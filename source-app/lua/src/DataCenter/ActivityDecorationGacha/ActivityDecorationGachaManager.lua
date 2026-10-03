local ActivityDecorationGachaManager = BaseClass("ActivityDecorationGachaManager")
local ActivityDecorationGachaProbabilityTemplate = require("DataCenter/ActivityDecorationGacha/ActivityDecorationGachaProbabilityTemplate")
local ActivityDecorationGachaData = require("DataCenter/ActivityDecorationGacha/ActivityDecorationGachaData")
local ActivityDecorationGachaInfoTemplate = require("DataCenter/ActivityDecorationGacha/ActivityDecorationGachaInfoTemplate")
local Localization = CS.GameEntry.Localization
ActivityDecorationGachaManager.ItemType = {Decoration = 1, Goods = 2}
ActivityDecorationGachaManager.BigRewardIndex = {
  1,
  4,
  8
}

function ActivityDecorationGachaManager:__init()
  self.allInfo = {}
  self.allRandomInfo = {}
  self.allItemData = {}
  self.allActivityData = {}
  self.allProbability = {}
end

function ActivityDecorationGachaManager:__delete()
  self.allInfo = nil
  self.allRandomInfo = nil
  self.allItemData = nil
  self.allActivityData = nil
  self.allProbability = nil
end

function ActivityDecorationGachaManager:GetRandomInfoTemplate(activityId)
  return self.allRandomInfo[tonumber(activityId)]
end

function ActivityDecorationGachaManager:GetActivityInfo(activityId)
  if self.allInfo[tonumber(activityId)] == nil then
    local activityData = self:GetActivityData(activityId)
    if activityData ~= nil and activityData.data ~= nil and activityData.data.decorationId ~= nil then
      local lineData = LocalController:instance():getLine(TableName.Activity_Decoration_Gacha_Info, tonumber(activityData.data.decorationId))
      if lineData ~= nil then
        self.allInfo[tonumber(activityId)] = ActivityDecorationGachaInfoTemplate.New()
        self.allInfo[tonumber(activityId)]:InitData(lineData)
      end
    end
  end
  return self.allInfo[tonumber(activityId)]
end

function ActivityDecorationGachaManager:GetProbabilityTemplateByItemId(activityId, itemId)
  local allTemplates = self:GetAllProbabilityTemplate(activityId)
  for i, v in pairs(allTemplates) do
    if tonumber(v.para1) == tonumber(itemId) then
      return v
    end
  end
end

function ActivityDecorationGachaManager:GetAllProbabilityTemplate(activityId, type)
  local function InitTemplates()
    self.allProbability[tonumber(activityId)] = {}
    
    local activityData = self:GetActivityData(activityId)
    if activityData ~= nil then
      LocalController:instance():visitTable(TableName.Activity_Decoration_Gacha_Probability, function(id, lineData)
        if lineData then
          local groupId = tonumber(lineData:getValue("group_id")) or 0
          if 0 < groupId and activityData ~= nil and activityData.data ~= nil and tonumber(activityData.data.dropinfo_id) == tonumber(groupId) then
            local template = ActivityDecorationGachaProbabilityTemplate.New()
            template:InitData(lineData)
            table.insert(self.allProbability[tonumber(activityId)], template)
          end
        end
      end)
    end
  end
  
  local res = {}
  if self.allProbability[tonumber(activityId)] == nil then
    InitTemplates()
  end
  local probabilityTemplates = self.allProbability[tonumber(activityId)]
  if type == self.ItemType.Decoration then
    for i, v in pairs(probabilityTemplates) do
      if v.type == self.ItemType.Decoration then
        table.insert(res, v)
      end
    end
  elseif type == self.ItemType.Goods then
    for i, v in pairs(probabilityTemplates) do
      if v.type == self.ItemType.Goods then
        table.insert(res, v)
      end
    end
  else
    res = probabilityTemplates
  end
  table.sort(res, function(a, b)
    return a.order > b.order
  end)
  return res
