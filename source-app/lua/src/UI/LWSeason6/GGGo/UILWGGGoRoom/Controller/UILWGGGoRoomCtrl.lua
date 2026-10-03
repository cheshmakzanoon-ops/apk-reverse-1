local UILWGGGoRoomCtrl = BaseClass("UILWGGGoRoomCtrl", UIBaseCtrl)

function UILWGGGoRoomCtrl:OnCustomKeyCodeEscape()
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  local state = room:GetState()
  if state == LittleGameRoomState.WaitPlayer or state == LittleGameRoomState.FightEnd or state == -1 then
    room:ReqCancel()
    self:CloseSelf()
  end
end

function UILWGGGoRoomCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoRoom)
end

return UILWGGGoRoomCtrl
