local UILWActConcertRewardRecordCtrl = BaseClass("UILWActConcertRewardRecordCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWActConcertRewardRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWActConcertRewardRecord)
end

return UILWActConcertRewardRecordCtrl
