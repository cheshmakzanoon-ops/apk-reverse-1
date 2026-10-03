using System;
using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class WheelJoint : Joint
{
	private readonly FVector2 _localAnchorA;

	private readonly FVector2 _localAnchorB;

	private readonly FVector2 _localXAxisA;

	private readonly FVector2 _localYAxisA;

	private FP _impulse;

	private FP _motorImpulse;

	private FP _springImpulse;

	private FP _lowerImpulse;

	private FP _upperImpulse;

	private FP _translation;

	private FP _lowerTranslation;

	private FP _upperTranslation;

	private FP _maxMotorTorque;

	private FP _motorSpeed;

	private bool _enableLimit;

	private bool _enableMotor;

	private FP _stiffness;

	private FP _damping;

	private int _indexA;

	private int _indexB;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private FP _invMassA;

	private FP _invMassB;

	private FP _invIA;

	private FP _invIB;

	private FVector2 _ax;

	private FVector2 _ay;

	private FP _sAx;

	private FP _sBx;

	private FP _sAy;

	private FP _sBy;

	private FP _mass;

	private FP _motorMass;

	private FP _axialMass;

	private FP _springMass;

	private FP _bias;

	private FP _gamma;

	internal WheelJoint(WheelJointDef def)
		: base(def)
	{
		_localAnchorA = def.LocalAnchorA;
		_localAnchorB = def.LocalAnchorB;
		_localXAxisA = def.LocalAxisA;
		_localYAxisA = MathUtils.Cross(1f, in _localXAxisA);
		_mass = 0f;
		_impulse = 0f;
		_motorMass = 0f;
		_motorImpulse = 0f;
		_springMass = 0f;
		_springImpulse = 0f;
		_axialMass = 0f;
		_lowerImpulse = 0f;
		_upperImpulse = 0f;
		_lowerTranslation = def.LowerTranslation;
		_upperTranslation = def.UpperTranslation;
		_enableLimit = def.EnableLimit;
		_maxMotorTorque = def.MaxMotorTorque;
		_motorSpeed = def.MotorSpeed;
		_enableMotor = def.EnableMotor;
		_bias = 0f;
		_gamma = 0f;
		_ax.SetZero();
		_ay.SetZero();
		_stiffness = def.Stiffness;
		_damping = def.Damping;
	}

	public FVector2 GetLocalAnchorA()
	{
		return _localAnchorA;
	}

	public FVector2 GetLocalAnchorB()
	{
		return _localAnchorB;
	}

	public FVector2 GetLocalAxisA()
	{
		return _localXAxisA;
	}

	public FP GetJointTranslation()
	{
		Body bodyA = BodyA;
		Body bodyB = BodyB;
		FVector2 worldPoint = bodyA.GetWorldPoint(in _localAnchorA);
		FVector2 value = bodyB.GetWorldPoint(in _localAnchorB) - worldPoint;
		FVector2 worldVector = bodyA.GetWorldVector(in _localXAxisA);
		return FVector2.Dot(value, worldVector);
	}

	public FP GetJointLinearSpeed()
	{
		Body bodyA = BodyA;
		Body bodyB = BodyB;
		ref Rotation rotation = ref bodyA.Transform.Rotation;
		FVector2 v = _localAnchorA - bodyA.Sweep.LocalCenter;
		FVector2 a = MathUtils.Mul(in rotation, in v);
		ref Rotation rotation2 = ref bodyB.Transform.Rotation;
		v = _localAnchorB - bodyB.Sweep.LocalCenter;
		FVector2 a2 = MathUtils.Mul(in rotation2, in v);
		FVector2 fVector = bodyA.Sweep.C + a;
		FVector2 value = bodyB.Sweep.C + a2 - fVector;
		FVector2 a3 = MathUtils.Mul(in bodyA.Transform.Rotation, in _localXAxisA);
		FVector2 linearVelocity = bodyA.LinearVelocity;
		FVector2 linearVelocity2 = bodyB.LinearVelocity;
		FP angularVelocity = bodyA.AngularVelocity;
		FP angularVelocity2 = bodyB.AngularVelocity;
		FP x = FVector2.Dot(value, MathUtils.Cross(angularVelocity, in a3));
		FP y = FVector2.Dot(a3, linearVelocity2 + MathUtils.Cross(angularVelocity2, in a2) - linearVelocity - MathUtils.Cross(angularVelocity, in a));
		return x + y;
	}

	public FP GetJointAngle()
	{
		Body bodyA = BodyA;
		return BodyB.Sweep.A - bodyA.Sweep.A;
	}

	public FP GetJointAngularSpeed()
	{
		FP y = BodyA.AngularVelocity;
		FP x = BodyB.AngularVelocity;
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
		if (!speed.Equals(_motorSpeed))
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
		if (!torque.Equals(_maxMotorTorque))
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

	public void SetStiffness(FP stiffness)
	{
		_stiffness = stiffness;
	}

	public FP GetStiffness()
	{
		return _stiffness;
	}

	public void SetDamping(FP damping)
	{
		_damping = damping;
	}

	public FP GetDamping()
	{
		return _damping;
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
		FVector2 fVector = _impulse * _ay;
		FP x = _springImpulse + _lowerImpulse;
		return inv_dt * (fVector + (x - _upperImpulse) * _ax);
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		return inv_dt * _motorImpulse;
	}

	public override void Dump()
	{
		throw new NotImplementedException();
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
		FP x = _invMassA;
		FP y = _invMassB;
		FP x2 = _invIA;
		FP x3 = _invIB;
		FVector2 center = data.Positions[_indexA].Center;
		FP angle = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x4 = data.Velocities[_indexA].W;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP angle2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x5 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(angle);
		Rotation q2 = new Rotation(angle2);
		FVector2 v3 = _localAnchorA - _localCenterA;
		FVector2 fVector = MathUtils.Mul(in q, in v3);
		v3 = _localAnchorB - _localCenterB;
		FVector2 a = MathUtils.Mul(in q2, in v3);
		FVector2 fVector2 = center2 + a - center - fVector;
		_ay = MathUtils.Mul(in q, in _localYAxisA);
		v3 = fVector2 + fVector;
		_sAy = MathUtils.Cross(in v3, in _ay);
		_sBy = MathUtils.Cross(in a, in _ay);
		FP x6 = x + y;
		FP x7 = x2 * _sAy;
		FP y2 = x7 * _sAy;
		FP x8 = x6 + y2;
		FP x9 = x3 * _sBy;
		FP y3 = x9 * _sBy;
		_mass = x8 + y3;
		if (_mass > 0f)
		{
			_mass = 1f / _mass;
		}
		_ax = MathUtils.Mul(in q, in _localXAxisA);
		v3 = fVector2 + fVector;
		_sAx = MathUtils.Cross(in v3, in _ax);
		_sBx = MathUtils.Cross(in a, in _ax);
		x6 = x + y;
		x7 = x2 * _sAx;
		y2 = x7 * _sAx;
		x8 = x6 + y2;
		x9 = x3 * _sBx;
		y3 = x9 * _sBx;
		FP x10 = x8 + y3;
		if (x10 > 0f)
		{
			_axialMass = 1f / x10;
		}
		else
		{
			_axialMass = 0f;
		}
		_springMass = 0f;
		_bias = 0f;
		_gamma = 0f;
		if (_stiffness > 0f && x10 > 0f)
		{
			_springMass = 1f / x10;
			FP x11 = FVector2.Dot(fVector2, _ax);
			FP x12 = data.Step.Dt;
			ref FP damping = ref _damping;
			x6 = x12 * _stiffness;
			x7 = damping + x6;
			_gamma = x12 * x7;
			if (_gamma > 0f)
			{
				_gamma = 1f / _gamma;
			}
			x6 = x11 * x12;
			x7 = x6 * _stiffness;
			_bias = x7 * _gamma;
			_springMass = x10 + _gamma;
			if (_springMass > 0f)
			{
				_springMass = 1f / _springMass;
			}
		}
		else
		{
			_springImpulse = 0f;
		}
		if (_enableLimit)
		{
			_translation = FVector2.Dot(_ax, fVector2);
		}
		else
		{
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
		if (_enableMotor)
		{
			_motorMass = x2 + x3;
			if (_motorMass > 0f)
			{
				_motorMass = 1f / _motorMass;
			}
		}
		else
		{
			_motorMass = 0f;
			_motorImpulse = 0f;
		}
		if (data.Step.WarmStarting)
		{
			_impulse *= data.Step.DtRatio;
			_springImpulse *= data.Step.DtRatio;
			_motorImpulse *= data.Step.DtRatio;
			x6 = _springImpulse + _lowerImpulse;
			FP x13 = x6 - _upperImpulse;
			FVector2 fVector3 = _impulse * _ay + x13 * _ax;
			x6 = _impulse * _sAy;
			x7 = x13 * _sAx;
			y2 = x6 + x7;
			FP y4 = y2 + _motorImpulse;
			x6 = _impulse * _sBy;
			x7 = x13 * _sBx;
			y2 = x6 + x7;
			FP y5 = y2 + _motorImpulse;
			v -= _invMassA * fVector3;
			x6 = _invIA * y4;
			x4 -= x6;
			v2 += _invMassB * fVector3;
			x6 = _invIB * y5;
			x5 += x6;
		}
		else
		{
			_impulse = 0f;
			_springImpulse = 0f;
			_motorImpulse = 0f;
			_lowerImpulse = 0f;
			_upperImpulse = 0f;
		}
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = x4;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = x5;
	}

	internal override void SolveVelocityConstraints(in SolverData data)
	{
		FP invMassA = _invMassA;
		FP invMassB = _invMassB;
		FP x = _invIA;
		FP x2 = _invIB;
		FVector2 v = data.Velocities[_indexA].V;
		FP y = data.Velocities[_indexA].W;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP y2 = data.Velocities[_indexB].W;
		FP x3 = FVector2.Dot(_ax, v2 - v);
		FP y3 = _sBx * y2;
		FP x4 = x3 + y3;
		FP y4 = _sAx * y;
		FP x5 = x4 - y4;
		x3 = -_springMass;
		y3 = x5 + _bias;
		x4 = _gamma * _springImpulse;
		y4 = y3 + x4;
		FP y5 = x3 * y4;
		_springImpulse += y5;
		FVector2 fVector = y5 * _ax;
		FP y6 = y5 * _sAx;
		FP y7 = y5 * _sBx;
		v -= invMassA * fVector;
		x3 = x * y6;
		y -= x3;
		v2 += invMassB * fVector;
		x3 = x2 * y7;
		y2 += x3;
		x3 = y2 - y;
		FP y8 = x3 - _motorSpeed;
		x3 = -_motorMass;
		FP y9 = x3 * y8;
		FP y10 = _motorImpulse;
		FP fP = data.Step.Dt * _maxMotorTorque;
		_motorImpulse = MathUtils.Clamp(_motorImpulse + y9, -fP, fP);
		y9 = _motorImpulse - y10;
		x3 = x * y9;
		y -= x3;
		x3 = x2 * y9;
		y2 += x3;
		if (_enableLimit)
		{
			FP left = _translation - _lowerTranslation;
			x3 = FVector2.Dot(_ax, v2 - v);
			y3 = _sBx * y2;
			x4 = x3 + y3;
			y4 = _sAx * y;
			FP x6 = x4 - y4;
			x3 = -_axialMass;
			y3 = FP.Max(left, 0f);
			x4 = y3 * data.Step.InvDt;
			y4 = x6 + x4;
			FP y11 = x3 * y4;
			FP y12 = _lowerImpulse;
			_lowerImpulse = FP.Max(_lowerImpulse + y11, 0f);
			y11 = _lowerImpulse - y12;
			FVector2 fVector2 = y11 * _ax;
			FP y13 = y11 * _sAx;
			FP y14 = y11 * _sBx;
			v -= invMassA * fVector2;
			x3 = x * y13;
			y -= x3;
			v2 += invMassB * fVector2;
			x3 = x2 * y14;
			y2 += x3;
			FP left2 = _upperTranslation - _translation;
			x3 = FVector2.Dot(_ax, v - v2);
			y3 = _sAx * y;
			x4 = x3 + y3;
			y4 = _sBx * y2;
			FP x7 = x4 - y4;
			x3 = -_axialMass;
			y3 = FP.Max(left2, 0f);
			x4 = y3 * data.Step.InvDt;
			y4 = x7 + x4;
			FP y15 = x3 * y4;
			FP y16 = _upperImpulse;
			_upperImpulse = FP.Max(_upperImpulse + y15, 0f);
			y15 = _upperImpulse - y16;
			FVector2 fVector3 = y15 * _ax;
			FP y17 = y15 * _sAx;
			FP y18 = y15 * _sBx;
			v += invMassA * fVector3;
			x3 = x * y17;
			y += x3;
			v2 -= invMassB * fVector3;
			x3 = x2 * y18;
			y2 -= x3;
		}
		x3 = FVector2.Dot(_ay, v2 - v);
		y3 = _sBy * y2;
		x4 = x3 + y3;
		y4 = _sAy * y;
		FP y19 = x4 - y4;
		x3 = -_mass;
		FP y20 = x3 * y19;
		_impulse += y20;
		FVector2 fVector4 = y20 * _ay;
		FP y21 = y20 * _sAy;
		FP y22 = y20 * _sBy;
		v -= invMassA * fVector4;
		x3 = x * y21;
		y -= x3;
		v2 += invMassB * fVector4;
		x3 = x2 * y22;
		y2 += x3;
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = y;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = y2;
	}

	internal override bool SolvePositionConstraints(in SolverData data)
	{
		FVector2 center = data.Positions[_indexA].Center;
		FP x = data.Positions[_indexA].Angle;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP x2 = data.Positions[_indexB].Angle;
		FP left = FP.Zero;
		FVector2 v;
		FP x5;
		FP y3;
		FP x6;
		FP x7;
		FP y4;
		FP x4;
		if (_enableLimit)
		{
			Rotation q = new Rotation(x);
			Rotation q2 = new Rotation(x2);
			v = _localAnchorA - _localCenterA;
			FVector2 fVector = MathUtils.Mul(in q, in v);
			v = _localAnchorB - _localCenterB;
			FVector2 a = MathUtils.Mul(in q2, in v);
			FVector2 fVector2 = center2 - center + a - fVector;
			FVector2 fVector3 = MathUtils.Mul(in q, in _localXAxisA);
			v = fVector2 + fVector;
			FP y = MathUtils.Cross(in v, in _ax);
			FP y2 = MathUtils.Cross(in a, in _ax);
			FP fP = FP.Zero;
			FP x3 = FVector2.Dot(fVector3, fVector2);
			FP fP2 = FP.Abs(_upperTranslation - _lowerTranslation);
			x4 = 2f;
			if (fP2 < x4 * Settings.LinearSlop)
			{
				fP = x3;
			}
			else if (x3 <= _lowerTranslation)
			{
				fP = FP.Min(x3 - _lowerTranslation, 0f);
			}
			else if (x3 >= _upperTranslation)
			{
				fP = FP.Max(x3 - _upperTranslation, 0f);
			}
			if (fP != FP.Zero)
			{
				x4 = _invMassA + _invMassB;
				x5 = _invIA * y;
				y3 = x5 * y;
				x6 = x4 + y3;
				x7 = _invIB * y2;
				y4 = x7 * y2;
				FP fP3 = x6 + y4;
				FP x8 = FP.Zero;
				if (!fP3.Equals(0))
				{
					x8 = -fP / fP3;
				}
				FVector2 fVector4 = x8 * fVector3;
				FP y5 = x8 * y;
				FP y6 = x8 * y2;
				center -= _invMassA * fVector4;
				x4 = _invIA * y5;
				x -= x4;
				center2 += _invMassB * fVector4;
				x4 = _invIB * y6;
				x2 += x4;
				left = FP.Abs(fP);
			}
		}
		Rotation q3 = new Rotation(x);
		Rotation q4 = new Rotation(x2);
		v = _localAnchorA - _localCenterA;
		FVector2 fVector5 = MathUtils.Mul(in q3, in v);
		v = _localAnchorB - _localCenterB;
		FVector2 a2 = MathUtils.Mul(in q4, in v);
		FVector2 fVector6 = center2 - center + a2 - fVector5;
		FVector2 b = MathUtils.Mul(in q3, in _localYAxisA);
		v = fVector6 + fVector5;
		FP y7 = MathUtils.Cross(in v, in b);
		FP y8 = MathUtils.Cross(in a2, in b);
		FP fP4 = FVector2.Dot(fVector6, b);
		x4 = _invMassA + _invMassB;
		x5 = _invIA * _sAy;
		y3 = x5 * _sAy;
		x6 = x4 + y3;
		x7 = _invIB * _sBy;
		y4 = x7 * _sBy;
		FP fP5 = x6 + y4;
		FP x9 = FP.Zero;
		if (fP5 != FP.Zero)
		{
			x9 = -fP4 / fP5;
		}
		FVector2 fVector7 = x9 * b;
		FP y9 = x9 * y7;
		FP y10 = x9 * y8;
		center -= _invMassA * fVector7;
		x4 = _invIA * y9;
		x -= x4;
		center2 += _invMassB * fVector7;
		x4 = _invIB * y10;
		x2 += x4;
		left = FP.Max(left, FP.Abs(fP4));
		data.Positions[_indexA].Center = center;
		data.Positions[_indexA].Angle = x;
		data.Positions[_indexB].Center = center2;
		data.Positions[_indexB].Angle = x2;
		return left <= Settings.LinearSlop;
	}

	public override void Draw(IDraw draw)
	{
		Transform T = BodyA.GetTransform();
		Transform T2 = BodyB.GetTransform();
		FVector2 p = MathUtils.Mul(in T, in _localAnchorA);
		FVector2 p2 = MathUtils.Mul(in T2, in _localAnchorB);
		FVector2 fVector = MathUtils.Mul(in T.Rotation, in _localXAxisA);
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
			FVector2 fVector2 = MathUtils.Mul(in T.Rotation, in _localYAxisA);
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
