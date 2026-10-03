local PushBankDepositChangeMessage = BaseClass("PushBankDepositChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBankDepositChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBankDepositChangeMessage:HandleMessage(t)
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

return PushBankDepositChangeMessage
