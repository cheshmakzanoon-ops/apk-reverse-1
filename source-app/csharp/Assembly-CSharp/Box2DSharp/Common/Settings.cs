namespace Box2DSharp.Common;

public static class Settings
{
	public static FP MaxFloat = FP.MaxValue;

	public static FP MinFloat = FP.MinValue;

	public static FP Epsilon = FP.Epsilon;

	public static FP Pi = FP.Pi;

	public static FP LengthUnitsPerMeter = FP.One;

	public const int MaxManifoldPoints = 2;

	public const int MaxPolygonVertices = 8;

	public static FP AABBExtension;

	public const int AABBMultiplier = 4;

	public static FP LinearSlop;

	public static FP AngularSlop;

	public static FP PolygonRadius;

	public const int MaxSubSteps = 8;

	public const int MaxToiContacts = 32;

	public static FP MaxLinearCorrection;

	public static FP MaxAngularCorrection;

	public static FP MaxTranslation;

	public static FP MaxTranslationSquared;

	public static FP MaxRotation;

	public static FP MaxRotationSquared;

	public static FP Baumgarte;

	public static FP ToiBaumgarte;

	public static FP TimeToSleep;

	public static FP LinearSleepTolerance;

	public static FP AngularSleepTolerance;

	static Settings()
	{
		FP x = 0.1f;
		AABBExtension = x * LengthUnitsPerMeter;
		x = 0.005f;
		LinearSlop = x * LengthUnitsPerMeter;
		AngularSlop = FP.PiTimes2 / 180;
		x = 2;
		PolygonRadius = x * LinearSlop;
		x = 0.2f;
		MaxLinearCorrection = x * LengthUnitsPerMeter;
		x = 8;
		MaxAngularCorrection = x * Pi / 180;
		x = 2;
		MaxTranslation = x * LengthUnitsPerMeter;
		MaxTranslationSquared = MaxTranslation * MaxTranslation;
		x = 0.5;
		MaxRotation = x * Pi;
		MaxRotationSquared = MaxRotation * MaxRotation;
		Baumgarte = 0.2;
		ToiBaumgarte = 0.75;
		TimeToSleep = 0.5;
		x = 0.01;
		LinearSleepTolerance = x * LengthUnitsPerMeter;
		AngularSleepTolerance = FP.PiTimes2 / 180;
	}
}
