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

        context 'when initialized with invalid user id' do
            it 'should return false' do
                post = Post.new(
                    user_id = "a",
                    text = "A new post",
                    time = "10-08-2021"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with too long text' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "a"*1001,
                    time = "10-08-2021"
                )

                expect(post.valid?).to eq(false)
            end
        end
    end
end