using Box2DSharp.Common;
using Newtonsoft.Json;

namespace MiniGame.Biubiu;

public struct CommandCreateBullet : ISyncCommand
{
	public int EntityID;

	public FVector2 BodyPosition;

	public FVector2 Position;

	public FVector2 Direction;

	public int BulletID;

	public int FrameIndex { get; set; }

	[JsonIgnore]
	public bool IsValid { get; set; }

	public int TypeID { get; set; }

	public ISyncCommand Clone()
	{
		CommandCreateBullet commandCreateBullet = default(CommandCreateBullet);
		commandCreateBullet.EntityID = EntityID;
		commandCreateBullet.FrameIndex = FrameIndex;
		commandCreateBullet.TypeID = TypeID;
		commandCreateBullet.BodyPosition = BodyPosition;
		commandCreateBullet.Position = Position;
		commandCreateBullet.Direction = Direction;
		commandCreateBullet.BulletID = BulletID;
		commandCreateBullet.IsValid = IsValid;
		return commandCreateBullet;
	}
}
