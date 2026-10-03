local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local CSGMSwitch = CS.GMSwitch
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("Battlefield")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 1500
config.label = "\230\136\152\229\156\186"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanbao_duikangicon.png"
config:Add({
  name = "\230\151\182\233\151\180\229\176\129\232\163\133\230\181\139\232\175\149",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\130\185\228\186\134\229\144\142\229\142\187\231\156\139log\229\149\138~")
    sb:AppendLine("\231\155\180\230\142\165\230\144\156\228\184\139\232\190\185\231\154\132\229\173\151\231\172\166\228\184\178")
    sb:AppendLine("[SafeLocalOsTime]")
    sb:AppendLine("\230\156\137\233\151\174\233\162\152log\232\161\140\233\152\159\229\175\185\229\186\148\231\154\132\228\188\154\230\156\137\228\184\139\232\190\185\231\154\132\230\150\135\230\156\172")
    sb:AppendLine("got exception")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    local UITimeDSTTest = require("Framework.UI.Time.UITimeDSTTest")
    UITimeDSTTest.Run()
  end,
  btnName = "\232\175\149\232\175\149\239\188\159"
})
config:Add({
  name = "\232\190\147\229\135\186\232\175\166\230\131\133",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  tips = function()
    UIUtil.ShowTips("\232\174\169\230\136\145\231\158\133\231\158\133\228\189\160\230\152\175\228\184\170\229\149\165~")
  end,
  onClicked = function()
    local sb = StringBuilder.New()
    sb:AppendLine("BattleFieldUtils:")
    sb:AppendLine(BattleFieldUtil.Description())
    sb:AppendLine()
    sb:AppendLine("Dsb:")
    sb:AppendLine(BattlefieldDsbDuelUtils.Description())
    UIUtil.ShowDetail(sb:ToString(), "\230\136\152\229\156\186\228\191\161\230\129\175", nil, true, true)
  end,
  btnName = "\231\158\133\231\158\133"
})
config:Add({
  name = "\230\181\139\232\175\149\229\138\160\232\189\189\230\136\152\229\156\186",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/common_cfm_anniu_fanhui.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\130\185\229\135\187\229\144\142\230\151\160\232\132\145\232\191\155\229\133\165\230\136\152\229\156\186\239\188\136\230\151\160\232\174\186\230\152\175\229\144\166\229\173\152\229\156\168\230\136\152\229\156\186\239\188\137")
    sb:AppendLine("\229\165\189\231\178\151\230\154\180\229\147\166\239\188\129")
    sb:AppendLine("\228\189\134\230\152\175\228\186\186\229\174\182\229\165\189\229\150\156\230\172\162~>_<")
    sb:AppendLine("")
    sb:AppendLine("\230\136\152\229\156\186\231\188\150\229\143\183\239\188\154")
    sb:AppendLine("1\239\188\154\230\178\153\230\188\160")
    sb:AppendLine("2\239\188\154\229\134\172\230\151\165")
    sb:AppendLine("3\239\188\154\229\179\161\232\176\183")
    sb:AppendLine("4\239\188\154\230\178\153\230\188\160\229\164\167\228\185\177\230\150\151")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return BattleFieldType.WinterStorm
  end,
  set = function(val)
  end,
  onClicked = function(val)
    BattleFieldUtil.DebugEnterBattlefield(val)
  end,
  btnName = "\230\136\145\232\191\155",
  contentType = 2,
  min = 1,
  max = 4
})
config:Add({
  name = "GM\231\155\180\230\142\165\232\191\155\229\133\165\230\136\152\229\156\186",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_saijikaifa_xuyaokangxing_icon.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\130\185\229\135\187\229\144\142\230\151\160\232\132\145\232\191\155\229\133\165\229\164\167\228\185\177\230\150\151")
    sb:AppendLine("\229\165\189\231\178\151\230\154\180\229\147\166\239\188\129")
    sb:AppendLine("\228\189\134\230\152\175\228\186\186\229\174\182\229\165\189\229\150\156\230\172\162~>_<")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 4
  end,
  set = function(val)
  end,
  onClicked = function(val)
    GMUtils.Close()
    BattleFieldUtil.GMEnterBattlefield(4)
  end,
  btnName = "\230\136\145\232\191\155",
  contentType = 2,
  min = 1,
  max = 4
})
config:Add({
  name = "\230\137\147\229\188\128\230\136\152\228\186\137\228\184\173\229\191\131",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanbao_duikangicon.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\136\152\228\186\137\228\184\173\229\191\131\229\164\170tm\233\154\190\230\137\190\228\186\134...")
    sb:AppendLine(">_<")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    GMUtils.Close()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRaceEntrance)
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\230\136\152\229\156\186\228\191\161\229\143\183\230\181\139\232\175\149",
  icon = "Assets/Main/Sprites/UI/UIDesertBattle/Sprites/lrb_putongtishitanhao.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(params)
    BattleFieldUtil.TestAddPing(toInt(params))
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\230\183\187\229\138\160"
})
config:Add({
  name = "\230\184\133\231\144\134\230\136\152\229\156\186\228\191\161\229\143\183",
  icon = "Assets/Main/Sprites/UI/UIDesertBattle/Sprites/lrb_putongtishitanhao.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function()
    BattleFieldUtil.TestCleanPing()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\230\184\133\231\144\134"
})
config:Add({
  name = "\230\178\153\230\188\160S0\231\187\147\231\174\151\230\181\139\232\175\149",
  icon = "Assets/Main/Sprites/ActivityIcons/zyf_shamofengbao_huodong_icon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "3,10|1,5"
  end,
  set = function(val)
  end,
  onClicked = function(params)
    DataCenter.ActDragonManager.TEST_PARAM = params
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    DataCenter.ActDragonManager:Test()
  end,
  contentType = 0,
  btnName = "\231\161\174\229\174\154!"
})
config:Add({
  name = "\230\150\176\232\161\128\230\157\161\230\181\139\232\175\149",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanbao_duikangicon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "6000,4000"
  end,
  set = function(val)
  end,
  onClicked = function(params)
    local theWorld = CS.SceneManager.World
    if theWorld == nil or not CS.SceneManager:IsInWorld() then
      UIUtil.ShowTips("\230\178\161\229\156\168\229\164\167\228\184\150\231\149\140\229\145\162\239\188\129\229\133\136\229\142\187\229\164\167\228\184\150\231\149\140\229\144\167\239\188\129")
      return
    end
    local nums = string.string2array_i_oneSep(params, ",")
    local buildingInfo = CS.SceneManager.World:GetPointInfo(LuaEntry.Player:GetMainWorldPos())
    if buildingInfo == nil then
      UIUtil.ShowTips("\230\178\161\230\137\190\229\136\176\232\135\170\229\183\177\228\184\187\229\159\142\229\149\138\239\188\129\229\133\136\230\137\190\230\137\190\229\156\168\229\147\170\229\145\162\239\188\159")
      return
    end
    GMUtils.Close()
    TimerManager:GetInstance():DelayInvoke(function()
      local serverId = LuaEntry.Player:GetCurServerId()
      local pointId = LuaEntry.Player:GetMainWorldPos()
      local startBlood = nums[1] or 6000
      local targetBlood = nums[2] or 4000
      local maxBlood = 8000
      local itemId = BuildingTypes.FUN_BUILD_MAIN
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
      if buildTemplate ~= nil then
        BuildBloodManager:GetInstance():ShowOneBloodEffect(serverId, buildingInfo.uuid, pointId, startBlood, targetBlood, maxBlood, buildTemplate.tileX, buildTemplate.tileY, itemId, true)
      end
    end, 0.5)
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\229\134\172\230\151\165S0\231\187\147\231\174\151",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanbao_duikangicon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "1,10000,433000,1,1,224|214|204|203"
  end,
  set = function(val)
  end,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\187\147\231\174\151\230\149\176\230\141\174\230\142\167\229\136\182")
    sb:AppendLine("1. 1-\232\131\156\229\136\169/\229\133\182\228\187\150\229\164\177\232\180\165")
    sb:AppendLine("2. \231\187\147\231\174\151\229\137\141\229\136\134\230\149\176")
    sb:AppendLine("3. Type420-\230\156\172\229\156\186\231\167\175\229\136\134\229\136\134\230\149\176")
    sb:AppendLine("4. Type421-\230\142\146\229\144\141Id")
    sb:AppendLine("5. Type422-MvpId")
    sb:AppendLine("6. Type423-\230\136\144\229\176\177\229\136\151\232\161\168\239\188\140\239\189\156\229\136\134\229\137\178")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function(params)
    GMUtils.Close()
    local list = string.split(params, ",")
    local isWin = list[1] == "1"
    local info = {
      isWin = isWin,
      battleScore = {
        {
          side = 1,
          score = isWin and 3000000 or 0
        },
        {
          side = 2,
          score = isWin and 0 or 3000000
        }
      },
      mvp = {
        {
          uid = LuaEntry.Player:GetUid(),
          server = LuaEntry.Player:GetSourceServerId(),
          head = "",
          frame = 0,
          level = 35,
          name = LuaEntry.Player:GetName(),
          allianceName = LuaEntry.Player:GetAllianceAbbr(),
          side = 1,
          mvpId = toInt(list[5])
        }
      },
      scoreInfo = {},
      beforeScore = toInt(list[2])
    }
    if list[3] ~= nil then
      table.insert(info.scoreInfo, {
        type = 420,
        param1 = toInt(list[3])
      })
    end
    if list[4] ~= nil then
      table.insert(info.scoreInfo, {
        type = 421,
        param1 = toInt(list[4])
      })
    end
    if list[5] ~= nil then
      table.insert(info.scoreInfo, {
        type = 422,
        param1 = toInt(list[5])
      })
    end
    if list[6] ~= nil then
      local achievements = string.string2array_i_oneSep(list[6] or "", "|")
      info.mvp[1].achievement = achievements
      table.insert(info.scoreInfo, {type = 423, param2 = achievements})
    end
    Logger.Log("[GMPanel] \229\134\172\230\151\165S0\231\187\147\231\174\151\230\181\139\232\175\149 \239\188\154 " .. table.dump(info, nil, 10))
    DataCenter.ActWinterStormManager:HandleResultPush(info)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleResultS0, {anim = false})
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\233\135\145\232\132\137\229\159\142\229\184\130\231\136\134\231\130\184\230\181\129\231\168\139",
  icon = "Assets/Main/Sprites/UI/Landlord/lrb_jinmai_rukou.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\232\167\166\229\143\145\230\140\135\229\174\154\233\135\145\232\132\137\229\159\142\229\184\130\231\154\132\229\174\140\230\149\180\231\136\134\231\130\184\230\181\129\231\168\139")
    sb:AppendLine("\232\190\147\229\133\165\231\130\185\228\189\141\231\180\162\229\188\149 (pointIndex)")
    sb:AppendLine("")
    sb:AppendLine("\232\135\170\229\138\168\230\181\129\231\168\139\239\188\154")
    sb:AppendLine("1. \231\171\139\229\141\179\232\191\155\229\133\165\227\128\144\229\141\179\229\176\134\231\136\134\231\130\184\227\128\145\231\138\182\230\128\129")
    sb:AppendLine("2. \229\128\146\232\174\161\230\151\182\229\144\142\232\135\170\229\138\168\232\191\155\229\133\165\227\128\144\231\136\134\231\130\184\228\184\173\227\128\145")
    sb:AppendLine("3. \231\136\134\231\130\184\231\187\147\230\157\159\229\144\142\232\135\170\229\138\168\230\136\144\228\184\186\227\128\144\229\186\159\229\162\159\227\128\145")
    sb:AppendLine("")
    sb:AppendLine("\230\149\180\228\184\170\230\181\129\231\168\139\231\148\177\231\138\182\230\128\129\230\156\186\232\135\170\229\138\168\230\142\167\229\136\182")
    sb:AppendLine("\230\151\160\233\156\128\229\164\154\230\172\161\231\130\185\229\135\187\239\188\140\228\184\128\233\148\174\229\174\140\230\136\144\239\188\129")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function(params)
    local pointIndex = toInt(params)
    if pointIndex <= 0 then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\156\137\230\149\136\231\154\132\231\130\185\228\189\141\231\180\162\229\188\149\239\188\129")
      return
    end
    local theWorld = CS.SceneManager.World
    if theWorld == nil or not CS.SceneManager:IsInWorld() then
      UIUtil.ShowTips("\230\178\161\229\156\168\229\164\167\228\184\150\231\149\140\239\188\140\232\175\183\229\133\136\232\191\155\229\133\165\229\164\167\228\184\150\231\149\140\239\188\129")
      return
    end
    GMUtils.Close()
    local success = CS.LandlordManager.TriggerCityExplosion(pointIndex)
    if success then
      UIUtil.ShowTips("\231\130\185\228\189\141 " .. pointIndex .. " \231\136\134\231\130\184\230\181\129\231\168\139\229\183\178\229\144\175\229\138\168\239\188\129\n\n\232\175\183\232\167\130\229\175\159\229\159\142\229\184\130\231\138\182\230\128\129\232\135\170\229\138\168\229\143\152\229\140\150")
    else
      UIUtil.ShowTips("\232\167\166\229\143\145\229\164\177\232\180\165\239\188\129\n\n\232\175\183\231\161\174\228\191\157\239\188\154\n1. \231\130\185\228\189\141\231\180\162\229\188\149\230\173\163\231\161\174\n2. \232\175\165\231\130\185\228\189\141\230\152\175\233\135\145\232\132\137\229\159\142\229\184\130")
    end
  end,
  btnName = "\232\167\166\229\143\145\231\136\134\231\130\184",
  contentType = 0
})
config:Add({
  name = "\230\168\161\230\139\159\228\184\173\229\191\131\230\156\141\229\156\176\229\155\190\231\138\182\230\128\129\230\142\168\233\128\129",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/Landlord/lrb_jinmai_rukou.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\168\161\230\139\159\230\156\141\229\138\161\229\153\168\230\142\168\233\128\129 push.update.center.server.map.state")
    sb:AppendLine("")
    sb:AppendLine("\232\190\147\229\133\165\230\160\188\229\188\143\239\188\154\230\156\141\229\138\161\229\153\168ID;\231\138\182\230\128\129\229\128\188")
    sb:AppendLine("\228\190\139\229\166\130\239\188\1548005;1")
    sb:AppendLine("")
    sb:AppendLine("\229\143\130\230\149\176\232\175\180\230\152\142\239\188\154")
    sb:AppendLine("\226\128\162 centerServerId - \228\184\173\229\191\131\230\156\141\229\138\161\229\153\168ID")
    sb:AppendLine("\226\128\162 centerServerState - \228\184\173\229\191\131\230\156\141\231\138\182\230\128\129")
    sb:AppendLine("")
    sb:AppendLine("\231\148\168\228\186\142\230\181\139\232\175\149\230\136\152\229\140\186\230\150\151\229\156\176\228\184\187\228\184\173\229\191\131\230\156\141\229\156\176\229\155\190\231\138\182\230\128\129\230\155\180\230\150\176")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return string.format("8005;1")
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not val or val == "" then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\229\143\130\230\149\176\239\188\129\230\160\188\229\188\143\239\188\154\230\156\141\229\138\161\229\153\168ID;\231\138\182\230\128\129\229\128\188")
      return
    end
    local params = string.split(val, ";")
    if #params ~= 2 then
      UIUtil.ShowTips("\232\190\147\229\133\165\230\160\188\229\188\143\233\148\153\232\175\175\239\188\129\n\230\173\163\231\161\174\230\160\188\229\188\143\239\188\154\230\156\141\229\138\161\229\153\168ID;\231\138\182\230\128\129\229\128\188\n\228\190\139\229\166\130\239\188\1548005;1")
      return
    end
    local centerServerId = tonumber(params[1])
    local centerServerState = tonumber(params[2])
    if not centerServerId or centerServerId <= 0 then
      UIUtil.ShowTips("\230\156\141\229\138\161\229\153\168ID\229\191\133\233\161\187\230\152\175\229\164\167\228\186\1420\231\154\132\230\149\176\229\173\151\239\188\129")
      return
    end
    if not centerServerState then
      UIUtil.ShowTips("\231\138\182\230\128\129\229\128\188\229\191\133\233\161\187\230\152\175\230\149\176\229\173\151\239\188\129")
      return
    end
    local pushData = {centerServerId = centerServerId, centerServerState = centerServerState}
    local SFSNetwork = require("Net.SFSNetwork")
    SFSNetwork.HandleMessage(MsgDefines.PushUpdateCenterServerMapState, pushData)
    UIUtil.ShowTips(string.format("\229\183\178\230\168\161\230\139\159\230\142\168\233\128\129\ncenterServerId=%d\ncenterServerState=%d", centerServerId, centerServerState))
    GMUtils.Close()
  end,
  contentType = 0,
  btnName = "\230\142\168\233\128\129"
})
config:Add({
  name = "\230\181\139\232\175\149\233\135\145\232\132\137\230\150\176\233\151\187",
  icon = "Assets/Main/Sprites/UI/Landlord/zxl_jinmai_tixing.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\180\187\229\138\168UI\231\172\172\228\184\128\228\184\170\233\161\181\231\173\190\233\187\152\232\174\164\230\152\190\231\164\186\230\150\176\233\151\187")
    sb:AppendLine("\229\143\130\230\149\176\229\143\170\230\156\1371\230\136\150\232\128\1332,\229\136\134\229\136\171\229\175\185\229\186\148\233\162\132\229\145\138\229\146\140\229\136\134\231\187\132\231\154\132\230\150\176\233\151\187")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    DataCenter.LandlordMgr.TEST_LL_NEWS = Mathf.Clamp(toInt(val), 1, 2)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILandlordMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    GMUtils.Close()
  end,
  contentType = 0,
  btnName = "Go"
})
config:Add({
  name = "\230\181\139\232\175\149\233\135\145\232\132\137\233\130\128\232\175\183",
  icon = "Assets/Main/Sprites/UI/Landlord/zxl_jinmai_tixing.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("1\230\152\175\233\130\128\232\175\183\239\188\140\229\144\166\229\136\153\230\152\175\232\162\171\233\130\128\232\175\183")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local info = {
      sInfo = DataCenter.LandlordMgr:GetMyServerInfo(),
      isInvite = toInt(val) == 1
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLGroupInvitation, {anim = true}, info)
    GMUtils.Close()
  end,
  contentType = 0,
  btnName = "\233\130\128\232\175\183"
})
config:Add({
  name = "\230\181\139\232\175\149\233\135\145\232\132\137city\233\128\154\231\159\165",
  icon = "Assets/Main/Sprites/UI/Landlord/zxl_jinmai_tixing.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\228\184\173\229\191\131\230\156\141\230\136\152\229\156\186UI\230\152\190\231\164\186\229\159\142\229\184\130\233\128\154\231\159\165")
    sb:AppendLine("\229\159\142\229\184\130id,\233\152\181\232\144\165,\231\153\190\229\136\134\230\175\148")
    sb:AppendLine("\233\152\181\232\144\1651\229\156\176\228\184\187\227\128\1292\229\134\156\230\176\145")
    sb:AppendLine("\231\153\190\229\136\134\230\175\1480-100")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return "995,1,100"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local list = string.string2array_num_oneSep(val, ",")
    GMUtils.Close()
    DataCenter.LandlordMgr:HandleBattleCityNotice({
      cityId = list[1] or 995,
      campId = list[2] or 1,
      progress = list[3] or 100
    })
  end,
  contentType = 0,
  btnName = "Go"
})
config:Add({
  name = "\230\137\147\229\188\128\230\181\139\232\175\149\231\137\136\229\134\172\230\151\165\230\136\152\229\156\186-\228\188\152\229\140\150\231\137\136",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/sj_shengdan_dengqiu.png",
  tips = function()
  end,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    DataCenter.ActWinterStormManager:GetFakeMatchPushInfo()
    local currentTime = UITimeManager:GetInstance():GetSocketTime()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormMatching)
    CS.GameFramework.Log.Warning(string.format("\231\187\159\232\174\161UIWinterStormMatching\230\182\136\232\128\151\231\148\168\230\151\182\239\188\154%s", UITimeManager:GetInstance():GetSocketTime() - currentTime))
  end,
  btnName = "open"
})
config:Add({
  name = "\230\137\147\229\188\128\230\181\139\232\175\149\231\137\136\229\134\172\230\151\165\230\136\152\229\156\186-\229\135\134\229\164\135 \229\136\183\230\150\176\231\149\140\233\157\162",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/sj_shengdan_dengqiu.png",
  tips = function()
  end,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    DataCenter.ActWinterStormManager:GetFakeMatchPushInfo(true)
    EventManager:GetInstance():Broadcast(EventId.WinterStormMatchRefresh)
  end,
  btnName = "\229\136\183\230\150\176"
})
config:Add({
  name = "\229\133\179\233\151\173\230\181\139\232\175\149\231\137\136\229\134\172\230\151\165\230\136\152\229\156\186",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/sj_shengdan_dengqiu.png",
  tips = function()
  end,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormMatching)
  end,
  btnName = "close"
})
config:Add({
  name = "\229\188\128\229\167\139\230\136\152\229\156\186\233\135\135\230\160\183",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_time.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\232\190\147\229\133\165\230\136\152\229\156\186\229\144\141\231\167\176\239\188\140\229\188\128\229\167\139\230\136\152\229\156\186\230\128\167\232\131\189\233\135\135\230\160\183")
    sb:AppendLine("\230\136\152\229\156\186\229\144\141\231\167\176\229\166\130\239\188\154winterstorm, desert, dsb_duel, meteorite")
    sb:AppendLine("\230\175\143\229\136\134\233\146\159\228\188\154\232\135\170\229\138\168\230\137\147\229\141\176\228\184\128\230\172\161\233\135\135\230\160\183\230\149\176\230\141\174")
    sb:AppendLine("\231\187\147\230\157\159\230\151\182\231\130\185\229\135\187\"\231\187\147\230\157\159\230\136\152\229\156\186\233\135\135\230\160\183\"\230\140\137\233\146\174")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return "winterstorm"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\136\152\229\156\186\229\144\141\231\167\176")
      return
    end
    CS.WorldScene.BeginBattlefieldSample(val)
    UIUtil.ShowTips(string.format("\229\188\128\229\167\139\233\135\135\230\160\183: %s", val))
  end,
  contentType = 0,
  btnName = "\229\188\128\229\167\139"
})
config:Add({
  name = "\231\187\147\230\157\159\230\136\152\229\156\186\233\135\135\230\160\183",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_time.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\187\147\230\157\159\229\189\147\229\137\141\230\136\152\229\156\186\230\128\167\232\131\189\233\135\135\230\160\183")
    sb:AppendLine("\228\188\154\230\137\147\229\141\176\230\156\128\229\144\142\228\184\128\230\172\161\233\135\135\230\160\183\230\138\165\229\145\138")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    CS.WorldScene.EndBattlefieldSample()
    UIUtil.ShowTips("\231\187\147\230\157\159\233\135\135\230\160\183")
  end,
  btnName = "\231\187\147\230\157\159"
})
config:Add()
config:Add()
config:Add()
return config
