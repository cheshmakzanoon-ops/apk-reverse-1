using System;
using Unity.Mathematics;

[Serializable]
public struct MinMaxAABB : IEquatable<MinMaxAABB>
{
	public float3 Min;

	public float3 Max;

	public bool IsEmpty => Equals(Empty);

	public static MinMaxAABB Empty
	{
		get
		{
			MinMaxAABB result = default(MinMaxAABB);
			result.Min = math.float3(float.PositiveInfinity);
			result.Max = math.float3(float.NegativeInfinity);
			return result;
		}
	}

	public void Encapsulate(MinMaxAABB aabb)
	{
		Min = math.min(Min, aabb.Min);
		Max = math.max(Max, aabb.Max);
	}

	public void Encapsulate(float3 point)
	{
		Min = math.min(Min, point);
		Max = math.max(Max, point);
	}

	public static implicit operator MinMaxAABB(AABB aabb)
	{
		MinMaxAABB result = default(MinMaxAABB);
		result.Min = aabb.Center - aabb.Extents;
		result.Max = aabb.Center + aabb.Extents;
		return result;
	}

	public static implicit operator AABB(MinMaxAABB aabb)
	{
		AABB result = default(AABB);
		result.Center = (aabb.Min + aabb.Max) * 0.5f;
		result.Extents = (aabb.Max - aabb.Min) * 0.5f;
		return result;
	}

	public bool Equals(MinMaxAABB other)
	{
		if (Min.Equals(other.Min))
		{
			return Max.Equals(other.Max);
		}
		return false;
	}
}
