local WorldBuildTimeManager = BaseClass("WorldBuildTimeManager")
local ResourceManager = CS.GameEntry.Resource
local BuildTimeTip = require("Scene.BuildTimeTip.BuildTimeTip")
local BuildTimeTipTrainField = require("Scene.BuildTimeTip.BuildTimeTipTrainField")
local BuildTimeTipFarm = require("Scene.BuildTimeTip.BuildTimeTipFarm")
local SceneBuildTimeTipCircle = require("Scene.BuildTimeTip.SceneBuildTimeTipCircle")
local IconBgResetScale = Vector3.New(1, 1, 1)
local ResetExtraHeight = Vector3.New(0, 0, 0)
local Localization = CS.GameEntry.Localization

function WorldBuildTimeManager:__init()
  self.allBuildTimes = {}
  self.loadingBuildTimes = {}
  self.buildTypeTimeType = {}
  self:AddListener()
end

function WorldBuildTimeManager:__delete()
  self:RemoveListener()
  for k, v in pairs(self.allBuildTimes) do
    local temp = v.request
    v:OnDestroy()
    temp:Destroy()
  end
  self.allBuildTimes = {}
  self.loadingBuildTimes = {}
  self.buildTypeTimeType = {}
end

function WorldBuildTimeManager:Startup()
end

function WorldBuildTimeManager:AddListener()
  if self.buildUpgradeStartSignal == nil then
    function self.buildUpgradeStartSignal(uuid)
      self:BuildUpgradeStartSignal(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)
    EventManager:GetInstance():AddListener(EventId.CreatWormholeBuild, self.buildUpgradeStartSignal)
  end
  if self.buildUpgradeFinishSignal == nil then
    function self.buildUpgradeFinishSignal(uuid)
      self:CheckShowTime(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
  end
  if self.addBuildSpeedSuccessSignal == nil then
    function self.addBuildSpeedSuccessSignal(uuid)
      self:AddBuildSpeedSuccessSignal(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.AddBuildSpeedSuccess, self.addBuildSpeedSuccessSignal)
  end
  if self.buildTimeEndSignal == nil then
    function self.buildTimeEndSignal(uuid)
      self:CheckShowTime(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.Build_Time_End, self.buildTimeEndSignal)
  end
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.HospitaiStart, self.HospitaiStartSignal)
  EventManager:GetInstance():AddListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint)
end

function WorldBuildTimeManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitaiStart, self.HospitaiStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint)
  if self.buildUpgradeStartSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.CreatWormholeBuild, self.buildUpgradeStartSignal)
    EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)
    self.buildUpgradeStartSignal = nil
  end
  if self.buildUpgradeFinishSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
    self.buildUpgradeFinishSignal = nil
  end
  if self.addBuildSpeedSuccessSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.AddBuildSpeedSuccess, self.addBuildSpeedSuccessSignal)
    self.addBuildSpeedSuccessSignal = nil
  end
  if self.buildTimeEndSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.Build_Time_End, self.buildTimeEndSignal)
    self.buildTimeEndSignal = nil
  end
end

function WorldBuildTimeManager:OnUpdatePoint()
  ProfilerUtil.BeginSample("WorldBuildTimeManager.OnUpdatePoint")
  local self = DataCenter.WorldBuildTimeManager
  if self and self.loadingBuildTimes then
    local dirtyList = {}
    for bUuid, v in pairs(self.loadingBuildTimes) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
      if buildData == nil then
        table.insert(dirtyList, bUuid)
      end
    end
    for k, bUuid in ipairs(dirtyList) do
      self:DeleteOneBuildTime(bUuid)
    end
  end
  ProfilerUtil.EndSample()
end

function WorldBuildTimeManager:GetBuildTimeTypeListByBuildType(buildType)
  if self.buildTypeTimeType[buildType] ~= nil then
    return self.buildTypeTimeType[buildType]
  end
  local list = {}
  table.insert(list, BuildTimeType.BuildTime_Upgrading)
  if buildType == BuildingTypes.WORM_HOLE_CROSS then
    local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
    if crossBuildData ~= nil then
      local worldId = crossBuildData.worldId
      if worldId ~= nil and 0 < worldId then
        table.insert(list, BuildTimeType.BuildTime_Injuries)
      end
    end
  end
  self.buildTypeTimeType[buildType] = list
  return list
end

function WorldBuildTimeManager:GetBuildNeedShowBuildTimeList(uuid)
  local retList = {}
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil and data.state ~= BuildingStateType.FoldUp then
    local buildId = data.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local extraHeight = ResetExtraHeight
    local list = self:GetBuildTimeTypeListByBuildType(buildId)
    if list ~= nil and buildTemplate ~= nil then
      local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
      for k, v in ipairs(list) do
        local needTip = false
        local param = {}
        param.bUuid = uuid
        if data.destroyStartTime <= 0 then
          if v == BuildTimeType.BuildTime_Upgrading then
            if data:IsUpgrading() then
              param.buildTimeType = v
              param.endTime = data.updateTime
              param.startTime = data.startTime
              if curTime < param.startTime then
                param.startTime = curTime
              end
              param.pos = data.pointId
              param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              param.desName = ""
              param.tiles = buildTemplate.tiles
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_Injuries then
            local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
            if queue ~= nil and not queue:IsEnd() then
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_zhiliao")
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              param.desName = Localization:GetString("130057")
              param.tiles = buildTemplate.tiles
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          end
        end
        if needTip then
          table.insert(retList, param)
        end
      end
    end
  end
  return retList
end

