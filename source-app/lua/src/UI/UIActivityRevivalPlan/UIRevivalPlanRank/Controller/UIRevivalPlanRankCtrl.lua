local UIRevivalPlanRankCtrl = BaseClass("UIRevivalPlanRankCtrl", UIBaseCtrl)

function UIRevivalPlanRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRevivalPlanRank)
end

return UIRevivalPlanRankCtrl
