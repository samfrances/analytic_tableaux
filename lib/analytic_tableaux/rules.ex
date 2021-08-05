defmodule AnalyticTableaux.Rules do
  alias AnalyticTableaux.SignedFormula

  def apply(%SignedFormula{formula: {:not, a}, truth_value: true}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: false}
      },
      {}
    }
  end

  def apply(%SignedFormula{formula: {:not, a}, truth_value: false}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: true}
      },
      {}
    }
  end

  def apply(%SignedFormula{formula: {:and, a, b}, truth_value: true}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: true},
        %SignedFormula{ formula: b, truth_value: true},
      },
      {}
    }
  end

  def apply(%SignedFormula{formula: {:and, a, b}, truth_value: false}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: false}
      },
      {
        %SignedFormula{ formula: b, truth_value: false},
      }
    }
  end

  def apply(%SignedFormula{formula: {:or, a, b}, truth_value: true}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: true}
      },
      {
        %SignedFormula{ formula: b, truth_value: true},
      }
    }
  end

  def apply(%SignedFormula{formula: {:or, a, b}, truth_value: false}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: false},
        %SignedFormula{ formula: b, truth_value: false},
      },
      {}
    }
  end

end
