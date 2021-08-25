require './models/attachment'

describe Attachment do
  describe '#valid?' do
    context 'when given valid input' do
      it 'should return true' do
        attachment = Attachment.new('filename.png', 'image/png', 1)

        expect(attachment.valid?).to eq(true)
      end
    end
  end
end
