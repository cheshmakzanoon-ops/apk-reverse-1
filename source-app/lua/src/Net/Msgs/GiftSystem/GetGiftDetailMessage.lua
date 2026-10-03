local GetGiftDetailMessage = BaseClass("GetGiftDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGiftDetailMessage:OnCreate(itemId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("itemId", itemId)
end

function GetGiftDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftDetailShowDataManager:SetMsgData(t)
    EventManager:GetInstance():Broadcast(EventId.OnGetGiftDetailMsgBack, t)
  end
end

return GetGiftDetailMessage
