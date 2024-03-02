if exists('g:loaded_coc_after')
	finish
endif
let g:loaded_coc_after = 1

if !exists(':CocInfo')
	finish
endif


" Section: Mappings

inoremap <silent><expr> <tab>
	\ coc#pum#visible()
	\ ? (coc#pum#info()['index'] < 0 ? coc#pum#next(1) : coc#pum#confirm())
	\ : (coc#jumpable()
	\     ? coc#snippet#next()
	\     : (exists(':Copilot') != 0 && copilot#Enabled() ? copilot#Accept("\<tab>") : "\<tab>"))

inoremap <silent><expr> <s-tab>
	\ coc#pum#visible() ? coc#pum#prev(1)
	\ : (coc#jumpable()
	\     ? coc#snippet#prev() : "\<s-tab>")

inoremap <silent><expr> <c-e>
	\ coc#pum#visible() ? coc#pum#cancel()
	\ : (len(copilot#GetDisplayedSuggestion()['uuid']) != 0 ? "\<Plug>(copilot-dismiss)" : "\<end>")

inoremap <silent><expr> <c-n>
	\ coc#pum#visible() ? coc#pum#next(1)
	\ : "\<down>"

inoremap <silent><expr> <c-p>
	\ coc#pum#visible() ? coc#pum#prev(1)
	\ : "\<up>"
