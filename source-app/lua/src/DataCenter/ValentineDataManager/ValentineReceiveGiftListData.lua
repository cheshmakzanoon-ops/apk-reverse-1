local ValentineReceiveGiftListData = BaseClass("ValentineReceiveGiftListData")
local ActivityValentineRankTemplate = require("DataCenter.ValentineDataManager.ActivityValentineRankTemplate")
local ActivityValentineGetTemplate = require("DataCenter.ValentineDataManager.ActivityValentineGetTemplate")
local ActValentineBoxProbabilityTemplate = require("DataCenter/ValentineDataManager/ActValentineBoxProbabilityTemplate")
local ActivityValentineBoxTemplate = require("DataCenter/ValentineDataManager/ActivityValentineBoxTemplate")

local function __init(self)
  self:AddListener()
  self.activityId = 0
  self.rankTemplateList = {}
  self.rankTemplateDic = {}
  self.rankInfoDic = {}
  self.openBoxInfo = {}
  self.openBoxLimitDic = {}
  self.openBoxPicDic = {}
  self.boxProbabilityList = {}
  self.rankReward = {}
  self.maxRank = 0
  self.totalRewardArr = {}
  self.allExistRankRewardIdList = {}
  self.boxDataDic = {}
  self.starRewardNum = 0
end

local function __delete(self)
  self:RemoveListener()
  self.activityId = nil
  self.rankTemplateList = nil
  self.rankTemplateDic = nil
  self.rankInfoDic = nil
  self.openBoxInfo = nil
  self.openBoxLimitDic = nil
  self.openBoxPicDic = nil
  self.boxProbabilityList = nil
  self.rankReward = nil
  self.maxRank = nil
  self.totalRewardArr = nil
  self.allExistRankRewardIdList = nil
  self.boxDataDic = nil
  self.starRewardNum = nil
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function ValentineReceiveGiftListData:UpdateServerData(data)
  self.activityId = toInt(data.activityId)
  self.fromLastReceiveGift = data.fromLastReceiveGift
  self.lastStarId = data.lastStarId
  self.lastRankId = data.lastRankId
  self.starRewardNum = data.starRewardNum
  self.lastOpenDay = data.lastOpenDay
  self.boxId = data.boxId
  self.rankReward = data.rankRewards
  self:UpdateTemplateData(self.activityId)
  self.totalRewardArr = data.totalRewardArr
end

