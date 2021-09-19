# AnalyticTableaux

This is an implementation in Elixir of the [Method of Analytic Tableaux](https://en.wikipedia.org/wiki/Method_of_analytic_tableaux) for proving arguments (sequents) in [propositional logic](https://en.wikipedia.org/wiki/Propositional_calculus).

We implement the "signed formulae" version of analytic tableaux.

The code is structured to allow for multiple implementations of the prover.

Currently, a single prover based on the ["block tableaux"](https://www.google.es/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiigdOqkvnyAhWOfMAKHV8cBdQQFnoECAUQAQ&url=http%3A%2F%2Fwww.cs.cornell.edu%2Fcourses%2Fcs4860%2F2012fa%2Flec-09.pdf&usg=AOvVaw3H9bxXXFRyPMp0zTaBWugt) variant of the method has been implemented.


# Elixir features used

- [x] Protocols
- [x] Behaviours
- [x] Property-based testing
- [x] Parsing using (yecc)[https://erlang.org/doc/man/yecc.html] and (leex)[https://erlang.org/doc/man/leex.html]
- [x] "Type-checking" with (dialyxir)[https://github.com/jeremyjh/dialyxir]

## Scope for future development

- [ ] Add instructions for use to README
- [x] Create CLI
  - [ ] Better handling of invalid arguments
- [ ] Multiple prover implementations
  - [x] Block tablueax
  - [ ] Tree tableaux
  - [ ] Unsigned tableaux
  - [ ] Use Elixir's concurrency features
- [ ] Extend use of property-based testing
  - [ ] Valuator module
- [ ] Better module documentation
- [ ] Generate hexdoc documentation
