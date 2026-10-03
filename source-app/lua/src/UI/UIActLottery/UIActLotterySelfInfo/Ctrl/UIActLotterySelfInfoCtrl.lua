local UIActLotterySelfInfoCtrl = BaseClass("UIActLotterySelfInfoCtrl", UIBaseCtrl)

function UIActLotterySelfInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotterySelfInfo)
end

return UIActLotterySelfInfoCtrl
