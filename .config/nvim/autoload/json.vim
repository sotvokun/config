" Function: json#expand
" Expands a JSON string or dictionary with dot-separated keys into a nested dictionary.
"
" Parameters:
"   json_str - A JSON string or dictionary with dot-separated keys.
"
" Returns:
"   A JSON string or dictionary with nested keys.
"
" Example:
"  json#expand('{"a.b.c": 1, "a.b.d": 2}')
"  => {'a': {'b': {'c': 1, 'd': 2}}}
"
"  json#expand({'a.b.c': 1, 'a.b.d': 2})
"  => {'a': {'b': {'c': 1, 'd': 2}}}
"
function! json#expand(json_str)
  let input_type = type(a:json_str)
  let json_dict = input_type == 1 ? json_decode(a:json_str) : a:json_str
  let expanded_dict = {}

  for [key, value] in items(json_dict)
    let keys = split(key, '\.')
    let current = expanded_dict

    for i in range(0, len(keys) - 2)
      if !has_key(current, keys[i])
        let current[keys[i]] = {}
      endif
      let current = current[keys[i]]
    endfor

    let current[keys[-1]] = value
  endfor

  return input_type == 1 ? json_encode(expanded_dict) : expanded_dict
endfunction
