require 'rubygems'

def matchFileEnding file,fileEndings
	match = false
	fileEndings.each do |ending|
		
		endingRegex = /\.#{ending}\z/
		
		if file.match(endingRegex)
			match = true
			break
		end
	end 
	match
end

def countLinesInFile file

	f = File.open file,"r"
	count = f.readlines.count

	puts "File #{file} has #{count} line#{count != 1 ? "s":""}"
	count
end

def countLines dirPath,fileEndings 

	pathcomps = dirPath.split "/"

	excludedDirs = [".svn",".git"]

	excludedDirs.each do |dir|
		if dir == pathcomps[-1]
			return 0
		end
	end



	if dirPath[-1] == "\n"
		dirPath.chomp!
	end

	subItemIO = IO.popen "ls -al #{dirPath}"
	subItemArray = subItemIO.inject([]) { |acc,item| acc << item }
	lineCount = 0
	items = []
	for i in 2..subItemArray.count-1
			items << subItemArray[i]
	end	

	items.each do |item|
		subItems = item.split		
		dirString = subItems[0]
		itemName = subItems[-1]

		if itemName != "." && itemName != ".."
			if dirString.match /d.*/
				dir_path = "#{dirPath}/#{subItems[-1]}"
				lineCount += countLines dir_path,fileEndings
			elsif matchFileEnding itemName,fileEndings
				dir_path = "#{dirPath}/#{itemName}"
				fileLineCount = countLinesInFile dir_path
				lineCount += fileLineCount
				
			end
		end
	end
	lineCount
end





rootDirPath = ARGV[0]
puts "rootDirPath is #{rootDirPath}"

if rootDirPath 
	lines = countLines rootDirPath,["m","h","c","mm"]
	puts "There were #{lines} lines"
else
	puts "No directory supplied"
end
