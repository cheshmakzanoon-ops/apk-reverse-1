local UIFingerArrowCtrl = BaseClass("UIFingerArrowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFingerArrow)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Guide)
end

UIFingerArrowCtrl.CloseSelf = CloseSelf
UIFingerArrowCtrl.Close = Close
return UIFingerArrowCtrl
