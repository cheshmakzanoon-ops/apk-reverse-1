local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("CustomFunction")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 1
config.label = "\232\135\170\229\174\154\228\185\137"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_dig.png"
config:Add({
  name = "UI\229\176\132\231\186\191\230\163\128\230\181\139\229\183\165\229\133\183\n(\230\140\137\228\189\143Ctrl\230\163\128\230\181\139UI)",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon08.png",
  tips = function()
    UIUtil.ShowTips("\230\140\137\228\189\143Ctrl\233\148\174\239\188\140\233\188\160\230\160\135\231\167\187\229\138\168\229\136\176UI\228\184\138\229\141\179\229\143\175\230\163\128\230\181\139\229\185\182\230\152\190\231\164\186\232\183\175\229\190\132")
  end,
  get = function()
    local UIRaycastDebugger = CS.UIRaycastDebugger
    if UIRaycastDebugger then
      return UIRaycastDebugger.GetEnabled()
    end
    return false
  end,
  set = function(val)
    local UIRaycastDebugger = CS.UIRaycastDebugger
    if UIRaycastDebugger then
      UIRaycastDebugger.SetEnabled(val)
    end
  end
})
config:Add({
  name = "\232\191\155\229\133\165\233\177\188\229\161\152",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UINewYearBP/FX_yundonghui_yeqian_icon3.png",
  get = function()
    return 1414
  end,
  set = function(val)
  end,
  onClicked = function(val)
    DataCenter.FishingDataManager:TryEnterFishPond(102, tonumber(val))
  end,
  btnName = "\231\161\174\232\174\164",
  contentType = 3,
  min = 0,
  max = 9999
})
config:Add({
  name = "\231\166\187\229\188\128\233\177\188\229\161\152",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UINewYearBP/FX_yundonghui_yeqian_icon3.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.FishingDataManager:LeavePond()
  end,
  btnName = "\231\166\187\229\188\128"
})
config:Add({
  name = "\230\156\172\229\156\176\230\142\168\233\128\129\231\177\187\229\158\1391 15s",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_tongzhishu_zhujiemian_icon.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.PushNoticeManager:PushNotice(4100001, 15)
  end,
  btnName = "\229\143\145\233\128\129"
})
config:Add({
  name = "\229\143\150\230\182\136\230\142\168\233\128\129 \231\177\187\229\158\1391",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_jinyan.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.PushNoticeManager:CancelNotice(4100001)
  end,
  btnName = "\229\143\145\233\128\129"
})
config:Add({
  name = "\230\156\172\229\156\176\230\142\168\233\128\129\231\177\187\229\158\1392 15s",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_tongzhishu_zhujiemian_icon.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.PushNoticeManager:PushNotice(4100015, 15)
  end,
  btnName = "\229\143\145\233\128\129"
})
config:Add({
  name = "\229\143\150\230\182\136\230\142\168\233\128\129 \231\177\187\229\158\1392",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_jinyan.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.PushNoticeManager:CancelNotice(4100015)
  end,
  btnName = "\229\143\145\233\128\129"
})
config:Add({
  name = "\229\143\150\230\182\136\230\142\168\233\128\129 \229\133\168\233\131\168",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_jinyan.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.PushNoticeManager:CancelAllNotice()
  end,
  btnName = "\229\143\145\233\128\129"
})
config:Add({
  name = "\232\174\190\231\189\174\232\191\158\230\157\128\230\176\148\230\179\161\229\157\144\230\160\135\n\228\190\139\229\166\130\231\142\139\229\186\167497500",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon4.png",
  get = function()
    return 497500
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local pointId = toInt(val)
    if 1 < pointId and pointId <= 999999 then
      GMUtils.SetIntToCS("DebugMultiKillPointId", pointId)
      UIUtil.ShowTips("\230\147\141\228\189\156\230\136\144\229\138\159\239\188\129")
    else
      UIUtil.ShowTips("\232\190\147\229\133\165\228\184\141\229\144\136\230\179\149\239\188\140\232\175\183\232\190\147\229\133\165\230\149\176\229\173\1511~999999")
    end
  end,
  btnName = "\231\161\174\232\174\164",
  contentType = 3,
  min = 1,
  max = 999999,
  tips = function()
    UIUtil.ShowDetail("\230\140\137U\227\128\129I\227\128\129O\227\128\129J\227\128\129K\227\128\129L\229\136\134\229\136\171\228\189\191\231\142\169\229\174\182111\227\128\129222\227\128\129333\227\128\129444\227\128\129555\227\128\129666\231\154\132\232\191\158\230\157\128+3", nil, nil, true)
  end
})
config:Add({
  name = "\230\137\147\229\188\128\230\140\135\229\174\154UI\n\229\143\130\230\149\176\229\161\171UIWindowNames\230\158\154\228\184\190\229\175\185\229\186\148\231\154\132\229\133\183\228\189\147\229\128\188",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIAllianceStar/zyf_tongmengzhixing_youjianyouhua_icon.png",
  get = function()
    return "UISurfingBattleResult"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("UI\229\144\141\231\167\176\228\184\186\231\169\186\239\188\129")
      return
    end
    GMUtils.Close()
    UIManager:GetInstance():OpenWindow(val, {anim = true})
  end,
  btnName = "Open!",
  contentType = 1
})
config:Add({
  name = "\229\177\149\231\164\186\232\139\177\233\155\132\231\153\187\229\156\186\239\188\140\230\160\188\229\188\143\228\184\186 heroId;appearanceId\227\128\130\228\190\139\229\166\130: 50009;50009",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_bingzhong_3.png",
  get = function()
    return "50009;50009"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if string.IsNullOrEmpty(val) then
      UIUtil.ShowTips("\232\190\147\229\133\165\228\184\186\231\169\186\239\188\129")
      return
    end
    GMUtils.Close()
    local params = string.split(val, ";")
    if string.IsNullOrEmpty(params[1]) then
      UIUtil.ShowTips("\232\139\177\233\155\132id\228\184\186\231\169\186\239\188\129")
      return
    end
    if string.IsNullOrEmpty(params[2]) then
      UIUtil.ShowTips("\229\164\150\232\167\130id\228\184\186\231\169\186\239\188\129")
      return
    end
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UIHeroExhibitPanel, {anim = false}, {
      heroId = params[1],
      appearanceId = params[2],
      isGM = true
    }, {
      params[1]
    }, nil, true)
  end,
  btnName = "\229\177\149\231\164\186!",
  contentType = 1
})
config:Add({
  name = "\229\177\149\231\164\186\228\184\187\229\174\176",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_bingzhong_3.png",
  get = function()
    return 1000005
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local rankTemplate = DataCenter.DominatorTemplateManager:GetRankTemplateById(val)
    if rankTemplate then
      local param = {
        curRankShowTemplate = rankTemplate:GetRankShowTemplate()
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorUpgradeBigRank, {anim = false}, param)
      GMUtils.Close()
    end
  end,
  btnName = "\229\177\149\231\164\186!",
  contentType = 1
})
config:Add({
  name = "\230\146\173\230\148\190\228\184\128\230\174\181\229\137\167\230\131\133\229\175\185\232\175\157\239\188\129",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_language.png",
  get = function()
    return "2013"
  end,
  set = function(val)
  end,
  onClicked = function(val)
    if not string.IsNullOrEmpty(val) then
      GMUtils.Close()
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = tonumber(val),
        hideMainUI = true
      })
    else
      UIUtil.ShowTips("\230\178\161\230\156\137\232\190\147\229\133\165\230\131\179\230\146\173\231\154\132\229\175\185\232\175\157\239\188\129")
    end
  end,
  btnName = "\229\188\128\230\146\173",
  contentType = 1
})
config:Add({
  name = "\232\191\155\229\133\165\232\139\177\233\155\132\232\175\149\231\148\168\229\133\179\229\141\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_bingzhong_3.png",
  get = function()
    return 0
  end,
  set = function(val)
  end,
  onClicked = function(val)
    GMUtils.Close()
    DataCenter.HeroTryOutManager:EnterBattle(tonumber(val))
  end,
  btnName = "\232\191\155\229\133\165",
  contentType = 1
})
config:Add({
  name = "\230\137\147\229\141\176\233\130\174\228\187\182\230\149\176\230\141\174\n(MailDataManager)",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_youjian.png",
  onClicked = function()
    local mailMgr = DataCenter.MailDataManager
    if not mailMgr then
      UIUtil.ShowTips("MailDataManager \228\184\141\229\173\152\229\156\168")
      return
    end
    local output = {}
    table.insert(output, "========== \233\130\174\228\187\182\230\149\176\230\141\174\231\174\161\231\144\134\229\153\168 ==========")
    table.insert(output, string.format("mailList \230\149\176\233\135\143: %d", mailMgr.mailList and #mailMgr.mailList or 0))
    table.insert(output, string.format("lastUid: %s", mailMgr.lastUid or "nil"))
    table.insert(output, string.format("lastTime: %s", mailMgr.lastTime or 0))
    table.insert(output, string.format("pullOver: %s", mailMgr.pullOver and "true" or "false"))
    table.insert(output, string.format("initUnrewardCountSuccess: %s", mailMgr.initUnrewardCountSuccess and "true" or "false"))
    if mailMgr.group then
      table.insert(output, "---------- \229\136\134\231\187\132\228\191\161\230\129\175 ----------")
      for groupId, group in pairs(mailMgr.group) do
        if group and group.mailList then
          local unread = group.GetUnreadCount and group:GetUnreadCount() or group.unreadCount or 0
          local unreward = group.GetUnrewardCount and group:GetUnrewardCount() or group.unrewardCount or 0
          table.insert(output, string.format("group[%d]: mailList=%d, unread=%d, unreward=%d", groupId, #group.mailList, unread, unreward))
        end
      end
    end
    if mailMgr.mailList then
      local typeCount = {}
      local statusCount = {unread = 0, read = 0}
      local rewardCount = {unreward = 0, reward = 0}
      for _, mail in pairs(mailMgr.mailList) do
        if mail then
          local t = mail.type or 0
          typeCount[t] = (typeCount[t] or 0) + 1
          if mail.status == 0 then
            statusCount.unread = statusCount.unread + 1
          else
            statusCount.read = statusCount.read + 1
          end
          if mail.rewardStatus == 0 then
            rewardCount.unreward = rewardCount.unreward + 1
          else
            rewardCount.reward = rewardCount.reward + 1
          end
        end
      end
      table.insert(output, "---------- \233\130\174\228\187\182\231\177\187\229\158\139\231\187\159\232\174\161 ----------")
      for t, cnt in pairs(typeCount) do
        table.insert(output, string.format("type[%d]: %d \229\176\129", t, cnt))
      end
      table.insert(output, "---------- \232\175\187/\230\156\170\232\175\187\231\187\159\232\174\161 ----------")
      table.insert(output, string.format("\230\156\170\232\175\187: %d, \229\183\178\232\175\187: %d", statusCount.unread, statusCount.read))
      table.insert(output, "---------- \229\165\150\229\138\177\231\187\159\232\174\161 ----------")
      table.insert(output, string.format("\230\156\137\229\165\150\229\138\177\230\156\170\233\162\134\229\143\150: %d, \229\183\178\233\162\134\229\143\150/\230\151\160\229\165\150\229\138\177: %d", rewardCount.unreward, rewardCount.reward))
      table.insert(output, "---------- \233\130\174\228\187\182\232\175\166\230\131\133(\229\137\14110\229\176\129) ----------")
      local idx = 0
      for uid, mail in pairs(mailMgr.mailList) do
        if 10 <= idx then
          break
        end
        table.insert(output, string.format("[%d] uid=%s, type=%d, status=%s, reward=%s, title=%s", idx + 1, tostring(uid), mail.type or 0, mail.status == 0 and "\230\156\170\232\175\187" or "\229\183\178\232\175\187", mail.rewardStatus == 0 and "\230\156\170\233\162\134\229\143\150" or "\229\183\178\233\162\134", mail.title or ""))
        idx = idx + 1
      end
    end
    table.insert(output, "========== \230\137\147\229\141\176\231\187\147\230\157\159 ==========")
    local logStr = table.concat(output, "\n")
    Logger.LogError(logStr)
    UIUtil.ShowTips("\233\130\174\228\187\182\230\149\176\230\141\174\229\183\178\230\137\147\229\141\176\229\136\176\230\151\165\229\191\151\233\157\162\230\157\191")
  end,
  btnName = "\230\137\147\229\141\176"
})
return config
