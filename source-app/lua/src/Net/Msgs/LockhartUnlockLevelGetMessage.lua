local LockhartUnlockLevelGetMessage = BaseClass("LockhartUnlockLevelGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LockhartUnlockLevelGetMessage:OnCreate(param)
  base.OnCreate(self)
end

function LockhartUnlockLevelGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWActivityLockhartManager:SetMaxLockHartUnlockLevel(t.lockhartUnlockedLevel, t.hasFirstKill)
  end
end

return LockhartUnlockLevelGetMessage
