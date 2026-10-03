local T11IdleGameSurpriseOpenMessage = BaseClass("T11IdleGameSurpriseOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function T11IdleGameSurpriseOpenMessage:OnCreate(param)
  base.OnCreate(self)
end

function T11IdleGameSurpriseOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnOpenSurpriseBoxMessage(t)
  end
end

return T11IdleGameSurpriseOpenMessage
