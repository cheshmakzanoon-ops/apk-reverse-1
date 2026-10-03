local ActTrendsData = BaseClass("ActTrendsData")

local function __init(self)
  self.config_id = 0
  self.start_time = 0
  self.end_time = 0
  self.is_get_reward = false
  self.cur_count = 0
  self.reward_array = nil
end

local function __delete(self)
  self.config_id = nil
  self.start_time = nil
  self.end_time = nil
  self.is_get_reward = nil
  self.cur_count = nil
  self.reward_array = nil
end

function ActTrendsData:SeasonTrendsData(msg, groupStartTime)
  self.config_id = msg.trend_id
  local configData = LocalController:instance():getLine(TableName.LW_Season_Trends, self.config_id)
  if configData then
    self.start_time = groupStartTime + 86400 * (configData.unlock_time - 1) * 1000
    self.end_time = groupStartTime + 86400 * (configData.expired_time - 1) * 1000
  else
    self.start_time = nil
    self.end_time = nil
  end
  self.type = configData.type
  self.groupIndex = configData.week_stage
  self.is_get_reward = msg.reward == 1
  self.cur_count = msg.cur_count
  self.day_donate = msg.day_donate
  self.reward_array = DataCenter.RewardManager:ReturnRewardParamForView(msg.rewards_show)
end

return ActTrendsData
