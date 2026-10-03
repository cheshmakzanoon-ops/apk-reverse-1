local ActDispatchTreasureManager = BaseClass("ActDispatchTreasureManager")
local ActDispatchTreasureRewardTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardTemplate")
local ActDispatchTreasureRewardItemTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardItemTemplate")

local function __init(self)
  self.selectSkip = CommonUtil.PlayerPrefsGetBool(SettingKeys.DISPATCH_TREASURE_SKIPANIM)
  self.isShowPlot = CommonUtil.PlayerPrefsGetBool(SettingKeys.DISPATCH_TREASURE_PLOT)
  self.fragGoodsIdList = {}
  self.exchangeType = SplinterExchangeType.DispatchTreasure.Id
  local data = LocalController:instance():getLine(TableName.Splinter_Exchange, self.exchangeType)
  local splinterIds = string.split(data.splinter_id, "|")
  for i = 1, #splinterIds do
    local goodsId = splinterIds[i]
    table.insert(self.fragGoodsIdList, goodsId)
  end
  self.fragDigGoodsIdList = {}
  self.digExchangeType = SplinterExchangeType.DigTreasure.Id
  local digData = LocalController:instance():getLine(TableName.Splinter_Exchange, self.digExchangeType)
  local digSplinterIds = string.split(digData.splinter_id, "|")
  for i = 1, #digSplinterIds do
    local goodsId = digSplinterIds[i]
    table.insert(self.fragDigGoodsIdList, goodsId)
  end
  self.previewRewardList = {}
  self:AddListener()
  self.isOpened = false
  self.CommonPreviewBoxReward = {}
  self.ownLogData = {}
  self.allianceLogData = {}
end

local function __delete(self)
  self.selectSkip = nil
  self.isShowPlot = nil
  self.fragGoodsIdList = nil
  self.fragDigGoodsIdList = nil
  self.exchangeType = nil
  self.previewRewardList = nil
  self.isOpened = false
  self.CommonPreviewBoxReward = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function SetSkipAnimState(self, isSkip)
  self.selectSkip = isSkip
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DISPATCH_TREASURE_SKIPANIM, self.selectSkip)
end

function ActDispatchTreasureManager:GetQuality(item)
  local q = 0
  if item.type == RewardType.GOODS then
    local tpl = DataCenter.ItemTemplateManager:GetItemTemplate(item.value.itemId)
    if tpl then
      q = tpl.color or 0
    end
  elseif item.type == RewardType.RESOURCE_ITEM then
    local tpl = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(item.value.itemId)
    if tpl then
      q = tpl.quality or 0
    end
  elseif item.type == RewardType.DecorateBuild then
    local tpl = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(item.value.itemId)
    if tpl then
      q = tpl.display_order_gallery or 0
    end
  end
  return q
end

local function ShowDigReward(self, message, closeFunc)
  if message.reward then
    local actData = DataCenter.DigTreasureManager:GetNewActivityData()
    if actData and actData.activityId then
      local line = LocalController:instance():getLine(TableName.Activity, actData.activityId)
      if line and line.para_3 then
        local itemId = tonumber(line.para_3)
        self:InsertBoxRewardsToFront(message, itemId)
      end
    end
    for _, v in ipairs(message.reward) do
      v._quality = self:GetQuality(v)
    end
    table.sort(message.reward, function(a, b)
      if a._quality ~= b._quality then
        return a._quality > b._quality
      end
      if a.type ~= b.type then
        return a.type < b.type
      end
      return (a.value.itemId or 0) < (b.value.itemId or 0)
    end)
    DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, closeFunc, nil, nil, nil, nil, true)
  end
end

function ActDispatchTreasureManager:InsertBoxRewardsToFront(message, itemId)
  if not message.boxArray or not message.reward then
    return
  end
  local templateReward, templateIndex
  for i, r in ipairs(message.reward) do
    if r.value and tonumber(r.value.itemId) == itemId then
      templateReward = r
      templateIndex = i
      break
    end
  end
  if not templateReward then
    return
  end
  local newRewards = {}
  for _, box in ipairs(message.boxArray) do
    local clone = {
      type = templateReward.type,
      value = {
        itemId = templateReward.value.itemId,
        rewardAdd = box.pointNum
      }
    }
    table.insert(newRewards, clone)
  end
  for i = #newRewards, 1, -1 do
    table.insert(message.reward, 1, newRewards[i])
  end
  table.remove(message.reward, templateIndex + #newRewards)
end

local function ShowPlot(self)
  self.isShowPlot = true
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DISPATCH_TREASURE_PLOT, true)
  local plotId = 2102
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
end

