local ActWinterStormResultData = BaseClass("ActWinterStormResultData")
local TeamArr = require("DataCenter.ActWinterStormManager.TeamArr")

function ActWinterStormResultData:__init()
  self.isWin = false
  self.taskRewardParam = 0
  self.taskRewardId = 0
  self.fightRewardParam = 0
  self.fightRewardId = 0
  self.reward = {}
  self.battleScore = {}
  self.mvp = {}
  self.scoreInfo = {}
  self.beforeScore = 0
end

function ActWinterStormResultData:__delete()
  self.isWin = false
  self.taskRewardParam = 0
  self.taskRewardId = 0
  self.fightRewardParam = 0
  self.fightRewardId = 0
  self.reward = {}
  self.battleScore = {}
  self.mvp = {}
  self.scoreInfo = {}
  self.beforeScore = 0
end

function ActWinterStormResultData:ParseData(message)
  if message == nil then
    return
  end
  if message.isWin ~= nil then
    self.isWin = message.isWin
  end
  if message.taskRewardParam ~= nil then
    self.taskRewardParam = message.taskRewardParam
  end
  if message.taskRewardId ~= nil then
    self.taskRewardId = message.taskRewardId
  end
  if message.fightRewardParam ~= nil then
    self.fightRewardParam = message.fightRewardParam
  end
  if message.fightRewardId ~= nil then
    self.fightRewardId = message.fightRewardId
  end
  local reward = message.reward
  if reward ~= nil then
    DataCenter.RewardManager:AddRewards(reward)
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(reward) or {}
  end
  local battleScore = message.battleScore
  if battleScore ~= nil then
    self.battleScore = {}
    for _, v in pairs(battleScore) do
      local side = v.side or 0
      local score = v.score or 0
      self.battleScore[side] = score
    end
  end
  local mvp = message.mvp
  if mvp ~= nil then
    self.mvp = {}
    for _, v in pairs(mvp) do
      local oneData = TeamArr.New()
      oneData:ParseData(v)
      table.insert(self.mvp, oneData)
    end
  end
  local scoreInfo = message.scoreInfo
  if scoreInfo ~= nil then
    self.scoreInfo = {}
    for _, v in ipairs(scoreInfo) do
      self.scoreInfo[v.type] = {
        param1 = v.param1,
        param2 = v.param2
      }
    end
  end
  local beforeScore = message.beforeScore
  if beforeScore ~= nil then
    self.beforeScore = beforeScore
  end
end

return ActWinterStormResultData
