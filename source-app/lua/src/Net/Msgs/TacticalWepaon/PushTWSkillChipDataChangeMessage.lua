local PushTWSkillChipDataChangeMessage = BaseClass("PushTWSkillChipDataChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushTWSkillChipDataChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushTWSkillChipDataChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t)
  end
end

return PushTWSkillChipDataChangeMessage
