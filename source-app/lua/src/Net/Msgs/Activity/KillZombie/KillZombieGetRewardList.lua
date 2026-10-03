local KillZombieGetRewardList = BaseClass("KillZombieGetRewardList", SFSBaseMessage)
local base = SFSBaseMessage

local function parseData(theType, theData)
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(theType)
  for difficulty, data in pairs(dataList.data) do
    local tmp = theData[tostring(difficulty)]
    local levelReward = {}
    local levelList = {}
    local allReward = {}
    if tmp then
      for level, level_data in pairs(tmp) do
        local reward
        for _, v in ipairs(level_data) do
          if type(v.value) == "number" then
            if reward == nil then
              reward = v.type .. ";" .. v.type .. ";" .. v.value
            else
              reward = reward .. "|" .. v.type .. ";" .. v.type .. ";" .. v.value
            end
            if allReward.ResItem == nil then
              allReward.ResItem = {}
            end
            if allReward.ResItem[v.type] == nil then
              allReward.ResItem[v.type] = v.value
            else
              allReward.ResItem[v.type] = allReward.ResItem[v.type] + v.value
            end
          else
            if reward == nil then
              reward = v.value.id .. ";" .. v.type .. ";" .. v.value.num
            else
              reward = reward .. "|" .. v.value.id .. ";" .. v.type .. ";" .. v.value.num
            end
            if allReward[v.type] == nil then
              allReward[v.type] = {}
            end
            if allReward[v.type][v.value.id] == nil then
              allReward[v.type][v.value.id] = v.value.num
            else
              allReward[v.type][v.value.id] = allReward[v.type][v.value.id] + v.value.num
            end
          end
        end
        levelReward[tostring(level)] = reward
        table.insert(levelList, tonumber(level))
      end
    end
    table.sort(levelList, function(a, b)
      return a < b
    end)
    local reward
    for k, v in pairs(allReward) do
      if k == "ResItem" then
        for t, n in pairs(v) do
          if reward == nil then
            reward = t .. ";" .. t .. ";" .. n
          else
            reward = reward .. "|" .. t .. ";" .. t .. ";" .. n
          end
        end
      else
        for id, num in pairs(v) do
          if reward == nil then
            reward = id .. ";" .. k .. ";" .. num
          else
            reward = reward .. "|" .. id .. ";" .. k .. ";" .. num
          end
        end
      end
    end
    levelReward.all = reward
    levelReward.levelList = levelList
    data.rewardListServer = levelReward
  end
end

function KillZombieGetRewardList:OnCreate()
  base.OnCreate(self)
end

function KillZombieGetRewardList:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil then
    if data.personal ~= nil then
      parseData(1, data.personal)
    end
    if not DataCenter.ActivityKillZombieManager.isNewFuncOpen and data.alliance ~= nil then
      parseData(2, data.alliance)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  data = nil
end

return KillZombieGetRewardList
