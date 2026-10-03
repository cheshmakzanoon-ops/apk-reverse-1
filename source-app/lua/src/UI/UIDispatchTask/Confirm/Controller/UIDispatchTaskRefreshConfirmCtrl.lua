local UIDispatchTaskRefreshConfirmCtrl = BaseClass("UIDispatchTaskRefreshConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskRefreshConfirm, {anim = false})
end

UIDispatchTaskRefreshConfirmCtrl.CloseSelf = CloseSelf
return UIDispatchTaskRefreshConfirmCtrl
