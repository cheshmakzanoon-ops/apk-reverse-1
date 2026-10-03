local PushDragonSendUserGift = BaseClass("PushDragonSendUserGift", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonSendUserGift:OnCreate(param)
  base.OnCreate(self)
end

function PushDragonSendUserGift:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.PushDragonGiftReceived, {
      targetUid = t.otherPlayerInfo.uid,
      sendUid = t.sendPlayerInfo.uid,
      giftId = t.itemId
    })
  end
end

return PushDragonSendUserGift
