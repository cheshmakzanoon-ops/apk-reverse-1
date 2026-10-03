local AllianceSkillEnergyGetInfoMessage = BaseClass("AllianceSkillEnergyGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSkillEnergyGetInfoMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceSkillEnergyGetInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceGovernmentCommonSkillManager:ReqSkillEnergyGetInfo(t)
  end
end

return AllianceSkillEnergyGetInfoMessage
