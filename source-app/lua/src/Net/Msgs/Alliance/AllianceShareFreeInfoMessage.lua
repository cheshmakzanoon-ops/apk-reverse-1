local AllianceShareFreeInfoMessage = BaseClass("AllianceShareFreeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceShareFreeInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceShareFreeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceInviteFreeMessage, {
      isFree = t.free,
      endTime = t.endTime
    })
  end
end

return AllianceShareFreeInfoMessage
