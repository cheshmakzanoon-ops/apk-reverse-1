using Box2DSharp.Common;
using Leopotam.EcsLite;
using Leopotam.EcsLite.Di;
using MiniGame.Core;

namespace MiniGame.Biubiu.Client;

public class SystemClientPrefabMovablePredictionSimulate : SystemClientPrefabMovablePrediction
{
	private readonly EcsPoolInject<ComponentPhysicsWorldSimulate> _poolPhysicsWorldSimulate;

	private readonly EcsPoolInject<ComponentPhysicsSimulate> _poolPhysicsSimulate;

	protected override int GetPredictionStep()
	{
		EcsPackedEntity packed = _shared.Value.PhysicsWorld;
		packed.Unpack(_poolPhysicsSimulate.Value.GetWorld(), out var entity);
		return _poolPhysicsWorldSimulate.Value.Get(entity).SimulatePhysicsFrame;
	}

	protected override bool Prediction(int entity, int step, float time)
	{
		ComponentPhysicsSimulate componentPhysicsSimulate = _poolPhysicsSimulate.Value.Get(entity);
		FVector2 vector = componentPhysicsSimulate.Body.GetPosition();
		FloatVector3 pos = vector.ToCSharpVector3();
		vector = componentPhysicsSimulate.Body.LinearVelocity;
		FloatVector3 vec = vector.ToCSharpVector3();
		return Prediction(entity, step, time, pos, vec);
	}
}
