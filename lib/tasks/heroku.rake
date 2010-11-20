namespace :heroku do
  desc 'Deploy the production branch to heroku'
  task :deploy do
    sh 'git push heroku production:master'
  end
end
