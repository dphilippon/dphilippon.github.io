require 'yaml'
require 'uri'
# use Jekyll configuration file
CONFIG = YAML.load_file("_config.yml")
URL_LAYOUT_DEFAULT = "../_layouts/default.html"
URL_MENU_FILE = "./WebsiteTreeStructure.txt"
task default: :build_dev


#-----------------------------------------
#                TOOLS
#-----------------------------------------
def check_configuration
  if CONFIG['wikiToJekyll'].nil? or CONFIG['wikiToJekyll'].empty?
    raise "Please set your configuration in _config.yml. See the readme."
  end
end
def build_jekyll
  system 'jekyll build'
end

def deploy
    puts "deploying"
    open(".gitignore", 'w') do |gitPage|
        gitPage.puts "vendor/*"
    end
    system 'git config user.name "Travis CI"'
    system 'git config user.email "damien.philippon.dev@gmail.com"'
    system 'git config user.password "4SSpas6B"'
    system "git add -A"
    message = "Site wiki update #{Time.now.utc}"
    puts "\n## :Committing => #{message}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing website"
    system "git push #{g('deploy_remote')} #{g('deploy_branch')}"
    puts "\n## Github Pages deploy complete"
end

def count_em(string, substring)
  string.scan(/(?=#{substring})/).count
end
def g(key)
  CONFIG['wikiToJekyll'][ key ]
end

def get_wiki_repository_url
  
  derived_url = ':https =>//github.com/' + g('user_name') + '/' + g('repository_name') + '.wiki.git'
  
  url = g('wiki_repository_url') || derived_url
  
end

def update_wiki_submodule
  cd g('wiki_source') do
    pullCommand = 'git pull origin master'
    puts "Updating wiki submodule"
    output = `#{pullCommand}`

    if output.include? 'Already up-to-date'
      abort("No update necessary") # exit
    end
  end
end
def wikibuildfunction
  clean_wiki_folders
  copy_wiki_pages
  build_jekyll
end

#-----------------------------------------
#     Clean the destination folder
#-----------------------------------------
def clean_wiki_folders
  puts "Trying to clean the wiki"
  if File.exist?(g('wiki_dest'))
    puts "Removing Folder "+g('wiki_dest')
    removeFolder("")    
  end
  puts "Creating Folder "+g('wiki_dest')
  FileUtils.mkdir(g('wiki_dest'))
end

def removeFolder(folder)
  puts "Inside "+folder
  Dir.glob(File.join("#{g('wiki_dest')}",folder,"/*.md")) do |wikiPage|
    puts "Removing Page : "+wikiPage
    FileUtils.rm_rf(wikiPage)
  end
  FileUtils.rm_rf(File.join("#{g('wiki_dest')}",folder))
  puts "Removing Folder : "+folder
end


#-----------------------------------------
#    Copy the wiki pages and resources
#-----------------------------------------
def copy_wiki_pages
  puts "--------------------FINDING PAGES--------------------"
  findPages("")
  puts "--------------------COPYING RESOURCES--------------------"
  copyResources()
  puts "--------------------GENERATING MENU--------------------"
  defineLayoutMenu()
  puts "Copying Home to Index"
  FileUtils.cp(File.join("#{g('wiki_source')}","Home.md"),File.join("#{g('wiki_source')}","../index-2.md"))
end
def copyResources()
  folderResources = "resources"
  findResources(folderResources)
end
def findResources(folder)
  puts "Looking for resources in "+folder
  FileUtils.mkdir(File.join("#{g('wiki_dest')}",folder))
  subdir_list = Dir.entries(File.join("#{g('wiki_source')}",folder)).select {|entry| File.directory? File.join("#{g('wiki_source')}",folder,entry) and !(entry =='.'||entry =='.git' || entry == '..') }
  subdir_list.each do |subfolder|
    findResources(File.join(folder,subfolder))
  end
  Dir.glob(File.join("#{g('wiki_source')}",folder,"[A-Za-z]*.*")) do |aResource|
    puts "Copying Resource : "+aResource+" to "+File.join("#{g('wiki_dest')}",folder,File.basename(aResource))
    FileUtils.cp(aResource,File.join("#{g('wiki_dest')}",folder,File.basename(aResource)))
  end
end
def findPages(folder)
  puts "Looking for pages in "+folder
  subdir_list = Dir.entries(File.join("#{g('wiki_source')}",folder)).select {|entry| File.directory? File.join("#{g('wiki_source')}",folder,entry) and !(entry =='.'||entry =='.git' || entry == '..' || entry =="resources") }
  subdir_list.each do |subfolder|
    findPages(File.join(folder,subfolder))
  end
  Dir.glob(File.join("#{g('wiki_source')}",folder,"[A-Za-z]*.*")) do |aFile|
    wikiPageFileName = File.basename(aFile).gsub(" ","-")
    wikiPagePath     = File.join("#{g('wiki_dest')}", wikiPageFileName)
    puts "Copying Page :  "+aFile+" to "+wikiPagePath
    if(File.extname(aFile)==".md")
      # remove extension
      wikiPageName    = wikiPageFileName.sub(/.[^.]+\z/,'')
      wikiPageTitle = File.basename(wikiPageName)
      File.foreach(aFile) do |line|
        if(line.include? "#")and(line[0]=="#")
          wikiPageTitle = line.gsub("\#","")
          wikiPageTitle = wikiPageTitle.gsub("\n","")
          if(wikiPageTitle[0]!=" ")
            wikiPageTitle=" "+wikiPageTitle
          end
          break
        end
      end 
      fileContent      = File.read(aFile)
      folderString = File.join("#{g('wiki_dest')}",folder)
      # write the new file with yaml front matter
      open(wikiPagePath, 'w') do |newWikiPage|
        newWikiPage.puts "---"
        newWikiPage.puts "layout: default"
        newWikiPage.puts "title:#{wikiPageTitle}"
        # used to transform links
        newWikiPage.puts "wikiPageName: #{wikiPageName}"
        newWikiPage.puts "wikiPagePath: #{wikiPagePath}"
        # used to generate a wiki specific menu. see readme
        newWikiPage.puts "---"
        newWikiPage.puts ""
        newWikiPage.puts fileContent
      end
    else
      FileUtils.cp(aFile,wikiPagePath)
    end
  end
end

#-----------------------------------------
#      Creation of the Menu Layout
#-----------------------------------------
def defineLayoutMenu
  puts "Removing Old Menu"
  rm_rf File.join("#{g('wiki_source')}",URL_LAYOUT_DEFAULT)
  puts "Generating New Menu"
  open(File.join("#{g('wiki_source')}",URL_LAYOUT_DEFAULT), 'w') do |newLayout|
    newLayout.puts '
    <!doctype html><html lang="en"><head><meta charset="utf-8"><title>{{ page.title }}</title></head>
    <body>
    {% include style.html %}
      <div id="left">'
    oldUnder=-1
    File.foreach(File.join("#{g('wiki_source')}",URL_MENU_FILE)) do |line|
      currentUnder = count_em(line,"-")
      #Fils du courant
      if(currentUnder>oldUnder)
        if(oldUnder==-1)
          newLayout.puts '
		<ul class="mcd-menu"><li><a href="/">Home</a></li><li><a href="/">Discussions</a></li>'
        else
          newLayout.puts "<ul class='sub'>"
        end
        oldUnder=currentUnder
      else
        #Père du courant
        if(currentUnder<oldUnder)
          loop do 
            newLayout.puts "</ul>"
            oldUnder = oldUnder -1
            break if oldUnder==currentUnder
          end
        end
      end
      fileWithName = File.join("#{g('wiki_dest')}","/"+line.gsub("-","")).gsub("\n","")
      title=line
      if(File.exists?(fileWithName+".md"))
        File.foreach(fileWithName+".md") do |row|
          if(row.include? "title:")
            title = row
            break
          end
        end 
        newLayout.puts "<li><a href='/"+fileWithName+"'>"+title.gsub("title: ","")+"</a>"+"</li>"
      else
        newLayout.puts "<li>"+title.gsub("-","")+"</li>"
      end
    end
    newLayout.puts '</ul></ul></div><div id="right">
<h3>Facebook Activities</h3>
<ul id="fbquotes">
</ul>
<h3>Commit Activities</h3>
<ul id="commitquotes">
</ul>
<h3>Issue Activities</h3>
<ul id="issuequotes">
</ul>
<h3>Gama Platform Users Activities</h3>
<ul id="googleusersquotes">
</ul>
</div><div id="content">{{ content }}</div></body></html>'
  end
  
 
end

#-----------------------------------------
#               Tasks
#-----------------------------------------
#Function to synchronise the git
task :wiki do |t|
    puts "Checking Configuration"
    check_configuration
    #puts "Updating Submodule"
    #update_wiki_submodule
    puts "Executing Wikibuild"
    wikibuildfunction
    puts "Deploying"
    deploy
    puts "Wiki synchronisation success !"
end
#Function to add the git of the wiki to a folder
task :wikisub do |t|

  puts "adding wiki as submodule"
  check_configuration
  wiki_repository = get_wiki_repository_url
  command = 'git submodule add ' + wiki_repository + ' ' + g('wiki_source')
  command += ' && git submodule init'
  command += ' && git submodule update'
  puts 'command : ' + command

  output = `#{command}`

  if output.include? 'failed'
    abort("submodule add failed : verify you configuration and that your wiki is public") # exit
  end

  puts "wiki submodule OK"
end



#Function to build the wiki
task :wikibuild do |t|
  puts ':rake =>wikibuild'
  wikibuildfunction
end



task :prod do |t|
  puts "Building with production parameters"
  sh 'jekyll build'
end

task :deploy do |t|
    deploy
end