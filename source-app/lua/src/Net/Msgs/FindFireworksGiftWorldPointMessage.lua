local FindFireworksGiftWorldPointMessage = BaseClass("FindFireworksGiftWorldPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FindFireworksGiftWorldPointMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("ownerUid", param.ownerUid)
end

function FindFireworksGiftWorldPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.currServerId and t.pointId then
    GoToUtil.CloseAllWindows()
    if tonumber(t.pointId) == 0 then
      UIUtil.ShowTipsId("firework_tips_1018")
    else
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(t.pointId, ForceChangeScene.World, t.currServerId), nil, nil, nil, t.currServerId)
    end
  end
end

return FindFireworksGiftWorldPointMessage
