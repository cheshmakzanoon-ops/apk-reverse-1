local UIWorldServerChangeTipCtrl = BaseClass("UIWorldServerChangeTip", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldServerChangeTip, {anim = false})
end

UIWorldServerChangeTipCtrl.CloseSelf = CloseSelf
return UIWorldServerChangeTipCtrl
