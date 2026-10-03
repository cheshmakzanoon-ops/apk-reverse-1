local SeasonHunterHonerCtrl = BaseClass("SeasonHunterHonerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterHoner)
end

SeasonHunterHonerCtrl.CloseSelf = CloseSelf
return SeasonHunterHonerCtrl
