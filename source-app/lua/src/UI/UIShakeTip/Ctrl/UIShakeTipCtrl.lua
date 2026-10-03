local UIShakeTipCtrl = BaseClass("UIShakeTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShakeTip)
end

UIShakeTipCtrl.CloseSelf = CloseSelf
return UIShakeTipCtrl
