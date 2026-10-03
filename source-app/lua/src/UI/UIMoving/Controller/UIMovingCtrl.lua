local UIMovingCtrl = BaseClass("UIMovingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoving, {anim = false, playEffect = false})
end

UIMovingCtrl.CloseSelf = CloseSelf
return UIMovingCtrl
