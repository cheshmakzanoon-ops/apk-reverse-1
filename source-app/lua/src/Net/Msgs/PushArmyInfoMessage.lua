local PushArmyInfoMessage = BaseClass("PushArmyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.heros ~= nil then
    DataCenter.HeroDataManager:UpdateHeroes(message.heros)
  end
  if message.soldiers ~= nil then
    for k, v in pairs(message.soldiers) do
      DataCenter.ArmyManager:UpdateOneArmy(v)
    end
  end
end

PushArmyInfoMessage.OnCreate = OnCreate
PushArmyInfoMessage.HandleMessage = HandleMessage
return PushArmyInfoMessage
