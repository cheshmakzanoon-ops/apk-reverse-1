local UIActEpidemicRewardCtrl = BaseClass("UIActEpidemicRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicRewardView)
end

function UIActEpidemicRewardCtrl:GetTabs()
  local tabs = {}
  table.insert(tabs, {
    name = "YiBianJinQu_reward_tips_12",
    prefab = UIAssets.UIActEpidemicRewardSheetRank,
    lua = "UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetRank"
  })
  table.insert(tabs, {
    name = "YiBianJinQu_battle_detail_tips_1",
    prefab = UIAssets.UIActEpidemicRewardSheetPersonalPt,
    lua = "UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetPersonalPt"
  })
  table.insert(tabs, {
    name = "YiBianJinQu_reward_tips_2",
    prefab = UIAssets.UIActEpidemicRewardSheetWinner,
    lua = "UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetWinner"
  })
  return tabs
end

UIActEpidemicRewardCtrl.CloseSelf = CloseSelf
return UIActEpidemicRewardCtrl
