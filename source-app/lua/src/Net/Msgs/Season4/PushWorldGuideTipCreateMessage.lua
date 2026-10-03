local PushWorldGuideTipCreateMessage = BaseClass("PushWorldGuideTipCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldGuideTipCreateMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldGuideTipCreateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.events then
    DataCenter.WorldBattleGuideManager:AddData(t.events)
  elseif t.eventKey and t.pointId and t.serverId and t.type then
    DataCenter.WorldBattleGuideManager:AddData({t})
  end
end

return PushWorldGuideTipCreateMessage
