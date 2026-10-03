local TWSkillChipDataMessage = BaseClass("TWSkillChipDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipDataMessage:OnCreate()
  base.OnCreate(self)
end

function TWSkillChipDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    DataCenter.TWSkillChipManager:ClearData()
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t)
  end
end

return TWSkillChipDataMessage
