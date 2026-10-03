local SetGiftDetailMessage = BaseClass("SetGiftDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetGiftDetailMessage:OnCreate(itemId, contentState, maxState, firstState, contentId, count)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", itemId)
  self.sfsObj:PutInt("contentState", contentState)
  self.sfsObj:PutInt("maxState", maxState)
  self.sfsObj:PutInt("firstState", firstState)
  if contentId ~= nil then
    self.sfsObj:PutLong("contentId", contentId)
  end
  if count ~= nil then
    self.sfsObj:PutInt("count", count)
  end
end

function SetGiftDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.params and t.params.contentId then
      UIUtil.ShowTipsId("gifts_show_tips_10")
    end
    DataCenter.GiftDetailShowDataManager:SetMsgChangeData(t)
    EventManager:GetInstance():Broadcast(EventId.OnSetGiftDetailMsgBack, t)
  end
end

return SetGiftDetailMessage
