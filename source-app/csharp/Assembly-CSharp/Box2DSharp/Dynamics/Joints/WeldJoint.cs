using Box2DSharp.Common;

namespace Box2DSharp.Dynamics.Joints;

public class WeldJoint : Joint
{
	private readonly FVector2 _localAnchorA;

	private readonly FVector2 _localAnchorB;

	private readonly FP _referenceAngle;

	private FP _bias;

	public FP Stiffness = 0f;

	public FP Damping = 0f;

	private FP _gamma;

	private FVector3 _impulse;

	private int _indexA;

	private int _indexB;

	private FP _invIa;

	private FP _invIb;

	private FP _invMassA;

	private FP _invMassB;

	private FVector2 _localCenterA;

	private FVector2 _localCenterB;

	private Matrix3x3 _mass;

	private FVector2 _rA;

	private FVector2 _rB;

	internal WeldJoint(WeldJointDef def)
		: base(def)
	{
		_localAnchorA = def.LocalAnchorA;
		_localAnchorB = def.LocalAnchorB;
		_referenceAngle = def.ReferenceAngle;
		Damping = def.Damping;
		Stiffness = def.Stiffness;
		_impulse.SetZero();
	}

	public FVector2 GetLocalAnchorA()
	{
		return _localAnchorA;
	}

	public FVector2 GetLocalAnchorB()
	{
		return _localAnchorB;
	}

	public FP GetReferenceAngle()
	{
		return _referenceAngle;
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
		FVector2 fVector = new FVector2(_impulse.X, _impulse.Y);
		return inv_dt * fVector;
	}

