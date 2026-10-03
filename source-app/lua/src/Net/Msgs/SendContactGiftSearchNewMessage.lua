local SendContactGiftSearchNewMessage = BaseClass("SendContactGiftSearchNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SendContactGiftSearchNewMessage:OnCreate(searchType, searchName)
  base.OnCreate(self)
  self.sfsObj:PutInt("searchType", searchType)
  self.sfsObj:PutUtfString("searchName", searchName)
end

function SendContactGiftSearchNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 and #t.errorPara2 >= 1 then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, t.errorPara2[1]))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.SendContactGiftSearchBack, t)
  end
end

return SendContactGiftSearchNewMessage
