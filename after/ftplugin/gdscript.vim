" use folding provided by vim-godot plugin
setlocal foldmethod=expr
" but default to having folds open
setlocal foldlevelstart=99

setlocal tabstop=4

" handy shortcuts for Godot
nnoremap <buffer> <F4> :GodotRunLast<CR>
nnoremap <buffer> <F5> :GodotRun<CR>
nnoremap <buffer> <F6> :GodotRunCurrent<CR>
nnoremap <buffer> <F7> :GodotRunFZF<CR>
