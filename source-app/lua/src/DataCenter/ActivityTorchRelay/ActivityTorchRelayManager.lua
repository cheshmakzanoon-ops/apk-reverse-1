local ActivityTorchRelayManager = BaseClass("ActivityTorchRelayManager")
local ActivityTorchRelayData = require("DataCenter/ActivityTorchRelay/ActivityTorchRelayData")
local TorchRelayBattleStageConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageConfigTemplate")
local Localization = CS.GameEntry.Localization
ActivityTorchRelayManager.GrowUpType = {
  Stamina = 1,
  Speed = 2,
  Lucky = 3
}
ActivityTorchRelayManager.Stage = {
  Normal = 0,
  Final = 1,
  Error = 2
}
ActivityTorchRelayManager.RankType = {Personal = 1, Alliance = 2}
ActivityTorchRelayManager.RankDataType = {Rank = 1, Reward = 2}

function ActivityTorchRelayManager:__init()
  self.allData = {}
  self.isBlockingEnterMsg = false
  self.activityIdStageTemplateMap = {}
end

function ActivityTorchRelayManager:__delete()
  self.allData = nil
  self.isBlockingEnterMsg = nil
  self.activityIdStageTemplateMap = nil
end

function ActivityTorchRelayManager:GetActivityData(activityId)
  if self.allData ~= nil and self.allData[tostring(activityId)] ~= nil then
    return self.allData[tostring(activityId)]
  end
end

function ActivityTorchRelayManager:OnReceiveActivityData(message)
  if not message then
    return
  end
  local activityId = message.id or message.activityId or ""
  activityId = tostring(activityId)
  self:UpdateActivityData(activityId, message)
  DataCenter.ActivityTorchRelayTaskManager:InitServerData(activityId, message)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActReceiveData)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActUpdateRed)
end

function ActivityTorchRelayManager:UpdateActivityData(activityId, data)
  local activityIdStr = tostring(activityId)
  if self.allData == nil then
    self.allData = {}
  end
  if self.allData[activityIdStr] == nil then
    local activityData = ActivityTorchRelayData.New()
    activityData:InitData(data, activityIdStr)
    self.allData[activityIdStr] = activityData
  else
    self.allData[activityIdStr]:InitData(data, activityIdStr)
  end
end

function ActivityTorchRelayManager:IsAutoCheerOn()
  return true
end

function ActivityTorchRelayManager:SetAutoCheerOn(value)
  local key = "activity_torch_relay_auto_cheer"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, value)
end

function ActivityTorchRelayManager:GetEnterGameRedCount(activityId)
  local data = self:GetActivityData(activityId)
  if data == nil or data.config == nil then
    return 0
  end
  local itemId, itemNum = data.config:GetGameCost()
  if itemId == nil or itemNum == nil then
    return 0
  end
  local userCount = DataCenter.ItemData:GetItemCount(tonumber(itemId))
  if 1 <= userCount then
    return 1
  end
  return 0
end

function ActivityTorchRelayManager:GetGiftPackageRedCount(activityId)
  local data = self:GetActivityData(activityId)
  if data and data:CanClaimFreePackage() then
    return 1
  end
  return 0
end

function ActivityTorchRelayManager:GetBoxItemDrawRedCount(activityId)
  local data = self:GetActivityData(activityId)
  if data and data.config and data.config.draw_box_id > 0 then
    local userCount = DataCenter.ItemData:GetItemCount(tonumber(data.config.draw_box_id))
    if 0 < userCount then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(data.config.draw_box_id)
      if itemTemplate == nil or itemTemplate.type ~= GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
        return 0
      end
      local groupId = checknumber(itemTemplate.para1)
      local itemData = DataCenter.BoxItemDrawManager:GetUserData(groupId)
      if itemData then
        local template = itemData:GetTemplate(itemData:GetCurRound())
        if template and 0 < userCount then
          return 1
        end
      end
    end
  end
  return 0
end

function ActivityTorchRelayManager:GetTaskRedCount(activityId)
  return DataCenter.ActivityTorchRelayTaskManager:GetRedDotNum(activityId)
end

