local SeasonAllianceWarTimeSetCtrl = BaseClass("SeasonAllianceWarTimeSetCtrl", UIBaseCtrl)

function SeasonAllianceWarTimeSetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonAllianceWarTimeSetView)
end

return SeasonAllianceWarTimeSetCtrl
