local ScienceRecommendManager = BaseClass("ScienceRecommendManager")
local Localization = CS.GameEntry.Localization
local findPreRecommandMaxDeep = 30
local baseDeep = 1

local function __init(self)
  self.recommend1OrderList = nil
  self.recommend2OrderList = nil
  self.recommend1TargetData = {index = 0, data = nil}
  self.recommend2TargetData = {index = 0, data = nil}
  self.recommend1FindList = {}
  self.recommend2FindList = {}
  self.showRecommend1Data = nil
  self.showRecommend2Data = nil
  self.reachingScienceList = {}
  self.isDataDirty = true
  self.isShowDataDirty = true
  self.sendMsgDelayTimer = nil
  self.configDataDict = {}
  self:AddListener()
end

local function __delete(self)
  self:StopSendMsgDelayTimerFunc()
  self.recommend1OrderList = nil
  self.recommend2OrderList = nil
  self.recommend1TargetIndex = nil
  self.recommend2TargetIndex = nil
  self.recommend1FindList = nil
  self.recommend2FindList = nil
  self.reachingScienceList = nil
  self.showRecommend1Data = nil
  self.showRecommend2Data = nil
  self.isDataDirty = nil
  self.isShowDataDirty = nil
  self.sendMsgDelayTimer = nil
  self.configDataDict = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA, self.SetDataDirty)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.SetDataDirty)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueFinish, self.SetDataDirty)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.SetDataDirty)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.SetDataDirty)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueFinish, self.SetDataDirty)
end

local function GetConfigData(self, id, lv, lineData)
  local configData
  if lv == nil or lv <= 0 then
    lv = 1
  end
  local index = CommonUtil.GetScienceBaseType(tonumber(id)) + lv
  if self.configDataDict[index] == nil then
    if lineData == nil then
      lineData = LocalController:instance():getLine(TableName.ScienceNew, index)
    end
    if lineData then
      configData = {
        id = lineData.id,
        science_id = lineData.science_id,
        level = lineData.level
      }
      local tempShow = lineData:getValue("science_condition")
      configData.needScience = {}
      if tempShow ~= nil then
        for k, v in ipairs(tempShow) do
          local tempTab = {}
          tempTab.scienceId = CommonUtil.GetScienceBaseType(tonumber(v))
          tempTab.level = CommonUtil.GetScienceLv(tonumber(v))
          table.insert(configData.needScience, tempTab)
        end
      end
      self.configDataDict[index] = configData
    end
  else
    configData = self.configDataDict[index]
  end
  return configData
end

local function TryInitRecommendOrderList(self)
  if self.recommend1OrderList ~= nil and self.recommend2OrderList ~= nil then
    return
  end
  self.recommend1OrderList = {}
  self.recommend2OrderList = {}
  LocalController:instance():visitTable(TableName.ScienceNew, function(id, lineData)
    local recommend_level1 = tonumber(lineData:getValue("recommend_level1")) or 0
    local recommend_level2 = tonumber(lineData:getValue("recommend_level2")) or 0
    local isNeedRecommend = 0 < recommend_level1 or 0 < recommend_level2
    if isNeedRecommend then
      local configData = self:GetConfigData(lineData.id, lineData.level, lineData)
      configData.recommend_level1 = recommend_level1
      configData.recommend_level2 = recommend_level2
      if 0 < recommend_level1 then
        table.insert(self.recommend1OrderList, configData)
      end
      if 0 < recommend_level2 then
        table.insert(self.recommend2OrderList, configData)
      end
    end
  end)
  table.sort(self.recommend1OrderList, function(a, b)
    if a.recommend_level1 ~= b.recommend_level1 then
      return a.recommend_level1 < b.recommend_level1
    end
    return a.id < b.id
  end)
  table.sort(self.recommend2OrderList, function(a, b)
    if a.recommend_level2 ~= b.recommend_level2 then
      return a.recommend_level2 < b.recommend_level2
    end
    return a.id < b.id
  end)
end

local function TryRefreshRecommendScience(self)
  if self.isDataDirty == false then
    return
  end
  self.isDataDirty = false
  self:InitReachingScienceList()
  self:RefreshRecommendData(self.recommend1OrderList, self.recommend1TargetData, self.recommend1FindList)
  self:RefreshRecommendData(self.recommend2OrderList, self.recommend2TargetData, self.recommend2FindList)
end

local function ClearRecommendFindListFunc(self, recommendOrderList, recommendTargetData, recommendFindList)
  for i = 1, #recommendFindList do
    recommendFindList[i] = nil
  end
end

local function FindNextRecommandTargetFunc(self, recommendOrderList, recommendTargetData, recommendFindList)
  local nextIndex = math.max(recommendTargetData.index + 1, 1)
  for i = nextIndex, #recommendOrderList do
    local targetData = recommendOrderList[i]
    recommendTargetData.index = i
    recommendTargetData.data = targetData
    if self:CheckRecommendTargetValidFunc(recommendOrderList, recommendTargetData, recommendFindList) then
      return
    end
  end
  recommendTargetData.index = #recommendOrderList
  recommendTargetData.data = nil
