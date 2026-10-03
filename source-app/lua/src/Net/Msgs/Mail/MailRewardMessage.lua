local MailRewardMessage = BaseClass("MailRewardMessage", SFSBaseMessage)

function MailRewardMessage:OnCreate(mailId)
  if string.IsNullOrEmpty(mailId) then
    MailPrint("\233\162\134\229\143\150\229\165\150\229\138\177\229\143\130\230\149\176\228\184\141\229\175\185, mailId \228\184\186\231\169\186")
    return
  end
  self.sfsObj:PutUtfString("uid", mailId)
  return
end

function MailRewardMessage:HandleMessage(message)
end

return MailRewardMessage
