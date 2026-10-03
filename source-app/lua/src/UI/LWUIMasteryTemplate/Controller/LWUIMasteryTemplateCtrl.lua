local LWUIMasteryTemplateCtrl = BaseClass("LWUIMasteryTemplateCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryTemplate, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIMasteryTemplateCtrl.CloseSelf = CloseSelf
LWUIMasteryTemplateCtrl.Close = Close
return LWUIMasteryTemplateCtrl
