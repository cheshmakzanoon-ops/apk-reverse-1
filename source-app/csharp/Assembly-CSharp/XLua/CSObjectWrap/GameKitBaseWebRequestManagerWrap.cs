using System;
using System.Collections.Generic;
using GameKit.Base;
using UnityEngine;
using UnityEngine.Networking;
using XLua.LuaDLL;

namespace XLua.CSObjectWrap;

public class GameKitBaseWebRequestManagerWrap
{
	public static void __Register(IntPtr L)
	{
		ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		Type typeFromHandle = typeof(WebRequestManager);
		Utils.BeginObjectRegister(typeFromHandle, L, translator, 0, 14, 0, 0);
		Utils.RegisterFunc(L, -3, "IsDownloadResult", _m_IsDownloadResult);
		Utils.RegisterFunc(L, -3, "LoadAssetBundle", _m_LoadAssetBundle);
		Utils.RegisterFunc(L, -3, "LoadTexture", _m_LoadTexture);
		Utils.RegisterFunc(L, -3, "LoadMultimedia", _m_LoadMultimedia);
		Utils.RegisterFunc(L, -3, "Get", _m_Get);
		Utils.RegisterFunc(L, -3, "Post", _m_Post);
		Utils.RegisterFunc(L, -3, "PostJson", _m_PostJson);
		Utils.RegisterFunc(L, -3, "Head", _m_Head);
		Utils.RegisterFunc(L, -3, "Put", _m_Put);
		Utils.RegisterFunc(L, -3, "Delete", _m_Delete);
		Utils.RegisterFunc(L, -3, "DownFile", _m_DownFile);
		Utils.RegisterFunc(L, -3, "Cancel", _m_Cancel);
		Utils.RegisterFunc(L, -3, "Abort", _m_Abort);
		Utils.RegisterFunc(L, -3, "ChatSendPhotoAbort", _m_ChatSendPhotoAbort);
		Utils.EndObjectRegister(typeFromHandle, L, translator, null, null, null, null, null);
		Utils.BeginClassRegister(typeFromHandle, L, __CreateInstance, 4, 0, 0);
		Utils.RegisterFunc(L, -4, "CreatePostJson", _m_CreatePostJson_xlua_st_);
		Utils.RegisterFunc(L, -4, "DisableCertificateHandler", _m_DisableCertificateHandler_xlua_st_);
		Utils.RegisterObject(L, translator, -4, "FILE_NO_EXISTS", "file no exists");
		Utils.EndClassRegister(typeFromHandle, L, translator);
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int __CreateInstance(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			if (Lua.lua_gettop(L) == 1)
			{
				WebRequestManager o = new WebRequestManager();
				objectTranslator.Push(L, o);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager constructor!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_IsDownloadResult(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			UnityWebRequest request = (UnityWebRequest)objectTranslator.GetObject(L, 2, typeof(UnityWebRequest));
			string result = Lua.lua_tostring(L, 3);
			bool value = webRequestManager.IsDownloadResult(request, result);
			Lua.lua_pushboolean(L, value);
			return 1;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_LoadAssetBundle(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && objectTranslator.Assignable<object>(L, 6))
			{
				string uri = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority = Lua.xlua_tointeger(L, 4);
				int timeout = Lua.xlua_tointeger(L, 5);
				object @object = objectTranslator.GetObject(L, 6, typeof(object));
				webRequestManager.LoadAssetBundle(uri, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority2 = Lua.xlua_tointeger(L, 4);
				int timeout2 = Lua.xlua_tointeger(L, 5);
				webRequestManager.LoadAssetBundle(uri2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority3 = Lua.xlua_tointeger(L, 4);
				webRequestManager.LoadAssetBundle(uri3, delegate3, priority3);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				webRequestManager.LoadAssetBundle(uri4, delegate4);
				return 0;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Hash128>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri5 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out Hash128 v);
				WebRequestManager.OnWebRequestCallback delegate5 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority4 = Lua.xlua_tointeger(L, 5);
				int timeout3 = Lua.xlua_tointeger(L, 6);
				object object2 = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.LoadAssetBundle(uri5, v, delegate5, priority4, timeout3, object2);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Hash128>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri6 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out Hash128 v2);
				WebRequestManager.OnWebRequestCallback delegate6 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority5 = Lua.xlua_tointeger(L, 5);
				int timeout4 = Lua.xlua_tointeger(L, 6);
				webRequestManager.LoadAssetBundle(uri6, v2, delegate6, priority5, timeout4);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Hash128>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri7 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out Hash128 v3);
				WebRequestManager.OnWebRequestCallback delegate7 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority6 = Lua.xlua_tointeger(L, 5);
				webRequestManager.LoadAssetBundle(uri7, v3, delegate7, priority6);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Hash128>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri8 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out Hash128 v4);
				WebRequestManager.OnWebRequestCallback delegate8 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.LoadAssetBundle(uri8, v4, delegate8);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadAssetBundle!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_LoadTexture(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && objectTranslator.Assignable<object>(L, 6))
			{
				string uri = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority = Lua.xlua_tointeger(L, 4);
				int timeout = Lua.xlua_tointeger(L, 5);
				object @object = objectTranslator.GetObject(L, 6, typeof(object));
				webRequestManager.LoadTexture(uri, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority2 = Lua.xlua_tointeger(L, 4);
				int timeout2 = Lua.xlua_tointeger(L, 5);
				webRequestManager.LoadTexture(uri2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority3 = Lua.xlua_tointeger(L, 4);
				webRequestManager.LoadTexture(uri3, delegate3, priority3);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				webRequestManager.LoadTexture(uri4, delegate4);
				return 0;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && LuaTypes.LUA_TBOOLEAN == Lua.lua_type(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri5 = Lua.lua_tostring(L, 2);
				bool nonReadable = Lua.lua_toboolean(L, 3);
				WebRequestManager.OnWebRequestCallback delegate5 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority4 = Lua.xlua_tointeger(L, 5);
				int timeout3 = Lua.xlua_tointeger(L, 6);
				object object2 = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.LoadTexture(uri5, nonReadable, delegate5, priority4, timeout3, object2);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && LuaTypes.LUA_TBOOLEAN == Lua.lua_type(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri6 = Lua.lua_tostring(L, 2);
				bool nonReadable2 = Lua.lua_toboolean(L, 3);
				WebRequestManager.OnWebRequestCallback delegate6 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority5 = Lua.xlua_tointeger(L, 5);
				int timeout4 = Lua.xlua_tointeger(L, 6);
				webRequestManager.LoadTexture(uri6, nonReadable2, delegate6, priority5, timeout4);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && LuaTypes.LUA_TBOOLEAN == Lua.lua_type(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri7 = Lua.lua_tostring(L, 2);
				bool nonReadable3 = Lua.lua_toboolean(L, 3);
				WebRequestManager.OnWebRequestCallback delegate7 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority6 = Lua.xlua_tointeger(L, 5);
				webRequestManager.LoadTexture(uri7, nonReadable3, delegate7, priority6);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && LuaTypes.LUA_TBOOLEAN == Lua.lua_type(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri8 = Lua.lua_tostring(L, 2);
				bool nonReadable4 = Lua.lua_toboolean(L, 3);
				WebRequestManager.OnWebRequestCallback delegate8 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.LoadTexture(uri8, nonReadable4, delegate8);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadTexture!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_LoadMultimedia(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<AudioType>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out AudioType v);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority = Lua.xlua_tointeger(L, 5);
				int timeout = Lua.xlua_tointeger(L, 6);
				object @object = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.LoadMultimedia(uri, v, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<AudioType>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out AudioType v2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority2 = Lua.xlua_tointeger(L, 5);
				int timeout2 = Lua.xlua_tointeger(L, 6);
				webRequestManager.LoadMultimedia(uri2, v2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<AudioType>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out AudioType v3);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority3 = Lua.xlua_tointeger(L, 5);
				webRequestManager.LoadMultimedia(uri3, v3, delegate3, priority3);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<AudioType>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				objectTranslator.Get(L, 3, out AudioType v4);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.LoadMultimedia(uri4, v4, delegate4);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadMultimedia!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Get(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && objectTranslator.Assignable<object>(L, 6))
			{
				string uri = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority = Lua.xlua_tointeger(L, 4);
				int timeout = Lua.xlua_tointeger(L, 5);
				object @object = objectTranslator.GetObject(L, 6, typeof(object));
				webRequestManager.Get(uri, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority2 = Lua.xlua_tointeger(L, 4);
				int timeout2 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Get(uri2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority3 = Lua.xlua_tointeger(L, 4);
				webRequestManager.Get(uri3, delegate3, priority3);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				webRequestManager.Get(uri4, delegate4);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Get!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Post(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Dictionary<string, string>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri = Lua.lua_tostring(L, 2);
				Dictionary<string, string> formFields = (Dictionary<string, string>)objectTranslator.GetObject(L, 3, typeof(Dictionary<string, string>));
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority = Lua.xlua_tointeger(L, 5);
				int timeout = Lua.xlua_tointeger(L, 6);
				object @object = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.Post(uri, formFields, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Dictionary<string, string>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				Dictionary<string, string> formFields2 = (Dictionary<string, string>)objectTranslator.GetObject(L, 3, typeof(Dictionary<string, string>));
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority2 = Lua.xlua_tointeger(L, 5);
				int timeout2 = Lua.xlua_tointeger(L, 6);
				webRequestManager.Post(uri2, formFields2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Dictionary<string, string>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				Dictionary<string, string> formFields3 = (Dictionary<string, string>)objectTranslator.GetObject(L, 3, typeof(Dictionary<string, string>));
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority3 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Post(uri3, formFields3, delegate3, priority3);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Dictionary<string, string>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				Dictionary<string, string> formFields4 = (Dictionary<string, string>)objectTranslator.GetObject(L, 3, typeof(Dictionary<string, string>));
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.Post(uri4, formFields4, delegate4);
				return 0;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri5 = Lua.lua_tostring(L, 2);
				string postData = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate5 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority4 = Lua.xlua_tointeger(L, 5);
				int timeout3 = Lua.xlua_tointeger(L, 6);
				object object2 = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.Post(uri5, postData, delegate5, priority4, timeout3, object2);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri6 = Lua.lua_tostring(L, 2);
				string postData2 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate6 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority5 = Lua.xlua_tointeger(L, 5);
				int timeout4 = Lua.xlua_tointeger(L, 6);
				webRequestManager.Post(uri6, postData2, delegate6, priority5, timeout4);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri7 = Lua.lua_tostring(L, 2);
				string postData3 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate7 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority6 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Post(uri7, postData3, delegate7, priority6);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri8 = Lua.lua_tostring(L, 2);
				string postData4 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate8 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.Post(uri8, postData4, delegate8);
				return 0;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WWWForm>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri9 = Lua.lua_tostring(L, 2);
				WWWForm formData = (WWWForm)objectTranslator.GetObject(L, 3, typeof(WWWForm));
				WebRequestManager.OnWebRequestCallback delegate9 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority7 = Lua.xlua_tointeger(L, 5);
				int timeout5 = Lua.xlua_tointeger(L, 6);
				object object3 = objectTranslator.GetObject(L, 7, typeof(object));
				UnityWebRequest o = webRequestManager.Post(uri9, formData, delegate9, priority7, timeout5, object3);
				objectTranslator.Push(L, o);
				return 1;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WWWForm>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri10 = Lua.lua_tostring(L, 2);
				WWWForm formData2 = (WWWForm)objectTranslator.GetObject(L, 3, typeof(WWWForm));
				WebRequestManager.OnWebRequestCallback delegate10 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority8 = Lua.xlua_tointeger(L, 5);
				int timeout6 = Lua.xlua_tointeger(L, 6);
				UnityWebRequest o2 = webRequestManager.Post(uri10, formData2, delegate10, priority8, timeout6);
				objectTranslator.Push(L, o2);
				return 1;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WWWForm>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri11 = Lua.lua_tostring(L, 2);
				WWWForm formData3 = (WWWForm)objectTranslator.GetObject(L, 3, typeof(WWWForm));
				WebRequestManager.OnWebRequestCallback delegate11 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority9 = Lua.xlua_tointeger(L, 5);
				UnityWebRequest o3 = webRequestManager.Post(uri11, formData3, delegate11, priority9);
				objectTranslator.Push(L, o3);
				return 1;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WWWForm>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri12 = Lua.lua_tostring(L, 2);
				WWWForm formData4 = (WWWForm)objectTranslator.GetObject(L, 3, typeof(WWWForm));
				WebRequestManager.OnWebRequestCallback delegate12 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				UnityWebRequest o4 = webRequestManager.Post(uri12, formData4, delegate12);
				objectTranslator.Push(L, o4);
				return 1;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<List<IMultipartFormSection>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri13 = Lua.lua_tostring(L, 2);
				List<IMultipartFormSection> multipartFormSections = (List<IMultipartFormSection>)objectTranslator.GetObject(L, 3, typeof(List<IMultipartFormSection>));
				WebRequestManager.OnWebRequestCallback delegate13 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority10 = Lua.xlua_tointeger(L, 5);
				int timeout7 = Lua.xlua_tointeger(L, 6);
				object object4 = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.Post(uri13, multipartFormSections, delegate13, priority10, timeout7, object4);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<List<IMultipartFormSection>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri14 = Lua.lua_tostring(L, 2);
				List<IMultipartFormSection> multipartFormSections2 = (List<IMultipartFormSection>)objectTranslator.GetObject(L, 3, typeof(List<IMultipartFormSection>));
				WebRequestManager.OnWebRequestCallback delegate14 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority11 = Lua.xlua_tointeger(L, 5);
				int timeout8 = Lua.xlua_tointeger(L, 6);
				webRequestManager.Post(uri14, multipartFormSections2, delegate14, priority11, timeout8);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<List<IMultipartFormSection>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri15 = Lua.lua_tostring(L, 2);
				List<IMultipartFormSection> multipartFormSections3 = (List<IMultipartFormSection>)objectTranslator.GetObject(L, 3, typeof(List<IMultipartFormSection>));
				WebRequestManager.OnWebRequestCallback delegate15 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority12 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Post(uri15, multipartFormSections3, delegate15, priority12);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<List<IMultipartFormSection>>(L, 3) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri16 = Lua.lua_tostring(L, 2);
				List<IMultipartFormSection> multipartFormSections4 = (List<IMultipartFormSection>)objectTranslator.GetObject(L, 3, typeof(List<IMultipartFormSection>));
				WebRequestManager.OnWebRequestCallback delegate16 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.Post(uri16, multipartFormSections4, delegate16);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Post!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_PostJson(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<Dictionary<string, string>>(L, 7))
			{
				string uri = Lua.lua_tostring(L, 2);
				string json = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority = Lua.xlua_tointeger(L, 5);
				int timeout = Lua.xlua_tointeger(L, 6);
				Dictionary<string, string> headers = (Dictionary<string, string>)objectTranslator.GetObject(L, 7, typeof(Dictionary<string, string>));
				UnityWebRequest o = webRequestManager.PostJson(uri, json, @delegate, priority, timeout, headers);
				objectTranslator.Push(L, o);
				return 1;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				string json2 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority2 = Lua.xlua_tointeger(L, 5);
				int timeout2 = Lua.xlua_tointeger(L, 6);
				UnityWebRequest o2 = webRequestManager.PostJson(uri2, json2, delegate2, priority2, timeout2);
				objectTranslator.Push(L, o2);
				return 1;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				string json3 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority3 = Lua.xlua_tointeger(L, 5);
				UnityWebRequest o3 = webRequestManager.PostJson(uri3, json3, delegate3, priority3);
				objectTranslator.Push(L, o3);
				return 1;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				string json4 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				UnityWebRequest o4 = webRequestManager.PostJson(uri4, json4, delegate4);
				objectTranslator.Push(L, o4);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.PostJson!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_CreatePostJson_xlua_st_(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			int num = Lua.lua_gettop(L);
			if (num == 3 && (Lua.lua_isnil(L, 1) || Lua.lua_type(L, 1) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<Dictionary<string, string>>(L, 3))
			{
				string uri = Lua.lua_tostring(L, 1);
				string json = Lua.lua_tostring(L, 2);
				Dictionary<string, string> headers = (Dictionary<string, string>)objectTranslator.GetObject(L, 3, typeof(Dictionary<string, string>));
				UnityWebRequest o = WebRequestManager.CreatePostJson(uri, json, headers);
				objectTranslator.Push(L, o);
				return 1;
			}
			if (num == 2 && (Lua.lua_isnil(L, 1) || Lua.lua_type(L, 1) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING))
			{
				string uri2 = Lua.lua_tostring(L, 1);
				string json2 = Lua.lua_tostring(L, 2);
				UnityWebRequest o2 = WebRequestManager.CreatePostJson(uri2, json2);
				objectTranslator.Push(L, o2);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.CreatePostJson!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Head(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && objectTranslator.Assignable<object>(L, 6))
			{
				string uri = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority = Lua.xlua_tointeger(L, 4);
				int timeout = Lua.xlua_tointeger(L, 5);
				object @object = objectTranslator.GetObject(L, 6, typeof(object));
				webRequestManager.Head(uri, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority2 = Lua.xlua_tointeger(L, 4);
				int timeout2 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Head(uri2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority3 = Lua.xlua_tointeger(L, 4);
				webRequestManager.Head(uri3, delegate3, priority3);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				webRequestManager.Head(uri4, delegate4);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Head!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Put(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri = Lua.lua_tostring(L, 2);
				string bodyData = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority = Lua.xlua_tointeger(L, 5);
				int timeout = Lua.xlua_tointeger(L, 6);
				object @object = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.Put(uri, bodyData, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				string bodyData2 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority2 = Lua.xlua_tointeger(L, 5);
				int timeout2 = Lua.xlua_tointeger(L, 6);
				webRequestManager.Put(uri2, bodyData2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				string bodyData3 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority3 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Put(uri3, bodyData3, delegate3, priority3);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				string bodyData4 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.Put(uri4, bodyData4, delegate4);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING))
			{
				string uri5 = Lua.lua_tostring(L, 2);
				string bodyData5 = Lua.lua_tostring(L, 3);
				webRequestManager.Put(uri5, bodyData5);
				return 0;
			}
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri6 = Lua.lua_tostring(L, 2);
				byte[] bodyData6 = Lua.lua_tobytes(L, 3);
				WebRequestManager.OnWebRequestCallback delegate5 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority4 = Lua.xlua_tointeger(L, 5);
				int timeout3 = Lua.xlua_tointeger(L, 6);
				object object2 = objectTranslator.GetObject(L, 7, typeof(object));
				webRequestManager.Put(uri6, bodyData6, delegate5, priority4, timeout3, object2);
				return 0;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri7 = Lua.lua_tostring(L, 2);
				byte[] bodyData7 = Lua.lua_tobytes(L, 3);
				WebRequestManager.OnWebRequestCallback delegate6 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority5 = Lua.xlua_tointeger(L, 5);
				int timeout4 = Lua.xlua_tointeger(L, 6);
				webRequestManager.Put(uri7, bodyData7, delegate6, priority5, timeout4);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri8 = Lua.lua_tostring(L, 2);
				byte[] bodyData8 = Lua.lua_tobytes(L, 3);
				WebRequestManager.OnWebRequestCallback delegate7 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority6 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Put(uri8, bodyData8, delegate7, priority6);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri9 = Lua.lua_tostring(L, 2);
				byte[] bodyData9 = Lua.lua_tobytes(L, 3);
				WebRequestManager.OnWebRequestCallback delegate8 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				webRequestManager.Put(uri9, bodyData9, delegate8);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING))
			{
				string uri10 = Lua.lua_tostring(L, 2);
				byte[] bodyData10 = Lua.lua_tobytes(L, 3);
				webRequestManager.Put(uri10, bodyData10);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Put!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Delete(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && objectTranslator.Assignable<object>(L, 6))
			{
				string uri = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority = Lua.xlua_tointeger(L, 4);
				int timeout = Lua.xlua_tointeger(L, 5);
				object @object = objectTranslator.GetObject(L, 6, typeof(object));
				webRequestManager.Delete(uri, @delegate, priority, timeout, @object);
				return 0;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority2 = Lua.xlua_tointeger(L, 4);
				int timeout2 = Lua.xlua_tointeger(L, 5);
				webRequestManager.Delete(uri2, delegate2, priority2, timeout2);
				return 0;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 4))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				int priority3 = Lua.xlua_tointeger(L, 4);
				webRequestManager.Delete(uri3, delegate3, priority3);
				return 0;
			}
			if (num == 3 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 3))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 3);
				webRequestManager.Delete(uri4, delegate4);
				return 0;
			}
			if (num == 2 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING))
			{
				string uri5 = Lua.lua_tostring(L, 2);
				webRequestManager.Delete(uri5);
				return 0;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Delete!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_DownFile(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			int num = Lua.lua_gettop(L);
			if (num == 7 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6) && objectTranslator.Assignable<object>(L, 7))
			{
				string uri = Lua.lua_tostring(L, 2);
				string localFilePath = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback @delegate = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority = Lua.xlua_tointeger(L, 5);
				int timeout = Lua.xlua_tointeger(L, 6);
				object @object = objectTranslator.GetObject(L, 7, typeof(object));
				UnityWebRequest o = webRequestManager.DownFile(uri, localFilePath, @delegate, priority, timeout, @object);
				objectTranslator.Push(L, o);
				return 1;
			}
			if (num == 6 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				string uri2 = Lua.lua_tostring(L, 2);
				string localFilePath2 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate2 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority2 = Lua.xlua_tointeger(L, 5);
				int timeout2 = Lua.xlua_tointeger(L, 6);
				UnityWebRequest o2 = webRequestManager.DownFile(uri2, localFilePath2, delegate2, priority2, timeout2);
				objectTranslator.Push(L, o2);
				return 1;
			}
			if (num == 5 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				string uri3 = Lua.lua_tostring(L, 2);
				string localFilePath3 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate3 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				int priority3 = Lua.xlua_tointeger(L, 5);
				UnityWebRequest o3 = webRequestManager.DownFile(uri3, localFilePath3, delegate3, priority3);
				objectTranslator.Push(L, o3);
				return 1;
			}
			if (num == 4 && (Lua.lua_isnil(L, 2) || Lua.lua_type(L, 2) == LuaTypes.LUA_TSTRING) && (Lua.lua_isnil(L, 3) || Lua.lua_type(L, 3) == LuaTypes.LUA_TSTRING) && objectTranslator.Assignable<WebRequestManager.OnWebRequestCallback>(L, 4))
			{
				string uri4 = Lua.lua_tostring(L, 2);
				string localFilePath4 = Lua.lua_tostring(L, 3);
				WebRequestManager.OnWebRequestCallback delegate4 = objectTranslator.GetDelegate<WebRequestManager.OnWebRequestCallback>(L, 4);
				UnityWebRequest o4 = webRequestManager.DownFile(uri4, localFilePath4, delegate4);
				objectTranslator.Push(L, o4);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.DownFile!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Cancel(IntPtr L)
	{
		try
		{
			WebRequestManager obj = (WebRequestManager)ObjectTranslatorPool.Instance.Find(L).FastGetCSObj(L, 1);
			string url = Lua.lua_tostring(L, 2);
			obj.Cancel(url);
			return 0;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Abort(IntPtr L)
	{
		try
		{
			WebRequestManager obj = (WebRequestManager)ObjectTranslatorPool.Instance.Find(L).FastGetCSObj(L, 1);
			string url = Lua.lua_tostring(L, 2);
			obj.Abort(url);
			return 0;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_ChatSendPhotoAbort(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			WebRequestManager webRequestManager = (WebRequestManager)objectTranslator.FastGetCSObj(L, 1);
			UnityWebRequest webRequest = (UnityWebRequest)objectTranslator.GetObject(L, 2, typeof(UnityWebRequest));
			webRequestManager.ChatSendPhotoAbort(webRequest);
			return 0;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_DisableCertificateHandler_xlua_st_(IntPtr L)
	{
		try
		{
			bool value = WebRequestManager.DisableCertificateHandler();
			Lua.lua_pushboolean(L, value);
			return 1;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}
}
