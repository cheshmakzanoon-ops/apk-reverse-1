using UnityEngine;

public class Vector3AnimationCurve
{
	private AnimationCurve curveX = new AnimationCurve();

	private AnimationCurve curveY = new AnimationCurve();

	private AnimationCurve curveZ = new AnimationCurve();

	public void AddKey(float time, Vector3 vec)
	{
		curveX.AddKey(time, vec.x);
		curveY.AddKey(time, vec.y);
		curveZ.AddKey(time, vec.z);
	}

	public Vector3 Evaluate(float time)
	{
		Vector3 result = default(Vector3);
		result.x = curveX.Evaluate(time);
		result.y = curveY.Evaluate(time);
		result.z = curveZ.Evaluate(time);
		return result;
	}
}
