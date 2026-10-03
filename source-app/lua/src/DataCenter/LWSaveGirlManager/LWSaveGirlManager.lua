local LWSaveGirlManager = BaseClass("LWSaveGirlManager")
local Setting = CS.GameEntry.Setting

function LWSaveGirlManager:__init()
  self.lastTimes = 5
  self.saveTimes = 0
  
  function self.triggerBubbleFun(flowId)
    self:OnGuideFlowStart(flowId)
  end
  
  self.abTest = nil
  self.UIMainPlotInterval = nil
  self.UIMainIdlePlotList = nil
  self.UIMainEncouragePlotList = nil
  self.UIMainComfortPlotList = nil
  self.UIMainHappyPlotList = nil
  self.HappyMonopolyIdMap = nil
  self.jpGirlServer = nil
  self.jpGirlOpen = nil
  self.jpReplaceAppearanceMap = nil
  self.jpGoodsIconMap = nil
  self.jpActivityPara4Map = nil
  self.jpMonsterMap = nil
  self.jpActivityHeroMap = nil
  self.jpActivityPara6Map = nil
end

function LWSaveGirlManager:__delete()
  self.endTime = nil
  self.abTest = nil
  self.UIMainPlotInterval = nil
  self.UIMainIdlePlotList = nil
  self.UIMainEncouragePlotList = nil
  self.UIMainComfortPlotList = nil
  self.UIMainHappyPlotList = nil
  self.HappyMonopolyIdMap = nil
  self.jpGirlServer = nil
  self.jpGirlOpen = nil
  self.jpReplaceAppearanceMap = nil
  self.jpGoodsIconMap = nil
  self.jpActivityPara4Map = nil
  self.jpMonsterMap = nil
  self.jpActivityHeroMap = nil
  self.jpActivityPara6Map = nil
  self:RemoveListener()
end

function LWSaveGirlManager:OnEnterGame()
  self.triggerBubbleFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k24")
  self.triggerFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k9")
  self.triggerProtectFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k16")
  self.warningTime = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k20") * 1000
  self.costItemId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k1")
  self.finishFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k24")
  self:AddListener()
  EventManager:GetInstance():Broadcast(EventId.SaveGirlMainUIRefresh)
end

function LWSaveGirlManager:AddListener()
  if self.inited then
    return
  end
  self.inited = true
  EventManager:GetInstance():AddListener(EventId.GF_guide_start, self.triggerBubbleFun)
end

function LWSaveGirlManager:RemoveListener()
  if not self.inited then
    return
  end
  self.inited = false
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_start, self.triggerBubbleFun)
end

function LWSaveGirlManager:InitData(t)
  self.maxSaveTimes = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k2")
  self.saveHeroId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k18")
  local defuseBombCount = 0
  if t.defuseBombCount ~= nil then
    defuseBombCount = t.defuseBombCount
  end
  self.saveTimes = defuseBombCount
  self.lastTimes = math.max(0, self.maxSaveTimes - defuseBombCount)
  self.cacheReward = nil
end

function LWSaveGirlManager:HandleSaveGirlMessage(t)
  local defuseBombCount = 0
  if t.defuseBombCount ~= nil then
    defuseBombCount = t.defuseBombCount
  end
  self.saveTimes = defuseBombCount
  self.lastTimes = math.max(0, self.maxSaveTimes - defuseBombCount)
  local delayTriggerFlow = false
  if 0 >= self.lastTimes then
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil then
      DataCenter.BuildBubbleManager:CheckShowBubble(mainBuild.uuid)
    end
  end
  if t.rewardArr ~= nil then
    self.cacheReward = t.rewardArr
    delayTriggerFlow = true
  else
    self.cacheReward = nil
  end
  EventManager:GetInstance():Broadcast(EventId.SaveGirlSucceed, delayTriggerFlow)
  EventManager:GetInstance():Broadcast(EventId.GF_save_girl, self.lastTimes)
  EventManager:GetInstance():Broadcast(EventId.SaveGirlMainUIRefresh)
end

function LWSaveGirlManager:PlayReward()
  if self.cacheReward ~= nil then
    DataCenter.RewardManager:ShowGiftReward({
      reward = self.cacheReward
    })
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = self.cacheReward
    })
    self.cacheReward = nil
  end
end

function LWSaveGirlManager:OnGuideFlowStart(flowId)
  if flowId == self.triggerBubbleFlow or flowId == self.triggerFlow or flowId == self.triggerProtectFlow then
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil then
      DataCenter.BuildBubbleManager:CheckShowBubble(mainBuild.uuid)
    end
  end
end

function LWSaveGirlManager:IsShowBubble()
  local mainLv = DataCenter.BuildManager.MainLv
  return false
end

function LWSaveGirlManager:IsSavingHero(heroId)
  if not self:IsShowBubble() then
    return false
  end
  if not self.saveHeroId then
    return false
  end
  return self.saveHeroId == heroId
end

function LWSaveGirlManager:GetLastTimes()
  return self.lastTimes
