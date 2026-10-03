local ctrl = BaseClass("ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailTroopInfoListView)
end

ctrl.CloseSelf = CloseSelf
return ctrl
