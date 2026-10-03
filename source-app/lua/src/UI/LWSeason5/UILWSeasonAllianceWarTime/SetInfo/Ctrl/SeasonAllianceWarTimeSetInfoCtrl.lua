local SeasonAllianceWarTimeSetInfoCtrl = BaseClass("SeasonAllianceWarTimeSetInfoCtrl", UIBaseCtrl)

function SeasonAllianceWarTimeSetInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonAllianceWarTimeSetInfoView)
end

return SeasonAllianceWarTimeSetInfoCtrl
