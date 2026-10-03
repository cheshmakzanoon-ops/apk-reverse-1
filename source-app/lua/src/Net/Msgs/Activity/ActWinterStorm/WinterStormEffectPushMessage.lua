local WinterStormEffectPushMessage = BaseClass("WinterStormEffectPushMessage", SFSBaseMessage)
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
    BattleFieldUtil.HandleEffects(t, BattleFieldType.WinterStorm)
  end
end

WinterStormEffectPushMessage.OnCreate = OnCreate
WinterStormEffectPushMessage.HandleMessage = HandleMessage
return WinterStormEffectPushMessage
