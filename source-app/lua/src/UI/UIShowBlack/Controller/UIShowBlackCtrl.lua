local UIShowBlackCtrl = BaseClass("UIShowBlackCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShowBlack, {anim = true, playEffect = false})
end

UIShowBlackCtrl.CloseSelf = CloseSelf
return UIShowBlackCtrl
