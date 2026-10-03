local UIWorldZoneChangeTipCtrl = BaseClass("UIWorldZoneChangeTip", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldZoneChangeTip, {anim = false})
end

UIWorldZoneChangeTipCtrl.CloseSelf = CloseSelf
return UIWorldZoneChangeTipCtrl
