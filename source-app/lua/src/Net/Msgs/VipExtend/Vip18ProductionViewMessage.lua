local Vip18ProductionViewMessage = BaseClass("Vip18ProductionViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Vip18ProductionViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function Vip18ProductionViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:UpdateVip18ProductionView(t)
  end
end

return Vip18ProductionViewMessage
