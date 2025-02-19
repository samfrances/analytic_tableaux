defmodule ParserTest do
  use ExUnit.Case

  describe "should parse sequent with no premise and atomic conclusion:" do
    table = [
      {"|- q", [:q]},
      {"|- p", [:p]}
    ]

    for {sequent, expected_result} <- table do
      test sequent do
        assert AnalyticTableaux.Parser.parse(unquote(sequent)) == unquote(expected_result)
      end
    end
  end

  test "parses sequent with single atomic premise and conclusion: p |- q" do
    assert AnalyticTableaux.Parser.parse("p |- q") == [:p, :q]
  end

  test "parses sequent with multiple atomic premises and conclusions: p,r |- q" do
    assert AnalyticTableaux.Parser.parse("p,r |- q") == [:p, :r, :q]
  end

  test "parse fails if no conclusion" do
    assert_raise MatchError, fn ->
      AnalyticTableaux.Parser.parse("p,r |-")
    end
  end

  test "should parse binary formulas with atomic children" do
    assert AnalyticTableaux.Parser.parse("|- (p & q)") == [{:and, :p, :q}]
    assert AnalyticTableaux.Parser.parse("|- (p | q)") == [{:or, :p, :q}]
    assert AnalyticTableaux.Parser.parse("|- (p -> q)") == [{:implies, :p, :q}]
    assert AnalyticTableaux.Parser.parse("|- (p = q)") == [{:iff, :p, :q}]
    assert AnalyticTableaux.Parser.parse("(a&b), (b&c),b|- (p & q)") == [{:and, :a, :b}, {:and, :b, :c}, :b, {:and, :p, :q}]
    assert AnalyticTableaux.Parser.parse("(a&b), (b|c),b|- (p -> q)") == [{:and, :a, :b}, {:or, :b, :c}, :b, {:implies, :p, :q}]
    assert AnalyticTableaux.Parser.parse("(a&b), (b=c),b|- (p -> q)") == [{:and, :a, :b}, {:iff, :b, :c}, :b, {:implies, :p, :q}]
  end

  test "should parse binary formulas with complex binary children" do
    assert AnalyticTableaux.Parser.parse("|- (p & (q | r))") == [{:and, :p, {:or, :q, :r}}]
    assert AnalyticTableaux.Parser.parse("p, ((q|r)|(a|(b&c)))|- (p & (q | r))") == [
      :p,
      {:or, {:or, :q, :r}, {:or, :a, {:and, :b, :c}}},
      {:and, :p, {:or, :q, :r}}
    ]
  end

  test "should parse unary formulas with atomic children" do
    assert AnalyticTableaux.Parser.parse("|- ~q") == [{:not, :q}]
    assert AnalyticTableaux.Parser.parse("|- ~a") == [{:not, :a}]
    assert AnalyticTableaux.Parser.parse("~b |- a") == [{:not, :b}, :a]
    assert AnalyticTableaux.Parser.parse("~b,~c |- a") == [{:not, :b}, {:not, :c}, :a]
  end

  test "should parse unary formulas with complex children" do
    assert AnalyticTableaux.Parser.parse("|- ~~q") == [{:not, {:not, :q}}]
    assert AnalyticTableaux.Parser.parse("|- ~(q&r)") == [{:not, {:and, :q, :r}}]
    assert AnalyticTableaux.Parser.parse("|- ~~(q&r)") == [{:not, {:not, {:and, :q, :r}}}]
    assert AnalyticTableaux.Parser.parse("p, ~d, (~(q|~r)|(a|~(b&c)))|- (p & (q | r))") == [
      :p,
      {:not, :d},
      {:or, {:not, {:or, :q, {:not, :r}}}, {:or, :a, {:not, {:and, :b, :c}}}},
      {:and, :p, {:or, :q, :r}}
    ]
  end

  test "overbracketing is allowed" do
    assert AnalyticTableaux.Parser.parse("|- (q)") == [:q]
    assert AnalyticTableaux.Parser.parse("|- (~(~(q)))") == [{:not, {:not, :q}}]
    assert AnalyticTableaux.Parser.parse("((a)) |- (q)") == [:a, :q]
    assert AnalyticTableaux.Parser.parse("((a & b)) |- (q)") == [{:and, :a, :b}, :q]
  end

  test "top-level complex formulas do not need to be wrapped in parentheses" do
    assert AnalyticTableaux.Parser.parse("|- q->r") == [{:implies, :q, :r}]
    assert AnalyticTableaux.Parser.parse("a&~b, b|(c&d),b|- p & q") == [{:and, :a, {:not, :b}}, {:or, :b, {:and, :c, :d}}, :b, {:and, :p, :q}]
  end

  test "alternative symbols for AND" do
    assert AnalyticTableaux.Parser.parse("|- a AND b") == [{:and, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a.b") == [{:and, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a^b") == [{:and, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a∧b") == [{:and, :a, :b}]
  end

  test "alternative symbols for OR" do
    assert AnalyticTableaux.Parser.parse("|- a OR b") == [{:or, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a+b") == [{:or, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- aVb") == [{:or, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a∨b") == [{:or, :a, :b}]
  end

  test "alternative symbols for NOT" do
    assert AnalyticTableaux.Parser.parse("|- NOT a") == [{:not, :a}]
    assert AnalyticTableaux.Parser.parse("|- ¬a") == [{:not, :a}]
    assert AnalyticTableaux.Parser.parse("|- -a") == [{:not, :a}]
    assert AnalyticTableaux.Parser.parse("|- 'a") == [{:not, :a}]
    assert AnalyticTableaux.Parser.parse("|- !a") == [{:not, :a}]
  end

  test "alternative symbols for IMPLIES" do
    assert AnalyticTableaux.Parser.parse("|- a IMPLIES b") == [{:implies, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a > b") == [{:implies, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a → b") == [{:implies, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a ⊃ b") == [{:implies, :a, :b}]
  end

  test "alternative symbols for IFF" do
    assert AnalyticTableaux.Parser.parse("|- a IFF b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a <-> b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a <> b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a ↔ b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a ⇔ b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a ≡ b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a EQV b") == [{:iff, :a, :b}]
    assert AnalyticTableaux.Parser.parse("|- a XNOR b") == [{:iff, :a, :b}]
  end

  test "should allow longer atoms containing numbers and underscores" do
    assert AnalyticTableaux.Parser.parse("|- a_1 IFF b_3_4") == [{:iff, :a_1, :b_3_4}]
  end

  test "binary operators are right associative" do
    assert AnalyticTableaux.Parser.parse("|- a&b&c") == [{:and, :a, {:and, :b, :c}}]
    assert AnalyticTableaux.Parser.parse("|- a&b&c&d") == [{:and, :a, {:and, :b, {:and, :c, :d}}}]
    assert AnalyticTableaux.Parser.parse("|- a&b|c&d") == [{:and, :a, {:or, :b, {:and, :c, :d}}}]
  end

  test "NOT takes precedence over binary operator" do
    assert AnalyticTableaux.Parser.parse("|- ~a&b") == [{:and, {:not, :a}, :b}]
    assert AnalyticTableaux.Parser.parse("|- ~a|b") == [{:or, {:not, :a}, :b}]
    assert AnalyticTableaux.Parser.parse("|- ~a->b") == [{:implies, {:not, :a}, :b}]
    assert AnalyticTableaux.Parser.parse("|- ~a=b") == [{:iff, {:not, :a}, :b}]
  end

end
