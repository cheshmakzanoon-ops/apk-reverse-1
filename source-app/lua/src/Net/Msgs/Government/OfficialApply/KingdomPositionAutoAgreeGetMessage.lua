local KingdomPositionAutoAgreeGetMessage = BaseClass("KingdomPositionAutoAgreeGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomPositionAutoAgreeGetMessage:OnCreate(param)
  base.OnCreate(self)
end

function KingdomPositionAutoAgreeGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GovernmentManager:SetKingdomPositionAutoAgreeInfo(t)
  end
end

return KingdomPositionAutoAgreeGetMessage
