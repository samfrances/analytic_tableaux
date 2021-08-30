defprotocol AnalyticTableaux.ProverResult do

  @type proof_status :: :unknown | :valid | :not_valid
  @type simplified_valuation :: %{optional(atom()) => boolean()}

  @spec get_status(t) :: proof_status()
  def get_status(value)

  @spec get_countervaluation(t) :: simplified_valuation()
  def get_countervaluation(value)

end
