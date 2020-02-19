require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |paragraph, index|
      "<p id= paragraph#{index}>#{paragraph}</p>"
    end.join
  end

  def highlight(text, phrase)
    text.gsub(phrase, "<strong>#{phrase}</strong>")
  end
end


get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb(:home)
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect("/") unless (1..(@contents.size)).cover?(number)

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")
  
  erb(:chapter)
end

not_found do
  redirect("/")
end

# # Calls the block for each chapter, passing that chapter's number, name, and
# contents.
def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield(number, name, contents)
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name and :number keys,
# and :paragraph keys. The value for :paragraph will be a hash of paragraph indexes
# and that paragraph's text.
def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
      results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb(:search)

end


