local UIWorkerDetailRecruitCtrl = BaseClass("UIWorkerDetailRecruitCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorkerDetailRecruit)
end

UIWorkerDetailRecruitCtrl.CloseSelf = CloseSelf
return UIWorkerDetailRecruitCtrl