	public override FP GetReactionTorque(FP inv_dt)
	{
		return inv_dt * _impulse.Z;
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
		FP y = data.Positions[_indexA].Angle;
		FVector2 v = data.Velocities[_indexA].V;
		FP x = data.Velocities[_indexA].W;
		FP x2 = data.Positions[_indexB].Angle;
		FVector2 v2 = data.Velocities[_indexB].V;
		FP x3 = data.Velocities[_indexB].W;
		Rotation q = new Rotation(y);
		Rotation q2 = new Rotation(x2);
		FVector2 v3 = _localAnchorA - _localCenterA;
		_rA = MathUtils.Mul(in q, in v3);
		v3 = _localAnchorB - _localCenterB;
		_rB = MathUtils.Mul(in q2, in v3);
		FP x4 = _invMassA;
		FP y2 = _invMassB;
		FP y3 = _invIa;
		FP y4 = _invIb;
		Matrix3x3 matrix3x = default(Matrix3x3);
		ref FVector3 ex = ref matrix3x.Ex;
		FP x5 = x4 + y2;
		FP x6 = _rA.Y * _rA.Y;
		FP y5 = x6 * y3;
		FP x7 = x5 + y5;
		FP x8 = _rB.Y * _rB.Y;
		FP y6 = x8 * y4;
		ex.X = x7 + y6;
		ref FVector3 ey = ref matrix3x.Ey;
		x5 = -_rA.Y;
		x6 = x5 * _rA.X;
		y5 = x6 * y3;
		x7 = _rB.Y * _rB.X;
		x8 = x7 * y4;
		ey.X = y5 - x8;
		ref FVector3 ez = ref matrix3x.Ez;
		x5 = -_rA.Y;
		x6 = x5 * y3;
		y5 = _rB.Y * y4;
		ez.X = x6 - y5;
		matrix3x.Ex.Y = matrix3x.Ey.X;
		ref FVector3 ey2 = ref matrix3x.Ey;
		x5 = x4 + y2;
		x6 = _rA.X * _rA.X;
		y5 = x6 * y3;
		x7 = x5 + y5;
		x8 = _rB.X * _rB.X;
		y6 = x8 * y4;
		ey2.Y = x7 + y6;
		ref FVector3 ez2 = ref matrix3x.Ez;
		x5 = _rA.X * y3;
		x6 = _rB.X * y4;
		ez2.Y = x5 + x6;
		matrix3x.Ex.Z = matrix3x.Ez.X;
		matrix3x.Ey.Z = matrix3x.Ez.Y;
		matrix3x.Ez.Z = y3 + y4;
		if (Stiffness > 0f)
		{
			matrix3x.GetInverse22(ref _mass);
			FP x9 = y3 + y4;
			x5 = x2 - y;
			FP x10 = x5 - _referenceAngle;
			FP x11 = Damping;
			FP y7 = Stiffness;
			FP x12 = data.Step.Dt;
			x5 = x12 * y7;
			x6 = x11 + x5;
			_gamma = x12 * x6;
			_gamma = ((_gamma != FP.Zero) ? (FP.One / _gamma) : FP.Zero);
			x5 = x10 * x12;
			x6 = x5 * y7;
			_bias = x6 * _gamma;
			x9 += _gamma;
			_mass.Ez.Z = ((x9 != FP.Zero) ? (FP.One / x9) : FP.Zero);
		}
		else if (matrix3x.Ez.Z.Equals(0f))
		{
			matrix3x.GetInverse22(ref _mass);
			_gamma = 0f;
			_bias = 0f;
		}
		else
		{
			matrix3x.GetSymInverse33(ref _mass);
			_gamma = 0f;
			_bias = 0f;
		}
		if (data.Step.WarmStarting)
		{
			_impulse *= data.Step.DtRatio;
			FVector2 b = new FVector2(_impulse.X, _impulse.Y);
			v -= x4 * b;
			x5 = MathUtils.Cross(in _rA, in b);
			x6 = x5 + _impulse.Z;
			y5 = y3 * x6;
			x -= y5;
			v2 += y2 * b;
			x5 = MathUtils.Cross(in _rB, in b);
			x6 = x5 + _impulse.Z;
			y5 = y4 * x6;
			x3 += y5;
		}
		else
		{
			_impulse.SetZero();
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
		if (Stiffness > 0f)
		{
			FP x4 = x - y;
			FP x5 = -_mass.Ez.Z;
			FP x6 = x4 + _bias;
			FP y2 = _gamma * _impulse.Z;
			FP y3 = x6 + y2;
			FP y4 = x5 * y3;
			ref FP z = ref _impulse.Z;
			z += y4;
			x5 = x2 * y4;
			y -= x5;
			x5 = x3 * y4;
			x += x5;
			FVector2 v3 = v2 + MathUtils.Cross(x, in _rB) - v - MathUtils.Cross(y, in _rA);
			FVector2 fVector = -MathUtils.Mul22(in _mass, in v3);
			ref FP x7 = ref _impulse.X;
			x7 += fVector.X;
			ref FP y5 = ref _impulse.Y;
			y5 += fVector.Y;
			FVector2 b = fVector;
			v -= invMassA * b;
			x5 = MathUtils.Cross(in _rA, in b);
			x6 = x2 * x5;
			y -= x6;
			v2 += invMassB * b;
			x5 = MathUtils.Cross(in _rB, in b);
			x6 = x3 * x5;
			x += x6;
		}
		else
		{
			FVector2 fVector2 = v2 + MathUtils.Cross(x, in _rB) - v - MathUtils.Cross(y, in _rA);
			FP z2 = x - y;
			FVector3 v4 = new FVector3(fVector2.X, fVector2.Y, z2);
			FVector3 fVector3 = -MathUtils.Mul(in _mass, in v4);
			_impulse += fVector3;
			FVector2 b2 = new FVector2(fVector3.X, fVector3.Y);
			v -= invMassA * b2;
			FP x5 = MathUtils.Cross(in _rA, in b2);
			FP x6 = x5 + fVector3.Z;
			FP y2 = x2 * x6;
			y -= y2;
			v2 += invMassB * b2;
			x5 = MathUtils.Cross(in _rB, in b2);
			x6 = x5 + fVector3.Z;
			y2 = x3 * x6;
			x += y2;
		}
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
		FP x2 = _invMassA;
		FP y2 = _invMassB;
		FP y3 = _invIa;
		FP y4 = _invIb;
		FVector2 v = _localAnchorA - _localCenterA;
		FVector2 a = MathUtils.Mul(in q, in v);
		v = _localAnchorB - _localCenterB;
		FVector2 a2 = MathUtils.Mul(in q2, in v);
		Matrix3x3 matrix3x = default(Matrix3x3);
		ref FVector3 ex = ref matrix3x.Ex;
		FP x3 = x2 + y2;
		FP x4 = a.Y * a.Y;
		FP y5 = x4 * y3;
		FP x5 = x3 + y5;
		FP x6 = a2.Y * a2.Y;
		FP y6 = x6 * y4;
		ex.X = x5 + y6;
		ref FVector3 ey = ref matrix3x.Ey;
		x3 = -a.Y;
		x4 = x3 * a.X;
		y5 = x4 * y3;
		x5 = a2.Y * a2.X;
		x6 = x5 * y4;
		ey.X = y5 - x6;
		ref FVector3 ez = ref matrix3x.Ez;
		x3 = -a.Y;
		x4 = x3 * y3;
		y5 = a2.Y * y4;
		ez.X = x4 - y5;
		matrix3x.Ex.Y = matrix3x.Ey.X;
		ref FVector3 ey2 = ref matrix3x.Ey;
		x3 = x2 + y2;
		x4 = a.X * a.X;
		y5 = x4 * y3;
		x5 = x3 + y5;
		x6 = a2.X * a2.X;
		y6 = x6 * y4;
		ey2.Y = x5 + y6;
		ref FVector3 ez2 = ref matrix3x.Ez;
		x3 = a.X * y3;
		x4 = a2.X * y4;
		ez2.Y = x3 + x4;
		matrix3x.Ex.Z = matrix3x.Ez.X;
		matrix3x.Ey.Z = matrix3x.Ez.Y;
		matrix3x.Ez.Z = y3 + y4;
		FP fP;
		FP fP2;
		if (Stiffness > 0f)
		{
			FVector2 b = center2 + a2 - center - a;
			fP = b.Length();
			fP2 = 0f;
			FVector2 b2 = -matrix3x.Solve22(in b);
			center -= x2 * b2;
			x3 = MathUtils.Cross(in a, in b2);
			x4 = y3 * x3;
			y -= x4;
			center2 += y2 * b2;
			x3 = MathUtils.Cross(in a2, in b2);
			x4 = y4 * x3;
			x += x4;
		}
		else
		{
			FVector2 b3 = center2 + a2 - center - a;
			x3 = x - y;
			FP fP3 = x3 - _referenceAngle;
			fP = b3.Length();
			fP2 = FP.Abs(fP3);
			FVector3 b4 = new FVector3(b3.X, b3.Y, fP3);
			FVector3 fVector = default(FVector3);
			if (matrix3x.Ez.Z > 0f)
			{
				fVector = -matrix3x.Solve33(in b4);
			}
			else
			{
				FVector2 fVector2 = -matrix3x.Solve22(in b3);
				fVector.Set(fVector2.X, fVector2.Y, 0f);
			}
			FVector2 b5 = new FVector2(fVector.X, fVector.Y);
			center -= x2 * b5;
			x3 = MathUtils.Cross(in a, in b5);
			x4 = x3 + fVector.Z;
			y5 = y3 * x4;
			y -= y5;
			center2 += y2 * b5;
			x3 = MathUtils.Cross(in a2, in b5);
			x4 = x3 + fVector.Z;
			y5 = y4 * x4;
			x += y5;
		}
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
}
