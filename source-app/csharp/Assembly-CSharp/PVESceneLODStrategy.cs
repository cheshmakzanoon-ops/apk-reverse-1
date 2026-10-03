using System.Collections.Generic;

public class PVESceneLODStrategy : ILODStrategy
{
	public int CalculateLODLevel(int currentLevel, List<ISceneLODNode> nodes)
	{
		if (!SceneManager.IsInPVE())
		{
			return 0;
		}
		int @int = GameEntry.Setting.GetInt("GAME_QUALITY_CONFIG_KEY", -1);
		if (@int == -1)
		{
			return 0;
		}
		int num = 0;
		if (@int >= 6)
		{
			return 0;
		}
		if (@int <= 3)
		{
			return 2;
		}
		return 1;
	}
}
