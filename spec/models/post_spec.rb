require "./models/post"

describe Post do
    describe '#valid?' do
        context 'when initialized with valid mandatory attributes value' do
            it 'should return true' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(true)
            end
        end

        context 'when initialized with invalid user id' do
            it 'should return false' do
                post = Post.new(
                    user_id = "a",
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with too long text' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "a"*1001,
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end
    end
end