using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public static class JointUtils
{
	public static void LinearStiffness(out FP stiffness, out FP damping, FP frequencyHertz, FP dampingRatio, Body bodyA, Body bodyB)
	{
		FP x = bodyA.Mass;
		FP y = bodyB.Mass;
		FP x2 = ((x > 0f && y > 0f) ? (x * y / (x + y)) : ((!(x > 0f)) ? y : x));
		FP x3 = 2f;
		FP x4 = x3 * Settings.Pi;
		FP y2 = x4 * frequencyHertz;
		x3 = x2 * y2;
		stiffness = x3 * y2;
		x3 = 2f;
		x4 = x3 * x2;
		FP x5 = x4 * dampingRatio;
		damping = x5 * y2;
	}

	public static void AngularStiffness(out FP stiffness, out FP damping, FP frequencyHertz, FP dampingRatio, Body bodyA, Body bodyB)
	{
		FP x = bodyA.Inertia;
		FP y = bodyB.Inertia;
		FP x2 = ((x > 0f && y > 0f) ? (x * y / (x + y)) : ((!(x > 0f)) ? y : x));
		FP x3 = 2f;
		FP x4 = x3 * Settings.Pi;
		FP y2 = x4 * frequencyHertz;
		x3 = x2 * y2;
		stiffness = x3 * y2;
		x3 = 2f;
		x4 = x3 * x2;
		FP x5 = x4 * dampingRatio;
		damping = x5 * y2;
	}
}
