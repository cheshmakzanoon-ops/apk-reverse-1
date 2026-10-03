local TacticalCardOpenBoxMessage = BaseClass("TacticalCardOpenBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, itemId, num)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", tostring(itemId))
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.TacticalCardDataManager:UpdateDataFromServerData(message)
  local cardUuids = {}
  for _, card in ipairs(message.userBattleCards) do
    table.insert(cardUuids, card.uuid)
  end
  local retData = {
    cardUuids = cardUuids,
    boxId = message.boxId,
    newUuids = message.newUuids
  }
  EventManager:GetInstance():Broadcast(EventId.TacticalCardOpenBox, retData)
end

TacticalCardOpenBoxMessage.OnCreate = OnCreate
TacticalCardOpenBoxMessage.HandleMessage = HandleMessage
return TacticalCardOpenBoxMessage
