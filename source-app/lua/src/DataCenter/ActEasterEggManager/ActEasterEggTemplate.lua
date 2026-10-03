local ActEasterEggTemplate = BaseClass("ActEasterEggTemplate")

function ActEasterEggTemplate:__init()
  self.id = 0
  self.throwingCost = 0
  self.throwingCostNum = 0
  self.throwingTimes = 0
  self.pickingUpCostItemId = 0
  self.pickingUpCostItemNum = 0
  self.pickingUpTimes = 0
  self.digLimitTime = 0
  self.thumbUpGiveItemId = 0
  self.thumbUpGiveItemNum = 0
  self.commentGiveItemId = 0
  self.commentGiveItemNum = 0
  self.tipsGroup = 0
  self.wordLimit = {}
  self.coinsThumbsLimit = 0
  self.coinsCommitLimit = 0
  self.oneKeyToTranslateSwitch = false
  self.inputTips = {}
  self.amazingUpgradeTimes = 0
  self.heroHeadList = {}
  self.score_item_id = ""
  self.task_stage_reward = ""
  self.amazing_egg_rward = {}
  self.amazing_egg_show_prob = {}
  self.amazing_egg_res = {}
  self.amazing_egg_name = {}
  self.intervalCanCommentTimes = {}
end

function ActEasterEggTemplate:__delete()
  self.id = nil
  self.throwingCost = nil
  self.throwingCostNum = nil
  self.throwingTimes = nil
  self.pickingUpCostItemId = nil
  self.pickingUpCostItemNum = nil
  self.pickingUpTimes = nil
  self.digLimitTime = nil
  self.thumbUpGiveItemId = nil
  self.thumbUpGiveItemNum = nil
  self.commentGiveItemId = nil
  self.commentGiveItemNum = nil
  self.tipsGroup = nil
  self.wordLimit = nil
  self.coinsThumbsLimit = nil
  self.coinsCommitLimit = nil
  self.oneKeyToTranslateSwitch = nil
  self.inputTips = nil
  self.amazingUpgradeTimes = nil
  self.heroHeadList = nil
  self.score_item_id = nil
  self.task_stage_reward = nil
  self.amazing_egg_rward = nil
  self.amazing_egg_show_prob = nil
  self.amazing_egg_res = nil
  self.amazing_egg_name = nil
  self.intervalCanCommentTimes = nil
end

