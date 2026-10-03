local IdleGameMainMessage = BaseClass("IdleGameMainMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameMainMessage:OnCreate(param)
  base.OnCreate(self)
end

function IdleGameMainMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnGetIdleGameMainMessage(t)
  end
end

return IdleGameMainMessage
