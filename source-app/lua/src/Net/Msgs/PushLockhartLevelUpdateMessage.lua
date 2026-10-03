local PushLockhartLevelUpdateMessage = BaseClass("PushLockhartLevelUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLockhartLevelUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushLockhartLevelUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWActivityLockhartManager:SetMaxLockHartUnlockLevel(t.lockhartUnlockedLevel, t.hasFirstKill)
  end
end

return PushLockhartLevelUpdateMessage
