require 'unicode/display_width'

class GitStars
  class ListFormatter < GitStars::Formatter
    HEADER_COLUMNS = %w(name language author stars description)
    DEFAULT_COLUMNS_SIZE = [40, 10, 10, 6, 20]

    def output(result)
      rule_columns_size(result)
      render_header
      render_body(result)
    end

    private

    def rule_columns_size(projects)
      @columns_size = DEFAULT_COLUMNS_SIZE.dup
      rule_max_column_size(projects, :name)
      rule_max_column_size(projects, :language)
      rule_max_column_size(projects, :author)
      rule_max_description_size
    end

    def render_header
      f = @columns_size
      fmt = "%-#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s %-#{f[4]}s"
      puts fmt % HEADER_COLUMNS.map(&:capitalize)
      puts fmt % @columns_size.map { |col| '-' * col }
    end

    def render_body(projects)
      f = @columns_size
      projects.each do |project|
        result = ''
        HEADER_COLUMNS[0..-2].each_with_index do |column, i|
          val = project.send(column)
          color = column_color(val, column)
          fmt = (val == val.to_i.to_s) ? "%#{f[i]}s " : "%-#{f[i]}s "
          formatted_val = fmt % val
          formatted_val = formatted_val.send(color) if color
          result << formatted_val
        end
        result << project.description.mb_slice(f.last)
        puts result
      end
    end

    def rule_max_column_size(projects, attr)
      index = HEADER_COLUMNS.index(attr.to_s)
      max_size = max_size_of(projects, attr)
      @columns_size[index] = max_size if max_size > @columns_size[index]
    end

    def max_size_of(projects, attr)
      projects.max_by { |project| project.send(attr).size }.send(attr).size
    end

    def rule_max_description_size
      terminal_width, _terminal_height = detect_terminal_size
      if terminal_width
        description_width = terminal_width - @columns_size[0..-2].inject(&:+) - (@columns_size.size - 1)
        @columns_size[-1] = description_width if description_width >= DEFAULT_COLUMNS_SIZE.last
      end
    end

    # https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
    def detect_terminal_size
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exists?('tput')
        [`tput cols`.to_i, `tput lines`.to_i]
      elsif STDIN.tty? && command_exists?('stty')
        `stty size`.scan(/\d+/).map {  |s| s.to_i }.reverse
      else
        nil
      end
    rescue
      nil
    end

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |d| File.exist? File.join(d, command) }
    end
  end
end
