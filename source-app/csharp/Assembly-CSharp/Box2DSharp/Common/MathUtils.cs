using System.Runtime.CompilerServices;

namespace Box2DSharp.Common;

public static class MathUtils
{
	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FP Cross(in FVector2 a, in FVector2 b)
	{
		FP x = a.X * b.Y;
		FP y = a.Y * b.X;
		return x - y;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Cross(in FVector2 a, FP s)
	{
		FP x = s * a.Y;
		FP x2 = -s;
		return new FVector2(x, x2 * a.X);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Cross(FP s, in FVector2 a)
	{
		FP x = -s;
		return new FVector2(x * a.Y, s * a.X);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Mul(in Matrix2x2 m, in FVector2 v)
	{
		FP x = m.Ex.X * v.X;
		FP y = m.Ey.X * v.Y;
		FP x2 = x + y;
		FP x3 = m.Ex.Y * v.X;
		FP y2 = m.Ey.Y * v.Y;
		return new FVector2(x2, x3 + y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 MulT(in Matrix2x2 m, in FVector2 v)
	{
		return new FVector2(FVector2.Dot(v, m.Ex), FVector2.Dot(v, m.Ey));
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Matrix2x2 Mul(in Matrix2x2 a, in Matrix2x2 b)
	{
		FVector2 c = Mul(in a, in b.Ex);
		FVector2 c2 = Mul(in a, in b.Ey);
		return new Matrix2x2(in c, in c2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Matrix2x2 MulT(in Matrix2x2 a, in Matrix2x2 b)
	{
		FVector2 c = new FVector2(FVector2.Dot(a.Ex, b.Ex), FVector2.Dot(a.Ey, b.Ex));
		FVector2 c2 = new FVector2(FVector2.Dot(a.Ex, b.Ey), FVector2.Dot(a.Ey, b.Ey));
		return new Matrix2x2(in c, in c2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector3 Mul(in Matrix3x3 m, in FVector3 v)
	{
		return v.X * m.Ex + v.Y * m.Ey + v.Z * m.Ez;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Mul22(in Matrix3x3 m, in FVector2 v)
	{
		FP x = m.Ex.X * v.X;
		FP y = m.Ey.X * v.Y;
		FP x2 = x + y;
		FP x3 = m.Ex.Y * v.X;
		FP y2 = m.Ey.Y * v.Y;
		return new FVector2(x2, x3 + y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Rotation Mul(in Rotation q, in Rotation r)
	{
		FP x = q.Sin * r.Cos;
		FP y = q.Cos * r.Sin;
		FP sin = x + y;
		FP x2 = q.Cos * r.Cos;
		FP y2 = q.Sin * r.Sin;
		return new Rotation(sin, x2 - y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Rotation MulT(in Rotation q, in Rotation r)
	{
		FP x = q.Cos * r.Sin;
		FP y = q.Sin * r.Cos;
		FP sin = x - y;
		FP x2 = q.Cos * r.Cos;
		FP y2 = q.Sin * r.Sin;
		return new Rotation(sin, x2 + y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Mul(in Rotation q, in FVector2 v)
	{
		FP x = q.Cos * v.X;
		FP y = q.Sin * v.Y;
		FP x2 = x - y;
		FP x3 = q.Sin * v.X;
		FP y2 = q.Cos * v.Y;
		return new FVector2(x2, x3 + y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 MulT(in Rotation q, in FVector2 v)
	{
		FP x = q.Cos * v.X;
		FP y = q.Sin * v.Y;
		FP x2 = x + y;
		FP x3 = -q.Sin;
		FP x4 = x3 * v.X;
		FP y2 = q.Cos * v.Y;
		return new FVector2(x2, x4 + y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 Mul(in Transform T, in FVector2 v)
	{
		FP x = T.Rotation.Cos * v.X;
		FP y = T.Rotation.Sin * v.Y;
		FP x2 = x - y;
		FP x3 = x2 + T.Position.X;
		x = T.Rotation.Sin * v.X;
		y = T.Rotation.Cos * v.Y;
		x2 = x + y;
		FP y2 = x2 + T.Position.Y;
		return new FVector2(x3, y2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FVector2 MulT(in Transform T, in FVector2 v)
	{
		FP y = v.X - T.Position.X;
		FP y2 = v.Y - T.Position.Y;
		FP x = T.Rotation.Cos * y;
		FP y3 = T.Rotation.Sin * y2;
		FP x2 = x + y3;
		FP x3 = -T.Rotation.Sin;
		FP x4 = x3 * y;
		FP y4 = T.Rotation.Cos * y2;
		return new FVector2(x2, x4 + y4);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Transform Mul(in Transform A, in Transform B)
	{
		FVector2 position = Mul(in A.Rotation, in B.Position) + A.Position;
		Rotation rotation = Mul(in A.Rotation, in B.Rotation);
		return new Transform(in position, in rotation);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Transform MulT(in Transform A, in Transform B)
	{
		ref readonly Rotation rotation = ref A.Rotation;
		FVector2 v = B.Position - A.Position;
		FVector2 position = MulT(in rotation, in v);
		Rotation rotation2 = MulT(in A.Rotation, in B.Rotation);
		return new Transform(in position, in rotation2);
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FP Clamp(FP a, FP low, FP high)
	{
		if (!(a < low))
		{
			if (!(a > high))
			{
				return a;
			}
			return high;
		}
		return low;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static FP SmothStep(FP left, FP right, FP value)
	{
		FP x = Clamp((value - left) / (right - left), 0, 1f);
		FP x2 = x * x;
		FP x3 = 3;
		FP x4 = 2;
		FP y = x4 * x;
		FP y2 = x3 - y;
		return x2 * y2;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static void Swap<T>(ref T a, ref T b)
	{
		T val = a;
		a = b;
		b = val;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static uint NextPowerOfTwo(uint x)
	{
		x |= x >> 1;
		x |= x >> 2;
		x |= x >> 4;
		x |= x >> 8;
		x |= x >> 16;
		return x + 1;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static bool IsPowerOfTwo(uint x)
	{
		if (x != 0)
		{
			return (x & (x - 1)) == 0;
		}
		return false;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static int GetArraySize(int capacity)
	{
		int num = capacity - 1;
		num |= num >> 1;
		num |= num >> 2;
		num |= num >> 4;
		num |= num >> 8;
		num |= num >> 16;
		if (num >= 0)
		{
			return num + 1;
		}
		return 128;
	}
}
