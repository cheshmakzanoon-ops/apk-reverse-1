local PushVip18ProductionMessage = BaseClass("PushVip18ProductionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushVip18ProductionMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushVip18ProductionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:UpdateVip18ProductionView(t)
  end
end

return PushVip18ProductionMessage
