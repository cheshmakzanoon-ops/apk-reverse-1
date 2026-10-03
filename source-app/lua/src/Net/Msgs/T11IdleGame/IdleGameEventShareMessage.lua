local IdleGameEventShareMessage = BaseClass("IdleGameEventShareMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventShareMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
end

function IdleGameEventShareMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120061)
  end
end

return IdleGameEventShareMessage
