namespace :heroku do
  desc 'Deploy the production branch to heroku'
  task :deploy => :tag_release do
    sh 'heroku maintenance:on'
    sh 'git push heroku production:master'
    sh 'heroku rake db:migrate'
    sh 'heroku maintenance:off'
  end

  task :tag_release do
    release_number = "production/#{Time.now.gmtime.xmlschema.gsub(/\W/,'')}"
    sh "git tag -s #{release_number} -m \"Deployed #{release_number} to production on Heroku\" production"
    sh "git push origin production"
    sh "git push origin --tags"
  end

  namespace :db do
    desc "Load the current production database into local development database"
    task :pull do
      rm File.join(Rails.root, 'db', 'development.sqlite3')
      sh "heroku db:pull --confirm virtual-token"
    end
  end
end
