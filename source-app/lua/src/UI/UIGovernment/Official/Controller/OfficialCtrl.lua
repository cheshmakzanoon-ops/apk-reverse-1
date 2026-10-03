local OfficialCtrl = BaseClass("OfficialCtrl", UIBaseCtrl)

function OfficialCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficial)
end

return OfficialCtrl
