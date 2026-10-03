local SeasonHunterConvertCtrl = BaseClass("SeasonHunterConvertCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterConvert)
end

SeasonHunterConvertCtrl.CloseSelf = CloseSelf
return SeasonHunterConvertCtrl
