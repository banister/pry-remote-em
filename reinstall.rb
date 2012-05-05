system("gem uninstall pry-remote-em") rescue nil

system("gem build pry-remote-em.gemspec")

system("gem install pry-remote-em*.gem")
