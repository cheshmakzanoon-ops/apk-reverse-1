using Box2DSharp.Common;

namespace Box2DSharp.Ropes;

public class Rope
{
	private RopeBend[] _bendConstraints;

	private int _bendCount;

	private FVector2[] _bindPositions;

	private int _count;

	private FVector2 _gravity;

	private FP[] _invMasses;

	private FVector2[] _p0s;

	private FVector2 _position;

	private FVector2[] _ps;

	private RopeStretch[] _stretchConstraints;

	private int _stretchCount;

	private RopeTuning _tuning;

	private FVector2[] _vs;

	public void Create(in RopeDef def)
	{
		_position = def.Position;
		_count = def.Count;
		_bindPositions = new FVector2[_count];
		_ps = new FVector2[_count];
		_p0s = new FVector2[_count];
		_vs = new FVector2[_count];
		_invMasses = new FP[_count];
		for (int i = 0; i < _count; i++)
		{
			_bindPositions[i] = def.Vertices[i];
			_ps[i] = def.Vertices[i] + _position;
			_p0s[i] = def.Vertices[i] + _position;
			_vs[i].SetZero();
			FP fP = def.Masses[i];
			if (fP > 0f)
			{
				_invMasses[i] = 1f / fP;
			}
			else
			{
				_invMasses[i] = 0f;
			}
		}
		_stretchCount = _count - 1;
		_bendCount = _count - 2;
		_stretchConstraints = new RopeStretch[_stretchCount];
		_bendConstraints = new RopeBend[_bendCount];
		for (int j = 0; j < _stretchCount; j++)
		{
			ref RopeStretch reference = ref _stretchConstraints[j];
			FVector2 value = _ps[j];
			FVector2 value2 = _ps[j + 1];
			reference.I1 = j;
			reference.I2 = j + 1;
			reference.L = FVector2.Distance(value, value2);
			reference.InvMass1 = _invMasses[j];
			reference.InvMass2 = _invMasses[j + 1];
			reference.Lambda = 0f;
			reference.Damper = 0f;
			reference.Spring = 0f;
		}
		for (int k = 0; k < _bendCount; k++)
		{
			ref RopeBend reference2 = ref _bendConstraints[k];
			FVector2 fVector = _ps[k];
			FVector2 fVector2 = _ps[k + 1];
			FVector2 fVector3 = _ps[k + 2];
			reference2.i1 = k;
			reference2.i2 = k + 1;
			reference2.i3 = k + 2;
			reference2.invMass1 = _invMasses[k];
			reference2.invMass2 = _invMasses[k + 1];
			reference2.invMass3 = _invMasses[k + 2];
			reference2.invEffectiveMass = 0f;
			reference2.L1 = FVector2.Distance(fVector, fVector2);
			reference2.L2 = FVector2.Distance(fVector2, fVector3);
			reference2.lambda = 0f;
			FVector2 vector = fVector2 - fVector;
			FVector2 vector2 = fVector3 - fVector2;
			FP x = vector.LengthSquared();
			FP y = vector2.LengthSquared();
			if (!(x * y).Equals(0))
			{
				FVector2 fVector4 = -1f / x * vector.Skew();
				FVector2 fVector5 = 1f / y * vector2.Skew();
				FVector2 fVector6 = -fVector4;
				FVector2 fVector7 = fVector4 - fVector5;
				FVector2 fVector8 = fVector5;
				ref FP invMass = ref reference2.invMass1;
				FP y2 = FVector2.Dot(fVector6, fVector6);
				FP x2 = invMass * y2;
				ref FP invMass2 = ref reference2.invMass2;
				FP y3 = FVector2.Dot(fVector7, fVector7);
				FP y4 = invMass2 * y3;
				FP x3 = x2 + y4;
				ref FP invMass3 = ref reference2.invMass3;
				FP y5 = FVector2.Dot(fVector8, fVector8);
				FP y6 = invMass3 * y5;
				reference2.invEffectiveMass = x3 + y6;
				FVector2 value3 = fVector3 - fVector;
				FP fP2 = value3.LengthSquared();
				if (!fP2.Equals(0))
				{
					reference2.alpha1 = FVector2.Dot(vector2, value3) / fP2;
					reference2.alpha2 = FVector2.Dot(vector, value3) / fP2;
				}
			}
		}
		_gravity = def.Gravity;
		SetTuning(def.Tuning);
	}

