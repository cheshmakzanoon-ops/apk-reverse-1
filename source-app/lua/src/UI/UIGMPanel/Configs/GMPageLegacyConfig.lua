local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("LegacyDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 1000
config.label = "\228\189\156\229\188\138\232\174\190\231\189\174"
config.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_tishibiao.png"
config:Add({
  name = "\230\191\128\230\180\187GUI\230\140\137\233\146\174\231\187\132",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png",
  get = function()
    return GMUtils.GetBool(GMConst.EnableLegacyToggle, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.EnableLegacyToggle, val)
  end
})
config:Add({
  name = "\227\128\144\230\136\152\230\156\175\229\141\161\231\137\140\227\128\145\232\142\183\229\190\151\228\184\128\230\137\185\229\141\161\229\140\133",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    local allGoodIdList = {
      405001,
      405002,
      405003,
      405004
    }
    local S6CardGroupList = {
      407001,
      407002,
      407003,
      407004,
      407006,
      407007,
      407008
    }
    if SeasonUtil.GetSeason() >= 6 then
      allGoodIdList = table.mergeArray(allGoodIdList, S6CardGroupList)
    end
    for index, v in ipairs(allGoodIdList) do
      TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, tostring(v), 9999)
      end, 0.1 * index)
    end
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144\230\136\152\230\156\175\229\141\161\231\137\140\227\128\145\229\136\183\230\150\176\230\137\128\230\156\137\229\141\161\229\134\183\229\141\180",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GmBattleCard, "resetRemainTimes")
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\230\191\128\230\180\187T11\232\135\170\229\138\168\229\141\135\231\186\167",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png",
  get = function()
    return GMUtils.GetBool(GMConst.EnableT11AutoUpgrade, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.EnableT11AutoUpgrade, val)
  end
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\233\135\141\231\189\174T11\229\133\187\230\136\144\232\191\155\229\186\166",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GmSoldierEleven, "reset")
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\229\189\147\229\137\141\233\152\182\229\141\135\232\135\179100%\232\191\155\229\186\166<color=red>(\228\188\154\233\135\141\231\189\174\230\137\128\233\128\137\229\133\181\231\167\141)</color>",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    local allStageMaxIdDic = {
      [0] = 14100,
      [1] = 24100,
      [2] = 34050,
      [3] = 44050,
      [4] = 54050
    }
    local curStage = T11Util.GetCurStage() or 0
    if table.containsKey(allStageMaxIdDic, curStage) then
      SFSNetwork.SendMessage(MsgDefines.GmSoldierEleven, "setProgress", allStageMaxIdDic[curStage])
      TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.SoldierElevenChange, T11SoldierType.T11SoldierTypeA)
      end, 1)
      TimerManager:GetInstance():DelayInvoke(function()
        EventManager:GetInstance():Broadcast(EventId.T11ResearchStateUpdate)
      end, 2)
    else
      UIUtil.ShowTipsId("operate_notice_10004")
    end
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\232\174\190\231\189\174\232\135\179\230\187\161\231\186\167\229\190\133\231\170\129\231\160\180\231\138\182\230\128\129<color=red>(\228\188\154\233\135\141\231\189\174\230\137\128\233\128\137\229\133\181\231\167\141)</color>",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GmSoldierEleven, "setProgress", 54050)
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.SoldierElevenChange, T11SoldierType.T11SoldierTypeA)
    end, 1)
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.T11ResearchStateUpdate)
    end, 2)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\232\174\190\231\189\174\229\136\176\230\140\135\229\174\154\232\191\155\229\186\166<color=red>(\228\188\154\233\135\141\231\189\174\230\137\128\233\128\137\229\133\181\231\167\141)</color>",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 54050
  end,
  set = function(val)
  end,
  onClicked = function(targetProgressId)
    if not targetProgressId then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.GmSoldierEleven, "setProgress", targetProgressId)
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.SoldierElevenChange, T11SoldierType.T11SoldierTypeA)
    end, 1)
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.T11ResearchStateUpdate)
    end, 2)
  end,
  contentType = 0,
  btnName = "\232\174\190\231\189\174\232\191\155\229\186\166"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\233\135\141\231\189\174\233\128\137\229\133\181\231\167\141\229\134\183\229\141\180",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GmSoldierEleven, "clearCd")
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\228\184\128\233\148\174\229\162\158\229\138\160\229\141\135\231\186\167\230\137\128\233\156\128\230\157\144\230\150\153",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "801000", 99999999)
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "801001", 99999999)
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, ResourceType.Petroleum, 99999999, nil, nil, nil, nil)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144T11\227\128\145\n\230\137\139\229\138\168\232\167\166\229\143\145T11\229\188\149\229\175\188",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 5302
  end,
  set = function(val)
  end,
  onClicked = function(targeGuideFlowId)
    DataCenter.LWGuideFlowManager:TryTriggerFlow(toInt(targeGuideFlowId))
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190\229\188\149\229\175\188"
})
config:Add({
  name = "\227\128\144\232\138\130\230\151\165\232\138\177\232\189\166\227\128\145\n\229\162\158\229\138\160\232\138\130\230\151\165\232\138\177\232\189\166&&\229\138\169\229\168\129\233\129\147\229\133\183",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "654201", 99999999)
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "654200", 99999999)
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "654227", 99999999)
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, "654226", 99999999)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\227\128\144\232\138\130\230\151\165\232\138\177\232\189\166\227\128\145\n\230\148\190\231\189\174\228\184\128\228\184\170\233\154\143\230\156\186\232\138\177\232\189\166\233\129\147\229\133\183",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    if SceneUtils.CheckCanGotoWorld() then
      SceneUtils.ChangeToWorld(function()
        local randomList = {654201, 654227}
        local goodsId = randomList[math.random(1, #randomList)]
        local pointId = LuaEntry.Player:GetMainWorldPos()
        if not CS.SceneManager.IsInCity() then
          local center = Vector3.New(Screen.width / 2, Screen.height / 2, 0)
          local worldPos = CS.SceneManager.World:ScreenPointToWorld(center)
          pointId = SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World)
        end
        local flowerTrainPrefabPath = FlowerTrainUtils.GetFlowerTrainPrefabPathByGoodsId(goodsId)
        CS.SceneManager.World:UICreateWorldFlowerTrain(flowerTrainPrefabPath, pointId, goodsId)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
      end)
    end
  end,
  contentType = 0,
  btnName = "\230\148\190\231\189\174"
})
config:Add({
  name = "\227\128\144\232\138\130\230\151\165\232\138\177\232\189\166\227\128\145\n\230\148\190\231\189\174\228\184\128\228\184\170\229\136\171\228\186\186\231\154\132\233\154\143\230\156\186\232\138\177\232\189\166",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_kuafuqiancheng_keqian.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    local randomList = {654201, 654227}
    local goodsId = randomList[math.random(1, #randomList)]
    local pointId = LuaEntry.Player:GetMainWorldPos()
    local senderUid = LuaEntry.Player:GetUid()
    local allAllianceMember = DataCenter.AllianceMemberDataManager:GetAllMember()
    for _, v in pairs(allAllianceMember) do
      if v.uid ~= LuaEntry.Player:GetUid() then
        senderUid = v.uid
        break
      end
    end
    SFSNetwork.SendMessage(MsgDefines.FlowerTrainSendGm, pointId, goodsId, senderUid)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\230\148\190\231\189\174"
})
config:Add({
  name = "\227\128\144\232\138\130\230\151\165\232\138\177\232\189\166\227\128\145\n\230\191\128\230\180\187\232\182\133\231\186\167\229\138\169\229\168\129",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmSettings.png",
  get = function()
    return GMUtils.GetBool(GMConst.FlowerTrainSuperCheerModeEnable, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.FlowerTrainSuperCheerModeEnable, val)
  end
})
config:Add({
  name = "\229\162\158\229\138\160\230\140\135\229\174\154\233\129\147\229\133\183",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  get = function()
    return nil
  end,
  set = function(val)
  end,
  onClicked = function(goodsId)
    if not goodsId then
      Logger.LogError("goodsId is nil!")
      return
    end
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, tostring(goodsId), 99999999)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\181\139\232\175\149\230\137\147\229\188\128\233\153\144\230\151\182\230\142\137\232\144\189\230\143\144\231\164\186",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    local fakeServerData = {}
    fakeServerData.activityId = 99156
    fakeServerData.dayGroupCurNum = 33
    fakeServerData.dayGroupLimit = 2082
    fakeServerData.itemId = 654189
    fakeServerData.serverTime = 1762063693756
    DataCenter.ActLimitedTimeFeastData:OpenLimitDropTipView(fakeServerData)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\181\139\232\175\149\230\137\147\229\188\128\233\153\144\230\151\182\230\142\137\232\144\189\230\151\165\229\191\151",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    TimerManager:GetInstance():DelayInvoke(function()
      local activityId = 99171
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILimitDropHistory, {anim = false}, activityId)
    end, 1)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\137\147\229\188\128\232\138\177\232\189\166\231\187\147\231\174\151\231\149\140\233\157\162(\229\129\135\230\149\176\230\141\174)",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    local playerSelfFlowerTrainDic = DataCenter.FlowerTrainDataManager.playerSelfFlowerTrainDic
    if not playerSelfFlowerTrainDic or table.count(playerSelfFlowerTrainDic) <= 0 then
      UIUtil.ShowTips("\229\133\136\229\143\145\228\184\128\228\184\170\232\138\177\232\189\166\229\144\167,\233\128\160\229\129\135\230\149\176\230\141\174\233\156\128\232\166\129")
      return
    end
    local tempTrainList = {}
    for _, trainData in pairs(playerSelfFlowerTrainDic) do
      table.insert(tempTrainList, trainData)
    end
    local index = math.random(1, table.count(playerSelfFlowerTrainDic))
    local trainData = tempTrainList[index]
    local params = {}
    params.reward = {}
    params.trainData = trainData
    params.topPlayerArr = {}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainArrived, {anim = true}, params)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\137\147\229\188\128\231\150\175\231\139\130\230\145\135\230\187\154\229\188\149\229\175\188\233\161\181",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  onClicked = function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockRulesGamePlay, {anim = true})
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\131\133\228\186\186\232\138\130\230\183\187\229\138\160\228\186\146\231\155\184\229\133\179\230\179\168GM",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  get = function()
    return nil
  end,
  set = function(val)
  end,
  onClicked = function(num)
    if not num then
      Logger.LogError("num is nil")
      return
    end
    local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActValentineSendGift.Type)
    if not actData then
      Logger.LogError("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175")
    end
    local activityId = actData.activityId
    local uid = LuaEntry.Player:GetUid()
    SFSNetwork.SendMessage(MsgDefines.ValentineFollowGm, {
      activityId = activityId,
      uid = uid,
      num = tonumber(num)
    })
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\230\146\173\230\148\190\230\140\135\229\174\154\232\183\175\229\190\132\229\133\168\229\177\143\232\167\134\233\162\145",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  get = function()
    return nil
  end,
  set = function(val)
  end,
  onClicked = function(path)
    local params = {}
    params.path = path or "Assets/Main/Video/v35_CG.mp4"
    UIManager:GetInstance():OpenWindow(UIWindowNames.FullScreenVideoView, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide,
      hideTop = true
    }, params)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\232\181\155\229\173\163\231\136\172\229\161\148\230\137\171\232\141\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  get = function()
    return nil
  end,
  set = function(val)
  end,
  onClicked = function(num)
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISeasonTowerMain) then
      UIUtil.ShowTipsId("\233\156\128\232\166\129\229\156\168\232\181\155\229\173\163\229\161\148\228\184\187\231\149\140\233\157\162\228\189\191\231\148\168\227\128\130")
      return
    end
    if type(tonumber(num)) ~= "number" then
      UIUtil.ShowTipsId("\229\143\130\230\149\176\230\152\175\230\149\176\229\173\151\227\128\130")
      return
    end
    DataCenter.LWSeasonTowerSceneManager:ShowReadyEffect()
    TimerManager:GetInstance():DelayInvoke(function()
      local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
      local result, resultFloor = LWSeasonTowerUtil.GetEffectShowListByNum(tonumber(num))
      DataCenter.LWSeasonTowerSceneManager:PlayEffect(result, resultFloor)
      local stage = DataCenter.LWSeasonTowerManager:GetSelectStage()
      stage.floor = stage.floor + tonumber(num)
    end, 3)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\231\161\174\229\174\154"
})
config:Add({
  name = "\232\181\155\229\173\163\231\136\172\229\161\148\233\128\159\229\186\166\228\191\174\230\148\185\239\188\140\232\190\147\229\133\165 \230\161\163\228\189\141|\230\151\182\233\151\180\239\188\140\229\166\130 1|1.1",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  tips = nil,
  get = function()
    return nil
  end,
  set = function(val)
  end,
  onClicked = function(num)
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISeasonTowerMain) then
      UIUtil.ShowTipsId("\233\156\128\232\166\129\229\156\168\232\181\155\229\173\163\229\161\148\228\184\187\231\149\140\233\157\162\228\189\191\231\148\168\227\128\130")
      return
    end
    local tab = string.split(num, "|")
    local logic = DataCenter.LWSeasonTowerSceneManager.logic
    logic:SetConfigSpeed(tonumber(tab[1]), tonumber(tab[2]))
    UIUtil.ShowTipsId("\232\174\190\231\189\174\230\136\144\229\138\159\227\128\130")
  end,
  btnName = "\231\161\174\229\174\154"
})
return config