end

local function GenerateRecommendFindListFunc(self, recommendOrderList, recommendTargetData, recommendFindList)
  self:ClearRecommendFindListFunc(recommendOrderList, recommendTargetData, recommendFindList)
  local targetData = recommendTargetData.data
  if targetData == nil then
    return
  end
  local curDeep = 0
  local preNeedScienceId = targetData.id
  while curDeep < findPreRecommandMaxDeep and 0 < preNeedScienceId do
    local target_science_id = CommonUtil.GetScienceBaseType(preNeedScienceId)
    local target_science_lv = CommonUtil.GetScienceLv(preNeedScienceId)
    local curLv = DataCenter.ScienceManager:GetScienceLevel(target_science_id)
    if curDeep > baseDeep and self.reachingScienceList[target_science_id] ~= nil then
      curLv = curLv + 1
    end
    local targetData = self:GetConfigData(target_science_id, target_science_lv)
    local needData = self:GetConfigData(target_science_id, curLv + 1)
    local scienceCondIndex = 1
    preNeedScienceId = -1
    for k, v in ipairs(needData.needScience) do
      local needScienceCalcLv = DataCenter.ScienceManager:GetScienceLevel(v.scienceId)
      if self.reachingScienceList[v.scienceId] ~= nil then
        needScienceCalcLv = needScienceCalcLv + 1
      end
      if needScienceCalcLv < v.level then
        scienceCondIndex = k
        preNeedScienceId = v.scienceId + v.level
        break
      end
    end
    if preNeedScienceId < 0 then
      scienceCondIndex = #needData.needScience + 1
    end
    curDeep = curDeep + 1
    recommendFindList[curDeep] = {
      deep = curDeep,
      targetData = targetData,
      needData = needData,
      scienceCondIndex = scienceCondIndex
    }
  end
end

