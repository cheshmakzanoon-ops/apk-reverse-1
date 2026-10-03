local LWUITCExpGetCtrl = BaseClass("LWUITCExpGetCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITCExpGet, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

LWUITCExpGetCtrl.CloseSelf = CloseSelf
LWUITCExpGetCtrl.Close = Close
return LWUITCExpGetCtrl
