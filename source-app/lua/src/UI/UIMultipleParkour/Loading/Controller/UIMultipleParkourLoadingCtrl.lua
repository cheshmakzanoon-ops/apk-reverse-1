local UIMultipleParkourLoadingCtrl = BaseClass("UIMultipleParkourLoadingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourLoading)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Dialog)
end

function UIMultipleParkourLoadingCtrl:OnCustomKeyCodeEscape()
end

UIMultipleParkourLoadingCtrl.CloseSelf = CloseSelf
UIMultipleParkourLoadingCtrl.Close = Close
return UIMultipleParkourLoadingCtrl
