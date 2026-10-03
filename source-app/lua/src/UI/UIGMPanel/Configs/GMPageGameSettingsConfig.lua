local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

local function reloadGame(showServerList)
  if showServerList then
    CS.UnityEngine.PlayerPrefs.SetInt("RELOAD_DEBUG_SHOW_SERVER_LIST", 1)
  end
  CS.ApplicationLaunch.Instance:ReloadGame()
end

local function reconnectGame()
  CS.GameEntry.Network:SyncPingPong(0)
  CS.GameEntry.Network:Disconnect()
  CS.ApplicationLaunch.Instance:DisconnectRetry()
end

local config = GMPageConfig.New("GameDaddy")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 5000
config.label = "\230\184\184\230\136\143\229\184\184\231\148\168"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhbd_google_icon.png"

local function _getBaseInfo()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("[\232\174\190\229\164\135ID]\n%s", CS.GameEntry.Device:GetDeviceUid())
  local uid = LuaEntry.Player:GetUid()
  if string.IsNullOrEmpty(uid) then
    return sb:ToString()
  end
  sb:AppendLine()
  sb:AppendFormatLine([[
[UID]
%s]], uid)
  sb:AppendLine()
  sb:AppendFormatLine([[
[Name]
%s]], LuaEntry.Player:GetName())
  sb:AppendLine()
  sb:AppendFormatLine("[\229\142\159\230\156\141]\n%s", LuaEntry.Player:GetSourceServerId())
  sb:AppendLine()
  sb:AppendFormatLine("[\231\153\187\229\189\149\230\156\141]\n%s", LuaEntry.Player:GetSelfServerId())
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    sb:AppendLine()
    sb:AppendFormatLine("[\232\129\148\231\155\159ID]\n%s", allianceId)
    sb:AppendLine()
    sb:AppendFormatLine("[\232\129\148\231\155\159\229\144\141\231\167\176]\n%s", LuaEntry.Player:GetFullAllianceName())
  end
  local seasonInfo = DataCenter.SeasonDataManager
  seasonInfo = seasonInfo and seasonInfo.playerSeasonInfo
  if seasonInfo then
    sb:AppendLine()
    sb:AppendFormatLine("[\232\181\155\229\173\163]")
    sb:AppendLine(string.format("\232\181\155\229\173\163id:%s", seasonInfo.seasonId))
    local modeConvert = {
      [0] = "0:\230\151\160\231\138\182\230\128\129",
      [1] = "1:\232\191\155\232\161\140\228\184\173",
      [2] = "2:\228\188\145\232\181\155\230\156\159",
      [3] = "3:\233\162\132\231\131\173\228\184\173"
    }
    sb:AppendLine(string.format("\232\181\155\229\173\163\231\138\182\230\128\129(mode):%s", modeConvert[seasonInfo.mode] or seasonInfo.mode))
    sb:AppendLine(string.format("\232\181\155\229\173\163\233\133\141\231\189\174id:%s", seasonInfo.seasonConfigId))
  end
  sb:AppendLine()
  sb:AppendFormatLine("[\229\133\182\228\187\150]")
  sb:AppendFormatLine("\229\188\186\230\156\141(NB Server):%s", DataCenter.ActMigrationManager:IsNBServer() and " \230\152\175\229\149\138" or " \228\184\141\230\152\175")
  return sb:ToString()
end