function WorldBuildTimeManager:DeleteOneBuildTime(bUuid)
  if self.loadingBuildTimes[bUuid] ~= nil then
    self.loadingBuildTimes[bUuid] = nil
  end
  if self.allBuildTimes[bUuid] ~= nil then
    local temp = self.allBuildTimes[bUuid].request
    self.allBuildTimes[bUuid]:OnDestroy()
    temp:Destroy()
    self.allBuildTimes[bUuid] = nil
  end
end

function WorldBuildTimeManager:ShowOneBuildTime(bUuid, paramList)
  if self.loadingBuildTimes[bUuid] == nil then
    self.loadingBuildTimes[bUuid] = paramList
    local param = paramList and 0 < #paramList and paramList[1] or nil
    if not param then
      return
    end
    local tempModel = param.model
    if param.buildTimeType == BuildTimeType.BuildTime_Upgrading then
      tempModel = UIAssets.BuildTimeTipTrainField
    end
    local request = ResourceManager:InstantiateAsync(tempModel)
    request:completed("+", function()
      if self.loadingBuildTimes[bUuid] == nil then
        request:Destroy()
      else
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.name = "BuildTime" .. bUuid
        local buildTimeTip
        if tempModel == UIAssets.BuildTimeTipTrainField then
          buildTimeTip = BuildTimeTipTrainField.New()
        elseif tempModel == UIAssets.SceneBuildTimeTipCircle then
          buildTimeTip = SceneBuildTimeTipCircle.New()
        elseif tempModel == UIAssets.BuildTimeTip4 then
          buildTimeTip = BuildTimeTipFarm.New()
        else
          buildTimeTip = BuildTimeTip.New()
        end
        local buildParamList = self.loadingBuildTimes[bUuid]
        buildTimeTip:OnCreate(request)
        self.allBuildTimes[bUuid] = buildTimeTip
        self.allBuildTimes[bUuid]:ReInit(buildParamList)
        self.loadingBuildTimes[bUuid] = nil
      end
    end)
  else
    self.loadingBuildTimes[bUuid] = paramList
  end
end

function WorldBuildTimeManager:BuildInViewSignal(data)
  local bUuid = data
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil then
    local paramList = self:GetBuildNeedShowBuildTimeList(bUuid)
    if not paramList or #paramList == 0 then
      self:DeleteOneBuildTime(bUuid)
    else
      local tempTip = self.allBuildTimes[bUuid]
      if tempTip then
        if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
          tempTip:ReInit(paramList)
        end
      else
        self:DeleteOneBuildTime(bUuid)
        self:ShowOneBuildTime(bUuid, paramList)
      end
    end
  end
end

function WorldBuildTimeManager:BuildOutViewSignal(data)
  self:DeleteOneBuildTime(data)
end

function WorldBuildTimeManager:CheckShowTime(bUuid)
  if DataCenter.BuildManager:IsWorldBuildInView(bUuid) then
    local paramList = self:GetBuildNeedShowBuildTimeList(bUuid)
    if not paramList or #paramList == 0 then
      self:DeleteOneBuildTime(bUuid)
    else
      local tempTip = DataCenter.WorldBuildTimeManager.allBuildTimes[bUuid]
      if tempTip then
        if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
          tempTip:ReInit(paramList)
        end
      else
        self:DeleteOneBuildTime(bUuid)
        self:ShowOneBuildTime(bUuid, paramList)
      end
    end
  else
    self:DeleteOneBuildTime(bUuid)
  end
end

function WorldBuildTimeManager:AddBuildSpeedSuccessSignal(data)
  if data:ContainsKey("bUuid") and data:ContainsKey("endTime") and data:ContainsKey("startTime") then
    local bUuid = data:GetLong("bUuid")
    local startTime = data:GetLong("startTime")
    local endTime = data:GetLong("endTime")
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local allBuildTimes = self.allBuildTimes
    if endTime <= curTime then
      self:DeleteOneBuildTime(bUuid)
    elseif allBuildTimes[bUuid] then
      if allBuildTimes[bUuid].param then
        if allBuildTimes[bUuid].param.buildTimeType == BuildTimeType.BuildTime_Upgrading then
          allBuildTimes[bUuid].param.startTime = startTime
          allBuildTimes[bUuid].param.endTime = endTime
          allBuildTimes[bUuid]:RefreshSliderInterVal()
        end
      elseif allBuildTimes[bUuid].UpdateTime then
        allBuildTimes[bUuid]:UpdateTime(BuildTimeType.BuildTime_Upgrading, startTime, endTime)
      end
    end
  end
end

function WorldBuildTimeManager:BuildUpgradeStartSignal(data)
  local bUuid = 0
  if data and type(data) == "number" then
    bUuid = data
  elseif data and type(data.ContainsKey) == "function" and data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  self:CheckShowTime(bUuid)
end

function WorldBuildTimeManager:HospitaiStartSignal(data)
  DataCenter.WorldBuildTimeManager:RefreshTimeByQueueType(NewQueueType.Hospital)
end

local function AddSpeedSuccessSignal(data)
  DataCenter.WorldBuildTimeManager:RefreshTimeByQueueType(data)
end

local function QueueTimeEndSignal(data)
  DataCenter.WorldBuildTimeManager:RefreshTimeByQueueType(data)
end

function WorldBuildTimeManager:RefreshTimeByQueueType(queueType)
  if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
    return
  end
  if queueType == NewQueueType.Hospital then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.WORM_HOLE_CROSS)
    if list ~= nil then
      for k, v in pairs(list) do
        DataCenter.WorldBuildTimeManager:CheckShowTime(v.uuid)
      end
    end
  end
end

WorldBuildTimeManager.AddSpeedSuccessSignal = AddSpeedSuccessSignal
WorldBuildTimeManager.QueueTimeEndSignal = QueueTimeEndSignal
return WorldBuildTimeManager
