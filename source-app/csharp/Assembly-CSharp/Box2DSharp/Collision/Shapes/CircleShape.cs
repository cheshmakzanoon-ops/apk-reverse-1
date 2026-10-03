using Box2DSharp.Collision.Collider;
using Box2DSharp.Common;
using Box2DSharp.Foreign;

namespace Box2DSharp.Collision.Shapes;

public class CircleShape : Shape
{
	public FVector2 Position;

	public new FP Radius
	{
		get
		{
			return base.Radius;
		}
		set
		{
			base.Radius = value;
		}
	}

	public CircleShape()
	{
		base.ShapeType = ShapeType.Circle;
		Radius = 0;
		Position.SetZero();
	}

	public override Shape Clone()
	{
		return new CircleShape
		{
			Position = Position,
			Radius = Radius
		};
	}

	public override int GetChildCount()
	{
		return 1;
	}

	public override bool TestPoint(in Transform transform, in FVector2 p)
	{
		FVector2 fVector = transform.Position + MathUtils.Mul(in transform.Rotation, in Position);
		FVector2 fVector2 = p - fVector;
		FP fP = FVector2.Dot(fVector2, fVector2);
		FP x = Radius;
		FP y = Radius;
		return fP <= x * y;
	}

	public override bool RayCast(out RayCastOutput output, in RayCastInput input, in Transform transform, int childIndex)
	{
		output = default(RayCastOutput);
		FVector2 fVector = transform.Position + MathUtils.Mul(in transform.Rotation, in Position);
		FVector2 fVector2 = input.P1 - fVector;
		FP x = FVector2.Dot(fVector2, fVector2);
		FP x2 = Radius;
		FP y = Radius;
		FP y2 = x2 * y;
		FP y3 = x - y2;
		FVector2 fVector3 = input.P2 - input.P1;
		FP x3 = FVector2.Dot(fVector2, fVector3);
		FP x4 = FVector2.Dot(fVector3, fVector3);
		x = x3 * x3;
		x2 = x4 * y3;
		FP fP = x - x2;
		if (fP < FP.Zero || x4 < Settings.Epsilon)
		{
			return false;
		}
		x = FP.Sqrt(fP);
		FP fP2 = -(x3 + x);
		if (FP.Zero <= fP2 && fP2 <= input.MaxFraction * x4)
		{
			fP2 /= x4;
			output = new RayCastOutput
			{
				Fraction = fP2,
				Normal = fVector2 + fP2 * fVector3
			};
			output.Normal.Normalize();
			return true;
		}
		return false;
	}

	public override void ComputeAABB(out AABB aabb, in Transform transform, int childIndex)
	{
		FVector2 fVector = transform.Position + MathUtils.Mul(in transform.Rotation, in Position);
		aabb = default(AABB);
		ref FVector2 lowerBound = ref aabb.LowerBound;
		ref FP x = ref fVector.X;
		FP y = Radius;
		FP x2 = x - y;
		ref FP y2 = ref fVector.Y;
		FP y3 = Radius;
		lowerBound.Set(x2, y2 - y3);
		ref FVector2 upperBound = ref aabb.UpperBound;
		ref FP x3 = ref fVector.X;
		y = Radius;
		FP x4 = x3 + y;
		ref FP y4 = ref fVector.Y;
		y3 = Radius;
		upperBound.Set(x4, y4 + y3);
	}

	public override void ComputeMass(out MassData massData, FP density)
	{
		MassData massData2 = default(MassData);
		FP x = density * Settings.Pi;
		FP y = Radius;
		FP x2 = x * y;
		FP y2 = Radius;
		massData2.Mass = x2 * y2;
		massData2.Center = Position;
		massData = massData2;
		ref FP mass = ref massData.Mass;
		x = 0.5f;
		y = Radius;
		x2 = x * y;
		y2 = Radius;
		FP x3 = x2 * y2;
		FP y3 = FVector2.Dot(Position, Position);
		FP y4 = x3 + y3;
		massData.RotationInertia = mass * y4;
	}

	public override PhysicsSnapShot.ComponentPhysicsShapeData TakeSnapShot()
	{
		return new PhysicsSnapShot.ComponentPhysicsCircleData
		{
			Position = Position,
			Radius = Radius
		};
	}

	public override void RestoreSnapshot(PhysicsSnapShot.ComponentPhysicsShapeData shapeData)
	{
		if (shapeData is PhysicsSnapShot.ComponentPhysicsCircleData componentPhysicsCircleData)
		{
			Radius = componentPhysicsCircleData.Radius;
			Position = componentPhysicsCircleData.Position;
		}
	}
}
