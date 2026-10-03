local WinterStormBattlePushPlayerMessage = BaseClass("WinterStormBattlePushPlayerMessage", SFSBaseMessage)
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
    DataCenter.ActWinterStormManager:HandleBattlePushPlayer(t)
  end
end

WinterStormBattlePushPlayerMessage.OnCreate = OnCreate
WinterStormBattlePushPlayerMessage.HandleMessage = HandleMessage
return WinterStormBattlePushPlayerMessage