end

function ActivityDecorationGachaManager:GetItemDataByItemId(activityId, itemId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil then
    return activityData:GetItemDataByItemId(itemId)
  end
  return nil
end

function ActivityDecorationGachaManager:GetDecorationQualityIconImagePath(quality)
  if quality == 5 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ur.png"
  end
  if quality == 4 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_ssr.png"
  end
  if quality == 3 then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_sr.png"
  end
  return ""
end

function ActivityDecorationGachaManager:GetDecorationQualityName(quality)
  if quality == 5 then
    return Localization:GetString("151014")
  end
  if quality == 4 then
    return Localization:GetString("151013")
  end
  if quality == 3 then
    return Localization:GetString("151012")
  end
  return ""
end

function ActivityDecorationGachaManager:GetQualityColoredText(quality, text)
  if quality == 5 then
    return string.format("<color=#ffd600>%s</color>", text)
  end
  if quality == 4 then
    return string.format("<color=#ba4fe4>%s</color>", text)
  end
  if quality == 3 then
    return string.format("<color=#289dcf>%s</color>", text)
  end
  return text
end

function ActivityDecorationGachaManager:GetDecorationQualityTotalProbability(activityId, quality)
  local probabilityTemplates = self:GetAllProbabilityTemplate(activityId)
  local res = 0
  for i, v in pairs(probabilityTemplates) do
    if v.color == quality then
      res = res + v.dropShow
    end
  end
  return res
end

function ActivityDecorationGachaManager:GetTotalProbabilityByItemType(activityId, type)
  local probabilityTemplates = self:GetAllProbabilityTemplate(activityId)
  local res = 0
  for i, v in pairs(probabilityTemplates) do
    if v.type == type then
      res = res + v.dropShow
    end
  end
  return res
end

function ActivityDecorationGachaManager:IsDecorationBoolFilterOn()
  local key = "activity_decoration_gacha_decoration_book_filter"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, true)
end

function ActivityDecorationGachaManager:SetDecorationBoolFilter(isOn)
  local key = "activity_decoration_gacha_decoration_book_filter"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, isOn)
end

function ActivityDecorationGachaManager:OpenDecorationBook(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil then
    local allItemData = activityData:GetAllItemDataInOrder()
    local allWishData = activityData:GetAllWishDataInOrder()
    local allBuildIdInBoxItem = activityData:GetAllBuildIdInWheelBoxItem()
    local param = {
      activityId = activityId,
      toggleText = Localization:GetString("decoration_recruit_desc4"),
      toggleFilterFunction = function(buildId)
        for i, v in pairs(allItemData) do
          if v.decorationBuildingId > 0 and math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(v.decorationBuildingId / 1000) * 1000 then
            return true
          end
        end
        for i, v in pairs(allWishData) do
          local itemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(activityId, v.itemId)
          if itemDataTemplate ~= nil and itemDataTemplate.decorationBuildingId > 0 and math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(itemDataTemplate.decorationBuildingId / 1000) * 1000 then
            return true
          end
        end
        for i, v in pairs(allBuildIdInBoxItem) do
          if math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(v / 1000) * 1000 then
            return true
          end
        end
        return false
      end
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaBook, {anim = true}, param)
    self:SetHasShownDecorationBook()
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaOpenDecorationBook)
    PostEventLog.Track(PostEventLog.Defines.ActivityDecorationGachaOpenBook, {
      activityId = tostring(activityId)
    })
  end
end

function ActivityDecorationGachaManager:GetActivityData(activityId)
  if self.allActivityData ~= nil and self.allActivityData[tostring(activityId)] ~= nil then
    return self.allActivityData[tostring(activityId)]
  end
end

