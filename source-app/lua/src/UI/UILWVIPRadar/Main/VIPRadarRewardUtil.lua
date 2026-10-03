local VIPRadarRewardUtil = {}
local math_floor = math.floor
local math_min = math.min

function VIPRadarRewardUtil.to_array(items)
  if type(items) ~= "table" then
    return {}
  end
  local result = {}
  local length = #items
  if 0 < length then
    for index = 1, length do
      result[index] = items[index]
    end
  else
    for _, value in pairs(items) do
      result[#result + 1] = value
    end
  end
  return result
end

function VIPRadarRewardUtil.deep_copy(value)
  if type(value) ~= "table" then
    return value
  end
  local copy = {}
  for k, v in pairs(value) do
    copy[k] = VIPRadarRewardUtil.deep_copy(v)
  end
  return copy
end

function VIPRadarRewardUtil.get_reward_quantity(reward)
  if type(reward) ~= "table" then
    return 0
  end
  local value = reward.value
  local count = reward.count or reward.num
  if count == nil then
    count = value.count or value.num
  end
  return tonumber(count) or 0
end

function VIPRadarRewardUtil.set_reward_quantity(reward, amount)
  if type(reward) ~= "table" then
    return
  end
  local targetAmount = math_floor((tonumber(amount) or 0) + 0.5)
  if targetAmount < 0 then
    targetAmount = 0
  end
  
  local function assign_explicit(target)
    if target.count ~= nil then
      target.count = targetAmount
      return true
    end
    if target.num ~= nil then
      target.num = targetAmount
      return true
    end
    return false
  end
  
  if assign_explicit(reward) then
    return
  end
  if type(reward.value) ~= "table" then
    reward.value = {}
  end
  if not assign_explicit(reward.value) then
    reward.value.num = targetAmount
  end
end

function VIPRadarRewardUtil.normalize_reward_info(reward)
  if type(reward) ~= "table" then
    return nil
  end
  local rewardType = reward.rewardType or reward.type
  if rewardType == nil then
    return nil
  end
  rewardType = type(rewardType) == "string" and tonumber(rewardType) or rewardType
  local value = reward.value
  local itemId = reward.itemId or reward.id
  if (itemId == nil or itemId == "") and type(value) == "table" then
    itemId = value.itemId or value.id or value.goodsId
  end
  itemId = type(itemId) == "string" and tonumber(itemId) or itemId
  local count = reward.count
  if count == nil and type(value) == "table" then
    count = value.count
  end
  count = type(count) == "string" and tonumber(count) or count
  if count == nil then
    count = VIPRadarRewardUtil.get_reward_quantity(reward)
  end
  local result = {
    rewardType = rewardType,
    itemId = itemId,
    count = count or 0,
    value = value,
    raw = reward
  }
  if reward.itemColor then
    result.itemColor = reward.itemColor
  end
  if reward.quality then
    result.quality = reward.quality
  end
  if reward.icon then
    result.icon = reward.icon
  end
  return result
end

function VIPRadarRewardUtil.sum_reward_quantities(list)
  local total = 0
  if type(list) ~= "table" then
    return total
  end
  for _, reward in ipairs(list) do
    local quantity = VIPRadarRewardUtil.get_reward_quantity(reward)
    if 0 < quantity then
      total = total + quantity
    end
  end
  return total
end

function VIPRadarRewardUtil.build_daily_reward_display(dailyRewards, overrideTotal)
  local rewardsArray = VIPRadarRewardUtil.to_array(dailyRewards)
  local display = {}
  local originalTotals = {}
  local totalOriginal = 0
  for index, reward in ipairs(rewardsArray) do
    local copy = VIPRadarRewardUtil.deep_copy(reward)
    display[index] = copy
    local quantity = VIPRadarRewardUtil.get_reward_quantity(reward)
    if quantity < 0 then
      quantity = 0
    end
    originalTotals[index] = quantity
    totalOriginal = totalOriginal + quantity
  end
  if overrideTotal and 0 < overrideTotal and 0 < #display then
    local remaining = overrideTotal
    local distributeBase = totalOriginal
    if distributeBase <= 0 then
      local average = math_floor(overrideTotal / #display)
      if average < 0 then
        average = 0
      end
      for index, copy in ipairs(display) do
        local newQty
        if index == #display then
          newQty = remaining
        else
          newQty = math_min(average, remaining)
        end
        if newQty < 0 then
          newQty = 0
        end
        remaining = remaining - newQty
        if remaining < 0 then
          newQty = newQty + remaining
          remaining = 0
        end
        VIPRadarRewardUtil.set_reward_quantity(copy, newQty)
      end
      if 0 < remaining then
        local last = display[#display]
        VIPRadarRewardUtil.set_reward_quantity(last, VIPRadarRewardUtil.get_reward_quantity(last) + remaining)
      end
    else
      for index, copy in ipairs(display) do
        local original = originalTotals[index]
        local newQty
        if index == #display then
          newQty = remaining
        else
          newQty = math_floor(overrideTotal * original / distributeBase + 0.5)
        end
        if newQty < 0 then
          newQty = 0
        end
        if remaining < newQty then
          newQty = remaining
        end
        remaining = remaining - newQty
        VIPRadarRewardUtil.set_reward_quantity(copy, newQty)
      end
      if 0 < remaining then
        local last = display[#display]
        VIPRadarRewardUtil.set_reward_quantity(last, VIPRadarRewardUtil.get_reward_quantity(last) + remaining)
      end
    end
  end
  return display, totalOriginal
end

function VIPRadarRewardUtil.build_extra_reward_display(extraRewards, dailyMax, dailyRewardCurrentTotal, adjustByDailyDiff)
  local rewardsArray = VIPRadarRewardUtil.to_array(extraRewards)
  local display = {}
  for index, reward in ipairs(rewardsArray) do
    display[index] = VIPRadarRewardUtil.deep_copy(reward)
  end
  if not (adjustByDailyDiff and dailyMax) or dailyMax <= 0 or #display == 0 then
    return display
  end
  local diff = dailyMax - (dailyRewardCurrentTotal or 0)
  if diff <= 0 then
    return display
  end
  local totalExtra = VIPRadarRewardUtil.sum_reward_quantities(rewardsArray)
  if totalExtra <= 0 then
    return {}
  end
  local remaining = math_min(diff, totalExtra)
  local adjusted = {}
  for _, reward in ipairs(display) do
    if remaining <= 0 then
      adjusted[#adjusted + 1] = reward
    else
      local quantity = VIPRadarRewardUtil.get_reward_quantity(reward)
      if 0 < quantity then
        local reduce = math_min(quantity, remaining)
        local newQty = quantity - reduce
        remaining = remaining - reduce
        if 0 < newQty then
          VIPRadarRewardUtil.set_reward_quantity(reward, newQty)
          adjusted[#adjusted + 1] = reward
        end
      end
    end
  end
  return adjusted
end

function VIPRadarRewardUtil.build_reward_key(reward)
  if not reward then
    return ""
  end
  local rewardType = reward.rewardType or reward.type or ""
  local itemId = reward.itemId or reward.id or ""
  return tostring(rewardType) .. ":" .. tostring(itemId)
end

return VIPRadarRewardUtil
