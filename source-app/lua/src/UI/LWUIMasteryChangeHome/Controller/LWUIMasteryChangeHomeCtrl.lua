local LWUIMasteryChangeHomeCtrl = BaseClass("LWUIMasteryChangeHomeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryChangeHome, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIMasteryChangeHomeCtrl.CloseSelf = CloseSelf
LWUIMasteryChangeHomeCtrl.Close = Close
return LWUIMasteryChangeHomeCtrl
