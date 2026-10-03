local ActivityTetrisInfoMessage = BaseClass("ActivityTetrisInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivityTetrisInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTetrisManager:OnGetInfoCallback(t)
  end
end

return ActivityTetrisInfoMessage
