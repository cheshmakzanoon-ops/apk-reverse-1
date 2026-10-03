using Box2DSharp.Common;
using Box2DSharp.Dynamics;
using Leopotam.EcsLite;
using Leopotam.EcsLite.Di;

namespace MiniGame.Biubiu;

public class SystemBulletPhysicsKeepSpeed : IEcsRunSystem, IEcsSystem
{
	private readonly EcsFilterInject<Inc<ComponentBullet, ComponentPhysics>> _filterBullet;

	public void Run(IEcsSystems systems)
	{
		EcsPool<ComponentBullet> inc = _filterBullet.Pools.Inc1;
		EcsPool<ComponentPhysics> inc2 = _filterBullet.Pools.Inc2;
		foreach (int item in _filterBullet.Value)
		{
			ref ComponentPhysics reference = ref inc2.Get(item);
			ref ComponentBullet reference2 = ref inc.Get(item);
			if (reference.Body != null)
			{
				FVector2 linearVelocity = reference.Body.LinearVelocity;
				FP x = linearVelocity.LengthSquared();
				FP y = reference2.Speed * reference2.Speed;
				FP fP = x - y;
				FVector2 value;
				if (fP > FP.EN2 || fP < -FP.EN2)
				{
					Body body = reference.Body;
					value = linearVelocity.normalized * reference2.Speed;
					body.SetLinearVelocity(in value);
				}
				FP angle = FMath.Atan2(reference.Body.LinearVelocity.Y, reference.Body.LinearVelocity.X);
				Body body2 = reference.Body;
				value = reference.Body.GetPosition();
				body2.SetTransform(in value, angle);
			}
		}
	}
}