function ActEasterEggTemplate:UpdateData(rowData)
  if not rowData then
    Logger.LogError("rowData is nil")
    return
  end
  self.id = rowData:getValue("id") or 0
  local throwingCost = rowData:getValue("throwing_cost")
  local throwingCostArr = string.split(throwingCost, ";")
  self.throwingCost = tonumber(throwingCostArr[1])
  self.throwingCostNum = tonumber(throwingCostArr[2])
  self.throwingTimes = rowData:getValue("throwing_times") or 0
  local pickingUpCostStr = rowData:getValue("picking_up_cost") or ""
  local costArr = string.split(pickingUpCostStr, ";")
  if costArr and type(costArr) == "table" and #costArr == 2 then
    self.pickingUpCostItemId = tonumber(costArr[1])
    self.pickingUpCostItemNum = tonumber(costArr[2])
  end
  self.pickingUpTimes = rowData:getValue("picking_up_times") or 0
  self.digLimitTime = rowData:getValue("dig_limit_time")
  local thumbUpGiveStr = rowData:getValue("thumbs_up_give") or ""
  local thumbUpGive = string.split(thumbUpGiveStr, ";")
  if thumbUpGive and type(thumbUpGive) == "table" and #thumbUpGive == 2 then
    self.thumbUpGiveItemId = tonumber(thumbUpGive[1])
    self.thumbUpGiveItemNum = tonumber(thumbUpGive[2])
  end
  local commentGiveStr = rowData:getValue("comment_give") or ""
  local commentGive = string.split(commentGiveStr, ";")
  if commentGive and type(commentGive) == "table" and #commentGive == 2 then
    self.commentGiveItemId = tonumber(commentGive[1])
    self.commentGiveItemNum = tonumber(commentGive[2])
  end
  self.tipsGroup = rowData:getValue("tips_group") ~= nil and tonumber(rowData:getValue("tips_group")) or 0
  local wordLimit = rowData:getValue("word_limit") or {}
  local worldLimitList = string.split(wordLimit, "|")
  for k, v in pairs(worldLimitList) do
    local wordNum = string.split(v, ";")
    if type(wordNum) == "table" and #wordNum == 2 then
      self.wordLimit[k] = {
        minWordNum = tonumber(wordNum[1]),
        maxWordNum = tonumber(wordNum[2])
      }
    end
  end
  local coinsLimit = rowData:getValue("coins_limit") or ""
  local coinsLimitArr = string.split(coinsLimit, ";")
  if type(coinsLimitArr) == "table" and #coinsLimitArr == 2 then
    self.coinsThumbsLimit = tonumber(coinsLimitArr[1])
    self.coinsCommitLimit = tonumber(coinsLimitArr[2])
  end
  self.oneKeyToTranslateSwitch = rowData:getValue("translate") and tonumber(rowData:getValue("translate")) == 1 or false
  local inputStr = rowData:getValue("tips_input") or ""
  local inputArr = string.split(inputStr, "|")
  if type(inputArr) == "table" and #inputArr == 4 then
    self.inputTips = inputArr
  end
  self.amazingUpgradeTimes = tonumber(rowData:getValue("amazing_egg_times"))
  local headStr = rowData:getValue("hero_head")
  local heroHeadList = string.split(headStr, ";")
  for k, v in pairs(heroHeadList) do
    table.insert(self.heroHeadList, tonumber(v))
  end
  self.score_item_id = rowData:getValue("score_item_id")
  self.task_stage_reward = rowData:getValue("task_stage_reward")
  self.amazing_egg_rward = rowData:getValue("amazing_egg_rward")
  self.amazing_egg_show_prob = rowData:getValue("amazing_egg_show_prob")
  self.amazing_egg_res = rowData:getValue("amazing_egg_res")
  self.amazing_egg_name = rowData:getValue("amazing_egg_name")
  if self.amazing_egg_rward and self.amazing_egg_show_prob and self.amazing_egg_res and self.amazing_egg_name then
    self.eggDropDisplay = {}
    for i, v in ipairs(self.amazing_egg_rward) do
      local item = {}
      item.rewardId = v
      item.percent = self.amazing_egg_show_prob[i] * 0.01
      item.icon = self.amazing_egg_res[i]
      item.name = self.amazing_egg_name[i]
      table.insert(self.eggDropDisplay, item)
    end
  end
  local per_comment = rowData:getValue("per_comment") or ""
  self.intervalCanCommentTimes = string.string2array_num_oneSep(per_comment, "|")
end

function ActEasterEggTemplate:GetWordLimit(eggEditType)
  if self.wordLimit then
    local limit = self.wordLimit[eggEditType]
    return limit.minWordNum, limit.maxWordNum
  end
end

function ActEasterEggTemplate:GetTipsInput(eggEditType)
  if self.inputTips then
    return self.inputTips[eggEditType]
  end
end

function ActEasterEggTemplate:GetOneKeyToTranslate()
  return self.oneKeyToTranslateSwitch
end

function ActEasterEggTemplate:GetIntervalCanCommentTimes()
  return self.intervalCanCommentTimes
end

function ActEasterEggTemplate:GetTaskStageRewardList()
  if self.taskStageRewardList then
    return self.taskStageRewardList
  end
  if string.IsNullOrEmpty(self.task_stage_reward) then
    Logger.LogError("task_stage_reward is nil")
    return
  end
  self.taskStageRewardList = {}
  local strSplited = string.split(self.task_stage_reward, "|")
  for i, v in pairs(strSplited) do
    local strSplited2 = string.split(v, ";")
    if #strSplited2 == 3 then
      local reward = {}
      reward.count = tonumber(strSplited2[3])
      reward.rewardType = RewardType.GOODS
      reward.itemId = tonumber(strSplited2[2])
      local point = {
        progress = tonumber(strSplited2[1]),
        reward = reward
      }
      table.insert(self.taskStageRewardList, point)
    end
  end
  return self.taskStageRewardList
end

return ActEasterEggTemplate
