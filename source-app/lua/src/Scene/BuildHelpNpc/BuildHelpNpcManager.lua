local BuildHelpNpcManager = BaseClass("BuildHelpNpcManager", CEventable)
local BuildHelpNpcData = require("Scene.BuildHelpNpc.BuildHelpNpcData")
local BuildHelpNpcUnit = require("Scene.BuildHelpNpc.BuildHelpNpcUnit")
local BuildHelpNpcGroup = require("Scene.BuildHelpNpc.BuildHelpNpcGroup")
local p_entryPath = "ModelGo/point/p_entry"
local p_exitPath = "ModelGo/point/p_exit"
local UnitSpeed = 2
local TextMeshProType = typeof(CS.TMPro.TextMeshPro)

local function __init(self)
  self.needAddNpcList = {}
  self.npcModelList = {}
  self.cd = 0
  self.helpNpcGroupDict = {}
  self:AddUpdateTimer()
  self:AddListener()
end

local function Startup(self)
  self.spawnCD = LuaEntry.DataConfig:TryGetNum("alliance_helpBuild_config", "k1", 1000) / 1000
  self.dialogRandom = LuaEntry.DataConfig:TryGetNum("alliance_helpBuild_config", "k2", 2000) / 10000
  local k3 = LuaEntry.DataConfig:TryGetStr("alliance_helpBuild_config", "k3")
  if not string.IsNullOrEmpty(k3) then
    self.plotList = string.split(k3, ";")
  end
  local k4 = LuaEntry.DataConfig:TryGetStr("alliance_helpBuild_config", "k4")
  if not string.IsNullOrEmpty(k4) then
    self.showNpcSize = {}
    for i, v in ipairs(string.split(k4, "|")) do
      local data = string.split(v, ";")
      local size = {
        [1] = tonumber(data[1]),
        [2] = tonumber(data[2])
      }
      table.insert(self.showNpcSize, size)
    end
  end
  self.unitSpeed = LuaEntry.DataConfig:TryGetStr("alliance_helpBuild_config", "k5", UnitSpeed)
end

local function __delete(self)
  self:RemoveUpdateTimer()
  self:ClearAllModel()
  self.needAddNpcList = nil
  self.npcModelList = nil
  self.helpNpcGroupDict = nil
  if self.npcQueueTimer then
    self.npcQueueTimer:Stop()
    self.npcQueueTimer = nil
  end
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

local function AddUpdateTimer(self)
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

local function RemoveUpdateTimer(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

local function OnUpdate(self)
  local deltaTime = Time.deltaTime
  if self.helpNpcGroupDict then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for k, v in pairs(self.helpNpcGroupDict) do
      if v.checkTime and curTime >= v.checkTime then
        self:ShowFinshAnim(k)
      end
    end
  end
  if self.cd > 0 then
    self.cd = self.cd - deltaTime
  end
  if self.needAddNpcList and 0 < #self.needAddNpcList and self.cd <= 0 then
    self.cd = self.spawnCD
    local data = table.remove(self.needAddNpcList, 1)
    self:CreatedBuildHelpModel(data)
  end
end

local function AddListener(self)
  self:RegisterEvent(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  self:RegisterEvent(EventId.AddBuildSpeedSuccess, self.OnChangeFinish)
  self:RegisterEvent(EventId.AllianceHelpUpdateSpeedUUid, self.OnAllianceHelpUpdateSpeedUUid)
  self:RegisterEvent(EventId.BUILD_IN_VIEW, self.OnBuildInViewSignal)
  self:RegisterEvent(EventId.BUILD_OUT_VIEW, self.OnBuildOutViewSignal)
end

local function BeforeReleaseCity(self)
  self:ClearAllModel()
end

local function ClearAllModel(self)
  self.needAddNpcList = {}
  for i = 1, #self.npcModelList do
    if self.npcModelList[i] then
      self.npcModelList[i]:Delete()
    end
  end
  self.npcModelList = {}
  for k, v in pairs(self.helpNpcGroupDict) do
    v:Delete()
  end
  self.helpNpcGroupDict = {}
end

local function AddHelpNpc(self, buildUUid, playerHead, helperSysName, helpName, reduceTimeStr, modelPath, deltaY)
  if not CS.SceneManager:IsInCity() then
    return
  end
  local buildUUid = buildUUid
  local allianceCenter = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ALLIANCE_CENTER)
  if not allianceCenter or buildUUid == allianceCenter.uid then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUUid)
  if buildData == nil then
    return
  end
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildDesTemplate == nil or string.IsNullOrEmpty(buildDesTemplate.helpBuildAniPath) then
    return
  end
  local data = BuildHelpNpcData:New()
  data:InitData(self:GetBulidExitPos(allianceCenter), self:GetBulidEntryPos(buildData), modelPath or UIAssets.HelpBuildPlayer, playerHead, helperSysName, helpName)
  table.insert(self.needAddNpcList, data)
