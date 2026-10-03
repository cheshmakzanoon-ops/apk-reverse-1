local Vip18ProductionHistoryMessage = BaseClass("Vip18ProductionHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Vip18ProductionHistoryMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("endTime", param)
end

function Vip18ProductionHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIVip18History).View
    if v18HistoryView then
      v18HistoryView:HistoryRecordsCallback(t)
    end
  end
end

return Vip18ProductionHistoryMessage