	public void SetTuning(RopeTuning tuning)
	{
		_tuning = tuning;
		FP x = 2f;
		FP x2 = x * Settings.Pi;
		FP y = x2 * _tuning.BendHertz;
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			FP x3 = reference.L1 * reference.L1;
			FP y2 = reference.L2 * reference.L2;
			if ((x3 * y2).Equals(0))
			{
				reference.spring = 0f;
				reference.damper = 0f;
				continue;
			}
			x = 1f / reference.L1;
			x2 = 1f / reference.L2;
			FP y3 = x + x2;
			x = reference.invMass1 / x3;
			x2 = reference.invMass2 * y3;
			FP y4 = x2 * y3;
			FP x4 = x + y4;
			FP y5 = reference.invMass3 / y2;
			FP fP = x4 + y5;
			if (fP.Equals(0))
			{
				reference.spring = 0f;
				reference.damper = 0f;
				continue;
			}
			FP x5 = 1f / fP;
			x = x5 * y;
			reference.spring = x * y;
			x = 2f;
			x2 = x * x5;
			y4 = x2 * _tuning.BendDamping;
			reference.damper = y4 * y;
		}
		x = 2f;
		x2 = x * Settings.Pi;
		FP y6 = x2 * _tuning.StretchHertz;
		for (int j = 0; j < _stretchCount; j++)
		{
			ref RopeStretch reference2 = ref _stretchConstraints[j];
			FP fP2 = reference2.InvMass1 + reference2.InvMass2;
			if (!fP2.Equals(0))
			{
				FP x6 = 1f / fP2;
				x = x6 * y6;
				reference2.Spring = x * y6;
				x = 2f;
				x2 = x * x6;
				FP y4 = x2 * _tuning.StretchDamping;
				reference2.Damper = y4 * y6;
			}
		}
	}

	public void Step(FP dt, int iterations, FVector2 position)
	{
		if (dt.Equals(0))
		{
			return;
		}
		FP fP = 1f / dt;
		FP x = -dt;
		FP fP2 = FMath.Exp(x * _tuning.Damping);
		for (int i = 0; i < _count; i++)
		{
			if (_invMasses[i] > 0f)
			{
				_vs[i] *= fP2;
				_vs[i] += dt * _gravity;
			}
			else
			{
				_vs[i] = fP * (_bindPositions[i] + position - _p0s[i]);
			}
		}
		if (_tuning.BendingModel == BendingModel.SpringAngleBendingModel)
		{
			ApplyBendForces(dt);
		}
		for (int j = 0; j < _bendCount; j++)
		{
			_bendConstraints[j].lambda = 0f;
		}
		for (int k = 0; k < _stretchCount; k++)
		{
			_stretchConstraints[k].Lambda = 0f;
		}
		for (int l = 0; l < _count; l++)
		{
			_ps[l] += dt * _vs[l];
		}
		for (int m = 0; m < iterations; m++)
		{
			switch (_tuning.BendingModel)
			{
			case BendingModel.PbdAngleBendingModel:
				SolveBend_PBD_Angle();
				break;
			case BendingModel.XpdAngleBendingModel:
				SolveBend_XPBD_Angle(dt);
				break;
			case BendingModel.PbdDistanceBendingModel:
				SolveBend_PBD_Distance();
				break;
			case BendingModel.PbdHeightBendingModel:
				SolveBend_PBD_Height();
				break;
			case BendingModel.PbdTriangleBendingModel:
				SolveBend_PBD_Triangle();
				break;
			}
			switch (_tuning.StretchingModel)
			{
			case StretchingModel.PbdStretchingModel:
				SolveStretch_PBD();
				break;
			case StretchingModel.XpbdStretchingModel:
				SolveStretch_XPBD(dt);
				break;
			}
		}
		for (int n = 0; n < _count; n++)
		{
			_vs[n] = fP * (_ps[n] - _p0s[n]);
			_p0s[n] = _ps[n];
		}
	}

	public void Reset(FVector2 position)
	{
		_position = position;
		for (int i = 0; i < _count; i++)
		{
			_ps[i] = _bindPositions[i] + _position;
			_p0s[i] = _bindPositions[i] + _position;
			_vs[i].SetZero();
		}
		for (int j = 0; j < _bendCount; j++)
		{
			_bendConstraints[j].lambda = 0f;
		}
		for (int k = 0; k < _stretchCount; k++)
		{
			_stretchConstraints[k].Lambda = 0f;
		}
	}

	private void SolveStretch_PBD()
	{
		FP x = _tuning.StretchStiffness;
		for (int i = 0; i < _stretchCount; i++)
		{
			ref RopeStretch reference = ref _stretchConstraints[i];
			FVector2 fVector = _ps[reference.I1];
			FVector2 fVector2 = _ps[reference.I2];
			FVector2 fVector3 = fVector2 - fVector;
			FP y = fVector3.Normalize();
			FP fP = reference.InvMass1 + reference.InvMass2;
			if (!fP.Equals(0))
			{
				FP y2 = reference.InvMass1 / fP;
				FP y3 = reference.InvMass2 / fP;
				FVector2 fVector4 = fVector;
				FP x2 = x * y2;
				FP y4 = reference.L - y;
				fVector = fVector4 - x2 * y4 * fVector3;
				FVector2 fVector5 = fVector2;
				x2 = x * y3;
				y4 = reference.L - y;
				fVector2 = fVector5 + x2 * y4 * fVector3;
				_ps[reference.I1] = fVector;
				_ps[reference.I2] = fVector2;
			}
		}
	}

	private void SolveStretch_XPBD(FP dt)
	{
		for (int i = 0; i < _stretchCount; i++)
		{
			ref RopeStretch reference = ref _stretchConstraints[i];
			FVector2 fVector = _ps[reference.I1];
			FVector2 fVector2 = _ps[reference.I2];
			FVector2 value = fVector - _p0s[reference.I1];
			FVector2 value2 = fVector2 - _p0s[reference.I2];
			FVector2 fVector3 = fVector2 - fVector;
			FP x = fVector3.Normalize();
			FVector2 fVector4 = -fVector3;
			FVector2 fVector5 = fVector3;
			FP y = reference.InvMass1 + reference.InvMass2;
			if (!y.Equals(0))
			{
				FP fP = 1f;
				FP x2 = reference.Spring * dt;
				FP x3 = fP / (x2 * dt);
				x2 = dt * dt;
				FP y2 = x2 * reference.Damper;
				FP x4 = x3 * y2 / dt;
				FP x5 = x - reference.L;
				x2 = FVector2.Dot(fVector4, value);
				FP y3 = FVector2.Dot(fVector5, value2);
				FP y4 = x2 + y3;
				x2 = x3 * reference.Lambda;
				y3 = x5 + x2;
				FP y5 = x4 * y4;
				FP fP2 = y3 + y5;
				x2 = 1f;
				y3 = x2 + x4;
				y5 = y3 * y;
				FP fP3 = y5 + x3;
				FP y6 = -fP2 / fP3;
				fVector += reference.InvMass1 * y6 * fVector4;
				fVector2 += reference.InvMass2 * y6 * fVector5;
				_ps[reference.I1] = fVector;
				_ps[reference.I2] = fVector2;
				ref FP lambda = ref reference.Lambda;
				lambda += y6;
			}
		}
	}

	private void SolveBend_PBD_Angle()
	{
		FP bendStiffness = _tuning.BendStiffness;
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			FVector2 fVector = _ps[reference.i1];
			FVector2 fVector2 = _ps[reference.i2];
			FVector2 fVector3 = _ps[reference.i3];
			FVector2 a = fVector2 - fVector;
			FVector2 b = fVector3 - fVector2;
			FP y = MathUtils.Cross(in a, in b);
			FP x = FVector2.Dot(a, b);
			FP y2 = FP.Atan2(y, x);
			FP x2;
			FP y3;
			if (_tuning.Isometric)
			{
				x2 = reference.L1 * reference.L1;
				y3 = reference.L2 * reference.L2;
			}
			else
			{
				x2 = a.LengthSquared();
				y3 = b.LengthSquared();
			}
			if (!(x2 * y3).Equals(0))
			{
				FVector2 fVector4 = -1f / x2 * a.Skew();
				FVector2 fVector5 = 1f / y3 * b.Skew();
				FVector2 fVector6 = -fVector4;
				FVector2 fVector7 = fVector4 - fVector5;
				FVector2 fVector8 = fVector5;
				FP fP;
				FP y4;
				if (_tuning.FixedEffectiveMass)
				{
					fP = reference.invEffectiveMass;
				}
				else
				{
					ref FP invMass = ref reference.invMass1;
					y4 = FVector2.Dot(fVector6, fVector6);
					FP x3 = invMass * y4;
					ref FP invMass2 = ref reference.invMass2;
					FP y5 = FVector2.Dot(fVector7, fVector7);
					FP y6 = invMass2 * y5;
					FP x4 = x3 + y6;
					ref FP invMass3 = ref reference.invMass3;
					FP y7 = FVector2.Dot(fVector8, fVector8);
					FP y8 = invMass3 * y7;
					fP = x4 + y8;
				}
				if (fP.Equals(0))
				{
					fP = reference.invEffectiveMass;
				}
				y4 = -bendStiffness;
				FP y9 = y4 * y2 / fP;
				fVector += reference.invMass1 * y9 * fVector6;
				fVector2 += reference.invMass2 * y9 * fVector7;
				fVector3 += reference.invMass3 * y9 * fVector8;
				_ps[reference.i1] = fVector;
				_ps[reference.i2] = fVector2;
				_ps[reference.i3] = fVector3;
			}
		}
	}

	private void SolveBend_XPBD_Angle(FP dt)
	{
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			FVector2 fVector = _ps[reference.i1];
			FVector2 fVector2 = _ps[reference.i2];
			FVector2 fVector3 = _ps[reference.i3];
			FVector2 value = fVector - _p0s[reference.i1];
			FVector2 value2 = fVector2 - _p0s[reference.i2];
			FVector2 value3 = fVector3 - _p0s[reference.i3];
			FVector2 a = fVector2 - fVector;
			FVector2 b = fVector3 - fVector2;
			FP x;
			FP y;
			if (_tuning.Isometric)
			{
				x = reference.L1 * reference.L1;
				y = reference.L2 * reference.L2;
			}
			else
			{
				x = a.LengthSquared();
				y = b.LengthSquared();
			}
			if (!(x * y).Equals(0))
			{
				FP y2 = MathUtils.Cross(in a, in b);
				FP x2 = FVector2.Dot(a, b);
				FP fP = FP.Atan2(y2, x2);
				FVector2 fVector4 = -1f / x * a.Skew();
				FVector2 fVector5 = 1f / y * b.Skew();
				FVector2 fVector6 = -fVector4;
				FVector2 fVector7 = fVector4 - fVector5;
				FVector2 fVector8 = fVector5;
				FP y3;
				if (_tuning.FixedEffectiveMass)
				{
					y3 = reference.invEffectiveMass;
				}
				else
				{
					ref FP invMass = ref reference.invMass1;
					FP y4 = FVector2.Dot(fVector6, fVector6);
					FP x3 = invMass * y4;
					ref FP invMass2 = ref reference.invMass2;
					FP y5 = FVector2.Dot(fVector7, fVector7);
					FP y6 = invMass2 * y5;
					FP x4 = x3 + y6;
					ref FP invMass3 = ref reference.invMass3;
					FP y7 = FVector2.Dot(fVector8, fVector8);
					FP y8 = invMass3 * y7;
					y3 = x4 + y8;
				}
				if (!y3.Equals(0))
				{
					FP fP2 = 1f;
					FP y4 = reference.spring * dt;
					FP x5 = fP2 / (y4 * dt);
					y4 = dt * dt;
					FP y9 = y4 * reference.damper;
					FP x6 = x5 * y9 / dt;
					FP x7 = fP;
					y4 = FVector2.Dot(fVector6, value);
					FP x3 = FVector2.Dot(fVector7, value2);
					FP y5 = y4 + x3;
					FP y6 = FVector2.Dot(fVector8, value3);
					FP y10 = y5 + y6;
					y4 = x5 * reference.lambda;
					x3 = x7 + y4;
					y5 = x6 * y10;
					FP fP3 = x3 + y5;
					y4 = 1f;
					x3 = y4 + x6;
					y5 = x3 * y3;
					FP fP4 = y5 + x5;
					FP y11 = -fP3 / fP4;
					fVector += reference.invMass1 * y11 * fVector6;
					fVector2 += reference.invMass2 * y11 * fVector7;
					fVector3 += reference.invMass3 * y11 * fVector8;
					_ps[reference.i1] = fVector;
					_ps[reference.i2] = fVector2;
					_ps[reference.i3] = fVector3;
					ref FP lambda = ref reference.lambda;
					lambda += y11;
				}
			}
		}
	}

	private void ApplyBendForces(FP dt)
	{
		FP x = 2f;
		FP x2 = x * Settings.Pi;
		FP y = x2 * _tuning.BendHertz;
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			FVector2 fVector = _ps[reference.i1];
			FVector2 fVector2 = _ps[reference.i2];
			FVector2 fVector3 = _ps[reference.i3];
			FVector2 value = _vs[reference.i1];
			FVector2 value2 = _vs[reference.i2];
			FVector2 value3 = _vs[reference.i3];
			FVector2 a = fVector2 - fVector;
			FVector2 b = fVector3 - fVector2;
			FP x3;
			FP y2;
			if (_tuning.Isometric)
			{
				x3 = reference.L1 * reference.L1;
				y2 = reference.L2 * reference.L2;
			}
			else
			{
				x3 = a.LengthSquared();
				y2 = b.LengthSquared();
			}
			if (!(x3 * y2).Equals(0))
			{
				FP y3 = MathUtils.Cross(in a, in b);
				FP x4 = FVector2.Dot(a, b);
				FP fP = FP.Atan2(y3, x4);
				FVector2 fVector4 = -1f / x3 * a.Skew();
				FVector2 fVector5 = 1f / y2 * b.Skew();
				FVector2 fVector6 = -fVector4;
				FVector2 fVector7 = fVector4 - fVector5;
				FVector2 fVector8 = fVector5;
				FP fP2;
				if (_tuning.FixedEffectiveMass)
				{
					fP2 = reference.invEffectiveMass;
				}
				else
				{
					ref FP invMass = ref reference.invMass1;
					x = FVector2.Dot(fVector6, fVector6);
					x2 = invMass * x;
					ref FP invMass2 = ref reference.invMass2;
					FP y4 = FVector2.Dot(fVector7, fVector7);
					FP y5 = invMass2 * y4;
					FP x5 = x2 + y5;
					ref FP invMass3 = ref reference.invMass3;
					FP y6 = FVector2.Dot(fVector8, fVector8);
					FP y7 = invMass3 * y6;
					fP2 = x5 + y7;
				}
				if (!fP2.Equals(0))
				{
					FP x6 = 1f / fP2;
					x = x6 * y;
					FP x7 = x * y;
					x = 2f;
					x2 = x * x6;
					FP y4 = x2 * _tuning.BendDamping;
					FP x8 = y4 * y;
					FP y8 = fP;
					x = FVector2.Dot(fVector6, value);
					x2 = FVector2.Dot(fVector7, value2);
					y4 = x + x2;
					FP y5 = FVector2.Dot(fVector8, value3);
					FP y9 = y4 + y5;
					x = -dt;
					x2 = x7 * y8;
					y4 = x8 * y9;
					y5 = x2 + y4;
					FP y10 = x * y5;
					_vs[reference.i1] += reference.invMass1 * y10 * fVector6;
					_vs[reference.i2] += reference.invMass2 * y10 * fVector7;
					_vs[reference.i3] += reference.invMass3 * y10 * fVector8;
				}
			}
		}
	}

	private void SolveBend_PBD_Distance()
	{
		FP x = _tuning.BendStiffness;
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			int i2 = reference.i1;
			int i3 = reference.i3;
			FVector2 fVector = _ps[i2];
			FVector2 fVector2 = _ps[i3];
			FVector2 fVector3 = fVector2 - fVector;
			FP y = fVector3.Normalize();
			FP fP = reference.invMass1 + reference.invMass3;
			if (!fP.Equals(0))
			{
				FP y2 = reference.invMass1 / fP;
				FP y3 = reference.invMass3 / fP;
				FVector2 fVector4 = fVector;
				FP x2 = x * y2;
				FP x3 = reference.L1 + reference.L2;
				FP y4 = x3 - y;
				fVector = fVector4 - x2 * y4 * fVector3;
				FVector2 fVector5 = fVector2;
				x2 = x * y3;
				x3 = reference.L1 + reference.L2;
				y4 = x3 - y;
				fVector2 = fVector5 + x2 * y4 * fVector3;
				_ps[i2] = fVector;
				_ps[i3] = fVector2;
			}
		}
	}

	private void SolveBend_PBD_Height()
	{
		FP bendStiffness = _tuning.BendStiffness;
		for (int i = 0; i < _bendCount; i++)
		{
			ref RopeBend reference = ref _bendConstraints[i];
			FVector2 fVector = _ps[reference.i1];
			FVector2 fVector2 = _ps[reference.i2];
			FVector2 fVector3 = _ps[reference.i3];
			FVector2 fVector4 = reference.alpha1 * fVector + reference.alpha2 * fVector3 - fVector2;
			FP fP = fVector4.Length();
			if (!fP.Equals(0))
			{
				FVector2 fVector5 = 1f / fP * fVector4;
				FVector2 fVector6 = reference.alpha1 * fVector5;
				FVector2 fVector7 = -fVector5;
				FVector2 fVector8 = reference.alpha2 * fVector5;
				FP x = reference.invMass1 * reference.alpha1;
				FP x2 = x * reference.alpha1;
				FP x3 = x2 + reference.invMass2;
				FP x4 = reference.invMass3 * reference.alpha2;
				FP y = x4 * reference.alpha2;
				FP fP2 = x3 + y;
				if (!fP2.Equals(0))
				{
					FP y2 = fP;
					FP y3 = 1f / fP2;
					x = -bendStiffness;
					x2 = x * y3;
					FP y4 = x2 * y2;
					fVector += reference.invMass1 * y4 * fVector6;
					fVector2 += reference.invMass2 * y4 * fVector7;
					fVector3 += reference.invMass3 * y4 * fVector8;
					_ps[reference.i1] = fVector;
					_ps[reference.i2] = fVector2;
					_ps[reference.i3] = fVector3;
				}
			}
		}
	}

	private void SolveBend_PBD_Triangle()
	{
		FP bendStiffness = _tuning.BendStiffness;
		for (int i = 0; i < _bendCount; i++)
		{
			RopeBend ropeBend = _bendConstraints[i];
			FVector2 fVector = _ps[ropeBend.i1];
			FVector2 fVector2 = _ps[ropeBend.i2];
			FVector2 fVector3 = _ps[ropeBend.i3];
			FP x = ropeBend.invMass1;
			FP y = ropeBend.invMass2;
			FP y2 = ropeBend.invMass3;
			FP x2 = x + y2;
			FP x3 = 2f;
			FP y3 = x3 * y;
			FP fP = x2 + y3;
			FP y4 = bendStiffness / fP;
			FVector2 fVector4 = fVector2 - 1f / 3f * (fVector + fVector2 + fVector3);
			x2 = 2f;
			x3 = x2 * x;
			FVector2 fVector5 = x3 * y4 * fVector4;
			x2 = -4f;
			x3 = x2 * y;
			FVector2 fVector6 = x3 * y4 * fVector4;
			x2 = 2f;
			x3 = x2 * y2;
			FVector2 fVector7 = x3 * y4 * fVector4;
			fVector += fVector5;
			fVector2 += fVector6;
			fVector3 += fVector7;
			_ps[ropeBend.i1] = fVector;
			_ps[ropeBend.i2] = fVector2;
			_ps[ropeBend.i3] = fVector3;
		}
	}

	public void Draw(IDraw draw)
	{
		Color color = Color.FromArgb(0.4f, 0.5f, 0.7f);
		Color color2 = Color.FromArgb(0.1f, 0.8f, 0.1f);
		Color color3 = Color.FromArgb(0.7f, 0.2f, 0.4f);
		for (int i = 0; i < _count - 1; i++)
		{
			draw.DrawSegment(in _ps[i], in _ps[i + 1], in color);
			Color color4 = ((_invMasses[i] > 0f) ? color3 : color2);
			draw.DrawPoint(in _ps[i], 5f, in color4);
		}
		Color color5 = ((_invMasses[_count - 1] > 0f) ? color3 : color2);
		draw.DrawPoint(in _ps[_count - 1], 5f, in color5);
	}
}