end

local function CreatedBuildHelpModel(self, data)
  local unit = BuildHelpNpcUnit:New()
  if Vector3.Distance(data.birthPos, data.endPos) <= 0.001 then
    if data.arriveCallBack then
      data.arriveCallBack()
    end
  else
    local posList = GetPosList(data.birthPos, data.endPos)
    data.posList = posList
    data.speed = self.unitSpeed
    unit:SetData(data)
    unit:CreateModel()
    table.insert(self.npcModelList, unit)
  end
end

local function GetBulidEntryPos(self, buildData)
  local pos = Vector3.New(0, 0, 0)
  if buildData then
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
    if cityObj and cityObj.gameObject then
      local cityTrans = cityObj.gameObject.transform
      local entry = cityTrans:Find(p_entryPath)
      if entry then
        pos = entry.position
      else
        pos = cityTrans.position
      end
    end
  end
  return pos
end

local function GetBulidExitPos(self, buildData)
  if not buildData then
    return Vector3.New(0, 0, 0)
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if cityObj then
    return cityObj.gameObject.transform:Find(p_exitPath).position
  end
  return Vector3.New(0, 0, 0)
end

local function GetRandomPlotId(self)
  local random = math.random()
  if random > self.dialogRandom then
    return
  end
  local plotId = tonumber(table.randomArrayValue(self.plotList))
  local cfg = LocalController.instance():getLine(TableName.LW_Plot, plotId)
  local time = 3
  if cfg and not string.IsNullOrEmpty(cfg.duration) and tonumber(cfg.duration) > 0 then
    time = tonumber(cfg.duration)
  end
  return plotId, time
end

local function OnChangeFinish(self, data)
  if data:ContainsKey("bUuid") and data:ContainsKey("endTime") and data:ContainsKey("startTime") then
    local bUuid = data:GetLong("bUuid")
    local endTime = data:GetLong("endTime")
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if endTime <= curTime then
      self:ShowFinshAnim(bUuid)
    elseif self.helpNpcGroupDict and self.helpNpcGroupDict[bUuid] then
      self.helpNpcGroupDict[bUuid]:SetCheckTime(endTime)
    end
  end
end

local function ShowFinshAnim(self, bUuid)
  if self.helpNpcGroupDict[bUuid] and not self.helpNpcGroupDict[bUuid].isFinish then
    self:RefreshHelpNpcGroup(bUuid, true)
    TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveHelpNpcGroup(bUuid)
      SFSNetwork.SendMessage(MsgDefines.AllianceShowHelp)
    end, 1)
  end
end

local function OnAllianceHelpUpdateSpeedUUid(self, bUuid)
  self:RefreshHelpNpcGroup(bUuid)
end

local function OnBuildInViewSignal(self, bUuid)
  self:RefreshHelpNpcGroup(bUuid)
end

