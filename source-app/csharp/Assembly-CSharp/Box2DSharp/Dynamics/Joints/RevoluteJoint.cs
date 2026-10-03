using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class RevoluteJoint : Joint
{
	internal readonly FP ReferenceAngle;

	private bool _enableLimit;

	private bool _enableMotor;

	private FVector2 _impulse;

	private int _indexA;

	private int _indexB;

	private FP _invIa;

	private FP _invIb;

	private Matrix2x2 _K;

	private FP _angle;

	private FP _axialMass;

	private FP _invMassA;

	private FP _invMassB;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private FP _lowerAngle;

	private FP _maxMotorTorque;

	private FP _motorImpulse;

	private FP _lowerImpulse;

	private FP _upperImpulse;

	private FP _motorSpeed;

	private FVector2 _rA;

	private FVector2 _rB;

	private FP _upperAngle;

	internal FVector2 LocalAnchorA;

	internal FVector2 LocalAnchorB;

	internal RevoluteJoint(RevoluteJointDef def)
		: base(def)
	{
		LocalAnchorA = def.LocalAnchorA;
		LocalAnchorB = def.LocalAnchorB;
		ReferenceAngle = def.ReferenceAngle;
		_impulse.SetZero();
		_motorImpulse = 0f;
		_axialMass = 0f;
		_lowerImpulse = 0f;
		_upperImpulse = 0f;
		_lowerAngle = def.LowerAngle;
		_upperAngle = def.UpperAngle;
		_maxMotorTorque = def.MaxMotorTorque;
		_motorSpeed = def.MotorSpeed;
		_enableLimit = def.EnableLimit;
		_enableMotor = def.EnableMotor;
		_angle = 0f;
	}

	public FVector2 GetLocalAnchorA()
	{
		return LocalAnchorA;
	}

	public FVector2 GetLocalAnchorB()
	{
		return LocalAnchorB;
	}

	public FP GetReferenceAngle()
	{
		return ReferenceAngle;
	}

	public FP GetJointAngle()
	{
		Body bodyA = BodyA;
		FP x = BodyB.Sweep.A - bodyA.Sweep.A;
		return x - ReferenceAngle;
	}

	public FP GetJointSpeed()
	{
		Body bodyA = BodyA;
		FP x = BodyB.AngularVelocity;
		FP y = bodyA.AngularVelocity;
		return x - y;
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
		return _lowerAngle;
	}

	public FP GetUpperLimit()
	{
		return _upperAngle;
	}

	public void SetLimits(FP lower, FP upper)
	{
		if (FP.Abs(lower - _lowerAngle) > Settings.Epsilon || FP.Abs(upper - _upperAngle) > Settings.Epsilon)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
			_lowerAngle = lower;
			_upperAngle = upper;
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

	public void SetMaxMotorTorque(FP torque)
	{
		if (torque != _maxMotorTorque)
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_maxMotorTorque = torque;
		}
	}

	public FP GetMaxMotorTorque()
	{
		return _maxMotorTorque;
	}

	public FP GetMotorTorque(FP inv_dt)
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
		FVector2 fVector = new FVector2(_impulse.X, _impulse.Y);
		return inv_dt * fVector;
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		FP x = _motorImpulse + _lowerImpulse;
		FP y = x - _upperImpulse;
		return inv_dt * y;
	}

	public override void Dump()
	{
		int islandIndex = BodyA.IslandIndex;
		int islandIndex2 = BodyB.IslandIndex;
		DumpLogger.Log("  b2RevoluteJointDef jd;");
		DumpLogger.Log($"  jd.bodyA = bodies[{islandIndex}];");
		DumpLogger.Log($"  jd.bodyB = bodies[{islandIndex2}];");
		DumpLogger.Log($"  jd.collideConnected = bool({CollideConnected});");
		DumpLogger.Log($"  jd.localAnchorA.Set({LocalAnchorA.X}, {LocalAnchorA.Y});");
		DumpLogger.Log($"  jd.localAnchorB.Set({LocalAnchorB.X}, {LocalAnchorB.Y});");
		DumpLogger.Log($"  jd.referenceAngle = {ReferenceAngle};");
		DumpLogger.Log($"  jd.enableLimit = bool({_enableLimit});");
		DumpLogger.Log($"  jd.lowerAngle = {_lowerAngle};");
		DumpLogger.Log($"  jd.upperAngle = {_upperAngle};");
		DumpLogger.Log($"  jd.enableMotor = bool({_enableMotor});");
		DumpLogger.Log($"  jd.motorSpeed = {_motorSpeed};");
		DumpLogger.Log($"  jd.maxMotorTorque = {_maxMotorTorque};");
		DumpLogger.Log($"  joints[{Index}] = m_world.CreateJoint(&jd);");
	}

	internal override void InitVelocityConstraints(in SolverData data)
	{
		_indexA = BodyA.IslandIndex;
		_indexB = BodyB.IslandIndex;
		_localCenterA = BodyA.Sweep.LocalCenter;
		_localCenterB = BodyB.Sweep.LocalCenter;
		_invMassA = BodyA.InvMass;
		_invMassB = BodyB.InvMass;
		_invIa = BodyA.InverseInertia;
		_invIb = BodyB.InverseInertia;
		FP y = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FP x2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x3 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(y);
		Rotation q2 = new Rotation(x2);
		FVector2 v3 = LocalAnchorA - _localCenterA;
		_rA = MathUtils.Mul(in q, in v3);
		v3 = LocalAnchorB - _localCenterB;
		_rB = MathUtils.Mul(in q2, in v3);
		FP x4 = _invMassA;
		FP y2 = _invMassB;
		FP y3 = _invIa;
		FP y4 = _invIb;
		ref FVector2 ex = ref _K.Ex;
		FP x5 = x4 + y2;
		FP x6 = _rA.Y * _rA.Y;
		FP y5 = x6 * y3;
		FP x7 = x5 + y5;
		FP x8 = _rB.Y * _rB.Y;
		FP y6 = x8 * y4;
		ex.X = x7 + y6;
		ref FVector2 ey = ref _K.Ey;
		x5 = -_rA.Y;
		x6 = x5 * _rA.X;
		y5 = x6 * y3;
		x7 = _rB.Y * _rB.X;
		x8 = x7 * y4;
		ey.X = y5 - x8;
		_K.Ex.Y = _K.Ey.X;
		ref FVector2 ey2 = ref _K.Ey;
		x5 = x4 + y2;
		x6 = _rA.X * _rA.X;
		y5 = x6 * y3;
		x7 = x5 + y5;
		x8 = _rB.X * _rB.X;
		y6 = x8 * y4;
		ey2.Y = x7 + y6;
		_axialMass = y3 + y4;
		bool flag;
		if (_axialMass > 0f)
		{
			_axialMass = 1f / _axialMass;
			flag = false;
		}
		else
		{
			flag = true;
		}
		x5 = x2 - y;
		_angle = x5 - ReferenceAngle;
		if (!_enableLimit || flag)
		{
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
		if (!_enableMotor || flag)
		{
			_motorImpulse = 0f;
		}
		if (data.Step.WarmStarting)
		{
			_impulse *= data.Step.DtRatio;
			_motorImpulse *= data.Step.DtRatio;
			_lowerImpulse *= data.Step.DtRatio;
			_upperImpulse *= data.Step.DtRatio;
			x5 = _motorImpulse + _lowerImpulse;
			FP y7 = x5 - _upperImpulse;
			FVector2 b = new FVector2(_impulse.X, _impulse.Y);
			v -= x4 * b;
			x5 = MathUtils.Cross(in _rA, in b);
			x6 = x5 + y7;
			y5 = y3 * x6;
			x -= y5;
			v2 += y2 * b;
			x5 = MathUtils.Cross(in _rB, in b);
			x6 = x5 + y7;
			y5 = y4 * x6;
			x3 += y5;
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
		data.Velocities[_indexB].W = x3;
	}

	internal override void SolveVelocityConstraints(in SolverData data)
	{
		FVector2 v = data.Velocities[_indexA].V;
		FP y = data.Velocities[_indexA].W;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x = data.Velocities[_indexB].W;
		FP invMassA = _invMassA;
		FP invMassB = _invMassB;
		FP x2 = _invIa;
		FP y2 = _invIb;
		bool flag = (x2 + y2).Equals(0f);
		FP x3;
		if (_enableMotor && !flag)
		{
			x3 = x - y;
			FP y3 = x3 - _motorSpeed;
			x3 = -_axialMass;
			FP y4 = x3 * y3;
			FP y5 = _motorImpulse;
			FP fP = data.Step.Dt * _maxMotorTorque;
			_motorImpulse = MathUtils.Clamp(_motorImpulse + y4, -fP, fP);
			y4 = _motorImpulse - y5;
			x3 = x2 * y4;
			y -= x3;
			x3 = y2 * y4;
			x += x3;
		}
		FP x5;
		if (_enableLimit && !flag)
		{
			FP left = _angle - _lowerAngle;
			FP x4 = x - y;
			x3 = -_axialMass;
			x5 = FP.Max(left, 0f);
			FP y6 = x5 * data.Step.InvDt;
			FP y7 = x4 + y6;
			FP y8 = x3 * y7;
			FP y9 = _lowerImpulse;
			_lowerImpulse = FP.Max(_lowerImpulse + y8, 0f);
			y8 = _lowerImpulse - y9;
			x3 = x2 * y8;
			y -= x3;
			x3 = y2 * y8;
			x += x3;
			FP left2 = _upperAngle - _angle;
			FP x6 = y - x;
			x3 = -_axialMass;
			x5 = FP.Max(left2, 0f);
			y6 = x5 * data.Step.InvDt;
			y7 = x6 + y6;
			FP y10 = x3 * y7;
			FP y11 = _upperImpulse;
			_upperImpulse = FP.Max(_upperImpulse + y10, 0f);
			y10 = _upperImpulse - y11;
			x3 = x2 * y10;
			y += x3;
			x3 = y2 * y10;
			x -= x3;
		}
		FVector2 fVector = v2 + MathUtils.Cross(x, in _rB) - v - MathUtils.Cross(y, in _rA);
		ref Matrix2x2 k = ref _K;
		FVector2 b = -fVector;
		FVector2 b2 = k.Solve(in b);
		ref FP x7 = ref _impulse.X;
		x7 += b2.X;
		ref FP y12 = ref _impulse.Y;
		y12 += b2.Y;
		v -= invMassA * b2;
		x3 = MathUtils.Cross(in _rA, in b2);
		x5 = x2 * x3;
		y -= x5;
		v2 += invMassB * b2;
		x3 = MathUtils.Cross(in _rB, in b2);
		x5 = y2 * x3;
		x += x5;
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = y;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = x;
	}

	internal override bool SolvePositionConstraints(in SolverData data)
	{
		FVector2 center = data.Positions[_indexA].Center;
		FP y = data.Positions[_indexA].Angle;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP x = data.Positions[_indexB].Angle;
		Rotation q = new Rotation(y);
		Rotation q2 = new Rotation(x);
		FP fP = FP.Zero;
		_ = FP.Zero;
		bool flag = (_invIa + _invIb).Equals(0f);
		FP x2;
		if (_enableLimit && !flag)
		{
			x2 = x - y;
			FP x3 = x2 - ReferenceAngle;
			FP y2 = 0f;
			FP fP2 = FP.Abs(_upperAngle - _lowerAngle);
			x2 = 2f;
			if (fP2 < x2 * Settings.AngularSlop)
			{
				y2 = MathUtils.Clamp(x3 - _lowerAngle, -Settings.MaxAngularCorrection, Settings.MaxAngularCorrection);
			}
			else if (x3 <= _lowerAngle)
			{
				x2 = x3 - _lowerAngle;
				y2 = MathUtils.Clamp(x2 + Settings.AngularSlop, -Settings.MaxAngularCorrection, 0f);
			}
			else if (x3 >= _upperAngle)
			{
				x2 = x3 - _upperAngle;
				y2 = MathUtils.Clamp(x2 - Settings.AngularSlop, 0f, Settings.MaxAngularCorrection);
			}
			x2 = -_axialMass;
			FP y3 = x2 * y2;
			x2 = _invIa * y3;
			y -= x2;
			x2 = _invIb * y3;
			x += x2;
			fP = FP.Abs(y2);
		}
		q.Set(y);
		q2.Set(x);
		FVector2 v = LocalAnchorA - _localCenterA;
		FVector2 a = MathUtils.Mul(in q, in v);
		v = LocalAnchorB - _localCenterB;
		FVector2 a2 = MathUtils.Mul(in q2, in v);
		FVector2 b = center2 + a2 - center - a;
		FP fP3 = b.Length();
		FP x4 = _invMassA;
		FP y4 = _invMassB;
		FP x5 = _invIa;
		FP x6 = _invIb;
		Matrix2x2 matrix2x = default(Matrix2x2);
		ref FVector2 ex = ref matrix2x.Ex;
		x2 = x4 + y4;
		FP x7 = x5 * a.Y;
		FP y5 = x7 * a.Y;
		FP x8 = x2 + y5;
		FP x9 = x6 * a2.Y;
		FP y6 = x9 * a2.Y;
		ex.X = x8 + y6;
		ref FVector2 ex2 = ref matrix2x.Ex;
		x2 = -x5;
		x7 = x2 * a.X;
		y5 = x7 * a.Y;
		x8 = x6 * a2.X;
		x9 = x8 * a2.Y;
		ex2.Y = y5 - x9;
		matrix2x.Ey.X = matrix2x.Ex.Y;
		ref FVector2 ey = ref matrix2x.Ey;
		x2 = x4 + y4;
		x7 = x5 * a.X;
		y5 = x7 * a.X;
		x8 = x2 + y5;
		x9 = x6 * a2.X;
		y6 = x9 * a2.X;
		ey.Y = x8 + y6;
		FVector2 b2 = -matrix2x.Solve(in b);
		center -= x4 * b2;
		x2 = MathUtils.Cross(in a, in b2);
		x7 = x5 * x2;
		y -= x7;
		center2 += y4 * b2;
		x2 = MathUtils.Cross(in a2, in b2);
		x7 = x6 * x2;
		x += x7;
		data.Positions[_indexA].Center = center;
		data.Positions[_indexA].Angle = y;
		data.Positions[_indexB].Center = center2;
		data.Positions[_indexB].Angle = x;
		if (fP3 <= Settings.LinearSlop)
		{
			return fP <= Settings.AngularSlop;
		}
		return false;
	}

	public override void Draw(IDraw draw)
	{
		Transform T = BodyA.GetTransform();
		Transform T2 = BodyB.GetTransform();
		FVector2 p = MathUtils.Mul(in T, in LocalAnchorA);
		FVector2 p2 = MathUtils.Mul(in T2, in LocalAnchorB);
		Color color = Color.FromArgb(0.7f, 0.7f, 0.7f);
		Color color2 = Color.FromArgb(0.3f, 0.9f, 0.3f);
		Color color3 = Color.FromArgb(0.9f, 0.3f, 0.3f);
		Color color4 = Color.FromArgb(0.3f, 0.3f, 0.9f);
		Color color5 = Color.FromArgb(0.4f, 0.4f, 0.4f);
		draw.DrawPoint(in p, 5f, in color4);
		draw.DrawPoint(in p2, 5f, in color5);
		FP y = BodyA.GetAngle();
		FP x = BodyB.GetAngle();
		FP x2 = x - y;
		FP x3 = x2 - ReferenceAngle;
		float num = 0.5f;
		FVector2 fVector = num * new FVector2(FP.Cos(x3), FP.Sin(x3));
		FVector2 p3 = p2 + fVector;
		draw.DrawSegment(in p2, in p3, in color);
		draw.DrawCircle(in p2, num, in color);
		if (_enableLimit)
		{
			FVector2 fVector2 = num * new FVector2(FP.Cos(_lowerAngle), FP.Cos(_lowerAngle));
			FVector2 fVector3 = num * new FVector2(FP.Cos(_upperAngle), FP.Cos(_upperAngle));
			p3 = p2 + fVector2;
			draw.DrawSegment(in p2, in p3, in color2);
			p3 = p2 + fVector3;
			draw.DrawSegment(in p2, in p3, in color3);
		}
		Color color6 = Color.FromArgb(0.5f, 0.8f, 0.8f);
		draw.DrawSegment(in T.Position, in p, in color6);
		draw.DrawSegment(in p, in p2, in color6);
		draw.DrawSegment(in T2.Position, in p2, in color6);
	}
}
