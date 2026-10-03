local UIChatRoomCellOperatorCtrl = BaseClass("UIChatRoomCellOperatorCtrl", UIBaseCtrl)

function UIChatRoomCellOperatorCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatRoomCellOperatorView)
end

return UIChatRoomCellOperatorCtrl
