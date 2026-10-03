local PushAccountAllDeviceMessage = BaseClass("PushAccountAllDeviceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAccountAllDeviceMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAccountAllDeviceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIDeviceManage).View
    if v18HistoryView then
      v18HistoryView:UpdateCells(t)
    end
  end
end

return PushAccountAllDeviceMessage