end

function LWSaveGirlManager:GetSaveTimes()
  return self.saveTimes
end

function LWSaveGirlManager:GetMaxSaveTimes()
  return self.maxSaveTimes
end

function LWSaveGirlManager:GetWarningEndTime(set)
  if self.endTime then
    return self.endTime, false
  end
  local endTime = Setting:GetPrivateString("SaveGirlEndTime")
  if endTime == nil or endTime == "" then
    if set then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local time = curTime + self.warningTime
      Setting:SetPrivateString("SaveGirlEndTime", tostring(time))
      self.endTime = time
      return time, true
    else
      return 0, false
    end
  end
  self.endTime = tonumber(endTime)
  return self.endTime, false
end

function LWSaveGirlManager:GetCostItemId()
  if not self.costItemId then
    self.costItemId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k1")
  end
  return self.costItemId
end

function LWSaveGirlManager:CheckShowPop()
  local show = DataCenter.LWSaveGirlManager:IsShowBubble()
  if not show then
    return false
  end
  local endTime = DataCenter.LWSaveGirlManager:GetWarningEndTime()
  if endTime == 0 then
    return false
  end
  return true
end

function LWSaveGirlManager:GetUIMainPlotInterval()
  if self.UIMainPlotInterval == nil then
    self.UIMainPlotInterval = LuaEntry.DataConfig:TryGetNum("save_girl_performance", "k1", 2.67)
  end
  return self.UIMainPlotInterval
end

function LWSaveGirlManager:GetUIMainIdlePlot()
  if self.UIMainIdlePlotList == nil then
    self.UIMainIdlePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("save_girl_performance", "k2")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainIdlePlotList, tonumber(v) or 0)
      end
    end
    self.UIMainIdlePlotCount = #self.UIMainIdlePlotList
  end
  if 0 < self.UIMainIdlePlotCount then
    if self.UIMainIdlePlotCount == 1 then
      return self.UIMainIdlePlotList[1]
    end
    local random = math.random(1, self.UIMainIdlePlotCount)
    return self.UIMainIdlePlotList[random]
  end
  return 0
end

function LWSaveGirlManager:GetUIMainEncouragePlot()
  if self.UIMainEncouragePlotList == nil then
    self.UIMainEncouragePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("save_girl_performance", "k3")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainEncouragePlotList, tonumber(v) or 0)
      end
    end
    self.UIMainEncouragePlotCount = #self.UIMainEncouragePlotList
  end
  if 0 < self.UIMainEncouragePlotCount then
    if self.UIMainEncouragePlotCount == 1 then
      return self.UIMainEncouragePlotList[1]
    end
    local random = math.random(1, self.UIMainEncouragePlotCount)
    return self.UIMainEncouragePlotList[random]
  end
  return 0
end

function LWSaveGirlManager:GetUIMainComfortPlot()
  if self.UIMainComfortPlotList == nil then
    self.UIMainComfortPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("save_girl_performance", "k4")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainComfortPlotList, tonumber(v) or 0)
      end
    end
    self.UIMainComfortPlotCount = #self.UIMainComfortPlotList
  end
  if 0 < self.UIMainComfortPlotCount then
    if self.UIMainComfortPlotCount == 1 then
      return self.UIMainComfortPlotList[1]
    end
    local random = math.random(1, self.UIMainComfortPlotCount)
    return self.UIMainComfortPlotList[random]
  end
  return 0
end

function LWSaveGirlManager:GetUIMainHappyPlot()
  if self.UIMainHappyPlotList == nil then
    self.UIMainHappyPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("save_girl_performance", "k5")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainHappyPlotList, tonumber(v) or 0)
      end
    end
    self.UIMainHappyPlotCount = #self.UIMainHappyPlotList
  end
  if 0 < self.UIMainHappyPlotCount then
    if self.UIMainHappyPlotCount == 1 then
      return self.UIMainHappyPlotList[1]
    end
    local random = math.random(1, self.UIMainHappyPlotCount)
    return self.UIMainHappyPlotList[random]
  end
  return 0
end

function LWSaveGirlManager:GetHappyMonopolyIdMap()
  if self.HappyMonopolyIdMap == nil then
    self.HappyMonopolyIdMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("save_girl_performance", "k6")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        local id = tonumber(v) or 0
        if 0 < id then
          self.HappyMonopolyIdMap[id] = true
        end
      end
    end
  end
  return self.HappyMonopolyIdMap
end

