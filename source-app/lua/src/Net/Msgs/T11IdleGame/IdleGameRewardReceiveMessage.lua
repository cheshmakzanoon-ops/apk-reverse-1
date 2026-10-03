local IdleGameRewardReceiveMessage = BaseClass("IdleGameRewardReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameRewardReceiveMessage:OnCreate(param)
  base.OnCreate(self)
end

function IdleGameRewardReceiveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnRewardReceiveMessage(t)
  end
end

return IdleGameRewardReceiveMessage
