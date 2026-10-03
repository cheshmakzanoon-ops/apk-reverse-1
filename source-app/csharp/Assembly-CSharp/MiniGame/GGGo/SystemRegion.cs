using Box2DSharp.Common;
using Leopotam.EcsLite;
using Leopotam.EcsLite.Di;
using MiniGame.Core;

namespace MiniGame.GGGo;

public class SystemRegion : IEcsInitSystem, IEcsSystem, IEcsDestroySystem, IEcsRunSystem
{
	private EcsWorldInject world;

	private readonly EcsSharedInject<GGGoEnv> _env;

	protected readonly EcsFilterInject<Inc<ComponentRegion>> _filterRegion;

	protected readonly EcsFilterInject<Inc<ComponentPosition, ComponentPlayer>> _filterPlayer;

	protected readonly EcsPoolInject<ComponentPosition> _poolPos;

	public void Init(IEcsSystems systems)
	{
		InitPlayerPos();
	}

	public void Destroy(IEcsSystems systems)
	{
	}

	public void Run(IEcsSystems systems)
	{
		Roll();
	}

	private void InitPlayerPos()
	{
		GGGoEnv value = _env.Value;
		if (value == null || value.GameState == EGameWorldState.Settlement)
		{
			return;
		}
		EcsFilter ecsFilter = world.Value.Filter<ComponentPlayer>().End();
		int num = 0;
		if (ecsFilter.GetEntitiesCount() > 1)
		{
			foreach (int item in ecsFilter)
			{
				num++;
				_poolPos.Value.Get(item).Position = ((num == 1) ? new FVector2(-0.6f, -1.5) : new FVector2(0.6f, -1.5));
			}
			return;
		}
		foreach (int item2 in ecsFilter)
		{
			_poolPos.Value.Get(item2).Position = new FVector2(-1.35, -2.6);
		}
	}

	private void Roll()
	{
		FP x = FuncRegion.GetRegionsLastPos(world.Value, out var lastEntity);
		x += _env.Value.Level.RangeVertical.Y;
		if (_env.Value.Distance <= x)
		{
			_env.Value.Distance = x;
			_env.Value.RollSpeed = FP.Zero;
			return;
		}
		if (_filterRegion.Value.GetEntitiesCount() > 0)
		{
			FP lowerPlayerPos = GetLowerPlayerPos();
			FP x2 = FuncRegion.GetCurSpeed(distance: _env.Value.Distance + _env.Value.Level.RangeVertical.X, world: world.Value, entity: out lastEntity);
			GGGoLevelConfig level = _env.Value.Level;
			FP x3 = level.RangeVertical.Y / FP._0_5;
			FP x4 = _env.Value.Distance - level.RangeVertical.Y;
			FP y = x3 * level.LowerBound;
			FP fP = x4 + y;
			if (lowerPlayerPos < fP)
			{
				x2 *= level.LowerBoundSpeedRate;
			}
			_env.Value.RollSpeed = x2;
		}
		if (FuncGame.IsPlaying(world.Value))
		{
			GGGoEnv value = _env.Value;
			ref FP distance2 = ref value.Distance;
			ref FP rollSpeed = ref _env.Value.RollSpeed;
			FP x4 = _env.Value.LogicTickDelta;
			FP y = rollSpeed * x4;
			value.Distance = distance2 + y;
		}
	}

	private FP GetLowerPlayerPos()
	{
		FP fP = FP.MaxValue;
		foreach (int item in _filterPlayer.Value)
		{
			ComponentPosition componentPosition = _poolPos.Value.Get(item);
			if (componentPosition.Position.Y < fP)
			{
				fP = componentPosition.Position.Y;
			}
		}
		return fP;
	}
}
