local PushWeaponEffectsChangeMessage = BaseClass("PushWeaponEffectsChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWeaponEffectsChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushWeaponEffectsChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
    if weaponInfo then
      weaponInfo:UpdateInfo(t)
    end
    if LuaEntry.Player then
      LuaEntry.Player:UpdatePlayerInfo(t)
    end
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponUpdate)
  end
end

return PushWeaponEffectsChangeMessage
