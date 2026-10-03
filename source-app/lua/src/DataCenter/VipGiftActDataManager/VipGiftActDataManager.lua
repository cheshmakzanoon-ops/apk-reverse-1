local VipGiftActDataManager = BaseClass("VipGiftActDataManager")
local EventManager = EventManager:GetInstance()
local EventId = _ENV.EventId
local math_floor = math.floor
local math_max = math.max
local tonumber = _ENV.tonumber
local type = _ENV.type
local pairs = _ENV.pairs
local ipairs = _ENV.ipairs
local table_insert = table.insert
local LocalController = _ENV.LocalController
local tostring = _ENV.tostring
local string_gsub = string.gsub
local string_lower = string.lower
local UITimeManager = _ENV.UITimeManager
local MILLISECONDS_PER_DAY = 86400000
local TIMESTAMP_SECOND_THRESHOLD = 1000000000000

local function get_reward_quantity(reward)
  if type(reward) ~= "table" then
    return 0
  end
  local value = reward.value
  local count = reward.count or reward.num
  if count == nil and type(value) == "table" then
    count = value.count or value.num
  end
  return tonumber(count) or 0
end

local function to_reward_array(source)
  source = DataCenter.RewardManager:ReturnRewardParamForMessage(source)
  if not source then
    return {}
  end
  local result = {}
  local length = #source
  if 0 < length then
    for index = 1, length do
      result[index] = source[index]
    end
  else
    for _, value in pairs(source) do
      result[#result + 1] = value
    end
  end
  return result
end

local function convert_config_box_param(raw)
  if type(raw) ~= "table" then
    return {}
  end
  local goodsType = RewardType and RewardType.GOODS or 7
  local result = {}
  
  local function push(id, count)
    if id == nil then
      return
    end
    local numericCount = tonumber(count) or 0
    local numericId = tonumber(id) or id
    local entry = {
      rewardType = goodsType,
      itemId = numericId,
      count = numericCount,
      value = {id = numericId, num = numericCount}
    }
    result[#result + 1] = entry
  end
  
  local length = #raw
  if 0 < length and type(raw[1]) ~= "table" then
    push(raw[1], raw[2])
  else
    for _, item in ipairs(raw) do
      if type(item) == "table" then
        if item.type or item.rewardType or item.value then
          local count = item.count or item.value and (item.value.num or item.value.count) or item.num
          push(item.itemId or item.id or item.value and item.value.id or item[1], count or item[2])
        else
          push(item[1] or item.id, item[2] or item.count)
        end
      end
    end
  end
  return result
end

local function compute_current_day_from_timestamp(timestamp)
  local stamp = tonumber(timestamp) or 0
  if 0 < stamp and stamp < TIMESTAMP_SECOND_THRESHOLD then
    stamp = stamp * 1000
  end
  if stamp <= 0 then
    return 0
  end
  local serverTime = UITimeManager and UITimeManager:GetInstance():GetServerTime() or 0
  local delta = serverTime - stamp
  if delta < 0 then
    delta = 0
  end
  local dayIndex = math_floor(delta / MILLISECONDS_PER_DAY) + 1
  if dayIndex < 1 then
    dayIndex = 1
  end
  return dayIndex
end

local function compute_max_day_from_progress(dailyCount, dailyMax)
  local perDay = math_floor(math_max(tonumber(dailyMax) or 0, 0))
  local total = math_floor(math_max(tonumber(dailyCount) or 0, 0))
  if perDay <= 0 or total <= 0 then
    return 0
  end
  local maxDay = math_floor((total + perDay - 1) / perDay)
  if maxDay < 1 then
    maxDay = 1
  end
  return maxDay
end

local function reset_activity_data(target, actId)
  if type(target) ~= "table" then
    return
  end
  if actId ~= nil then
    target.activityId = toInt and toInt(actId) or tonumber(actId) or actId
  elseif target.activityId == nil then
    target.activityId = 0
  end
  target.freeReceived = false
  target.dailyReward = {}
  target.timestamp = 0
  target.dispearTime = 0
  target.dailyMax = 0
  target.accumulateLimit = 0
  target.dailyCount = 0
  target.accumulateCount = 0
  target.currentDayCount = 0
  target.extraReward = {}
  target.extraRewardList = {}
end

local function get_reward_identity(reward)
  if type(reward) ~= "table" then
    return nil
  end
  local rewardType = reward.rewardType or reward.type or reward.Type
  local itemId = reward.itemId or reward.item_id or reward.goodsId or reward.goods_id
  local value = reward.value or reward.Value
  if not rewardType and type(value) == "table" then
    rewardType = value.rewardType or value.type or value.Type
  end
  if not itemId and type(value) == "table" then
    itemId = value.id or value.itemId or value.item_id or value.goodsId or value.goods_id
  end
  if not rewardType then
    return nil
  end
  return tostring(rewardType) .. "#" .. tostring(itemId or "")
end

local function build_reward_quantity_map(list)
  local map = {}
  local source = list
  if not source then
    source = {}
  elseif #source == 0 then
    local temp = {}
    for _, value in pairs(source) do
      temp[#temp + 1] = value
    end
    source = temp
  end
  for index, reward in ipairs(source) do
    local qty = get_reward_quantity(reward)
    if 0 < qty then
      local key = get_reward_identity(reward) or tostring(index)
      map[key] = (map[key] or 0) + qty
    end
  end
  return map
end

local function compute_stage_day_count(extraRewards, addBoxRewards)
  local perDayList = addBoxRewards
  if not perDayList then
    perDayList = {}
  elseif #perDayList == 0 then
    local temp = {}
    for _, value in pairs(perDayList) do
      temp[#temp + 1] = value
    end
    perDayList = temp
  end
  if #perDayList == 0 then
    return 0
  end
  local extraMap = build_reward_quantity_map(extraRewards)
  local minDays
  for index, reward in ipairs(perDayList) do
    local perQty = get_reward_quantity(reward)
    if 0 < perQty then
      local key = get_reward_identity(reward) or tostring(index)
      local available = extraMap[key] or 0
      local ratio = math_floor(available / perQty)
      if not minDays or minDays > ratio then
        minDays = ratio
      end
    end
  end
  return minDays or 0
end

local function recalc_accumulate_progress(data)
  if not data then
    return
  end
  local totalDays = 0
  local list = data.extraRewardList
  for _, stage in ipairs(list) do
    local vipGiftId = math_floor(math_max(tonumber(stage.vipGiftId) or 0, 0))
    if 0 < vipGiftId then
      local packId = tostring(vipGiftId)
      local bought = GiftPackageData.hasBought(packId)
      bought = bought and true or false
      if not bought then
        local addBox = stage.putBoxParam or stage.config and stage.config.putBoxParam or nil
        local extra = stage.extraRewards or stage.rewards or nil
        local days = compute_stage_day_count(extra, addBox)
        if days < 0 then
          days = 0
        end
        totalDays = days
        break
      end
    end
  end
  if data.freeReceived ~= true and 0 < totalDays then
    totalDays = totalDays - 1
  end
  if totalDays < 0 then
    totalDays = 0
  end
  data.currentDayCount = totalDays
  local dailyMax = math_floor(math_max(tonumber(data.dailyMax) or 0, 0))
  local accumulate = 0 < dailyMax and totalDays * dailyMax or 0
  local limit = math_floor(math_max(tonumber(data.accumulateLimit) or 0, 0))
  if 0 < limit and accumulate > limit then
    accumulate = limit
  end
  data.accumulateCount = accumulate
end

local function compute_stage_discount(self, actId, stage, careTodayClaim)
  local numericActId = toInt(actId)
  if numericActId <= 0 then
    return 0, 0, 0
  end
  local data = self:GetData(numericActId)
  local entry, stageId
  if type(stage) == "table" then
    entry = stage
    stageId = math_floor(math_max(tonumber(entry.stageId or entry.vipGiftId) or 0, 0))
  end
  if not entry then
    local numericStage = tonumber(stage) or 0
    stageId = math_floor(math_max(numericStage, 0))
    if 0 < stageId and data and data.extraRewardList then
      for _, item in ipairs(data.extraRewardList) do
        local itemStageId = math_floor(math_max(tonumber(item.stageId) or 0, 0))
        local itemVipId = math_floor(math_max(tonumber(item.vipGiftId) or 0, 0))
        if itemStageId == stageId or itemVipId == stageId then
          entry = item
          break
        end
      end
    end
  end
  local config = data and data.config or nil
  if not config then
    config = self:GetActivityConfig(numericActId)
    if data then
      data.config = config
    end
  end
  if not stageId and entry then
    stageId = math_floor(math_max(tonumber(entry.stageId or entry.vipGiftId) or 0, 0))
  end
  local stageConfig
  if entry and entry.config then
    stageConfig = entry.config
  elseif config and stageId and 0 < stageId then
    stageConfig = config.stageMap and config.stageMap[stageId] or nil
  end
  if not stageConfig and entry then
    stageConfig = entry
  end
  if not stageConfig then
    return 0, 0, 0
  end
  local vipGiftId = stageConfig.vipGiftId or entry and entry.vipGiftId
  local basePercent = 0
  do
    local pack = GiftPackageData.get(tostring(vipGiftId or ""))
    local packPercent = pack and pack:getPercent()
    basePercent = tonumber(packPercent) or 0
  end
  local perItemBonus = tonumber(stageConfig.addScore or stageConfig.rebateStep or stageConfig.rebateRatioRaw) or 0
  local rewardList = entry and (entry.extraRewards or entry.rewards) or nil
  if (not rewardList or #rewardList == 0) and data and data.extraReward and stageId and 0 < stageId then
    local stageKey = tostring(stageId)
    local rawRewards = data.extraReward[stageKey]
    if type(rawRewards) == "table" then
      rewardList = {}
      for _, reward in ipairs(rawRewards) do
        table_insert(rewardList, reward)
      end
    end
  end
  local extraPercent = 0.0
  if perItemBonus ~= 0 and rewardList and 0 < #rewardList then
    local quantityMap = build_reward_quantity_map(rewardList)
    if careTodayClaim and data and data.freeReceived ~= true then
      local putBoxSource = entry and (entry.putBoxParam or entry.config and entry.config.putBoxParam) or nil
      if not putBoxSource and stageConfig then
        putBoxSource = stageConfig.putBoxParam
      end
      if putBoxSource then
        local perDayMap = build_reward_quantity_map(putBoxSource)
        for key, value in pairs(perDayMap) do
          local current = quantityMap[key] or 0
          current = current - value
          if current < 0 then
            current = 0
          end
          quantityMap[key] = current
        end
      end
    end
    local totalUnits = 0
    for _, quantity in pairs(quantityMap) do
      if 0 < quantity then
        totalUnits = totalUnits + quantity
      end
    end
    extraPercent = perItemBonus * totalUnits
  end
  return basePercent + extraPercent, basePercent, extraPercent
end

local table_sort = table.sort

function VipGiftActDataManager:OnGiftPackageDataUpdate()
  if not self or not self.dataMap then
    return
  end
  local changedActs
  for actId, data in pairs(self.dataMap) do
    if data and data.extraRewardList and #data.extraRewardList > 0 then
      local prevAccumulate = data.accumulateCount
      local prevDay = data.currentDayCount
      recalc_accumulate_progress(data)
      if data.accumulateCount ~= prevAccumulate or data.currentDayCount ~= prevDay then
        changedActs = changedActs or {}
        changedActs[#changedActs + 1] = {actId = actId, data = data}
      end
    end
  end
  if changedActs then
    for _, entry in ipairs(changedActs) do
      EventManager:Broadcast(EventId.SurvivalVipGiftInfoUpdate, entry)
    end
  end
end

function VipGiftActDataManager:OnPassDay()
  if self.dataMap and next(self.dataMap) then
    for actId, data in pairs(self.dataMap) do
      self:SendGetInfo(tostring(actId))
    end
  end
end

local function add_event_listeners(self)
  if self._vipGiftEventReg == true then
    return
  end
  if not self.OnGiftUpdateCallback then
    self.OnGiftUpdateCallback = BindCallback(self, self.OnGiftPackageDataUpdate)
  end
  if not self.OnPassDayCallback then
    self.OnPassDayCallback = BindCallback(self, self.OnPassDay)
  end
  EventManager:AddListener(EventId.UpdateGiftPackData, self.OnGiftUpdateCallback)
  EventManager:AddListener(EventId.OnPassDay, self.OnPassDayCallback)
  self._vipGiftEventReg = true
end

local function remove_event_listeners(self)
  if not self._vipGiftEventReg then
    return
  end
  EventManager:RemoveListener(EventId.UpdateGiftPackData, self.OnGiftUpdateCallback)
  EventManager:RemoveListener(EventId.OnPassDay, self.OnPassDayCallback)
  self._vipGiftEventReg = nil
end

local function __init(self)
  self.dataMap = {}
  self.configMap = {}
  self._vipGiftEventReg = nil
  add_event_listeners(self)
end

local function __delete(self)
  remove_event_listeners(self)
  self.dataMap = nil
  self.configMap = nil
  self._vipGiftEventReg = nil
end

function VipGiftActDataManager:GetData(actId)
  if not self.dataMap then
    return nil
  end
  local numericId = toInt and toInt(actId) or tonumber(actId)
  if not numericId or numericId <= 0 then
    return nil
  end
  local data = self.dataMap[numericId]
  if not data then
    return nil
  end
  return data
end

function VipGiftActDataManager:GetDataCanShow(actId)
  if not self.dataMap then
    return nil
  end
  local numericId = toInt and toInt(actId) or tonumber(actId)
  if not numericId or numericId <= 0 then
    return nil
  end
  local data = self.dataMap[numericId]
  if not data then
    return nil
  end
  if data.isShow == false then
    return nil
  end
  return data
end

function VipGiftActDataManager:HasFreeReward(actId)
  local d = self:GetDataCanShow(actId)
  if not d then
    return false
  end
  local rewardList = d.dailyReward
  local hasRewardEntry = rewardList and 0 < #rewardList
  if not hasRewardEntry and d.freeReceived == true then
    return false
  end
  return d.freeReceived == false or d.freeReceived == nil
end

function VipGiftActDataManager:GetRedNum(actId)
  return self:HasFreeReward(actId) and 1 or 0, 0, 0
end

function VipGiftActDataManager:SendGetInfo(actId, immediate)
  if actId == nil or toInt(actId) == 0 then
    return
  end
  if immediate then
    SFSNetwork.SendMessage(MsgDefines.SurvivalVipGiftGetInfo, toInt(actId))
  else
    DataCenter.DispatchRequestManager:Append(function()
      SFSNetwork.SendMessage(MsgDefines.SurvivalVipGiftGetInfo, toInt(actId))
    end)
  end
end

function VipGiftActDataManager:SendReceiveFree(actId)
  if actId == nil or toInt(actId) == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurvivalVipGiftReceiveFree, toInt(actId))
end

function VipGiftActDataManager:GetActivityConfig(actId)
  local numericId = toInt(actId)
  if numericId <= 0 then
    return nil
  end
  if not LocalController or not LocalController.instance then
    return nil
  end
  if not self.configMap then
    self.configMap = {}
  end
  local cached = self.configMap[numericId]
  if cached ~= nil then
    if cached == false then
      return nil
    end
    return cached
  end
  local controller = LocalController:instance()
  if not controller then
    self.configMap[numericId] = false
    return nil
  end
  local activityTableName = TableName and TableName.Activity or "activity"
  local activityLine = controller:tryGetLine(activityTableName, numericId)
  activityLine = activityLine or controller:tryGetLine(activityTableName, tostring(numericId))
  if not activityLine then
    self.configMap[numericId] = false
    return nil
  end
  local tableInfoName = activityLine.tableInfo
  local groupId = math_floor(math_max(tonumber(activityLine.tableInfoType) or 0, 0))
  local config = {
    tableName = tableInfoName,
    groupId = groupId,
    stageList = {},
    stageMap = {},
    activityNameKey = activityLine.name,
    mailId = activityLine.mailId,
    maxAddBox = 0,
    dailyMax = math_floor(math_max(tonumber(activityLine.daily_max) or 0, 0))
  }
  if tableInfoName and tableInfoName ~= "" then
    controller:visitTable(tableInfoName, function(_, line)
      if not line then
        return false
      end
      local lineGroup = line:getValue("group")
      if lineGroup == nil or lineGroup <= 0 then
        lineGroup = groupId
      end
      if groupId == 0 or lineGroup == groupId then
        local stageId = line:getValue("id")
        local vipGiftId = line:getValue("gift_id")
        local maxAddBox = line:getValue("max_add_box")
        local ratioRaw = line:getValue("add_score")
        local vipPic = line:getValue("vip_pic")
        local dailyStageMax = line:getValue("daily_max")
        local freeBoxList = convert_config_box_param(line:getValue("send_box"))
        local addBoxList = convert_config_box_param(line:getValue("add_box"))
        local para1 = line:getValue("para1")
        local bubbleQualityId = para1 and para1[1] or 0
        local bubbleBoxItemId = para1 and para1[2] or 0
        local entry = {
          stageId = stageId,
          configId = stageId,
          groupId = lineGroup,
          vipGiftId = vipGiftId,
          extraGiftId = 0,
          maxAddBox = maxAddBox,
          rebateStep = ratioRaw,
          rebateRatioRaw = ratioRaw,
          rebateRatio = 0 < ratioRaw and ratioRaw / 100 or 0,
          addScore = ratioRaw,
          rebateTextKey = nil,
          vipPic = vipPic,
          dailyMax = dailyStageMax,
          freeBoxParam = freeBoxList,
          putBoxParam = addBoxList,
          bubbleParam = nil,
          bubbleQualityId = bubbleQualityId,
          bubbleBoxItemId = bubbleBoxItemId
        }
        if entry.maxAddBox and entry.maxAddBox > config.maxAddBox then
          config.maxAddBox = entry.maxAddBox
        end
        if entry.dailyMax and 0 < entry.dailyMax then
          config.dailyMax = math_max(config.dailyMax, entry.dailyMax)
        end
        if 0 >= config.groupId and lineGroup and 0 < lineGroup then
          config.groupId = lineGroup
        end
        config.stageMap[entry.stageId] = entry
        table_insert(config.stageList, entry)
      end
      return false
    end)
    if #config.stageList > 1 then
      table_sort(config.stageList, function(a, b)
        return a.stageId < b.stageId
      end)
    end
  end
  self.configMap[numericId] = config
  return config
end

function VipGiftActDataManager:OnGetInfo(message)
  local actId = toInt(message.activityId or 0)
  if actId <= 0 then
    return
  end
  if self.dataMap[actId] == nil then
    self.dataMap[actId] = {}
  end
  local d = self.dataMap[actId]
  local isShow = message.isShow
  if isShow == nil then
    isShow = true
  elseif type(isShow) ~= "boolean" then
    local lowered = string_lower(tostring(isShow))
    isShow = lowered ~= "0" and lowered ~= "false"
  end
  d.isShow = isShow
  if not isShow then
    reset_activity_data(d, actId)
    d.isShow = false
    d.config = nil
    EventManager:Broadcast(EventId.SurvivalVipGiftInfoUpdate, {actId = actId, data = nil})
    return
  end
  d.activityId = actId
  d.freeReceived = message.freeReceived == true
  d.dailyReward = to_reward_array(message.dailyReward)
  local timestamp = tonumber(message.timestamp) or 0
  if 0 < timestamp and timestamp < TIMESTAMP_SECOND_THRESHOLD then
    timestamp = timestamp * 1000
  end
  d.timestamp = timestamp
  local dispearTime = tonumber(message.dispearTime) or 0
  if 0 < dispearTime and dispearTime < TIMESTAMP_SECOND_THRESHOLD then
    dispearTime = dispearTime * 1000
  end
  d.dispearTime = dispearTime
  local config = self:GetActivityConfig(actId)
  d.config = config
  if config then
    d.dailyMax = math_floor(math_max(tonumber(config.dailyMax) or 0, 0))
    d.accumulateLimit = math_floor(math_max(tonumber(config.maxAddBox) or 0, 0))
  else
    d.dailyMax = d.dailyMax or 0
    d.accumulateLimit = d.accumulateLimit or 0
  end
  local messageDailyCount = message.dailyCount or message.daily_count
  if messageDailyCount ~= nil then
    d.dailyCount = math_floor(math_max(tonumber(messageDailyCount) or 0, 0))
  else
    d.dailyCount = d.freeReceived and d.dailyMax or 0
  end
  d.accumulateCount = d.accumulateCount or 0
  d.extraReward = {}
  d.extraRewardList = {}
  local extraRewardData = message.extraReward
  local extraRewardLookup = {}
  if type(extraRewardData) == "table" then
    for key, value in pairs(extraRewardData) do
      extraRewardLookup[tostring(key)] = to_reward_array(value)
    end
  end
  if config and config.stageList and 0 < #config.stageList then
    for _, stage in ipairs(config.stageList) do
      local stageKey = tostring(stage.stageId)
      local source = extraRewardLookup[stageKey]
      if not source and stage.vipGiftId and 0 < stage.vipGiftId then
        source = extraRewardLookup[tostring(stage.vipGiftId)]
      end
      local rewards = source or {}
      local entry = {
        stageId = stage.stageId,
        groupId = stage.groupId,
        vipGiftId = stage.vipGiftId,
        extraGiftId = stage.extraGiftId,
        maxAddBox = stage.maxAddBox,
        rebateStep = stage.rebateStep,
        rebateRatio = stage.rebateRatio,
        rebateRatioRaw = stage.rebateRatioRaw,
        rebateTextKey = stage.rebateTextKey,
        addScore = stage.addScore,
        vipPic = stage.vipPic,
        dailyMax = stage.dailyMax,
        freeBoxParam = stage.freeBoxParam,
        putBoxParam = stage.putBoxParam,
        bubbleParam = stage.bubbleParam,
        bubbleQualityId = stage.bubbleQualityId,
        bubbleBoxItemId = stage.bubbleBoxItemId,
        extraRewards = rewards,
        config = stage
      }
      entry.rewards = entry.extraRewards
      d.extraReward[stageKey] = entry.extraRewards
      if entry.vipGiftId and 0 < entry.vipGiftId then
        d.extraReward[tostring(entry.vipGiftId)] = entry.extraRewards
      end
      table_insert(d.extraRewardList, entry)
    end
  else
    for key, value in pairs(extraRewardLookup) do
      local rewards = value
      local numericId = math_floor(math_max(tonumber(key) or 0, 0))
      local entry = {
        stageId = numericId,
        vipGiftId = numericId,
        extraRewards = rewards,
        rewards = rewards
      }
      d.extraReward[key] = rewards
      table_insert(d.extraRewardList, entry)
    end
  end
  if #d.extraRewardList > 1 then
    table_sort(d.extraRewardList, function(a, b)
      local vipA = math_floor(math_max(tonumber(a.vipGiftId) or 0, 0))
      local vipB = math_floor(math_max(tonumber(b.vipGiftId) or 0, 0))
      if vipA ~= vipB then
        return vipA < vipB
      end
      local stageA = math_floor(math_max(tonumber(a.stageId) or 0, 0))
      local stageB = math_floor(math_max(tonumber(b.stageId) or 0, 0))
      return stageA < stageB
    end)
  end
  recalc_accumulate_progress(d)
  EventManager:Broadcast(EventId.SurvivalVipGiftInfoUpdate, {actId = actId, data = d})
end

function VipGiftActDataManager:OnReceiveFree(message)
  local actId = toInt(message.activityId or 0)
  if actId <= 0 then
    return
  end
  if self.dataMap[actId] == nil then
    self.dataMap[actId] = {}
  end
  local d = self.dataMap[actId]
  local isShow = message.isShow
  if isShow == nil then
    isShow = d.isShow ~= false
  elseif type(isShow) ~= "boolean" then
    local lowered = string_lower(tostring(isShow))
    isShow = lowered ~= "0" and lowered ~= "false"
  end
  d.isShow = isShow
  if not isShow then
    reset_activity_data(d, actId)
    d.isShow = false
    d.config = nil
    EventManager:Broadcast(EventId.SurvivalVipGiftInfoUpdate, {actId = actId, data = nil})
    return
  end
  d.activityId = actId
  d.freeReceived = message.freeReceived == true
  if message.dispearTime then
    local dispearTime = tonumber(message.dispearTime) or 0
    if 0 < dispearTime and dispearTime < TIMESTAMP_SECOND_THRESHOLD then
      dispearTime = dispearTime * 1000
    end
    d.dispearTime = dispearTime
  end
  if message.timestamp then
    local ts = tonumber(message.timestamp) or 0
    if 0 < ts and ts < TIMESTAMP_SECOND_THRESHOLD then
      ts = ts * 1000
    end
    d.timestamp = ts
  end
  if message.dailyReward then
    d.dailyReward = to_reward_array(message.dailyReward)
  else
    d.dailyReward = d.dailyReward or {}
  end
  local config = self:GetActivityConfig(actId)
  if config then
    d.dailyMax = math_floor(math_max(tonumber(config.dailyMax) or 0, 0))
    d.accumulateLimit = math_floor(math_max(tonumber(config.maxAddBox) or 0, 0))
  else
    d.dailyMax = d.dailyMax or 0
    d.accumulateLimit = d.accumulateLimit or 0
  end
  local receiveDailyCount = message.dailyCount or message.daily_count
  if receiveDailyCount ~= nil then
    d.dailyCount = math_floor(math_max(tonumber(receiveDailyCount) or 0, 0))
  else
    d.dailyCount = d.freeReceived and d.dailyMax or 0
  end
  d.accumulateCount = d.accumulateCount or 0
  recalc_accumulate_progress(d)
  DataCenter.RewardManager:AddRewards(message.dailyReward)
  EventManager:Broadcast(EventId.SurvivalVipGiftFreeReward, {actId = actId, data = d})
end

function VipGiftActDataManager:GetSummary(actId)
  local data = self:GetData(actId)
  if not data then
    return nil
  end
  return {
    activityId = data.activityId,
    dailyCount = math_floor(math_max(tonumber(data.dailyCount) or 0, 0)),
    dailyMax = math_floor(math_max(tonumber(data.dailyMax) or 0, 0)),
    accumulateCount = math_floor(math_max(tonumber(data.accumulateCount) or 0, 0)),
    accumulateLimit = math_floor(math_max(tonumber(data.accumulateLimit) or 0, 0)),
    freeReceived = data.freeReceived == true,
    timestamp = data.timestamp,
    hasFreeReward = self:HasFreeReward(actId),
    currentDay = compute_current_day_from_timestamp(data.timestamp),
    maxDay = compute_max_day_from_progress(data.dailyCount, data.dailyMax),
    dispearTime = tonumber(data.dispearTime or 0) or 0
  }
end

function VipGiftActDataManager:GetCurrentDayIndex(actId)
  local data = self:GetData(actId)
  if not data then
    return 0
  end
  return compute_current_day_from_timestamp(data.timestamp)
end

function VipGiftActDataManager:GetMaxDayCount(actId)
  local data = self:GetData(actId)
  if not data then
    return 0
  end
  return compute_max_day_from_progress(data.dailyCount, data.dailyMax)
end

function VipGiftActDataManager:GetDayInfo(actId)
  local data = self:GetData(actId)
  if not data then
    return nil
  end
  return {
    currentDay = compute_current_day_from_timestamp(data.timestamp),
    maxDay = compute_max_day_from_progress(data.dailyCount, data.dailyMax),
    timestamp = data.timestamp,
    dispearTime = tonumber(data.dispearTime or 0) or 0
  }
end

function VipGiftActDataManager:GetDisappearTime(actId)
  local data = self:GetData(actId)
  if not data then
    return 0
  end
  return tonumber(data.dispearTime or 0) or 0
end

function VipGiftActDataManager:GetStageDiscountPercent(actId, stage, careTodayClaim)
  return compute_stage_discount(self, actId, stage, careTodayClaim)
end

function VipGiftActDataManager:GetStageDiscountDetail(actId, stage, careTodayClaim)
  local total, base, extra = compute_stage_discount(self, actId, stage, careTodayClaim)
  return {
    total = total,
    base = base,
    extra = extra
  }
end

function VipGiftActDataManager:GetGiftExtraInfo(actId)
  local data = self:GetData(actId)
  if not data or not data.extraRewardList then
    return {}
  end
  local list = {}
  for _, entry in ipairs(data.extraRewardList) do
    table_insert(list, entry)
  end
  if 1 < #list then
    table_sort(list, function(a, b)
      local vipA = math_floor(math_max(tonumber(a and a.vipGiftId) or 0, 0))
      local vipB = math_floor(math_max(tonumber(b and b.vipGiftId) or 0, 0))
      if vipA ~= vipB then
        return vipA < vipB
      end
      local stageA = math_floor(math_max(tonumber(a and a.stageId) or 0, 0))
      local stageB = math_floor(math_max(tonumber(b and b.stageId) or 0, 0))
      return stageA < stageB
    end)
  end
  return list
end

function VipGiftActDataManager:CanShowRadarEntrance()
  local activityInfo = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SurvivalVipGift.Type)
  if not activityInfo then
    return false, nil
  end
  local data = self:GetDataCanShow(activityInfo.id)
  local curTime = UITimeManager and UITimeManager:GetInstance():GetServerTime() or 0
  local dispearTime = self.GetDisappearTime and self:GetDisappearTime(activityInfo.id) or 0
  if dispearTime and 0 < dispearTime and curTime >= dispearTime then
    return false, nil
  end
  if not data then
    return false, activityInfo
  end
  for _, stage in ipairs(data.extraRewardList) do
    if stage.vipGiftId and 0 < stage.vipGiftId then
      local vipLv = DataCenter.VIPManager:GetPackVipLv(stage.vipGiftId)
      local state = DataCenter.VIPManager:AnalyzePayGoodState(vipLv, stage.vipGiftId)
      if state < VipPayGoodState.HasGet then
        return true, activityInfo
      end
    end
  end
  return false, nil
end

function VipGiftActDataManager:CanShowVIPSurvivalTip()
  if self.hideVIPSurvivalTip == nil then
    return true
  end
  return not self.hideVIPSurvivalTip
end

function VipGiftActDataManager:SetVIPSurvivalTipHide(hide)
  self.hideVIPSurvivalTip = hide
end

VipGiftActDataManager.__init = __init
VipGiftActDataManager.__delete = __delete
return VipGiftActDataManager
