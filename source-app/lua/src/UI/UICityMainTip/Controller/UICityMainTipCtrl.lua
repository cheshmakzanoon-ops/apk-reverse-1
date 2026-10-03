local UICityMainTipCtrl = BaseClass("UICityMainTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityMainTip, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICityMainTipCtrl.CloseSelf = CloseSelf
UICityMainTipCtrl.Close = Close
return UICityMainTipCtrl
