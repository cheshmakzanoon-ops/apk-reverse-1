local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")

local function getIcon()
  return GMUtils.GetSkinPath().icon
end

local config = GMPageConfig.New("BarSupport")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 5000
config.label = "\230\181\174\231\170\151"
config.iconGet = getIcon
config:Add({
  name = "\230\152\190\231\164\186\230\181\174\231\170\151",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  iconGet = getIcon,
  get = function()
    return GMUtils.GetBool(GMConst.ShowGMBar, true)
  end,
  set = function(val)
    if not val then
      UIUtil.ShowTips("\229\134\141\232\167\129")
    end
    GMUtils.SetBool(GMConst.ShowGMBar, val)
    EventManager:GetInstance():Broadcast(EventId.GM_GMBarShowStateChanged)
  end
})
config:Add({
  name = "\229\177\143\230\152\190\230\151\165\229\191\151",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/icon_jisuanji.png",
  get = function()
    return GMUtils.GetBool(GMConst.DebugLocalLogEnable)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugLocalLogEnable, val)
    if val then
      local logLevel = GMUtils.GetInt(GMConst.DebugLocalLogLevel, 3)
      GMUtils.SetInt(GMConst.DebugLocalLogLevel, logLevel)
      GMUtils.SetIntToCS(GMConst.DebugLocalLogLevel, logLevel)
    end
    if not val then
      DataCenter.GMManager:UpdateLogCount(0, 0)
    end
  end
})
config:Add({
  name = "\228\184\150\231\149\140\228\191\161\230\129\175",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon08.png",
  tips = function()
    UIUtil.ShowTips("\232\191\155\229\133\165\229\164\167\228\184\150\231\149\140\231\148\159\230\149\136")
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ShowWorldInfo, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowWorldInfo, val)
  end
})
config:Add({
  name = "\230\136\145\231\136\177\231\156\139\231\131\173\233\151\185",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/zyf_daojv_biaoqing_ganenjie.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\228\188\154\232\135\170\229\138\168\231\156\139\231\131\173\233\151\185")
    sb:AppendLine("")
    sb:AppendLine("\230\178\161\228\186\186\228\184\141\231\136\177\231\156\139\231\131\173\233\151\185\229\144\167...")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ShowHappyWatcher, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowHappyWatcher, val)
  end
})
config:Add({
  name = "\230\128\167\232\131\189\230\140\135\230\160\135",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon01.png",
  get = function()
    return GMUtils.GetBool(GMConst.ShowPerformanceBar, false)
  end,
  set = function(val)
    return GMUtils.SetBool(GMConst.ShowPerformanceBar, val)
  end
})
config:Add({
  name = "\232\161\140\229\134\155\231\186\191\232\176\131\232\175\149",
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_liwu_paoche.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\229\144\137\229\167\134\231\136\184\228\184\138\228\188\154\230\152\190\231\164\186\232\161\140\229\134\155\231\186\191\232\176\131\232\175\149\232\143\156\229\141\149")
    sb:AppendLine("\228\189\160\228\184\141\229\139\190\233\128\137\230\128\142\228\185\136\228\188\154\231\159\165\233\129\147\230\136\145\231\154\132\230\149\133\228\186\139\239\188\159")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.TroopLineDebug, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.TroopLineDebug, val)
    UIUtil.ShowTips(val and "\230\152\190\231\164\186\232\161\140\229\134\155\232\176\131\232\175\149\232\143\156\229\141\149" or "\228\184\141\230\152\190\231\164\186\232\161\140\229\134\155\232\176\131\232\175\149\232\143\156\229\141\149")
  end
})
config:Add({
  name = "\230\152\175\229\144\166\230\152\190\231\164\186LOD\232\176\131\232\175\149",
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_liwu_paoche.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\229\144\137\229\167\134\231\136\184\228\184\138\228\188\154\230\152\190\231\164\186LOD\232\176\131\232\175\149\232\143\156\229\141\149")
    sb:AppendLine("\228\189\160\228\184\141\229\139\190\233\128\137\230\128\142\228\185\136\228\188\154\231\159\165\233\129\147\230\136\145\231\154\132\230\149\133\228\186\139\239\188\159")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ShowLodDebug, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowLodDebug, val)
    UIUtil.ShowTips(val and "\230\152\190\231\164\186LOD\232\176\131\232\175\149\232\143\156\229\141\149" or "\228\184\141\230\152\190\231\164\186LOD\232\176\131\232\175\149\232\143\156\229\141\149")
  end
})
config:Add({
  name = "\231\174\128\229\140\150\230\168\161\229\188\143\232\176\131\232\175\149",
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\229\144\137\229\167\134\231\136\184\228\184\138\228\188\154\230\152\190\231\164\186\230\158\129\231\174\128\230\168\161\229\188\143\231\154\132\232\176\131\232\175\149\232\143\156\229\141\149")
    sb:AppendLine("\228\189\160\228\184\141\229\139\190\233\128\137\230\128\142\228\185\136\228\188\154\231\159\165\233\129\147\230\136\145\231\154\132\230\149\133\228\186\139\239\188\159")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ShowLitModeDebug, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowLitModeDebug, val)
    UIUtil.ShowTips(val and "\230\152\190\231\164\186\230\158\129\231\174\128\230\168\161\229\188\143\232\176\131\232\175\149\232\143\156\229\141\149" or "\228\184\141\230\152\190\231\164\186\230\158\129\231\174\128\230\168\161\229\188\143\232\176\131\232\175\149\232\143\156\229\141\149")
  end
})
config:Add({
  name = "\232\131\140\229\140\133\229\191\171\230\141\183\229\183\165\229\133\183",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_beibao.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\232\131\140\229\140\133\229\191\171\230\141\183\229\183\165\229\133\183]")
    sb:AppendLine("[GM\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\188\128\229\144\175\229\144\142\229\143\175\228\187\165\229\156\168\232\131\140\229\140\133\231\149\140\233\157\162\229\191\171\230\141\183\230\183\187\229\138\160\233\129\147\229\133\183\229\145\162..")
    sb:AppendLine()
    sb:AppendLine("\240\159\142\181\240\159\142\181\240\159\142\181        \n\227\128\138\228\189\160\231\154\132\232\131\140\229\140\133\227\128\139\n\228\184\128\228\185\157\228\185\157\228\186\148\229\185\180\n\230\136\145\228\187\172\229\156\168\230\156\186\229\156\186\231\154\132\232\189\166\231\171\153\n\228\189\160\229\128\159\230\136\145\n\232\128\140\230\136\145\228\184\141\230\131\179\229\189\146\232\191\152\n\233\130\163\228\184\170\232\131\140\229\140\133\232\189\189\230\187\161\231\186\170\229\191\181\229\147\129\229\146\140\230\130\163\233\154\190\n\232\191\152\230\156\137\230\145\169\230\147\166\231\149\153\228\184\139\230\157\165\231\154\132\229\155\190\230\161\136\n\228\189\160\231\154\132\232\131\140\229\140\133\n\232\131\140\229\136\176\231\142\176\229\156\168\232\191\152\230\178\161\231\131\130\n\229\141\180\230\136\144\228\184\186\230\136\145\232\186\171\228\189\147\229\143\166\228\184\128\229\141\138\n\229\141\131\233\135\145\228\184\141\230\141\162\n\229\174\131\229\183\178\231\134\159\230\130\137\230\136\145\231\154\132\230\177\151\n\229\174\131\230\152\175\230\136\145\232\130\169\232\134\128\228\184\138\231\154\132\230\140\135\231\142\175\n\232\131\140\228\186\134\229\133\173\229\185\180\229\141\138\n\230\136\145\230\175\143\228\184\128\229\164\169\233\153\170\229\174\131\228\184\138\231\143\173\n\228\189\160\229\128\159\230\136\145\n\230\136\145\229\176\177\228\184\186\228\189\160\228\191\157\231\174\161\n\230\136\145\231\154\132\230\156\139\229\143\139\233\131\189\232\175\180\229\174\131\230\151\167\229\190\151\229\190\136\229\165\189\231\156\139\n\233\129\151\230\134\190\230\152\175\229\174\131\229\183\178\228\184\142\228\189\160\230\151\160\229\133\179\n\228\189\160\231\154\132\232\131\140\229\140\133\n\232\174\169\230\136\145\232\181\176\229\190\151\229\165\189\231\188\147\230\133\162\n\231\187\136\230\156\137\228\184\128\229\164\169\233\153\170\231\157\128\230\136\145\232\133\144\231\131\130\n\228\189\160\231\154\132\232\131\140\229\140\133\n\229\175\185\230\136\145\230\178\137\233\135\141\231\154\132\229\174\161\229\136\164\n\229\128\159\228\186\134\228\184\156\232\165\191\228\184\186\228\187\128\228\185\136\228\184\141\232\191\152\n\228\189\160\231\154\132\232\131\140\229\140\133\232\174\169\230\136\145\232\181\176\229\190\151\229\165\189\231\188\147\230\133\162\n\231\187\136\230\156\137\228\184\128\229\164\169\233\153\170\231\157\128\230\136\145\232\133\144\231\131\130\n\228\189\160\231\154\132\232\131\140\229\140\133\229\175\185\230\136\145\230\178\137\233\135\141\231\154\132\229\174\161\229\136\164\n\229\128\159\228\186\134\228\184\156\232\165\191\228\184\186\228\187\128\228\185\136\228\184\141\232\191\152\n\229\128\159\228\186\134\228\184\156\232\165\191\228\184\186\228\187\128\228\185\136\228\184\141\232\191\152")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ShowBagMaster, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowBagMaster, val)
    UIUtil.ShowTips(val and "\229\144\175\229\138\168 \232\131\140\229\140\133\229\191\171\230\141\183\229\183\165\229\133\183" or "\229\133\179\233\151\173 \232\131\140\229\140\133\229\191\171\230\141\183\229\183\165\229\133\183")
  end
})
config:Add({
  name = "\230\151\182\233\151\180\232\176\131\232\175\149\229\183\165\229\133\183",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_shijian_icon.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  get = function()
    return GMUtils.GetBool(GMConst.ShowClock, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowClock, val)
    UIUtil.ShowTips(val and "\230\152\190\231\164\186\230\151\182\233\151\180\232\176\131\232\175\149\229\183\165\229\133\183" or "\229\133\179\233\151\173\230\151\182\233\151\180\232\176\131\232\175\149\229\183\165\229\133\183")
  end
})
return config
