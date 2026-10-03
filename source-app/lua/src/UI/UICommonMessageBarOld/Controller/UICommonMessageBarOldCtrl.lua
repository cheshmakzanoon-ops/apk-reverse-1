local UICommonMessageBarOldCtrl = BaseClass("UICommonMessageBarOldCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageBarOld, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonMessageBarOldCtrl.CloseSelf = CloseSelf
UICommonMessageBarOldCtrl.Close = Close
return UICommonMessageBarOldCtrl
