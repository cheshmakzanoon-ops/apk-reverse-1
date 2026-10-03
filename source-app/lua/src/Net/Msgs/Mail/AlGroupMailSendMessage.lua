local AlGroupMailSendMessage = BaseClass("AlGroupMailSendMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function AlGroupMailSendMessage:OnCreate(rankList, title, message)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("rankList", rankList)
  self.sfsObj:PutUtfString("title", title)
  self.sfsObj:PutUtfString("message", message)
end

function AlGroupMailSendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    return
  end
  UIUtil.ShowTipsId(390497)
end

return AlGroupMailSendMessage
