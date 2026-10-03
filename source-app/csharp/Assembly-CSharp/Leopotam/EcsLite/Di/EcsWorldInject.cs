namespace Leopotam.EcsLite.Di;

public struct EcsWorldInject : IEcsDataInject
{
	public EcsWorld Value;

	private string _worldName;

	public static implicit operator EcsWorldInject(string worldName)
	{
		EcsWorldInject result = default(EcsWorldInject);
		result._worldName = worldName;
		return result;
	}

	void IEcsDataInject.Fill(IEcsSystems systems)
	{
		Value = systems.GetWorld(_worldName);
	}
}