local function RefreshRecommendFindListFunc(self, recommendOrderList, recommendTargetData, recommendFindList)
  local curDeep = #recommendFindList
  local firstDeal = true
  local preNeedScienceId = -1
  local removePreScience = false
  while 0 < curDeep and curDeep < findPreRecommandMaxDeep and (firstDeal or removePreScience or 0 < preNeedScienceId) do
    if firstDeal or removePreScience then
      firstDeal = false
      removePreScience = false
      preNeedScienceId = -1
      local curData = recommendFindList[#recommendFindList]
      local targetData = curData.targetData
      local target_science_id = targetData.science_id
      local target_science_lv = targetData.level
      local curLv = DataCenter.ScienceManager:GetScienceLevel(target_science_id)
      if curDeep > baseDeep and self.reachingScienceList[target_science_id] ~= nil then
        curLv = curLv + 1
      end
      if target_science_lv <= curLv then
        local listLen = #recommendFindList
        recommendFindList[listLen] = nil
        removePreScience = true
      else
        local needData = self:GetConfigData(target_science_id, curLv + 1)
        local scienceCondIndex = 1
        for k, v in ipairs(needData.needScience) do
          local needScienceCalcLv = DataCenter.ScienceManager:GetScienceLevel(v.scienceId)
          if self.reachingScienceList[v.scienceId] ~= nil then
            needScienceCalcLv = needScienceCalcLv + 1
          end
          if needScienceCalcLv < v.level then
            scienceCondIndex = k
            preNeedScienceId = v.scienceId + v.level
            break
          end
        end
        if preNeedScienceId < 0 then
          scienceCondIndex = #needData.needScience + 1
        end
        recommendFindList[#recommendFindList].needData = needData
        recommendFindList[#recommendFindList].scienceCondIndex = scienceCondIndex
      end
      curDeep = #recommendFindList
    elseif 0 < preNeedScienceId then
      local target_science_id = CommonUtil.GetScienceBaseType(preNeedScienceId)
      local target_science_lv = CommonUtil.GetScienceLv(preNeedScienceId)
      local curLv = DataCenter.ScienceManager:GetScienceLevel(target_science_id)
      if curDeep > baseDeep and self.reachingScienceList[target_science_id] ~= nil then
        curLv = curLv + 1
      end
      local targetData = self:GetConfigData(target_science_id, target_science_lv)
      local needData = self:GetConfigData(target_science_id, curLv + 1)
      local scienceCondIndex = 1
      preNeedScienceId = -1
      for k, v in ipairs(needData.needScience) do
        local needScienceCalcLv = DataCenter.ScienceManager:GetScienceLevel(v.scienceId)
        if self.reachingScienceList[v.scienceId] ~= nil then
          needScienceCalcLv = needScienceCalcLv + 1
        end
        if needScienceCalcLv < v.level then
          scienceCondIndex = k
          preNeedScienceId = v.scienceId + v.level
          break
        end
      end
      if preNeedScienceId < 0 then
        scienceCondIndex = #needData.needScience + 1
      end
      curDeep = curDeep + 1
      recommendFindList[curDeep] = {
        deep = curDeep,
        targetData = targetData,
        needData = needData,
        scienceCondIndex = scienceCondIndex
      }
    end
  end
end

local function CheckRecommendTargetValidFunc(self, recommendOrderList, recommendTargetData, recommendFindList)
  local isValid = true
  if recommendTargetData.index <= 0 or recommendTargetData.index > #recommendOrderList then
    isValid = false
  elseif recommendTargetData.data then
    local targetData = recommendTargetData.data
    local isHave = DataCenter.ScienceManager:HasScienceByIdAndLevel(targetData.science_id, targetData.level)
    isValid = not isHave
  else
    isValid = false
  end
  return isValid
end

local function RefreshRecommendData(self, recommendOrderList, recommendTargetData, recommendFindList)
  if recommendTargetData.index == 0 then
    self:FindNextRecommandTargetFunc(recommendOrderList, recommendTargetData, recommendFindList)
    self:GenerateRecommendFindListFunc(recommendOrderList, recommendTargetData, recommendFindList)
  elseif recommendTargetData.index > #recommendOrderList then
    self:GenerateRecommendFindListFunc(recommendOrderList, recommendTargetData, recommendFindList)
  else
    local isValid = self:CheckRecommendTargetValidFunc(recommendOrderList, recommendTargetData, recommendFindList)
    if isValid == false then
      self:FindNextRecommandTargetFunc(recommendOrderList, recommendTargetData, recommendFindList)
      self:GenerateRecommendFindListFunc(recommendOrderList, recommendTargetData, recommendFindList)
    else
      self:RefreshRecommendFindListFunc(recommendOrderList, recommendTargetData, recommendFindList)
    end
  end
end

local function InitReachingScienceList(self)
  local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.reachingScienceList = {}
  table.walk(queueList, function(k, v)
    if v ~= nil and v:GetQueueState() ~= NewQueueState.Free then
      local scienceId = tonumber(v.itemId)
      local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        self.reachingScienceList[scienceId] = v
      end
    end
  end)
end

local function GetRecommendScience(self)
  self:TryInitRecommendOrderList()
  self:TryRefreshRecommendScience()
  if self.isShowDataDirty then
    self.isShowDataDirty = false
    self.showRecommend1Data = nil
    if #self.recommend1FindList > 0 then
      self.showRecommend1Data = self.recommend1FindList[#self.recommend1FindList].needData
    end
    self.showRecommend2Data = nil
    if 0 < #self.recommend2FindList then
      self.showRecommend2Data = self.recommend2FindList[#self.recommend2FindList].needData
    end
  end
  local recommend1Temp, recommend2Temp
  if self.showRecommend1Data then
    recommend1Temp = DataCenter.ScienceManager:GetScienceTemplate(self.showRecommend1Data.science_id, self.showRecommend1Data.level)
  end
  if self.showRecommend2Data then
    recommend2Temp = DataCenter.ScienceManager:GetScienceTemplate(self.showRecommend2Data.science_id, self.showRecommend2Data.level)
  end
  return recommend1Temp, recommend2Temp
end

local function SetDataDirty()
  DataCenter.ScienceRecommendManager.isDataDirty = true
  DataCenter.ScienceRecommendManager.isShowDataDirty = true
  DataCenter.ScienceRecommendManager:SendMsgDelayTimerFunc()
end

local function StopSendMsgDelayTimerFunc(self)
  if self.sendMsgDelayTimer ~= nil then
    self.sendMsgDelayTimer:Stop()
    self.sendMsgDelayTimer = nil
  end
end

local function SendMsgDelayTimerFunc(self)
  self:StopSendMsgDelayTimerFunc()
  self.sendMsgDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.ScienceRecommendDataDirty)
  end, 0.6)
end

ScienceRecommendManager.__init = __init
ScienceRecommendManager.__delete = __delete
ScienceRecommendManager.AddListener = AddListener
ScienceRecommendManager.RemoveListener = RemoveListener
ScienceRecommendManager.TryInitRecommendOrderList = TryInitRecommendOrderList
ScienceRecommendManager.TryRefreshRecommendScience = TryRefreshRecommendScience
ScienceRecommendManager.RefreshRecommendData = RefreshRecommendData
ScienceRecommendManager.GetRecommendScience = GetRecommendScience
ScienceRecommendManager.ClearRecommendFindListFunc = ClearRecommendFindListFunc
ScienceRecommendManager.FindNextRecommandTargetFunc = FindNextRecommandTargetFunc
ScienceRecommendManager.GenerateRecommendFindListFunc = GenerateRecommendFindListFunc
ScienceRecommendManager.RefreshRecommendFindListFunc = RefreshRecommendFindListFunc
ScienceRecommendManager.CheckRecommendTargetValidFunc = CheckRecommendTargetValidFunc
ScienceRecommendManager.SetDataDirty = SetDataDirty
ScienceRecommendManager.InitReachingScienceList = InitReachingScienceList
ScienceRecommendManager.StopSendMsgDelayTimerFunc = StopSendMsgDelayTimerFunc
ScienceRecommendManager.SendMsgDelayTimerFunc = SendMsgDelayTimerFunc
ScienceRecommendManager.GetConfigData = GetConfigData
return ScienceRecommendManager
