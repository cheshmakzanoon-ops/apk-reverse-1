local ctrl = BaseClass("ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailTroopBuffAddPanel)
end

ctrl.CloseSelf = CloseSelf
return ctrl
