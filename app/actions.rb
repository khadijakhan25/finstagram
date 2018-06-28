helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end
  
get '/' do
  @posts = FinstagramPost.order(created_at: :desc)
  erb(:index) 
end

get '/signup' do
  @user=User.new
  erb(:signup)
end

post '/signup' do
 email=params[:email]
 avatar_url=params[:avatar_url]
 username=params[:username]
 password=params[:password]
 @user=User.new({email: email,avatar_url: avatar_url,username: username,password: password})
 
 if @user.save
  redirect to('/login')
 else
  erb(:signup)
 end
end

get '/login' do
  erb(:login)
end

post '/login' do
  username=params[:username]
  password=params[:password]
  
  user=User.find_by(username: username)
  
  if user && user.password == password
    session[:user_id]=user.id
    redirect to('/')
  else
    @error_message= "Login failed."
    erb(:login)
  end

end

get '/logout' do
  session[:user_id]=nil
  redirect to('/')
end

get '/posts/new' do
  @post=FinstagramPost.new
  erb(:"posts/new")
end

post '/posts'do
  photo_url=params[:photo_url]
  @post= FinstagramPost.new({ photo_url:photo_url,user_id: current_user.id})
  
  if @post.save
    redirect(to('/'))
  else
   erb(:"posts/new")
  end
end
 get '/posts/:id' do
  @post=FinstagramPost.find(params[:id])
  erb(:"posts/show")
 end
 
post '/comments' do
  text=params[:text]
  finstagram_post_id=params[:finstagram_post_id]
  
  comment=Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })
  
  comment.save
   redirect(back)
end

post '/likes' do
  finstagram_post_id=params[:finstagram_post_id]
  
  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id})
  like.save
  
   redirect(back)
 end
 
 delete '/likes/:id' do
   like=Like.find(params[:id])
   like.destroy
   redirect(back)
end
