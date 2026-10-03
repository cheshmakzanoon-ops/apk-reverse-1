local GiftOtherReceivingHistoryMessage = BaseClass("GiftOtherReceivingHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GiftOtherReceivingHistoryMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", param.targetUid)
  self.sfsObj:PutInt("itemId", param.itemId)
  self.sfsObj:PutInt("start", param.startIndex or 1)
  self.sfsObj:PutInt("end", param.endIndex or 20)
end

function GiftOtherReceivingHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleGiftReceivingHistory(t.historyArr)
  end
end

return GiftOtherReceivingHistoryMessage
