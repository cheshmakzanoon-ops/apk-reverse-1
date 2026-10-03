local OfficialSelectMemberCtrl = BaseClass("OfficialSelectMemberCtrl", UIBaseCtrl)

function OfficialSelectMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficialSelectMember)
end

return OfficialSelectMemberCtrl
