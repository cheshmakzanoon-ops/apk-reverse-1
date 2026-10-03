local UIDispatchTaskHeroShowCtrl = BaseClass("UIDispatchTaskHeroShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskHeroShow, {anim = false})
end

UIDispatchTaskHeroShowCtrl.CloseSelf = CloseSelf
return UIDispatchTaskHeroShowCtrl
