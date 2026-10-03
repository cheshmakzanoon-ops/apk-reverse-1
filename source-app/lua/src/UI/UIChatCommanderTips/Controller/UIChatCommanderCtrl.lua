local UIChatCommanderCtrl = BaseClass("UIChatCommanderCtrl", UIBaseCtrl)

function UIChatCommanderCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatCommanderTips)
end

return UIChatCommanderCtrl
