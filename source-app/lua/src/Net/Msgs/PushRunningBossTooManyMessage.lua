local PushRunningBossTooManyMessage = BaseClass("PushRunningBossTooManyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local str
    if DataCenter.LWDoomsdayManager:IsOpen() then
      str = LuaEntry.DataConfig:TryGetStr("running_boss", "k8", "")
    else
      str = LuaEntry.DataConfig:TryGetStr("running_boss", "k7", "")
    end
    local tips = Localization:GetString("running_boss_willy_002", str)
    UIUtil.ShowTips(tips)
  end
end

PushRunningBossTooManyMessage.OnCreate = OnCreate
PushRunningBossTooManyMessage.HandleMessage = HandleMessage
return PushRunningBossTooManyMessage
