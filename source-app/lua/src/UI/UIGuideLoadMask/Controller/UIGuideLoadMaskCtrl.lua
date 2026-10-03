local UIGuideLoadMaskCtrl = BaseClass("UIGuideLoadMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadMask, {anim = true, playEffect = false})
end

UIGuideLoadMaskCtrl.CloseSelf = CloseSelf
return UIGuideLoadMaskCtrl
