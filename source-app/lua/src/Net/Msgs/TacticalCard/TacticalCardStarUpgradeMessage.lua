local TacticalCardStarUpgradeMessage = BaseClass("TacticalCardStarUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cardUuid, costUuids)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", cardUuid)
  if costUuids then
    local array = SFSArray.New()
    table.walk(costUuids, function(k, v)
      array:AddLong(v)
    end)
    self.sfsObj:PutSFSArray("uuids", array)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade3, false)
  local removeUuids = message.uuids
  if removeUuids then
    for i = 1, #removeUuids do
      DataCenter.TacticalCardDataManager:RemoveOneCard(removeUuids[i])
    end
  end
  if message.cardObj then
    local cardObj = message.cardObj
    DataCenter.TacticalCardDataManager:UpdateOneCardData(cardObj)
    EventManager:GetInstance():Broadcast(EventId.TacticalCardStarUpgrade, cardObj.uuid)
    EventManager:GetInstance():Broadcast(EventId.TacticalCardDataChanged)
  end
end

TacticalCardStarUpgradeMessage.OnCreate = OnCreate
TacticalCardStarUpgradeMessage.HandleMessage = HandleMessage
return TacticalCardStarUpgradeMessage
