require './models/attachment'

describe Attachment do
  describe '#valid?' do
    context 'when given valid input' do
      it 'should return true' do
        attachment = Attachment.new('filename.png', 'image/png', 1)

        expect(attachment.valid?).to eq(true)
      end
    end

    context 'when given post and comment id simultaneously' do
      it 'should return false' do
        attachment = Attachment.new('filename.png', 'image/png', 1, 1)

        expect(attachment.valid?).to eq(false)
      end
    end
  end
end
