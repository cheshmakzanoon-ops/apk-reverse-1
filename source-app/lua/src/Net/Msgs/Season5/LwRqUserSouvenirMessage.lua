local LwRqUserSouvenirMessage = BaseClass("LwRqUserSouvenirMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwRqUserSouvenirMessage:OnCreate(itemId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", itemId)
end

function LwRqUserSouvenirMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.BankUserSouvenir, t.extra)
end

return LwRqUserSouvenirMessage
