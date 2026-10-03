local UICommonMessageWithImageBarCtrl = BaseClass("UICommonMessageWithImageBarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageWithImageBar, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UICommonMessageWithImageBarCtrl.CloseSelf = CloseSelf
UICommonMessageWithImageBarCtrl.Close = Close
return UICommonMessageWithImageBarCtrl
