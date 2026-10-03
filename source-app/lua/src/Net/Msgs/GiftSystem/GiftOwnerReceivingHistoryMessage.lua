local GiftOwnerReceivingHistoryMessage = BaseClass("GiftOwnerReceivingHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GiftOwnerReceivingHistoryMessage:OnCreate(param, filterContent)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", param.itemId)
  self.sfsObj:PutInt("start", param.startIndex or 1)
  self.sfsObj:PutInt("end", param.endIndex or 50)
  if filterContent then
    self.sfsObj:PutInt("filterContent", filterContent)
  end
end

function GiftOwnerReceivingHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleGiftReceivingHistory(t.historyArr, t.params)
  end
end

return GiftOwnerReceivingHistoryMessage
