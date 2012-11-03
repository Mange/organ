module EpisodeFile
  def self.pattern(name)
    liberal_name = Regexp.quote(name).gsub('\ ', '[ ._]')
    %r{#{liberal_name}.*#{NUMBER_PATTERN}}i
  end

  def season
    episode_data[:season].to_i
  end

  def episode
    episode_data[:episode].to_i
  end

  private
  NUMBER_PATTERN = /s(?<season>\d+)e(?<episode>\d+)/i

  def episode_data
    @episode_data ||= NUMBER_PATTERN.match(@name)
  end
end
