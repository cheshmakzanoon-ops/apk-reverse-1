local Vip18ProductionHistoryStageMessage = BaseClass("Vip18ProductionHistoryStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Vip18ProductionHistoryStageMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stage", param)
end

function Vip18ProductionHistoryStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:UpdateVip18HistoryView(t)
  end
end

return Vip18ProductionHistoryStageMessage
