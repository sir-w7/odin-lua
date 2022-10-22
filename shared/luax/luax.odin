package luax

import c "core:c"

import lua "../lua"
import luaL "../luaL"

get_int :: proc(L: ^lua.State, stackPos: c.int, result: ^int) {
    using lua
    result^ = cast(int)lua.tointeger(L, stackPos)
}

get_float :: proc(L: ^lua.State, stackPos: c.int, result: ^f64) {
    using lua
    result^ = cast(f64)lua.tonumber(L, stackPos)
}

get_bool :: proc(L: ^lua.State, stackPos: c.int, result: ^bool) {
    using lua
    result^ = cast(bool)lua.toboolean(L, stackPos)
}

get_string :: proc(L: ^lua.State, stackPos: c.int, result: ^string) {
    using lua
    result^ = lua.tostring(L, stackPos)
}

get :: proc {
    get_int,
    get_bool,
    get_float,
    get_string,
}

push :: proc {
	lua.pushboolean,
	lua.pushinteger,
	lua.pushnumber,
	lua.pushlightuserdata,
	lua.pushcfunction,
	lua.pushstring,
}