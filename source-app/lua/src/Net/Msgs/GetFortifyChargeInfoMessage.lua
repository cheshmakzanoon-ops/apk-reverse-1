local GetFortifyChargeInfoMessage = BaseClass("GetFortifyChargeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetFortifyChargeInfoMessage:OnCreate(cityUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("cityUuid", cityUuid)
end

function GetFortifyChargeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceGovernmentCommonSkillManager:HandleChargeCount(t)
  end
end

return GetFortifyChargeInfoMessage
