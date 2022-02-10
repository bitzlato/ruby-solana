RSpec.describe Solana::Message do
  let(:bytes) {[1, 0, 1, 3, 48, 5, 192, 182, 107, 98, 57, 249, 114, 103, 87, 150, 201, 193, 136, 203, 232, 96, 203, 199, 219, 100, 7, 62, 80, 19, 98, 189, 57, 56, 236, 83, 57, 11, 201, 85, 219, 62, 123, 156, 97, 158, 110, 197, 94, 178, 151, 4, 100, 15, 78, 87, 244, 30, 49, 133, 164, 245, 191, 255, 21, 236, 112, 242, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 214, 60, 77, 247, 186, 215, 231, 35, 136, 180, 146, 250, 139, 165, 158, 40, 4, 140, 155, 122, 41, 217, 70, 61, 47, 245, 16, 205, 213, 3, 72, 156, 1, 2, 2, 0, 1, 12, 2, 0, 0, 0, 0, 202, 154, 59, 0, 0, 0, 0]}

  describe "from" do
    it "decodes bytes" do
      expect(Solana::Message.from(bytes).class).to be Solana::Message
    end
  end

  describe "serialize" do
    it "serialized bytes equal incoming bytes" do
      message = Solana::Message.from(bytes)
      expect(message.serialize).to eq(bytes)
    end
  end
end
