local TWSkillChipUnlockMessage = BaseClass("TWSkillChipUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipUnlockMessage:OnCreate(equipGroup)
  base.OnCreate(self)
  if equipGroup == nil then
    return
  end
  self.sfsObj:PutInt("equipGroup", equipGroup)
end

function TWSkillChipUnlockMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t)
    if t.gold then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    UIUtil.ShowTipsId("120088")
  end
end

return TWSkillChipUnlockMessage