config:Add({
  name = "\230\159\165\231\156\139\229\159\186\231\161\128\228\191\161\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local str = _getBaseInfo()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  onClicked = function()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(_getBaseInfo())
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\228\191\174\230\148\185\229\188\128\229\133\179\231\138\182\230\128\129",
  icon = "Assets/Main/Sprites/ItemIcons/zyf_zhuzai_jihuashu_daoju_icon_new.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendFormatLine("\230\159\165\231\156\139\227\128\129\228\191\174\230\148\185\229\188\128\229\133\179\231\138\182\230\128\129\239\188\136\230\156\172\229\156\176\239\188\137")
    sb:AppendFormatLine("\229\175\185\229\186\148function_on\232\161\168")
    sb:AppendFormatLine("\230\179\168\230\132\143\239\188\154\230\159\144\228\186\155\229\188\128\229\133\179\228\191\174\230\148\185\229\144\142\239\188\140\229\143\175\232\131\189\230\151\160\230\179\149\231\148\159\230\149\136")
    sb:AppendFormatLine("\229\155\160\228\184\186\228\189\191\231\148\168\228\186\134\232\191\153\228\184\170\229\188\128\229\133\179\231\154\132\229\156\176\230\150\185\229\143\175\232\131\189\231\188\147\229\173\152\232\191\135\229\188\128\229\133\179\231\138\182\230\128\129...")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    if not GMUtils.CheckLogin() then
      UIUtil.ShowTips("\232\175\183\230\130\168\229\133\136tm\231\153\187\229\189\149\230\184\184\230\136\143...")
      return
    end
    GMUtils.Close()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMSwitchView, {anim = true})
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\233\135\141\229\144\175\230\184\184\230\136\143",
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    GMUtils.Close()
    UIUtil.ShowMessage("\228\189\160\231\161\174\229\174\154\232\166\129\231\170\129\231\160\180\228\186\186\231\177\187\233\129\147\229\190\183\229\186\149\231\186\191\239\188\140\229\188\186\229\136\182\233\135\141\229\144\175\230\184\184\230\136\143\228\185\136\239\188\159", 2, "\231\170\129\231\160\180!", "\228\191\157\229\174\136\231\130\185", function()
      UIUtil.ShowTips("\229\145\181\229\145\181\239\188\140\231\156\159\230\184\163!")
      TimerManager:GetInstance():DelayInvoke(function()
        reloadGame(true)
      end, 0.5)
    end, function()
      UIUtil.ShowTips("\229\145\181\229\145\181\239\188\140\233\135\141\232\189\189\232\135\170\229\138\168\231\153\187\229\189\149\229\142\187\228\186\134!")
      TimerManager:GetInstance():DelayInvoke(function()
        reloadGame(false)
      end, 0.5)
    end, nil)
  end,
  btnName = "\232\181\176\228\189\160"
})
config:Add({
  name = "\230\150\173\231\186\191\233\135\141\232\191\158",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_wifi_bg.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    GMUtils.Close()
    reconnectGame()
  end,
  btnName = "\"kale\""
})
config:Add({
  name = "\229\136\135\230\141\162\232\175\173\232\168\128",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_language.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, {anim = true, hideTop = true})
    GMUtils.Close()
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\229\136\135\230\141\162\232\175\173\233\159\179",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_voice.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, {anim = true, hideTop = true}, SettingType.Voice)
    GMUtils.Close()
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\230\152\190\231\164\186\229\164\154\232\175\173\232\168\128key",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_language.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\230\152\190\231\164\186\229\164\154\232\175\173\232\168\128\231\154\132\229\156\176\230\150\185\229\176\134\230\152\190\231\164\186key")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return Localization.ShowKey
  end,
  set = function(val)
    Localization.ShowKey = val
  end
})
config:Add({
  name = "\230\137\139\229\138\168\230\137\147\229\188\128\230\142\167\229\136\182\229\143\176",
  icon = "Assets/Main/Sprites/ItemIcons/item_uav_equip_1308.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    DataCenter.LWDevConsoleManager:OpenWindow()
    GMUtils.Close()
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\230\152\190\231\164\186\229\144\132\231\167\141ID",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_plus sign.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\229\143\175\228\187\165\229\156\168\239\188\154")
    sb:AppendLine("\232\139\177\233\155\132\231\149\140\233\157\162\227\128\129\232\131\140\229\140\133\231\149\140\233\157\162\227\128\129\229\187\186\231\173\145\229\141\135\231\186\167\231\149\140\233\157\162\227\128\129\230\138\128\232\131\189\231\160\148\231\169\182\231\149\140\233\157\162")
    sb:AppendLine("\230\159\165\231\156\139\229\136\176\229\175\185\229\186\148\231\154\132ID")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugDisplayGameID, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugDisplayGameID, val)
  end
})
config:Add({
  name = "\229\147\170\233\135\140\228\184\141\228\188\154\231\130\185\229\147\170\233\135\140",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\233\131\168\229\136\134\229\138\159\232\131\189\231\154\132\231\130\185\229\135\187\232\161\140\228\184\186\228\188\154\229\156\168Warning\233\162\145\233\129\147\230\137\147\229\141\176\232\176\131\232\175\149\228\191\161\230\129\175")
    sb:AppendLine("\231\155\174\229\137\141\229\183\178\230\148\175\230\140\129\239\188\154")
    sb:AppendLine("1\227\128\129\229\164\167\228\184\150\231\149\140\231\130\185\229\135\187\229\144\132\231\167\141\229\156\176\229\155\190\231\130\185")
    sb:AppendLine("2\227\128\129\229\164\167\228\184\150\231\149\140\231\130\185\229\135\187\229\144\132\231\167\141\232\161\140\229\134\155")
    sb:AppendLine("3\227\128\129\231\130\185\229\135\187UI\229\146\140collider\228\188\154\230\137\147\229\141\176gameObject.name")
    sb:AppendLine("\229\143\175\228\187\165\229\156\168Console\228\184\173\230\144\156\231\180\162\229\133\179\233\148\174\232\175\141ccc")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugClickLogWarning, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugClickLogWarning, val)
  end,
  icon = "Assets/Main/Sprites/UI/UIBuildBubble/mjc_zhujiemian_qipao_s2_dianhuo.png"
})
config:Add({
  name = "\230\137\147\229\141\176\230\156\141\229\138\161\229\153\168\230\182\136\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianyouhua_jianpan_icon.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\230\191\128\230\180\187\229\144\142\229\176\134\229\156\168warning\233\162\145\233\129\147\230\137\147\229\141\176\229\137\141\231\171\175\230\148\182\227\128\129\229\143\145\231\154\132\229\141\143\232\174\174\232\175\166\230\131\133\239\188\129")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugLogProtocolMsg, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugLogProtocolMsg, val)
    UIUtil.ShowTips(val and "\230\137\147\229\141\176\230\156\141\229\138\161\229\153\168\230\182\136\230\129\175" or "\228\184\141\230\137\147\229\141\176\230\156\141\229\138\161\229\153\168\230\182\136\230\129\175")
  end
})
config:Add({
  name = "\230\137\147\229\141\176\229\174\140\230\149\180\229\143\145\233\128\129\230\182\136\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_wangzhuozhan_zontongguanli_icon6.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[QA\231\148\168]")
    sb:AppendLine("\230\191\128\230\180\187\229\144\142\229\176\134\229\156\168log\233\162\145\233\129\147\230\137\147\229\141\176\229\174\140\230\149\180\231\154\132\229\143\145\233\128\129\230\182\136\230\129\175\239\188\129\229\133\179\233\148\174\232\175\141[Msg Send]")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugSendMsg, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugSendMsg, val)
    UIUtil.ShowTips(val and "\229\188\128\229\167\139\230\137\147\229\141\176\229\174\140\230\149\180\229\143\145\233\128\129\230\182\136\230\129\175" or "\229\129\156\230\173\162\230\137\147\229\141\176\229\174\140\230\149\180\229\143\145\233\128\129\230\182\136\230\129\175")
  end
})
config:Add({
  name = "\228\184\141\232\166\129\229\134\141\230\146\173\229\137\167\230\131\133\229\175\185\232\175\157\228\186\134\239\188\136\229\141\149\230\172\161\239\188\137",
  icon = "Assets/Main/Sprites/UI/UIActivity/cfm_huodong_gerenjunbei_baoxiang_qipao.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\233\135\141\229\144\175\230\184\184\230\136\143\229\144\142\232\191\152\230\152\175\228\188\154\230\146\173\229\145\166\239\188\129")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool("DEBUG_JUMP_ALL_PLOT", false)
  end,
  set = function(val)
    GMUtils.SetBool("DEBUG_JUMP_ALL_PLOT", val)
    UIUtil.ShowTips(val and "\230\129\173\229\150\156\228\189\160\228\184\141\231\148\168\229\134\141\231\130\185\231\130\185\231\130\185\228\186\134\239\188\129" or "\230\131\179\231\130\185\228\189\160\229\176\177\231\130\185\229\144\167~")
  end
})
config:Add({
  name = "\228\184\141\232\166\129\229\134\141\230\146\173\229\137\167\230\131\133\229\175\185\232\175\157\228\186\134\239\188\136\230\176\184\228\185\133\239\188\137",
  icon = "Assets/Main/Sprites/UI/UIActivity/cfm_huodong_gerenjunbei_baoxiang_qipao.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\230\136\145\229\183\178\231\187\143\229\142\140\229\128\166\228\186\134\231\130\185\231\130\185\231\130\185\239\188\129")
    sb:AppendLine("\233\135\141\229\144\175\230\184\184\230\136\143\229\144\142\228\185\159\228\184\141\228\188\154\230\146\173\229\149\166\239\188\129")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return Setting:GetBool("DEBUG_JUMP_ALL_PLOT", false)
  end,
  set = function(val)
    Setting:SetBool("DEBUG_JUMP_ALL_PLOT", val)
    UIUtil.ShowTips(val and "\230\129\173\229\150\156\228\189\160\228\184\141\231\148\168\229\134\141\231\130\185\231\130\185\231\130\185\228\186\134\239\188\129" or "\230\131\179\231\130\185\228\189\160\229\176\177\231\130\185\229\144\167~")
  end
})
config:Add({
  name = "\232\131\189\229\191\171\231\130\185\228\185\136[0.5 ~ 5.0]",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_time.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\167\141\228\184\128\230\163\181\230\160\145\230\156\128\229\165\189\231\154\132\230\151\182\233\151\180\230\152\175\229\156\168\229\141\129\229\185\180\229\137\141\239\188\140")
    sb:AppendLine("\229\133\182\230\172\161\230\152\175\229\156\168\228\184\139\228\184\128\228\184\170\230\164\141\230\160\145\232\138\130\227\128\130")
    sb:AppendLine("\230\136\145\229\184\140\230\156\155\229\191\171\231\130\185\232\191\135\228\184\139\228\184\128\228\184\170\230\164\141\230\160\145\232\138\130\239\188\129")
    sb:AppendLine("\233\130\163\229\176\177\229\191\171\230\157\165\232\176\131\230\136\145\229\144\167~")
    sb:AppendLine("\232\176\131\232\138\130\232\140\131\229\155\180\239\188\154[0.5 ~ 5.0]")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return Time.timeScale
  end,
  set = function(val)
    Time.timeScale = val
    UIUtil.ShowTips(string.format("TimeScale\232\174\190\231\189\174\228\184\186:%s", Time.timeScale))
  end,
  min = 0.5,
  max = 5.0,
  contentType = 3
})
config:Add({
  name = "\230\136\170\229\155\190\229\185\182\228\184\148\228\191\157\229\173\152\229\136\176\231\155\184\229\134\140",
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    local nowTime = SafeLocalOsTime()
    local fileName = string.format("ScreenShot%s.jpg", nowTime)
    local filePath = CS.UnityEngine.Application.persistentDataPath .. "/" .. fileName
    CS.UnityEngine.ScreenCapture.CaptureScreenshot(fileName)
    TimerManager:GetInstance():DelayInvoke(function()
      CS.SDKManager.SaveToAlbum(filePath, fileName)
    end, 0.5)
  end,
  btnName = "\230\136\170\229\155\190"
})

