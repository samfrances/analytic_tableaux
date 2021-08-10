Definitions.

ATOM       = [a-z_0-9]+
WHITESPACE = [\s\t\n\r]
TURNSTILE  = \|\-
OR         = (\||OR|\+|V|∨)
AND        = (\&|AND|\.|\^|∧)
IMPLIES    = (\-\>|IMPLIES|\>|→|⊃)
IFF        = (\=|IFF)
IFF        = (\=|IFF|\<\-\>|\<\>|↔|⇔|≡|EQV|XNOR)
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
{IFF}         : {token, {binary, TokenLine, 'iff'}}.
{WHITESPACE}+ : skip_token.

Erlang code.
