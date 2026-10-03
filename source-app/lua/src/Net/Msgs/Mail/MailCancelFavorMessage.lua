local MailCancelFavorMessage = BaseClass("MailCancelFavorMessage", SFSBaseMessage)

local function OnCreate(self, uid, type)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("mail_tips_10006")
  end
end

MailCancelFavorMessage.OnCreate = OnCreate
MailCancelFavorMessage.HandleMessage = HandleMessage
return MailCancelFavorMessage
