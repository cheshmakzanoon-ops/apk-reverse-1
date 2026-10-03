local PushWeaponChangeMessage = BaseClass("PushWeaponChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWeaponChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushWeaponChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    DataCenter.TacticalWeaponManager:Update(t)
  end
end

return PushWeaponChangeMessage
