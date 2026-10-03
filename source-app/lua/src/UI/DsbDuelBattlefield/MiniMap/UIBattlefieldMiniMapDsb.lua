local base = require("UI.BattleFieldBase.Misc.BattlefieldMiniMap")
local UIBattlefieldMiniMapDsb = BaseClass("UIBattlefieldMiniMapDsb", base)
local Localization = CS.GameEntry.Localization

function UIBattlefieldMiniMapDsb:GetBattlefieldType()
  return BattleFieldType.DsbDuel
end

function UIBattlefieldMiniMapDsb:GetMgr()
  return DataCenter.BattlefieldDsbDuelManager
end

function UIBattlefieldMiniMapDsb:GetAllBuildTemplates()
  local mgr = DataCenter.BattlefieldDsbDuelTemplateManager
  if mgr then
    return mgr:GetAllBuildTemplates()
  end
end

function UIBattlefieldMiniMapDsb:OnMapShowClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelBattleMap)
end

function UIBattlefieldMiniMapDsb:GetDetailPath()
  return LoadPath.LWBattleFieldDsbDuelDetailPath
end

return UIBattlefieldMiniMapDsb
