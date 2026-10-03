using System;
using System.Buffers;
using Box2DSharp.Collision.Collider;
using Box2DSharp.Collision.Shapes;
using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Contacts;

public class ContactSolver
{
	internal ContactPositionConstraint[] PositionConstraints;

	internal ContactVelocityConstraint[] VelocityConstraints;

	private int _contactCount;

	private Contact[] _contacts;

	private Position[] _positions;

	private Velocity[] _velocities;

	private readonly ArrayPool<ContactPositionConstraint> _contactPositionConstraintPool = ArrayPool<ContactPositionConstraint>.Create();

	private readonly ArrayPool<ContactVelocityConstraint> _contactVelocityConstraintPool = ArrayPool<ContactVelocityConstraint>.Create();

	public void Setup(in ContactSolverDef def)
	{
		TimeStep step = def.Step;
		_contactCount = def.ContactCount;
		PositionConstraints = _contactPositionConstraintPool.Rent(_contactCount);
		VelocityConstraints = _contactVelocityConstraintPool.Rent(_contactCount);
		_positions = def.Positions;
		_velocities = def.Velocities;
		_contacts = def.Contacts;
		Span<Contact> span = _contacts;
		Span<ContactVelocityConstraint> span2 = VelocityConstraints;
		Span<ContactPositionConstraint> span3 = PositionConstraints;
		for (int i = 0; i < _contactCount; i++)
		{
			Contact contact = span[i];
			Fixture fixtureA = contact.FixtureA;
			Fixture fixtureB = contact.FixtureB;
			Shape shape = fixtureA.Shape;
			Shape shape2 = fixtureB.Shape;
			FP radius = shape.Radius;
			FP radius2 = shape2.Radius;
			Body body = fixtureA.Body;
			Body body2 = fixtureB.Body;
			ref Manifold manifold = ref contact.Manifold;
			int pointCount = manifold.PointCount;
			ref ContactVelocityConstraint reference = ref span2[i];
			reference.Friction = contact.Friction;
			reference.Restitution = contact.Restitution;
			reference.Threshold = contact.RestitutionThreshold;
			reference.TangentSpeed = contact.TangentSpeed;
			reference.IndexA = body.IslandIndex;
			reference.IndexB = body2.IslandIndex;
			reference.InvMassA = body.InvMass;
			reference.InvMassB = body2.InvMass;
			reference.InvIa = body.InverseInertia;
			reference.InvIb = body2.InverseInertia;
			reference.ContactIndex = i;
			reference.PointCount = pointCount;
			reference.K.SetZero();
			reference.NormalMass.SetZero();
			ref ContactPositionConstraint reference2 = ref span3[i];
			reference2.IndexA = body.IslandIndex;
			reference2.IndexB = body2.IslandIndex;
			reference2.InvMassA = body.InvMass;
			reference2.InvMassB = body2.InvMass;
			reference2.LocalCenterA = body.Sweep.LocalCenter;
			reference2.LocalCenterB = body2.Sweep.LocalCenter;
			reference2.InvIa = body.InverseInertia;
			reference2.InvIb = body2.InverseInertia;
			reference2.LocalNormal = manifold.LocalNormal;
			reference2.LocalPoint = manifold.LocalPoint;
			reference2.PointCount = pointCount;
			reference2.RadiusA = radius;
			reference2.RadiusB = radius2;
			reference2.Type = manifold.Type;
			for (int j = 0; j < pointCount; j++)
			{
				ref ManifoldPoint reference3 = ref j == 0 ? ref manifold.Points.Value0 : ref manifold.Points.Value1;
				ref VelocityConstraintPoint reference4 = ref j == 0 ? ref reference.Points.Value0 : ref reference.Points.Value1;
				if (step.WarmStarting)
				{
					reference4.NormalImpulse = step.DtRatio * reference3.NormalImpulse;
					reference4.TangentImpulse = step.DtRatio * reference3.TangentImpulse;
				}
				else
				{
					reference4.NormalImpulse = 0f;
					reference4.TangentImpulse = 0f;
				}
				reference4.Ra = default(FVector2);
				reference4.Rb = default(FVector2);
				reference4.NormalMass = 0f;
				reference4.TangentMass = 0f;
				reference4.VelocityBias = 0f;
				reference2.LocalPoints[j] = reference3.LocalPoint;
			}
		}
	}

