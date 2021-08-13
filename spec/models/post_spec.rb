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

        context 'when initialized with invalid format datetime' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05a"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with out of range datetime' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-13-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when intialized with out of of range time' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-12-31 24:00:05"
                )

                expect(post.valid?).to eq(false)
            end
        end
    end

    describe '#generate_hashtags' do
        context 'when text has no hashtags' do
            it 'should return empty list' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-12-31 24:00:05"
                )
            
                hashtags = post.generate_hashtags()
                expected_hashtags = []
                expect(hashtags).to eq(expected_hashtags)
            end
        end 

        context 'when text has 1 hashtag' do
            it 'should return array with the hashtag' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post #ini_hashtag",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = ["#ini_hashtag"]
                expect(hashtags).to eq(expected_hashtags)
            end
        end

        context 'when text has 1 hashtag in the middle' do
            it 'should return array with the hashtag' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post #middle_hashtag in my account",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = ["#middle_hashtag"]
                expect(hashtags).to eq(expected_hashtags)
            end
        end

        context 'when text contain multiple instances of a hashtag' do
            it 'should return only one hashtags' do
                post = Post.new(
                    user_id = 1,
                    text = "#hashtag #hashtaG #hasHtag",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = ["#hashtag"]
                expect(hashtags).to eq(expected_hashtags)
            end
        end
    end

    
end