local function getPackageInfo()
  local sb = StringBuilder.New()
  local requiredPackages = CS.ResourcePackageManager.GetRequiredPackagesWithoutLog()
  if requiredPackages ~= nil and requiredPackages.Length > 0 then
    sb:AppendLine("\230\156\141\229\138\161\229\153\168\232\166\129\230\177\130\228\184\139\232\189\189\231\154\132\229\136\134\229\140\133ID:")
    local packageIds = {}
    for i = 0, requiredPackages.Length - 1 do
      table.insert(packageIds, requiredPackages[i])
    end
    sb:AppendLine(table.concat(packageIds, ", "))
    sb:AppendLine("\n\229\144\132\229\136\134\229\140\133\228\184\139\232\189\189\231\138\182\230\128\129:")
    for i = 0, requiredPackages.Length - 1 do
      local packageId = requiredPackages[i]
      local isDownloaded = CS.ResourcePackageManager.IsPackageDownloaded(packageId)
      local totalSize = CS.ResourcePackageManager.GetPackageTotalSize(packageId)
      local sizeFormat = totalSize == 0 and "<color=#FF0000>0Mb</color>" or string.format("<color=#000000>%.2fMb</color>", totalSize / 1048576)
      sb:AppendLine(string.format("\229\136\134\229\140\133ID: %d, \229\183\178\228\184\139\232\189\189: %s,\230\128\187\229\164\167\229\176\143: %s", packageId, tostring(isDownloaded), sizeFormat))
    end
  else
    sb:AppendLine("\230\156\170\232\142\183\229\143\150\229\136\176\230\156\141\229\138\161\229\153\168\228\184\139\229\143\145\231\154\132\229\136\134\229\140\133\228\191\161\230\129\175")
  end
  sb:AppendLine("\n\n\228\184\139\232\189\189\228\184\173\229\191\131\228\184\139\229\143\145\230\149\176\230\141\174:")
  local normalPackageStr = DataCenter.PlayerDownloadCenterManager:GetNormalPackageStrFromServer()
  sb:AppendLine("\233\161\181\231\173\190\230\152\190\231\164\186\231\154\132\229\136\134\229\140\133ID\239\188\154\n" .. string.gsub(normalPackageStr, "|", ", "))
  local canDelPackageStr = DataCenter.PlayerDownloadCenterManager:GetCanDelPackageStrFromServer()
  sb:AppendLine("\233\156\128\232\135\170\229\138\168\229\136\160\233\153\164\231\154\132\229\136\134\229\140\133ID\239\188\154\n" .. string.gsub(canDelPackageStr, "|", ", "))
  sb:AppendLine("\n\228\184\139\230\172\161\231\153\187\229\189\149\232\175\165\229\143\183\231\154\132\230\151\182\239\188\140\230\156\170\229\136\160\229\185\178\229\135\128\231\154\132\229\136\134\229\140\133\239\188\154")
  local waitDeletePackageIds = CS.DownloadResGroupCommonManager.GetWaitDeletePackageIds()
  if not string.IsNullOrEmpty(waitDeletePackageIds) then
    local waitDeletePackageIdList = string.split(waitDeletePackageIds, "|")
    for i = 1, #waitDeletePackageIdList do
      local deleteTimes = CS.DownloadResGroupCommonManager.GetPackageDeleteTimes(waitDeletePackageIdList[i])
      sb:AppendLine("packageId\239\188\154" .. waitDeletePackageIdList[i] .. "     \229\190\133\229\136\160\233\153\164\230\172\161\230\149\176\239\188\154" .. deleteTimes)
    end
  end
  local versionsSkipUpdateFlag = CS.DownloadResGroupCommonManager.GetVersionsSkipUpdateFlag()
  sb:AppendLine("\nVersions.SkipUpdate\230\160\135\229\191\151\239\188\154" .. versionsSkipUpdateFlag)
  return sb:ToString()
