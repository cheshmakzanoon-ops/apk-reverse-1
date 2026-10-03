local ActCrazyRockDataManager = BaseClass("ActCrazyRockDataManager")
local Localization = CS.GameEntry.Localization
local CrazyRockSongData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockSongData")
local CrazyRockRankData = require("DataCenter.ActCrazyRockDataManager.Data.CrazyRockRankData")
local ActivityFesMusicTemplate = require("DataCenter.ActCrazyRockDataManager.Template.ActivityFesMusicTemplate")
local CrazyRockActData = require("DataCenter.ActCrazyRockDataManager.Data.CrazyRockActData")
local CrazyRockSettleData = require("DataCenter.ActCrazyRockDataManager.Data.CrazyRockSettleData")

function ActCrazyRockDataManager:__init()
  self.songDataDic = {}
  self.rankDataList = {}
  self.showUIGamePlayFlag = nil
  self.crazyRockActConfigList = {}
  self.actDataList = {}
  self.lastShareScoreTime = 0
  self.shareCd = -1
end

function ActCrazyRockDataManager:__delete()
  self.songDataDic = nil
  self.rankDataList = nil
  self.showUIGamePlayFlag = nil
  self.crazyRockActConfigList = nil
  self.actDataList = nil
  self.lastShareScoreTime = nil
  self.shareCd = nil
end

function ActCrazyRockDataManager:UpdateActInfo(message)
  if not message or not message.activityId then
    Logger.LogError("message or activityId is nil")
    return
  end
  local activityId = message.activityId
  local actData = self.actDataList[activityId]
  actData = actData or CrazyRockActData.New()
  actData:ParsActData(message)
  self.actDataList[activityId] = actData
  if not message.taskArr then
    Logger.LogError("taskArr is nil")
  else
    DataCenter.ActCrazyRockTaskManager:UpdateServerData(message)
  end
  self:InitCrazyRockConfig(activityId)
  EventManager:GetInstance():Broadcast(EventId.CrazyRockActInfoUpdate)
end

function ActCrazyRockDataManager:GetSongData(songId)
  if not table.containsKey(self.songDataDic, songId) then
    local songData = CrazyRockSongData.New()
    songData:UpdateData(songId)
    self.songDataDic[songId] = songData
  end
  return self.songDataDic[songId]
end

function ActCrazyRockDataManager:OnRecRankData(message)
  if not message then
    Logger.LogError("message is nil")
    return
  end
  local activityId = message.activityId
  if not activityId then
    Logger.LogError("activity id is nil")
    return
  end
  local rankData = self.rankDataList[activityId]
  rankData = rankData or CrazyRockRankData.New()
  rankData:ParsRankInfo(message)
  self.rankDataList[activityId] = rankData
  EventManager:GetInstance():Broadcast(EventId.CrazyRockRecRankData)
end

function ActCrazyRockDataManager:GetRankData(activityId)
  if not activityId or not tonumber(activityId) then
    Logger.LogError("activity id is nil")
    return nil
  end
  return self.rankDataList[tonumber(activityId)]
end

function ActCrazyRockDataManager:ShareToChat(score, advancePercent)
  local share_param = {}
  share_param.post = PostType.MusicFestival2025_Share
  share_param.postType = PostType.MusicFestival2025_Share
  local data = {}
  data.score = score
  data.advancePercent = advancePercent
  share_param.param = data
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function ActCrazyRockDataManager:CheckOpenGamePlay(activityId, closeFunc)
  local SHOW_GAMEPLAY_FLAG_KEY = "ActCrazyRock_UI_Gameplay_showFlag_" .. activityId
  if self.showUIGamePlayFlag == nil then
    local key = SHOW_GAMEPLAY_FLAG_KEY .. LuaEntry.Player.uid
    local flag = CommonUtil.PlayerPrefsGetBool(key, false)
    if flag == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockRulesGamePlay, {anim = true}, closeFunc)
      CommonUtil.PlayerPrefsSetBool(key, true)
      return true
    end
    self.showUIGamePlayFlag = true
  end
  return false
end

function ActCrazyRockDataManager:InitCrazyRockConfig(activityId)
  if not self.crazyRockActConfigList[activityId] then
    local crazyRockActConfig = {}
    local actTempData = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
    if actTempData then
      local actType = tonumber(actTempData.type) or 0
      if actType == EnumActivity.CrazyRock.Type then
        local id = tonumber(actTempData.tableInfoType) or 0
        local musicData = LocalController:instance():getLine(TableName.Festival_Music_Config, id)
        if musicData then
          crazyRockActConfig = ActivityFesMusicTemplate.New()
          crazyRockActConfig:UpdateData(musicData)
          self.crazyRockActConfigList[activityId] = crazyRockActConfig
        end
      end
    end
  end
end

