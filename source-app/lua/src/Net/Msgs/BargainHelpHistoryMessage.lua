local BargainHelpHistoryMessage = BaseClass("BargainHelpHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BargainHelpHistoryMessage:OnCreate(activityId)
  base.OnCreate(self)
  if activityId then
    self.sfsObj:PutUtfString("activityId", activityId)
  end
end

function BargainHelpHistoryMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActBargainShopData:UpdateShopInfo(message)
end

return BargainHelpHistoryMessage
