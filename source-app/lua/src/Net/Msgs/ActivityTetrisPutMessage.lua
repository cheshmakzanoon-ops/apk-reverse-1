local ActivityTetrisPutMessage = BaseClass("ActivityTetrisPutMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisPutMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("pieceid", param.pieceid)
  self.sfsObj:PutInt("x", param.x)
  self.sfsObj:PutInt("y", param.y)
end

function ActivityTetrisPutMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTetrisManager:OnPutCallback(t)
  end
end

return ActivityTetrisPutMessage
