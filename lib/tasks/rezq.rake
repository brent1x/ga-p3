namespace :rezq do
  desc "TODO"
  task run_crawler: :environment do
    Crawler.crawler_check
  end

end
