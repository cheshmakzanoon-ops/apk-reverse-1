local PushWorldGuideTipDeleteMessage = BaseClass("PushWorldGuideTipDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldGuideTipDeleteMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldGuideTipDeleteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.events then
    DataCenter.WorldBattleGuideManager:DeleteData(t.events)
  end
end

return PushWorldGuideTipDeleteMessage
