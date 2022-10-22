# odin-lua

Lua bindings updated from the fork to support -string-style and link_prefix.


### Usage
  - Add the shared folder to the odin shared collection.
  - Call functions like you would in C; substitute the `lua_/luaL_` prefixes with the corresponding packages: `luaL.dofile`
  - Some function names clash with keywords, therefore they were named with an underscore prefix: `luaL._where` `lua._type`
  - The `luax` package contains extra lua utlities not available in the standard C API
  

### Known issues
  - The library and binary files are made for windows only. If you want to use other OS you need to replace the foreign imports yourself. Feel free to submit a pull request or issue if you have a better approach
