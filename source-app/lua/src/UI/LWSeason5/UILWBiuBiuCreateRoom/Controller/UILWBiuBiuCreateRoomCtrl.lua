local UILWBiuBiuCreateRoomCtrl = BaseClass("UILWBiuBiuCreateRoomCtrl", UIBaseCtrl)

function UILWBiuBiuCreateRoomCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuCreateRoom)
end

function UILWBiuBiuCreateRoomCtrl:CheckName(value)
  local len = string.len(value)
  local type = CheckNameType.None
  if len < 3 then
    type = CheckNameType.MaxNameChar
  elseif len > DataCenter.LWBiuBiuDataManager:GetPvpNotifyStrLength() then
    type = CheckNameType.MaxNameChar
  end
  return type
end

function UILWBiuBiuCreateRoomCtrl:OnCustomKeyCodeEscape()
  if self.req then
    return
  end
  self:CloseSelf()
end

return UILWBiuBiuCreateRoomCtrl
