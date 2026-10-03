using Box2DSharp.Common;

namespace Box2DSharp.Collision.Shapes;

public struct Sweep
{
	public FVector2 LocalCenter;

	public FVector2 C0;

	public FVector2 C;

	public FP A0;

	public FP A;

	public FP Alpha0;

	public void GetTransform(out Transform xf, FP beta)
	{
		FP x = 1f;
		FVector2 position = (x - beta) * C0 + beta * C;
		x = 1f;
		FP x2 = x - beta;
		FP x3 = x2 * A0;
		FP y = beta * A;
		FP angle = x3 + y;
		xf = new Transform(in position, angle);
		xf.Position -= MathUtils.Mul(in xf.Rotation, in LocalCenter);
	}

	public void Advance(FP alpha)
	{
		FP fP = alpha - Alpha0;
		FP x = 1f;
		FP x2 = fP / (x - Alpha0);
		C0 += x2 * (C - C0);
		ref FP a = ref A0;
		x = A - A0;
		FP y = x2 * x;
		A0 = a + y;
		Alpha0 = alpha;
	}

	public void Normalize()
	{
		FP y = FP.Floor(A0 / FP.PiTimes2);
		FP y2 = FP.PiTimes2 * y;
		A0 -= y2;
		A -= y2;
	}
}
