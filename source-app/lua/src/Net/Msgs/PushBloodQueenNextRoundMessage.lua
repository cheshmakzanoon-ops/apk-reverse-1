local PushBloodQueenNextRoundMessage = BaseClass("PushBloodQueenNextRoundMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBloodQueenNextRoundMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBloodQueenNextRoundMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1QueenOfBloodManager:RefreshRoundInfo(t)
  end
end

return PushBloodQueenNextRoundMessage
