load 'scheduler.rb'

s = schedule do
  day   'Mo'
  day   'We'

  first '2015.02.16'
  last  '2015.05.29'

  except '2015.03.19', '<i>No class: San Giuseppe</i>'
  except '2015.04.03', '<i>No class: Pasqua</i>'
  except '2015.04.04', '<i>No class: Pasqua</i>'
  except '2015.04.05', '<i>No class: Pasqua</i>'
  except '2015.04.06', '<i>No class: Pasqua</i>'
  except '2015.04.07', '<i>No class: Pasqua</i>'
  except '2015.04.08', '<i>No class: Pasqua</i>'
  except '2015.04.09', '<i>No class: Pasqua</i>'
  except '2015.04.10', '<i>No class: Pasqua</i>'
  except '2015.04.11', '<i>No class: Pasqua</i>'
  except '2015.04.12', '<i>No class: Pasqua</i>'
  except '2015.05.01', '<i>No class: Festa dei lavoratori</i>'
  except '2015.05.14', '<i>No class: Ascensione</i>'
  except '2015.05.25', '<i>No class: Pentecoste</i>'

  section "Introduction" do
  end

  lecture "Introduction" do
  end

  section "Functional programming" do
  end

  lecture "Haskell crash course" do
    prep '<a href="http://learnyouahaskell.com/chapters">Learn You a Haskell</a> Ch. 1&ndash;3'
  end

  lecture "Recursion, datatypes, and pattern matching" do
    prep '<a href="http://learnyouahaskell.com/chapters">Learn You a Haskell</a> Ch. 4&ndash;6, 8'
  end

  lecture "Higher-order functions" do
  end

  lecture "Advanced functional programming" do
  end

  lecture "Testing and debugging Haskell, QuickCheck" do
  end

  lecture "Functors, applicatives, monads" do
  end

  lecture "Bind, state monad" do
  end

  section "Parsing" do
  end

  lecture "Recursive-descent parsing" do
  end

  lecture "Parser combinators" do
  end

  lecture "Parser combinators, Parsec" do
    out "Write a parser for JavaScript expressions"
  end

  lecture "Parser generators, Alex and Happy" do
  end

  section "Interpreters" do
  end

  lecture "Interpreters" do
    out "Write an interpreter for JavaScript expressions"
  end

  lecture "Operational semantics and interpreters" do
  end

  lecture "Functions, scope, control flow" do
    out "Extend interpreter with functions and closures"
  end

  exam do
     date '2015.04.15'
     title 'Midterm Exam'
  end

  section "Compilers" do
  end

  lecture "Compilers 101" do
  end

  lecture "Static typing and typing rules" do
    out "Write a type checker"
  end

  lecture "Static semantics" do
  end

  lecture "Closure conversion" do
    out "Closure conversion"
  end

  lecture "Objects" do
  end

  lecture "Intermediate representations" do
  end

  lecture "Code generation" do
  end

  lecture "x86 or LLVM or C" do
  end

  lecture "Register allocation" do
  end

  lecture "Garbage collection" do
    out "Write a mark/sweep garbage collector"
  end

  lecture "TBD" do
  end
end

puts s.to_html
