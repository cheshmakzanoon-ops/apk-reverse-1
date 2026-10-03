local LWUIBagResourceOverviewCtrl = BaseClass("LWUIBagResourceOverviewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIBagResourceOverviewCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIBagResourceOverview)
end

function LWUIBagResourceOverviewCtrl:SetSpeedUpTimeShowType(timeShowType)
  self.timeShowType = timeShowType
end

function LWUIBagResourceOverviewCtrl:GetSpeedUpTimeShowType()
  return self.timeShowType
end

return LWUIBagResourceOverviewCtrl