function ActivityTorchRelayManager:GetGrowUpRedCount(activityId)
  local data = self:GetActivityData(activityId)
  local res = 0
  if data then
    for i, v in pairs(DataCenter.ActivityTorchRelayManager.GrowUpType) do
      local isCanLevelUp, _ = data:IsCanGrowUpLevelUp(v)
      if isCanLevelUp then
        res = res + 1
        break
      end
    end
  end
  return res
end

function ActivityTorchRelayManager:GetTotalRedCount(activityId)
  local res = 0
  local rewardNum = 0
  res = res + self:GetEnterGameRedCount(activityId)
  rewardNum = self:GetGiftPackageRedCount(activityId)
  rewardNum = rewardNum + self:GetTaskRedCount(activityId)
  res = res + self:GetBoxItemDrawRedCount(activityId)
  res = res + self:GetGrowUpRedCount(activityId)
  return res + rewardNum, rewardNum, res
end

function ActivityTorchRelayManager:IsGameCostItemEnough(activityId)
  local data = self:GetActivityData(activityId)
  if data == nil or data.config == nil then
    return false
  end
  local itemId, itemNum = data.config:GetGameCost()
  if itemId == nil or itemNum == nil then
    return false
  end
  local userCount = DataCenter.ItemData:GetItemCount(tonumber(itemId))
  return itemNum <= userCount
end

function ActivityTorchRelayManager:GetGrowUpTypeName(type)
  if type == self.GrowUpType.Stamina then
    return Localization:GetString("activity_torch_relay_desc_2")
  end
  if type == self.GrowUpType.Speed then
    return Localization:GetString("activity_torch_relay_desc_3")
  end
  if type == self.GrowUpType.Lucky then
    return Localization:GetString("activity_torch_relay_desc_4")
  end
  return ""
end

function ActivityTorchRelayManager:GetGrowUpTypeImagePath(type)
  if type == self.GrowUpType.Stamina then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_tinengxunlian.png"
  end
  if type == self.GrowUpType.Speed then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_jixiangwu.png"
  end
  if type == self.GrowUpType.Lucky then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_paobuxie.png"
  end
  return ""
end

function ActivityTorchRelayManager:GetGrowUpTypeSmallIconImagePath(type)
  if type == self.GrowUpType.Stamina then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_tili.png"
  end
  if type == self.GrowUpType.Speed then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_sudu.png"
  end
  if type == self.GrowUpType.Lucky then
    return "Assets/Main/Sprites/UI/ActivityNewYear2025/lyt_xinnianpaoku_xingyunzhi.png"
  end
  return ""
end

function ActivityTorchRelayManager:GetStageTemplate(activityId)
  if activityId == nil then
    return
  end
  if not self.activityIdStageTemplateMap[activityId] then
    local data = self:GetActivityData(activityId)
    if data and data.config then
      local lineData = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage, tonumber(data.config.game_stage_id))
      if lineData then
        local template = TorchRelayBattleStageConfigTemplate.New()
        template:InitData(lineData)
        self.activityIdStageTemplateMap[activityId] = template
      end
    end
  end
  return self.activityIdStageTemplateMap[activityId]
end

function ActivityTorchRelayManager:GetScoreCoefficient(activityId)
  local template = self:GetStageTemplate(activityId)
  if template then
    return template.meter_para
  end
  return 1
end

function ActivityTorchRelayManager:GetGrowUpValueDescription(config, activityId)
  if config == nil then
    return ""
  end
  if config.attribute == self.GrowUpType.Stamina then
    if not string.IsNullOrEmpty(config.value_show) then
      return "+" .. config.value_show
    end
    return "+" .. tostring(config.value)
  end
  if config.attribute == self.GrowUpType.Speed then
    if not string.IsNullOrEmpty(config.value_show) then
      return "+" .. config.value_show .. "%"
    end
    return "+" .. string.formatDecimal(config.value * self:GetScoreCoefficient(activityId), 1) .. "m/s"
  end
  if config.attribute == self.GrowUpType.Lucky then
    if not string.IsNullOrEmpty(config.value_show) then
      return "+" .. config.value_show .. "%"
    end
    return "+" .. string.formatDecimal(config.value / 100, 2) .. "%"
  end
  return ""
end

