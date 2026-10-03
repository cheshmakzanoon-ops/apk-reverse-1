local IdleGameEventPlotMessage = BaseClass("IdleGameEventPlotMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventPlotMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
end

function IdleGameEventPlotMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return IdleGameEventPlotMessage
