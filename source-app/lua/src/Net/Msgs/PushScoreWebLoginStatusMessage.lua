local PushScoreWebLoginStatusMessage = BaseClass("PushScoreWebLoginStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushScoreWebLoginStatusMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushScoreWebLoginStatusMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AccountScoreManager:UpdateAccountScoreData(t)
  end
end

return PushScoreWebLoginStatusMessage
