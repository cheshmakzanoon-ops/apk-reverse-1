using System.Collections.Generic;
using Box2DSharp.Common;
using Leopotam.EcsLite;
using MiniGame.Core;
using MiniGame.Core.Client;
using UnityEngine;

namespace MiniGame.GGGo.Client;

public class MiniBox2DGame
{
	public float Scale;

	private GameUnityRuntime _gameUnityRuntime;

	private readonly List<ComponentRegion> _sortedRegions = new List<ComponentRegion>();

	public EcsWorld World { get; set; }

	public void DebugDraw()
	{
		if (World != null)
		{
			GGGoEnvClient shared = World.GetShared<GGGoEnvClient>();
			DrawColliders(shared);
			DrawTriggers(shared);
			DrawRegions(shared);
			DrawRange(shared);
		}
	}

	private FVector2 ToDrawPos(in FVector2 worldPos)
	{
		ref readonly FP x = ref worldPos.X;
		FP y = Scale;
		FP x2 = x * y;
		ref readonly FP y2 = ref worldPos.Y;
		FP y3 = Scale;
		return new FVector2(x2, y2 * y3);
	}

	private FVector2 ToDrawSize(in FVector2 worldHalfSize)
	{
		ref readonly FP x = ref worldHalfSize.X;
		FP y = Scale;
		FP x2 = x * y;
		ref readonly FP y2 = ref worldHalfSize.Y;
		FP y3 = Scale;
		return new FVector2(x2, y2 * y3);
	}

	private static void DrawRectGizmos(in FVector2 worldCenter, in FVector2 halfSize, in UnityEngine.Color color, float z = 0f)
	{
		Gizmos.color = color;
		Vector3 center = new Vector3((float)worldCenter.X, (float)worldCenter.Y, 0f);
		ref readonly FP x = ref halfSize.X;
		FP y = 2;
		float x2 = (float)(x * y);
		ref readonly FP y2 = ref halfSize.Y;
		FP y3 = 2;
		Gizmos.DrawWireCube(center, new Vector3(x2, (float)(y2 * y3), z));
	}

	private static void DrawLabel(in FVector2 worldPos, string text, in UnityEngine.Color color)
	{
	}

	private void DrawColliders(GGGoEnvClient env)
	{
		EcsPool<ComponentPosition> pool = World.GetPool<ComponentPosition>();
		EcsPool<ComponentCollider> pool2 = World.GetPool<ComponentCollider>();
		foreach (int item in World.Filter<ComponentCollider>().End())
		{
			ref ComponentPosition reference = ref pool.Get(item);
			ref ComponentCollider reference2 = ref pool2.Get(item);
			FVector2 worldPos = reference.Position + reference2.Offset;
			FVector2 worldCenter = ToDrawPos(in worldPos);
			FVector2 halfSize = ToDrawSize(in reference2.HalfSize);
			UnityEngine.Color color = UnityEngine.Color.green;
			DrawRectGizmos(in worldCenter, in halfSize, in color);
		}
	}

	private void DrawTriggers(GGGoEnvClient env)
	{
		EcsPool<ComponentPosition> pool = World.GetPool<ComponentPosition>();
		EcsPool<ComponentColliderTrigger> pool2 = World.GetPool<ComponentColliderTrigger>();
		foreach (int item in World.Filter<ComponentColliderTrigger>().End())
		{
			ref ComponentPosition reference = ref pool.Get(item);
			ref ComponentColliderTrigger reference2 = ref pool2.Get(item);
			FVector2 worldPos = reference.Position + reference2.Offset;
			FVector2 worldCenter = ToDrawPos(in worldPos);
			FVector2 halfSize = ToDrawSize(in reference2.HalfSize);
			UnityEngine.Color color = UnityEngine.Color.yellow;
			DrawRectGizmos(in worldCenter, in halfSize, in color);
		}
	}

	private void DrawRange(GGGoEnvClient env)
	{
		if (_gameUnityRuntime == null)
		{
			_gameUnityRuntime = env.Scene.gameObject.GetComponentInParent<GameUnityRuntime>();
		}
		GGGoLevelConfig level = env.Level;
		FP x = level.RangeHorizon.X;
		FP y = level.RangeHorizon.Y;
		FP y2 = env.Distance;
		FP x2 = level.RangeVertical.X + y2;
		FP y3 = level.RangeVertical.Y + y2;
		FVector2 worldPos = new FVector2((x + y) / 2, (x2 + y3) / 2);
		FVector2 worldHalfSize = new FVector2((y - x) / 2, (y3 - x2) / 2);
		FVector2 worldCenter = ToDrawPos(in worldPos);
		FVector2 halfSize = ToDrawSize(in worldHalfSize);
		UnityEngine.Color color = UnityEngine.Color.red;
		DrawRectGizmos(in worldCenter, in halfSize, in color);
	}

	private void DrawRegions(GGGoEnvClient env)
	{
		if (env == null)
		{
			return;
		}
		EcsPool<ComponentRegion> pool = World.GetPool<ComponentRegion>();
		EcsPool<ComponentUniqueID> pool2 = World.GetPool<ComponentUniqueID>();
		EcsFilter ecsFilter = World.Filter<ComponentRegion>().End();
		if (ecsFilter.GetEntitiesCount() <= 0)
		{
			return;
		}
		GGGoLevelConfig level = env.Level;
		FP y = level.RangeHorizon.X;
		FP x = level.RangeHorizon.Y;
		FP x2 = (x - y) / 2;
		FP x3 = (y + x) / 2;
		UnityEngine.Color color = UnityEngine.Color.cyan;
		_sortedRegions.Clear();
		foreach (int item in ecsFilter)
		{
			ref ComponentRegion reference = ref pool.Get(item);
			_sortedRegions.Add(reference);
		}
		_sortedRegions.Sort((ComponentRegion a, ComponentRegion b) => b.StartPos.CompareTo(a.StartPos));
		int num = 0;
		foreach (int item2 in ecsFilter)
		{
			ref ComponentRegion reference2 = ref pool.Get(item2);
			FP x4 = reference2.StartPos;
			FP y2 = reference2.StartPos - reference2.Length;
			FP y3 = (x4 + y2) / 2;
			FP y4 = FP.Abs(x4 - y2) / 2;
			FVector2 worldPos = new FVector2(x3, y3);
			FVector2 worldHalfSize = new FVector2(x2, y4);
			FVector2 worldCenter = ToDrawPos(in worldPos);
			FVector2 halfSize = ToDrawSize(in worldHalfSize);
			DrawRectGizmos(in worldCenter, in halfSize, in color);
			FVector2 worldPos2 = new FVector2(x, x4);
			string text = $"Region#{num}  startY={x4}  len={reference2.Length}  speed={reference2.Speed}";
			if (pool2.Has(item2))
			{
				ref ComponentUniqueID reference3 = ref pool2.Get(item2);
				text += "\nuid:";
				if (reference3.ID > 0)
				{
					text += $"  id={reference3.ID}";
				}
				if (!string.IsNullOrEmpty(reference3.Name))
				{
					text = text + "  Name=" + reference3.Name;
				}
			}
			worldCenter = ToDrawPos(in worldPos2);
			DrawLabel(in worldCenter, text, in color);
			num++;
		}
	}
}
