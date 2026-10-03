local PushFirstRechargeInfoMessage = BaseClass("PushFirstRechargeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFirstRechargeInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFirstRechargeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FirstPayManager:UpdateBuildExpData(t)
  end
end

return PushFirstRechargeInfoMessage
