local FlowerTrainUtils = {}
local FETCH_HISTORY_DELTA_TIME = 0
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")
local Localization = CS.GameEntry.Localization
local WorldTriggerUtil = require("Util.WorldTriggerUtil")

function FlowerTrainUtils.GetFlowerTrainMetaId(group, lv)
  return group * 1000 + lv
end

function FlowerTrainUtils.GetFlowerTrainLvMeta(group, lv)
  local metaId = FlowerTrainUtils.GetFlowerTrainMetaId(group, lv)
  return DataCenter.FlowerTrainDataManager:GetFlowerTrainLvMeta(metaId)
end

function FlowerTrainUtils.GetFlowerLvGroupByGoodsId(goodsId)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerLvGroupByGoodsId itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local group = toInt(itemMeta.serverPara1)
  return group
end

function FlowerTrainUtils.GetFlowerTrainLvDataByGoodsId(goodsId, lv)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainLvDataByGoodsId itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local group = toInt(itemMeta.serverPara1)
  local paraId = toInt(itemMeta.serverPara2)
  if not paraId then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainLvDataByGoodsId paraId is nil, goodsId: " .. goodsId)
    return nil
  end
  if not lv or lv < 0 then
    lv = FlowerTrainUtils.GetFlowerTrainInitLvByParaId(paraId)
  end
  local flowerTrainLvMetaId = FlowerTrainUtils.GetFlowerTrainMetaId(group, lv)
  local meta = DataCenter.FlowerTrainDataManager:GetFlowerTrainLvMeta(flowerTrainLvMetaId)
  if not meta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainLvDataByGoodsId meta is nil, goodsId: " .. goodsId)
    return nil
  end
  return meta
end

function FlowerTrainUtils.GetFlowerTrainInitLvByParaId(paraId)
  local configMeta = FlowerTrainUtils.GetFlowerTrainConfigMetaByParaId(paraId)
  if not configMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainInitLvByParaId configMeta is nil, paraId: " .. paraId)
    return 1
  end
  return configMeta.init_level or 1
end

function FlowerTrainUtils.GetFlowerTrainConfigMetaByGoodsId(goodsId)
  local paraId = FlowerTrainUtils.GetFlowerTrainParaIdByGoodsId(goodsId)
  return FlowerTrainUtils.GetFlowerTrainConfigMetaByParaId(paraId)
end

function FlowerTrainUtils.GetFlowerTrainParaIdByGoodsId(goodsId)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainParaIdByGoodsId itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local paraId = toInt(itemMeta.serverPara2)
  return paraId
end

function FlowerTrainUtils.GetFlowerTrainConfigMetaByParaId(paraId)
  local meta = DataCenter.FlowerTrainDataManager:GetFlowerTrainParaMeta(paraId)
  if not meta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainConfigMetaByParaId meta is nil, paraId: " .. paraId)
    return nil
  end
  local configId = meta.common_id
  if not configId then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainInitLvByParaId configId is nil, paraId: " .. paraId)
    return nil
  end
  return DataCenter.FlowerTrainDataManager:GetFlowerTrainConfigMeta(configId)
end

function FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(goodsId, lv)
  local trainLvMeta = FlowerTrainUtils.GetFlowerTrainLvDataByGoodsId(goodsId, lv)
  if not trainLvMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainDisplayMetaByGoodsId trainLvMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local displayMetaId = trainLvMeta.show_id
  if not displayMetaId then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainDisplayMetaByGoodsId displayMetaId is nil, goodsId: " .. goodsId)
    return nil
  end
  return DataCenter.FlowerTrainDataManager:GetFlowerTrainDisplayMeta(displayMetaId)
end

function FlowerTrainUtils.GetFlowerTrainPrefabPathByGoodsId(goodsId, lv)
  local displayMeta = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(goodsId, lv)
  if not displayMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainPrefabPathByGoodsId displayMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  return displayMeta.prefab
end

function FlowerTrainUtils.IsCanPlaceFlowerTrain(isShowTips)
  local isInBattleField = BattleFieldUtil.InBattleField()
  if isInBattleField then
    if isShowTips then
      UIUtil.ShowTipsId("458287")
    end
    return false, FlowerTrainOperateFailReason.InBattleField
  end
  if not LuaEntry.Player:IsInSourceServer() then
    if isShowTips then
      UIUtil.ShowTipsId("500019")
    end
    return false, FlowerTrainOperateFailReason.NotInSourceServer
  end
  return true
