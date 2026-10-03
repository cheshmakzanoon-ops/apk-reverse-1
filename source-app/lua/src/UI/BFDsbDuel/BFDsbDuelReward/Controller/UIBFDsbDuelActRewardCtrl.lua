local UIBFDsbDuelActRewardCtrl = BaseClass("UIBFDsbDuelActRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActRewardView)
end

function UIBFDsbDuelActRewardCtrl:GetTabs(battleFieldType)
  local tabs = {}
  table.insert(tabs, {
    name = "YiBianJinQu_battle_detail_tips_1",
    prefab = UIAssets.UIActDsbDuelRewardSheetPersonalPt,
    lua = "UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetPersonalPt"
  })
  table.insert(tabs, {
    name = "dsb_duel_interface_1069",
    prefab = UIAssets.UIActDsbDuelRewardSheetPersonal,
    lua = "UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetPersonal"
  })
  table.insert(tabs, {
    name = "YiBianJinQu_reward_tips_2",
    prefab = UIAssets.UIActDsbDuelRewardSheetWinner,
    lua = "UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetWinner"
  })
  return tabs
end

UIBFDsbDuelActRewardCtrl.CloseSelf = CloseSelf
return UIBFDsbDuelActRewardCtrl