local function GetCanDig(self)
  local idList
  if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
    idList = self.fragDigGoodsIdList
  else
    idList = self.fragGoodsIdList
  end
  local count = 0
  for i = 1, #idList do
    local num = self:GetGoodsCountByIndex(i)
    if 0 < num then
      count = count + 1
    end
  end
  return count == #idList
end

local function GetCanDigCount(self)
  local idList
  if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
    idList = self.fragDigGoodsIdList
  else
    idList = self.fragGoodsIdList
  end
  local minNum = 99999
  for i = 1, #idList do
    local num = self:GetGoodsCountByIndex(i)
    if minNum > num then
      minNum = num
    end
  end
  return minNum
end

local function GetDigRedPoint(self)
  return self:GetCanDig()
end

local function GetDayFirstShow(self)
  return not self.isOpened
end

local function SetDayFirstIsShow(self)
  if not self.isOpened then
    self.isOpened = true
    EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshTabRedPoint)
  end
end

local function GetTabRedPoint(self)
  return self:GetDigRedPoint()
end

local function GetExchangeLogRedPoint(self)
  return DataCenter.SplinterExchangeManager:GetExchangeLogRedPoint(self.exchangeType)
end

local function GetMainBtnRedPoint(self)
  return self:GetDigRedPoint() and self:GetDayFirstShow()
end

local function GetGoodsCountByIndex(self, index)
  local idList
  if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
    idList = self.fragDigGoodsIdList
  else
    idList = self.fragGoodsIdList
  end
  if idList[index] then
    local itemData = DataCenter.ItemData:GetItemByItemId(tonumber(idList[index]))
    if itemData then
      return itemData.count
    end
  end
  return 0
end

local function GetGoodsIdByIndex(self, index)
  local idList
  if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
    idList = self.fragDigGoodsIdList
  else
    idList = self.fragGoodsIdList
  end
  return idList[index]
end

local function GetExchangeType(self)
  return self.exchangeType
end

local function GetAllFragNum(self)
  return DataCenter.SplinterExchangeManager:GetAllFragNum(self.exchangeType)
end

local function InitPreviewReward(self)
  local commonData = ActDispatchTreasureRewardTemplate.New()
  commonData:InitData(DispathTreasureRewardType.Common)
  self.previewRewardList[DispathTreasureRewardType.Common] = commonData
  local normalData = ActDispatchTreasureRewardTemplate.New()
  normalData:InitData(DispathTreasureRewardType.Normal)
  self.previewRewardList[DispathTreasureRewardType.Normal] = normalData
  local rareData = ActDispatchTreasureRewardTemplate.New()
  rareData:InitData(DispathTreasureRewardType.Rare)
  self.previewRewardList[DispathTreasureRewardType.Rare] = rareData
  local epicData = ActDispatchTreasureRewardTemplate.New()
  epicData:InitData(DispathTreasureRewardType.Epic)
  self.previewRewardList[DispathTreasureRewardType.Epic] = epicData
end

local function GetPreviewReward(self, type)
  self.previewRewardList = {}
  local rewardData = self.previewRewardList[type]
  if rewardData == nil or rewardData:CheckNeedRefresh() then
    self:InitPreviewReward()
  end
  return self.previewRewardList[type]
end

function ActDispatchTreasureManager:GetPreviewRewardById(id)
  local data
  if self.CommonPreviewBoxReward[id] then
    data = DeepCopy(self.CommonPreviewBoxReward[id])
  else
    data = {}
    local showCfg = LocalController:instance():getLine(TableName.Treasure_Map_Reward_Show, id)
    local allProp = 0
    local propTab = string.split(showCfg.rate, ";")
    local itemTab = string.split(showCfg.item, ";")
    local numTab = string.split(showCfg.num, ";")
    local index = string.find(showCfg.rate, "|")
    if index ~= nil then
      propTab = string.split(showCfg.rate, "|")
      itemTab = string.split(showCfg.item, "|")
      numTab = string.split(showCfg.num, "|")
      allProp = 100
    else
      for index, value in ipairs(propTab) do
        allProp = allProp + tonumber(value)
      end
    end
    data.rewardInfo = {}
    for i = 1, #propTab do
      local rewardItem = ActDispatchTreasureRewardItemTemplate.New()
      rewardItem:InitData(propTab[i] / allProp, itemTab[i], numTab[i])
      table.insert(data.rewardInfo, rewardItem)
    end
    self.CommonPreviewBoxReward[id] = data
    data = DeepCopy(data)
  end
  return data
