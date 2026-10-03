local UISeasonOfficialHistoryCtrl = BaseClass("UISeasonOfficialHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialHistory)
end

UISeasonOfficialHistoryCtrl.CloseSelf = CloseSelf
return UISeasonOfficialHistoryCtrl
