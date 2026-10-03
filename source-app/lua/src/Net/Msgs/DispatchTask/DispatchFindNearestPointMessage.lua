local DispatchFindNearestPointMessage = BaseClass("DispatchFindNearestPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchFindNearestPointMessage:OnCreate()
  base.OnCreate(self)
end

function DispatchFindNearestPointMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local pointId = message.pointId
  local serverId = message.serverId
  if pointId == nil or serverId == nil then
    return
  end
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  GoToUtil.CloseAllWindows()
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, nil, nil, nil, serverId)
end

return DispatchFindNearestPointMessage