local function OnBuildOutViewSignal(self, data)
  self:RemoveHelpNpcGroup(data)
end

local function RefreshHelpNpcGroup(self, bUuid, isFinish)
  if not CS.SceneManager:IsInCity() then
    return
  end
  if bUuid == nil then
    return
  end
  local alhelpData = DataCenter.AllianceHelpDataManager:GetSelfAllianceHelp(bUuid)
  if alhelpData == nil or alhelpData.nowCount == nil then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildDesTemplate == nil or string.IsNullOrEmpty(buildDesTemplate.helpBuildAniPath) then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  local upGradeTrans
  if cityObj then
    local upGradeObj = cityObj:GetUpgradeObj()
    upGradeTrans = upGradeObj.transform
  end
  if upGradeTrans == nil then
    self:RemoveHelpNpcGroup(bUuid)
    return
  end
  local showNum = 0
  for i, v in ipairs(self.showNpcSize) do
    if alhelpData.nowCount >= v[1] then
      showNum = i
    else
      break
    end
  end
  if 0 < showNum then
    local prefabPath = buildDesTemplate.helpBuildAniPath
    local parent = upGradeTrans
    local buildHelpNpcGroup = self.helpNpcGroupDict[bUuid]
    if buildHelpNpcGroup and (buildHelpNpcGroup.prefabPath ~= prefabPath or buildHelpNpcGroup.parent ~= parent) then
      self:RemoveHelpNpcGroup(bUuid)
      buildHelpNpcGroup = nil
    end
    if buildHelpNpcGroup == nil then
      buildHelpNpcGroup = BuildHelpNpcGroup.New()
      self.helpNpcGroupDict[bUuid] = buildHelpNpcGroup
    end
    buildHelpNpcGroup:ReInit(prefabPath, parent, showNum, buildData.updateTime, isFinish)
  else
    self:RemoveHelpNpcGroup(bUuid)
  end
end

local function RemoveHelpNpcGroup(self, bUuid)
  if self.helpNpcGroupDict and self.helpNpcGroupDict[bUuid] then
    self.helpNpcGroupDict[bUuid]:Delete()
    self.helpNpcGroupDict[bUuid] = nil
  end
end

BuildHelpNpcManager.__init = __init
BuildHelpNpcManager.__delete = __delete
BuildHelpNpcManager.Startup = Startup
BuildHelpNpcManager.AddUpdateTimer = AddUpdateTimer
BuildHelpNpcManager.RemoveUpdateTimer = RemoveUpdateTimer
BuildHelpNpcManager.OnUpdate = OnUpdate
BuildHelpNpcManager.AddListener = AddListener
BuildHelpNpcManager.BeforeReleaseCity = BeforeReleaseCity
BuildHelpNpcManager.ClearAllModel = ClearAllModel
BuildHelpNpcManager.AddHelpNpc = AddHelpNpc
BuildHelpNpcManager.CreatedBuildHelpModel = CreatedBuildHelpModel
BuildHelpNpcManager.GetBulidEntryPos = GetBulidEntryPos
BuildHelpNpcManager.GetBulidExitPos = GetBulidExitPos
BuildHelpNpcManager.GetRandomPlotId = GetRandomPlotId
BuildHelpNpcManager.OnChangeFinish = OnChangeFinish
BuildHelpNpcManager.ShowFinshAnim = ShowFinshAnim
BuildHelpNpcManager.OnAllianceHelpUpdateSpeedUUid = OnAllianceHelpUpdateSpeedUUid
BuildHelpNpcManager.OnBuildInViewSignal = OnBuildInViewSignal
BuildHelpNpcManager.OnBuildOutViewSignal = OnBuildOutViewSignal
BuildHelpNpcManager.RefreshHelpNpcGroup = RefreshHelpNpcGroup
BuildHelpNpcManager.RemoveHelpNpcGroup = RemoveHelpNpcGroup
return BuildHelpNpcManager
