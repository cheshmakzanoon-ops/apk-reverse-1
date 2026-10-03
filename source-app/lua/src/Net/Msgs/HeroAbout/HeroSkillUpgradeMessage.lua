local HeroSkillUpgradeMessage = BaseClass("HeroSkillUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, slotId)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
  self.sfsObj:PutInt("slot", slotId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  if message.resource ~= nil then
    LuaEntry.Resource:UpdateResource(message.resource)
  end
  if message.hero ~= nil then
    DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  end
  UIUtil.ShowTipsId(151078)
  EventManager:GetInstance():Broadcast(EventId.SkillUpgradeEnd, message)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
end

HeroSkillUpgradeMessage.OnCreate = OnCreate
HeroSkillUpgradeMessage.HandleMessage = HandleMessage
return HeroSkillUpgradeMessage
