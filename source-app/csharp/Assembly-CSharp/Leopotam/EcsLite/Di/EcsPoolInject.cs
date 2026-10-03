namespace Leopotam.EcsLite.Di;

public struct EcsPoolInject<T> : IEcsDataInject where T : struct
{
	public EcsPool<T> Value;

	private string _worldName;

	public static implicit operator EcsPoolInject<T>(string worldName)
	{
		EcsPoolInject<T> result = default(EcsPoolInject<T>);
		result._worldName = worldName;
		return result;
	}

	void IEcsDataInject.Fill(IEcsSystems systems)
	{
		Value = systems.GetWorld(_worldName).GetPool<T>();
	}
}