end

function FlowerTrainUtils.IsCrossSeasonPlaceNow(goodsId)
  local nextSeasonStartTime = DataCenter.SeasonDataManager:GetNextSeasonStartTime()
  if nextSeasonStartTime <= 0 then
    return false
  end
  local paraCfg = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(goodsId)
  if not paraCfg then
    return false
  end
  local maxLvNeedTime = 0
  if paraCfg.init_time then
    maxLvNeedTime = maxLvNeedTime + toInt(paraCfg.init_time)
  end
  if paraCfg.time_para then
    local tmpArr1 = string.split(paraCfg.time_para, "|")
    for _, v in ipairs(tmpArr1) do
      local tmpArr2 = string.split(v, ";")
      local needTime = toInt(tmpArr2[2])
      maxLvNeedTime = maxLvNeedTime + needTime
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local expectedMaxLvTime = now + maxLvNeedTime * 1000
  if nextSeasonStartTime < expectedMaxLvTime then
    return true
  end
  return false
end

function FlowerTrainUtils.CalculateFlowerTrainPoint(prevPoint, nextPoint, nextNextPoint, lerpValue)
  local prevPointWorldPos = SceneUtils.TileIndexToWorld(prevPoint, ForceChangeScene.World)
  local nextPointWorldPos = SceneUtils.TileIndexToWorld(nextPoint, ForceChangeScene.World)
  return Vector3.Lerp(prevPointWorldPos, nextPointWorldPos, lerpValue)
end

function FlowerTrainUtils.ParseRewardStr(str)
  local rewardCfgList = string.string2array_i(str, ";", "|")
  local showRewardData = {}
  for i = 1, #rewardCfgList do
    local tmpShowData = {}
    if rewardCfgList[i][1] == 1 then
      tmpShowData = {
        rewardType = ResTypeToReward[rewardCfgList[i][2]],
        count = rewardCfgList[i][3]
      }
    else
      tmpShowData = {
        rewardType = rewardCfgList[i][1],
        itemId = rewardCfgList[i][2],
        count = rewardCfgList[i][3]
      }
    end
    table.insert(showRewardData, tmpShowData)
  end
  return showRewardData
end

function FlowerTrainUtils.GetItemDropProbCfgDic(goodsId)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetItemDropProbCfgDic itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local paraId = toInt(itemMeta.serverPara2)
  if not paraId then
    Logger.LogError("FlowerTrainUtils:GetItemDropProbCfgDic paraId is nil, goodsId: " .. goodsId)
    return nil
  end
  local meta = DataCenter.FlowerTrainDataManager:GetFlowerTrainParaMeta(paraId)
  if meta == nil then
    return
  end
  return DataCenter.FlowerTrainDataManager:GetItemDropProbCfgByDropShowId(meta.drop_group)
end

function FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(goodsId)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainParaMetaByGoodsId itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local paraId = toInt(itemMeta.serverPara2)
  if not paraId then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainParaMetaByGoodsId paraId is nil, goodsId: " .. goodsId)
    return nil
  end
  return DataCenter.FlowerTrainDataManager:GetFlowerTrainParaMeta(paraId)
end

function FlowerTrainUtils.GetFlowerTrainFireImgPathByGoodsId(goodsId, curExp)
  local paraId = FlowerTrainUtils.GetFlowerTrainParaIdByGoodsId(goodsId)
  local expFireConfigList = FlowerTrainUtils.ParesExpFireImgPath(paraId)
  return FlowerTrainUtils.GetExpFireImgPath(expFireConfigList, curExp)
end

function FlowerTrainUtils.GetExpFireImgPath(expFireConfigList, curExp)
  local fireImgPath = ""
  local curIndex = 1
  for index, config in ipairs(expFireConfigList) do
    if curExp < config.exp then
      break
    end
    fireImgPath = config.path
    curIndex = index
  end
  return tostring(fireImgPath), curIndex
end

