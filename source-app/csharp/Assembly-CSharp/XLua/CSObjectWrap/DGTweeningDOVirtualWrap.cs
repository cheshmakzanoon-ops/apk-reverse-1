using System;
using DG.Tweening;
using UnityEngine;
using XLua.LuaDLL;

namespace XLua.CSObjectWrap;

public class DGTweeningDOVirtualWrap
{
	public static void __Register(IntPtr L)
	{
		ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		Type typeFromHandle = typeof(DOVirtual);
		Utils.BeginObjectRegister(typeFromHandle, L, translator, 0, 0, 0, 0);
		Utils.EndObjectRegister(typeFromHandle, L, translator, null, null, null, null, null);
		Utils.BeginClassRegister(typeFromHandle, L, __CreateInstance, 4, 0, 0);
		Utils.RegisterFunc(L, -4, "Float", _m_Float_xlua_st_);
		Utils.RegisterFunc(L, -4, "EasedValue", _m_EasedValue_xlua_st_);
		Utils.RegisterFunc(L, -4, "DelayedCall", _m_DelayedCall_xlua_st_);
		Utils.EndClassRegister(typeFromHandle, L, translator);
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int __CreateInstance(IntPtr L)
	{
		return Lua.luaL_error(L, "DG.Tweening.DOVirtual does not have a constructor!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_Float_xlua_st_(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			float from = (float)Lua.lua_tonumber(L, 1);
			float to = (float)Lua.lua_tonumber(L, 2);
			float duration = (float)Lua.lua_tonumber(L, 3);
			TweenCallback<float> @delegate = objectTranslator.GetDelegate<TweenCallback<float>>(L, 4);
			Tweener o = DOVirtual.Float(from, to, duration, @delegate);
			objectTranslator.Push(L, o);
			return 1;
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_EasedValue_xlua_st_(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			int num = Lua.lua_gettop(L);
			if (num == 4 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 2) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 3) && objectTranslator.Assignable<Ease>(L, 4))
			{
				float from = (float)Lua.lua_tonumber(L, 1);
				float to = (float)Lua.lua_tonumber(L, 2);
				float lifetimePercentage = (float)Lua.lua_tonumber(L, 3);
				objectTranslator.Get(L, 4, out Ease val);
				float num2 = DOVirtual.EasedValue(from, to, lifetimePercentage, val);
				Lua.lua_pushnumber(L, num2);
				return 1;
			}
			if (num == 4 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 2) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 3) && objectTranslator.Assignable<AnimationCurve>(L, 4))
			{
				float from2 = (float)Lua.lua_tonumber(L, 1);
				float to2 = (float)Lua.lua_tonumber(L, 2);
				float lifetimePercentage2 = (float)Lua.lua_tonumber(L, 3);
				AnimationCurve easeCurve = (AnimationCurve)objectTranslator.GetObject(L, 4, typeof(AnimationCurve));
				float num3 = DOVirtual.EasedValue(from2, to2, lifetimePercentage2, easeCurve);
				Lua.lua_pushnumber(L, num3);
				return 1;
			}
			if (num == 5 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 2) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 3) && objectTranslator.Assignable<Ease>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5))
			{
				float from3 = (float)Lua.lua_tonumber(L, 1);
				float to3 = (float)Lua.lua_tonumber(L, 2);
				float lifetimePercentage3 = (float)Lua.lua_tonumber(L, 3);
				objectTranslator.Get(L, 4, out Ease val2);
				float num4 = DOVirtual.EasedValue(overshoot: (float)Lua.lua_tonumber(L, 5), from: from3, to: to3, lifetimePercentage: lifetimePercentage3, easeType: val2);
				Lua.lua_pushnumber(L, num4);
				return 1;
			}
			if (num == 6 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 2) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 3) && objectTranslator.Assignable<Ease>(L, 4) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 5) && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 6))
			{
				float from4 = (float)Lua.lua_tonumber(L, 1);
				float to4 = (float)Lua.lua_tonumber(L, 2);
				float lifetimePercentage4 = (float)Lua.lua_tonumber(L, 3);
				objectTranslator.Get(L, 4, out Ease val3);
				float num5 = DOVirtual.EasedValue(amplitude: (float)Lua.lua_tonumber(L, 5), period: (float)Lua.lua_tonumber(L, 6), from: from4, to: to4, lifetimePercentage: lifetimePercentage4, easeType: val3);
				Lua.lua_pushnumber(L, num5);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to DG.Tweening.DOVirtual.EasedValue!");
	}

	[MonoPInvokeCallback(typeof(lua_CSFunction))]
	private static int _m_DelayedCall_xlua_st_(IntPtr L)
	{
		try
		{
			ObjectTranslator objectTranslator = ObjectTranslatorPool.Instance.Find(L);
			int num = Lua.lua_gettop(L);
			if (num == 3 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && objectTranslator.Assignable<TweenCallback>(L, 2) && LuaTypes.LUA_TBOOLEAN == Lua.lua_type(L, 3))
			{
				float delay = (float)Lua.lua_tonumber(L, 1);
				TweenCallback @delegate = objectTranslator.GetDelegate<TweenCallback>(L, 2);
				bool ignoreTimeScale = Lua.lua_toboolean(L, 3);
				Tween o = DOVirtual.DelayedCall(delay, @delegate, ignoreTimeScale);
				objectTranslator.Push(L, o);
				return 1;
			}
			if (num == 2 && LuaTypes.LUA_TNUMBER == Lua.lua_type(L, 1) && objectTranslator.Assignable<TweenCallback>(L, 2))
			{
				float delay2 = (float)Lua.lua_tonumber(L, 1);
				TweenCallback delegate2 = objectTranslator.GetDelegate<TweenCallback>(L, 2);
				Tween o2 = DOVirtual.DelayedCall(delay2, delegate2);
				objectTranslator.Push(L, o2);
				return 1;
			}
		}
		catch (Exception ex)
		{
			return Lua.luaL_error(L, "c# exception:" + ex);
		}
		return Lua.luaL_error(L, "invalid arguments to DG.Tweening.DOVirtual.DelayedCall!");
	}
}
