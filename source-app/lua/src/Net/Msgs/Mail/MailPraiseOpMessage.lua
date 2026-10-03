local MailPraiseOpMessage = BaseClass("MailPraiseOpMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function MailPraiseOpMessage:OnCreate(mailUid, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", mailUid)
  self.sfsObj:PutInt("type", type)
end

function MailPraiseOpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.MailDataManager:SetMailLikeData(t)
  EventManager:GetInstance():Broadcast(EventId.RefreshMailLikeData, t)
end

return MailPraiseOpMessage
