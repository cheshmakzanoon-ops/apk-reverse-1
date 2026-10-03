local EncourageSelectMemberCtrl = BaseClass("EncourageSelectMemberCtrl", UIBaseCtrl)

function EncourageSelectMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEncourageSelectMember)
end

return EncourageSelectMemberCtrl
