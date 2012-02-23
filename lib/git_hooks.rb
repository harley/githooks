module GitHooks
  # detect for story ids in commit message and append the message with links to the mentioned stories
  # using message syntax explained here https://www.pivotaltracker.com/help/api?version=v3#scm_post_commit_message_syntax
  def self.append_with_PT_links_if_applicable(filename)
    message = File.read filename
    unless (story_links = get_story_links(message)).empty?
      File.open(filename, 'a') do |f|
        f.puts
        f.puts story_links*"\n"
      end
    end
  end

  def self.get_story_ids(message)
    story_ids = []
    message.each_line do |line|
      next if line =~ /^#/ # skip comments
      line.scan(/\[[^#]*((#\d+\s*)+)\]/) do |m|
        ids = m[0].split /\s+/
        ids.each do |id|
          id.slice!(0) if id =~ /^#/
          story_ids << id
        end
      end
    end
    story_ids
  end

  def self.get_story_links(message)
    story_ids = get_story_ids message
    story_links = story_ids.map {|id| linkify(id) }
  end

  def self.linkify(story_id)
    "https://www.pivotaltracker.com/story/show/#{story_id}"
  end
end