function ActivityTorchRelayManager:GetGrowUpTips(config, activityId)
  if config == nil then
    return ""
  end
  if config.attribute == self.GrowUpType.Stamina then
    local actData = self:GetActivityData(activityId)
    if actData and actData.config then
      local stageTemplate = actData.config:GetStageConfigTemplate()
      if stageTemplate then
        return Localization:GetString("activity_torch_relay_desc_45", tostring(stageTemplate.stamina_cost))
      end
    end
  end
  if config.attribute == self.GrowUpType.Speed then
    return Localization:GetString("activity_torch_relay_desc_46")
  end
  if config.attribute == self.GrowUpType.Lucky then
    return Localization:GetString("activity_torch_relay_desc_47")
  end
  return ""
end

function ActivityTorchRelayManager:RequestExtraData(activityId)
  local data = self:GetActivityData(activityId)
  if data ~= nil then
    local stage = data:GetCurStage()
    if stage == self.Stage.Normal then
      SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayGetExtraData, {activityId = activityId})
    end
    if stage == self.Stage.Final then
      SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayGetExtraData, {activityId = activityId})
    end
  end
end

function ActivityTorchRelayManager:OnGetExtraDataCallback(msg)
  if msg == nil or msg.activityId == nil then
    return
  end
  local actData = self:GetActivityData(msg.activityId)
  if actData ~= nil then
    actData:InitData(msg, tostring(msg.activityId))
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActReceiveExtraData)
end

function ActivityTorchRelayManager:OnCostItemLack(activityId)
  local data = self:GetActivityData(activityId)
  if data == nil or data.config == nil then
    return
  end
  local itemId, itemNum = data.config:GetGameCost()
  if itemId == nil or itemNum == nil then
    return
  end
  LWResourceLackUtil:GotoGoodsItemLack(itemId, itemNum)
end

function ActivityTorchRelayManager:OpenCostItemPackage(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData == nil or activityData.config == nil or activityData.config.exchange_id <= 0 then
    return
  end
  local param = {}
  param.goldGiftPackageDataList = {}
  param.freeGiftPackageDataList = {}
  param.activityId = activityId
  param.exchangeGroupId = activityData.config.exchange_id
  param.refreshTimeDuration = 86400
  param.exchangeGiftPackageIcon = "Assets/Main/Sprites/ItemIcons/wxy_25wanshengjie_paokuquan_icon.png"
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  local todayZero = UITimeManager:GetInstance():GetTodayZeroServerTime(serverTimeS)
  local nextDayZero = todayZero + OneDayTime
  param.nextRefreshTime = nextDayZero
  local freePackageData = {}
  freePackageData.rewards = activityData.config:GetFreeGiftRewards()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo then
    local showConfigTemplate = activityInfo:GetShowConfigTemp()
    if showConfigTemplate and not string.IsNullOrEmpty(showConfigTemplate.free_banner) then
      freePackageData.background = showConfigTemplate.free_banner
    end
  end
  
  function freePackageData.canBuyFunc(activityIdTmp, index)
    local activityDataTmp = self:GetActivityData(activityIdTmp)
    if activityDataTmp == nil then
      return false
    end
    return activityDataTmp:CanClaimFreePackage()
  end
  
  function freePackageData.clickBuyFunc(activityIdTmp, index)
    local activityDataTmp = self:GetActivityData(activityIdTmp)
    if activityDataTmp == nil then
      return
    end
    if activityDataTmp:CanClaimFreePackage() then
      SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayClaimFreeGift, {activityId = activityIdTmp})
    end
  end
  
  freePackageData.userData = {index = 1}
  table.insert(param.freeGiftPackageDataList, freePackageData)
  local itemId, itemNum = activityData.config:GetGameCost()
  if itemId == nil or itemNum == nil then
    return
  end
  local jumpDataTemplates = DataCenter.LWResourceLackManager:GetGoodsWay(itemId)
  if jumpDataTemplates then
    table.sort(jumpDataTemplates, function(a, b)
      return a.order < b.order
    end)
    local resultTemplateList = {}
    if 1 <= table.count(jumpDataTemplates) then
      for i = 1, table.count(jumpDataTemplates) do
        if jumpDataTemplates[i].tips ~= LWResourceLackGetWay.GiftPackage then
          table.insert(resultTemplateList, jumpDataTemplates[i])
        end
      end
    end
    if not param.extension then
      param.extension = {}
    end
    param.extension.halloweenJumpDataList = resultTemplateList
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  param.title = Localization:GetString(activityData.config.getmore_title)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonActivityGiftPackage, {anim = true}, param)
end

