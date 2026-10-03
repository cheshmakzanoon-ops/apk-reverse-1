local IdleGameEventGoodsMessage = BaseClass("IdleGameEventGoodsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventGoodsMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
end

function IdleGameEventGoodsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return IdleGameEventGoodsMessage
