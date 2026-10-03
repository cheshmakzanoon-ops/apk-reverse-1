local UILWGGGoCreateRoomCtrl = BaseClass("UILWGGGoCreateRoomCtrl", UIBaseCtrl)

function UILWGGGoCreateRoomCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoCreateRoom)
end

function UILWGGGoCreateRoomCtrl:CheckName(value)
  local len = string.len(value)
  local type = CheckNameType.None
  if len < 3 then
    type = CheckNameType.MaxNameChar
  elseif len > DataCenter.LWGGGoDataManager:GetPvpNotifyStrLength() then
    type = CheckNameType.MaxNameChar
  end
  return type
end

function UILWGGGoCreateRoomCtrl:OnCustomKeyCodeEscape()
  if self.req then
    return
  end
  self:CloseSelf()
end

return UILWGGGoCreateRoomCtrl
