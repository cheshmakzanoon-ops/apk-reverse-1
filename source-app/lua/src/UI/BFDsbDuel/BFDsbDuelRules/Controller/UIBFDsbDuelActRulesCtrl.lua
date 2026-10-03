local UIBFDsbDuelActRulesCtrl = BaseClass("UIBFDsbDuelActRulesCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBFDsbDuelActRules)
end

function UIBFDsbDuelActRulesCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

function UIBFDsbDuelActRulesCtrl:GetRulesData(type)
  local templates = BattlefieldDsbDuelUtils.ActTemplateInfo:GetLWDsbLeagueGuideTemplatesByType(type)
  return templates
end

return UIBFDsbDuelActRulesCtrl
