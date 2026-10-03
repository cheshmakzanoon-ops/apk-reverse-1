using Box2DSharp.Common;

namespace MiniGame.Core;

public static class FPFunc
{
	public static FP Lerp(FP a, FP b, FP t)
	{
		FP x = b - a;
		FP y = x * t;
		return a + y;
	}
}