function ActivityTorchRelayManager:EnterBattle(activityId)
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local data = self:GetActivityData(activityId)
  if data == nil or data.config == nil then
    return false
  end
  self:SendEnterBattleMsg(activityId, data:GetEnterGameCheerUids())
end

function ActivityTorchRelayManager:SendEnterBattleMsg(activityId, uids)
  if self.isBlockingEnterMsg then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayEnterBattle, {activityId = activityId, uids = uids})
  self.isBlockingEnterMsg = true
end

function ActivityTorchRelayManager:OnEnterBattleCallback(msg)
  self.isBlockingEnterMsg = false
  if not msg or not msg.activityId then
    return
  end
  local data = self:GetActivityData(msg.activityId)
  if not data then
    return
  end
  local itemLimitData, cheerData
  if msg.content ~= nil then
    local decodedBytes = CS.System.Convert.FromBase64String(msg.content)
    local byteArray = CS.Sfs2X.Util.ByteArray(decodedBytes)
    local sfsObj = CS.Sfs2X.Entities.Data.SFSObject.NewFromBinaryData(byteArray)
    local decodedData = CS.SFSObjectExtention.ToLuaTable(sfsObj, CS.GameEntry.Lua.Env)
    if decodedData ~= nil then
      itemLimitData = decodedData.items
      cheerData = decodedData.helpsDetails
      data:SetScoreRecord(decodedData.serverMaxScore, decodedData.selfMaxScore)
    end
  end
  data:SetCheerCustomUidList(nil)
  data:SetCheerAutoSelectUidList(nil)
  if data.config.game_stage_id <= 0 then
    return
  end
  local userData = {
    activityId = msg.activityId,
    itemLimitData = itemLimitData,
    cheerData = cheerData
  }
  local param = {}
  param.type = PVEType.TorchRelay
  param.enterType = PVEEnterType.TorchRelayMain
  param.levelId = data.config.game_stage_id
  param.userData = userData
  DataCenter.LWBattleManager:Enter(param)
end

function ActivityTorchRelayManager:OnGrowUpCallback(msg)
  if msg and msg.activityId then
    local data = self:GetActivityData(msg.activityId)
    if data and data:SetGrowUpLevel(msg.attType, msg.level) then
      EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActGrowUp)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function ActivityTorchRelayManager:SendInGameServerCheckMsg(activityId, contentStr)
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayBattleServerCheck, {activityId = activityId, contentStr = contentStr})
end

function ActivityTorchRelayManager:OnInGameServerCheckCallback(msg)
end

function ActivityTorchRelayManager:SendFinishGameMsg(activityId, contentStr)
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayBattleFinish, {activityId = activityId, contentStr = contentStr})
end

function ActivityTorchRelayManager:OnFinishGameCallback(msg)
  if not msg then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayBattleFinishSuccess, msg)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityTorchRelayManager:IsCheerOtherInChat(primId)
  if self.chatCheerRecordBuffers then
    return self.chatCheerRecordBuffers[primId] ~= nil
  end
  return false
end

function ActivityTorchRelayManager:SetCheerOtherInChat(primId)
  if not self.chatCheerRecordBuffers then
    self.chatCheerRecordBuffers = {}
  end
  self.chatCheerRecordBuffers[primId] = 1
end

function ActivityTorchRelayManager:OnCheerOtherInChatReq(message)
  local activityId = message.activityId
  local activityData = self:GetActivityData(activityId)
  if activityData == nil then
    return
  end
  local seqId = message.seqId
  local tarUid = message.tarUid
  local state = message.state
  local reward = message.reward
  if state == 1 then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  self:SetCheerOtherInChat(seqId)
  local chatData = {}
  chatData.seqId = tonumber(message.chatSeqId)
  chatData.roomId = message.roomId
  chatData.post = PostType.TorchRelayCheer
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, chatData)
end

