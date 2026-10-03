local MailThumbsUpMessage = BaseClass("MailThumbsUpMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function MailThumbsUpMessage:OnCreate(mailUuid, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("mailUuid", mailUuid)
  self.sfsObj:PutInt("like", type)
end

function MailThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.mailUuid then
    DataCenter.MailDataManager:SetMailLikeData(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshMailLikeData, t)
  end
end

return MailThumbsUpMessage
