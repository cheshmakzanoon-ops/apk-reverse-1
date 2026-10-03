using Box2DSharp.Common;
using Leopotam.EcsLite;
using Leopotam.EcsLite.Di;
using MiniGame.Core;

namespace MiniGame.GGGo;

public class SystemMoveRestriction : IEcsRunSystem, IEcsSystem
{
	private readonly EcsWorldInject _world;

	private readonly EcsSharedInject<GGGoEnv> _env;

	protected readonly EcsFilterInject<Inc<ComponentPlayer, ComponentPosition>, Exc<ComponentStatic>> _filter;

	protected readonly EcsPoolInject<ComponentPosition> _poolPos;

	protected readonly EcsPoolInject<ComponentVelocity> _poolVel;

	protected readonly EcsPoolInject<ComponentCollider> _poolCol;

	public void Run(IEcsSystems systems)
	{
		FP y = _env.Value.Distance;
		FP minYWithOffset = _env.Value.Level.RangeVertical.X + y;
		FP maxYWithOffset = _env.Value.Level.RangeVertical.Y + y;
		FP x = _env.Value.Level.RangeHorizon.X;
		FP y2 = _env.Value.Level.RangeHorizon.Y;
		CheckRange(x, y2, minYWithOffset, maxYWithOffset);
	}

	private void CheckRange(FP minX, FP maxX, FP minYWithOffset, FP maxYWithOffset)
	{
		EcsWorld value = _world.Value;
		foreach (int item in _filter.Value)
		{
			ref ComponentPosition reference = ref _poolPos.Value.Get(item);
			FVector2 position = reference.Position;
			FP y = FP.Zero;
			FP y2 = FP.Zero;
			FP y3 = FP.Zero;
			FP y4 = FP.Zero;
			if (_poolCol.Value.Has(item))
			{
				ref ComponentCollider reference2 = ref _poolCol.Value.Get(item);
				y = reference2.HalfSize.X;
				y2 = reference2.HalfSize.Y;
				y3 = reference2.Offset.X;
				y4 = reference2.Offset.Y;
			}
			FP x = minX + y;
			FP fP = x - y3;
			x = maxX - y;
			FP fP2 = x - y3;
			if (position.X < fP)
			{
				position.X = fP;
				reference.Position = position;
			}
			else if (position.X > fP2)
			{
				position.X = fP2;
				reference.Position = position;
			}
			x = position.Y + y4;
			FP fP3 = x + y2;
			if (fP3 < minYWithOffset)
			{
				FuncEvent.Broadcast(value, new EventFallOutCollection(value.PackEntity(item)));
			}
			else
			{
				if (!(fP3 > maxYWithOffset))
				{
					continue;
				}
				x = maxYWithOffset - y4;
				position.Y = x - y2;
				reference.Position = position;
				if (_poolVel.Value.Has(item))
				{
					ref ComponentVelocity reference3 = ref _poolVel.Value.Get(item);
					x = _env.Value.RollSpeed / FP._0_9;
					FP fP4 = x - FP.One;
					if (reference3.Velocity.Y > fP4)
					{
						reference3.Velocity.Y = fP4;
					}
					FuncBuff.AddBuff(value, item, BuffId.Ghost, FP.Abs(FP.One / _env.Value.RollSpeed));
				}
				FuncEvent.Broadcast(value, new EventHitTopCollection(value.PackEntity(item)));
			}
		}
	}
}