function LWSaveGirlManager:IsJPGirlOpen()
  if self.jpGirlServer == nil then
    self.jpGirlServer = {}
    self.jpGirlOpen = false
    local server = LuaEntry.Player:GetSourceServerId()
    if CS.CommonUtils.IsDebug() then
      local serverArray = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k4")
      if not string.IsNullOrEmpty(serverArray) then
        local array = string.split(serverArray, "|")
        for _, arr in ipairs(array) do
          local list = string.split(arr, "-")
          if #list == 2 then
            local startServer = tonumber(list[1])
            local endServer = tonumber(list[2])
            for i = startServer, endServer do
              self.jpGirlServer[i] = true
            end
          elseif #list == 1 then
            local se = tonumber(list[1]) or 0
            if se == 0 then
              self.jpGirlOpen = true
              return true
            else
              self.jpGirlServer[se] = true
            end
          end
        end
        if self.jpGirlServer[server] then
          self.jpGirlOpen = true
          return true
        end
      end
    else
      local serverArray = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k5")
      if not string.IsNullOrEmpty(serverArray) then
        local array = string.split(serverArray, "|")
        for _, arr in ipairs(array) do
          local list = string.split(arr, "-")
          if #list == 2 then
            local startServer = tonumber(list[1])
            local endServer = tonumber(list[2])
            for i = startServer, endServer do
              self.jpGirlServer[i] = true
            end
          elseif #list == 1 then
            local se = tonumber(list[1]) or 0
            if se == 0 then
              self.jpGirlOpen = true
              return true
            else
              self.jpGirlServer[se] = true
            end
          end
        end
        if self.jpGirlServer[server] then
          self.jpGirlOpen = true
          return true
        end
      end
    end
  end
  return self.jpGirlOpen
end

function LWSaveGirlManager:GetJPAppearanceId(oldAppearanceId)
  local appearanceId = tonumber(oldAppearanceId)
  if not self:IsJPGirlOpen() then
    return appearanceId
  end
  if not LuaEntry.Player.JPUser then
    return appearanceId
  end
  if self.jpReplaceAppearanceMap == nil then
    self.jpReplaceAppearanceMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k1")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local old = tonumber(list[1]) or 0
          local new = tonumber(list[2]) or 0
          if 0 < old and 0 < new then
            self.jpReplaceAppearanceMap[old] = new
          end
        end
      end
    end
  end
  local ret = self.jpReplaceAppearanceMap[appearanceId]
  if ret and 0 < ret then
    return ret
  end
  return appearanceId
end

function LWSaveGirlManager:GetJPGoodsIcon(goodsId)
  if not self:IsJPGirlOpen() then
    return nil
  end
  if not LuaEntry.Player.JPUser then
    return nil
  end
  local id = tonumber(goodsId) or 0
  if self.jpGoodsIconMap == nil then
    self.jpGoodsIconMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k2")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local key = tonumber(list[1]) or 0
          local icon = list[2]
          if 0 < key then
            self.jpGoodsIconMap[key] = icon
          end
        end
      end
    end
  end
  return self.jpGoodsIconMap[id]
end

function LWSaveGirlManager:GetJPActivityPara4(activityId)
  if not self:IsJPGirlOpen() then
    return nil
  end
  if not LuaEntry.Player.JPUser then
    return nil
  end
  local id = tonumber(activityId) or 0
  if self.jpActivityPara4Map == nil then
    self.jpActivityPara4Map = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k3")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local key = tonumber(list[1]) or 0
          local icon = list[2]
          if 0 < key then
            self.jpActivityPara4Map[key] = icon
          end
        end
      end
    end
  end
  return self.jpActivityPara4Map[id]
end

function LWSaveGirlManager:GetJPMonster(oldMonsterId)
  if not self:IsJPGirlOpen() then
    return oldMonsterId
  end
  if not LuaEntry.Player.JPUser then
    return oldMonsterId
  end
  local id = tonumber(oldMonsterId) or 0
  if self.jpMonsterMap == nil then
    self.jpMonsterMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k6")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local old = tonumber(list[1]) or 0
          local new = tonumber(list[2]) or 0
          if 0 < old and 0 < new then
            self.jpMonsterMap[old] = new
          end
        end
      end
    end
  end
  local ret = self.jpMonsterMap[id]
  if ret and 0 < ret then
    return ret
  end
  return id
end

function LWSaveGirlManager:GetJPActivityHero(activityId)
  if not self:IsJPGirlOpen() then
    return nil
  end
  if not LuaEntry.Player.JPUser then
    return nil
  end
  local id = tonumber(activityId) or 0
  if self.jpActivityHeroMap == nil then
    self.jpActivityHeroMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k7")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local key = tonumber(list[1]) or 0
          local hero = list[2]
          if 0 < key then
            self.jpActivityHeroMap[key] = hero
          end
        end
      end
    end
  end
  return self.jpActivityHeroMap[id]
end

function LWSaveGirlManager:GetJPActivityPara6(activityId)
  if not self:IsJPGirlOpen() then
    return nil
  end
  if not LuaEntry.Player.JPUser then
    return nil
  end
  local id = tonumber(activityId) or 0
  if self.jpActivityPara6Map == nil then
    self.jpActivityPara6Map = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k10")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local key = tonumber(list[1]) or 0
          local para6 = list[2]
          if 0 < key then
            self.jpActivityPara6Map[key] = para6
          end
        end
      end
    end
  end
  return self.jpActivityPara6Map[id]
end

return LWSaveGirlManager
