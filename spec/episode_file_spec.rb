# encoding: UTF-8
require 'spec_helper'
require 'episode_file'
require 'matching_file'

describe EpisodeFile do
  describe ".pattern(name)" do
    # Basic matching
    describe 'for "foobar"' do
      subject { described_class.pattern "foobar" }

      it { should_not =~ "foobar" }
      it { should =~ "foobar.excluzive.s01e01.wow.avi" }
      it { should =~ "foobar S00E991" }
    end

    # Spaces are not literal
    describe 'for "south park"' do
      subject { described_class.pattern "south park" }

      it { should_not =~ "south park" }
      it { should =~ "South Park.excluzive.s01e01.wow.avi" }
      it { should =~ "south.park.excluzive.s01e01.wow.avi" }
      it { should =~ "junk.in.front.south_park.excluzive.s01e01.wow.avi" }
      it { should =~ "SoUTh pARk S00E991" }
    end

    # Pattern string is quoted
    describe 'for ".*"' do
      subject { described_class.pattern ".*" }

      it { should =~ ".* s01e01" }
      it { should_not =~ "whatever s01e01" }
    end
  end

  describe "decorating a MatchingFile" do
    def decorated_matching_file(full_path)
      file = path(full_path).create_file
      matching_file = MatchingFile.new file.directory, file.filename
      matching_file.extend(EpisodeFile)
    end

    it "has a season number" do
      matching_file = decorated_matching_file "/tmp/lustmord s04e087"
      matching_file.season.should == 4
    end

    it "has a episode number" do
      matching_file = decorated_matching_file "/tmp/lustmord s04e097"
      matching_file.episode.should == 97
    end
  end
end
