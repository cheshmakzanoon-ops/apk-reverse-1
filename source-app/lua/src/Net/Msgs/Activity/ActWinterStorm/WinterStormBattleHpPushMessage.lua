local WinterStormBattleHpPushMessage = BaseClass("WinterStormBattleHpPushMessage", SFSBaseMessage)
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
    DataCenter.ActWinterStormManager:HandleBuildingHpChange(t)
  end
end

WinterStormBattleHpPushMessage.OnCreate = OnCreate
WinterStormBattleHpPushMessage.HandleMessage = HandleMessage
return WinterStormBattleHpPushMessage
