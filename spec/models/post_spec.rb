require "./models/post"

describe Post do
    describe '#valid?' do
        context 'when initialized with valid mandatory attributes value' do
            it 'should return true' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    time = "10-08-2021"
                )

                expect(post.valid?).to eq(true)
            end
        end
    end
end