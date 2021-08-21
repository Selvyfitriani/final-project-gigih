require "./models/comment"

describe Comment do
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
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                user_id = User.get_last_insert_id
                post_id = Post.get_last_insert_id

                comment = Comment.new(
                    user_id = user_id,
                    post_id = post_id,
                    text = "A new comment"  
                )

                expect(comment.valid?).to eq(true)
            end
        end
    end
end