local UIWorkerOverviewListCtrl = BaseClass("UIWorkerOverviewListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerOverviewList)
end

UIWorkerOverviewListCtrl.CloseSelf = CloseSelf
return UIWorkerOverviewListCtrl
