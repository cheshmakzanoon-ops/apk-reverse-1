local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("CitySceneDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.label = "\228\184\187\229\159\142"
config.icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_daben.png"
config:Add({
  name = "\230\152\190\233\154\144\228\184\187\229\159\142Tile",
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_tank.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  get = function()
    local show = false
    if DataCenter.CityZoneMgr and DataCenter.CityZoneMgr.debugMgr then
      show = DataCenter.CityZoneMgr.debugMgr.ShowTile
    end
    return show
  end,
  set = function(val)
    if DataCenter.CityZoneMgr then
      UIUtil.ShowTips(val and "\229\188\128\229\144\175" or "\229\133\179\233\151\173")
      DataCenter.CityZoneMgr:ShowTileGrid(val)
    end
  end
})
config:Add({
  name = "\232\174\190\231\189\174Zone\232\167\163\233\148\129\230\149\176\233\135\143",
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_tank.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  get = function()
    return DataCenter.GMManager.cityZoneDebugNum or 0
  end,
  set = function(val)
    if DataCenter.CityZoneMgr then
      val = tonumber(val)
      UIUtil.ShowTips("\232\174\190\231\189\174Zone\232\167\163\233\148\129\230\149\176\233\135\143\228\184\186" .. val)
      DataCenter.GMManager.cityZoneDebugNum = val
      DataCenter.CityZoneMgr:DebugRefreshCityZone(val)
    end
  end
})
return config
