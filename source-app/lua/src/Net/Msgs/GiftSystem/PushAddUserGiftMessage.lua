local PushAddUserGiftMessage = BaseClass("PushAddUserGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAddUserGiftMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAddUserGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleAddGift(t)
  end
end

return PushAddUserGiftMessage
