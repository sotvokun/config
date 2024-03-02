" Name: colorutil.vim - The utilities for creating color
" Author: Sotvokun <sotvokun@outlook.com>
" License: UNLICENSED


" Convert RGB to HEX
function! colorutil#rgb2hex(r, g, b) abort
  let r = printf('%02X', a:r)
  let g = printf('%02X', a:g)
  let b = printf('%02X', a:b)
  return '#' . r . g . b
endfunction


" Convert RGB to HEX (Array)
function! colorutil#rgb2hex_arr(rgb) abort
  return printf('#%02X%02X%02X', a:rgb[0], a:rgb[1], a:rgb[2])
endfunction


" Convert HEX to RGB
function! colorutil#hex2rgb(hex) abort
  let hex = substitute(a:hex, '#', '', '')
  let r = str2nr(printf('%d', '0x' . strpart(hex, 0, 2)))
  let g = str2nr(printf('%d', '0x' . strpart(hex, 2, 2)))
  let b = str2nr(printf('%d', '0x' . strpart(hex, 4, 2)))
  return [r, g, b]
endfunction


" Convert HSL to RGB
function! colorutil#hsl2rgb(h, s, l) abort
  let h = a:h | let s = a:s * 1.0 / 100 | let l = a:l * 1.0 / 100
  let c = (1 - abs(2 * l - 1)) * s
  let x = c * (1 - abs((h / 60) % 2 - 1))
  let m = l - c / 2
  let r = 0 | let g = 0 | let b = 0
  if h < 60 | let r = c | let g = x
    elseif h < 120 | let r = x | let g = c
    elseif h < 180 | let g = c | let b = x
    elseif h < 240 | let g = x | let b = c
    elseif h < 300 | let r = x | let b = c
    else | let r = c | let b = x
  endif
  let r = float2nr((r + m) * 255)
  let g = float2nr((g + m) * 255)
  let b = float2nr((b + m) * 255)
  return [r, g, b]
endfunction


" Convert HSL to RGB (Array)
function! colorutil#hsl2rgb_arr(hsl) abort
  return colorutil#hsl2rgb(a:hsl[0], a:hsl[1], a:hsl[2])
endfunction
