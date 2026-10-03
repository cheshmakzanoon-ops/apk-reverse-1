local UITutorialAnimationCtrl = BaseClass("UITutorialAnimationCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UITutorialAnimation)
end

UITutorialAnimationCtrl.CloseSelf = CloseSelf
return UITutorialAnimationCtrl
