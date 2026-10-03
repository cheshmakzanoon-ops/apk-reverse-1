local UIWorkerRecruitTipCtrl = BaseClass("UIWorkerRecruitTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerRecruitTip)
end

UIWorkerRecruitTipCtrl.CloseSelf = CloseSelf
return UIWorkerRecruitTipCtrl
