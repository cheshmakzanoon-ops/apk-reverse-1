using System.ComponentModel;
using Box2DSharp.Collision.Collider;
using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Contacts;

public struct PositionSolverManifold
{
	public FVector2 Normal;

	public FVector2 Point;

	public FP Separation;

	public void Initialize(in ContactPositionConstraint pc, in Transform xfA, in Transform xfB, int index)
	{
		switch (pc.Type)
		{
		case ManifoldType.Circles:
		{
			FP x = xfA.Rotation.Cos * pc.LocalPoint.X;
			FP y = xfA.Rotation.Sin * pc.LocalPoint.Y;
			FP x3 = x - y;
			FP x7 = x3 + xfA.Position.X;
			x = xfA.Rotation.Sin * pc.LocalPoint.X;
			y = xfA.Rotation.Cos * pc.LocalPoint.Y;
			x3 = x + y;
			FP y5 = x3 + xfA.Position.Y;
			FVector2 fVector5 = new FVector2(x7, y5);
			x = xfB.Rotation.Cos * pc.LocalPoints.Value0.X;
			y = xfB.Rotation.Sin * pc.LocalPoints.Value0.Y;
			x3 = x - y;
			x7 = x3 + xfB.Position.X;
			x = xfB.Rotation.Sin * pc.LocalPoints.Value0.X;
			y = xfB.Rotation.Cos * pc.LocalPoints.Value0.Y;
			x3 = x + y;
			y5 = x3 + xfB.Position.Y;
			FVector2 fVector6 = new FVector2(x7, y5);
			Normal = fVector6 - fVector5;
			Normal.Normalize();
			Point = 0.5f * (fVector5 + fVector6);
			x = FVector2.Dot(fVector6 - fVector5, Normal);
			y = x - pc.RadiusA;
			Separation = y - pc.RadiusB;
			break;
		}
		case ManifoldType.FaceA:
		{
			FP x = xfA.Rotation.Cos * pc.LocalNormal.X;
			FP y = xfA.Rotation.Sin * pc.LocalNormal.Y;
			FP x5 = x - y;
			FP x3 = xfA.Rotation.Sin * pc.LocalNormal.X;
			FP y2 = xfA.Rotation.Cos * pc.LocalNormal.Y;
			Normal = new FVector2(x5, x3 + y2);
			x = xfA.Rotation.Cos * pc.LocalPoint.X;
			y = xfA.Rotation.Sin * pc.LocalPoint.Y;
			x3 = x - y;
			FP x6 = x3 + xfA.Position.X;
			x = xfA.Rotation.Sin * pc.LocalPoint.X;
			y = xfA.Rotation.Cos * pc.LocalPoint.Y;
			x3 = x + y;
			FP y4 = x3 + xfA.Position.Y;
			FVector2 fVector3 = new FVector2(x6, y4);
			if (index == 0)
			{
				x = xfB.Rotation.Cos * pc.LocalPoints.Value0.X;
				y = xfB.Rotation.Sin * pc.LocalPoints.Value0.Y;
				x3 = x - y;
				x6 = x3 + xfB.Position.X;
				x = xfB.Rotation.Sin * pc.LocalPoints.Value0.X;
				y = xfB.Rotation.Cos * pc.LocalPoints.Value0.Y;
				x3 = x + y;
				y4 = x3 + xfB.Position.Y;
			}
			else
			{
				x = xfB.Rotation.Cos * pc.LocalPoints.Value1.X;
				y = xfB.Rotation.Sin * pc.LocalPoints.Value1.Y;
				x3 = x - y;
				x6 = x3 + xfB.Position.X;
				x = xfB.Rotation.Sin * pc.LocalPoints.Value1.X;
				y = xfB.Rotation.Cos * pc.LocalPoints.Value1.Y;
				x3 = x + y;
				y4 = x3 + xfB.Position.Y;
			}
			FVector2 fVector4 = new FVector2(x6, y4);
			x = FVector2.Dot(fVector4 - fVector3, Normal);
			y = x - pc.RadiusA;
			Separation = y - pc.RadiusB;
			Point = fVector4;
			break;
		}
		case ManifoldType.FaceB:
		{
			FP x = xfB.Rotation.Cos * pc.LocalNormal.X;
			FP y = xfB.Rotation.Sin * pc.LocalNormal.Y;
			FP x2 = x - y;
			FP x3 = xfB.Rotation.Sin * pc.LocalNormal.X;
			FP y2 = xfB.Rotation.Cos * pc.LocalNormal.Y;
			Normal = new FVector2(x2, x3 + y2);
			x = xfB.Rotation.Cos * pc.LocalPoint.X;
			y = xfB.Rotation.Sin * pc.LocalPoint.Y;
			x3 = x - y;
			FP x4 = x3 + xfB.Position.X;
			x = xfB.Rotation.Sin * pc.LocalPoint.X;
			y = xfB.Rotation.Cos * pc.LocalPoint.Y;
			x3 = x + y;
			FP y3 = x3 + xfB.Position.Y;
			FVector2 fVector = new FVector2(x4, y3);
			if (index == 0)
			{
				x = xfA.Rotation.Cos * pc.LocalPoints.Value0.X;
				y = xfA.Rotation.Sin * pc.LocalPoints.Value0.Y;
				x3 = x - y;
				x4 = x3 + xfA.Position.X;
				x = xfA.Rotation.Sin * pc.LocalPoints.Value0.X;
				y = xfA.Rotation.Cos * pc.LocalPoints.Value0.Y;
				x3 = x + y;
				y3 = x3 + xfA.Position.Y;
			}
			else
			{
				x = xfA.Rotation.Cos * pc.LocalPoints.Value1.X;
				y = xfA.Rotation.Sin * pc.LocalPoints.Value1.Y;
				x3 = x - y;
				x4 = x3 + xfA.Position.X;
				x = xfA.Rotation.Sin * pc.LocalPoints.Value1.X;
				y = xfA.Rotation.Cos * pc.LocalPoints.Value1.Y;
				x3 = x + y;
				y3 = x3 + xfA.Position.Y;
			}
			FVector2 fVector2 = new FVector2(x4, y3);
			x = FVector2.Dot(fVector2 - fVector, Normal);
			y = x - pc.RadiusA;
			Separation = y - pc.RadiusB;
			Point = fVector2;
			Normal = -Normal;
			break;
		}
		default:
			throw new InvalidEnumArgumentException($"Invalid ManifoldType: {pc.Type}");
		}
	}
}
