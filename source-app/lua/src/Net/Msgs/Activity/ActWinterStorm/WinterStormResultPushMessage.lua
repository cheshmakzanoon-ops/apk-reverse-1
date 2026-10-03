local WinterStormResultPushMessage = BaseClass("WinterStormResultPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.funClose == true then
    UIUtil.ShowTipsId("E100008")
    if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
      BattleFieldUtil.BackToCity(BattleFieldType.WinterStorm)
    end
  else
    DataCenter.ActWinterStormManager:SendResult()
  end
end

WinterStormResultPushMessage.OnCreate = OnCreate
WinterStormResultPushMessage.HandleMessage = HandleMessage
return WinterStormResultPushMessage
