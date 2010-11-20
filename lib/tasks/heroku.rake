namespace :heroku do
  desc 'Deploy the production branch to heroku'
  task :deploy => :tag_release do
    sh 'git push heroku production:master'
  end

  task :tag_release do
    release_number = "production/#{Time.now.gmtime.xmlschema.gsub(/\W/,'')}"
    sh "git tag -s #{release_number} -m \"Deployed #{release_number} to production on Heroku\" production"
    sh "git push origin production"
    sh "git push origin --tags"
  end
end
