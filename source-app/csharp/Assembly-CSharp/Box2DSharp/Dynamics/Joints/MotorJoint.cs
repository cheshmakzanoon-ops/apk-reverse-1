using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class MotorJoint : Joint
{
	private FP _angularError;

	private FP _angularImpulse;

	private FP _angularMass;

	private FP _angularOffset;

	private FP _correctionFactor;

	private int _indexA;

	private int _indexB;

	private FP _invIa;

	private FP _invIb;

	private FP _invMassA;

	private FP _invMassB;

	private FVector2 _linearError;

	private FVector2 _linearImpulse;

	private Matrix2x2 _linearMass;

	private FVector2 _linearOffset;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private FP _maxForce;

	private FP _maxTorque;

	private FVector2 _rA;

	private FVector2 _rB;

	internal MotorJoint(MotorJointDef def)
		: base(def)
	{
		_linearOffset = def.LinearOffset;
		_angularOffset = def.AngularOffset;
		_linearImpulse.SetZero();
		_angularImpulse = 0f;
		_maxForce = def.MaxForce;
		_maxTorque = def.MaxTorque;
		_correctionFactor = def.CorrectionFactor;
	}

	public void SetLinearOffset(in FVector2 linearOffset)
	{
		if (!linearOffset.X.Equals(_linearOffset.X) || !linearOffset.Y.Equals(_linearOffset.Y))
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_linearOffset = linearOffset;
		}
	}

	public FVector2 GetLinearOffset()
	{
		return _linearOffset;
	}

	public void SetAngularOffset(FP angularOffset)
	{
		if (!angularOffset.Equals(_angularOffset))
		{
			BodyA.IsAwake = true;
			BodyB.IsAwake = true;
			_angularOffset = angularOffset;
		}
	}

	public FP GetAngularOffset()
	{
		return _angularOffset;
	}

	public void SetMaxForce(FP force)
	{
		_maxForce = force;
	}

	public FP GetMaxForce()
	{
		return _maxForce;
	}

	public void SetMaxTorque(FP torque)
	{
		_maxTorque = torque;
	}

	public FP GetMaxTorque()
	{
		return _maxTorque;
	}

	public void SetCorrectionFactor(FP factor)
	{
		_correctionFactor = factor;
	}

	public FP GetCorrectionFactor()
	{
		return _correctionFactor;
	}

	public override FVector2 GetAnchorA()
	{
		return BodyA.GetPosition();
	}

	public override FVector2 GetAnchorB()
	{
		return BodyB.GetPosition();
	}

	public override FVector2 GetReactionForce(FP invDt)
	{
		return invDt * _linearImpulse;
	}

	public override FP GetReactionTorque(FP invDt)
	{
		return invDt * _angularImpulse;
	}

	public override void Dump()
	{
		int islandIndex = BodyA.IslandIndex;
		int islandIndex2 = BodyB.IslandIndex;
		DumpLogger.Log("  b2MotorJointDef jd;");
		DumpLogger.Log($"  jd.bodyA = bodies[{islandIndex}];");
		DumpLogger.Log($"  jd.bodyB = bodies[{islandIndex2}];");
		DumpLogger.Log($"  jd.collideConnected = bool({CollideConnected});");
		DumpLogger.Log($"  jd.linearOffset.Set({_linearOffset.X}, {_linearOffset.Y});");
		DumpLogger.Log($"  jd.angularOffset = {_angularOffset};");
		DumpLogger.Log($"  jd.maxForce = {_maxForce};");
		DumpLogger.Log($"  jd.maxTorque = {_maxTorque};");
		DumpLogger.Log($"  jd.correctionFactor = {_correctionFactor};");
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
		FVector2 center = data.Positions[_indexA].Center;
		FP y = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FVector2 center2 = data.Positions[_indexB].Center;
		FP x2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x3 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(y);
		Rotation q2 = new Rotation(x2);
		FVector2 v3 = _linearOffset - _localCenterA;
		_rA = MathUtils.Mul(in q, in v3);
		v3 = -_localCenterB;
		_rB = MathUtils.Mul(in q2, in v3);
		FP x4 = _invMassA;
		FP y2 = _invMassB;
		FP x5 = _invIa;
		FP x6 = _invIb;
		Matrix2x2 matrix2x = default(Matrix2x2);
		ref FVector2 ex = ref matrix2x.Ex;
		FP x7 = x4 + y2;
		FP x8 = x5 * _rA.Y;
		FP y3 = x8 * _rA.Y;
		FP x9 = x7 + y3;
		FP x10 = x6 * _rB.Y;
		FP y4 = x10 * _rB.Y;
		ex.X = x9 + y4;
		ref FVector2 ex2 = ref matrix2x.Ex;
		x7 = -x5;
		x8 = x7 * _rA.X;
		y3 = x8 * _rA.Y;
		x9 = x6 * _rB.X;
		x10 = x9 * _rB.Y;
		ex2.Y = y3 - x10;
		matrix2x.Ey.X = matrix2x.Ex.Y;
		ref FVector2 ey = ref matrix2x.Ey;
		x7 = x4 + y2;
		x8 = x5 * _rA.X;
		y3 = x8 * _rA.X;
		x9 = x7 + y3;
		x10 = x6 * _rB.X;
		y4 = x10 * _rB.X;
		ey.Y = x9 + y4;
		_linearMass = matrix2x.GetInverse();
		_angularMass = x5 + x6;
		if (_angularMass > 0f)
		{
			_angularMass = 1f / _angularMass;
		}
		_linearError = center2 + _rB - center - _rA;
		x7 = x2 - y;
		_angularError = x7 - _angularOffset;
		if (data.Step.WarmStarting)
		{
			_linearImpulse *= data.Step.DtRatio;
			_angularImpulse *= data.Step.DtRatio;
			FVector2 b = new FVector2(_linearImpulse.X, _linearImpulse.Y);
			v -= x4 * b;
			x7 = MathUtils.Cross(in _rA, in b);
			x8 = x7 + _angularImpulse;
			y3 = x5 * x8;
			x -= y3;
			v2 += y2 * b;
			x7 = MathUtils.Cross(in _rB, in b);
			x8 = x7 + _angularImpulse;
			y3 = x6 * x8;
			x3 += y3;
		}
		else
		{
			_linearImpulse.SetZero();
			_angularImpulse = 0f;
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
		FP x3 = _invIb;
		FP x4 = data.Step.Dt;
		FP x5 = data.Step.InvDt;
		FP x6 = x - y;
		FP x7 = x5 * _correctionFactor;
		FP y2 = x7 * _angularError;
		FP y3 = x6 + y2;
		x6 = -_angularMass;
		FP y4 = x6 * y3;
		FP y5 = _angularImpulse;
		FP fP = x4 * _maxTorque;
		_angularImpulse = MathUtils.Clamp(_angularImpulse + y4, -fP, fP);
		y4 = _angularImpulse - y5;
		x6 = x2 * y4;
		y -= x6;
		x6 = x3 * y4;
		x += x6;
		FVector2 v3 = v2 + MathUtils.Cross(x, in _rB) - v - MathUtils.Cross(y, in _rA) + x5 * _correctionFactor * _linearError;
		FVector2 fVector = -MathUtils.Mul(in _linearMass, in v3);
		FVector2 linearImpulse = _linearImpulse;
		_linearImpulse += fVector;
		FP x8 = x4 * _maxForce;
		if (_linearImpulse.LengthSquared() > x8 * x8)
		{
			_linearImpulse.Normalize();
			_linearImpulse *= x8;
		}
		fVector = _linearImpulse - linearImpulse;
		v -= invMassA * fVector;
		x6 = MathUtils.Cross(in _rA, in fVector);
		x7 = x2 * x6;
		y -= x7;
		v2 += invMassB * fVector;
		x6 = MathUtils.Cross(in _rB, in fVector);
		x7 = x3 * x6;
		x += x7;
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
