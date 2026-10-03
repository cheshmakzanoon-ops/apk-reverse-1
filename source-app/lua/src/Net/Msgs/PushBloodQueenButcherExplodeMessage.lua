local PushBloodQueenButcherExplodeMessage = BaseClass("PushBloodQueenButcherExplodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBloodQueenButcherExplodeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBloodQueenButcherExplodeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCityTipManager:ShowBloodQueenButcherExplodeTip(t.damage, t.pointId)
  end
end

return PushBloodQueenButcherExplodeMessage
