local PushRunningBossDelMessage = BaseClass("PushRunningBossDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWDoomsdayManager:OnSingleBossDelete(t)
  end
end

PushRunningBossDelMessage.OnCreate = OnCreate
PushRunningBossDelMessage.HandleMessage = HandleMessage
return PushRunningBossDelMessage
