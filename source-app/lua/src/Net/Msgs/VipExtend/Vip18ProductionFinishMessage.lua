local Vip18ProductionFinishMessage = BaseClass("Vip18ProductionFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Vip18ProductionFinishMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stage", param)
end

function Vip18ProductionFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:UpdateVip18ProductionView(t)
  end
end

return Vip18ProductionFinishMessage