function FlowerTrainUtils.ParesExpFireImgPath(paraId)
  local expFireConfigList = {}
  local trainParaMeta = DataCenter.FlowerTrainDataManager:GetFlowerTrainParaMeta(paraId)
  if not trainParaMeta then
    Logger.LogError("FlowerTrainUtils:ParesExpFireImgPath trainParaMeta is nil")
    return expFireConfigList
  end
  local configStrList = trainParaMeta.exp_pic_list
  if #configStrList < 2 then
    Logger.LogError("FlowerTrainUtils:ParesExpFireImgPath configStrList is less than 2")
    return expFireConfigList
  end
  local publicPath = configStrList[1]
  for i = 2, #configStrList do
    local info = string.split(configStrList[i], "|")
    if #info == 2 then
      local needExp = toInt(info[1])
      local fireImg = info[2]
      local fullPath = publicPath .. fireImg
      table.insert(expFireConfigList, {exp = needExp, path = fullPath})
    end
  end
  return expFireConfigList
end

function FlowerTrainUtils.ParseFlowerTrainCheerReward(info)
  if not info then
    Logger.LogError("FlowerTrainUtils:ParseFlowerTrainCheerReward info is nil")
    return {}
  end
  local customInfoStr = info.customInfoStr
  local rewardInfoList = string.split(customInfoStr, "_")
  if #rewardInfoList < 4 then
    Logger.LogError("FlowerTrainUtils:ParseFlowerTrainCheerReward rewardInfoList is less than 4, customInfoStr: " .. customInfoStr)
    return {}
  end
  local ret = {}
  ret.info = info
  ret.isSelf = LuaEntry.Player.uid == info.ownerUid
  ret.TrainUuid = rewardInfoList[1]
  ret.worldTreasureId = toInt(rewardInfoList[2])
  ret.goodsId = toInt(rewardInfoList[3])
  ret.flowerTrainLv = toInt(rewardInfoList[4])
  ret.boxUuid = info.uuid
  ret.ownerName = info.ownerName
  ret.abbr = info.allianceAbbr
  ret.pointId = info.fromPoint
  ret.abbrName = UIUtil.FormatAllianceAndName(info.allianceAbbr, info.ownerName)
  return ret
end

function FlowerTrainUtils.IsFlowerTrainLvBoxReward(msg)
  if not msg then
    return false
  end
  if not msg.cfgId then
    return false
  end
  local treasureId = msg.cfgId
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, treasureId)
  if not giftMeta then
    return false
  end
  local treasureType = giftMeta.type
  return treasureType == WorldTreasureType.FlowerTrainUpgradeTreasure
end

function FlowerTrainUtils.IsFlowerTrainCheerReward(msg)
  if not msg then
    return false
  end
  if not msg.cfgId then
    return false
  end
  local treasureId = msg.cfgId
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, treasureId)
  if not giftMeta then
    return false
  end
  local treasureType = giftMeta.type
  return treasureType == WorldTreasureType.FlowerTrainCheerTreasure
end

function FlowerTrainUtils.GetFlowerTrainConfigByGoodsId(goodsId)
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not itemMeta then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainLvDataByGoodsId itemMeta is nil, goodsId: " .. goodsId)
    return nil
  end
  local paraId = toInt(itemMeta.serverPara2)
  if not paraId then
    Logger.LogError("FlowerTrainUtils:GetFlowerTrainLvDataByGoodsId paraId is nil, goodsId: " .. goodsId)
    return nil
  end
  local configMeta = FlowerTrainUtils.GetFlowerTrainConfigMetaByParaId(paraId)
  return configMeta
end

function FlowerTrainUtils:IsExistAnySelfFlowerTrainArrived()
  local allArrivedFlowerTrainDataList = DataCenter.FlowerTrainDataManager:GetPlayerAllArrivedFlowerTrainDataList()
  if not allArrivedFlowerTrainDataList or #allArrivedFlowerTrainDataList <= 0 then
    return false
  end
  return true
end

function FlowerTrainUtils.IsExistSelfFlowerTrainArrived(itemId)
  local allArrivedFlowerTrainDataList = DataCenter.FlowerTrainDataManager:GetPlayerAllArrivedFlowerTrainDataList()
  if not allArrivedFlowerTrainDataList or #allArrivedFlowerTrainDataList <= 0 then
    return false
  end
  for _, v in pairs(allArrivedFlowerTrainDataList) do
    if tostring(v.fromGoodsId) == tostring(itemId) then
      return true
    end
  end
  return false
end

function FlowerTrainUtils.IsExistAnySelfFlowerTrain()
  local allFlowerTrainDataList = DataCenter.FlowerTrainDataManager:GetPlayerAllFlowerTrainDataList()
  if not allFlowerTrainDataList or #allFlowerTrainDataList <= 0 then
    return false
  end
  return true
