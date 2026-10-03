local UILWActConcertListCtrl = BaseClass("UILWActConcertListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWActConcertListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWActConcertList)
end

return UILWActConcertListCtrl
