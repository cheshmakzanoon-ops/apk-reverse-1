local PushUnlockGiftModelMessage = BaseClass("PushUnlockGiftModelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUnlockGiftModelMessage:OnCreate()
  base.OnCreate(self)
end

function PushUnlockGiftModelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftDetailShowDataManager:SetGiftModelUnlockData(t)
  end
end

return PushUnlockGiftModelMessage
