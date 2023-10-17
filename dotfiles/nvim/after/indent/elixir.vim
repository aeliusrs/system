if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal indentexpr=elixir#indent(v:lnum)

setlocal indentkeys+==after,=catch,=do,=else,=end,=rescue,
setlocal indentkeys+=*<Return>,=->,=\|>,=<>,0},0],0)

function! elixir#indent(lnum)
  return elixir#indent#indent(a:lnum)
endfunction
