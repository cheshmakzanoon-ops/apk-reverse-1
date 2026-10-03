local IdleGameEndMessage = BaseClass("IdleGameEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEndMessage:OnCreate(param)
  base.OnCreate(self)
end

function IdleGameEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnEndMessage(t)
  end
end

return IdleGameEndMessage
