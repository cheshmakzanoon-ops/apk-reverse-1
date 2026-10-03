local ActivityTetrisStartMessage = BaseClass("ActivityTetrisStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisStartMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivityTetrisStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTetrisManager:OnStartCallback(t)
  end
end

return ActivityTetrisStartMessage
