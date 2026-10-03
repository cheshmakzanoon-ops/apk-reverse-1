namespace Box2DSharp.Common;

public struct Matrix3x3
{
	public FVector3 Ex;

	public FVector3 Ey;

	public FVector3 Ez;

	public Matrix3x3(in FVector3 c1, in FVector3 c2, in FVector3 c3)
	{
		Ex = c1;
		Ey = c2;
		Ez = c3;
	}

	public void SetZero()
	{
		Ex.SetZero();
		Ey.SetZero();
		Ez.SetZero();
	}

	public FVector3 Solve33(in FVector3 b)
	{
		FP x = FVector3.Dot(Ex, FVector3.Cross(Ey, Ez));
		if (!x.Equals(0f))
		{
			x = 1f / x;
		}
		FP y = FVector3.Dot(b, FVector3.Cross(Ey, Ez));
		FVector3 result = default(FVector3);
		result.X = x * y;
		y = FVector3.Dot(Ex, FVector3.Cross(b, Ez));
		result.Y = x * y;
		y = FVector3.Dot(Ex, FVector3.Cross(Ey, b));
		result.Z = x * y;
		return result;
	}

	public FVector2 Solve22(in FVector2 b)
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
		x3 = y2 * b.X;
		y3 = x2 * b.Y;
		FP y4 = x3 - y3;
		FVector2 result = default(FVector2);
		result.X = x4 * y4;
		x3 = x * b.Y;
		y3 = y * b.X;
		y4 = x3 - y3;
		result.Y = x4 * y4;
		return result;
	}

	public void GetInverse22(ref Matrix3x3 matrix3X3)
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
		matrix3X3.Ex.X = x4 * y2;
		ref FVector3 ey = ref matrix3X3.Ey;
		x3 = -x4;
		ey.X = x3 * x2;
		matrix3X3.Ex.Z = 0f;
		ref FVector3 ex = ref matrix3X3.Ex;
		x3 = -x4;
		ex.Y = x3 * y;
		matrix3X3.Ey.Y = x4 * x;
		matrix3X3.Ey.Z = 0f;
		matrix3X3.Ez.X = 0f;
		matrix3X3.Ez.Y = 0f;
		matrix3X3.Ez.Z = 0f;
	}

	public void GetSymInverse33(ref Matrix3x3 matrix3X3)
	{
		FP x = FVector3.Dot(Ex, FVector3.Cross(Ey, Ez));
		if (!x.Equals(0f))
		{
			x = 1f / x;
		}
		FP x2 = Ex.X;
		FP x3 = Ey.X;
		FP x4 = Ez.X;
		FP x5 = Ey.Y;
		FP x6 = Ez.Y;
		FP y = Ez.Z;
		ref FVector3 ex = ref matrix3X3.Ex;
		FP x7 = x5 * y;
		FP y2 = x6 * x6;
		FP y3 = x7 - y2;
		ex.X = x * y3;
		ref FVector3 ex2 = ref matrix3X3.Ex;
		x7 = x4 * x6;
		y2 = x3 * y;
		y3 = x7 - y2;
		ex2.Y = x * y3;
		ref FVector3 ex3 = ref matrix3X3.Ex;
		x7 = x3 * x6;
		y2 = x4 * x5;
		y3 = x7 - y2;
		ex3.Z = x * y3;
		matrix3X3.Ey.X = matrix3X3.Ex.Y;
		ref FVector3 ey = ref matrix3X3.Ey;
		x7 = x2 * y;
		y2 = x4 * x4;
		y3 = x7 - y2;
		ey.Y = x * y3;
		ref FVector3 ey2 = ref matrix3X3.Ey;
		x7 = x4 * x3;
		y2 = x2 * x6;
		y3 = x7 - y2;
		ey2.Z = x * y3;
		matrix3X3.Ez.X = matrix3X3.Ex.Z;
		matrix3X3.Ez.Y = matrix3X3.Ey.Z;
		ref FVector3 ez = ref matrix3X3.Ez;
		x7 = x2 * x5;
		y2 = x3 * x3;
		y3 = x7 - y2;
		ez.Z = x * y3;
	}
}