function ActivityDecorationGachaManager:OpenGiftPackage(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData == nil then
    return
  end
  local info = self:GetActivityInfo(activityId)
  if info == nil then
    return
  end
  local canOpenGiftPackage = false
  if activityData:CanClaimFreePackage() then
    canOpenGiftPackage = true
  end
  if not canOpenGiftPackage then
    local goldRewardData = activityData:GetGoldRewardData()
    if goldRewardData ~= nil then
      for i, v in pairs(goldRewardData) do
        if activityData:CanBuyGoldPackage(i) then
          canOpenGiftPackage = true
          break
        end
      end
    end
  end
  if not canOpenGiftPackage then
    local packs = GiftPackManager.GetPacksByGroupId(info.exchangeId, false)
    if not table.IsNullOrEmpty(packs) then
      canOpenGiftPackage = true
    elseif info.exchangeid_event and info.exchangeid_event > 0 then
      local packsWithAct = GiftPackManager.GetPacksByGroupId(info.exchangeid_event, false)
      if packsWithAct and 0 < #packsWithAct then
        canOpenGiftPackage = true
      end
    end
  end
  if canOpenGiftPackage then
    local param = {}
    param.goldGiftPackageDataList = {}
    param.freeGiftPackageDataList = {}
    param.activityId = activityId
    param.exchangeGroupId = info.exchangeId
    param.exchangeGroupIdByAct = info.exchangeid_event
    param.nextRefreshTime = activityData.data.nextResetTime
    param.refreshTimeDuration = 86400
    param.exchangeGiftPackageIcon = "Assets/Main/Sprites/ItemIcons/item_zhuangshiwu_zhuanpan1.png"
    local actEndTime = activityData:GetEndTime()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if UITimeManager:GetInstance():IsSameDayForServer(actEndTime // 1000, curTime) then
      param.emptyText = Localization:GetString("dailygift_buy_alert2")
    else
      param.emptyText = Localization:GetString("dailygift_buy_alert1")
    end
    local freePackageData = {}
    freePackageData.rewards = activityData:GetFreeRewardData()
    freePackageData.background = "Assets/Main/TextureEx/UIActivityBg/ActivityDecorationGacha/mjc_zhuangshiwu_zhigoulibao_fenye_banner.png"
    
    function freePackageData.canBuyFunc(activityIdTmp, index)
      local activityDataTmp = self:GetActivityData(activityIdTmp)
      if activityDataTmp == nil then
        return
      end
      return activityDataTmp:CanClaimFreePackage()
    end
    
    function freePackageData.clickBuyFunc(activityIdTmp, index)
      local activityDataTmp = self:GetActivityData(activityIdTmp)
      if activityDataTmp == nil then
        return
      end
      if activityDataTmp:CanClaimFreePackage() then
        SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaBuyFreeGift, {activityId = activityIdTmp})
      end
    end
    
    freePackageData.userData = {index = 1}
    table.insert(param.freeGiftPackageDataList, freePackageData)
    local goldRewardData = activityData:GetGoldRewardData()
    if goldRewardData ~= nil then
      for i, v in pairs(goldRewardData) do
        local goldPackageData = {}
        goldPackageData.userData = {index = i}
        goldPackageData.title = Localization:GetString("giftbag_decoration_recruit_name_diamond")
        goldPackageData.rewards = {}
        for _, j in pairs(v.reward) do
          local data = {
            rewardType = j.type,
            itemId = j.value.id,
            count = j.value.num
          }
          table.insert(goldPackageData.rewards, data)
        end
        goldPackageData.costGoldNum = v.cost
        goldPackageData.background = "Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_ka_2.png"
        
        function goldPackageData.canBuyFunc(activityIdTmp, userData)
          if userData == nil or userData.index == nil then
            return
          end
          local activityDataTmp = self:GetActivityData(activityIdTmp)
          if activityDataTmp == nil then
            return
          end
          return activityDataTmp:CanBuyGoldPackage(userData.index)
        end
        
        function goldPackageData.clickBuyFunc(activityIdTmp, userData)
          if userData == nil or userData.index == nil then
            return
          end
          local activityDataTmp = self:GetActivityData(activityIdTmp)
          if activityDataTmp == nil then
            return
          end
          if activityDataTmp:CanBuyGoldPackage(userData.index) then
            SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaBuyGoldGift, {
              activityId = activityIdTmp,
              index = userData.index - 1
            })
          end
        end
        
        goldPackageData.icon = "Assets/Main/Sprites/ItemIcons/item_zhuangshiwu_zhuanpan1.png"
        goldPackageData.quality = 2
        table.insert(param.goldGiftPackageDataList, goldPackageData)
      end
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonActivityGiftPackage, {anim = true}, param)
  else
    UIUtil.ShowTipsId(2000655)
  end
