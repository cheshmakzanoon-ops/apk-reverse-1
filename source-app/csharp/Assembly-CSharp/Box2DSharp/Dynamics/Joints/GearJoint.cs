using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class GearJoint : Joint
{
	private readonly Body _bodyC;

	private readonly Body _bodyD;

	private readonly FP _constant;

	private readonly Joint _joint1;

	private readonly Joint _joint2;

	private readonly FVector2 _localAnchorA;

	private readonly FVector2 _localAnchorB;

	private readonly FVector2 _localAnchorC;

	private readonly FVector2 _localAnchorD;

	private readonly FVector2 _localAxisC;

	private readonly FVector2 _localAxisD;

	private readonly FP _referenceAngleA;

	private readonly FP _referenceAngleB;

	private readonly JointType _typeA;

	private readonly JointType _typeB;

	private FP _iA;

	private FP _iB;

	private FP _iC;

	private FP _iD;

	private FP _impulse;

	private int _indexA;

	private int _indexB;

	private int _indexC;

	private int _indexD;

	private FVector2 _jvAc;

	private FVector2 _jvBd;

	private FP _jwA;

	private FP _jwB;

	private FP _jwC;

	private FP _jwD;

	private FVector2 _lcA;

	private FVector2 _lcB;

	private FVector2 _lcC;

	private FVector2 _lcD;

	private FP _mA;

	private FP _mB;

	private FP _mC;

	private FP _mD;

	private FP _mass;

	private FP _ratio;

	private FP _tolerance;

	public GearJoint(GearJointDef def)
		: base(def)
	{
		_joint1 = def.Joint1;
		_joint2 = def.Joint2;
		_typeA = _joint1.JointType;
		_typeB = _joint2.JointType;
		_bodyC = _joint1.BodyA;
		BodyA = _joint1.BodyB;
		Transform transform = BodyA.Transform;
		FP x = BodyA.Sweep.A;
		Transform transform2 = _bodyC.Transform;
		FP y = _bodyC.Sweep.A;
		FP x3;
		FP x2;
		if (_typeA == JointType.RevoluteJoint)
		{
			RevoluteJoint revoluteJoint = (RevoluteJoint)def.Joint1;
			_localAnchorC = revoluteJoint.LocalAnchorA;
			_localAnchorA = revoluteJoint.LocalAnchorB;
			_referenceAngleA = revoluteJoint.ReferenceAngle;
			_localAxisC.SetZero();
			x2 = x - y;
			x3 = x2 - _referenceAngleA;
			_tolerance = Settings.AngularSlop;
		}
		else
		{
			PrismaticJoint prismaticJoint = (PrismaticJoint)def.Joint1;
			_localAnchorC = prismaticJoint.LocalAnchorA;
			_localAnchorA = prismaticJoint.LocalAnchorB;
			_referenceAngleA = prismaticJoint.ReferenceAngle;
			_localAxisC = prismaticJoint.LocalXAxisA;
			FVector2 localAnchorC = _localAnchorC;
			ref Rotation rotation = ref transform2.Rotation;
			FVector2 v = MathUtils.Mul(in transform.Rotation, in _localAnchorA) + (transform.Position - transform2.Position);
			x3 = FVector2.Dot(MathUtils.MulT(in rotation, in v) - localAnchorC, _localAxisC);
			_tolerance = Settings.LinearSlop;
		}
		_bodyD = _joint2.BodyA;
		BodyB = _joint2.BodyB;
		Transform transform3 = BodyB.Transform;
		FP x4 = BodyB.Sweep.A;
		Transform transform4 = _bodyD.Transform;
		FP y2 = _bodyD.Sweep.A;
		FP y3;
		if (_typeB == JointType.RevoluteJoint)
		{
			RevoluteJoint revoluteJoint2 = (RevoluteJoint)def.Joint2;
			_localAnchorD = revoluteJoint2.LocalAnchorA;
			_localAnchorB = revoluteJoint2.LocalAnchorB;
			_referenceAngleB = revoluteJoint2.ReferenceAngle;
			_localAxisD.SetZero();
			x2 = x4 - y2;
			y3 = x2 - _referenceAngleB;
		}
		else
		{
			PrismaticJoint prismaticJoint2 = (PrismaticJoint)def.Joint2;
			_localAnchorD = prismaticJoint2.LocalAnchorA;
			_localAnchorB = prismaticJoint2.LocalAnchorB;
			_referenceAngleB = prismaticJoint2.ReferenceAngle;
			_localAxisD = prismaticJoint2.LocalXAxisA;
			FVector2 localAnchorD = _localAnchorD;
			ref Rotation rotation2 = ref transform4.Rotation;
			FVector2 v = MathUtils.Mul(in transform3.Rotation, in _localAnchorB) + (transform3.Position - transform4.Position);
			y3 = FVector2.Dot(MathUtils.MulT(in rotation2, in v) - localAnchorD, _localAxisD);
		}
		_ratio = def.Ratio;
		x2 = _ratio * y3;
		_constant = x3 + x2;
		_impulse = 0f;
	}

	public Joint GetJoint1()
	{
		return _joint1;
	}

	public Joint GetJoint2()
	{
		return _joint2;
	}

	public void SetRatio(FP ratio)
	{
		_ratio = ratio;
	}

	public FP GetRatio()
	{
		return _ratio;
	}

	public override void Dump()
	{
		int islandIndex = BodyA.IslandIndex;
		int islandIndex2 = BodyB.IslandIndex;
		_ = _joint1.Index;
		int index = _joint2.Index;
		DumpLogger.Log("  b2GearJointDef jd;");
		DumpLogger.Log($"  jd.bodyA = bodies[{islandIndex}];");
		DumpLogger.Log($"  jd.bodyB = bodies[{islandIndex2}];");
		DumpLogger.Log($"  jd.collideConnected = bool({CollideConnected});");
		DumpLogger.Log("  jd.joint1 = joints[index1];");
		DumpLogger.Log($"  jd.joint2 = joints[{index}];");
		DumpLogger.Log($"  jd.ratio = {_ratio};");
		DumpLogger.Log($"  joints[{Index}] = m_world.CreateJoint(&jd);");
	}

	public override FVector2 GetAnchorA()
	{
		return BodyA.GetWorldPoint(in _localAnchorA);
	}

	public override FVector2 GetAnchorB()
	{
		return BodyB.GetWorldPoint(in _localAnchorB);
	}

	public override FVector2 GetReactionForce(FP inv_dt)
	{
		FVector2 fVector = _impulse * _jvAc;
		return inv_dt * fVector;
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		FP y = _impulse * _jwA;
		return inv_dt * y;
	}

	internal override void InitVelocityConstraints(in SolverData data)
	{
		_indexA = BodyA.IslandIndex;
		_indexB = BodyB.IslandIndex;
		_indexC = _bodyC.IslandIndex;
		_indexD = _bodyD.IslandIndex;
		_lcA = BodyA.Sweep.LocalCenter;
		_lcB = BodyB.Sweep.LocalCenter;
		_lcC = _bodyC.Sweep.LocalCenter;
		_lcD = _bodyD.Sweep.LocalCenter;
		_mA = BodyA.InvMass;
		_mB = BodyB.InvMass;
		_mC = _bodyC.InvMass;
		_mD = _bodyD.InvMass;
		_iA = BodyA.InverseInertia;
		_iB = BodyB.InverseInertia;
		_iC = _bodyC.InverseInertia;
		_iD = _bodyD.InverseInertia;
		FP angle = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FP angle2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x2 = data.Velocities[_indexB].W;
		FP angle3 = data.Positions[_indexC].Angle;
		FVector2 v3 = data.Velocities[_indexC].V;
		FP x3 = data.Velocities[_indexC].W;
		FP angle4 = data.Positions[_indexD].Angle;
		FVector2 v4 = data.Velocities[_indexD].V;
		FP x4 = data.Velocities[_indexD].W;
		Rotation q = new Rotation(angle);
		Rotation q2 = new Rotation(angle2);
		Rotation q3 = new Rotation(angle3);
		Rotation q4 = new Rotation(angle4);
		_mass = 0f;
		if (_typeA == JointType.RevoluteJoint)
		{
			_jvAc.SetZero();
			_jwA = 1f;
			_jwC = 1f;
			ref FP mass = ref _mass;
			FP y = _iA + _iC;
			_mass = mass + y;
		}
		else
		{
			FVector2 b = MathUtils.Mul(in q3, in _localAxisC);
			FVector2 v5 = _localAnchorC - _lcC;
			FVector2 a = MathUtils.Mul(in q3, in v5);
			v5 = _localAnchorA - _lcA;
			FVector2 a2 = MathUtils.Mul(in q, in v5);
			_jvAc = b;
			_jwC = MathUtils.Cross(in a, in b);
			_jwA = MathUtils.Cross(in a2, in b);
			ref FP mass2 = ref _mass;
			FP y = _mC + _mA;
			FP x5 = _iC * _jwC;
			FP y2 = x5 * _jwC;
			FP x6 = y + y2;
			FP x7 = _iA * _jwA;
			FP y3 = x7 * _jwA;
			FP y4 = x6 + y3;
			_mass = mass2 + y4;
		}
		if (_typeB == JointType.RevoluteJoint)
		{
			_jvBd.SetZero();
			_jwB = _ratio;
			_jwD = _ratio;
			ref FP mass3 = ref _mass;
			FP y = _ratio * _ratio;
			FP x5 = _iB + _iD;
			FP y2 = y * x5;
			_mass = mass3 + y2;
		}
		else
		{
			FVector2 b2 = MathUtils.Mul(in q4, in _localAxisD);
			FVector2 v5 = _localAnchorD - _lcD;
			FVector2 a3 = MathUtils.Mul(in q4, in v5);
			v5 = _localAnchorB - _lcB;
			FVector2 a4 = MathUtils.Mul(in q2, in v5);
			_jvBd = _ratio * b2;
			ref FP ratio = ref _ratio;
			FP y = MathUtils.Cross(in a3, in b2);
			_jwD = ratio * y;
			ref FP ratio2 = ref _ratio;
			y = MathUtils.Cross(in a4, in b2);
			_jwB = ratio2 * y;
			ref FP mass4 = ref _mass;
			y = _ratio * _ratio;
			FP x5 = _mD + _mB;
			FP y2 = y * x5;
			FP x6 = _iD * _jwD;
			FP x7 = x6 * _jwD;
			FP y3 = y2 + x7;
			FP y4 = _iB * _jwB;
			FP y5 = y4 * _jwB;
			FP y6 = y3 + y5;
			_mass = mass4 + y6;
		}
		_mass = ((_mass > FP.Zero) ? (FP.One / _mass) : FP.Zero);
		if (data.Step.WarmStarting)
		{
			v += _mA * _impulse * _jvAc;
			FP y = _iA * _impulse;
			FP x5 = y * _jwA;
			x += x5;
			v2 += _mB * _impulse * _jvBd;
			y = _iB * _impulse;
			x5 = y * _jwB;
			x2 += x5;
			v3 -= _mC * _impulse * _jvAc;
			y = _iC * _impulse;
			x5 = y * _jwC;
			x3 -= x5;
			v4 -= _mD * _impulse * _jvBd;
			y = _iD * _impulse;
			x5 = y * _jwD;
			x4 -= x5;
		}
		else
		{
			_impulse = 0f;
		}
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = x;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = x2;
		data.Velocities[_indexC].V = v3;
		data.Velocities[_indexC].W = x3;
		data.Velocities[_indexD].V = v4;
		data.Velocities[_indexD].W = x4;
	}

	internal override void SolveVelocityConstraints(in SolverData data)
	{
		FVector2 v = data.Velocities[_indexA].V;
		FP y = data.Velocities[_indexA].W;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP y2 = data.Velocities[_indexB].W;
		FVector2 v3 = data.Velocities[_indexC].V;
		FP y3 = data.Velocities[_indexC].W;
		FVector2 v4 = data.Velocities[_indexD].V;
		FP y4 = data.Velocities[_indexD].W;
		FP x = FVector2.Dot(_jvAc, v - v3);
		FP y5 = FVector2.Dot(_jvBd, v2 - v4);
		FP x2 = x + y5;
		x = _jwA * y;
		y5 = _jwC * y3;
		FP x3 = x - y5;
		FP x4 = _jwB * y2;
		FP y6 = _jwD * y4;
		FP y7 = x4 - y6;
		FP y8 = x3 + y7;
		x2 += y8;
		x = -_mass;
		FP y9 = x * x2;
		_impulse += y9;
		v += _mA * y9 * _jvAc;
		x = _iA * y9;
		y5 = x * _jwA;
		y += y5;
		v2 += _mB * y9 * _jvBd;
		x = _iB * y9;
		y5 = x * _jwB;
		y2 += y5;
		v3 -= _mC * y9 * _jvAc;
		x = _iC * y9;
		y5 = x * _jwC;
		y3 -= y5;
		v4 -= _mD * y9 * _jvBd;
		x = _iD * y9;
		y5 = x * _jwD;
		y4 -= y5;
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = y;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = y2;
		data.Velocities[_indexC].V = v3;
		data.Velocities[_indexC].W = y3;
		data.Velocities[_indexD].V = v4;
		data.Velocities[_indexD].W = y4;
	}

	internal override bool SolvePositionConstraints(in SolverData data)
	{
		FVector2 center = data.Positions[_indexA].Center;
		FP x = data.Positions[_indexA].Angle;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP x2 = data.Positions[_indexB].Angle;
		FVector2 center3 = data.Positions[_indexC].Center;
		FP y = data.Positions[_indexC].Angle;
		FVector2 center4 = data.Positions[_indexD].Center;
		FP y2 = data.Positions[_indexD].Angle;
		Rotation q = new Rotation(x);
		Rotation q2 = new Rotation(x2);
		Rotation q3 = new Rotation(y);
		Rotation q4 = new Rotation(y2);
		FVector2 vector = default(FVector2);
		FVector2 vector2 = default(FVector2);
		FP x3 = FP.Zero;
		FP y3;
		FP y4;
		FP x4;
		FP y5;
		FP x5;
		if (_typeA == JointType.RevoluteJoint)
		{
			vector.SetZero();
			y3 = 1f;
			y4 = 1f;
			y5 = _iA + _iC;
			x3 += y5;
			y5 = x - y;
			x4 = y5 - _referenceAngleA;
		}
		else
		{
			FVector2 b = MathUtils.Mul(in q3, in _localAxisC);
			FVector2 v = _localAnchorC - _lcC;
			FVector2 a = MathUtils.Mul(in q3, in v);
			v = _localAnchorA - _lcA;
			FVector2 a2 = MathUtils.Mul(in q, in v);
			vector = b;
			y4 = MathUtils.Cross(in a, in b);
			y3 = MathUtils.Cross(in a2, in b);
			y5 = _mC + _mA;
			x5 = _iC * y4;
			FP y6 = x5 * y4;
			FP x6 = y5 + y6;
			FP x7 = _iA * y3;
			FP y7 = x7 * y3;
			FP y8 = x6 + y7;
			x3 += y8;
			FVector2 fVector = _localAnchorC - _lcC;
			v = a2 + (center - center3);
			x4 = FVector2.Dot(MathUtils.MulT(in q3, in v) - fVector, _localAxisC);
		}
		FP y9;
		FP y10;
		FP y11;
		if (_typeB == JointType.RevoluteJoint)
		{
			vector2.SetZero();
			y9 = _ratio;
			y10 = _ratio;
			y5 = _ratio * _ratio;
			x5 = _iB + _iD;
			FP y6 = y5 * x5;
			x3 += y6;
			y5 = x2 - y2;
			y11 = y5 - _referenceAngleB;
		}
		else
		{
			FVector2 b2 = MathUtils.Mul(in q4, in _localAxisD);
			FVector2 v = _localAnchorD - _lcD;
			FVector2 a3 = MathUtils.Mul(in q4, in v);
			v = _localAnchorB - _lcB;
			FVector2 a4 = MathUtils.Mul(in q2, in v);
			vector2 = _ratio * b2;
			ref FP ratio = ref _ratio;
			y5 = MathUtils.Cross(in a3, in b2);
			y10 = ratio * y5;
			ref FP ratio2 = ref _ratio;
			y5 = MathUtils.Cross(in a4, in b2);
			y9 = ratio2 * y5;
			y5 = _ratio * _ratio;
			x5 = _mD + _mB;
			FP y6 = y5 * x5;
			FP x6 = _iD * y10;
			FP x7 = x6 * y10;
			FP y7 = y6 + x7;
			FP y8 = _iB * y9;
			FP y12 = y8 * y9;
			FP y13 = y7 + y12;
			x3 += y13;
			FVector2 fVector2 = _localAnchorD - _lcD;
			v = a4 + (center2 - center4);
			y11 = FVector2.Dot(MathUtils.MulT(in q4, in v) - fVector2, _localAxisD);
		}
		y5 = _ratio * y11;
		x5 = x4 + y5;
		FP fP = x5 - _constant;
		FP y14 = FP.Zero;
		if (x3 > 0f)
		{
			y14 = -fP / x3;
		}
		center += _mA * y14 * vector;
		y5 = _iA * y14;
		x5 = y5 * y3;
		x += x5;
		center2 += _mB * y14 * vector2;
		y5 = _iB * y14;
		x5 = y5 * y9;
		x2 += x5;
		center3 -= _mC * y14 * vector;
		y5 = _iC * y14;
		x5 = y5 * y4;
		y -= x5;
		center4 -= _mD * y14 * vector2;
		y5 = _iD * y14;
		x5 = y5 * y10;
		y2 -= x5;
		data.Positions[_indexA].Center = center;
		data.Positions[_indexA].Angle = x;
		data.Positions[_indexB].Center = center2;
		data.Positions[_indexB].Angle = x2;
		data.Positions[_indexC].Center = center3;
		data.Positions[_indexC].Angle = y;
		data.Positions[_indexD].Center = center4;
		data.Positions[_indexD].Angle = y2;
		return FMath.Abs(fP) < _tolerance;
	}
}
