# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'random_data'

#create posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end
posts = Post.all

#create comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

Post.find_or_create_by(title: "I'm a unique title", body: "This unique body goes with the unique title")

#Comment.create_with(body: "This is a unique comment").find_or_create_by(title: "I'm a unique title")
Comment.find_or_create_by(body: 'This is a unique comment', post_id: 101)

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
