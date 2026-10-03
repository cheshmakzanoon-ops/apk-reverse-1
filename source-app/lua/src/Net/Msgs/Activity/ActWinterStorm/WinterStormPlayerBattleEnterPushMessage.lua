local WinterStormPlayerBattleEnterPushMessage = BaseClass("WinterStormPlayerBattleEnterPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandlePlayerBattleEnterPush(t)
  end
end

WinterStormPlayerBattleEnterPushMessage.OnCreate = OnCreate
WinterStormPlayerBattleEnterPushMessage.HandleMessage = HandleMessage
return WinterStormPlayerBattleEnterPushMessage
