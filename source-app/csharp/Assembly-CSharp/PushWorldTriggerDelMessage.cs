using Sfs2X.Entities.Data;

public class PushWorldTriggerDelMessage : BaseMessage
{
	private static PushWorldTriggerDelMessage _instance;

	public static PushWorldTriggerDelMessage Instance => _instance ?? (_instance = MessageFactory.GetMessage<PushWorldTriggerDelMessage>());

	public override string GetMsgId()
	{
		return "push.world.trigger.del";
	}

	protected override void CSHandleResponse(ISFSObject message)
	{
		if (SceneManager.World != null && SceneManager.IsInWorld())
		{
			int @int = message.GetInt("serverId");
			int int2 = message.GetInt("worldId");
			SceneManager.World.HandlePushWorldTriggerDel(message, @int, int2);
		}
	}

	protected override bool showErrorCode()
	{
		return true;
	}
}
