using System.Runtime.CompilerServices;

namespace Box2DSharp.Common;

public struct Matrix2x2
{
	public FVector2 Ex;

	public FVector2 Ey;

	public Matrix2x2(in FVector2 c1, in FVector2 c2)
	{
		Ex = c1;
		Ey = c2;
	}

	public Matrix2x2(FP a11, FP a12, FP a21, FP a22)
	{
		Ex.X = a11;
		Ex.Y = a21;
		Ey.X = a12;
		Ey.Y = a22;
	}

	public void Set(in FVector2 c1, in FVector2 c2)
	{
		Ex = c1;
		Ey = c2;
	}

	public void SetIdentity()
	{
		Ex.X = 1f;
		Ey.X = 0f;
		Ex.Y = 0f;
		Ey.Y = 1f;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public void SetZero()
	{
		Ex.X = 0f;
		Ey.X = 0f;
		Ex.Y = 0f;
		Ey.Y = 0f;
	}

	public Matrix2x2 GetInverse()
	{
		FP x = Ex.X;
		FP x2 = Ey.X;
		FP y = Ex.Y;
		FP y2 = Ey.Y;
		FP x3 = x * y2;
		FP y3 = x2 * y;
		FP x4 = x3 - y3;
		if (!x4.Equals(0f))
		{
			x4 = 1f / x4;
		}
		Matrix2x2 result = default(Matrix2x2);
		result.Ex.X = x4 * y2;
		ref FVector2 ey = ref result.Ey;
		x3 = -x4;
		ey.X = x3 * x2;
		ref FVector2 ex = ref result.Ex;
		x3 = -x4;
		ex.Y = x3 * y;
		result.Ey.Y = x4 * x;
		return result;
	}

	public FVector2 Solve(in FVector2 b)
	{
		FP x = Ex.X;
		FP x2 = Ey.X;
		FP y = Ex.Y;
		FP y2 = Ey.Y;
		FP x3 = x * y2;
		FP y3 = x2 * y;
		FP x4 = x3 - y3;
		if (x4 != 0)
		{
			x4 = 1f / x4;
		}
		FVector2 result = default(FVector2);
		x3 = y2 * b.X;
		y3 = x2 * b.Y;
		FP y4 = x3 - y3;
		result.X = x4 * y4;
		FP x5 = x * b.Y;
		FP y5 = y * b.X;
		FP y6 = x5 - y5;
		result.Y = x4 * y6;
		return result;
	}

	[MethodImpl(MethodImplOptions.AggressiveInlining)]
	public static Matrix2x2 operator +(in Matrix2x2 A, in Matrix2x2 B)
	{
		FVector2 c = A.Ex + B.Ex;
		FVector2 c2 = A.Ey + B.Ey;
		return new Matrix2x2(in c, in c2);
	}
}
