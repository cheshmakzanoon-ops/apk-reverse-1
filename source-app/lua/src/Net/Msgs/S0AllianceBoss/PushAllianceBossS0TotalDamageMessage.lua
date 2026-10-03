local PushAllianceBossS0TotalDamageMessage = BaseClass("PushAllianceBossS0TotalDamageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceBossS0TotalDamageMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossS0TotalDamageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:UpdateAllianceDmg(message)
end

return PushAllianceBossS0TotalDamageMessage
