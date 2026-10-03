local ActDispatchTreasureRewardTemplate = BaseClass("ActDispatchTreasureRewardTemplate")
local ActDispatchTreasureRewardItemTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardItemTemplate")

local function __init(self)
  self.type = DispathTreasureRewardType.Common
  self.showId = ""
  self.boxIconPath = ""
  self.nameStrId = ""
  self.prob = 0
  self.rewardInfo = nil
  self.season = 0
  self.seasonBeginDay = 0
  self.seasonEndDay = 0
  self.fallbackShowRewardDatas = {}
  self:AddListener()
end

local function __delete(self)
  self.type = nil
  self.showId = nil
  self.boxIconPath = nil
  self.nameStrId = nil
  self.prob = nil
  self.rewardInfo = nil
  self.season = nil
  self.seasonBeginDay = nil
  self.seasonEndDay = nil
  self.fallbackShowRewardDatas = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self, type)
  self.type = type
  if type == DispathTreasureRewardType.Common then
    self.showId = LuaEntry.DataConfig:TryGetStr("Treasure_map_reward_guarantees", "k3")
  else
    self:InitRewardDataByType(type)
    if type == DispathTreasureRewardType.Normal then
      self.boxIconPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/FX_WB_xiangzi03.png"
      self.nameStrId = "Treasure_map_reward_show_3"
    elseif type == DispathTreasureRewardType.Rare then
      self.boxIconPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/FX_WB_xiangzi05.png"
      self.nameStrId = "Treasure_map_reward_show_6"
    elseif type == DispathTreasureRewardType.Epic then
      self.boxIconPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/FX_WB_xiangzi02.png"
      self.nameStrId = "Treasure_map_reward_show_7"
    end
  end
  if not string.IsNullOrEmpty(self.showId) then
    local showCfg = LocalController:instance():getLine(TableName.Treasure_Map_Reward_Show, self.showId)
    local allProp = 0
    local propTab = string.split(showCfg.rate, ";")
    local itemTab = string.split(showCfg.item, ";")
    local numTab = string.split(showCfg.num, ";")
    local index = string.find(showCfg.rate, "|")
    if index ~= nil then
      propTab = string.split(showCfg.rate, "|")
      itemTab = string.split(showCfg.item, "|")
      numTab = string.split(showCfg.num, "|")
      allProp = 100
    else
      for index, value in ipairs(propTab) do
        allProp = allProp + tonumber(value)
      end
    end
    self.rewardInfo = {}
    for i = 1, #propTab do
      local rewardItem = ActDispatchTreasureRewardItemTemplate.New()
      rewardItem:InitData(propTab[i] / allProp, itemTab[i], numTab[i])
      table.insert(self.rewardInfo, rewardItem)
    end
  end
end

local function InitRewardDataByType(self, type)
  LocalController:instance():visitTable(TableName.Treasure_Map_Reward, function(id, lineData)
    local season_days = lineData:getValue("season_days")
    local cfgType = lineData:getIntValue("type") + 1
    local strReward = lineData:getValue("reward")
    local strRewardList = string.split(strReward, "|")
    local reward = strRewardList[1]
    local prob = lineData:getValue("probabilities")
    local inner_server = lineData:getValue("inner_server")
    local server = lineData:getValue("server")
    local hummerInfo = lineData:getValue("hummer_num")
    local pointReward = lineData:getValue("point_reward")
    if season_days == "-1" then
      if type == cfgType and not self.fallbackShowRewardDatas[cfgType] then
        self.fallbackShowRewardDatas[cfgType] = {}
        self.fallbackShowRewardDatas[cfgType].showId = reward
        self.fallbackShowRewardDatas[cfgType].prob = prob
      end
    else
      local strServer = CS.CommonUtils.IsDebug() and inner_server or server
      local strServer2 = string.split(strServer, "-")
      local serverList = {}
      if table.count(strServer2) == 1 then
        serverList[1] = tonumber(strServer2[1])
        serverList[2] = tonumber(strServer2[1])
      elseif table.count(strServer2) == 2 then
        serverList[1] = tonumber(strServer2[1])
        serverList[2] = tonumber(strServer2[2])
      end
      local checkGroups = string.split(season_days, ",")
      for _, checkGroupStr in ipairs(checkGroups) do
        local checkGroup = string.split(checkGroupStr, "|")
        local season = tonumber(checkGroup[1])
        local seasonBeginDay = tonumber(checkGroup[2])
        local seasonEndDay = tonumber(checkGroup[3])
        if type == cfgType and self:IsTimeConditionValid(season, seasonBeginDay, seasonEndDay, serverList) then
          self.season = season
          self.seasonBeginDay = seasonBeginDay
          self.seasonEndDay = seasonEndDay
          self.showId = reward
          self.prob = prob
          if hummerInfo ~= nil then
            local hummerData = string.split(hummerInfo, "|")
            if table.count(hummerData) == 3 then
              self.hummerProb = tonumber(hummerData[1])
              self.hummerId = tonumber(hummerData[2])
              self.hummerNum = tonumber(hummerData[3])
            end
          end
          if not string.IsNullOrEmpty(pointReward) then
            self.pointRewardList = {}
            for part in string.gmatch(pointReward, "([^;]+)") do
              local pointProb, pointId, pointValue = string.match(part, "([^|]+)|([^|]+)|([^|]+)")
              table.insert(self.pointRewardList, {
                probability = tonumber(pointProb),
                id = tonumber(pointId),
                value = tonumber(pointValue)
              })
            end
          end
          return true
        end
      end
    end
    if self.fallbackShowRewardDatas[cfgType] then
      self.showId = self.fallbackShowRewardDatas[cfgType].showId
      self.prob = self.fallbackShowRewardDatas[cfgType].prob
      return true
    end
    return false
  end)
end

local function CheckNeedRefresh(self)
  local needRefresh = false
  if self.type == DispathTreasureRewardType.Common then
    needRefresh = false
  else
    needRefresh = not self:IsTimeConditionValid(self.season, self.seasonBeginDay, self.seasonEndDay)
  end
  return needRefresh
end

local function IsTimeConditionValid(self, season, seasonBeginDay, seasonEndDay, serverList)
  local isIn = false
  local nowSeason = DataCenter.SeasonDataManager:GetSeason()
  if nowSeason == season then
    local day = UITimeManager:GetInstance():GetServerOpenDays()
    if nowSeason ~= 0 then
      day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
    end
    local isInTargetServer = false
    local serverId = LuaEntry.Player:GetSourceServerId()
    if serverId >= serverList[1] and serverId <= serverList[2] then
      isInTargetServer = true
    end
    if seasonBeginDay <= day and seasonEndDay >= day and isInTargetServer then
      isIn = true
    end
  end
  return isIn
end

ActDispatchTreasureRewardTemplate.__init = __init
ActDispatchTreasureRewardTemplate.__delete = __delete
ActDispatchTreasureRewardTemplate.AddListener = AddListener
ActDispatchTreasureRewardTemplate.RemoveListener = RemoveListener
ActDispatchTreasureRewardTemplate.InitData = InitData
ActDispatchTreasureRewardTemplate.CheckNeedRefresh = CheckNeedRefresh
ActDispatchTreasureRewardTemplate.IsTimeConditionValid = IsTimeConditionValid
ActDispatchTreasureRewardTemplate.InitRewardDataByType = InitRewardDataByType
return ActDispatchTreasureRewardTemplate
