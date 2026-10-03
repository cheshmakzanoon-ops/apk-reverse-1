local PushThumbsUpBroadcastMessage = BaseClass("PushThumbsUpBroadcastMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushThumbsUpBroadcastMessage:OnCreate()
  base.OnCreate(self)
end

function PushThumbsUpBroadcastMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.sender and t.pointId and t.targetUid and CS.SceneManager.World then
    local serverId = t.serverId
    local worldId = t.worldId
    local info = CS.SceneManager.World:GetPointInfo(t.pointId)
    if info ~= nil and (serverId == nil or serverId == 0 or serverId == info.serverId) and info.PointType == WorldPointType.PlayerBuilding then
      cast(info, typeof(CS.BuildPointInfo))
      if info ~= nil and info.ownerUid == t.targetUid then
        UIUtil.ShowThumbsUpBroadcastPopUI(info.serverId, t.pointId, t.sender)
      end
    end
  end
end

return PushThumbsUpBroadcastMessage
