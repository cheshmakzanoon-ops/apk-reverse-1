namespace Leopotam.EcsLite.Di;

public struct EcsFilterInject<TInc> : IEcsDataInject where TInc : struct, IEcsInclude
{
	public EcsFilter Value;

	public TInc Pools;

	private string _worldName;

	public static implicit operator EcsFilterInject<TInc>(string worldName)
	{
		EcsFilterInject<TInc> result = default(EcsFilterInject<TInc>);
		result._worldName = worldName;
		return result;
	}

	void IEcsDataInject.Fill(IEcsSystems systems)
	{
		Pools = default(TInc);
		Value = Pools.Fill(systems.GetWorld(_worldName)).End();
	}
}
public struct EcsFilterInject<TInc, TExc> : IEcsDataInject where TInc : struct, IEcsInclude where TExc : struct, IEcsExclude
{
	public EcsFilter Value;

	public TInc Pools;

	private string _worldName;

	public static implicit operator EcsFilterInject<TInc, TExc>(string worldName)
	{
		EcsFilterInject<TInc, TExc> result = default(EcsFilterInject<TInc, TExc>);
		result._worldName = worldName;
		return result;
	}

	void IEcsDataInject.Fill(IEcsSystems systems)
	{
		Pools = default(TInc);
		Value = default(TExc).Fill(Pools.Fill(systems.GetWorld(_worldName))).End();
	}
}
