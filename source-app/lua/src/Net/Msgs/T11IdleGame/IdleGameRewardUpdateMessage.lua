local IdleGameRewardUpdateMessage = BaseClass("IdleGameRewardUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameRewardUpdateMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", param.index)
end

function IdleGameRewardUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnRewardUpdateMessage(t)
  end
end

return IdleGameRewardUpdateMessage
