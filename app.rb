require 'sinatra'
require 'shotgun'
require 'pg'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

class Task
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get('/') do
	@tasks = Task.all :order => :id.desc
	@title = "All Tasks"
	erb :index
end

post('/') do
	task = Task.new
	task.content = params[:content]
	task.created_at = Time.now
	task.updated_at = Time.now
	task.save
	redirect '/'
end

get('/:id') do
	@task = Task.get params[:id]
	@title = "Edit note ##{params[:id]}"
	erb :edit
end

put ('/:id') do
  task = Task.get params[:id]
  task.content = params[:content]
  task.updated_at = Time.now
  task.save
  redirect '/'
end

delete '/:id' do
  task = Task.get params[:id]
  task.destroy
  redirect '/'
end

get ('/:id/complete') do
  task = Task.get params[:id]
  task.complete = task.complete ? 0 : 1 # flip it
  task.updated_at = Time.now
  task.save
  redirect '/'
end
