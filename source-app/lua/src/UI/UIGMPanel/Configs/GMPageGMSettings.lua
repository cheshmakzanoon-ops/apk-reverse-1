local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("GMPageGMSettings")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 1
config.label = "\232\174\190\231\189\174"
config.icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png"
config:Add({
  name = "\230\181\174\231\170\151\231\188\169\230\148\190(80%-200%)",
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon05.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = function()
    UIUtil.ShowTips("\228\185\159\232\174\184\230\130\168\230\155\180\229\186\148\232\175\165\233\133\141\228\184\128\229\137\175\231\156\188\233\149\156...")
  end,
  get = function()
    return GMUtils.GetInt(GMConst.GMBarScale, 100)
  end,
  set = function(val)
    UIUtil.ShowTips(string.format("\231\188\169\230\148\190\229\136\176%s%%", val))
    EventManager:GetInstance():Broadcast(EventId.GM_GMBar_ScaleChanged, val)
    GMUtils.SetInt(GMConst.GMBarScale, val)
  end,
  contentType = 2,
  min = 80,
  max = 200
})
config:Add({
  name = "\233\135\141\231\189\174\230\181\174\231\170\151",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    UIUtil.ShowTips("\231\162\176\229\136\176\229\188\130\229\184\184\230\131\133\229\134\181\230\151\182\229\143\175\228\187\165\233\135\141\231\189\174\228\184\128\228\184\139\228\184\139")
  end,
  onClicked = function()
    GMUtils.SetInt(GMConst.GMBarScale, 100)
    local KEY_POS_X = "GM_Bar_Pos_X"
    local KEY_POS_Y = "GM_Bar_Pos_Y"
    CommonUtil.GlobalPrefsSetInt(KEY_POS_X, 0)
    CommonUtil.GlobalPrefsSetInt(KEY_POS_Y, -400)
    EventManager:GetInstance():Broadcast(EventId.GM_GMBar_Reset)
  end,
  btnName = "\233\135\141\231\189\174"
})
config:Add({
  name = "\229\136\135\230\141\162\233\163\142\230\160\188",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon04.png",
  get = function()
    return GMUtils.GetBool(GMConst.GirlMode, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.GirlMode, val)
    EventManager:GetInstance():Broadcast(EventId.GM_Skin_Changed)
  end
})
return config
