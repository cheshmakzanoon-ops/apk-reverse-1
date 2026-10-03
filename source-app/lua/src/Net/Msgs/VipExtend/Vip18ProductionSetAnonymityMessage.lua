local Vip18ProductionSetAnonymityMessage = BaseClass("Vip18ProductionSetAnonymityMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Vip18ProductionSetAnonymityMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("anonymity", param)
end

function Vip18ProductionSetAnonymityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.anonymity == 0 then
      UIUtil.ShowTipsId("vip18_extend_anonymity_no")
    else
      UIUtil.ShowTipsId("vip18_extend_anonymity_yes")
    end
    DataCenter.VipExtendManager:UpdateVip18ProductionView(t)
  end
end

return Vip18ProductionSetAnonymityMessage
