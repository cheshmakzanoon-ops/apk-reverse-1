local PushFormationEffectMessage = BaseClass("PushFormationEffectMessage", SFSBaseMessage)
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
    DataCenter.ArmyFormationDataManager:OnPushFormationEffectNumber(t)
  end
end

PushFormationEffectMessage.OnCreate = OnCreate
PushFormationEffectMessage.HandleMessage = HandleMessage
return PushFormationEffectMessage
