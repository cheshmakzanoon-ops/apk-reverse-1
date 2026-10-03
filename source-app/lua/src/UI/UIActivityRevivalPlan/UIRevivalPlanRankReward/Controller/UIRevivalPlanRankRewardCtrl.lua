local UIRevivalPlanRankRewardCtrl = BaseClass("UIRevivalPlanRankRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIRevivalPlanRankReward, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UIRevivalPlanRankRewardCtrl.CloseSelf = CloseSelf
return UIRevivalPlanRankRewardCtrl
