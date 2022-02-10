require 'base64'

module Solana
  class Tx
    SIGNATURE_LENGTH = 64
    PACKET_DATA_SIZE = 1280 - 40 - 8
    DEFAULT_SIGNATURE = Array.new(64, 0)

    attr_accessor :recent_blockhash, :fee_payer, :signatures, :instructions

    def initialize(recent_blockhash:nil, signatures:[] , instructions:[], fee_payer:nil)
      @recent_blockhash = recent_blockhash
      @signatures = signatures
      @instructions = instructions
      @fee_payer = fee_payer
    end


    def self.from(base64_string)
      bytes = Base64.decode64(base64_string).bytes
      signature_count = Utils.decode_length(bytes)
      signatures = signature_count.times.map do
        signature_bytes = bytes.slice!(0, SIGNATURE_LENGTH)
        Utils.bytes_to_base58(signature_bytes)
      end
      msg = Message.from(bytes)
      self.populate(msg, signatures)
    end

    def self.populate(message, signatures)
      tx = self.new
      tx.recent_blockhash = message.recent_blockhash
      tx.fee_payer = message.account_keys[0] if (message.header[:num_required_signatures] > 0)

      signatures.each_with_index do |signature, index|
        sig_pubkey_pair = {
          signature: (signature == Utils.bytes_to_base58(DEFAULT_SIGNATURE) ? null : Utils.base58_to_bytes(signature)),
          public_key: message.account_keys[index]
        }

        tx.signatures.push(sig_pubkey_pair)
      end

      message.instructions.each do |instruction|
        keys = instruction[:accounts].map do |account|
          pubkey = message.account_keys[account]
          {
            pubkey: pubkey,
            is_signer: !(tx.signatures.find{|el| el[:public_key] == pubkey}.nil?),
            is_writable: message.is_account_writable(account),
          }
        end

        tx.instructions.push(
          {
            keys: keys,
            program_id: message.account_keys[instruction[:program_id_index]],
            data: Utils.base58_to_bytes(instruction[:data]),
          })
      end
      tx
    end

    def serialize
      sign_data = serialize_message

      signature_count = Utils.encode_length(signatures.length)
      raise 'invalid length!' if signatures.length > 256
      
      wire_transaction = signature_count

      signatures.each do |signature|
        if signature
          signature_bytes = signature[:signature]
          raise 'signature is empty' unless (signature_bytes)
          raise 'signature has invalid length' unless (signature_bytes.length == 64)
          wire_transaction += signature_bytes
          raise "Transaction too large: #{wire_transaction.length} > #{PACKET_DATA_SIZE}" unless wire_transaction.length <= PACKET_DATA_SIZE
          wire_transaction
        end
      end

      wire_transaction += sign_data
      wire_transaction
    end

    def serialize_message
      compile.serialize
    end

    def compile
      message = compile_message
      signed_keys = message.account_keys.slice(0, message.header[:num_required_signatures])

      if signatures.length == signed_keys.length
        valid = signatures.each_with_index.all?{|pair, i| signed_keys[i] == pair[:public_key]}
        return message if valid
      end

      @signatures = signed_keys.map do |publicKey|
        {
          signature: nil,
          public_key: publicKey
        }
      end

      message
    end

    def compile_message
      raise 'Transaction recent_blockhash required' unless recent_blockhash

      puts 'No instructions provided' if instructions.length < 1

      if fee_payer
      elsif signatures.length > 0 && signatures[0][:public_key]
        @fee_payer = signatures[0][:public_key] if (signatures.length > 0 && signatures[0][:public_key])
      else
        raise('Transaction fee payer required')
      end

      instructions.each_with_index do |instruction, i|
        raise("Transaction instruction index #{i} has undefined program id") unless instruction[:program_id]
      end

      program_ids = []
      account_metas= []

      instructions.each do |instruction|
        account_metas += instruction[:keys]
        program_ids.push(instruction[:program_id]) unless program_ids.include?(instruction[:program_id])
      end

      # Append programID account metas
      program_ids.each do |programId|
        account_metas.push({
                            pubkey: programId,
                            is_signer: false,
                            is_writable: false,
                          })
      end

      
      # Sort. Prioritizing first by signer, then by writable
      account_metas.sort! do |x, y|
        check_signer = x[:is_signer] == y[:is_signer] ? nil : x[:is_signer] ? -1 : 1
        check_writable = x[:is_writable] == y[:is_writable] ? nil : (x[:is_writable] ? -1 : 1)
        (check_signer || check_writable) || 0
      end

      # Cull duplicate account metas
      unique_metas = []
      account_metas.each do |account_meta|
        pubkey_string = account_meta[:pubkey]
        unique_index = unique_metas.find_index{|x| x[:pubkey] == pubkey_string }
        if unique_index
          unique_metas[unique_index][:is_writable] = unique_metas[unique_index][:is_writable] || account_meta[:is_writable]
        else
          unique_metas.push(account_meta);
        end
      end

      # Move fee payer to the front
      fee_payer_index = unique_metas.find_index{|x| x[:pubkey] == fee_payer }

      if fee_payer_index
        payer_meta = unique_metas.delete_at(fee_payer_index)
        payer_meta[:is_signer] = true
        payer_meta[:is_writable] = true
        unique_metas.unshift(payer_meta)
      else
        unique_metas.unshift({
                              pubkey: fee_payer,
                              is_signer: true,
                              is_writable: true,
                            })
      end

      # Disallow unknown signers
      signatures.each do |signature|
        unique_index = unique_metas.find_index{|x| x[:pubkey] == signature[:public_key]}

        if unique_index
          unless unique_metas[unique_index][:is_signer]
            unique_metas[unique_index][:is_signer] = true
            # console.warn(
            #   'Transaction references a signature that is unnecessary, ' +
            #     'only the fee payer and instruction signer accounts should sign a transaction. ' +
            #     'This behavior is deprecated and will throw an error in the next major version release.',
            #   );
          end
        else
          raise "unknown signer: #{signature[:public_key]}"
        end
      end

      num_required_signatures = 0
      num_readonly_signed_accounts = 0
      num_readonly_unsigned_accounts = 0

      # Split out signing from non-signing keys and count header values
      signed_keys = []
      unsigned_keys = []
      unique_metas.each do |meta|
        if meta[:is_signer]
          signed_keys.push(meta[:pubkey])
          num_required_signatures += 1
          num_readonly_signed_accounts += 1 if (!meta[:is_writable])
        else
          unsigned_keys.push(meta[:pubkey])
          num_readonly_unsigned_accounts += 1 if (!meta[:is_writable])
        end
      end

      account_keys = signed_keys + unsigned_keys

      instructs = instructions.map do |instruction|
        {
          program_id_index: account_keys.index(instruction[:program_id]),
          accounts: instruction[:keys].map{|meta| account_keys.index(meta[:pubkey])},
          data: Utils.bytes_to_base58(instruction[:data])
        }
      end

      # instructions.each do |instruction|
      #   raise 'error' unless instruction[:program_id_index] >= 0
      #   instruction[:accounts].each{|keyIndex| raise 'error' unless keyIndex >= 0}
      # end

      Message.new(
        header: {
          num_required_signatures: num_required_signatures,
          num_readonly_signed_accounts:num_readonly_signed_accounts,
          num_readonly_unsigned_accounts:num_readonly_unsigned_accounts,
        },
        account_keys:account_keys, recent_blockhash:recent_blockhash, instructions:instructs
      )
    end

    def add(item)
      instructions.push(item)
    end

    def sign(keys)
      raise 'No signers' unless keys.any?

      keys = keys.uniq{|k| k.address }
      @signatures = keys.map do |key|
        {
          signature: nil,
          public_key: key.address
        }
      end

      message = compile_message
      partial_sign(message, keys)
      true
      # verify_signatures(message.serialize, true)
    end

    def partial_sign(message, keys)
      sign_data = message.serialize
      keys.each do |key|
        signature = key.sign(sign_data.pack('C*')).bytes
        add_signature(key.address, signature)
      end
    end

    def add_signature(pubkey,  signature)
      raise 'error' unless signature.length === 64
      index = signatures.find_index{|s| s[:public_key] == pubkey}
      raise "unknown signer: #{pubkey}" unless index

      @signatures[index][:signature] = signature
    end

    # def _verifySignatures(sign_data: Buffer, requireAllSignatures: boolean): boolean {
    #   for (const {signature, publicKey} of this.signatures) {
    #     if (signature === null) {
    #       if (requireAllSignatures) {
    #         return false;
    #       }
    #       } else {
    #         if (
    #           !nacl.sign.detached.verify(sign_data, signature, publicKey.toBuffer())
    #         ) {
    #           return false;
    #         }
    #         }
    #         }
    #         return true;
    #         }
    # end
  end
end