using Box2DSharp.Common;
using Leopotam.EcsLite;
using Leopotam.EcsLite.Di;
using MiniGame.Core;
using MiniGame.Test.Client;
using UnityEngine;

namespace MiniGame.Test;

public class SystemPrepare : IEcsRunSystem, IEcsSystem
{
	private EcsSharedInject<GameTestEnvClient> _share;

	public void Run(IEcsSystems systems)
	{
		GameTestEnvClient value = _share.Value;
		ref FP prepareTime = ref value.PrepareTime;
		FP y = Time.deltaTime;
		value.PrepareTime = prepareTime + y;
		if (_share.Value.PrepareTime > 1)
		{
			_share.Value.GameState = EGameWorldState.Running;
		}
	}
}
