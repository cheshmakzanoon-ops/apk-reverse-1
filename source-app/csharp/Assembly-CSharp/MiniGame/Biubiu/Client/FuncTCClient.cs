using System;
using System.Collections.Generic;
using Box2DSharp.Foreign;
using Leopotam.EcsLite;
using MiniGame.Core;
using UnityEngine;

namespace MiniGame.Biubiu.Client;

public static class FuncTCClient
{
	private static bool InitTC;

	public static void InitAction()
	{
		if (!InitTC)
		{
			Dictionary<Type, Action<EcsWorld, int, IAction, IEvent>> actionDict = FuncAction.ActionDict;
			Type typeFromHandle = typeof(RefreshUIAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoRefreshFireUIAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(TriggerStateChangeAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoTriggerStateChangeAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(TriggerType2StateChangeAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoTriggerType2StateChangeAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(EffectAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoEffectAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(UIEntityAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoUIEntityAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(BombAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoBombAction));
			actionDict = FuncAction.ActionDict;
			typeFromHandle = typeof(GameWaitAction);
			actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Combine(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoGameWaitAction));
			InitTC = true;
		}
	}

	public static void ClearAction()
	{
		Dictionary<Type, Action<EcsWorld, int, IAction, IEvent>> actionDict = FuncAction.ActionDict;
		Type typeFromHandle = typeof(RefreshUIAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoRefreshFireUIAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(TriggerStateChangeAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoTriggerStateChangeAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(TriggerType2StateChangeAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoTriggerType2StateChangeAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(EffectAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoEffectAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(UIEntityAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoUIEntityAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(BombAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoBombAction));
		actionDict = FuncAction.ActionDict;
		typeFromHandle = typeof(GameWaitAction);
		actionDict[typeFromHandle] = (Action<EcsWorld, int, IAction, IEvent>)Delegate.Remove(actionDict[typeFromHandle], new Action<EcsWorld, int, IAction, IEvent>(DoGameWaitAction));
		InitTC = false;
	}

	private static void DoTriggerStateChangeAction(EcsWorld world, int entity, IAction action, IEvent e)
	{
		EGameType gameType = world.GetShared<SharedRuntime>().GameType;
		if (gameType == EGameType.PveServer || gameType == EGameType.PvpServer)
		{
			return;
		}
		EcsPool<ComponentPrefabClient> pool = world.GetPool<ComponentPrefabClient>();
		if (pool.Has(entity))
		{
			GameObject prefab = pool.Get(entity).GetPrefab();
			if (prefab != null)
			{
				ref ComponentRotation reference = ref world.GetPool<ComponentRotation>().Get(entity);
				prefab.transform.eulerAngles = new Vector3(0f, 0f, reference.Rotation.AsFloat);
			}
			if (e is EventTrigger { TriggerSource: not 1 })
			{
				FuncUI.FireRender(default(DataUIRenderMessage.UICameraShake), world);
			}
		}
	}

	private static void DoTriggerType2StateChangeAction(EcsWorld world, int entity, IAction action, IEvent e)
	{
		EGameType gameType = world.GetShared<SharedRuntime>().GameType;
		if (gameType != EGameType.PveServer && gameType != EGameType.PvpServer && e is EventTrigger { TriggerSource: not 1 })
		{
			FuncUI.FireRender(default(DataUIRenderMessage.UICameraShake), world);
		}
	}

	private static void DoRefreshFireUIAction(EcsWorld world, int entity, IAction action, IEvent e)
	{
		SharedRuntime shared = world.GetShared<SharedRuntime>();
		EGameType gameType = shared.GameType;
		if (gameType == EGameType.PveServer || gameType == EGameType.PvpServer)
		{
			return;
		}
		RefreshUIAction refreshUIAction = ((action is RefreshUIAction) ? ((RefreshUIAction)(object)action) : default(RefreshUIAction));
		ref MiniGame.Biubiu.ComponentUIClient clientUI = ref FuncUI.GetClientUI(shared, world);
		if (refreshUIAction.UIState == RefreshUIAction.RefreshUIType.Fire)
		{
			EcsPackedEntity packed = e.Sender;
			packed.Unpack(world, out var entity2);
			EcsPool<ComponentPlayer> pool = world.GetPool<ComponentPlayer>();
			EcsPool<ComponentControllerClient> pool2 = world.GetPool<ComponentControllerClient>();
			if (!pool.Has(entity2) || !pool2.Has(entity2))
			{
				return;
			}
			ref ComponentPlayer reference = ref pool.Get(entity2);
			DataUIPlayerController controller = pool2.Get(entity2).GetController(world, entity2);
			DataUIAdapt uIAdapt = clientUI.GetUIAdapt();
			if (uIAdapt == null)
			{
				return;
			}
			float leftTime = uIAdapt.GetLeftTime();
			bool flag = reference.PlayerID == shared.InitData.PlayerID;
			DataUIRenderMessage.UIEntityAction uIEntityAction = default(DataUIRenderMessage.UIEntityAction);
			uIEntityAction.IsMe = flag;
			uIEntityAction.Controller = controller;
			uIEntityAction.FireCdTime = leftTime;
			uIEntityAction.ActionType = 2;
			FuncUI.FireRender(uIEntityAction, world);
			if (flag)
			{
				if (uIAdapt.GetGunInfo().Item1 == 10)
				{
					uIAdapt.FireRender(new DataUIRenderMessage.UIEntityAction
					{
						IsMe = true,
						Controller = controller,
						ActionType = 4
					}, world);
				}
				else
				{
					clientUI.GetUIAdapt().RefreshUIShow();
				}
			}
		}
		else if (refreshUIAction.UIState == RefreshUIAction.RefreshUIType.HpChange)
		{
			clientUI.GetUIAdapt().RefreshUIShow();
		}
	}

	public static void DoSettlementAction(EcsWorld world)
	{
		SharedRuntime shared = world.GetShared<SharedRuntime>();
		EGameType gameType = shared.GameType;
		if (gameType != EGameType.PveClient && gameType != EGameType.PvpClient)
		{
			return;
		}
		if (FuncUI.GetClientUI(world.GetShared<SharedRuntime>(), world).GetUIAdapt().TryGetUIResult(out var result))
		{
			EcsFilter ecsFilter = world.Filter<ComponentPlayer>().Inc<ComponentControllerClient>().End();
			EcsPool<ComponentPlayer> pool = world.GetPool<ComponentPlayer>();
			EcsPool<ComponentControllerClient> pool2 = world.GetPool<ComponentControllerClient>();
			foreach (int item in ecsFilter)
			{
				ref ComponentPlayer reference = ref pool.Get(item);
				DataUIPlayerController controller = pool2.Get(item).GetController(world, item);
				bool isMe = reference.PlayerID == shared.InitData.PlayerID;
				int result2 = ((result.WinPlayerID != reference.PlayerID) ? 1 : 0);
				if (result.Result != 0)
				{
					result2 = 2;
				}
				DataUIRenderMessage.UIEntityAction uIEntityAction = default(DataUIRenderMessage.UIEntityAction);
				uIEntityAction.IsMe = isMe;
				uIEntityAction.Controller = controller;
				uIEntityAction.ActionType = 3;
				uIEntityAction.Result = result2;
				FuncUI.FireRender(uIEntityAction, world);
			}
			FuncUI.FireRender(result, world);
		}
		FuncPostLog.PostBattleResult(shared, result);
	}

	internal static void DoEffectAction(EcsWorld world, int entity, IAction arg3, IEvent e)
	{
		SharedRuntime shared = world.GetShared<SharedRuntime>();
		EGameType gameType = shared.GameType;
		if (gameType == EGameType.PveServer || gameType == EGameType.PvpServer)
		{
			return;
		}
		EffectAction effectAction = ((arg3 is EffectAction) ? ((EffectAction)(object)arg3) : default(EffectAction));
		if (!(e is EventPhysicCollection eventPhysicCollection))
		{
			return;
		}
		Quaternion rotation = Quaternion.identity;
		bool isMe = true;
		if (effectAction.EEffectType == EffectAction.EffectType.BulletWall)
		{
			Vector3 vector = eventPhysicCollection.Manifold.Normal.ToUnityVector3();
			float z = Mathf.Atan2(vector.y, vector.x) * 57.29578f;
			rotation = Quaternion.Euler(0f, 0f, z);
			int entity2 = -1;
			if (eventPhysicCollection.SenderLayer == 4)
			{
				EcsPackedEntity packed = eventPhysicCollection.Sender;
				packed.Unpack(world, out entity2);
			}
			else
			{
				EcsPackedEntity packed = eventPhysicCollection.Target;
				packed.Unpack(world, out entity2);
			}
			if (entity2 != -1)
			{
				EcsPool<ComponentPhysics> pool = world.GetPool<ComponentPhysics>();
				if (world.IsEntityAliveInternal(entity2) && pool.Has(entity2) && pool.Get(entity2).Body.UserData is IBodyLogic bodyLogic)
				{
					EcsPool<ComponentPlayer> pool2 = world.GetPool<ComponentPlayer>();
					if (pool2.Has(bodyLogic.OwnerID))
					{
						isMe = pool2.Get(bodyLogic.OwnerID).PlayerID == shared.InitData.PlayerID;
					}
				}
			}
		}
		Vector3 vector2 = eventPhysicCollection.Manifold.Points[0].ToUnityVector3();
		GameLoader gameLoader = (GameLoader)shared.ResourceLoader;
		float num = 1f / gameLoader.LoaderEnv.SizeToUnit;
		DataUIRenderMessage.UIEffect uIEffect = default(DataUIRenderMessage.UIEffect);
		uIEffect.IsMe = isMe;
		uIEffect.EffectType = (int)effectAction.EEffectType;
		uIEffect.Position = vector2 * num;
		uIEffect.Rotation = rotation;
		uIEffect.Parent = ((GameLoader)shared.ResourceLoader).LoaderEnv.DynamicRoot.transform;
		FuncUI.FireRender(uIEffect, world);
	}

	private static void DoUIEntityAction(EcsWorld world, int entity, IAction arg3, IEvent e)
	{
		EGameType gameType = world.GetShared<SharedRuntime>().GameType;
		if (gameType == EGameType.PveServer || gameType == EGameType.PvpServer)
		{
			return;
		}
		UIEntityAction uIEntityAction = ((arg3 is UIEntityAction) ? ((UIEntityAction)(object)arg3) : default(UIEntityAction));
		EcsPool<ComponentPrefabClient> pool = world.GetPool<ComponentPrefabClient>();
		EcsPackedEntity packed = e.Sender;
		packed.Unpack(world, out var entity2);
		if (pool.Has(entity2))
		{
			GameObject prefab = pool.Get(entity2).GetPrefab();
			if (prefab != null)
			{
				DataUIRenderMessage.UIEntityAction uIEntityAction2 = default(DataUIRenderMessage.UIEntityAction);
				uIEntityAction2.ActionType = (int)uIEntityAction.Type;
				uIEntityAction2.Controller = prefab.GetComponentInChildren<DataUIEntityController>();
				FuncUI.FireRender(uIEntityAction2, world);
			}
		}
	}

	private static void DoBombAction(EcsWorld world, int entity, IAction arg3, IEvent e)
	{
		SharedRuntime shared = world.GetShared<SharedRuntime>();
		EGameType gameType = shared.GameType;
		if (gameType != EGameType.PveServer && gameType != EGameType.PvpServer)
		{
			EcsPool<ComponentPhysics> pool = world.GetPool<ComponentPhysics>();
			if (pool.Has(entity))
			{
				ref ComponentPhysics reference = ref pool.Get(entity);
				GameLoader gameLoader = (GameLoader)shared.ResourceLoader;
				float num = 1f / gameLoader.LoaderEnv.SizeToUnit;
				DataUIRenderMessage.UIEffect uIEffect = default(DataUIRenderMessage.UIEffect);
				uIEffect.EffectType = 3;
				uIEffect.Position = reference.Body.GetPosition().ToUnityVector3() * num;
				uIEffect.Rotation = Quaternion.identity;
				uIEffect.Parent = ((GameLoader)shared.ResourceLoader).LoaderEnv.DynamicRoot.transform;
				FuncUI.FireRender(uIEffect, world);
			}
		}
	}

	private static void DoGameWaitAction(EcsWorld world, int entity, IAction arg3, IEvent e)
	{
		SharedRuntime shared = world.GetShared<SharedRuntime>();
		EGameType gameType = shared.GameType;
		if (gameType != EGameType.PveServer && gameType != EGameType.PvpServer && gameType != EGameType.PveClient && !shared.InitData.ReEnter)
		{
			DataUIRenderMessage.UIWait uIWait = default(DataUIRenderMessage.UIWait);
			uIWait.PlayerID = (int)shared.InitData.PlayerID;
			FuncUI.FireRender(uIWait, world);
		}
	}
}
