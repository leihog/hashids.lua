#include "lua.h"
#include "lauxlib.h"
#include "string.h"
#include "stdlib.h"

static int str_switch_pos(lua_State *L) {
	size_t slen;
	const char *str = lua_tolstring(L, 1, &slen);
	int pos1 = lua_tonumber(L, 2);
	int pos2 = lua_tonumber(L, 3);

	char *nstr = strdup(str);
	nstr[pos1] = str[pos2];
	nstr[pos2] = str[pos1];

	lua_pushlstring(L, nstr, slen);
	free(nstr);
	return 1;
}

static const luaL_reg hashidslib[] = {
	{"str_switch_pos",    str_switch_pos},
	{NULL, NULL}
};

#if !defined LUA_VERSION_NUM || LUA_VERSION_NUM == 501
/*
 * http://lua-users.org/wiki/CompatibilityWithLuaFive
 */
static void luaL_setfuncs (lua_State *L, const luaL_Reg *l, int nup) {
	luaL_checkstack(L, nup, "too many upvalues");
	for (; l->name != NULL; l++) {  /* fill the table with given functions */
		int i;
		for (i = 0; i < nup; i++)  /* copy upvalues to the top */
			lua_pushvalue(L, -nup);
		lua_pushstring(L, l->name);
		lua_pushcclosure(L, l->func, nup);  /* closure with those upvalues */
		lua_settable(L, -(nup + 3));
	}
	lua_pop(L, nup);  /* remove upvalues */
}
#endif

LUALIB_API int luaopen_hashids_clib(lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, hashidslib, 0);
	return 1;
}
