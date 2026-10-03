using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class FrictionJoint : Joint
{
	private FP _angularImpulse;

	private FP _angularMass;

	private int _indexA;

	private int _indexB;

	private FP _invIa;

	private FP _invIb;

	private FP _invMassA;

	private FP _invMassB;

	private FVector2 _linearImpulse;

	private Matrix2x2 _linearMass;

	private FVector2 _localAnchorA;

	private FVector2 _localAnchorB;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private FP _maxForce;

	private FP _maxTorque;

	private FVector2 _rA;

	private FVector2 _rB;

	public FP MaxForce
	{
		get
		{
			return _maxForce;
		}
		set
		{
			_maxForce = value;
		}
	}

	public FP MaxTorque
	{
		get
		{
			return _maxTorque;
		}
		set
		{
			_maxTorque = value;
		}
	}

	internal FrictionJoint(FrictionJointDef def)
		: base(def)
	{
		_localAnchorA = def.LocalAnchorA;
		_localAnchorB = def.LocalAnchorB;
		_linearImpulse.SetZero();
		_angularImpulse = 0f;
		_maxForce = def.MaxForce;
		_maxTorque = def.MaxTorque;
	}

	public FVector2 GetLocalAnchorA()
	{
		return _localAnchorA;
	}

	public FVector2 GetLocalAnchorB()
	{
		return _localAnchorB;
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
		return inv_dt * _linearImpulse;
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		return inv_dt * _angularImpulse;
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
		_invIa = BodyA.InverseInertia;
		_invIb = BodyB.InverseInertia;
		FP angle = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FP angle2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x2 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(angle);
		Rotation q2 = new Rotation(angle2);
		FVector2 v3 = _localAnchorA - _localCenterA;
		_rA = MathUtils.Mul(in q, in v3);
		v3 = _localAnchorB - _localCenterB;
		_rB = MathUtils.Mul(in q2, in v3);
		FP x3 = _invMassA;
		FP y = _invMassB;
		FP x4 = _invIa;
		FP x5 = _invIb;
		Matrix2x2 matrix2x = default(Matrix2x2);
		ref FVector2 ex = ref matrix2x.Ex;
		FP x6 = x3 + y;
		FP x7 = x4 * _rA.Y;
		FP y2 = x7 * _rA.Y;
		FP x8 = x6 + y2;
		FP x9 = x5 * _rB.Y;
		FP y3 = x9 * _rB.Y;
		ex.X = x8 + y3;
		ref FVector2 ex2 = ref matrix2x.Ex;
		x6 = -x4;
		x7 = x6 * _rA.X;
		y2 = x7 * _rA.Y;
		x8 = x5 * _rB.X;
		x9 = x8 * _rB.Y;
		ex2.Y = y2 - x9;
		matrix2x.Ey.X = matrix2x.Ex.Y;
		ref FVector2 ey = ref matrix2x.Ey;
		x6 = x3 + y;
		x7 = x4 * _rA.X;
		y2 = x7 * _rA.X;
		x8 = x6 + y2;
		x9 = x5 * _rB.X;
		y3 = x9 * _rB.X;
		ey.Y = x8 + y3;
		_linearMass = matrix2x.GetInverse();
		_angularMass = x4 + x5;
		if (_angularMass > 0f)
		{
			_angularMass = 1f / _angularMass;
		}
		if (data.Step.WarmStarting)
		{
			_linearImpulse *= data.Step.DtRatio;
			_angularImpulse *= data.Step.DtRatio;
			FVector2 b = new FVector2(_linearImpulse.X, _linearImpulse.Y);
			v -= x3 * b;
			x6 = MathUtils.Cross(in _rA, in b);
			x7 = x6 + _angularImpulse;
			y2 = x4 * x7;
			x -= y2;
			v2 += y * b;
			x6 = MathUtils.Cross(in _rB, in b);
			x7 = x6 + _angularImpulse;
			y2 = x5 * x7;
			x2 += y2;
		}
		else
		{
			_linearImpulse.SetZero();
			_angularImpulse = 0f;
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
		FP x = data.Velocities[_indexB].W;
		FP invMassA = _invMassA;
		FP invMassB = _invMassB;
		FP x2 = _invIa;
		FP x3 = _invIb;
		FP x4 = data.Step.Dt;
		FP y2 = x - y;
		FP x5 = -_angularMass;
		FP y3 = x5 * y2;
		FP y4 = _angularImpulse;
		FP fP = x4 * _maxTorque;
		_angularImpulse = MathUtils.Clamp(_angularImpulse + y3, -fP, fP);
		y3 = _angularImpulse - y4;
		x5 = x2 * y3;
		y -= x5;
		x5 = x3 * y3;
		x += x5;
		FVector2 v3 = v2 + MathUtils.Cross(x, in _rB) - v - MathUtils.Cross(y, in _rA);
		FVector2 fVector = -MathUtils.Mul(in _linearMass, in v3);
		FVector2 linearImpulse = _linearImpulse;
		_linearImpulse += fVector;
		FP x6 = x4 * _maxForce;
		if (_linearImpulse.LengthSquared() > x6 * x6)
		{
			_linearImpulse.Normalize();
			_linearImpulse *= x6;
		}
		fVector = _linearImpulse - linearImpulse;
		v -= invMassA * fVector;
		x5 = MathUtils.Cross(in _rA, in fVector);
		FP y5 = x2 * x5;
		y -= y5;
		v2 += invMassB * fVector;
		x5 = MathUtils.Cross(in _rB, in fVector);
		y5 = x3 * x5;
		x += y5;
		data.Velocities[_indexA].V = v;
		data.Velocities[_indexA].W = y;
		data.Velocities[_indexB].V = v2;
		data.Velocities[_indexB].W = x;
	}

	internal override bool SolvePositionConstraints(in SolverData data)
	{
		return true;
	}
}
