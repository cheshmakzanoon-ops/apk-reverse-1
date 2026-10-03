local PushBloodQueenHpChangeMessage = BaseClass("PushBloodQueenHpChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBloodQueenHpChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBloodQueenHpChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1QueenOfBloodManager:OnPushBloodQueenHpChangeMessage(t)
  end
end

return PushBloodQueenHpChangeMessage
