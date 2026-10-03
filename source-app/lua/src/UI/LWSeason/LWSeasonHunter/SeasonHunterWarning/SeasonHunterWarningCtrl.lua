local SeasonHunterWarningCtrl = BaseClass("SeasonHunterWarningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterWarning, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

SeasonHunterWarningCtrl.CloseSelf = CloseSelf
SeasonHunterWarningCtrl.Close = Close
return SeasonHunterWarningCtrl
