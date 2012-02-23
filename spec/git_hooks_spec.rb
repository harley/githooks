require File.expand_path('../../spec/spec_helper', __FILE__)
require 'tempfile'

describe GitHooks do
  describe ".append_with_PT_links_if_applicable" do
    it "must leave the file untouched if no link is file" do
      temp = Tempfile.new "temp"
      begin
        orig = "this message has not PT link in it"
        temp.write orig
        temp.rewind
        GitHooks.append_with_PT_links_if_applicable temp.path
        assert_equal temp.read, orig
      ensure
        temp.close
        temp.unlink
      end
    end

    it "must read the file and append PT links if applicable" do
      temp = Tempfile.new "temp"
      begin
        orig = "[Fix #123] see the PT story id in here?"
        temp.write orig
        temp.rewind
        GitHooks.append_with_PT_links_if_applicable temp.path
        assert_equal temp.read, "#{orig}\nhttps://www.pivotaltracker.com/story/show/123\n"
      ensure
        temp.close
        temp.unlink
      end
    end
  end

  describe ".get_story_ids" do
    it "must find one story if there is one" do
      msgs = ["[#1234567] first step at fixing things", "can also put at end [#1234567]"]
      msgs.each do |message|
        assert_equal GitHooks.get_story_ids(message), ["1234567"]
      end
    end
    it "must return empty if no story is found" do
      msgs = ["no story id here", "[not here either]", "nor here [#123"]
      msgs.each do |msg|
        assert_empty GitHooks.get_story_ids(msg)
      end
    end
    it "must find two stories if there are two" do
      message = "[#123 #124] Diverting power from warp drive to torpedoes."
      assert_equal GitHooks.get_story_ids(message), ["123", "124"]

    end
  end

  describe ".get_story_links" do
    it "must correctly return a list of links" do
      msgs = ["[#1234567] first step at fixing things", "can also put at end [#1234567]"]
      msgs.each do |msg|
        assert_equal GitHooks.get_story_links(msg), ["https://www.pivotaltracker.com/story/show/1234567"]
      end
    end
  end

  describe ".linkify" do
    it "must turn story id into links" do
      assert_equal GitHooks.linkify("12345"), "https://www.pivotaltracker.com/story/show/12345"
    end
  end
end
