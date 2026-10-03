local SeasonAllianceWarTimeSetConfirmCtrl = BaseClass("SeasonAllianceWarTimeSetConfirmCtrl", UIBaseCtrl)

function SeasonAllianceWarTimeSetConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonAllianceWarTimeSetConfirmView)
end

return SeasonAllianceWarTimeSetConfirmCtrl