function ActivityTorchRelayManager:SendShareChatRoomMessage(message)
  local share_param = {}
  share_param.activityId = message.activityId
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.TorchRelayCheer
  share_param.roomId = message.roomId
  local chatData = {}
  chatData.roomId = message.roomId
  chatData.post = PostType.TorchRelayCheer
  chatData.param = share_param
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
end

function ActivityTorchRelayManager:GetRankReward(activityId, rankType)
  local data = self:GetActivityData(activityId)
  if data and data.config then
    if rankType == self.RankType.Personal then
      return data.config:GetPersonalReward()
    else
      return data.config:GetAllianceReward()
    end
  end
end

function ActivityTorchRelayManager:OnGetRankInfoCallback(message)
  if not message or not message.activityId then
    return
  end
  local type = message.type
  local data = self:GetActivityData(message.activityId)
  if not data then
    return
  end
  local playerRankingInfoMsg = message.self
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = checknumber(playerRankingInfoMsg.score)
    selfPlayerData.rank = checknumber(playerRankingInfoMsg.rank)
    if playerRankingInfoMsg.score == nil then
      local rapidjson = require("rapidjson")
      local json = rapidjson.encode(playerRankingInfoMsg)
      Logger.LogError("Torch Relay Log Error, self rank null score, " .. json)
    end
    if type == self.RankType.Personal - 1 then
      data:SetSelfRankInfoData(self.RankType.Personal, selfPlayerData)
    elseif type == self.RankType.Alliance - 1 then
      data:SetSelfRankInfoData(self.RankType.Alliance, selfPlayerData)
    end
  end
  local rankingList = message.ranks
  if rankingList then
    if type == self.RankType.Personal - 1 then
      data:SetRankListInfoData(self.RankType.Personal, rankingList)
    elseif type == self.RankType.Alliance - 1 then
      data:SetRankListInfoData(self.RankType.Alliance, rankingList)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActRankUpdate)
end

function ActivityTorchRelayManager:OnGetRankRewardInfoCallback(message)
  if message == nil or message.activityId == nil then
    return
  end
  local data = self:GetActivityData(message.activityId)
  if not data then
    return
  end
  if message.type then
    local type = message.type
    if type == self.RankType.Personal - 1 then
      if message.self_rank then
        data:SetSelfRankRewardData(self.RankType.Personal, message.self_rank)
      end
      if message.rewards then
        data:SetRankRewardData(self.RankType.Personal, message.rewards)
      end
    elseif type == self.RankType.Alliance - 1 then
      if message.self_rank then
        data:SetSelfRankRewardData(self.RankType.Alliance, message.self_rank)
      end
      if message.rewards then
        data:SetRankRewardData(self.RankType.Alliance, message.rewards)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActRankRewardUpdate)
end

function ActivityTorchRelayManager:OnSetHideNationCallback(msg)
  if msg then
    local activityId = msg.activityId
    if activityId then
      local data = self:GetActivityData(activityId)
      if data and data.data then
        data.data.hideFlag = msg.hide
        EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayActRankHideNationUpdate)
      end
    end
  end
end

function ActivityTorchRelayManager:SendGrowUpMsg(activityId, type)
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayGrowUp, {activityId = activityId, type = type})
end

function ActivityTorchRelayManager:ShareCheerToChat(activityId)
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local share_param = {}
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.TorchRelayCheer
  share_param.postType = PostType.TorchRelayCheer
  share_param.activityId = activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

ActivityTorchRelayManager.TaskViewTag = {Daily = 1, Total = 2}

function ActivityTorchRelayManager:OpenDailyTask()
  local actInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TorchRelay.Type)
  if actInfoList then
    for i, v in pairs(actInfoList) do
      if v:IsValid() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITorchRelayTaskView, {anim = true}, v.id, ActivityTorchRelayManager.TaskViewTag.Daily)
        return
      end
    end
  end
end

function ActivityTorchRelayManager:OpenTotalTask()
  local actInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TorchRelay.Type)
  if actInfoList then
    for i, v in pairs(actInfoList) do
      if v:IsValid() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITorchRelayTaskView, {anim = true}, v.id, ActivityTorchRelayManager.TaskViewTag.Total)
        return
      end
    end
  end
end

return ActivityTorchRelayManager