end

config:Add({
  name = "\230\159\165\231\156\139\229\136\134\229\140\133\228\191\161\230\129\175",
  icon = "Assets/Main/Sprites/ItemIcons/icon_building_103509000.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local serverRequireData = getPackageInfo()
    local param = {}
    param.title = "\229\136\134\229\140\133"
    param.activityRulesStr = serverRequireData
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end,
  onClicked = function()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(getPackageInfo())
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\231\167\187\233\153\164\230\137\128\230\156\137 Settings\239\188\136PlayerPres\239\188\137",
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_shangjinlieren_zidan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    CS.GameEntry.Setting:RemoveAllSettings()
  end,
  btnName = "\230\139\156\230\139\156\228\186\134\230\130\168\228\187\172\229\134\133\239\188\129"
})
config:Add({
  name = "\231\167\187\233\153\164\230\140\135\229\174\154 Settings\239\188\136PlayerPres\239\188\137",
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_shangjinlieren_zidan.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not string.IsNullOrEmpty(val) then
      CS.GameEntry.Setting:RemoveSetting(val)
    end
  end,
  btnName = "\230\139\156\230\139\156\228\186\134\230\130\168\229\134\133\239\188\129"
})
config:Add({
  name = "\231\167\187\233\153\164\230\140\135\229\174\154 Settings\239\188\136PlayerPres\239\188\137\229\184\166\228\184\138\232\135\170\229\183\177\231\154\132Uid",
  icon = "Assets/Main/Sprites/ItemIcons/wxy_icon_shangjinlieren_zidan.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = nil,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not string.IsNullOrEmpty(val) then
      CS.GameEntry.Setting:RemoveSetting(LuaEntry.Player:GetUid() .. val)
      CS.GameEntry.Setting:RemoveSetting(val .. LuaEntry.Player:GetUid())
    end
  end,
  btnName = "\230\139\156\230\139\156\228\186\134\230\130\168\229\134\133\239\188\129"
})
config:Add({
  name = "WIFI\232\135\170\229\138\168\228\184\139\232\189\189\229\188\128\229\133\179",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/FX_xiazaizhongxing_xiazai_icon.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\228\184\139\232\189\189\228\184\173\229\191\131\239\188\154")
    sb:AppendLine("\230\191\128\230\180\187\229\144\142\229\176\134\232\191\155\230\184\184\230\136\143\228\188\154\232\135\170\229\138\168\229\188\128\229\167\139\228\184\139\232\189\189\228\184\173\229\191\131\233\133\141\231\189\174\231\154\132package\239\188\140\229\166\130\230\158\156\232\166\129\230\181\139\232\175\149\229\138\159\232\131\189\231\154\132\232\191\156\231\168\139\229\138\168\230\128\129\229\138\160\232\189\189\239\188\140\233\156\128\232\166\129\229\156\168\232\191\155\230\184\184\230\136\143\231\154\132\230\151\182\229\128\153\229\133\179\233\151\173\230\173\164\230\140\137\233\146\174\227\128\130  Debug\229\140\133\231\154\132\232\174\190\231\189\174\229\188\128\229\133\179\228\184\141\232\183\159\233\154\143\232\180\166\229\143\183\232\181\176\239\188\129")
    sb:AppendLine("")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return CommonUtil.GlobalPrefsGetBool(GMConst.PlayerDownloadCenter_Setting_AutoDownload, true)
  end,
  set = function(val)
    CommonUtil.GlobalPrefsSetBool(GMConst.PlayerDownloadCenter_Setting_AutoDownload, val)
    EventManager:GetInstance():Broadcast(EventId.ChangeAutoDownloadSettingState)
    UIUtil.ShowTips(val and "\229\188\128\229\144\175WIFI\232\135\170\229\138\168\228\184\139\232\189\189" or "\229\133\179\233\151\173WIFI\232\135\170\229\138\168\228\184\139\232\189\189")
  end
})
config:Add({
  name = "\233\135\141\231\189\174\228\184\141\229\134\141\230\143\144\233\134\146",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\232\190\147\229\133\165 TodayNoSecondConfirmType \230\158\154\228\184\190\229\128\188\239\188\140\233\135\141\231\189\174\229\175\185\229\186\148\231\154\132\"\228\184\141\229\134\141\230\143\144\233\134\146\"\231\138\182\230\128\129")
    sb:AppendLine("")
    sb:AppendLine("\229\184\184\231\148\168\230\158\154\228\184\190\229\128\188\239\188\154")
    sb:AppendLine("UpgradeUseDiamond - \229\141\135\231\186\167\228\189\191\231\148\168\233\146\187\231\159\179")
    sb:AppendLine("BuyUseDialog - \228\185\176\229\138\160\233\128\159\227\128\129\228\185\176\232\181\132\230\186\144")
    sb:AppendLine("BuyStaminaTip - \228\185\176\228\189\147\229\138\155\230\143\144\231\164\186")
    sb:AppendLine("RefreshDispatchTask - \229\136\183\230\150\176\230\180\190\233\129\163\228\187\187\229\138\161")
    sb:AppendLine("AutoDig - \232\135\170\229\138\168\230\140\150\230\142\152")
    sb:AppendLine("KillZombie - \228\184\167\229\176\184\230\140\145\230\136\152\230\143\144\231\164\186")
    sb:AppendLine("AresMissileConfirm - \230\136\152\231\165\158\233\163\158\229\188\185\231\161\174\232\174\164")
    sb:AppendLine("")
    sb:AppendLine("\232\190\147\229\133\165 * \229\143\175\233\135\141\231\189\174\230\137\128\230\156\137\228\184\141\229\134\141\230\143\144\233\134\146")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return "UpgradeUseDiamond"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\158\154\228\184\190\229\128\188")
      return
    end
    if val == "*" then
      for k, v in pairs(TodayNoSecondConfirmType) do
        Setting:SetPrivateString(v, "")
      end
      UIUtil.ShowTips("\229\183\178\233\135\141\231\189\174\230\137\128\230\156\137\228\184\141\229\134\141\230\143\144\233\134\146")
    else
      local enumValue = TodayNoSecondConfirmType[val]
      if enumValue then
        Setting:SetPrivateString(enumValue, "")
        UIUtil.ShowTips(string.format("\229\183\178\233\135\141\231\189\174: %s", val))
      else
        Setting:SetPrivateString(val, "")
        UIUtil.ShowTips(string.format("\229\183\178\233\135\141\231\189\174: %s", val))
      end
    end
  end,
  contentType = 0,
  btnName = "\233\135\141\231\189\174"
})
config:Add({
  name = "\230\168\161\230\139\159\229\144\142\231\171\175\230\182\136\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianyouhua_jianpan_icon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\176\134\230\151\165\229\191\151\228\184\173\230\137\147\229\141\176\231\154\132\230\156\141\229\138\161\229\153\168\230\182\136\230\129\175\231\178\152\232\180\180\229\136\176\230\173\164\229\164\132\232\191\155\232\161\140\230\168\161\230\139\159\227\128\130")
    sb:AppendLine("")
    sb:AppendLine("\230\148\175\230\140\129\230\160\135\229\135\134\230\151\165\229\191\151\230\160\188\229\188\143\239\188\154")
    sb:AppendLine("[Msg][Receive]<color=green>extension res <get.new.user.info> |</color> {json_body}")
    sb:AppendLine("")
    sb:AppendLine("\228\185\159\230\148\175\230\140\129\231\174\128\229\140\150\230\160\188\229\188\143\239\188\154")
    sb:AppendLine("get.new.user.info | {json_body}")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return ""
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\230\182\136\230\129\175\229\134\133\229\174\185")
      return
    end
    CS.MessageFactory.Instance:DebugDispatchMessage(val)
  end,
  contentType = 0,
  btnName = "\230\168\161\230\139\159"
})
return config
