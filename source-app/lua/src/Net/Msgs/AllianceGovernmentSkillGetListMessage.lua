local AllianceGovernmentSkillGetListMessage = BaseClass("AllianceGovernmentSkillGetListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceGovernmentSkillGetListMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceGovernmentSkillGetListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceGovernmentCommonSkillManager:ReqAllianceGovernmentSkillList(t)
  end
end

return AllianceGovernmentSkillGetListMessage
