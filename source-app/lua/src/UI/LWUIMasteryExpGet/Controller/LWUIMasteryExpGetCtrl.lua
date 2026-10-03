local LWUIMasteryExpGetCtrl = BaseClass("LWUIMasteryExpGetCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryExpGet, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

LWUIMasteryExpGetCtrl.CloseSelf = CloseSelf
LWUIMasteryExpGetCtrl.Close = Close
return LWUIMasteryExpGetCtrl