end

function ActivityDecorationGachaManager:GetCriticalParams(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil and activityData.data ~= nil then
    return checknumber(activityData.data.critWeight), checknumber(activityData.data.critMultiple)
  end
  return 0, 0
end

function ActivityDecorationGachaManager:OnReceiveActivityData(message)
  if not message then
    return
  end
  local activityId = message.id or message.activityId or ""
  activityId = tostring(activityId)
  self:UpdateActivityData(activityId, message)
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaReceiveActivityData)
end

function ActivityDecorationGachaManager:UpdateActivityData(activityId, data)
  local activityIdStr = tostring(activityId)
  if self.allActivityData == nil then
    self.allActivityData = {}
  end
  if self.allActivityData[activityIdStr] == nil then
    local activityData = ActivityDecorationGachaData.New()
    activityData:InitData(data, activityIdStr)
    self.allActivityData[activityIdStr] = activityData
  else
    self.allActivityData[activityIdStr]:InitData(data, activityIdStr)
  end
end

function ActivityDecorationGachaManager:GetProgressRedCount(activityId)
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(activityId)
  if activityData ~= nil then
    local progressData = activityData:GetProgressData()
    if not table.IsNullOrEmpty(progressData) then
      for i, v in pairs(progressData) do
        if activityData:GetProgressState(v.index) == 1 then
          return 1
        end
      end
    end
  end
  return 0
end

function ActivityDecorationGachaManager:GetWishRedCount(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil then
    local curScore = activityData:GetCurWishScore()
    local maxScore = activityData:GetPity()
    if curScore >= maxScore then
      return 1
    end
  end
  return 0
end

function ActivityDecorationGachaManager:GetGiftPackageRedPoint(activityId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil and activityData:CanClaimFreePackage() then
    return 1
  end
  return 0
end

function ActivityDecorationGachaManager:IsShowInBookView(activityId, buildId)
  local activityData = self:GetActivityData(activityId)
  if activityData ~= nil then
    local allItemData = activityData:GetAllItemDataInOrder()
    local allWishData = activityData:GetAllWishDataInOrder()
    local allBuildIdInBoxItem = activityData:GetAllBuildIdInWheelBoxItem()
    for i, v in pairs(allItemData) do
      if v.decorationBuildingId > 0 and math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(v.decorationBuildingId / 1000) * 1000 then
        return true
      end
    end
    for i, v in pairs(allWishData) do
      local itemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(activityId, v.itemId)
      if itemDataTemplate ~= nil and itemDataTemplate.decorationBuildingId > 0 and math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(itemDataTemplate.decorationBuildingId / 1000) * 1000 then
        return true
      end
    end
    for i, v in pairs(allBuildIdInBoxItem) do
      if math.floor(tonumber(buildId) / 1000) * 1000 == math.floor(v / 1000) * 1000 then
        return true
      end
    end
  end
  return false
end

function ActivityDecorationGachaManager:GetDecorationBookUpgradeRedCount(activityId)
  local res = 0
  if self:IsDecorationBoolFilterOn() then
    local baseBuildingIdMap = DataCenter.BuildTemplateManager:GetNoBuyDecorateDataListByQuality()
    for k, v in pairs(baseBuildingIdMap) do
      local hasBuilding = DataCenter.BuildManager:HasBuilding(k, true)
      if hasBuilding then
        local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(k, true)
        local buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(k, false)
        local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(k)
        if buildData then
          local hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildData.itemId, buildData.level, false)
          local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
          local groupId = 0
          if lvTemplate then
            groupId = lvTemplate.decoGroupUpgradeBaseId or 0
          end
          local isAdvanceUpgrade = 0 < groupId
          local canUpgrade = false
          if not isAdvanceUpgrade then
            if needCountWithoutGlue <= hasCount and buildData.level < buildDesTemplate.max_level then
              canUpgrade = true
            end
          else
            local curProgress = buildData.prodStatus or 0
            local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, buildData.level, curProgress)
            if curProgressInfo then
              local upgradeCostItem = toInt(curProgressInfo.cost_item)
              if hasCount >= upgradeCostItem then
                canUpgrade = true
              end
            end
          end
          if not canUpgrade and buildData.state == BuildingStateType.FoldUp and (buildDataExist == nil or buildData.level > buildDataExist.level) then
            canUpgrade = true
          end
          if canUpgrade and self:IsShowInBookView(activityId, k) then
            res = res + 1
          end
        end
      end
    end
  elseif DataCenter.BuildManager:IsDecoratorHasRedDot() then
    res = res + 1
  end
  return res
