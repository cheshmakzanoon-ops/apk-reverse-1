local WepaonLevelUpMessage = BaseClass("WepaonLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WepaonLevelUpMessage:OnCreate(id, clientPara, upgradeType)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutUtfString("clientPara", tostring(clientPara))
  self.sfsObj:PutInt("upgradeType", upgradeType)
end

function WepaonLevelUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil and errCode ~= "uav_grade_type_error" then
    print(errCode)
  else
    DataCenter.TacticalWeaponManager:UpdateWeapon(t.weapon)
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponLevelUp, t)
  end
end

return WepaonLevelUpMessage
