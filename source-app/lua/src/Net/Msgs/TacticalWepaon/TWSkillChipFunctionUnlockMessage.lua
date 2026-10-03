local TWSkillChipFunctionUnlockMessage = BaseClass("TWSkillChipFunctionUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipFunctionUnlockMessage:OnCreate(uuidArr)
  base.OnCreate(self)
end

function TWSkillChipFunctionUnlockMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t)
    EventManager:GetInstance():Broadcast(EventId.TWSkillChipFunctionUnlock)
  end
end

return TWSkillChipFunctionUnlockMessage
