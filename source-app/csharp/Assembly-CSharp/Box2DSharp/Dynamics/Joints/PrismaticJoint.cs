using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class PrismaticJoint : Joint
{
	internal readonly FVector2 LocalAnchorA;

	internal readonly FVector2 LocalAnchorB;

	internal readonly FVector2 LocalXAxisA;

	internal readonly FVector2 LocalYAxisA;

	internal readonly FP ReferenceAngle;

	private FVector2 _impulse;

	private FP _motorImpulse;

	private FP _lowerImpulse;

	private FP _upperImpulse;

	private FP _lowerTranslation;

	private FP _upperTranslation;

	private FP _maxMotorForce;

	private FP _motorSpeed;

	private bool _enableLimit;

	private bool _enableMotor;

	private int _indexA;

	private int _indexB;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private FP _invMassA;

	private FP _invMassB;

	private FP _invIA;

	private FP _invIB;

	private FVector2 _axis;

	private FVector2 _perp;

	private FP _s1;

	private FP _s2;

	private FP _a1;

	private FP _a2;

	private Matrix2x2 _k;

	private FP _translation;

	private FP _axialMass;

	internal PrismaticJoint(PrismaticJointDef def)
		: base(def)
	{
		LocalAnchorA = def.LocalAnchorA;
		LocalAnchorB = def.LocalAnchorB;
		LocalXAxisA = def.LocalAxisA;
		LocalXAxisA.Normalize();
		LocalYAxisA = MathUtils.Cross(1f, in LocalXAxisA);
		ReferenceAngle = def.ReferenceAngle;
		_impulse.SetZero();
		_axialMass = 0f;
		_motorImpulse = 0f;
		_lowerImpulse = 0f;
		_upperImpulse = 0f;
		_lowerTranslation = def.LowerTranslation;
		_upperTranslation = def.UpperTranslation;
		_maxMotorForce = def.MaxMotorForce;
		_motorSpeed = def.MotorSpeed;
		_enableLimit = def.EnableLimit;
		_enableMotor = def.EnableMotor;
		_translation = 0f;
		_axis.SetZero();
		_perp.SetZero();
	}

	public FVector2 GetLocalAnchorA()
	{
		return LocalAnchorA;
	}

	public FVector2 GetLocalAnchorB()
	{
		return LocalAnchorB;
	}

	public FVector2 GetLocalAxisA()
	{
		return LocalXAxisA;
	}

	public FP GetReferenceAngle()
	{
		return ReferenceAngle;
	}

	public FP GetJointTranslation()
	{
		FVector2 worldPoint = BodyA.GetWorldPoint(in LocalAnchorA);
		FVector2 value = BodyB.GetWorldPoint(in LocalAnchorB) - worldPoint;
		FVector2 worldVector = BodyA.GetWorldVector(in LocalXAxisA);
		return FVector2.Dot(value, worldVector);
	}

	public FP GetJointSpeed()
	{
		Body bodyA = BodyA;
		Body bodyB = BodyB;
		ref Rotation rotation = ref bodyA.Transform.Rotation;
		FVector2 v = LocalAnchorA - bodyA.Sweep.LocalCenter;
		FVector2 a = MathUtils.Mul(in rotation, in v);
		ref Rotation rotation2 = ref bodyB.Transform.Rotation;
		v = LocalAnchorB - bodyB.Sweep.LocalCenter;
		FVector2 a2 = MathUtils.Mul(in rotation2, in v);
		FVector2 fVector = bodyA.Sweep.C + a;
		FVector2 value = bodyB.Sweep.C + a2 - fVector;
		FVector2 a3 = MathUtils.Mul(in bodyA.Transform.Rotation, in LocalXAxisA);
		FVector2 linearVelocity = bodyA.LinearVelocity;
		FVector2 linearVelocity2 = bodyB.LinearVelocity;
		FP angularVelocity = bodyA.AngularVelocity;
		FP angularVelocity2 = bodyB.AngularVelocity;
		FP x = FVector2.Dot(value, MathUtils.Cross(angularVelocity, in a3));
		FP y = FVector2.Dot(a3, linearVelocity2 + MathUtils.Cross(angularVelocity2, in a2) - linearVelocity - MathUtils.Cross(angularVelocity, in a));
		return x + y;
	}

	public bool IsLimitEnabled()
	{
		return _enableLimit;
	}

	public void EnableLimit(bool flag)
	{
		if (flag != _enableLimit)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_enableLimit = flag;
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
	}

	public FP GetLowerLimit()
	{
		return _lowerTranslation;
	}

	public FP GetUpperLimit()
	{
		return _upperTranslation;
	}

	public void SetLimits(FP lower, FP upper)
	{
		if (!lower.Equals(_lowerTranslation) || !upper.Equals(_upperTranslation))
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_lowerTranslation = lower;
			_upperTranslation = upper;
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
	}

	public bool IsMotorEnabled()
	{
		return _enableMotor;
	}

	public void EnableMotor(bool flag)
	{
		if (flag != _enableMotor)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_enableMotor = flag;
		}
	}

	public void SetMotorSpeed(FP speed)
	{
		if (speed != _motorSpeed)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_motorSpeed = speed;
		}
	}

	public FP GetMotorSpeed()
	{
		return _motorSpeed;
	}

	public void SetMaxMotorForce(FP force)
	{
		if (FP.Abs(force - _maxMotorForce) > 1E-06f)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_maxMotorForce = force;
		}
	}

	public FP GetMaxMotorForce()
	{
		return _maxMotorForce;
	}

	public FP GetMotorForce(FP inv_dt)
	{
		return inv_dt * _motorImpulse;
	}

	public override FVector2 GetAnchorA()
	{
		return BodyA.GetWorldPoint(in LocalAnchorA);
	}

	public override FVector2 GetAnchorB()
	{
		return BodyB.GetWorldPoint(in LocalAnchorB);
	}

	public override FVector2 GetReactionForce(FP inv_dt)
	{
		FVector2 fVector = _impulse.X * _perp;
		FP x = _motorImpulse + _lowerImpulse;
		return inv_dt * (fVector + (x - _upperImpulse) * _axis);
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		return inv_dt * _impulse.Y;
	}

	public override void Dump()
	{
	}

	internal override void InitVelocityConstraints(in SolverData data)
	{
		_indexA = BodyA.IslandIndex;
		_indexB = BodyB.IslandIndex;
		_localCenterA = BodyA.Sweep.LocalCenter;
		_localCenterB = BodyB.Sweep.LocalCenter;
		_invMassA = BodyA.InvMass;
		_invMassB = BodyB.InvMass;
		_invIA = BodyA.InverseInertia;
		_invIB = BodyB.InverseInertia;
		FVector2 center = data.Positions[_indexA].Center;
		FP angle = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP angle2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x2 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(angle);
		Rotation q2 = new Rotation(angle2);
		FVector2 v3 = LocalAnchorA - _localCenterA;
		FVector2 fVector = MathUtils.Mul(in q, in v3);
		v3 = LocalAnchorB - _localCenterB;
		FVector2 a = MathUtils.Mul(in q2, in v3);
		FVector2 fVector2 = center2 - center + a - fVector;
		FP x3 = _invMassA;
		FP y = _invMassB;
		FP x4 = _invIA;
		FP x5 = _invIB;
		_axis = MathUtils.Mul(in q, in LocalXAxisA);
		v3 = fVector2 + fVector;
		_a1 = MathUtils.Cross(in v3, in _axis);
		_a2 = MathUtils.Cross(in a, in _axis);
		FP x6 = x3 + y;
		FP x7 = x4 * _a1;
		FP y2 = x7 * _a1;
		FP x8 = x6 + y2;
		FP x9 = x5 * _a2;
		FP y3 = x9 * _a2;
		_axialMass = x8 + y3;
		if (_axialMass > 0f)
		{
			_axialMass = 1f / _axialMass;
		}
		_perp = MathUtils.Mul(in q, in LocalYAxisA);
		v3 = fVector2 + fVector;
		_s1 = MathUtils.Cross(in v3, in _perp);
		_s2 = MathUtils.Cross(in a, in _perp);
		x6 = x3 + y;
		x7 = x4 * _s1;
		y2 = x7 * _s1;
		x8 = x6 + y2;
		x9 = x5 * _s2;
		y3 = x9 * _s2;
		FP x10 = x8 + y3;
		x6 = x4 * _s1;
		x7 = x5 * _s2;
		FP fP = x6 + x7;
		FP y4 = x4 + x5;
		if (y4.Equals(0f))
		{
			y4 = 1f;
		}
		_k.Ex.Set(x10, fP);
		_k.Ey.Set(fP, y4);
		if (_enableLimit)
		{
			_translation = FVector2.Dot(_axis, fVector2);
		}
		else
		{
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
		if (!_enableMotor)
		{
			_motorImpulse = 0f;
		}
		if (data.Step.WarmStarting)
		{
			_impulse *= data.Step.DtRatio;
			_motorImpulse *= data.Step.DtRatio;
			_lowerImpulse = data.Step.DtRatio;
			_upperImpulse = data.Step.DtRatio;
			x6 = _motorImpulse + _lowerImpulse;
			FP x11 = x6 - _upperImpulse;
			FVector2 fVector3 = _impulse.X * _perp + x11 * _axis;
			x6 = _impulse.X * _s1;
			x7 = x6 + _impulse.Y;
			y2 = x11 * _a1;
			FP y5 = x7 + y2;
			x6 = _impulse.X * _s2;
			x7 = x6 + _impulse.Y;
			y2 = x11 * _a2;
			FP y6 = x7 + y2;
			v -= x3 * fVector3;
			x6 = x4 * y5;
			x -= x6;
			v2 += y * fVector3;
			x6 = x5 * y6;
			x2 += x6;
		}
		else
		{
			_impulse.SetZero();
			_motorImpulse = 0f;
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = x;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = x2;
	}

	internal override void SolveVelocityConstraints(in SolverData data)
	{
		FVector2 v = data.Velocities[_indexA].V;
		FP y = data.Velocities[_indexA].W;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP y2 = data.Velocities[_indexB].W;
		FP invMassA = _invMassA;
		FP invMassB = _invMassB;
		FP x = _invIA;
		FP x2 = _invIB;
		FP y3;
		FP x4;
		FP y4;
		FP x3;
		if (_enableMotor)
		{
			x3 = FVector2.Dot(_axis, v2 - v);
			y3 = _a2 * y2;
			x4 = x3 + y3;
			y4 = _a1 * y;
			FP y5 = x4 - y4;
			ref FP axialMass = ref _axialMass;
			x3 = _motorSpeed - y5;
			FP y6 = axialMass * x3;
			FP y7 = _motorImpulse;
			FP fP = data.Step.Dt * _maxMotorForce;
			_motorImpulse = MathUtils.Clamp(_motorImpulse + y6, -fP, fP);
			y6 = _motorImpulse - y7;
			FVector2 fVector = y6 * _axis;
			FP y8 = y6 * _a1;
			FP y9 = y6 * _a2;
			v -= invMassA * fVector;
			x3 = x * y8;
			y -= x3;
			v2 += invMassB * fVector;
			x3 = x2 * y9;
			y2 += x3;
		}
		x3 = FVector2.Dot(_perp, v2 - v);
		y3 = _s2 * y2;
		x4 = x3 + y3;
		y4 = _s1 * y;
		FVector2 fVector2 = default(FVector2);
		fVector2.X = x4 - y4;
		fVector2.Y = y2 - y;
		if (_enableLimit)
		{
			FP left = _translation - _lowerTranslation;
			x3 = FVector2.Dot(_axis, v2 - v);
			y3 = _a2 * y2;
			x4 = x3 + y3;
			y4 = _a1 * y;
			FP x5 = x4 - y4;
			x3 = -_axialMass;
			y3 = FP.Max(left, 0f);
			x4 = y3 * data.Step.InvDt;
			y4 = x5 + x4;
			FP y10 = x3 * y4;
			FP y11 = _lowerImpulse;
			_lowerImpulse = FP.Max(_lowerImpulse + y10, 0f);
			y10 = _lowerImpulse - y11;
			FVector2 fVector3 = y10 * _axis;
			FP y12 = y10 * _a1;
			FP y13 = y10 * _a2;
			v -= invMassA * fVector3;
			x3 = x * y12;
			y -= x3;
			v2 += invMassB * fVector3;
			x3 = x2 * y13;
			y2 += x3;
			FP left2 = _upperTranslation - _translation;
			x3 = FVector2.Dot(_axis, v - v2);
			y3 = _a1 * y;
			x4 = x3 + y3;
			y4 = _a2 * y2;
			FP x6 = x4 - y4;
			x3 = -_axialMass;
			y3 = FP.Max(left2, 0f);
			x4 = y3 * data.Step.InvDt;
			y4 = x6 + x4;
			FP y14 = x3 * y4;
			FP y15 = _upperImpulse;
			_upperImpulse = FP.Max(_upperImpulse + y14, 0f);
			y14 = _upperImpulse - y15;
			FVector2 fVector4 = y14 * _axis;
			FP y16 = y14 * _a1;
			FP y17 = y14 * _a2;
			v += invMassA * fVector4;
			x3 = x * y16;
			y += x3;
			v2 -= invMassB * fVector4;
			x3 = x2 * y17;
			y2 -= x3;
		}
		FVector2 fVector5 = default(FVector2);
		x3 = FVector2.Dot(_perp, v2 - v);
		y3 = _s2 * y2;
		x4 = x3 + y3;
		y4 = _s1 * y;
		fVector5.X = x4 - y4;
		fVector5.Y = y2 - y;
		FVector2 fVector6 = fVector5;
		ref Matrix2x2 k = ref _k;
		fVector5 = -fVector6;
		FVector2 fVector7 = k.Solve(in fVector5);
		_impulse += fVector7;
		FVector2 fVector8 = fVector7.X * _perp;
		x3 = fVector7.X * _s1;
		FP y18 = x3 + fVector7.Y;
		x3 = fVector7.X * _s2;
		FP y19 = x3 + fVector7.Y;
		v -= invMassA * fVector8;
		x3 = x * y18;
		y -= x3;
		v2 += invMassB * fVector8;
		x3 = x2 * y19;
		y2 += x3;
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = y;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = y2;
	}

	internal override bool SolvePositionConstraints(in SolverData data)
	{
		FVector2 center = data.Positions[_indexA].Center;
		FP y = data.Positions[_indexA].Angle;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP x = data.Positions[_indexB].Angle;
		Rotation q = new Rotation(y);
		Rotation q2 = new Rotation(x);
		FP x2 = _invMassA;
		FP y2 = _invMassB;
		FP x3 = _invIA;
		FP x4 = _invIB;
		FVector2 v = LocalAnchorA - _localCenterA;
		FVector2 fVector = MathUtils.Mul(in q, in v);
		v = LocalAnchorB - _localCenterB;
		FVector2 a = MathUtils.Mul(in q2, in v);
		FVector2 fVector2 = center2 + a - center - fVector;
		FVector2 b = MathUtils.Mul(in q, in LocalXAxisA);
		v = fVector2 + fVector;
		FP y3 = MathUtils.Cross(in v, in b);
		FP y4 = MathUtils.Cross(in a, in b);
		FVector2 b2 = MathUtils.Mul(in q, in LocalYAxisA);
		v = fVector2 + fVector;
		FP y5 = MathUtils.Cross(in v, in b2);
		FP y6 = MathUtils.Cross(in a, in b2);
		FVector3 fVector3 = default(FVector3);
		FVector2 fVector4 = default(FVector2);
		fVector4.X = FVector2.Dot(b2, fVector2);
		FP x5 = x - y;
		fVector4.Y = x5 - ReferenceAngle;
		FP fP = FP.Abs(fVector4.X);
		FP fP2 = FP.Abs(fVector4.Y);
		bool flag = false;
		FP z = FP.Zero;
		if (_enableLimit)
		{
			FP x6 = FVector2.Dot(b, fVector2);
			FP fP3 = FP.Abs(_upperTranslation - _lowerTranslation);
			x5 = 2f;
			if (fP3 < x5 * Settings.LinearSlop)
			{
				z = x6;
				fP = FP.Max(fP, FP.Abs(x6));
				flag = true;
			}
			else if (x6 <= _lowerTranslation)
			{
				z = FP.Min(x6 - _lowerTranslation, 0f);
				fP = FP.Max(fP, _lowerTranslation - x6);
				flag = true;
			}
			else if (x6 >= _upperTranslation)
			{
				z = FP.Max(x6 - _upperTranslation, 0f);
				fP = FP.Max(fP, x6 - _upperTranslation);
				flag = true;
			}
		}
		FP x7;
		FP y7;
		if (flag)
		{
			x5 = x2 + y2;
			x7 = x3 * y5;
			y7 = x7 * y5;
			FP x8 = x5 + y7;
			FP x9 = x4 * y6;
			FP y8 = x9 * y6;
			FP x10 = x8 + y8;
			x5 = x3 * y5;
			x7 = x4 * y6;
			FP fP4 = x5 + x7;
			x5 = x3 * y5;
			x7 = x5 * y3;
			y7 = x4 * y6;
			x8 = y7 * y4;
			FP fP5 = x7 + x8;
			FP y9 = x3 + x4;
			if (y9.Equals(0f))
			{
				y9 = 1f;
			}
			x5 = x3 * y3;
			x7 = x4 * y4;
			FP fP6 = x5 + x7;
			x5 = x2 + y2;
			x7 = x3 * y3;
			y7 = x7 * y3;
			x8 = x5 + y7;
			x9 = x4 * y4;
			y8 = x9 * y4;
			FP z2 = x8 + y8;
			Matrix3x3 matrix3x = default(Matrix3x3);
			matrix3x.Ex.Set(x10, fP4, fP5);
			matrix3x.Ey.Set(fP4, y9, fP6);
			matrix3x.Ez.Set(fP5, fP6, z2);
			FVector3 fVector5 = default(FVector3);
			fVector5.X = fVector4.X;
			fVector5.Y = fVector4.Y;
			fVector5.Z = z;
			FVector3 b3 = -fVector5;
			fVector3 = matrix3x.Solve33(in b3);
		}
		else
		{
			x5 = x2 + y2;
			x7 = x3 * y5;
			y7 = x7 * y5;
			FP x8 = x5 + y7;
			FP x9 = x4 * y6;
			FP y8 = x9 * y6;
			FP x11 = x8 + y8;
			x5 = x3 * y5;
			x7 = x4 * y6;
			FP fP7 = x5 + x7;
			FP y10 = x3 + x4;
			if (y10.Equals(0f))
			{
				y10 = 1f;
			}
			Matrix2x2 matrix2x = default(Matrix2x2);
			matrix2x.Ex.Set(x11, fP7);
			matrix2x.Ey.Set(fP7, y10);
			v = -fVector4;
			FVector2 fVector6 = matrix2x.Solve(in v);
			fVector3.X = fVector6.X;
			fVector3.Y = fVector6.Y;
			fVector3.Z = 0f;
		}
		FVector2 fVector7 = fVector3.X * b2 + fVector3.Z * b;
		x5 = fVector3.X * y5;
		x7 = x5 + fVector3.Y;
		y7 = fVector3.Z * y3;
		FP y11 = x7 + y7;
		x5 = fVector3.X * y6;
		x7 = x5 + fVector3.Y;
		y7 = fVector3.Z * y4;
		FP y12 = x7 + y7;
		center -= x2 * fVector7;
		x5 = x3 * y11;
		y -= x5;
		center2 += y2 * fVector7;
		x5 = x4 * y12;
		x += x5;
		data.Positions[_indexA].Center = center;
		data.Positions[_indexA].Angle = y;
		data.Positions[_indexB].Center = center2;
		data.Positions[_indexB].Angle = x;
		if (fP <= Settings.LinearSlop)
		{
			return fP2 <= Settings.AngularSlop;
		}
		return false;
	}

	public override void Draw(IDraw draw)
	{
		Transform T = BodyA.GetTransform();
		Transform T2 = BodyB.GetTransform();
		FVector2 p = MathUtils.Mul(in T, in LocalAnchorA);
		FVector2 p2 = MathUtils.Mul(in T2, in LocalAnchorB);
		FVector2 fVector = MathUtils.Mul(in T.Rotation, in LocalXAxisA);
		Color color = Color.FromArgb(0.7f, 0.7f, 0.7f);
		Color color2 = Color.FromArgb(0.3f, 0.9f, 0.3f);
		Color color3 = Color.FromArgb(0.9f, 0.3f, 0.3f);
		Color color4 = Color.FromArgb(0.3f, 0.3f, 0.9f);
		Color color5 = Color.FromArgb(0.4f, 0.4f, 0.4f);
		draw.DrawSegment(in p, in p2, in color5);
		if (_enableLimit)
		{
			FVector2 p3 = p + _lowerTranslation * fVector;
			FVector2 p4 = p + _upperTranslation * fVector;
			FVector2 fVector2 = MathUtils.Mul(in T.Rotation, in LocalYAxisA);
			draw.DrawSegment(in p3, in p4, in color);
			FVector2 p5 = p3 - 0.5f * fVector2;
			FVector2 p6 = p3 + 0.5f * fVector2;
			draw.DrawSegment(in p5, in p6, in color2);
			p5 = p4 - 0.5f * fVector2;
			p6 = p4 + 0.5f * fVector2;
			draw.DrawSegment(in p5, in p6, in color3);
		}
		else
		{
			FVector2 p5 = p - 1f * fVector;
			FVector2 p6 = p + 1f * fVector;
			draw.DrawSegment(in p5, in p6, in color);
		}
		draw.DrawPoint(in p, 5f, in color);
		draw.DrawPoint(in p2, 5f, in color4);
	}
}
