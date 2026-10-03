local OfficialBuffCtrl = BaseClass("OfficialBuffCtrl", UIBaseCtrl)

function OfficialBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficialBuff)
end

return OfficialBuffCtrl
