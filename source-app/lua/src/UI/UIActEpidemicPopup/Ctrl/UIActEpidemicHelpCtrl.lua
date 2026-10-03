local UIActEpidemicHelpCtrl = BaseClass("UIActEpidemicHelpCtrl", UIBaseCtrl)

function UIActEpidemicHelpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicHelpView)
end

function UIActEpidemicHelpCtrl:GetItemRendererConfig(type)
  local config = {}
  if type == 1 then
    config.asset = UIAssets.DesertBattleRuleNormalCellForHelp
    config.lua = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesEpidemicNormalCell")
    config.height = 600
    config.title = "458129"
  elseif type == 2 then
    config.asset = UIAssets.DesertBattleRuleBuildCellForHelp
    config.lua = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesBuildItemCell")
    config.height = 600
    config.title = "458130"
  elseif type == 3 then
    config.title = "458131"
  elseif type == 4 then
    config.asset = UIAssets.DesertBattleRuleNormalCellForHelp
    config.lua = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesEpidemicNormalCell")
    config.height = 600
    config.title = "458132"
  elseif type == 5 then
    config.asset = UIAssets.DesertBattleRuleSkillCellForHelp
    config.lua = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesEpidemicSkillCell")
    config.height = 650
    config.title = "150001"
  end
  return config
end

return UIActEpidemicHelpCtrl
