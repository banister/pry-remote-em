#!/Users/john/.rvm/rubies/ruby-1.9.3-p0/bin/ruby

system("gem uninstall pry-remote-em") rescue nil

system("gem build pry-remote-em.gemspec")

system("gem install pry-remote-em*.gem")