end

function ActivityDecorationGachaManager:GetDecorationBookRedPoint(activityId)
  local res = 0
  res = res + self:GetDecorationBookUpgradeRedCount(activityId)
  if not self:HasShownDecorationBook() then
    res = res + 1
  end
  return res
end

function ActivityDecorationGachaManager:HasShownDecorationBook()
  local key = "activity_decoration_gacha_decoration_bool_show"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function ActivityDecorationGachaManager:SetHasShownDecorationBook()
  local key = "activity_decoration_gacha_decoration_bool_show"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function ActivityDecorationGachaManager:GetTotalRedCount(activityId)
  local rewardNum = self:GetGiftPackageRedPoint(activityId)
  local tipNum = self:GetDecorationBookRedPoint(activityId) + self:GetWishRedCount(activityId) + self:GetProgressRedCount(activityId)
  return rewardNum + tipNum, rewardNum, tipNum
end

function ActivityDecorationGachaManager:IsSkipGachaAnim()
  local key = "activity_decoration_gacha_skip_gacha_anim_"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function ActivityDecorationGachaManager:SetIsSkipGachaAnim(isSkip)
  if isSkip then
    local key = "activity_decoration_gacha_skip_gacha_anim_"
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
  else
    local key = "activity_decoration_gacha_skip_gacha_anim_"
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, false)
  end
end

function ActivityDecorationGachaManager:IsGachaCostItemEnough(activityId, num)
  local activityInfo = self:GetActivityInfo(activityId)
  if activityInfo == nil then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(tonumber(activityInfo.costId))
  return userCount >= num * activityInfo.costNum
end

function ActivityDecorationGachaManager:SendGachaMessage(activityId, num)
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaStartGacha)
  SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaGacha, {activityId = activityId, num = num})
end

function ActivityDecorationGachaManager:ShowGachaResult()
  if self.gachaResultParamCache == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaGetReward, {anim = true}, self.gachaResultParamCache)
  self.gachaResultParamCache = nil
end

function ActivityDecorationGachaManager:SetLastGachaResultCache(message)
  if message and message.rewardList then
    local pos = -1
    for i, v in pairs(message.rewardList) do
      pos = v.pos
    end
    if 0 < pos then
      local key = "activity_decoration_gacha_last_result_pos_"
      CS.GameEntry.Setting:SetInt(key .. LuaEntry.Player.uid, pos)
    end
  end
end

function ActivityDecorationGachaManager:GetLastGachaResultCache()
  local key = "activity_decoration_gacha_last_result_pos_"
  return CS.GameEntry.Setting:GetInt(key .. LuaEntry.Player.uid, 1)
end

