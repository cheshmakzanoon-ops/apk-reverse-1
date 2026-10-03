local UIDeleteAccountListPopCtrl = BaseClass("UIDeleteAccountListPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDeleteAccountListPop)
end

UIDeleteAccountListPopCtrl.CloseSelf = CloseSelf
return UIDeleteAccountListPopCtrl
