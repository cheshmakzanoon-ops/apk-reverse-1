local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local CrazyRockSettleData = require("DataCenter.ActCrazyRockDataManager.Data.CrazyRockSettleData")
local config = GMPageConfig.New("ActivityDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 500
config.label = "\230\180\187\229\138\168"
config.icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/mjc_huodong_huizong.png"
config:Add({
  name = "[\231\150\175\231\139\130\230\145\135\230\187\154]\230\184\184\231\142\169\230\140\135\229\174\154\230\173\140\230\155\178(\233\159\179\228\185\144\232\138\130)",
  icon = "Assets/Main/Sprites/ItemIcons/lyt_2025yinyuejie_chengbaopifu.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local params = {}
    params.activityId = nil
    params.songId = val
    params.showId = 1
    params.isEditor = true
    params.gamePlayModel = CrazyRockGameMode.Normal
    UIManager:GetInstance():OpenWindow(UIWindowNames.CrazyRockGame, {anim = true}, params)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\230\145\135\230\187\154"
})
config:Add({
  name = "[\231\150\175\231\139\130\230\145\135\230\187\154]\230\184\184\231\142\169\230\140\135\229\174\154\230\173\140\230\155\178(2026\229\133\131\230\151\166)",
  icon = "Assets/Main/Sprites/ItemIcons/lyt_2025yinyuejie_chengbaopifu.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local params = {}
    params.activityId = nil
    params.songId = val
    params.showId = 2
    params.isEditor = true
    params.gamePlayModel = CrazyRockGameMode.Normal
    UIManager:GetInstance():OpenWindow(UIWindowNames.CrazyRockGame, {anim = true}, params)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, tostring(992108), 99999999)
  end,
  contentType = 0,
  btnName = "\230\145\135\230\187\154"
})
config:Add({
  name = "[\231\150\175\231\139\130\230\145\135\230\187\154]\229\129\143\231\167\187\230\160\161\229\135\134",
  icon = "Assets/Main/Sprites/ItemIcons/lyt_2025yinyuejie_chengbaopifu.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 7
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local params = {}
    params.activityId = nil
    params.songId = val
    params.showId = 2
    params.isEditor = true
    params.gamePlayModel = CrazyRockGameMode.Offset
    UIManager:GetInstance():OpenWindow(UIWindowNames.CrazyRockGame, {anim = true}, params)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\230\145\135\230\187\154"
})
config:Add({
  name = "\231\150\175\231\139\130\230\145\135\230\187\154\231\187\147\231\174\151\231\149\140\233\157\162",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_goumaijilu_anniu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    local settleData = CrazyRockSettleData.New()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockGameSettlement, {anim = true}, settleData)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\137\147\229\188\128\228\184\128\228\184\170\229\141\135\229\143\152\229\174\157\231\174\177",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_goumaijilu_anniu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    local data = {
      initQuality = 2,
      uid = "testbox001",
      origin = 1,
      progress = {
        3,
        4,
        4,
        4,
        5
      },
      state = 0,
      uuid = "testbox001",
      group = 1,
      quality = 4
    }
    local msg = {
      data = {data}
    }
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    DataCenter.UpgradeTreasureBoxManager:OnReceiveOneUpgradeTreasureBoxInfo(msg)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\232\129\148\231\155\159\229\175\185\229\134\179\232\129\148\232\181\155\230\174\181\228\189\141\229\177\149\231\164\186",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_vsjin_icon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("0: \229\185\179")
    sb:AppendLine("1: \229\141\135")
    sb:AppendLine("-1: \233\153\141")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 0
  end,
  set = function(val)
  end,
  onClicked = function(params)
    local state = toInt(params)
    local last = SegmentType.Gold
    local cur = SegmentType.Gold
    if 0 < state then
      last = SegmentType.Silver
    elseif state < 0 then
      last = SegmentType.Diamond
    end
    DataCenter.LeagueMatchManager:OnRecvMyMatchInfoResp({
      duelInfo = {
        group = "2_1_1",
        rankType = cur,
        position = 0,
        roundResult = ""
      },
      lastDuelInfo = {
        group = "1_1_1",
        rankType = last,
        position = 2,
        roundResult = ""
      }
    })
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelLeagueGradeStatePop, {anim = false})
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "Dump \230\180\187\229\138\168\229\136\151\232\161\168",
  icon = "Assets/Main/Sprites/UI/UIPersonalArms/cfm_huodong_gerenjunbei_anniu_rili.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\143\130\230\149\176:  \230\180\187\229\138\168 Type")
    sb:AppendLine("\228\188\160 0: \230\137\147\229\141\176\230\137\128\230\156\137\230\180\187\229\138\168")
    sb:AppendLine("\228\184\141\228\184\186 0: \230\137\147\229\141\176\230\140\135\229\174\154 Type \231\154\132\230\180\187\229\138\168")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return 0
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local list = DataCenter.ActivityListDataManager.activityList
    if not table.IsNullOrEmpty(list) then
      local str = ""
      for _, actInfo in pairs(list) do
        if checknumber(val) == 0 or checknumber(val) == actInfo.type then
          str = str .. actInfo:Description() .. "\n"
        end
      end
      Logger.Log(str)
    end
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\184\133\233\153\164\230\150\176\229\134\155\229\164\135\228\186\164\230\141\162\228\187\187\229\138\161\230\156\172\229\156\176\230\160\135\232\174\176",
  icon = "Assets/Main/Sprites/ActivityIcons/cfm_huodong_gerenjunbei_yeqian_tubiao.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function(val)
    CommonUtil.PlayerPrefsSetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_FIRST", 0)
    CommonUtil.PlayerPrefsSetInt("PERSONAL_ARMS_CALENDAR_EXCHANGE_GUIDE", 0)
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsCalendarExchangeRed)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  btnName = "\230\184\133\233\153\164\239\188\129"
})
config:Add({
  name = "\232\180\167\232\189\166\229\188\128\229\144\175\229\191\171\233\128\159\230\142\160\229\164\186",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UILWScience/huochekeji.png",
  get = function()
    return GMUtils.GetBool(GMConst.TruckQuickRobFuncOpen)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.TruckQuickRobFuncOpen, val)
  end
})
config:Add({
  name = "\232\174\190\231\189\174\233\155\183\232\190\190UI\232\161\140\229\134\155\233\128\159\229\186\166",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return CommonUtil.PlayerPrefsGetInt(GMConst.RadarFakeUIMarchSpeed, 3)
  end,
  set = function(val)
    CommonUtil.PlayerPrefsSetInt(GMConst.RadarFakeUIMarchSpeed, checknumber(val))
  end,
  btnName = "\232\174\190\231\189\174",
  contentType = 2
})
config:Add({
  name = "\230\181\139\232\175\149FunctionSeason",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/lt_buzu_duihao.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return "0 1 0"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    val = checkstring(val)
    local strings = string.split(val, " ")
    if table.count(strings) ~= 3 then
      return
    end
    local seasonInfoTemplate = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    local seasonId = seasonInfoTemplate ~= nil and seasonInfoTemplate:GetSeasonId(true) or 0
    local msg = "\229\189\147\229\137\141\231\138\182\230\128\129\239\188\154"
    if 0 < seasonId then
      msg = msg .. "\232\181\155\229\173\163 " .. seasonId .. ","
      if seasonInfoTemplate:InPreviewMode() then
        msg = msg .. " \233\162\132\231\131\173\230\156\159"
        local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(seasonInfoTemplate.nextSeasonPreviewTime // 1000) * 1000
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local duration = math.max(curTime - zeroTime, 0)
        local seasonDay = Mathf.Floor(duration // (1000 * OneDayTime)) + 1
        msg = msg .. ", \231\172\172" .. seasonDay .. "\229\164\169"
      else
        msg = msg .. " \232\181\155\229\173\163\228\184\173"
        local seasonDay = seasonInfoTemplate:GetSeasonDurationDay() + 1
        msg = msg .. ", \231\172\172" .. seasonDay .. "\229\164\169"
      end
    else
      local seasonDay = UITimeManager:GetInstance():GetOpenServerDay()
      msg = msg .. "\230\151\160\232\181\155\229\173\163, \231\172\172" .. seasonDay .. "\229\164\169"
    end
    Logger.Log("\227\128\144SeasonInfo\227\128\145 " .. msg .. "\n" .. seasonInfoTemplate:Description())
    local cell = {}
    cell.season = checknumber(strings[1])
    cell.season_type = checknumber(strings[2])
    cell.season_day = checknumber(strings[3])
    local isOpen = FunctionSeasonUtil.CheckSeasonDayTest(seasonInfoTemplate, cell)
    local seasonType = cell.season_type == 1 and "\232\181\155\229\173\163\228\184\173" or "\233\162\132\231\131\173\230\156\159"
    local result = "\227\128\144\230\181\139\232\175\149\232\190\147\229\133\165\227\128\145 " .. tostring(isOpen) .. "\n" .. msg .. "\n\233\156\128\230\177\130\239\188\154\232\181\155\229\173\163" .. cell.season .. ", " .. seasonType .. ", \231\172\172" .. cell.season_day .. "\229\164\169"
    Logger.Log(result)
    
    local function getCellReq(funcType)
      local funcCell = LocalController:instance():tryGetLine(TableName.LW_FUNCTION_SEASON, funcType)
      local funcSeasonType = checknumber(funcCell.season_type) == 1 and "\232\181\155\229\173\163\228\184\173" or "\233\162\132\231\131\173\230\156\159"
      return "\233\156\128\230\177\130\239\188\154\232\181\155\229\173\163" .. funcCell.season .. ", " .. funcSeasonType .. ", \231\172\172" .. funcCell.season_day .. "\229\164\169"
    end
    
    local funcStr = "\227\128\144\230\181\139\232\175\149\233\133\141\231\189\174\232\161\168\227\128\145\n" .. msg .. "\n"
    if LocalController:instance():hasTable(TableName.LW_FUNCTION_SEASON) then
      funcStr = funcStr .. "\228\184\170\228\186\186\229\134\155\229\164\135\229\136\135\230\141\162\229\138\159\232\131\189, \231\187\147\230\158\156\239\188\154 " .. tostring(FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.PersonalArmsExchange)) .. ", " .. getCellReq(FunctionSeasonUtil.FuncType.PersonalArmsExchange) .. "\n"
      funcStr = funcStr .. "\233\154\144\231\167\152\228\187\187\229\138\161\230\160\135\232\174\176\229\138\159\232\131\189, \231\187\147\230\158\156\239\188\154 " .. tostring(FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.DispatchTaskMark)) .. ", " .. getCellReq(FunctionSeasonUtil.FuncType.DispatchTaskMark) .. "\n"
      funcStr = funcStr .. "\229\149\134\229\186\151\229\191\171\230\141\183, \231\187\147\230\158\156\239\188\154 " .. tostring(FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.ShopAutoMax)) .. ", " .. getCellReq(FunctionSeasonUtil.FuncType.ShopAutoMax) .. "\n"
      funcStr = funcStr .. "\232\180\167\232\189\166\229\191\171\233\128\159\230\142\160\229\164\186, \231\187\147\230\158\156\239\188\154 " .. tostring(FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.TrunkQuickAttack)) .. ", " .. getCellReq(FunctionSeasonUtil.FuncType.TrunkQuickAttack) .. "\n"
      funcStr = funcStr .. "\233\155\183\232\190\190\229\191\171\233\128\159\230\137\167\232\161\140&\228\184\128\233\148\174\233\162\134\229\165\150, \231\187\147\230\158\156\239\188\154 " .. tostring(FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.RadarQuickFinish)) .. ", " .. getCellReq(FunctionSeasonUtil.FuncType.RadarQuickFinish) .. "\n"
    else
      funcStr = funcStr .. "\232\191\153\228\184\170\229\136\134\230\148\175\230\151\160 lw_function_season \233\133\141\231\189\174\232\161\168"
    end
    Logger.Log(funcStr)
  end,
  btnName = "DO\239\188\129"
})
return config
