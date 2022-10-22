package luaL

import "core:os"
import "core:c"

import lua "../lua"

when os.OS == .Windows do foreign import liblua "shared:lua542.lib"
when os.OS == .Linux do foreign import liblua "shared:lua542"
when os.OS == .Darwin do foreign import liblua "shared:lua542"

@(default_calling_convention = "c")
@(link_prefix = "luaL_")
foreign liblua {
	// lua_pushfstring :: proc (L: ^lua.State , fmt: cstring , ...) -> cstring ---
	// lua_pushvfstring :: proc (L: ^lua.State , fmt: cstring , va_list argp) -> cstring ---
	argerror :: proc (L: ^lua.State , arg: c.int , extramsg: cstring) -> c.int ---
	callmeta :: proc (L: ^lua.State , obj: c.int , e: cstring ) -> c.int ---
	checkany :: proc (L: ^lua.State , arg: c.int) ---
	checkinteger :: proc (L: ^lua.State , arg: c.int) -> lua.Integer ---
	checklstring :: proc (L: ^lua.State , arg: c.int , l: ^c.ptrdiff_t)-> cstring ---
	checknumber :: proc (L: ^lua.State , arg: c.int ) -> lua.Number ---
	checkoption :: proc (L: ^lua.State , arg: c.int, def: cstring, lst : ^cstring ) -> c.int ---
	checkstack :: proc (L: ^lua.State , sz: c.int , msg: cstring) ---
	checktype :: proc (L: ^lua.State , arg: c.int, t: c.int) ---
	checkudata :: proc (L: ^lua.State , ud: c.int , tname: cstring) -> rawptr ---
	checkversion_ :: proc (L: ^lua.State , ver:lua.Number , sz: c.ptrdiff_t ) ---
	execresult :: proc (L: ^lua.State , stat: c.int ) -> c.int ---
	fileresult :: proc (L: ^lua.State , stat: c.int , fname: cstring) -> c.int ---
	getmetafield :: proc (L: ^lua.State , obj: c.int , e: cstring ) -> c.int ---
	getsubtable :: proc (L: ^lua.State , idx: c.int , fname: cstring) -> c.int ---
	gsub :: proc (L : ^lua.State, s: cstring, p: cstring, r: cstring) -> cstring ---
	len :: proc (L: ^lua.State , idx: c.int ) -> lua.Integer ---
	loadbufferx :: proc (L: ^lua.State , buff: cstring, sz: c.ptrdiff_t , name: cstring, mode: cstring) -> c.int ---
	loadfilex :: proc (L: ^lua.State , filename: cstring, mode: cstring) -> c.int ---
	loadstring :: proc (L: ^lua.State , s: cstring) -> c.int ---
	newmetatable :: proc (L: ^lua.State , tname: cstring) -> c.int ---
	newstate :: proc () -> ^lua.State ---
	openlibs :: proc (L: ^lua.State) ---
	optinteger :: proc (L: ^lua.State , arg: c.int,def: lua.Integer ) -> lua.Integer ---
	optlstring :: proc (L: ^lua.State , arg: c.int , def: cstring, l: ^c.ptrdiff_t) -> cstring ---
	optnumber :: proc (L: ^lua.State , arg: c.int , def:lua.Number) -> lua.Number ---
	ref :: proc (L: ^lua.State , t: c.int ) -> c.int ---
	requiref :: proc (L: ^lua.State , modname: cstring, openf: lua.CFunction , glb: c.int ) ---
	setfuncs :: proc (L: ^lua.State , l: ^Reg, nup: c.int ) --- 
	setmetatable :: proc (L: ^lua.State , tname: cstring) ---
	testudata :: proc (L: ^lua.State , ud: c.int , tname: cstring) -> rawptr ---
	tolstring :: proc (L: ^lua.State , idx: c.int , len: ^c.ptrdiff_t) -> cstring ---
	traceback :: proc (L: ^lua.State , L1: ^lua.State ,msg: cstring, level: c.int ) ---
}

foreign liblua {
	// Note(Dragos): Avoid clashes with keywords
	luaL_where :: proc (L: ^lua.State , lvl: c.int ) ---
}

/*
	CONSTANTS
*/





NUMSIZES :: (size_of(lua.Integer)*16 + size_of(lua.Number))

/*
	TYPES
*/
unref :: proc "c" (L: ^lua.State, t: c.int, ref: c.int)

// lua_ident: ^u8

Reg :: struct {
	name: cstring,
	func: lua.CFunction,
}



/*
	MACROS
*/

// lua_getextraspace :: proc (L: ^lua.State )
// {
// 	(cast(rawptr)(cast(^i8)c.ptrdiff_t(L) - LUA_EXTRASPACE));
// }	


loadfile :: proc (L: ^lua.State, f: cstring) -> c.int {
	return loadfilex(L, f, nil)
}

checkversion :: proc (L: ^lua.State) {
	checkversion_(L, lua.VERSION_NUM, NUMSIZES)
}

// luaL_newlibtable :: proc (L:^ lua.State,l: ^luaL_Reg)
// {
// 	lua_createtable(L, 0, size_of(l)/size_of((l)[0]) - 1);
// }

// luaL_newlib :: proc (L:^ lua.State,l: ^luaL_Reg )
// {
// 	luaL_checkversion(L);
// 	luaL_newlibtable(L,l);
// 	luaL_setfuncs(L,l,0);
// }

// luaL_argcheck :: (L:^ lua.State, cond,arg,extramsg)	\
// 		((void)((cond) || luaL_argerror(L, (arg), (extramsg))))

// luaL_checkstring :: (L:^ lua.State,n)	(luaL_checklstring(L, (n), NULL))
// luaL_optstring :: (L:^ lua.State,n,d)	(luaL_optlstring(L, (n), (d), NULL))

// luaL_typename :: (L:^ lua.State,i)	lua_typename(L, lua_type(L,(i)))

// Note(Dragos): Error handling is not properly made I believe. Loadfile can also error
dofile :: proc (L:^ lua.State, fn: cstring) -> (err: c.int) {
	err = loadfile(L, fn)
	if err != lua.OK do return
	err = lua.pcall(L, 0, lua.MULTRET, 0)
	return
}

dostring :: proc (L:^ lua.State, s: cstring) -> (err: c.int) {
	err = loadstring(L, s)
	if err != lua.OK do return
	err = lua.pcall(L, 0, lua.MULTRET, 0)
	return
}

getmetatable :: proc (L:^ lua.State, n:cstring) {
	lua.getfield(L, lua.REGISTRYINDEX, (n))
}

// luaL_opt :: (L:^ lua.State,f,n,d)	(lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))
// luaL_loadbuffer :: (L:^ lua.State,s,sz,n)	luaL_loadbufferx(L,s,sz,n,NULL)