local PushFortifyChargeInfoMessage = BaseClass("PushFortifyChargeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFortifyChargeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceGovernmentCommonSkillManager:HandleChargeCount(t)
  end
end

return PushFortifyChargeInfoMessage
