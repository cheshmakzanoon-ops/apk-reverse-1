local UIAccountBanCtrl = BaseClass("UIAccountBanCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountBan)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnCustomKeyCodeEscape(self)
end

UIAccountBanCtrl.CloseSelf = CloseSelf
UIAccountBanCtrl.Close = Close
UIAccountBanCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIAccountBanCtrl
