Definitions.

ATOM       = [a-z]
WHITESPACE = [\s\t\n\r]
IMPLIES    = (\-\>|IMPLIES|\>|→|⊃)
TURNSTILE  = \|\-
OR         = (\||OR|\+|V|∨)
AND        = (\&|AND|\.|\^|∧)
NOT        = (\~|NOT|\¬|\-|\'|\!)

Rules.

{ATOM}        : {token, {atom,   TokenLine, list_to_atom(TokenChars)}}.
\(            : {token, {'(',    TokenLine}}.
\)            : {token, {')',    TokenLine}}.
,             : {token, {',',    TokenLine}}.
{TURNSTILE}   : {token, {'|-',   TokenLine}}.
{NOT}         : {token, {unary,  TokenLine, 'not'}}.
{OR}          : {token, {binary, TokenLine, 'or'}}.
{AND}         : {token, {binary, TokenLine, 'and'}}.
{IMPLIES}     : {token, {binary, TokenLine, 'implies'}}.
{WHITESPACE}+ : skip_token.

Erlang code.