end

function FlowerTrainUtils.GetNeedShowFlowerTrainBubbleIconPath()
  if not FlowerTrainUtils.IsExistAnySelfFlowerTrain() then
    return false
  end
  local allFlowerTrainDataList = DataCenter.FlowerTrainDataManager:GetPlayerAllFlowerTrainDataList()
  local firstFlowerTrainData = allFlowerTrainDataList[1]
  local tipBubbleIconPath = firstFlowerTrainData:GetTipBubbleIconPath()
  if not tipBubbleIconPath or tipBubbleIconPath == "" then
    return nil
  end
  return tipBubbleIconPath
end

function FlowerTrainUtils.JumpToFlowerTrainByMarchUuid(marchUuid, serverId, worldId)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if marchUuid and type(marchUuid) == "number" and 0 < marchUuid then
    SFSNetwork.SendMessage(MsgDefines.GetMarchPos, serverId, worldId, marchUuid, NewMarchType.FLOWER_TRAIN)
  else
    UIUtil.ShowTipsId("not departed yet!")
  end
end

function FlowerTrainUtils.GetFlowerTrainLikeCount(goodsId)
  return DataCenter.FlowerTrainDataManager:GetCurInteractionCount(goodsId, FlowerTrainInteractiveType.Like)
end

function FlowerTrainUtils.GetFlowerTrainCheerCount(goodsId)
  return DataCenter.FlowerTrainDataManager:GetCurInteractionCount(goodsId, FlowerTrainInteractiveType.Cheer)
end

function FlowerTrainUtils.GetFlowerTrainClaimLvBoxCount(goodsId)
  return DataCenter.FlowerTrainDataManager:GetCurInteractionCount(goodsId, FlowerTrainInteractiveType.ClaimLvLvBox)
end

function FlowerTrainUtils.GetFlowerTrainWorldTreasureMeta(goodsId, lv)
  local lvMeta = FlowerTrainUtils.GetFlowerTrainLvDataByGoodsId(goodsId, lv)
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, lvMeta.gift_1_group)
  return giftMeta
end

function FlowerTrainUtils.GetFlowerTrainWorldTreasureMetaDailyMax(goodsId, lv)
  local giftMeta = FlowerTrainUtils.GetFlowerTrainWorldTreasureMeta(goodsId, lv)
  if giftMeta == nil then
    return 0
  end
  return giftMeta.daily_max
end

local lastFetchHistoryTime

function FlowerTrainUtils.ShowRecentlyLikeAndCheers()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if lastFetchHistoryTime and curTime < lastFetchHistoryTime + FETCH_HISTORY_DELTA_TIME then
    return
  end
  lastFetchHistoryTime = curTime
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainFromPraiseInfo)
end

function FlowerTrainUtils.GetFlowerTrainLodIcon(marchUuid, index)
  local groupData = DataCenter.FlowerTrainDataManager:GetFlowerTrainGroupDataByMarchUuid(marchUuid)
  if not groupData then
    return ""
  end
  local firstSingleTrainData = groupData:GetFirstSingleTrainData()
  if not firstSingleTrainData then
    return ""
  end
  return firstSingleTrainData:GetWorldLodIconPath()
end

function FlowerTrainUtils.GetCheerActorExistDuration()
  return 1000 * (FlowerTrainConstant.FlowerTrainDropTime + FlowerTrainConstant.FlowerTrainCheerRunTime + FlowerTrainConstant.FlowerTrainCheerAniTime)
end

function FlowerTrainUtils.GetPlayerAllRunningFlowerTrainCount()
  local allRunningFlowerTrainDataList = DataCenter.FlowerTrainDataManager:GetPlayerAllRunningFlowerTrainDataList()
  return allRunningFlowerTrainDataList and #allRunningFlowerTrainDataList or 0
end

function FlowerTrainUtils.IsInCDForClaimLvBox(isShowTips)
  local lastClaimTime = DataCenter.FlowerTrainDataManager:GetLastClaimBoxRewardTime()
  if not lastClaimTime then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local cdTime = LuaEntry.DataConfig:TryGetNum("festival_treasure_box_get_config", "k1", 5000)
  local passTime = now - lastClaimTime
  local isInCD = cdTime >= passTime
  if isInCD and isShowTips then
    local remainTime = Mathf.Max(cdTime - passTime, 0) / 1000
    UIUtil.ShowTips(Localization:GetString("activity_treasurebox_tipsdesc2", math.ceil(remainTime)))
  end
  return isInCD
