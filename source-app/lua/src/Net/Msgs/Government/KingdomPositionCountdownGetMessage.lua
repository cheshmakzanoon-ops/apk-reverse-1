local KingdomPositionCountdownGetMessage = BaseClass("KingdomPositionCountdownGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomPositionCountdownGetMessage:OnCreate(param)
  base.OnCreate(self)
end

function KingdomPositionCountdownGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GovernmentManager:SetKingdomPositionTimes(t)
  end
end

return KingdomPositionCountdownGetMessage
