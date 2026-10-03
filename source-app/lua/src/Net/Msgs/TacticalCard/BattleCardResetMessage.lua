local BattleCardResetMessage = BaseClass("BattleCardResetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cardUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", cardUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if message.cardObj then
    local cardObj = message.cardObj
    DataCenter.TacticalCardDataManager:UpdateOneCardData(cardObj)
    EventManager:GetInstance():Broadcast(EventId.TacticalCardReset, cardObj.uuid)
    EventManager:GetInstance():Broadcast(EventId.TacticalCardDataChanged)
  end
end

BattleCardResetMessage.OnCreate = OnCreate
BattleCardResetMessage.HandleMessage = HandleMessage
return BattleCardResetMessage
