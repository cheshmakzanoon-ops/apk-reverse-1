local ActivityRevivalConfigTemplate = BaseClass("ActivityRevivalConfigTemplate")

function ActivityRevivalConfigTemplate:__init()
  self.id = 0
  self.type = 0
  self.day_list = 0
  self.base_reward = ""
  self.base_reward_show = ""
  self.phase_name = ""
  self.phase_des = ""
  self.phase_open_pic = ""
  self.phase_open_fx = ""
  self.phase_close_pic = ""
end

function ActivityRevivalConfigTemplate:__delete()
  self.id = nil
  self.type = nil
  self.day_list = nil
  self.base_reward = nil
  self.base_reward_show = nil
  self.phase_name = nil
  self.phase_des = nil
  self.phase_open_pic = nil
  self.phase_open_fx = nil
  self.phase_close_pic = nil
  self.score_list = nil
  self.get_score_rules = nil
  self.parsed_base_reward_show = nil
  self.replace_reward_show = nil
end

function ActivityRevivalConfigTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.day_list = rowData:getValue("day_list") or 0
  self.base_reward = rowData:getValue("base_reward") or ""
  self.base_reward_show = rowData:getValue("base_reward_show") or ""
  self.phase_name = rowData:getValue("phase_name") or ""
  self.phase_des = rowData:getValue("phase_des") or ""
  self.phase_open_pic = rowData:getValue("phase_open_pic") or ""
  self.phase_open_fx = rowData:getValue("phase_open_fx") or ""
  self.phase_close_pic = rowData:getValue("phase_close_pic") or ""
  self.score_list = rowData:getValue("score_list")
  self.get_score_rules = rowData:getValue("get_score_rules")
end

function ActivityRevivalConfigTemplate:GetParsedBaseRewardShow()
  if not self.parsed_base_reward_show then
    self.parsed_base_reward_show = {}
    local array = string.split(self.base_reward_show, ",")
    for _, v in ipairs(array) do
      table.insert(self.parsed_base_reward_show, DataCenter.RewardManager:ParseRewardsStr(v))
    end
  end
  return self.parsed_base_reward_show
end

function ActivityRevivalConfigTemplate:GetReplaceRewardShow(index, itemId)
  if self.replace_reward_show == nil then
    self.replace_reward_show = {}
  end
  local rewardList = self.replace_reward_show[index]
  if rewardList ~= nil then
    return rewardList
  end
  rewardList = {}
  local parsed_base_reward_show = self:GetParsedBaseRewardShow()
  local parsed_base = parsed_base_reward_show[index]
  if parsed_base then
    for _, reward in ipairs(parsed_base) do
      if reward and reward.itemId ~= itemId then
        table.insert(rewardList, reward)
      end
    end
  end
  self.replace_reward_show[index] = rewardList
  return rewardList
end

return ActivityRevivalConfigTemplate
