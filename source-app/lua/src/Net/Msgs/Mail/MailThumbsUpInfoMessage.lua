local MailThumbsUpInfoMessage = BaseClass("MailThumbsUpInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MailThumbsUpInfoMessage:OnCreate(mailUuid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("mailUuid", mailUuid)
end

function MailThumbsUpInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.mailUuid then
    DataCenter.MailDataManager:SetMailLikeData(t)
    EventManager:GetInstance():Broadcast(EventId.GetMailLikeData, t.mailUuid)
  end
end

return MailThumbsUpInfoMessage
