require "./models/comment"

describe Comment do
    before(:each) do
        "DELETE * FROM users"
        "DELETE * FROM posts"
    end

    describe '#valid?' do
        context 'when given valid attributes value' do
            it 'should return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A new comment"  
                )

                expect(comment.valid?).to eq(true)
            end
        end
    end
end