function ActCrazyRockDataManager:GetCrazyRockActRewardConfig(activityId)
  if not activityId or not tonumber(activityId) then
    return nil
  end
  local reward = {}
  local actData = self.actDataList[tonumber(activityId)]
  if not actData or not actData.scoreRewardArr then
    Logger.LogError("scoreRewardArr is nil")
    return reward
  end
  local scoreRewardArr = actData.scoreRewardArr
  for k, v in pairs(scoreRewardArr) do
    local beginNum = tonumber(v.min) or 0
    local endNum = tonumber(v.max) or 0
    local rewardArr = v.reward
    table.insert(reward, {
      beginNum = beginNum,
      endNum = endNum,
      rewardArr = rewardArr,
      index = k
    })
  end
  table.sort(reward, function(a, b)
    return a.beginNum > b.beginNum
  end)
  for k, v in pairs(reward) do
    v.index = k
  end
  return reward
end

function ActCrazyRockDataManager:GetHistoryTopScore(activityId)
  if not activityId or not tonumber(activityId) then
    return -1
  end
  local actData = self.actDataList[tonumber(activityId)]
  if not actData or not actData.historyTopScore then
    Logger.LogError("historyTopScore is nil")
    return
  end
  return actData.historyTopScore
end

function ActCrazyRockDataManager:GetActCost(activityId)
  if not activityId then
    Logger.LogError("activityId is nil")
    return nil
  end
  local crazyRockActConfig = self.crazyRockActConfigList[tonumber(activityId)]
  if not crazyRockActConfig or not crazyRockActConfig.cost then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.lastShowLogTime == nil or curTime - self.lastShowLogTime > 1000 then
      self.lastShowLogTime = curTime
      Logger.LogError("crazyRockActConfig or cost is nil")
    end
    return nil
  end
  local cost = crazyRockActConfig.cost
  local costArr = string.split(cost, ";")
  local costList = {}
  costList.itemId = costArr[1]
  costList.itemNum = tonumber(costArr[2]) or 0
  return costList
end

function ActCrazyRockDataManager:GetRedCount(activityId)
  local result = 0
  if 0 < DataCenter.ActCrazyRockTaskManager:GetRedDotNum(activityId) then
    result = result + 1
  end
  local cost = self:GetActCost(tonumber(activityId))
  if cost and cost.itemId and cost.itemNum and 0 < cost.itemNum then
    local itemCount = DataCenter.ItemData:GetItemCount(cost.itemId)
    if itemCount >= cost.itemNum then
      result = result + 1
    end
  end
  return 0 < result and 1 or 0
end

function ActCrazyRockDataManager:OnRecSettleData(data)
  local settleData = CrazyRockSettleData.New()
  settleData:ParsSettleInfo(data)
  local actData = self.actDataList[settleData.activityId]
  if actData and actData.historyTopScore < settleData.score then
    actData:UpdateHistoryTopScore(settleData.score)
  end
  DataCenter.RewardManager:AddRewardsAndRes(settleData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockGameSettlement, {anim = true}, settleData)
end

function ActCrazyRockDataManager:GetGarde(score, activityId)
  local grade = 0
  local actData = self.actDataList[activityId]
  if not actData or not actData.scoreRewardArr then
    Logger.LogError("scoreRewardArr is nil")
    return grade
  end
  local scoreRewardArr = actData.scoreRewardArr
  for k, v in pairs(scoreRewardArr) do
    local beginNum = tonumber(v.min) or 0
    local endNum = tonumber(v.max) or 0
    if score == beginNum or score == endNum or score > beginNum and score < endNum then
      grade = k
      break
    end
  end
  return grade
end

function ActCrazyRockDataManager:GetMusicConfig(activityId)
  if not table.containsKey(self.crazyRockActConfigList, activityId) then
    self:InitCrazyRockConfig(activityId)
  end
  return self.crazyRockActConfigList[activityId]
end

function ActCrazyRockDataManager:GetShareCd(activityId)
  local config = self:GetMusicConfig(activityId)
  if not (config and config.share_cd) or not tonumber(config.share_cd) then
    Logger.LogError("config or share_cd is nil")
    return 0
  end
  return tonumber(config.share_cd)
end

function ActCrazyRockDataManager:GetIfShareScore(activityId)
  if self.lastShareScoreTime == nil or not activityId then
    return true
  end
  if self.shareCd == -1 then
    self.shareCd = self:GetShareCd(activityId)
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local delta = currentTime - self.lastShareScoreTime
  return delta / 1000 >= self.shareCd
end

function ActCrazyRockDataManager:UpdateLastShareScoreTime()
  self.lastShareScoreTime = UITimeManager:GetInstance():GetServerTime()
end

function ActCrazyRockDataManager:GetDeltaTime(activityId)
  if self.lastShareScoreTime == nil then
    return 0
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local cd = self:GetShareCd(activityId)
  local delta = self.lastShareScoreTime / 1000 + cd - currentTime / 1000
  return math.floor(delta)
end

function ActCrazyRockDataManager:GetActDataById(activityId)
  if not self.actDataList then
    return nil
  end
  return self.actDataList[toInt(activityId)]
end

return ActCrazyRockDataManager
