local TacticalCardLvUpgradeMessage = BaseClass("TacticalCardLvUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cardUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", cardUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  if not message.cardObj then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade3, false)
  DataCenter.TacticalCardDataManager:UpdateOneCardData(message.cardObj)
  local cardUuid = message.cardObj.uuid
  EventManager:GetInstance():Broadcast(EventId.TacticalCardLvUpgrade, cardUuid)
  EventManager:GetInstance():Broadcast(EventId.TacticalCardDataChanged)
end

TacticalCardLvUpgradeMessage.OnCreate = OnCreate
TacticalCardLvUpgradeMessage.HandleMessage = HandleMessage
return TacticalCardLvUpgradeMessage
