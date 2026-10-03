local LwRqUserDepositBankMessage = BaseClass("LwRqUserDepositBankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwRqUserDepositBankMessage:OnCreate(param)
  base.OnCreate(self)
end

function LwRqUserDepositBankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local list = t.strongholdIds or {}
  local dic = {}
  for _, id in ipairs(list) do
    dic[id] = true
  end
  DataCenter.SeasonBankManager.selfDepositData = dic
  EventManager:GetInstance():Broadcast(EventId.BankDepositChange)
end

return LwRqUserDepositBankMessage