function ActivityDecorationGachaManager:OnGachaMessageCallback(message)
  if message == nil or message.activityId == nil then
    return
  end
  local isWishComplete = false
  local preWishScore = 0
  local preGachaTotalTimes = 0
  local activityData = self:GetActivityData(message.activityId)
  if activityData ~= nil then
    preWishScore = activityData:GetCurWishScore()
    preGachaTotalTimes = activityData:GetCurGachaTimes()
  end
  local curWishScore = checknumber(message.wishScore)
  local curGachaTotalTimes = checknumber(message.totalTimes)
  local maxWishScore = activityData:GetPity()
  if preWishScore ~= maxWishScore and curWishScore >= maxWishScore then
    isWishComplete = true
  end
  self.gachaResultParamCache = {data = message, isWishComplete = isWishComplete}
  local rewardData = {}
  rewardData.reward = {}
  if message.rewardList ~= nil then
    for _, i in pairs(message.rewardList) do
      if i.reward ~= nil then
        for _, v in pairs(i.reward) do
          table.insert(rewardData.reward, v)
        end
      end
    end
  end
  DataCenter.RewardManager:AddRewardsAndRes(rewardData)
  self:OnReceiveActivityData(message)
  if self:IsSkipGachaAnim() then
    self:ShowGachaResult()
  else
    local gachaTimes = math.max(curGachaTotalTimes - preGachaTotalTimes, 0)
    EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaShowGachaAnim, {num = gachaTimes, data = message})
  end
  self:SetLastGachaResultCache(message)
end

function ActivityDecorationGachaManager:SendSelectWishMessage(activityId, wishData)
  local activityData = self:GetActivityData(activityId)
  if activityData == nil then
    return
  end
  local allWishData = activityData:GetAllWishDataInOrder()
  for i, v in pairs(allWishData) do
    if v.itemId == wishData.itemId and v.count == wishData.count then
      SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaWishSelect, {activityId = activityId, index = i})
      return
    end
  end
end

function ActivityDecorationGachaManager:OnSelectWishMessageCallback(message)
  if message == nil or message.activityId == nil then
    return
  end
  self:OnReceiveActivityData(message)
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaWishSelect)
end

function ActivityDecorationGachaManager:SendClaimWishMessage(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaWishClaim, {activityId = activityId})
end

function ActivityDecorationGachaManager:OnClaimWishMessageCallback(message)
  if message == nil or message.activityId == nil then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self:OnReceiveActivityData(message)
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaWishClaim)
end

function ActivityDecorationGachaManager:SendClaimProgressMessage(activityId, index)
  SFSNetwork.SendMessage(MsgDefines.ActivityDecorationGachaProgressClaim, {activityId = activityId, index = index})
end

function ActivityDecorationGachaManager:OnClaimProgressMessageCallback(message)
  if message == nil or message.activityId == nil then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self:OnReceiveActivityData(message)
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaProgressClaim)
end

function ActivityDecorationGachaManager:IsAllWishDecorationBuildMaxOrUpgradeItemMax(activityId)
  local activityData = self:GetActivityData(activityId)
  local res = false
  if activityData ~= nil then
    res = true
    local allWishData = activityData:GetAllWishDataInOrder()
    for i, v in pairs(allWishData) do
      local wishItemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(activityId, v.itemId)
      if wishItemDataTemplate ~= nil and not wishItemDataTemplate:IsDecorationBuildMaxOrUpgradeItemMax() then
        res = false
        break
      end
    end
  end
  return res
end

function ActivityDecorationGachaManager:IsBigReward(index)
  for i, v in pairs(self.BigRewardIndex) do
    if v == index then
      return true
    end
  end
  return false
end

function ActivityDecorationGachaManager:GetShowResultDelayTime(evtData)
  if evtData == nil or evtData.num == nil or evtData.data == nil then
    return -1
  end
  if table.IsNullOrEmpty(evtData.data.rewardList) then
    return -1
  end
  if evtData.num == 1 then
    local index = evtData.data.rewardList[1].pos
    if self:IsBigReward(index) then
      return 1
    else
      return 0.5
    end
  else
    return 1
  end
end

return ActivityDecorationGachaManager
