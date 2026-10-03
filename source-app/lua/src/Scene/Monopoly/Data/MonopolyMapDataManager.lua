local MonopolyMapDataManager = BaseClass("MonopolyMapDataManager")
local MonopolyPlacealityTemplate = require("Scene.Monopoly.Data.MonopolyPlacealityTemplate")
local MonopolyPlacealityData = require("Scene.Monopoly.Data.MonopolyPlacealityData")

function MonopolyMapDataManager:__init()
  self.templateDict = {}
  self.placealityDataDict = {}
  self.landLockDic = {}
  self.decorateLLDic = {}
end

function MonopolyMapDataManager:ChangeDataState(state)
  local data = self.placealityDataDict[self.curId]
  if state > data.state then
    data.state = state
  elseif data.state == state then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.MonopolyUpdateData, data)
end

function MonopolyMapDataManager:GetCurData()
  if not self.curId or DataCenter.LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(self.curId) < 1 then
    return
  end
  if self.curId and self.placealityDataDict[self.curId] then
    return self.placealityDataDict[self.curId]
  end
end

function MonopolyMapDataManager:NextData()
  if self.curId then
    self.curId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(self.curId)
  end
  return self:GetCurData()
end

function MonopolyMapDataManager:SetIsLose(isLose)
  local curData = self:GetCurData()
  if curData then
    curData.isLose = isLose
  end
end

function MonopolyMapDataManager:SetIsExit(isExit)
  local curData = self:GetCurData()
  if curData then
    curData.isExit = isExit
  end
end

function MonopolyMapDataManager:__delete()
  self.templateDict = nil
  self.placealityDataDict = nil
  self.landLockDic = nil
  self.decorateLLDic = nil
end

function MonopolyMapDataManager:GetTemplate(id)
  return self.templateDict[id]
end

function MonopolyMapDataManager:InitData()
  if self.templateDict and table.count(self.templateDict) > 0 then
    return
  end
  ProfilerUtil.BeginSample("InitMonopolyData")
  local replaceIdDict = DataCenter.HeroTryOutManager:GetMonopolyPlacealityIdDict()
  local noUseIdDict = DataCenter.HeroTryOutManager:GetMonopolyPlacealityNewIdDict()
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Monopoly), function(id, line)
    if noUseIdDict and noUseIdDict[id] == true then
      return
    end
    local newLineData = line
    local newLineId = id
    if replaceIdDict and replaceIdDict[id] then
      newLineId = replaceIdDict[id]
      newLineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Monopoly), newLineId)
      if newLineData == nil then
        Logger.LogError("Error! LW_Monopoly line not exist, " .. tostring(newLineId))
        return
      end
    end
    local template = MonopolyPlacealityTemplate.New()
    template:InitData(newLineData, id)
    self.templateDict[template.id] = template
    local data = MonopolyPlacealityData.New()
    data:InitByTemplate(template)
    if data.land_lock then
      if data.id < 10000 then
        if not self.landLockDic[data.land_lock] then
          self.landLockDic[data.land_lock] = {}
        end
        table.insert(self.landLockDic[data.land_lock], data.id)
      else
        if not self.decorateLLDic[data.land_lock] then
          self.decorateLLDic[data.land_lock] = {}
        end
        table.insert(self.decorateLLDic[data.land_lock], data.id)
      end
    end
    self.placealityDataDict[template.id] = data
  end)
  ProfilerUtil.EndSample()
end

function MonopolyMapDataManager:SetCurId(curId)
  self.lastId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  self.curId = curId
  for i, data in pairs(self.placealityDataDict) do
    data:SetStateByCurId(curId)
  end
end

function MonopolyMapDataManager:SaveReward(id, reward)
  self.rewardId = id
  self.reward = reward
end

function MonopolyMapDataManager:GetRewardById(id)
  if self.rewardId == id then
    return self.reward
  end
end

function MonopolyMapDataManager:GetInitPlacealityId()
  local id = DataCenter.LandLockManager:GetCurrentToBeUnlockedId()
  if id and self.landLockDic[id] then
    return self.landLockDic[id][1]
  else
    return DataCenter.LWCivilizationSparkExtend:MonopolyManager_getInitPlacealityId()
  end
end

function MonopolyMapDataManager:GetAllUnLockPlacealityList()
  local id = DataCenter.LandLockManager:GetCurrentToBeUnlockedId()
  local list = {}
  for i, v in pairs(self.landLockDic) do
    if i < id then
      for index, lacealityId in pairs(v) do
        table.insert(list, lacealityId)
      end
    end
  end
  return list
end

function MonopolyMapDataManager:GetDecorateListByLandLockId(id)
  if self.decorateLLDic then
    return self.decorateLLDic[id]
  end
end

function MonopolyMapDataManager:GetLandIsLeave(id)
  if id == nil or id < 5 then
    return false
  end
  local list = self:GetPlacealityIdListByLandlockId(id)
  local data
  for i, id in pairs(list) do
    data = self:GetPlacealityById(id)
    if data.state ~= MonopolyPlacealityType.Leave then
      return false
    end
  end
  local nextId = DataCenter.LWCivilizationSparkExtend:LandLockManager_getNextLandId(id)
  if id == DataCenter.MonopolyManager:GetV1LastLandId() then
    return true
  elseif self.landLockDic[nextId] then
    data = self:GetPlacealityById(self.landLockDic[nextId][1])
    if data and data.state == MonopolyPlacealityType.Leave then
      return true
    end
  else
    return true
  end
end

function MonopolyMapDataManager:GetPlacealityIdListByLandlockId(id)
  if self.landLockDic then
    return self.landLockDic[id]
  end
end

function MonopolyMapDataManager:GetPlacealityById(id)
  return self.placealityDataDict and self.placealityDataDict[id]
end

function MonopolyMapDataManager:GetPlacealityListByLandlockId(id)
  return self.placealityDataDict and self.placealityDataDict[id]
end

function MonopolyMapDataManager:GetMapDataDic()
  return self.placealityDataDict
end

function MonopolyMapDataManager:GetPlacealityCount()
  local count = 0
  for id, v in pairs(self.placealityDataDict) do
    if id < 10000 then
      count = count + 1
    end
  end
  return count
end

return MonopolyMapDataManager
