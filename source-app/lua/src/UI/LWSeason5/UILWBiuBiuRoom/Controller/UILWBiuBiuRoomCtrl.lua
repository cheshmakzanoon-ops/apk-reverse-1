local UILWBiuBiuRoomCtrl = BaseClass("UILWBiuBiuRoomCtrl", UIBaseCtrl)

function UILWBiuBiuRoomCtrl:OnCustomKeyCodeEscape()
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local state = room:GetState()
  if state == LittleGameRoomState.WaitPlayer or state == LittleGameRoomState.FightEnd or state == -1 then
    room:ReqCancel()
    self:CloseSelf()
  end
end

function UILWBiuBiuRoomCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuRoom)
end

return UILWBiuBiuRoomCtrl
