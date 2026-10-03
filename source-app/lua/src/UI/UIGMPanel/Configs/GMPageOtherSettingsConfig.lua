local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("OtherDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 10
config.label = "\229\133\182\228\187\150"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_S3_shijie_lvhua.png"
config:Add({
  name = "\229\164\141\229\136\182\232\180\166\229\143\183\229\136\151\232\161\168",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_beizhugongneng_rukou_icon.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLineFormat("--\233\128\137\230\156\141\229\140\133\229\143\175\231\148\168--")
    sb:AppendLineFormat("\229\184\174\230\130\168\230\137\190\229\155\158\233\157\146\230\152\165\231\154\132\229\155\158\229\191\134^_^")
    sb:AppendLineFormat("\229\176\134\229\189\147\229\137\141\230\156\172\229\156\176\228\191\157\229\173\152\231\154\132\232\180\166\229\143\183\229\136\151\232\161\168\228\191\161\230\129\175\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    sb:AppendLineFormat("\229\136\160\229\140\133\229\144\142\239\188\140\229\143\175\229\176\134\229\136\151\232\161\168\228\191\161\230\129\175\233\128\154\232\191\135 \229\175\188\229\133\165 \229\138\159\232\131\189\233\135\141\230\150\176\230\183\187\229\138\160\229\155\158\230\156\172\229\156\176")
    local str = sb:ToString()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  onClicked = function()
    local infoStr = DataCenter.AccountListManager:GetAccountInfoString()
    local accounts = DataCenter.AccountListManager:ParseAccountInfos(infoStr)
    if #accounts <= 0 then
      UIUtil.ShowTips("\230\156\168\230\156\137\228\187\187\228\189\149\232\180\166\229\143\183\228\191\161\230\129\175\229\147\166~")
      return
    end
    UIUtil.ShowTips(string.format("\229\183\178\229\164\141\229\136\182 %s \228\184\170\232\180\166\229\143\183\228\191\161\230\129\175\229\136\176\229\137\170\232\180\180\230\157\191", #accounts))
    CommonUtil.CopyTextToClipboard(infoStr)
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\229\175\188\229\133\165\232\180\166\229\143\183\229\136\151\232\161\168",
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_gerenshezhi_guanzhu_icon.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  contentType = 0,
  tips = function(comp)
    if not comp then
      return
    end
    local input = comp.input
    if not input then
      return
    end
    local val = input:GetText()
    local accounts = DataCenter.AccountListManager:ParseAccountInfos(val)
    local str = ""
    if #accounts <= 0 then
      str = "\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\232\180\166\229\143\183\228\191\161\230\129\175\229\145\162~"
    else
      local sb = StringBuilder.New()
      sb:AppendLineFormat("\230\137\190\229\136\176<color=red> %s </color>\228\184\170\232\180\166\229\143\183\228\191\161\230\129\175", #accounts)
      sb:AppendLine()
      sb:AppendLineFormat(val)
      str = sb:ToString()
    end
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  get = function()
    return ""
  end,
  set = function(val)
    local accounts = DataCenter.AccountListManager:ParseAccountInfos(val)
    if #accounts <= 0 then
      UIUtil.ShowTips("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\232\180\166\229\143\183\228\191\161\230\129\175~")
    else
      UIUtil.ShowTips(string.format("\230\137\190\229\136\176 %s \228\184\170\232\180\166\229\143\183\228\191\161\230\129\175", #accounts))
    end
  end,
  onClicked = function(val)
    local accounts = DataCenter.AccountListManager:ParseAccountInfos(val)
    if #accounts <= 0 then
      UIUtil.ShowTips("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\232\180\166\229\143\183\228\191\161\230\129\175~")
      return
    else
      local newCount = DataCenter.AccountListManager:MergeAccountInfoAndSave(val)
      UIUtil.ShowTips(string.format("\229\144\136\229\185\182\230\136\144\229\138\159\239\188\140\230\150\176\229\162\158\228\186\134 %s \228\184\170\232\180\166\229\143\183\228\191\161\230\129\175", newCount))
    end
  end,
  btnName = "\229\175\188\229\133\165"
})
config:Add({
  name = "\230\137\147\229\141\176\232\189\166\229\186\147\228\189\156\231\148\168\229\143\183\232\174\161\231\174\151\232\191\135\231\168\139",
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_tank.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  get = function()
    return GMUtils.GetBool(GMConst.ShowParkEffectNumberLog, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ShowParkEffectNumberLog, val)
    UIUtil.ShowTips(val and "\229\188\128\229\144\175" or "\229\133\179\233\151\173")
  end
})
config:Add({
  name = "\231\130\185\231\169\186\229\156\176\230\137\147\229\188\128\230\142\167\229\136\182\229\143\176",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UIDecoration/UIDecoration/base_effect_pifu1.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\156\168\229\134\133\229\159\142\228\184\173\231\130\185\229\135\187\231\169\186\229\156\176\228\184\128\231\153\190\230\172\161\229\144\142\229\143\175\228\187\165\230\137\147\229\188\128\230\142\167\229\136\182\229\143\176\227\128\130")
    sb:AppendLine("\233\156\128\232\166\129\229\156\1682\231\167\146\229\134\133\231\130\185\229\174\140\229\147\166~")
    sb:AppendLine("\226\153\170\226\153\169\226\153\170\226\153\169")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugClickEmptyRunCmd, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugClickEmptyRunCmd, val)
    UIUtil.ShowTips(val and "\231\130\185\229\135\187\231\169\186\229\156\176\229\143\175\228\187\165\229\144\175\229\138\168\230\142\167\229\136\182\229\143\176" or "\231\130\185\229\135\187\231\169\186\229\156\176\229\176\134\228\184\141\229\134\141\229\144\175\229\138\168\230\142\167\229\136\182\229\143\176")
  end
})
config:Add({
  name = "\231\186\162\231\130\185\231\179\187\231\187\159\230\151\165\229\191\151\232\190\147\229\135\186",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/uibuild_ruins_energy_icon.png",
  get = function()
    return GMUtils.GetBool(GMConst.LogRedPointInfo)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.LogRedPointInfo, val)
  end
})
config:Add({
  name = "\229\164\150\231\189\145\230\160\185\230\141\174\230\136\152\230\138\165id\230\137\147\229\188\128\230\140\135\229\174\154\230\136\152\230\138\165",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_1.png",
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    BattleReportUtil.ShowBattleReport(val)
  end,
  contentType = 0,
  btnName = "\229\188\128\229\167\139\230\136\152\230\150\151"
})
config:Add({
  name = "\230\181\139\232\175\149\228\184\139\232\189\189\230\136\152\230\138\165(Download)",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_1.png",
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local uuid = "1300717095129977899"
    BattleReportUtil.DownloadBattleReport(uuid, {
      type = "mail",
      id = "6b96a32030da4d44befa02c43bf87973"
    }, true, "aws://reportFrame/fb/1300717095129977899.bin", true)
  end,
  contentType = 0,
  btnName = "\229\188\128\229\167\139\230\136\152\230\150\151"
})
config:Add({
  name = "\230\181\139\232\175\149\228\184\139\232\189\189\230\136\152\230\138\165\229\155\158\230\148\190(Get)",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_1.png",
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local uuid = "1300717031536246416"
    local md5 = CS.StringUtils.GetMD5(uuid)
    local index = string.lower(string.sub(md5, 1, 2))
    local address = "ali://report/" .. index .. "/" .. uuid .. ".bin"
    BattleReportUtil.Create(uuid, PVEEnterType.Debug, false, true, address)
  end,
  contentType = 0,
  btnName = "\229\188\128\229\167\139\230\136\152\230\150\151"
})
config:Add({
  name = "\229\134\133\231\189\145\230\160\185\230\141\174\230\136\152\230\138\165id\230\137\147\229\188\128\230\140\135\229\174\154\230\136\152\230\138\165",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    BattleReportUtil.ShowLocalBattleReport(val)
  end,
  contentType = 0,
  btnName = "\229\188\128\229\167\139\230\136\152\230\150\151",
  icon = "Assets/Main/Sprites/ItemIcons/icon_kelongxinpian_1.png"
})
config:Add({
  name = "\230\160\185\230\141\174id\232\191\155\229\133\165PVE\229\133\179\229\141\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 101
  end,
  set = function(val)
  end,
  onClicked = function(val)
    DataCenter.LWBattleManager:JumpLevel(val)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\232\191\155\229\133\165\229\133\179\229\141\161",
  icon = "Assets/Main/Sprites/UI/UIPveLoading/UIPveLoading_img01.png"
})
config:Add({
  name = "\230\160\185\230\141\174mailUid\230\146\173\230\148\190\230\136\152\230\150\151\229\189\149\229\131\143",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    DataCenter.LWBattleManager:PlayReplay(val, PVEEnterType.GM)
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190\229\189\149\229\131\143",
  icon = "Assets/Main/Sprites/UI/UIFirstPay/cfm_shouchong_bofang.png"
})
config:Add({
  name = "\233\135\141\230\146\173\228\184\138\228\184\128\230\172\161\230\146\173\230\148\190\231\154\132\229\189\149\229\131\143",
  icon = "Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_shuaxin_icon.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    DataCenter.LWBattleManager:PlayLastReplay()
  end,
  btnName = "\233\135\141\230\146\173\229\189\149\229\131\143"
})
config:Add({
  name = "\230\137\147\229\188\128\233\156\135\229\138\168\232\176\131\232\175\149\231\149\140\233\157\162",
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMVibratorPanel, {anim = true})
  end,
  btnName = "\229\188\128\233\156\135"
})
config:Add({
  name = "\232\183\145\233\133\183\229\188\128\229\144\175\230\151\165\229\191\151\232\190\147\229\135\186",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianyouhua_jianpan_icon.png",
  get = function()
    return GMUtils.GetBool(GMConst.SurfingLogOutput, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.SurfingLogOutput, val)
  end
})
config:Add({
  name = "\229\156\168\233\155\183\232\190\190\231\149\140\233\157\162\230\146\173\230\148\190\230\137\171\229\133\137\229\138\168\231\148\187",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    EventManager:GetInstance():Broadcast(EventId.GMPanelPlayDetectEventAni)
  end,
  btnName = "\230\146\173\230\148\190\230\137\171\229\133\137\229\138\168\231\148\187"
})
config:Add({
  name = "\229\156\168\233\155\183\232\190\190\231\149\140\233\157\162\230\146\173\230\148\190\230\172\161\230\149\176\229\162\158\229\138\160\231\137\185\230\149\136",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local newValue = tonumber(val) or 1
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    EventManager:GetInstance():Broadcast(EventId.DetectEventRewardGet, newValue)
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190\231\137\185\230\149\136",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png"
})
config:Add({
  name = "\230\137\147\229\188\128\228\184\138\230\150\176\231\149\140\233\157\162",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianyouhua_jianpan_icon.png",
  get = function()
    return 10007
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local weekCardList = DataCenter.WeekCardManager:GetWeekCardList()
    if weekCardList == nil then
      return
    end
    if not val then
      return
    end
    for i, v in ipairs(weekCardList) do
      if v and v.id == tonumber(val) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWeekCardShowNew, {anim = true}, v)
        break
      end
    end
  end,
  btnName = "\232\138\157\233\186\187\229\188\128\233\151\168"
})
config:Add({
  name = "\229\188\128\229\144\175\230\150\176\231\154\132PVE\232\163\133\233\165\176\231\137\169\230\152\190\231\164\186",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UIPveLoading/UIPveLoading_img01.png",
  get = function()
    return GMUtils.GetBool(GMConst.NewPVEDecorationShowMethod, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.NewPVEDecorationShowMethod, val)
  end
})
config:Add({
  name = "\229\128\141\229\162\158\233\151\168\232\175\166\231\187\134\230\151\165\229\191\151",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UIPveLoading/UIPveLoading_img01.png",
  get = function()
    return GMUtils.GetBool(GMConst.ParkourDetailLog, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ParkourDetailLog, val)
  end
})
config:Add({
  name = "\229\143\145\233\128\129\228\184\128\228\184\170event",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianyouhua_jianpan_icon.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLineFormat("\229\143\145\229\176\132\229\144\142\232\135\170\229\138\168\229\133\179\233\151\173 GM \233\161\181\233\157\162")
    sb:AppendLineFormat("\228\189\134 1s \229\144\142\232\167\166\229\143\145\228\186\139\228\187\182")
    local str = sb:ToString()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetInt(GMConst.DebugTriggerEvent, 0)
  end,
  set = function(val)
    GMUtils.SetInt(GMConst.DebugTriggerEvent, val)
  end,
  onClicked = function(val)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    TimerManager:GetInstance():DelayInvoke(function()
      UIUtil.ShowTips("\232\167\166\229\143\145\228\186\139\228\187\182!")
      EventManager:GetInstance():Broadcast(val)
    end, 1)
  end,
  btnName = "\229\143\145\229\176\132\239\188\129"
})
config:Add({
  name = "\230\137\147\229\188\128\229\185\191\229\145\138\229\136\151\232\161\168",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWUIMaxAd/lrb_GGBX_shangdian_ADicon.png",
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    DataCenter.MaxAdManager:ShowAdsCollectionPanel()
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\230\137\147\229\188\128\229\185\191\229\145\138Debugger",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWUIMaxAd/lrb_GGBX_shangdian_ADicon.png",
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    DataCenter.MaxAdManager:ShowDebugger()
  end,
  btnName = "\230\137\147\229\188\128"
})
config:Add({
  name = "\230\137\147\229\188\128\229\185\191\229\145\138\230\181\139\232\175\149",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/LWUIMaxAd/lrb_GGBX_shangdian_ADicon.png",
  get = function()
    return GMUtils.GetBool(GMConst.AdDebugMode, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.AdDebugMode, val)
  end
})
config:Add({
  name = "\230\146\173\230\148\190\230\173\166\232\163\133\229\141\135\231\186\167\231\154\132\232\180\180\232\132\184banner",
  icon = "Assets/Main/Sprites/UI/UILWArmedUpgrade/lrb_xinshou_shengji.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    if LuaEntry.Player.JPUser then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeBannerWarningView_JP, {anim = false}, {click = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeBannerWarning, {anim = false}, {click = true})
    end
  end,
  btnName = "\230\137\147\229\188\128\231\149\140\233\157\162"
})
config:Add({
  name = "\230\137\147\229\188\128\229\144\140\231\155\159\229\134\155\233\165\183\229\165\150\229\138\177\229\141\135\231\186\167\231\149\140\233\157\162",
  tips = nil,
  icon = "Assets/Main/Sprites/UI/LWAllianceMilitaryPay/lrb_tmjx_jianglishengji_xiangzi_hong.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    UIManager:GetInstance():OpenWindow(UIWindowNames.AllianceMilitaryRewardUpgrade, {anim = false}, {lastLevel = 2, curLevel = 3})
  end,
  btnName = "\230\137\147\229\188\128\231\149\140\233\157\162"
})
config:Add({
  name = "\230\163\128\230\181\139Plot\232\161\168\233\133\141\233\159\179\229\156\168\229\144\132\228\184\170\232\175\173\232\168\128\230\152\175\229\144\166\229\173\152\229\156\168",
  tips = nil,
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_voice.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    DataCenter.LWSoundManager:DebugCheckAllLangDub()
  end,
  btnName = "\230\163\128\230\181\139"
})
config:Add({
  name = "\230\157\165\228\184\170\233\130\128\232\175\183\229\138\160\231\155\159\229\176\143\228\186\186",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_qizi_2.png",
  onClicked = function()
    DataCenter.ClientCityVisitorManager:GMSetEnterGameTarget(true)
    SFSNetwork.SendMessage(MsgDefines.AlSearch, 1, 1, "", 0, true)
  end,
  btnName = "\230\183\187\229\138\160"
})
config:Add({
  name = "\230\168\161\230\139\159\230\137\185\233\135\143\229\143\145\232\180\167\232\189\166",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local truckIndexStrArr = string.split(val, ",")
    local truckIndexArr = {}
    for i, v in ipairs(truckIndexStrArr) do
      truckIndexArr[i] = tonumber(v)
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    EventManager:GetInstance():Broadcast(EventId.BatchDepartureTrainSuccess, truckIndexArr)
  end,
  contentType = 0,
  btnName = "\229\143\145\232\189\166",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/lrb_chengjimaoyi_zhujiemian_tubiao.png"
})
config:Add({
  name = "\232\174\190\231\189\174\228\184\186\233\159\169\229\155\189\229\156\176\229\140\186(KFTC\230\179\149\232\167\132, \233\128\128\230\172\190)",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/CountryFlag/KR.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\229\176\134\229\188\186\229\136\182\232\174\190\231\189\174\228\184\186\233\159\169\229\155\189\229\156\176\229\140\186\227\128\130")
    sb:AppendLine("\233\128\154\229\184\184 \231\148\168\230\157\165\230\181\139\232\175\149KFTC\231\155\184\229\133\179\229\138\159\232\131\189\227\128\130 \233\159\169\229\155\189\233\128\128\230\172\190\230\143\144\231\164\186\231\173\137")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return CS.GameEntry.Setting:GetBool("KTFC_FORCE_TO_KR", false)
  end,
  set = function(val)
    CS.GameEntry.Setting:SetBool("KTFC_FORCE_TO_KR", val)
    UIUtil.ShowTips(val and "\229\183\178\229\136\135\230\141\162\228\184\186\233\159\169\229\155\189\229\156\176\229\140\186" or "\229\133\179\233\151\173\228\186\134\233\159\169\229\155\189\229\156\176\229\140\186")
  end
})
config:Add({
  name = "\230\183\187\229\138\160\228\184\128\228\184\170\228\191\157\230\138\164\231\189\169\230\139\141\232\132\184\230\143\144\233\134\146\229\176\143\228\186\186",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_lianmengduijue_tubiao.png",
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
    DataCenter.CityVisitorManager:CheckProtectCoverVisitorShow()
  end,
  btnName = "\230\183\187\229\138\160"
})
config:Add({
  name = "\230\183\187\229\138\160\228\184\128\228\184\170\233\128\154\231\159\165\231\177\187\230\176\148\230\179\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\229\134\133\229\174\185")
      return
    end
    local type = tonumber(val)
    DataCenter.LWPopupManager:TryAddPopupNotification(type)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\230\183\187\229\138\160",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_lianmengduijue_tubiao.png"
})
config:Add({
  name = "\229\136\160\233\153\164\228\184\128\228\184\170\233\128\154\231\159\165\231\177\187\230\176\148\230\179\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\175\183\232\190\147\229\133\165\229\134\133\229\174\185")
      return
    end
    local type = tonumber(val)
    DataCenter.LWPopupManager:ClearPopupNotificationByClick(type)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel, {anim = true})
  end,
  contentType = 0,
  btnName = "\229\136\160\233\153\164",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_lianmengduijue_tubiao.png"
})
return config
