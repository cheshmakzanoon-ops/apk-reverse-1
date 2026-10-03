local GetAllianceOfficialSkillDetailMessage = BaseClass("GetAllianceOfficialSkillDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceOfficialSkillDetailMessage:OnCreate(skillId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skillId", skillId)
end

function GetAllianceOfficialSkillDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.AllianceGovernmentSkillManager:HandleSkillActivityData(t)
end

return GetAllianceOfficialSkillDetailMessage
