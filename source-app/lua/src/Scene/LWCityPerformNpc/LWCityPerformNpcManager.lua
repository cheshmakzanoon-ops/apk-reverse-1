local LWCityPerformNpcManager = BaseClass("LWCityPerformNpcManager")
local const = require("Scene.LWCityPerformNpc.Const")
local performUnit = require("Scene.LWCityPerformNpc.PerformNpcUnit.PerformUnit")
local performNpcUtil = require("Scene.LWCityPerformNpc.LWCityPerformNpcUtil")
local WorldCityTruckManager = CS.SceneManager.World
local worldCityPeople = require("Scene.LWCityPerformNpc.PerformNpcUnit.WorldCityPeople")

function LWCityPerformNpcManager:__init()
  self.npcModelList = {}
  self.cityPepoleDic = {}
  self.delayList = {}
  self:AddListeners()
  self.plotList = nil
  self.emojiList = nil
  self.animList = nil
  self.lastAnim = nil
end

function LWCityPerformNpcManager:__delete()
  DataCenter.LWCityPerformNpcManager:ClaerAllModel()
  self.cityPepoleDic = nil
  self.npcModelList = nil
  self.delayList = nil
  self.plotList = nil
  self.emojiList = nil
  self.animList = nil
  self.lastAnim = nil
  self:RemoveListener()
end

function LWCityPerformNpcManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.CitySolderCreate, self.OnCitySolderCreate)
  EventManager:GetInstance():AddListener(EventId.CitySolderHied, self.OnCitySolderHied)
  EventManager:GetInstance():AddListener(EventId.CitySolderDelete, self.OnCitySolderDelete)
end

function LWCityPerformNpcManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.CitySolderCreate, self.OnCitySolderCreate)
  EventManager:GetInstance():RemoveListener(EventId.CitySolderHied, self.OnCitySolderHied)
  EventManager:GetInstance():RemoveListener(EventId.CitySolderDelete, self.OnCitySolderDelete)
end

function LWCityPerformNpcManager.OnCitySolderCreate(index)
  local self = DataCenter.LWCityPerformNpcManager
  local people = self.cityPepoleDic[index + 1]
  if not SceneUtils.GetIsInCity() then
    return
  end
  if people == nil then
    local obj = CS.SceneManager.World:GetPeopleById(index)
    local citypePeople = worldCityPeople:New()
    citypePeople:OnCreate(obj, index)
    self.cityPepoleDic[index + 1] = citypePeople
  elseif IsNull(people.gameObject) then
    local obj = CS.SceneManager.World:GetPeopleById(index)
    self.cityPepoleDic[index + 1]:OnCreate(obj)
  end
end

function LWCityPerformNpcManager.OnCitySolderHied(index)
  local self = DataCenter.LWCityPerformNpcManager
  if not self.cityPepoleDic then
    return
  end
  local people = self.cityPepoleDic[index + 1]
  if people then
    people:OnHide()
  end
end

function LWCityPerformNpcManager:Startup()
end

function LWCityPerformNpcManager.OnCitySolderDelete(index)
  local self = DataCenter.LWCityPerformNpcManager
  if not self.cityPepoleDic then
    return
  end
  local people = self.cityPepoleDic[index + 1]
  if people then
    people:Delete()
    self.cityPepoleDic[index + 1] = nil
  end
end

function LWCityPerformNpcManager.BeforeReleaseCity()
  DataCenter.LWCityPerformNpcManager:ClaerAllModel()
end

function LWCityPerformNpcManager:GetUtil()
  if self.util == nil then
    self.util = performNpcUtil:New()
  end
  return self.util
end

local function GetPosList(startPos, endPos)
  local posList = DataCenter.InnerCityMapManager:FindPath(startPos, endPos)
  if posList then
    if #posList == 0 then
      table.insert(posList, startPos)
      table.insert(posList, endPos)
    elseif 2 < #posList then
      table.remove(posList, 1)
      table.insert(posList, 1, startPos)
      table.remove(posList, #posList)
      table.insert(posList, #posList + 1, endPos)
    end
  else
    posList = {}
    table.insert(posList, startPos)
    table.insert(posList, endPos)
  end
  return posList
end

function LWCityPerformNpcManager:CreateTeamModel(performData, count, time)
  local posList = GetPosList(performData.birthPos, performData.endPos)
  performData.posList = posList
  local delayTime = 0
  for i = 1, count do
    delayTime = i == 1 and 0 or (i - 1) * time
    self:DelayCreateModel(delayTime, performData)
  end
end

function LWCityPerformNpcManager:CreateQueueNpc(time, performDataList)
  local posList = GetPosList(performDataList[1].birthPos, performDataList[1].endPos)
  local delayTime = 0
  for i = 1, #performDataList do
    performDataList[i].posList = posList
    delayTime = i == 1 and 0 or (i - 1) * time
    self:DelayCreateModel(delayTime, performDataList[i])
  end
end

function LWCityPerformNpcManager:DelayCreateModel(time, performData)
  if time == 0 then
    self:CreatedModel(DeepCopy(performData))
  else
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:CreatedModel(DeepCopy(performData))
    end, time)
    table.insert(self.delayList, timer)
  end
end

function LWCityPerformNpcManager:CreatedModel(performData)
  local unit = performUnit:New()
  unit:SetData(performData)
  unit:CreateModel()
  table.insert(self.npcModelList, unit)
end

function LWCityPerformNpcManager:GetRandomPlot()
  if self.plotList == nil then
    self.plotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k16")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.plotList, tonumber(v) or 0)
      end
    end
    self.plotCount = #self.plotList
  end
  if self.plotCount < 1 then
    return 0
  end
  local random = math.random(1, self.plotCount)
  return self.plotList[random]
end

function LWCityPerformNpcManager:GetRandomEmoji()
  if self.emojiList == nil then
    self.emojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k17")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.emojiList, tonumber(v) or 0)
      end
    end
    self.emojiCount = #self.emojiList
  end
  if self.emojiCount < 1 then
    return 0
  end
  local random = math.random(1, self.emojiCount)
  return self.emojiList[random]
end

function LWCityPerformNpcManager:GetRandomAnim()
  if self.animList == nil then
    self.animList = {}
  end
  local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k18")
  if not string.IsNullOrEmpty(str) then
    local list = string.split(str, ";")
    for _, v in ipairs(list) do
      table.insert(self.animList, v)
    end
  end
  self.animCount = #self.animList
  local random = math.random(1, self.animCount)
  if self.lastAnim ~= nil and self.lastAnim == random then
    random = random + 1
    if random > self.animCount then
      random = 1
    end
  end
  self.lastAnim = random
  return self.animList[random]
end

function LWCityPerformNpcManager:ClaerAllModel()
  for i = 1, #self.delayList do
    if self.delayList[i] then
      self.delayList[i]:Stop()
    end
  end
  for i = 1, #self.npcModelList do
    if self.npcModelList[i] then
      self.npcModelList[i]:Delete()
    end
  end
  for i, v in pairs(self.cityPepoleDic) do
    if not IsNull(v) then
      v:Delete()
    end
  end
  self.cityPepoleDic = {}
  self.delayList = {}
  self.npcModelList = {}
end

function LWCityPerformNpcManager:__delete()
  self:ClaerAllModel()
  self.delayList = nil
  self.npcModelList = nil
  self.cityPepoleDic = nil
end

return LWCityPerformNpcManager
