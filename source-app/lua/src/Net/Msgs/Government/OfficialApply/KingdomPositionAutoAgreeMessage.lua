local KingdomPositionAutoAgreeMessage = BaseClass("KingdomPositionAutoAgreeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomPositionAutoAgreeMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function KingdomPositionAutoAgreeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GovernmentManager:SetKingdomPositionAutoAgreeInfo(t)
    if t.type == 1 then
      UIUtil.ShowTipsId("officer_apply_053")
    else
      UIUtil.ShowTipsId("officer_apply_057")
    end
  end
end

return KingdomPositionAutoAgreeMessage
