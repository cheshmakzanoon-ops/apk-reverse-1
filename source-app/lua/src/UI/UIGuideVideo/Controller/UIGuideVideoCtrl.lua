local UIGuideVideoCtrl = BaseClass("UIGuideVideoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideVideo, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Guide)
end

UIGuideVideoCtrl.CloseSelf = CloseSelf
UIGuideVideoCtrl.Close = Close
return UIGuideVideoCtrl
