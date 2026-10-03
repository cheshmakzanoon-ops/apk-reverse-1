local GetAllianceOfficialSkillListMessage = BaseClass("GetAllianceOfficialSkillListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceOfficialSkillListMessage:OnCreate()
  base.OnCreate(self)
end

function GetAllianceOfficialSkillListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and (t.joinAct ~= nil or t.currStep ~= nil) then
    DataCenter.AllianceGovernmentSkillManager:HandleSkillActivityData(t)
  end
  if t and t.list ~= nil then
    DataCenter.AllianceGovernmentSkillManager:SetUsedSkillStateData(t.list)
  end
  if t and t.timeList ~= nil then
    DataCenter.AllianceGovernmentSkillManager:SetSkillTimeList(t.timeList)
  end
  if t and t.allianceOfficialArr ~= nil then
    DataCenter.AllianceGovernmentSkillManager:SetAllianceOfficialArr(t.allianceOfficialArr)
  end
end

return GetAllianceOfficialSkillListMessage
