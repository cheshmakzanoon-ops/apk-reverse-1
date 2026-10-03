local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local Localization = CS.GameEntry.Localization
local config = GMPageConfig.New("WorldDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 500
config.label = "\229\164\167\228\184\150\231\149\140"
config.icon = "Assets/Main/Sprites/UI/GMPanel/gmIconWorldMap.png"
config:Add({
  name = "\229\164\167\229\174\182\228\184\128\228\184\170\230\160\183\229\132\191",
  iconGet = function()
    local skinId = GMUtils.GetInt(GMConst.DebugBuildSkinID, 0)
    local skinTemp = 0 < skinId and DecorationUtil.GetDecorationBaseInfoById(skinId)
    if skinTemp then
      return skinTemp.icon
    else
      return "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_chengshimaoyi_diushi.png"
    end
  end,
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local skinId = GMUtils.GetInt(GMConst.DebugBuildSkinID, 0)
    local skinEffId = GMUtils.GetInt(GMConst.DebugBuildSkinEffId, 0)
    local skinTemp = 0 < skinId and DecorationUtil.GetDecorationBaseInfoById(skinId)
    local effTemp = 0 < skinEffId and DecorationUtil.GetDecorationBaseInfoById(skinEffId)
    local sb = StringBuilder.New()
    if skinTemp then
      sb:AppendLineFormat("\230\155\191\230\141\162\231\154\174\232\130\164: %s", Localization:GetString(skinTemp.nameId))
    else
      sb:AppendLineFormat("\230\155\191\230\141\162\231\154\174\232\130\164: -")
    end
    if effTemp then
      sb:AppendLineFormat("\230\155\191\230\141\162\231\137\185\230\149\136: %s", Localization:GetString(effTemp.nameId))
    else
      sb:AppendLineFormat("\230\155\191\230\141\162\231\137\185\230\149\136: -")
    end
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    local skinId = GMUtils.GetInt(GMConst.DebugBuildSkinID, 0)
    local skinEffId = GMUtils.GetInt(GMConst.DebugBuildSkinEffId, 0)
    return skinId ~= 0 or skinEffId ~= 0
  end,
  set = function(val)
    if not GMUtils.CheckLogin() then
      UIUtil.ShowTips("\232\175\183\230\130\168\229\133\136tm\231\153\187\229\189\149\230\184\184\230\136\143...")
      return
    end
    if not val then
      GMUtils.SetInt(GMConst.DebugBuildSkinID, 0)
      GMUtils.SetInt(GMConst.DebugBuildSkinEffId, 0)
      EventManager:GetInstance():Broadcast(EventId.GM_Page_Rebuild)
      UIUtil.ShowTips("\229\159\186\229\156\176\231\137\185\230\149\136\232\176\131\232\175\149\229\183\178\233\135\141\231\189\174\229\150\189~")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true})
      GMUtils.Close()
    end
  end
})
config:Add({
  name = "\229\164\167\229\174\182\233\154\143\228\190\191\228\184\128\231\130\185",
  icon = "Assets/Main/Sprites/UI/UILWAlliance/btn_alliance_random.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\188\128\229\144\175\229\144\142\239\188\140\228\184\150\231\149\140\231\142\169\229\174\182\231\154\132\229\159\186\229\156\176\231\154\174\232\130\164\233\131\189\229\176\134\233\154\143\230\156\186\230\152\190\231\164\186...")
    sb:AppendLine("..\230\136\145\228\184\141\230\152\175\228\184\128\228\184\170\233\154\143\228\190\191\231\154\132\228\186\186...")
    sb:AppendLine("\228\189\134\230\152\175\230\136\145\233\154\143\228\190\191\232\181\183\230\157\165...")
    sb:AppendLine("\229\152\191\229\152\191\229\152\191\240\159\153\130\240\159\153\130...")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugBuildSkinRandom, false)
  end,
  set = function(val)
    if not GMUtils.CheckLogin() then
      UIUtil.ShowTips("\232\175\183\230\130\168\229\133\136tm\231\153\187\229\189\149\230\184\184\230\136\143...")
      return
    end
    if val then
      UIUtil.ShowTips("\229\159\186\229\156\176\231\154\174\232\130\164\230\148\185\228\184\186\239\188\154\233\154\143\230\156\186")
      GMUtils.SetRandomBuildSkins()
      EventManager:GetInstance():Broadcast(EventId.GM_Page_Rebuild)
    else
      UIUtil.ShowTips("\229\159\186\229\156\176\231\154\174\232\130\164\229\143\150\230\182\136\233\154\143\230\156\186")
    end
    GMUtils.SetBool(GMConst.DebugBuildSkinRandom, val)
  end
})
config:Add({
  name = "\232\161\140\229\134\155\230\149\176\230\141\174\230\155\180\230\150\176",
  icon = "Assets/Main/Sprites/ItemIcons/LXY_s5_kafeibei01_icon.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  get = function()
    return GMUtils.GetInt(GMConst.DebugWorldMarchDataHaha, 0) == 1
  end,
  set = function(val)
    if val then
      UIUtil.ShowTips("\229\188\186\229\136\182\229\188\128\229\144\175")
      GMUtils.SetInt(GMConst.DebugWorldMarchDataHaha, 1)
    else
      UIUtil.ShowTips("\229\188\186\229\136\182\229\133\179\233\151\173")
      GMUtils.SetInt(GMConst.DebugWorldMarchDataHaha, -1)
    end
  end
})
config:Add({
  isVisible = function()
    return LuaEntry.DataConfig:CheckSwitch("world_building_optimize_mode")
  end,
  name = "\229\164\167\228\184\150\231\149\140\229\174\158\228\190\139\229\140\150\229\155\190\230\160\135\230\175\148\228\190\139",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = nil,
  get = function()
    return GMUtils.GetInt(GMConst.DebugWorldPointGPUInstanceProp, 100)
  end,
  set = function(val)
    GMUtils.SetInt(GMConst.DebugWorldPointGPUInstanceProp, val)
    UIUtil.ShowTips(string.format("\232\174\190\231\189\174\230\175\148\228\190\139\228\184\186:%s%%", val))
  end,
  icon = "Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png",
  contentType = 2
})
config:Add({
  name = "\229\136\134\228\186\171\230\140\135\229\174\154uuid\231\154\132\232\161\140\229\134\155\239\188\140\230\150\185\228\190\191\232\191\189\232\184\170\230\159\165bug(\230\140\137F7\229\143\175\228\187\165\229\136\134\228\186\171\231\155\184\230\156\186\233\148\129\229\174\154\231\154\132\232\161\140\229\134\155)",
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/zyf_zhujiemian_qipao_fenxiang.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(marchUuid)
    MarchUtil.ShareOneMarch(marchUuid)
  end,
  contentType = 0,
  btnName = "\229\136\134\228\186\171",
  tips = function()
    UIUtil.ShowDetail("\230\140\137F7\229\143\175\228\187\165\231\155\180\230\142\165\229\136\134\228\186\171\231\155\184\230\156\186\233\148\129\229\174\154\231\154\132\232\161\140\229\134\155\239\188\140\228\184\141\233\156\128\232\166\129\232\190\147\229\133\165uuid")
  end
})
config:Add({
  name = "\232\183\168\230\156\141\230\159\165\231\156\139",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_bukeqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 100
  end,
  set = function(val)
  end,
  onClicked = function(serverId)
    local sid = toInt(serverId)
    if sid <= 0 then
      UIUtil.ShowTips("\229\136\171\230\139\191\228\185\177\231\160\129\230\157\165\229\191\189\230\130\160\230\136\145\229\145\128\239\188\129")
    elseif sid == LuaEntry.Player:GetCurServerId() then
      UIUtil.ShowTips("\229\136\171\233\151\185\239\188\129\228\189\160\231\142\176\229\156\168\229\176\177\229\156\168\232\191\153\228\184\170\228\184\150\231\149\140\239\188\129")
    else
      UIUtil.ShowTips("\229\165\189\229\186\183\231\154\132\230\157\165\229\146\175\239\188\129")
      GMUtils.Close()
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos({
        x = 777,
        y = 0,
        z = 777
      }, MoveCityCameraHeight, nil, function()
      end, toInt(serverId))
    end
  end,
  contentType = 0,
  btnName = "\232\174\169\230\136\145\231\156\139\231\156\139!",
  tips = function()
    UIUtil.ShowDetail("\232\190\147\229\133\165\230\156\141\229\138\161\229\153\168id\239\188\140\229\176\177\229\143\175\228\187\165\229\129\183\231\170\165\228\186\186\229\174\182\231\154\132\230\156\141\229\138\161\229\153\168\232\190\163\239\188\129")
  end
})
config:Add({
  name = "\232\183\168\230\156\141\232\191\129\229\159\142",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "100,1"
  end,
  set = function(val)
  end,
  onClicked = function(serverIdAndType)
    local strs = string.split(serverIdAndType, ",")
    local sid = toInt(strs[1])
    local type = string.IsNullOrEmpty(strs[2]) and MoveCrossServerType.SeasonBattleDesert or toInt(strs[2])
    if sid <= 0 then
      UIUtil.ShowTips("\232\189\172\231\148\159\229\164\177\232\180\165\239\188\129\229\188\130\228\184\150\231\149\140\228\184\141\229\173\152\229\156\168\239\188\129")
    elseif sid == LuaEntry.Player:GetSelfServerId() then
      UIUtil.ShowTips("\229\136\171\233\151\185\239\188\129\228\189\160\231\142\176\229\156\168\229\176\177\229\156\168\232\191\153\228\184\170\228\184\150\231\149\140\239\188\129")
    elseif LuaEntry.Player:GetSourceServerId() == sid then
      UIUtil.ShowTips("\229\155\158\229\174\182\229\146\175\239\188\129")
      CrossServerUtil.BackToSrcServer()
    else
      CrossServerUtil.JumpToServerByServerId(sid, type, 777777)
    end
  end,
  contentType = 0,
  btnName = "\229\142\187\229\188\130\228\184\150\231\149\140!",
  tips = function()
    UIUtil.ShowDetail("\229\166\130\228\189\149\232\189\172\231\148\159\229\142\187\229\188\130\228\184\150\231\149\140\239\188\154\n\232\190\147\229\133\165\229\188\130\228\184\150\231\149\140id\229\146\140\232\189\172\231\148\159\231\144\134\231\148\177\239\188\140\228\187\165\233\128\151\229\143\183\229\136\134\233\154\148\239\188\140\228\190\139\229\166\130\239\188\154100,1\n\232\189\172\231\148\159\231\144\134\231\148\177\229\166\130\228\184\139\239\188\154\n0\239\188\154\229\155\158\229\136\176\229\142\159\230\156\141\239\188\140\n1\239\188\154\232\129\148\231\155\159\229\175\185\229\134\179\232\191\129\229\159\142\239\188\140\n2\239\188\154\232\183\168\230\156\141\231\142\139\229\186\167\232\191\129\229\159\142\239\188\140\n3\239\188\154\232\181\155\229\173\163\232\191\129\229\159\142\239\188\140\n4\239\188\154\233\153\168\233\147\129\232\191\129\229\159\142\239\188\140\n\228\184\186\230\150\185\228\190\191\228\189\191\231\148\168\239\188\140\"0:\229\155\158\229\136\176\229\142\159\230\156\141\" \229\146\140 \"3:\232\181\155\229\173\163\232\191\129\229\159\142\"\228\184\141\233\156\128\232\166\129\232\190\147\229\133\165\231\144\134\231\148\177\239\188\140\229\143\170\232\190\147\229\133\165\230\156\141\229\138\161\229\153\168id\229\141\179\229\143\175", nil, nil, true)
  end
})
config:Add({
  name = "\230\155\191\230\141\162\230\136\152\230\150\151\229\173\144\229\188\185\231\137\185\230\149\136",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\188\128\229\144\175\229\144\142\239\188\140\228\184\150\231\149\140\232\161\140\229\134\155\230\136\152\230\150\151\230\151\182\232\139\177\233\155\132\229\173\144\229\188\185\229\176\134\230\155\191\230\141\162\228\184\186\228\189\160\229\150\156\230\172\162\231\154\132\230\160\183\229\173\144...")
    sb:AppendLine("\226\153\170\226\153\169\226\153\170\226\153\169")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
  end,
  set = function(val)
    if val == 0 then
      GMUtils.SetInt(GMConst.ReplaceWorldBulletId, val)
      EventManager:GetInstance():Broadcast(EventId.GM_Page_Rebuild)
      return
    end
    local template = DataCenter.PveBulletTemplateManager:GetTemplate(val)
    if template then
      UIUtil.ShowTips(string.format("\230\155\191\230\141\162\230\136\144\229\138\159\239\188\129"))
    else
      UIUtil.ShowTips(string.format("\230\155\191\230\141\162\229\164\177\232\180\165\239\188\140\230\137\190\228\184\141\229\136\176id=%s\231\154\132\233\133\141\231\189\174(lw_bullet)", val))
    end
    GMUtils.SetInt(GMConst.ReplaceWorldBulletId, val)
    EventManager:GetInstance():Broadcast(EventId.GM_Page_Rebuild)
  end,
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_shangjinlieren_zidan.png",
  min = 0,
  max = 952700952700,
  contentType = 2
})
config:Add({
  isVisible = function()
    local replacedId = GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
    return 0 < replacedId
  end,
  name = "\230\155\191\230\141\162\229\173\144\229\188\185\231\137\185\230\149\136\232\183\175\229\190\132",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  contentType = 0,
  tips = function()
    local replacedId = GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
    if replacedId <= 0 then
      return
    end
    local template = DataCenter.PveBulletTemplateManager:GetTemplate(replacedId)
    if not template then
      return
    end
    local sb = StringBuilder.New()
    sb:AppendLineFormat("\233\133\141\231\189\174id:%s", replacedId)
    sb:AppendLineFormat("\229\173\144\229\188\185\232\183\175\229\190\132:%s", template.bullet_effect)
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    local replacedId = GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
    if replacedId <= 0 then
      return
    end
    local template = DataCenter.PveBulletTemplateManager:GetTemplate(replacedId)
    if template then
      return template.bullet_effect
    end
  end,
  set = function(val)
    local replacedId = GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
    if replacedId <= 0 then
      UIUtil.ShowTips(string.format("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\233\133\141\231\189\174id"))
      return
    end
    local template = DataCenter.PveBulletTemplateManager:GetTemplate(replacedId)
    if not template then
      UIUtil.ShowTips(string.format("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\233\133\141\231\189\174"))
    end
    template.bullet_effect = val
    UIUtil.ShowTips(string.format("\229\173\144\229\188\185\232\183\175\229\190\132\230\155\191\230\141\162\228\184\186:%s", val))
  end,
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_shangjinlieren_zidan.png"
})
config:Add({
  name = "\229\164\167\228\184\150\231\149\140\231\130\185\228\189\141\232\183\179\232\189\172",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "471058;193"
  end,
  set = function(val)
  end,
  onClicked = function(pointAndServerId)
    local strs = string.split(pointAndServerId, ";")
    local pointId = toInt(strs[1])
    local server = string.IsNullOrEmpty(strs[2]) and 100 or toInt(strs[2])
    if pointId and server then
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, server)
    else
      UIUtil.ShowTips("\232\190\147\229\133\165\230\160\188\229\188\143\230\152\175:  471058;193 !(\229\157\144\230\160\135;\230\156\141\229\138\161\229\153\168)")
    end
  end,
  contentType = 0,
  btnName = "\232\183\179!",
  tips = function()
    UIUtil.ShowDetail("", nil, nil, true)
  end
})
config:Add({
  name = "\230\140\137\229\159\142\229\184\130ID\232\183\179\232\189\172",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "1001"
  end,
  set = function(val)
  end,
  onClicked = function(cityIdStr)
    local cityId = toInt(cityIdStr)
    if not cityId or cityId <= 0 then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\156\137\230\149\136\231\154\132\229\159\142\229\184\130ID")
      return
    end
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    if not cityTemplate then
      UIUtil.ShowTips(string.format("\230\156\170\230\137\190\229\136\176 cityId=%s \231\154\132\229\159\142\229\184\130\233\133\141\231\189\174", cityId))
      return
    end
    local pointId = cityTemplate:GetPointId()
    local serverId = cityTemplate:GetSourceServerId()
    if pointId and serverId and 0 < serverId then
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, serverId)
      GMUtils.Close()
    else
      UIUtil.ShowTips(string.format("\229\159\142\229\184\130 %s \230\151\160\230\179\149\232\142\183\229\143\150\230\156\137\230\149\136\231\154\132\230\156\141\229\138\161\229\153\168\230\136\150\231\130\185\228\189\141", cityId))
    end
  end,
  contentType = 0,
  btnName = "\232\183\179!",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\140\137\229\159\142\229\184\130ID\232\183\179\232\189\172\229\164\167\228\184\150\231\149\140")
    sb:AppendLine("")
    sb:AppendLine("\232\190\147\229\133\165\230\160\188\229\188\143: cityId")
    sb:AppendLine("  cityId: \229\159\142\229\184\130\233\133\141\231\189\174ID")
    sb:AppendLine("")
    sb:AppendLine("\232\135\170\229\138\168\232\142\183\229\143\150\229\159\142\229\184\130\230\137\128\229\177\158\230\156\141\229\138\161\229\153\168\229\146\140\229\157\144\230\160\135")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true)
  end
})
config:Add({
  name = "\231\187\153\228\189\160\231\130\185\233\162\156\232\137\178\231\156\139\231\156\139",
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon04.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "1000,FFFFFF,FFFFFF,FFFFFF"
  end,
  set = function(val)
  end,
  onClicked = function(inputStr)
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
      UIUtil.ShowTips("\232\175\183\229\137\141\229\190\128\229\164\167\228\184\150\231\149\140\229\144\142\229\134\141\232\175\149")
      return
    end
    if not inputStr or inputStr == "" then
      UIUtil.ShowTips("\232\190\147\229\133\165\230\160\188\229\188\143: cityId,innerColor,baseColor,outlineColor\239\188\140\228\190\139\229\166\130: 190,5dadff,408eea,7fd5ff")
      return
    end
    local parts = string.split(inputStr, ",")
    if #parts ~= 4 then
      UIUtil.ShowTips(string.format("\229\143\130\230\149\176\230\149\176\233\135\143\233\148\153\232\175\175\239\188\140\230\156\159\230\156\1554\228\184\170\239\188\140\229\174\158\233\153\133%d\228\184\170", #parts))
      return
    end
    local cityId = toInt(parts[1])
    local innerColor = parts[2]
    local baseColor = parts[3]
    local outlineColor = parts[4]
    if not cityId or cityId <= 0 then
      UIUtil.ShowTips("\229\159\142\229\184\130ID\230\151\160\230\149\136: " .. tostring(parts[1]))
      return
    end
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    if not cityTemplate then
      UIUtil.ShowTips(string.format("\230\156\170\230\137\190\229\136\176 cityId=%s \231\154\132\229\159\142\229\184\130\233\133\141\231\189\174", cityId))
      return
    end
    local success = CS.SceneManager.World:DebugPreviewZoneColor(cityId, innerColor, baseColor, outlineColor)
    if success then
      UIUtil.ShowTips(string.format("\230\159\147\232\137\178\233\162\132\232\167\136\229\183\178\229\186\148\231\148\168: \229\159\142\229\184\130%d", cityId))
    else
      UIUtil.ShowTips(string.format("\230\159\147\232\137\178\233\162\132\232\167\136\229\164\177\232\180\165: \229\159\142\229\184\130%d \230\156\170\230\137\190\229\136\176\229\175\185\229\186\148\230\136\152\229\140\186", cityId))
    end
  end,
  contentType = 0,
  btnName = "\232\174\190\231\189\174",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\136\183\230\150\176\229\164\167\228\184\150\231\149\140\229\156\176\229\157\151\230\159\147\232\137\178")
    sb:AppendLine("\231\148\168\228\186\142\230\159\165\231\156\139\233\130\163\229\149\165")
    sb:AppendLine("\228\190\139\229\166\130:190,5dadff,408eea,7fd5ff")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true)
  end
})
config:Add({
  name = "\231\187\153\230\136\145\231\130\185\233\162\156\232\137\178\231\156\139\231\156\139",
  icon = "Assets/Main/Sprites/UI/UIBuildBubble/zxl_zhujiemian_qipao_sousuo.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "1001"
  end,
  set = function(val)
  end,
  onClicked = function(inputStr)
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
      UIUtil.ShowTips("\232\175\183\229\137\141\229\190\128\229\164\167\228\184\150\231\149\140\229\144\142\229\134\141\232\175\149")
      return
    end
    local cityId = toInt(inputStr)
    if not cityId or cityId <= 0 then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\156\137\230\149\136\231\154\132\229\159\142\229\184\130ID")
      return
    end
    local colorStr = CS.SceneManager.World:DebugGetZoneColorString(cityId)
    if not colorStr or colorStr == "" then
      UIUtil.ShowTips(string.format("\230\156\170\230\137\190\229\136\176\229\159\142\229\184\130%d\231\154\132\233\162\156\232\137\178\228\191\161\230\129\175", cityId))
      return
    end
    CS.UnityEngine.GUIUtility.systemCopyBuffer = colorStr
    UIUtil.ShowTips(string.format("\233\162\156\232\137\178\229\183\178\229\164\141\229\136\182: %s", colorStr))
  end,
  contentType = 0,
  btnName = "\232\142\183\229\143\150",
  tips = function()
    UIUtil.ShowDetail("\232\190\147\229\133\165\229\159\142\229\184\130ID\239\188\140\232\142\183\229\143\150\232\175\165\229\156\176\229\157\151\229\189\147\229\137\141\233\162\156\232\137\178\229\185\182\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191\239\188\140\230\160\188\229\188\143\228\184\142\232\190\147\229\133\165\231\155\184\229\144\140", nil, nil, true)
  end
})
config:Add({
  name = "\231\131\159\232\138\177\233\152\136\229\128\188(\228\184\173\228\189\142\231\148\187\232\180\168)",
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\228\187\133\232\176\131\232\175\149\229\140\133\229\143\175\231\148\168\239\188\154\229\174\158\230\151\182\232\176\131\230\149\180\228\184\173/\228\189\142\230\161\163\231\148\187\232\180\168\228\184\139\232\167\166\229\143\145\231\131\159\232\138\177\231\174\128\229\140\150\231\154\132\230\156\128\229\164\167\229\144\140\229\177\143\230\149\176\233\135\143\233\152\136\229\128\188")
    sb:AppendLine("\233\187\152\232\174\164\229\128\188\228\184\186 10\239\188\140\232\174\190\228\184\186 0 \229\176\134\231\171\139\229\141\179\232\167\166\229\143\145\233\153\144\229\136\182")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return DataCenter.LWFireworkManager:GetFireworkMaxNum(GameQualitySettings.IsLowGearQuality())
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not CS.CommonUtils.IsDebug() then
      UIUtil.ShowTips("\228\187\133\232\176\131\232\175\149\229\140\133\230\148\175\230\140\129\232\176\131\230\149\180\231\131\159\232\138\177\233\152\136\229\128\188")
      return
    end
    local newValue = tonumber(val)
    if not newValue then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\149\176\229\173\151\233\152\136\229\128\188")
      return
    end
    DataCenter.LWFireworkManager:SetFireworkMaxNum(newValue)
    UIUtil.ShowTips(string.format("\231\131\159\232\138\177\233\152\136\229\128\188\229\183\178\232\174\190\228\184\186 %d", DataCenter.LWFireworkManager:GetFireworkMaxNum()))
  end,
  contentType = 3,
  btnName = "\229\186\148\231\148\168"
})
config:Add({
  name = "\229\159\186\229\156\176\231\130\185\232\181\158\229\142\139\229\138\155\230\181\139\232\175\149\239\188\136\229\188\130\230\173\165\239\188\137",
  icon = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_rongyuqiang_dianzan01.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\228\187\133\232\176\131\232\175\149\229\140\133\229\143\175\231\148\168\239\188\154\232\183\179\232\189\172\229\136\176\229\164\167\228\184\150\231\149\140\232\135\170\229\183\177\229\159\186\229\156\176\232\191\155\232\161\140\231\130\185\232\181\158\229\142\139\229\138\155\230\181\139\232\175\149")
    sb:AppendLine("\230\140\129\231\187\1735\231\167\146\239\188\140\229\156\168\229\159\186\229\156\176\232\140\131\229\155\180\229\141\138\229\190\1325\230\160\188\232\140\131\229\155\180\229\134\133\230\175\143\231\167\146\232\135\170\229\138\168\231\130\185\232\181\158\230\140\135\229\174\154\230\149\176\233\135\143\231\154\132\229\159\186\229\156\176\239\188\140\229\188\130\230\173\165\229\185\179\230\187\145\230\152\190\231\164\186\229\164\167\233\135\143\231\130\185\232\181\158\239\188\140\229\185\182\228\184\148\229\176\134UI\229\146\140\230\149\176\230\141\174\228\189\191\231\148\168\229\175\185\232\177\161\230\177\160\228\188\152\229\140\150")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 200
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not CS.CommonUtils.IsDebug() then
      UIUtil.ShowTips("\228\187\133\232\176\131\232\175\149\229\140\133\230\148\175\230\140\129")
      return
    end
    local newValue = tonumber(val)
    if not newValue then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\175\143\231\167\146\231\130\185\232\181\158\230\149\176")
      return
    end
    local selfPointIndex = LuaEntry.Player:GetMainWorldPos()
    local pos = SceneUtils.TileIndexToWorld(selfPointIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      DataCenter.WorldNoticeManager:TestThumbsUp(5, 5, newValue, UIUtil.ShowThumbsUpBroadcastPopUI)
    end, LuaEntry.Player:GetSelfServerId(), 0)
    GMUtils.Close()
  end,
  contentType = 3,
  btnName = "\229\188\128\229\167\139\230\181\139\232\175\149"
})
config:Add({
  name = "\229\159\186\229\156\176\231\130\185\232\181\158\229\142\139\229\138\155\230\181\139\232\175\149\239\188\136\229\144\140\230\173\165\239\188\137",
  icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\228\187\133\232\176\131\232\175\149\229\140\133\229\143\175\231\148\168\239\188\154\232\183\179\232\189\172\229\136\176\229\164\167\228\184\150\231\149\140\232\135\170\229\183\177\229\159\186\229\156\176\232\191\155\232\161\140\231\130\185\232\181\158\229\142\139\229\138\155\230\181\139\232\175\149")
    sb:AppendLine("\230\140\129\231\187\1735\231\167\146\239\188\140\229\156\168\229\159\186\229\156\176\232\140\131\229\155\180\229\141\138\229\190\1325\230\160\188\232\140\131\229\155\180\229\134\133\230\175\143\231\167\146\232\135\170\229\138\168\231\130\185\232\181\158\230\140\135\229\174\154\230\149\176\233\135\143\231\154\132\229\159\186\229\156\176\239\188\140\228\184\141\229\129\154\228\184\187\229\138\168\231\154\132\229\188\130\230\173\165\230\142\146\233\152\159\229\146\140\231\187\132\228\187\182\232\142\183\229\143\150\231\188\147\229\173\152")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 200
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not CS.CommonUtils.IsDebug() then
      UIUtil.ShowTips("\228\187\133\232\176\131\232\175\149\229\140\133\230\148\175\230\140\129")
      return
    end
    local newValue = tonumber(val)
    if not newValue then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\175\143\231\167\146\231\130\185\232\181\158\230\149\176")
      return
    end
    local selfPointIndex = LuaEntry.Player:GetMainWorldPos()
    local pos = SceneUtils.TileIndexToWorld(selfPointIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      DataCenter.WorldNoticeManager:TestThumbsUp(5, 5, newValue, UIUtil.ShowThumbsUpBroadcastPopUINow)
    end, LuaEntry.Player:GetSelfServerId(), 0)
    GMUtils.Close()
  end,
  contentType = 3,
  btnName = "\229\188\128\229\167\139\230\181\139\232\175\149"
})
return config
