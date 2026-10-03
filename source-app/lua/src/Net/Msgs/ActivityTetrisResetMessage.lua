local ActivityTetrisResetMessage = BaseClass("ActivityTetrisResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisResetMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("is_restart", param.is_restart)
end

function ActivityTetrisResetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTetrisManager:OnResetCallback(t)
  end
end

return ActivityTetrisResetMessage