end

local function RefreshRecordData(self, msg, logType)
  local refreshData = {}
  if msg ~= nil and msg.array ~= nil then
    local list = {}
    for _, v in ipairs(msg.array) do
      local data = SplinterExchangeRecordData.New()
      data:ParseData(v)
      table.insert(list, data)
    end
    table.sort(list, function(a, b)
      return a.time > b.time
    end)
    refreshData[1] = list
    local idList
    if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
      idList = DataCenter.SplinterExchangeManager:GetFragGoodsIdList(SplinterExchangeType.DigTreasure.Id)
    else
      idList = DataCenter.SplinterExchangeManager:GetFragGoodsIdList(SplinterExchangeType.DispatchTreasure.Id)
    end
    for index, value in ipairs(list) do
      for i = 1, #idList do
        if refreshData[i + 1] == nil then
          refreshData[i + 1] = {}
        end
        if idList[i] == value.getFragment then
          table.insert(refreshData[i + 1], value)
        end
      end
    end
  end
  if logType == SplinterExchangeLogType.Own then
    self.ownLogData = refreshData
  elseif logType == SplinterExchangeLogType.Alliance then
    self.allianceLogData = refreshData
  end
  EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshLog, logType)
end

local function GetLogByTypeAndLv(self, logType, lv)
  local data
  if logType == SplinterExchangeLogType.Own then
    if self.ownLogData and self.ownLogData[lv] then
      data = self.ownLogData[lv]
    end
  elseif logType == SplinterExchangeLogType.Alliance and self.allianceLogData and self.allianceLogData[lv] then
    data = self.allianceLogData[lv]
  end
  return data
end

local function ClearRecordData(self)
  self.ownLogData = nil
  self.allianceLogData = nil
end

local function IsHaveFragGoodsIdList(self)
  return self.fragGoodsIdList ~= nil
end

ActDispatchTreasureManager.__init = __init
ActDispatchTreasureManager.__delete = __delete
ActDispatchTreasureManager.AddListener = AddListener
ActDispatchTreasureManager.RemoveListener = RemoveListener
ActDispatchTreasureManager.ShowDigReward = ShowDigReward
ActDispatchTreasureManager.SetSkipAnimState = SetSkipAnimState
ActDispatchTreasureManager.ShowPlot = ShowPlot
ActDispatchTreasureManager.GetCanDig = GetCanDig
ActDispatchTreasureManager.GetDigRedPoint = GetDigRedPoint
ActDispatchTreasureManager.GetDayFirstShow = GetDayFirstShow
ActDispatchTreasureManager.SetDayFirstIsShow = SetDayFirstIsShow
ActDispatchTreasureManager.GetTabRedPoint = GetTabRedPoint
ActDispatchTreasureManager.GetMainBtnRedPoint = GetMainBtnRedPoint
ActDispatchTreasureManager.GetExchangeLogRedPoint = GetExchangeLogRedPoint
ActDispatchTreasureManager.GetGoodsCountByIndex = GetGoodsCountByIndex
ActDispatchTreasureManager.GetGoodsIdByIndex = GetGoodsIdByIndex
ActDispatchTreasureManager.GetExchangeType = GetExchangeType
ActDispatchTreasureManager.GetAllFragNum = GetAllFragNum
ActDispatchTreasureManager.InitPreviewReward = InitPreviewReward
ActDispatchTreasureManager.GetPreviewReward = GetPreviewReward
ActDispatchTreasureManager.GetLogByTypeAndLv = GetLogByTypeAndLv
ActDispatchTreasureManager.RefreshRecordData = RefreshRecordData
ActDispatchTreasureManager.ClearRecordData = ClearRecordData
ActDispatchTreasureManager.IsHaveFragGoodsIdList = IsHaveFragGoodsIdList
ActDispatchTreasureManager.GetCanDigCount = GetCanDigCount
return ActDispatchTreasureManager
