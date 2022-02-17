RSpec.describe Solana::Tx do

  describe "System Program" do
    let(:tx64_string) {"AQj+cn9lBhtH8flFlhsAqUNPnyAWDr8tgQTeYNORnuh3f2rW/W//KxZPraC6lkreY1fxjHWzDyyRRrpJZ+wrrAcBAAEDMAXAtmtiOflyZ1eWycGIy+hgy8fbZAc+UBNivTk47FM5C8lV2z57nGGebsVespcEZA9OV/QeMYWk9b//Fexw8gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1jxN97rX5yOItJL6i6WeKASMm3op2UY9L/UQzdUDSJwBAgIAAQwCAAAAAMqaOwAAAAA="}
    let(:secret_key) { [44, 98, 215, 237, 34, 123, 89, 247, 206, 196, 165, 5, 232, 42, 79, 158, 27, 20, 165, 137, 124, 155, 216, 126, 167, 178, 46, 57, 164, 181, 156, 43].pack('C*') }
    let(:from_key) { Solana::Key.new(secret_key) }
    let(:to_pubkey) { '3wh7S43AJW5FyYnJUFbhn7hBvSSfuQbPozmf1xMohWiX' }
    let(:blockhash) { 'FRHahRJ2Qy1smaQs8caFE4ebTjPK53kGB7UTi57MKhS3' }

    let(:new_tx_bytes) { [
      1, 19, 216, 56, 242, 247, 255, 115, 161, 93, 189, 203,
      79, 96, 102, 10, 187, 113, 108, 196, 131, 169, 189,
      106, 243, 195, 198, 254, 54, 152, 179, 89, 40, 116,
      26, 155, 115, 133, 197, 243, 176, 89, 49, 41, 115,
      173, 254, 156, 136, 121, 239, 159, 51, 190, 10, 70, 42,
      182, 136, 104, 202, 11, 32, 92, 13, 1, 0, 1, 3, 194, 229,
      83, 147, 230, 126, 232, 164, 189, 237, 156, 139, 64, 11, 78,
      209, 56, 197, 47, 82, 188, 124, 189, 47, 49, 220, 9, 37, 136,
      204, 100, 93, 43, 186, 23, 80, 208, 22, 89, 87, 181, 171, 112,
      128, 84, 20, 104, 202, 79, 55, 8, 156, 181, 154, 225, 4, 160, 173,
      235, 208, 206, 88, 15, 220, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 214, 60,
      77, 247, 186, 215, 231, 35, 136, 180, 146, 250, 139, 165, 158, 40,
      4, 140, 155, 122, 41, 217, 70, 61, 47, 245, 16, 205, 213, 3, 72, 156,
      1, 2, 2, 0, 1, 12, 2, 0, 0, 0, 232, 3, 0, 0, 0, 0, 0, 0
    ]}

    describe 'initialize' do
      it "creates empty tx" do
        expect(Solana::Tx.new).not_to be nil
      end
    end

    describe 'from' do
      it "decodes base64 string" do
        expect(Solana::Tx.from(tx64_string)).not_to be nil
      end
    end

    describe 'serialize' do
      it "serialize tx to exact value provided from" do
        tx =  Solana::Tx.from(tx64_string)
        serialize = tx.serialize
        expect(serialize).to eq(Base64.decode64(tx64_string).bytes)
      end

      it "serializes new transfer tx" do
        tx =  Solana::Tx.new
        instruct = Solana::Program::System.transfer_instruction(from_pubkey: from_key.address, to_pubkey: to_pubkey, lamports: 1000)
        tx.add(instruct)
        tx.recent_blockhash = blockhash
        tx.fee_payer = from_key.address
        tx.sign([from_key])
        expect(tx.serialize).to eq(new_tx_bytes)
      end

      # it "serializes new transfer tx" do
      #   tx =  Solana::Tx.new
      #   instruct = Solana::SystemProgram.transfer(from_pubkey: from_key.address, to_pubkey: to_pubkey, lamports: 1000)
      #   tx.add(instruct)
      #   tx.recent_blockhash = blockhash
      #   tx.fee_payer = from_key.address
      #   tx.sign([from_key])
      #   expect(tx.serialize).to eq(new_tx_bytes)
      # end
    end
  end

  describe "Token Program" do
    let(:tx64_string) {"AV6kMM0qdPJ2Ykt/K7Csr5QtJ0iggH4cNn/zXPN/pkYgZ1euuRNNDFgv5QjOIV2qY0WiUH9XusuAVpwnTze5FwsBAAIFmCNKPiDK2yPgpoqIES4kEbn2kswPnkTXZMwJ/fEPMdQfB9hKFnmN+GBwBoKXnSf7K4SOqaFQf87qBd0wPoyj/I5j2HKCyd2lWge9vikHMtZQHP6DX7PUIt46l7mRX/BP+H1b2nth8GQDYuXTxPwEURWwqaG/t1IiPIIn/bs9dJ4G3fbh12Whk9nL4UbO63msHLSF7V9bN5E6jPWFfv8AqdhZ/0ummp1odnYmXeWkSGYqm5Yh++bn4TqrGWyb/iSzAQQEAQMCAAoMAJQ1dwAAAAAJ"}
    let(:secret_key) { [71, 149, 27, 82, 211, 169, 227, 152, 131, 245, 38, 216, 54, 141, 104, 145, 122, 22, 92, 136, 109, 192, 7, 243, 77, 67, 30, 22, 215, 224, 223, 147].pack('C*') }
    let(:from_key) { Solana::Key.new(secret_key) }
    let(:program_params) { {from_pubkey: from_key.address, from_token_account_pubkey: '368aSxiAESiQ5B33x2AwqE3RP64HYS7Tv2VjEsVjS1Ns',to_token_account_pubkey: 'AaqCRXYKhebaRSC9k4Y1bb3Fniko6BJ4dQ4vDDAhk6N2',token_pubkey: 'HizyfeSmxUSvER7NJuY4yA9YpG2qwUFEvk6Eby7CzTMP',amount: 2000000000,decimals: 9} }
    let(:blockhash) { 'FZYf6GdoJRFnh1cXEooiaY2W4kSmXzWjYN7QXSxCUVYv' }

    describe 'from' do
      it "decodes base64 string" do
        expect(Solana::Tx.from(tx64_string)).not_to be nil
      end
    end

    describe 'serialize' do
      it "serialize tx to exact value provided from" do
        tx =  Solana::Tx.from(tx64_string)
        serialize = tx.serialize
        # puts serialize.to_s
        # puts Base64.decode64(tx64_string).bytes.to_s
        expect(serialize).to eq(Base64.decode64(tx64_string).bytes)
      end

      it "serializes new transfer tx" do
        tx =  Solana::Tx.new
        instruct = Solana::Program::Token.transfer_checked_instruction(program_params)
        tx.add(instruct)
        tx.recent_blockhash = blockhash
        tx.fee_payer = from_key.address
        tx.sign([from_key])
        # expect(tx.signatures).to eq(tx2.signatures)
        expect(tx.serialize).to eq(Base64.decode64(tx64_string).bytes)
      end

      # it "serializes new transfer tx" do
      #   tx =  Solana::Tx.new
      #   instruct = Solana::SystemProgram.transfer(from_pubkey: from_key.address, to_pubkey: to_pubkey, lamports: 1000)
      #   tx.add(instruct)
      #   tx.recent_blockhash = blockhash
      #   tx.fee_payer = from_key.address
      #   tx.sign([from_key])
      #   expect(tx.serialize).to eq(new_tx_bytes)
      # end
    end
  end
end
