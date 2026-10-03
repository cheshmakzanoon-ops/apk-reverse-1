local UIScreenLoadingCtrl = BaseClass("UIMovingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScreenLoading, {anim = false, playEffect = false})
end

UIScreenLoadingCtrl.CloseSelf = CloseSelf
return UIScreenLoadingCtrl
