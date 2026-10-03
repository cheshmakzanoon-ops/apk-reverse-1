local UIFishingMainCtrl = BaseClass("UIFishingMainCtrl", UIBaseCtrl)

function UIFishingMainCtrl:CloseSelf()
  DataCenter.FishingDataManager:LeavePond()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishingMain)
end

return UIFishingMainCtrl
