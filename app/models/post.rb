class Post < ActiveRecord::Base
    validates_presence_of,:photo_url, :user