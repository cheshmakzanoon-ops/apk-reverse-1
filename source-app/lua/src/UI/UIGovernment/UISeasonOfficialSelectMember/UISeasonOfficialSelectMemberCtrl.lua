local UISeasonOfficialSelectMemberCtrl = BaseClass("UISeasonOfficialSelectMemberCtrl", UIBaseCtrl)

function UISeasonOfficialSelectMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialSelectMember)
end

return UISeasonOfficialSelectMemberCtrl
