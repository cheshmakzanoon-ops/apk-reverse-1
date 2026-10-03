local PushWorldSuppliesDetailMessage = BaseClass("PushWorldSuppliesDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldSuppliesDetailMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushWorldSuppliesDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldPointDetailManager:UpdateWorldChargeData(t)
  end
end

return PushWorldSuppliesDetailMessage
