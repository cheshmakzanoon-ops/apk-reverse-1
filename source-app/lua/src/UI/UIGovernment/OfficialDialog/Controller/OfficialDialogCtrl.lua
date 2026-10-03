local OfficialDialogCtrl = BaseClass("OfficialDialogCtrl", UIBaseCtrl)

function OfficialDialogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficialDialog)
end

return OfficialDialogCtrl
