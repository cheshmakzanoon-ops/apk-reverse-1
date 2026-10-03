local UWEnhanceUnitUpgradeMessage = BaseClass("UWEnhanceUnitUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, unitType, useComItem)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
  self.sfsObj:PutInt("slot", unitType)
  self.sfsObj:PutBool("exchange", useComItem)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  local heroUuid = message.hero.uuid
  local slot = message.slot
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  EventManager:GetInstance():Broadcast(EventId.HeroUWEnhanceUnitUpgrade, {uuid = heroUuid, unitType = slot})
end

UWEnhanceUnitUpgradeMessage.OnCreate = OnCreate
UWEnhanceUnitUpgradeMessage.HandleMessage = HandleMessage
return UWEnhanceUnitUpgradeMessage
