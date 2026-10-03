local SeasonHunterResultCtrl = BaseClass("SeasonHunterResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterResult)
end

SeasonHunterResultCtrl.CloseSelf = CloseSelf
return SeasonHunterResultCtrl
