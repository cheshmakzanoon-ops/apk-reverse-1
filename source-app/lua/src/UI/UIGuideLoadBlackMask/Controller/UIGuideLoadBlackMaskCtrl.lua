local UIGuideLoadBlackMaskCtrl = BaseClass("UIGuideLoadBlackMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadBlackMask, {anim = true, playEffect = false})
end

UIGuideLoadBlackMaskCtrl.CloseSelf = CloseSelf
return UIGuideLoadBlackMaskCtrl
