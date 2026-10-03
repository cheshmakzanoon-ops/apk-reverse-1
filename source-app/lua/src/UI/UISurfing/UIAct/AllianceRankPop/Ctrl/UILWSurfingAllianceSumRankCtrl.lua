local UILWSurfingAllianceSumRankCtrl = BaseClass("UILWSurfingAllianceSumRankCtrl", UIBaseCtrl)

function UILWSurfingAllianceSumRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingAllianceSumRankView)
end

return UILWSurfingAllianceSumRankCtrl
