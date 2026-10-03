using Sfs2X.Entities.Data;

public class PushMonsterInvasionSummon : BaseMessage
{
	private static PushMonsterInvasionSummon _instance;

	public static PushMonsterInvasionSummon Instance => _instance ?? (_instance = MessageFactory.GetMessage<PushMonsterInvasionSummon>());

	public override string GetMsgId()
	{
		return "push.monster.invasion.summon";
	}

	protected override void CSHandleResponse(ISFSObject message)
	{
		if (SceneManager.World != null)
		{
			long @long = message.GetLong("uuid");
			SceneManager.World.GetTroop(@long)?.MarkInvasionMonsterDialogFlag(1u);
		}
	}
}