function ValentineReceiveGiftListData:UpdateTemplateData(activityId)
  if activityId and 0 < activityId then
    self.activityTemplate = LocalController:instance():getLine(TableName.Activity, activityId)
  end
  if self.activityTemplate then
    local lineData = LocalController:instance():getLine(self.activityTemplate.tableInfo, toInt(self.activityTemplate.tableInfoType))
    self.activityGetData = ActivityValentineGetTemplate.New()
    self.activityGetData:UpdateData(lineData)
  end
  if self.activityGetData and (not self.rankTemplateList or 0 >= #self.rankTemplateList) then
    self.rankTemplateList = {}
    self.rankInfoDic = {}
    local targetRankGroup = self.activityGetData.group_id
    LocalController:instance():visitTable(TableName.ValentineRank, function(id, lineData)
      if lineData:getIntValue("group") ~= targetRankGroup then
        return
      end
      local rankData = ActivityValentineRankTemplate.New()
      rankData:UpdateData(lineData)
      table.insert(self.rankTemplateList, rankData)
      self.rankTemplateDic[rankData.id] = rankData
      local rank = rankData.type
      local star = rankData.star
      if rank and rank > self.maxRank then
        self.maxRank = rank
      end
      local starInfoList = self.rankInfoDic[rank]
      if not starInfoList then
        starInfoList = {}
        self.rankInfoDic[rank] = starInfoList
      end
      starInfoList[star] = rankData
      if not string.IsNullOrEmpty(rankData.reward_rank) then
        table.insert(self.allExistRankRewardIdList, rankData.id)
      end
    end)
  end
  if self.activityGetData then
    if 0 >= table.count(self.openBoxLimitDic) then
      local boxInfoStr = self.activityGetData.limit_open
      boxInfoStr = string.split(boxInfoStr, "|")
      for _, v in ipairs(boxInfoStr) do
        local boxInfo = string.split(v, ";")
        if #boxInfo == 2 then
          local itemId = toInt(boxInfo[1])
          local singleOpenLimit = toInt(boxInfo[2])
          table.insert(self.openBoxInfo, itemId)
          self.openBoxLimitDic[itemId] = singleOpenLimit
        end
      end
    end
    if 0 >= table.count(self.openBoxPicDic) then
      local boxPicStr = self.activityGetData.box_pic
      boxPicStr = string.split(boxPicStr, "|")
      for _, v in ipairs(boxPicStr) do
        local boxPicInfo = string.split(v, ";")
        if #boxPicInfo == 3 then
          local itemId = toInt(boxPicInfo[1])
          local cover = boxPicInfo[3]
          local body = boxPicInfo[2]
          local data = {}
          data.cover = cover
          data.body = body
          self.openBoxPicDic[itemId] = data
        end
      end
    end
  end
  if self.activityGetData.box_get_group and 0 >= table.count(self.boxDataDic) then
    LocalController:instance():visitTable(TableName.ValentineBox, function(id, lineData)
      local boxInfoData = ActivityValentineBoxTemplate.New()
      boxInfoData:UpdateData(lineData)
      self.boxDataDic[boxInfoData.id] = boxInfoData
    end)
  end
end

function ValentineReceiveGiftListData:GetCurExp()
  if not self.activityGetData then
    return 0
  end
  local expItemId = self.activityGetData.exp
  local expItemCount = DataCenter.ItemData:GetItemCount(expItemId)
  return expItemCount
end

function ValentineReceiveGiftListData:GetCurFragItemCount()
  if not self.activityGetData then
    return 0
  end
  local fragItemId = self.activityGetData.pieces
  local fragItemCount = DataCenter.ItemData:GetItemCount(fragItemId)
  return fragItemCount
end

function ValentineReceiveGiftListData:SingleOpenBoxMaxNum(itemId)
  return self.openBoxLimitDic[itemId] or 0
end

function ValentineReceiveGiftListData:GetCurShowRankInfo()
  local lastRankData = self.rankTemplateList[self.lastRankId]
  if not lastRankData then
    return self.rankTemplateList[1]
  end
  local targetRank = lastRankData.type
  local targetRankStar = lastRankData.star + 1
  local ret = self:GetRankDataByRankAndStar(targetRank, targetRankStar)
  ret = ret or self:GetRankDataByRankAndStar(targetRank + 1, 0)
  return ret
end

function ValentineReceiveGiftListData:GetCurRankData()
  local curExp = self:GetCurExp()
  return self:GetRankDataByExp(curExp)
end

function ValentineReceiveGiftListData:GetRankDataByExp(exp)
  if not self.rankTemplateList then
    return nil
  end
  local ret = self.rankTemplateList[1]
  if not ret then
    return nil
  end
  for _, v in ipairs(self.rankTemplateList) do
    if v.circulate ~= "" and toInt(v.circulate) == 1 then
      ret = v
      break
    end
    if exp >= v.exp_all and exp < v.exp_all + v.exp_cost then
      ret = v
      break
    end
  end
  return ret
end

function ValentineReceiveGiftListData:GetRankDataByRankAndStar(rank, star)
  local starInfoList = self.rankInfoDic[rank]
  if not starInfoList then
    return
  end
  return starInfoList[star]
end

function ValentineReceiveGiftListData:GetMaxCanOpenNum(itemId)
  return self.openBoxLimitDic[itemId] or 1
end

function ValentineReceiveGiftListData:GetBoxProbabilityData()
  if table.length(self.boxProbabilityList) == 0 then
    if self.activityGetData and self.activityGetData.box_reward then
      LocalController:instance():visitTable(TableName.Activity_Valentine_BoxReward, function(id, lineData)
        if lineData:getIntValue("group") ~= self.activityGetData.box_reward then
          return
        end
        local probabilityInfo = ActValentineBoxProbabilityTemplate.New()
        local actTempData = LocalController:instance():getLine(TableName.Activity_Valentine_BoxReward, toInt(id))
        probabilityInfo:InitData(actTempData)
        table.insert(self.boxProbabilityList, probabilityInfo)
      end)
    end
    table.sort(self.boxProbabilityList, function(a, b)
      return a.id < b.id
    end)
  end
  return self.boxProbabilityList
end

function ValentineReceiveGiftListData:GetRankMaxStar(rank)
  local ret = 0
  local starList = self.rankInfoDic[rank]
  if not starList then
    return ret
  end
  for _, v in pairs(starList) do
    if ret < v.star then
      ret = v.star
    end
  end
  return ret
end

function ValentineReceiveGiftListData:UpdateTotalReward(rewardArr)
  self.totalRewardArr = rewardArr
end

function ValentineReceiveGiftListData:GetTotalReward()
  return self.totalRewardArr
end

function ValentineReceiveGiftListData:CheckIsExistRankReward()
  local lastRankId = self.lastRankId or 0
  local curRankId = 0
  local curRankData = self:GetCurRankData()
  if not curRankData then
    return false
  end
  curRankId = curRankData.id
  for _, v in ipairs(self.allExistRankRewardIdList) do
    if v <= curRankId and v > lastRankId then
      return true
    end
  end
  return false
end

function ValentineReceiveGiftListData:GetCurShowRewardRankData()
  local lastRankId = self.lastRankId or 0
  local curRankId = 0
  local curRankData = self:GetCurRankData()
  if not curRankData then
    return false
  end
  curRankId = curRankData.id
  local targetRankId
  for _, v in ipairs(self.allExistRankRewardIdList) do
    if v > lastRankId then
      targetRankId = v
      break
    end
  end
  if not targetRankId then
    return
  end
  return self.rankTemplateDic[targetRankId] or nil
end

function ValentineReceiveGiftListData:IsReceiveAllReward()
  return self:GetCurShowRewardRankData() == nil
end

function ValentineReceiveGiftListData:GetRankReward()
  local rewardList = {}
  if not self.allExistRankRewardIdList then
    return rewardList
  end
  for k, v in pairs(self.allExistRankRewardIdList) do
    local rankData = LocalController:instance():getLine(TableName.ValentineRank, v)
    if rankData then
      local reward = {}
      reward.type = rankData.type
      local Localization = CS.GameEntry.Localization
      reward.rankName = Localization:GetString(rankData.key_full, rankData.star)
      local rewardId = rankData.reward_rank
      reward.rewardItemInfoList = self:GetRewardInfoById(rewardId)
      table.insert(rewardList, reward)
    end
  end
  return rewardList
end

function ValentineReceiveGiftListData:GetNextLevelReward()
  local curRankData = self:GetCurRankData()
  if not curRankData or not curRankData.index then
    return {}
  end
  local index = curRankData.index + 1
  local rewardInfoList = {}
  local rewardId = 0
  LocalController:instance():visitTable(TableName.ValentineRank, function(id, lineData)
    if lineData:getIntValue("index") ~= index then
      return
    end
    local rankData = ActivityValentineRankTemplate.New()
    rankData:UpdateData(lineData)
    rewardId = rankData.reward_star
  end)
  rewardInfoList = self:GetRewardInfoById(rewardId)
  return rewardInfoList
end

function ValentineReceiveGiftListData:GetRewardInfoById(rewardId)
  local rewardList = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local rewardItemInfo = {}
          rewardItemInfo.itemId = id
          rewardItemInfo.count = nums[i] or 0
          rewardItemInfo.rewardType = RewardType.GOODS
          table.insert(rewardList, rewardItemInfo)
        end
      end
    end
  end
  return rewardList
end

ValentineReceiveGiftListData.__init = __init
ValentineReceiveGiftListData.__delete = __delete
ValentineReceiveGiftListData.AddListener = AddListener
ValentineReceiveGiftListData.RemoveListener = RemoveListener
return ValentineReceiveGiftListData