	public void Reset()
	{
		_contactPositionConstraintPool.Return(PositionConstraints, clearArray: true);
		PositionConstraints = null;
		_contactVelocityConstraintPool.Return(VelocityConstraints, clearArray: true);
		VelocityConstraints = null;
		_positions = null;
		_contacts = null;
		_velocities = null;
		_contactCount = 0;
	}

	public void InitializeVelocityConstraints()
	{
		Span<Position> span = _positions;
		Span<Velocity> span2 = _velocities;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactVelocityConstraint reference = ref VelocityConstraints[i];
			ref ContactPositionConstraint reference2 = ref PositionConstraints[i];
			FP radiusA = reference2.RadiusA;
			FP radiusB = reference2.RadiusB;
			ref Manifold manifold = ref _contacts[reference.ContactIndex].Manifold;
			int indexA = reference.IndexA;
			int indexB = reference.IndexB;
			FP x = reference.InvMassA;
			FP y = reference.InvMassB;
			FP x2 = reference.InvIa;
			FP x3 = reference.InvIb;
			FVector2 v = reference2.LocalCenterA;
			FVector2 v2 = reference2.LocalCenterB;
			FVector2 center = span[indexA].Center;
			FP angle = span[indexA].Angle;
			FVector2 v3 = span2[indexA].V;
			FP x4 = span2[indexA].W;
			FVector2 center2 = span[indexB].Center;
			FP angle2 = span[indexB].Angle;
			FVector2 v4 = span2[indexB].V;
			FP x5 = span2[indexB].W;
			Transform xfA = default(Transform);
			Transform xfB = default(Transform);
			xfA.Rotation.Set(angle);
			xfB.Rotation.Set(angle2);
			xfA.Position = center - MathUtils.Mul(in xfA.Rotation, in v);
			xfB.Position = center2 - MathUtils.Mul(in xfB.Rotation, in v2);
			WorldManifold worldManifold = default(WorldManifold);
			worldManifold.Initialize(in manifold, in xfA, radiusA, in xfB, radiusB);
			reference.Normal = worldManifold.Normal;
			for (int j = 0; j < reference.PointCount; j++)
			{
				ref VelocityConstraintPoint reference3 = ref j == 0 ? ref reference.Points.Value0 : ref reference.Points.Value1;
				ref FVector2 reference4 = ref j == 0 ? ref worldManifold.Points.Value0 : ref worldManifold.Points.Value1;
				reference3.Ra = reference4 - center;
				reference3.Rb = reference4 - center2;
				FP y2 = MathUtils.Cross(in reference3.Ra, in reference.Normal);
				FP y3 = MathUtils.Cross(in reference3.Rb, in reference.Normal);
				FP x6 = x + y;
				FP x7 = x2 * y2;
				FP y4 = x7 * y2;
				FP x8 = x6 + y4;
				FP x9 = x3 * y3;
				FP y5 = x9 * y3;
				FP fP = x8 + y5;
				reference3.NormalMass = ((fP > FP.Zero) ? (FP.One / fP) : FP.Zero);
				FVector2 b = MathUtils.Cross(in reference.Normal, 1f);
				FP y6 = MathUtils.Cross(in reference3.Ra, in b);
				FP y7 = MathUtils.Cross(in reference3.Rb, in b);
				x6 = x + y;
				x7 = x2 * y6;
				y4 = x7 * y6;
				x8 = x6 + y4;
				x9 = x3 * y7;
				y5 = x9 * y7;
				FP fP2 = x8 + y5;
				reference3.TangentMass = ((fP2 > FP.Zero) ? (FP.One / fP2) : FP.Zero);
				reference3.VelocityBias = FP.Zero;
				FVector2 normal = reference.Normal;
				ref FP x10 = ref v4.X;
				x6 = x5 * reference3.Rb.Y;
				x7 = x10 - x6;
				y4 = x7 - v3.X;
				x8 = x4 * reference3.Ra.Y;
				FP x11 = y4 + x8;
				ref FP y8 = ref v4.Y;
				x9 = x5 * reference3.Rb.X;
				y5 = y8 + x9;
				FP x12 = y5 - v3.Y;
				FP y9 = x4 * reference3.Ra.X;
				FP y10 = FVector2.Dot(normal, new FVector2(x11, x12 - y9));
				if (y10 < -reference.Threshold)
				{
					x6 = -reference.Restitution;
					reference3.VelocityBias = x6 * y10;
				}
			}
			if (reference.PointCount == 2)
			{
				ref VelocityConstraintPoint value = ref reference.Points.Value0;
				ref VelocityConstraintPoint value2 = ref reference.Points.Value1;
				FP x6 = value.Ra.X * reference.Normal.Y;
				FP x7 = value.Ra.Y * reference.Normal.X;
				FP y11 = x6 - x7;
				x6 = value.Rb.X * reference.Normal.Y;
				x7 = value.Rb.Y * reference.Normal.X;
				FP y12 = x6 - x7;
				x6 = value2.Ra.X * reference.Normal.Y;
				x7 = value2.Ra.Y * reference.Normal.X;
				FP y13 = x6 - x7;
				x6 = value2.Rb.X * reference.Normal.Y;
				x7 = value2.Rb.Y * reference.Normal.X;
				FP y14 = x6 - x7;
				x6 = x + y;
				x7 = x2 * y11;
				FP y4 = x7 * y11;
				FP x8 = x6 + y4;
				FP x9 = x3 * y12;
				FP y5 = x9 * y12;
				FP x13 = x8 + y5;
				x6 = x + y;
				x7 = x2 * y13;
				y4 = x7 * y13;
				x8 = x6 + y4;
				x9 = x3 * y14;
				y5 = x9 * y14;
				FP y15 = x8 + y5;
				x6 = x + y;
				x7 = x2 * y11;
				y4 = x7 * y13;
				x8 = x6 + y4;
				x9 = x3 * y12;
				y5 = x9 * y14;
				FP x14 = x8 + y5;
				FP x15 = 1000;
				FP fP3 = x13 * x13;
				x6 = x13 * y15;
				x7 = x14 * x14;
				y4 = x6 - x7;
				if (fP3 < x15 * y4)
				{
					reference.K.Ex.Set(x13, x14);
					reference.K.Ey.Set(x14, y15);
					reference.NormalMass = reference.K.GetInverse();
				}
				else
				{
					reference.PointCount = 1;
				}
			}
		}
	}

	public void WarmStart()
	{
		Span<ContactVelocityConstraint> span = VelocityConstraints;
		Span<Velocity> span2 = _velocities;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactVelocityConstraint reference = ref span[i];
			int indexA = reference.IndexA;
			int indexB = reference.IndexB;
			FP invMassA = reference.InvMassA;
			FP x = reference.InvIa;
			FP invMassB = reference.InvMassB;
			FP x2 = reference.InvIb;
			int pointCount = reference.PointCount;
			FVector2 v = span2[indexA].V;
			FP x3 = span2[indexA].W;
			FVector2 v2 = span2[indexB].V;
			FP x4 = span2[indexB].W;
			FVector2 a = reference.Normal;
			FVector2 fVector = MathUtils.Cross(in a, 1f);
			for (int j = 0; j < pointCount; j++)
			{
				ref VelocityConstraintPoint reference2 = ref j == 0 ? ref reference.Points.Value0 : ref reference.Points.Value1;
				FVector2 b = reference2.NormalImpulse * a + reference2.TangentImpulse * fVector;
				FP y = MathUtils.Cross(in reference2.Ra, in b);
				FP y2 = x * y;
				x3 -= y2;
				v -= invMassA * b;
				y = MathUtils.Cross(in reference2.Rb, in b);
				y2 = x2 * y;
				x4 += y2;
				v2 += invMassB * b;
			}
			span2[indexA].V = v;
			span2[indexA].W = x3;
			span2[indexB].V = v2;
			span2[indexB].W = x4;
		}
	}

	public void SolveVelocityConstraints()
	{
		Span<ContactVelocityConstraint> span = VelocityConstraints;
		Span<Velocity> span2 = _velocities;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactVelocityConstraint reference = ref span[i];
			int indexA = reference.IndexA;
			int indexB = reference.IndexB;
			FP x = reference.InvMassA;
			FP x2 = reference.InvIa;
			FP x3 = reference.InvMassB;
			FP x4 = reference.InvIb;
			int pointCount = reference.PointCount;
			ref Velocity reference2 = ref span2[indexA];
			ref Velocity reference3 = ref span2[indexB];
			FP y = reference2.V.X;
			FP y2 = reference2.V.Y;
			FP x5 = reference2.W;
			FP x6 = reference3.V.X;
			FP x7 = reference3.V.Y;
			FP x8 = reference3.W;
			FP y3 = reference.Normal.X;
			FP y4 = reference.Normal.Y;
			FP y5 = y4;
			FP y6 = -y3;
			FP x9 = reference.Friction;
			for (int j = 0; j < pointCount; j++)
			{
				ref VelocityConstraintPoint reference4 = ref j == 0 ? ref reference.Points.Value0 : ref reference.Points.Value1;
				FP y7 = x8 * reference4.Rb.Y;
				FP x10 = x6 - y7;
				FP x11 = x10 - y;
				FP y8 = x5 * reference4.Ra.Y;
				FP x12 = x11 + y8;
				y7 = x8 * reference4.Rb.X;
				x10 = x7 + y7;
				x11 = x10 - y2;
				y8 = x5 * reference4.Ra.X;
				FP x13 = x11 - y8;
				y7 = x12 * y5;
				x10 = x13 * y6;
				x11 = y7 + x10;
				FP fP = x11 - reference.TangentSpeed;
				ref FP tangentMass = ref reference4.TangentMass;
				y7 = -fP;
				FP y9 = tangentMass * y7;
				FP fP2 = x9 * reference4.NormalImpulse;
				FP fP3 = reference4.TangentImpulse + y9;
				fP3 = ((fP3 < -fP2) ? (-fP2) : ((fP3 > fP2) ? fP2 : fP3));
				y9 = fP3 - reference4.TangentImpulse;
				reference4.TangentImpulse = fP3;
				FP y10 = y9 * y5;
				FP y11 = y9 * y6;
				y7 = x * y10;
				y -= y7;
				y7 = x * y11;
				y2 -= y7;
				y7 = reference4.Ra.X * y11;
				x10 = reference4.Ra.Y * y10;
				x11 = y7 - x10;
				y8 = x2 * x11;
				x5 -= y8;
				y7 = x3 * y10;
				x6 += y7;
				y7 = x3 * y11;
				x7 += y7;
				y7 = reference4.Rb.X * y11;
				x10 = reference4.Rb.Y * y10;
				x11 = y7 - x10;
				y8 = x4 * x11;
				x8 += y8;
			}
			if (pointCount == 1)
			{
				ref VelocityConstraintPoint value = ref reference.Points.Value0;
				FP y7 = x8 * value.Rb.Y;
				FP x10 = x6 - y7;
				FP x11 = x10 - y;
				FP y8 = x5 * value.Ra.Y;
				FP x12 = x11 + y8;
				y7 = x8 * value.Rb.X;
				x10 = x7 + y7;
				x11 = x10 - y2;
				y8 = x5 * value.Ra.X;
				FP x13 = x11 - y8;
				y7 = x12 * y3;
				x10 = x13 * y4;
				FP x14 = y7 + x10;
				y7 = -value.NormalMass;
				x10 = x14 - value.VelocityBias;
				FP y12 = y7 * x10;
				FP x15 = FP.Max(value.NormalImpulse + y12, 0f);
				y12 = x15 - value.NormalImpulse;
				value.NormalImpulse = x15;
				FP y10 = y12 * y3;
				FP y11 = y12 * y4;
				y7 = x * y10;
				y -= y7;
				y7 = x * y11;
				y2 -= y7;
				y7 = value.Ra.X * y11;
				x10 = value.Ra.Y * y10;
				x11 = y7 - x10;
				y8 = x2 * x11;
				x5 -= y8;
				y7 = x3 * y10;
				x6 += y7;
				y7 = x3 * y11;
				x7 += y7;
				y7 = value.Rb.X * y11;
				x10 = value.Rb.Y * y10;
				x11 = y7 - x10;
				y8 = x4 * x11;
				x8 += y8;
			}
			else
			{
				FP y13 = reference.Points.Value0.VelocityBias;
				FP y14 = reference.Points.Value1.VelocityBias;
				FP normalMass = reference.Points.Value0.NormalMass;
				FP normalMass2 = reference.Points.Value1.NormalMass;
				FP y15 = reference.Points.Value0.Ra.X;
				FP y16 = reference.Points.Value0.Ra.Y;
				FP y17 = reference.Points.Value0.Rb.X;
				FP y18 = reference.Points.Value0.Rb.Y;
				FP y19 = reference.Points.Value1.Ra.X;
				FP y20 = reference.Points.Value1.Ra.Y;
				FP y21 = reference.Points.Value1.Rb.X;
				FP y22 = reference.Points.Value1.Rb.Y;
				ref FP normalImpulse = ref reference.Points.Value0.NormalImpulse;
				ref FP normalImpulse2 = ref reference.Points.Value1.NormalImpulse;
				FVector2 fVector = new FVector2(normalImpulse, normalImpulse2);
				FP y7 = x8 * y18;
				FP x10 = x6 - y7;
				FP x11 = x10 - y;
				FP y8 = x5 * y16;
				FP x16 = x11 + y8;
				y7 = x8 * y17;
				x10 = x7 + y7;
				x11 = x10 - y2;
				y8 = x5 * y15;
				FP x17 = x11 - y8;
				y7 = x8 * y22;
				x10 = x6 - y7;
				x11 = x10 - y;
				y8 = x5 * y20;
				FP x18 = x11 + y8;
				y7 = x8 * y21;
				x10 = x7 + y7;
				x11 = x10 - y2;
				y8 = x5 * y19;
				FP x19 = x11 - y8;
				y7 = x16 * y3;
				x10 = x17 * y4;
				FP x20 = y7 + x10;
				y7 = x18 * y3;
				x10 = x19 * y4;
				FP x21 = y7 + x10;
				y7 = x20 - y13;
				x10 = reference.K.Ex.X * fVector.X;
				x11 = reference.K.Ey.X * fVector.Y;
				y8 = x10 + x11;
				FP x22 = y7 - y8;
				FP x23 = x21 - y14;
				FP x24 = reference.K.Ex.Y * fVector.X;
				FP y23 = reference.K.Ey.Y * fVector.Y;
				FP y24 = x24 + y23;
				FVector2 fVector2 = new FVector2(x22, x23 - y24);
				y7 = reference.NormalMass.Ex.X * fVector2.X;
				x10 = reference.NormalMass.Ey.X * fVector2.Y;
				FP x25 = -(y7 + x10);
				x11 = reference.NormalMass.Ex.Y * fVector2.X;
				y8 = reference.NormalMass.Ey.Y * fVector2.Y;
				FVector2 fVector3 = new FVector2(x25, -(x11 + y8));
				if (fVector3.X >= 0f && fVector3.Y >= 0f)
				{
					FP x26 = fVector3.X - fVector.X;
					FP x27 = fVector3.Y - fVector.Y;
					FP x28 = x26 * y3;
					FP x29 = x26 * y4;
					FP y25 = x27 * y3;
					FP y26 = x27 * y4;
					y7 = x28 + y25;
					x10 = x * y7;
					y -= x10;
					y7 = x29 + y26;
					x10 = x * y7;
					y2 -= x10;
					y7 = y15 * x29;
					x10 = y16 * x28;
					x11 = y7 - x10;
					y8 = y19 * y26;
					x23 = y20 * y25;
					x24 = y8 - x23;
					y23 = x11 + x24;
					y24 = x2 * y23;
					x5 -= y24;
					y7 = x28 + y25;
					x10 = x3 * y7;
					x6 += x10;
					y7 = x29 + y26;
					x10 = x3 * y7;
					x7 += x10;
					y7 = y17 * x29;
					x10 = y18 * x28;
					x11 = y7 - x10;
					y8 = y21 * y26;
					x23 = y22 * y25;
					x24 = y8 - x23;
					y23 = x11 + x24;
					y24 = x4 * y23;
					x8 += y24;
					normalImpulse = fVector3.X;
					normalImpulse2 = fVector3.Y;
				}
				else
				{
					y7 = -normalMass;
					fVector3.X = y7 * fVector2.X;
					fVector3.Y = 0f;
					x20 = 0f;
					y7 = reference.K.Ex.Y * fVector3.X;
					x21 = y7 + fVector2.Y;
					if (fVector3.X >= 0f && x21 >= 0f)
					{
						FP x30 = fVector3.X - fVector.X;
						FP x31 = fVector3.Y - fVector.Y;
						FP x28 = x30 * y3;
						FP x29 = x30 * y4;
						FP y25 = x31 * y3;
						FP y26 = x31 * y4;
						y7 = x28 + y25;
						x10 = x * y7;
						y -= x10;
						y7 = x29 + y26;
						x10 = x * y7;
						y2 -= x10;
						y7 = y15 * x29;
						x10 = y16 * x28;
						x11 = y7 - x10;
						y8 = y19 * y26;
						x23 = y20 * y25;
						x24 = y8 - x23;
						y23 = x11 + x24;
						y24 = x2 * y23;
						x5 -= y24;
						y7 = x28 + y25;
						x10 = x3 * y7;
						x6 += x10;
						y7 = x29 + y26;
						x10 = x3 * y7;
						x7 += x10;
						y7 = y17 * x29;
						x10 = y18 * x28;
						x11 = y7 - x10;
						y8 = y21 * y26;
						x23 = y22 * y25;
						x24 = y8 - x23;
						y23 = x11 + x24;
						y24 = x4 * y23;
						x8 += y24;
						normalImpulse = fVector3.X;
						normalImpulse2 = fVector3.Y;
					}
					else
					{
						fVector3.X = 0f;
						y7 = -normalMass2;
						fVector3.Y = y7 * fVector2.Y;
						y7 = reference.K.Ey.X * fVector3.Y;
						x20 = y7 + fVector2.X;
						x21 = 0f;
						if (fVector3.Y >= 0f && x20 >= 0f)
						{
							FP x32 = fVector3.X - fVector.X;
							FP x33 = fVector3.Y - fVector.Y;
							FP x28 = x32 * y3;
							FP x29 = x32 * y4;
							FP y25 = x33 * y3;
							FP y26 = x33 * y4;
							y7 = x28 + y25;
							x10 = x * y7;
							y -= x10;
							y7 = x29 + y26;
							x10 = x * y7;
							y2 -= x10;
							y7 = y15 * x29;
							x10 = y16 * x28;
							x11 = y7 - x10;
							y8 = y19 * y26;
							x23 = y20 * y25;
							x24 = y8 - x23;
							y23 = x11 + x24;
							y24 = x2 * y23;
							x5 -= y24;
							y7 = x28 + y25;
							x10 = x3 * y7;
							x6 += x10;
							y7 = x29 + y26;
							x10 = x3 * y7;
							x7 += x10;
							y7 = y17 * x29;
							x10 = y18 * x28;
							x11 = y7 - x10;
							y8 = y21 * y26;
							x23 = y22 * y25;
							x24 = y8 - x23;
							y23 = x11 + x24;
							y24 = x4 * y23;
							x8 += y24;
							normalImpulse = fVector3.X;
							normalImpulse2 = fVector3.Y;
						}
						else
						{
							fVector3.X = 0f;
							fVector3.Y = 0f;
							x20 = fVector2.X;
							x21 = fVector2.Y;
							if (x20 >= 0f && x21 >= 0f)
							{
								FP x34 = fVector3.X - fVector.X;
								FP x35 = fVector3.Y - fVector.Y;
								FP x28 = x34 * y3;
								FP x29 = x34 * y4;
								FP y25 = x35 * y3;
								FP y26 = x35 * y4;
								y7 = x28 + y25;
								x10 = x * y7;
								y -= x10;
								y7 = x29 + y26;
								x10 = x * y7;
								y2 -= x10;
								y7 = y15 * x29;
								x10 = y16 * x28;
								x11 = y7 - x10;
								y8 = y19 * y26;
								x23 = y20 * y25;
								x24 = y8 - x23;
								y23 = x11 + x24;
								y24 = x2 * y23;
								x5 -= y24;
								y7 = x28 + y25;
								x10 = x3 * y7;
								x6 += x10;
								y7 = x29 + y26;
								x10 = x3 * y7;
								x7 += x10;
								y7 = y17 * x29;
								x10 = y18 * x28;
								x11 = y7 - x10;
								y8 = y21 * y26;
								x23 = y22 * y25;
								x24 = y8 - x23;
								y23 = x11 + x24;
								y24 = x4 * y23;
								x8 += y24;
								normalImpulse = fVector3.X;
								normalImpulse2 = fVector3.Y;
							}
						}
					}
				}
			}
			span2[indexA].V.X = y;
			span2[indexA].V.Y = y2;
			span2[indexA].W = x5;
			span2[indexB].V.X = x6;
			span2[indexB].V.Y = x7;
			span2[indexB].W = x8;
		}
	}

	public void StoreImpulses()
	{
		Span<ContactVelocityConstraint> span = VelocityConstraints;
		Span<Contact> span2 = _contacts;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactVelocityConstraint reference = ref span[i];
			ref Manifold manifold = ref span2[reference.ContactIndex].Manifold;
			if (reference.PointCount == 1)
			{
				manifold.Points.Value0.NormalImpulse = reference.Points.Value0.NormalImpulse;
				manifold.Points.Value0.TangentImpulse = reference.Points.Value0.TangentImpulse;
			}
			else if (reference.PointCount == 2)
			{
				manifold.Points.Value0.NormalImpulse = reference.Points.Value0.NormalImpulse;
				manifold.Points.Value0.TangentImpulse = reference.Points.Value0.TangentImpulse;
				manifold.Points.Value1.NormalImpulse = reference.Points.Value1.NormalImpulse;
				manifold.Points.Value1.TangentImpulse = reference.Points.Value1.TangentImpulse;
			}
		}
	}

	public bool SolvePositionConstraints()
	{
		FP fP = FP.Zero;
		Span<ContactPositionConstraint> span = PositionConstraints;
		Span<Position> span2 = _positions;
		FP y2;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactPositionConstraint reference = ref span[i];
			int indexA = reference.IndexA;
			int indexB = reference.IndexB;
			FVector2 v = reference.LocalCenterA;
			FP x = reference.InvMassA;
			FP x2 = reference.InvIa;
			FVector2 v2 = reference.LocalCenterB;
			FP y = reference.InvMassB;
			FP x3 = reference.InvIb;
			int pointCount = reference.PointCount;
			FVector2 center = span2[indexA].Center;
			FP x4 = span2[indexA].Angle;
			FVector2 center2 = span2[indexB].Center;
			FP x5 = span2[indexB].Angle;
			for (int j = 0; j < pointCount; j++)
			{
				Transform xfA = default(Transform);
				Transform xfB = xfA;
				xfA.Rotation.Set(x4);
				xfB.Rotation.Set(x5);
				xfA.Position = center - MathUtils.Mul(in xfA.Rotation, in v);
				xfB.Position = center2 - MathUtils.Mul(in xfB.Rotation, in v2);
				PositionSolverManifold positionSolverManifold = default(PositionSolverManifold);
				positionSolverManifold.Initialize(in reference, in xfA, in xfB, j);
				FVector2 b = positionSolverManifold.Normal;
				FVector2 point = positionSolverManifold.Point;
				FP x6 = positionSolverManifold.Separation;
				FVector2 a = point - center;
				FVector2 a2 = point - center2;
				fP = FP.Min(fP, x6);
				y2 = x6 + Settings.LinearSlop;
				FP fP2 = MathUtils.Clamp(Settings.Baumgarte * y2, -Settings.MaxLinearCorrection, 0f);
				FP y3 = MathUtils.Cross(in a, in b);
				FP y4 = MathUtils.Cross(in a2, in b);
				y2 = x + y;
				FP x7 = x2 * y3;
				FP y5 = x7 * y3;
				FP x8 = y2 + y5;
				FP x9 = x3 * y4;
				FP y6 = x9 * y4;
				FP fP3 = x8 + y6;
				FVector2 b2 = ((fP3 > FP.Zero) ? (-fP2 / fP3) : FP.Zero) * b;
				center -= x * b2;
				y2 = MathUtils.Cross(in a, in b2);
				x7 = x2 * y2;
				x4 -= x7;
				center2 += y * b2;
				y2 = MathUtils.Cross(in a2, in b2);
				x7 = x3 * y2;
				x5 += x7;
			}
			span2[indexA].Center = center;
			span2[indexA].Angle = x4;
			span2[indexB].Center = center2;
			span2[indexB].Angle = x5;
		}
		FP fP4 = fP;
		y2 = -3f;
		return fP4 >= y2 * Settings.LinearSlop;
	}

	public bool SolveTOIPositionConstraints(int toiIndexA, int toiIndexB)
	{
		FP fP = FP.Zero;
		Span<ContactPositionConstraint> span = PositionConstraints;
		Span<Position> span2 = _positions;
		FP y2;
		for (int i = 0; i < _contactCount; i++)
		{
			ref ContactPositionConstraint reference = ref span[i];
			int indexA = reference.IndexA;
			int indexB = reference.IndexB;
			FVector2 v = reference.LocalCenterA;
			FVector2 v2 = reference.LocalCenterB;
			int pointCount = reference.PointCount;
			FP x = FP.Zero;
			FP x2 = FP.Zero;
			if (indexA == toiIndexA || indexA == toiIndexB)
			{
				x = reference.InvMassA;
				x2 = reference.InvIa;
			}
			FP y = FP.Zero;
			FP x3 = FP.Zero;
			if (indexB == toiIndexA || indexB == toiIndexB)
			{
				y = reference.InvMassB;
				x3 = reference.InvIb;
			}
			FVector2 center = span2[indexA].Center;
			FP x4 = span2[indexA].Angle;
			FVector2 center2 = span2[indexB].Center;
			FP x5 = span2[indexB].Angle;
			for (int j = 0; j < pointCount; j++)
			{
				Transform xfA = default(Transform);
				Transform xfB = default(Transform);
				xfA.Rotation.Set(x4);
				xfB.Rotation.Set(x5);
				xfA.Position = center - MathUtils.Mul(in xfA.Rotation, in v);
				xfB.Position = center2 - MathUtils.Mul(in xfB.Rotation, in v2);
				PositionSolverManifold positionSolverManifold = default(PositionSolverManifold);
				positionSolverManifold.Initialize(in reference, in xfA, in xfB, j);
				FVector2 b = positionSolverManifold.Normal;
				FVector2 point = positionSolverManifold.Point;
				FP x6 = positionSolverManifold.Separation;
				FVector2 a = point - center;
				FVector2 a2 = point - center2;
				fP = FP.Min(fP, x6);
				y2 = x6 + Settings.LinearSlop;
				FP fP2 = MathUtils.Clamp(Settings.ToiBaumgarte * y2, -Settings.MaxLinearCorrection, 0f);
				FP y3 = MathUtils.Cross(in a, in b);
				FP y4 = MathUtils.Cross(in a2, in b);
				y2 = x + y;
				FP x7 = x2 * y3;
				FP y5 = x7 * y3;
				FP x8 = y2 + y5;
				FP x9 = x3 * y4;
				FP y6 = x9 * y4;
				FP fP3 = x8 + y6;
				FVector2 b2 = ((fP3 > FP.Zero) ? (-fP2 / fP3) : FP.Zero) * b;
				center -= x * b2;
				y2 = MathUtils.Cross(in a, in b2);
				x7 = x2 * y2;
				x4 -= x7;
				center2 += y * b2;
				y2 = MathUtils.Cross(in a2, in b2);
				x7 = x3 * y2;
				x5 += x7;
			}
			_positions[indexA].Center = center;
			_positions[indexA].Angle = x4;
			_positions[indexB].Center = center2;
			_positions[indexB].Angle = x5;
		}
		FP fP4 = fP;
		y2 = -1.5f;
		return fP4 >= y2 * Settings.LinearSlop;
	}
}
