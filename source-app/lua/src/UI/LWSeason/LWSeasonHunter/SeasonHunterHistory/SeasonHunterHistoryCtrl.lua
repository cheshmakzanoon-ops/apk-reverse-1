local SeasonHunterHistoryCtrl = BaseClass("SeasonHunterHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterHistory)
end

SeasonHunterHistoryCtrl.CloseSelf = CloseSelf
return SeasonHunterHistoryCtrl