end

function FlowerTrainUtils.IsCanPutDownBySize(size, index, theServerId)
  local points = WorldTriggerUtil.GetPointsBySizeAndIndex(size, index)
  for k, v in pairs(points) do
    local putState = FlowerTrainUtils.IsCanPutDownByPoint(v, theServerId)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

function FlowerTrainUtils.IsCanPutDownByPoint(index, theServerId)
  local theWorld = CS.SceneManager.World
  if theWorld:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if SceneUtils.IsInBlackRange(index) then
    return BuildPutState.InBlackLandRange
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(theServerId)
  return BuildingUtils.IsCanPutDownInWorldByPoint(index, ResourceType.None, false, theWorld, isInSeason, true, theServerId)
end

function FlowerTrainUtils.ShowFlyReward(rewardDataList, rewardContentRoot)
  if not rewardDataList or not rewardContentRoot then
    return
  end
  if rewardDataList ~= nil and table.count(rewardDataList) > 0 then
    local count = math.min(#rewardDataList, rewardContentRoot.transform.childCount)
    for i = 1, count do
      local child = rewardContentRoot.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
      local pic = DataCenter.RewardManager:GetPicByType(rewardDataList[i].rewardType, rewardDataList[i].itemId)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(rewardDataList[i].rewardType, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
    end
  end
end

function FlowerTrainUtils.ShowFlyRewardSimple(rewardDataList, worldPos)
  if not rewardDataList or #rewardDataList <= 0 then
    return
  end
  if rewardDataList ~= nil and 0 < table.count(rewardDataList) then
    for i = 1, #rewardDataList do
      local pic = DataCenter.RewardManager:GetPicByType(rewardDataList[i].rewardType, rewardDataList[i].itemId)
      local flyPos = Vector3.New(0, 0, 0)
      worldPos = worldPos or CS.GameEntry.UIContainer.transform.position
      UIUtil.DoFly(rewardDataList[i].rewardType, 2, pic, worldPos, flyPos, 100, 100)
    end
  end
end

function FlowerTrainUtils.SuperCheer(trainUuid)
  local cheerCount = 6
  local cheerPlayerUuidList = {}
  local allAllianceMember = DataCenter.AllianceMemberDataManager:GetAllMember()
  for _, v in pairs(allAllianceMember) do
    if v.uid ~= LuaEntry.Player:GetUid() then
      table.insert(cheerPlayerUuidList, v.uid)
      if cheerCount <= #cheerPlayerUuidList then
        break
      end
    end
  end
  for _, v in ipairs(cheerPlayerUuidList) do
    local randomDelay = math.random(1, 5)
    TimerManager:GetInstance():DelayInvoke(function()
      local uidArr = {}
      table.insert(uidArr, tostring(v))
      SFSNetwork.SendMessage(MsgDefines.FlowerTrainCheerGm, trainUuid, uidArr)
    end, randomDelay)
  end
end

function FlowerTrainUtils.GeneratePanelDeco(panelView, decoConfigDic)
  if not (panelView and decoConfigDic) or table.count(decoConfigDic) <= 0 then
    return nil
  end
  if IsNull(panelView.transform) then
    return
  end
  if not panelView.GameObjectInstantiateAsync then
    return
  end
  for hangUpPath, assetPullPath in pairs(decoConfigDic) do
    local hangUpTrans = panelView.transform:Find(hangUpPath)
    if not IsNull(hangUpTrans) then
      local request = panelView:GameObjectInstantiateAsync(assetPullPath)
      request:completed("+", function(req)
        if req.isError then
          return
        end
        local go = req.gameObject
        local name = tostring(NameCount)
        go.name = name
        NameCount = NameCount + 1
        local trans = go.transform
        trans:SetParent(hangUpTrans)
        trans.transform:Reset()
      end)
    end
  end
end

function FlowerTrainUtils.IsCanCheer(tipKey)
  local isCanCheer = LuaEntry.Player:IsInSourceServer()
  if tipKey and not isCanCheer then
    UIUtil.ShowTipsId(tipKey)
  end
  return isCanCheer
end

return ConstClass("FlowerTrainUtils", FlowerTrainUtils)
