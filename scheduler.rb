require 'docile'
require 'date'

Lecture = Struct.new(:index, :date, :title, :notes, :prep, :out, :due)
Section = Struct.new(:index, :date, :title)
Exam = Struct.new(:index, :date, :title)
Except = Struct.new(:index, :date, :title)
Schedule = Struct.new(:first, :last, :days, :except, :lines, :date)

Schedule.class_eval do
  def to_html
    map_line = lambda do |line|
      if line.is_a?(Section)
        return "<tr><th colspan='6' class='schedule-section'>#{line.title}</th></tr>"
      elsif line.is_a?(Lecture)
        date = line.date.strftime("%a %-d %b")
        return "<tr><th scope='row'>#{date}</th><td>#{line.title}</td><td>#{line.prep.join("; ")}</td><td>#{line.notes.join("; ")}</td><td>#{line.out.join("; ")}</td><td>#{line.due.join("; ")}</td></tr>"
      elsif line.is_a?(Exam)
        date = line.date.strftime("%a %-d %b")
        return "<tr><th scope='row'>#{date}</th><td colspan='5'>#{line.title}</td></tr>"
      elsif line.is_a?(Except)
        date = line.date.strftime("%a %-d %b")
        return "<tr class='no-class'><th scope='row'>#{date}</th><td colspan='5'>#{line.title}</td></tr>"
      else
        return ""
      end
    end

    lines = self.lines.compact
    lines = lines.sort_by { |a| [a.date, a.index] }
    lines = lines.map(&map_line)
    lines.join("\n")
  end

  def to_s
    map_line = lambda do |line|
      if line.is_a?(Section)
        return "Section #{line.title}"
      elsif line.is_a?(Lecture)
        date = line.date.strftime("%-d %b")
        return "Lecture #{date} #{line.title}"
      elsif line.is_a?(Exam)
        date = line.date.strftime("%-d %b")
        return "Except #{date} #{line.title}"
      elsif line.is_a?(Exam)
        date = line.date.strftime("%-d %b")
        return "Exam #{date} #{line.title}"
      else
        return line.to_s
      end
    end

    lines = self.lines.compact
    lines = lines.sort_by { |a| a.date }
    lines = lines.map(&map_line)
    lines.join("\n")
  end
end

class ScheduleBuilder
  def initialize
    @first = nil
    @last = nil
    @days = []
    @except = []
    @lines = []
    @curr = nil
    @index = 0
  end

  def first(text)
    v = Date.strptime(text, "%Y.%m.%d")
    @first = v
  end

  def last(text)
    v = Date.strptime(text, "%Y.%m.%d")
    @last = v
  end

  def set_date(v)
    @curr = v
  end

  def curr_date
    if @curr == nil
      @curr = @first - 1
    end
    return @curr
  end

  def next_index
    @index = @index + 1
    return @index - 1
  end

  def next_date
    if @curr == nil
      @curr = next_lecture(@first - 1)
    else
      @curr = next_lecture(@curr)
    end
    return @curr
  end

  def next_lecture(d)
    d = d.next
    while d <= @last
      if ! (@except.include?(d)) && (@days.include?(d.wday))
        return d
      end
      d = d.next
    end
    return nil
  end

  def day(v)
    h = Hash[ "M" => 1, "Mo" => 1, "Mon" => 1,
              "T" => 2, "Tu" => 2, "Tue" => 2,
              "W" => 3, "We" => 3, "Wed" => 3,
              "R" => 4, "Th" => 4, "Thu" => 4,
              "F" => 5, "Fr" => 5, "Fri" => 5,
              "S" => 6, "Sa" => 6, "Sat" => 6,
              "U" => 0, "Su" => 0, "Sun" => 0
            ]
    @days << h[v]
  end

  def except(text, title=nil)
    v = Date.strptime(text, "%Y.%m.%d")
    if @days.include?(v.wday)
      @except << v
      if title == nil
        title = "No class"
      end
      l = Except.new(next_index, v, title)
      if l.date != nil
        @lines << l
      end
    end
  end

  def build
    s = Schedule.new(@first, @last, @days, @except, @lines)
    return s
  end

  def lecture(title, &block)
    l = Docile.dsl_eval(LectureBuilder.new(self, title), &block).build
    if l.date != nil
      @lines << l
    end
  end

  def section(title, &block)
    l = Docile.dsl_eval(SectionBuilder.new(self, title), &block).build
    if l.date != nil
      @lines << l
    end
  end

  def exam(&block)
    l = Docile.dsl_eval(ExamBuilder.new(self), &block).build
    if l.date != nil
      @lines << l
    end
  end
end

class LectureBuilder
  def initialize(sched, title)
    @sched = sched
    @title = title
    @date = nil
    @notes = []
    @prep = []
    @out = []
    @due = []
  end

  def date(text)
    v = Date.strptime(text, "%Y.%m.%d")
    @date = v
  end

  def title(v)
    @title = v
  end

  def notes(v)
    @notes << v
  end

  def prep(v)
    @prep << v
  end

  def out(v)
    @out << v
  end

  def due(v)
    @due << v
  end

  def build
    if @date == nil
      @date = @sched.next_date
    else
      @sched.set_date(@date)
    end
    Lecture.new(@sched.next_index, @date, @title, @notes, @prep, @out, @due)
  end
end

class SectionBuilder
  def initialize(sched, title)
    @sched = sched
    @title = title
    @date = nil
  end

  def date(text)
    v = Date.strptime(text, "%Y.%m.%d")
    @date = v
  end

  def title(v)
    @title = v
  end

  def build
    if @date == nil
      @date = @sched.curr_date + 1
    end
    Section.new(@sched.next_index, @date, @title)
  end
end

class ExamBuilder
  def initialize(sched)
    @sched = sched
    @date = nil
    @title = nil
  end

  def date(text)
    v = Date.strptime(text, "%Y.%m.%d")
    @date = v
  end

  def title(v)
    @title = v
  end

  def build
    if @date == nil
      @date = @sched.next_date
    else
      @sched.set_date(@date)
    end
    Exam.new(@sched.next_index, @date, @title)
  end
end

def schedule(&block)
  Docile.dsl_eval(ScheduleBuilder.new, &block).build
end
