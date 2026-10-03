local PushCenterThroneActivityInfoMessage = BaseClass("PushCenterThroneActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCenterThroneActivityInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushCenterThroneActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonNineKingManager:CenterThroneActivityInfo(t)
end

return PushCenterThroneActivityInfoMessage
