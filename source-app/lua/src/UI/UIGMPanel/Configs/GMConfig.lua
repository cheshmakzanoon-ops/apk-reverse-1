local GMConfig = {}
GMConfig.Bars = {}
GMConfig.Bars.log = {
  order = 9527,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemLog.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemLog",
  key = GMConst.DebugLocalLogEnable,
  defaultShow = true
}
GMConfig.Bars.perf = {
  order = 5000,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemPerf.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemPerf",
  key = GMConst.ShowPerformanceBar
}
GMConfig.Bars.worldInfo = {
  order = 1000,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemWorldInfo.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemWorldInfo",
  key = GMConst.ShowWorldInfo
}
GMConfig.Bars.happyWatcher = {
  order = 100,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemHappyWatcher.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemHappyWatcher",
  key = GMConst.ShowHappyWatcher
}
GMConfig.Bars.litModeDebug = {
  order = 10,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemOriginLitMode.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemOriginLitMode",
  key = GMConst.ShowLitModeDebug
}
GMConfig.Bars.troopLineDebug = {
  order = 15,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemOriginTroopLine.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemOriginTroopLine",
  key = GMConst.TroopLineDebug
}
GMConfig.Bars.lodDebug = {
  order = 20,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemOriginLod.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemOriginLod",
  key = GMConst.ShowLodDebug
}
GMConfig.Bars.bagMaster = {
  order = 20,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemBagMaster.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemBagMaster",
  key = GMConst.ShowBagMaster
}
GMConfig.Bars.clock = {
  order = 5,
  prefab = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/GMBarItemClock.prefab",
  lua = "UI.UIGMPanel.GMBar.GMBarItemClock",
  key = GMConst.ShowClock
}
GMConfig.Pages = {}

local function _AddPage(page)
  GMConfig.Pages[page.pageName] = page
end

_AddPage(require("UI.UIGMPanel.Configs.GamePageFavoriteConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageGameSettingsConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageBarSupport"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageLegacyConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageDebugWorldDebugConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageActivityConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageBattlefieldConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageSeasonConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPagePerformanceConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageParkourConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageOtherSettingsConfig"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageGMSettings"))
_AddPage(require("UI.UIGMPanel.Configs.GMCustomFunction"))
_AddPage(require("UI.UIGMPanel.Configs.GMPageCitySceneConfig"))
return GMConfig
