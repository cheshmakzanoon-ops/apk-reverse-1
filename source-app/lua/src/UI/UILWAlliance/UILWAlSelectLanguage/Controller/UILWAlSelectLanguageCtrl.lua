local UILWAlSelectLanguageCtrl = BaseClass("UILWAlSelectLanguageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlSelectLanguage)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILWAlSelectLanguageCtrl.CloseSelf = CloseSelf
UILWAlSelectLanguageCtrl.Close = Close
return UILWAlSelectLanguageCtrl
