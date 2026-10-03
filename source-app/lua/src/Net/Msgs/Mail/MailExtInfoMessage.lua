local MailExtInfoMessage = BaseClass("MailExtInfoMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function MailExtInfoMessage:OnCreate(mailUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", mailUid)
end

function MailExtInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t.uid then
  else
    DataCenter.MailDataManager:SetMailLikeData(t)
    EventManager:GetInstance():Broadcast(EventId.GetMailLikeData, t.uid)
  end
end

return MailExtInfoMessage
