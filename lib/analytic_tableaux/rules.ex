defmodule AnalyticTableaux.Rules do
  alias AnalyticTableaux.SignedFormula

  # True NOT rule
  def apply(%SignedFormula{formula: {:not, a}, truth_value: true}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: false}
      },
      {}
    }
  end

  # False NOT rule
  def apply(%SignedFormula{formula: {:not, a}, truth_value: false}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: true}
      },
      {}
    }
  end

  # True AND rule
  def apply(%SignedFormula{formula: {:and, a, b}, truth_value: true}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: true},
        %SignedFormula{ formula: b, truth_value: true},
      },
      {}
    }
  end

  # False AND rule
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

  # True OR rule
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

  # False OR rule
  def apply(%SignedFormula{formula: {:or, a, b}, truth_value: false}) do
    {
      {
        %SignedFormula{ formula: a, truth_value: false},
        %SignedFormula{ formula: b, truth_value: false},
      },
      {}
    }
  end

    # True IMPLIES rule
    def apply(%SignedFormula{formula: {:implies, a, b}, truth_value: true}) do
      {
        {
          %SignedFormula{ formula: a, truth_value: false}
        },
        {
          %SignedFormula{ formula: b, truth_value: true},
        }
      }
    end

    # False IMPLIES rule
    def apply(%SignedFormula{formula: {:implies, a, b}, truth_value: false}) do
      {
        {
          %SignedFormula{ formula: a, truth_value: true},
          %SignedFormula{ formula: b, truth_value: false},
        },
        {}
      }
    end

    # True IFF rule
    def apply(%SignedFormula{formula: {:iff, a, b}, truth_value: true}) do
      {
        {
          %SignedFormula{ formula: a, truth_value: true},
          %SignedFormula{ formula: b, truth_value: true},
        },
        {
          %SignedFormula{ formula: a, truth_value: false},
          %SignedFormula{ formula: b, truth_value: false},
        }
      }
    end

    # False IFF rule
    def apply(%SignedFormula{formula: {:iff, a, b}, truth_value: false}) do
      {
        {
          %SignedFormula{ formula: a, truth_value: true},
          %SignedFormula{ formula: b, truth_value: false},
        },
        {
          %SignedFormula{ formula: a, truth_value: false},
          %SignedFormula{ formula: b, truth_value: true},
        }
      }
    end
end
