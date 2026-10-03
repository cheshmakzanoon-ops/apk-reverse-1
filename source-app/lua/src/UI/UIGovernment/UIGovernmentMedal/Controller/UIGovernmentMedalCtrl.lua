local UIGovernmentMedalCtrl = BaseClass("UIGovernmentMedalCtrl", UIBaseCtrl)

function UIGovernmentMedalCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentMedal)
end

return UIGovernmentMedalCtrl
