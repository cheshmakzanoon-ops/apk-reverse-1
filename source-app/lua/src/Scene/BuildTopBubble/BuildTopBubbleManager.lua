local BuildTopBubbleManager = BaseClass("BuildTopBubbleManager", Singleton)
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.allEffect = {}
  self.OnCreateEffect = {}
  self.needRefreshBuildList = {}
  self.timer = nil
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    v.script:OnDestroy()
    request:Destroy()
  end
  for k, v in pairs(self.OnCreateEffect) do
    if v ~= nil then
      v.request:Destroy()
    end
  end
  self.allEffect = nil
  self.OnCreateEffect = nil
  self.needRefreshBuildList = nil
  self:DeleteTimer()
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.CheckDomeOpen, self.CheckDomeOpen)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():AddListener(EventId.WorldBuildTopBubbleRefresh, self.RefreshTopBubble)
  EventManager:GetInstance():AddListener(EventId.WorldBuildTopBubblePlot, self.TriggerPlotBubble)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.CheckDomeOpen, self.CheckDomeOpen)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.WorldBuildTopBubbleRefresh, self.RefreshTopBubble)
  EventManager:GetInstance():RemoveListener(EventId.WorldBuildTopBubblePlot, self.TriggerPlotBubble)
end

local function BuildOutViewSignal(uuid)
  BuildTopBubbleManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function CheckDomeOpen(uuid)
  BuildTopBubbleManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function RefreshTopBubble(uuid)
  BuildTopBubbleManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function OnLodChange(lod)
  for k, v in pairs(BuildTopBubbleManager:GetInstance().allEffect) do
    local request = v.request
  end
end

local function ShowBubbleEffect(self, bUuid, posIndex, bubbleType, bubbleParam, bubbleServerId)
  self:RemoveOneEffect(bUuid)
  local bubbleData = WorldBuildTopBubbleTypeData[bubbleType]
  local modelName = bubbleData.assert
  local scriptPath = bubbleData.script
  local request = ResourceManager:InstantiateAsync(modelName)
  local par = {}
  par.request = request
  par.bubbleType = bubbleType
  par.bubbleParam = bubbleParam
  self.OnCreateEffect[bUuid] = par
  request:completed("+", function()
    self.OnCreateEffect[bUuid] = nil
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if bubbleParam and bubbleParam.serverId then
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World, bubbleParam.serverId)
    elseif bubbleServerId then
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World, bubbleServerId)
    else
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(posIndex)
    end
    local script = require(scriptPath)
    local effect = script.New()
    effect:OnCreate(request)
    effect:ReInit(bubbleParam, bUuid)
    par.script = effect
    self.allEffect[bUuid] = par
  end)
end

local function RemoveOneEffect(self, bUuid)
  local temp = self.allEffect[bUuid]
  if temp ~= nil then
    local request = temp.request
    temp.script:OnDestroy()
    request:Destroy()
    self.allEffect[bUuid] = nil
  end
  if self.OnCreateEffect[bUuid] ~= nil then
    local request = self.OnCreateEffect[bUuid].request
    request:Destroy()
    self.OnCreateEffect[bUuid] = nil
  end
end

local function CheckShowEffect(self, bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info == nil then
    return
  end
  self:OnWorldBaseRefresh(info)
end

function BuildTopBubbleManager:OnWorldBaseRefresh(info)
  local bUuid = info.uuid
  local bubbleType = WorldBuildTopBubbleType.None
  local bubbleParam
  if info.destroyStartTime > 0 then
    self:RemoveOneEffect(bUuid)
    return
  end
  local infoItemId = info.itemId
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(infoItemId, info.level)
  if buildLevelTemplate == nil then
    return
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(infoItemId)
  if buildTemplate == nil then
    return
  end
  if not info:IsNormalType() then
    return
  end
  local isOnlyRefresh = false
  local bubbleServerId
  if infoItemId == BuildingTypes.FUN_BUILD_MAIN and bubbleType == WorldBuildTopBubbleType.None then
    if DataCenter.LWFireworkManager:IsFiringByUid(info.ownerUid) or DataCenter.LWFireworkManager:HasClientFirework(info.ownerUid) or DataCenter.LWFireworkManager:GetPreClientFirework(info.ownerUid) or DataCenter.LWFireworkGiftManager:IsHasAvailableBoxForMeByUid(info.ownerUid) then
      bubbleParam = {
        buildingInfo = info,
        serverId = info.serverId
      }
      isOnlyRefresh = self.allEffect[bUuid] and self.allEffect[bUuid].bubbleType == WorldBuildTopBubbleType.Firework
      if isOnlyRefresh then
        self.allEffect[bUuid].script:ReInit(bubbleParam, bUuid, true)
        return
      else
        bubbleType = WorldBuildTopBubbleType.Firework
      end
    elseif info:GetAOSType() ~= AlOfficialSkillType.AresMissile then
      local detectData = DataCenter.RadarCenterDataManager:GetHelperEventDataByBuildUid(bUuid)
      local highFiveData = DataCenter.AllianceMemberDataManager:GetHighFiveData(info)
      if detectData and detectData.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
        bubbleType = WorldBuildTopBubbleType.HelperDetect
        bubbleParam = detectData
        bubbleServerId = info.serverId
      elseif highFiveData then
        bubbleType = WorldBuildTopBubbleType.HighFive
        bubbleParam = {data = highFiveData, point = info}
      end
    end
  end
  if bubbleType ~= WorldBuildTopBubbleType.None then
    self:ShowBubbleEffect(bUuid, info.mainIndex, bubbleType, bubbleParam, bubbleServerId)
  else
    self:RemoveOneEffect(bUuid)
  end
end

local function TimeRefresh(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local refreshListCount = 0
  for uuid, time in pairs(self.needRefreshBuildList) do
    if time > curTime then
      refreshListCount = refreshListCount + 1
    else
      self.needRefreshBuildList[uuid] = nil
      BuildTopBubbleManager:GetInstance():RemoveOneEffect(tonumber(uuid))
    end
  end
  if refreshListCount == 0 then
    self:DeleteTimer()
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimeRefresh, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddNeedRefreshBuildUuidTime(self, uuid, delayTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local refreshTime = curTime + delayTime * 1000
  self.needRefreshBuildList[uuid] = refreshTime
  if self.timer == nil then
    self:AddTimer()
  end
end

local function TriggerPlotBubble(data)
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local bUuid = data.bUuid
  local plotId = data.plotId
  local playerInfo = data.playerInfo
  local info = theWorld:GetPointInfoByUuid(bUuid)
  local bubbleType = WorldBuildTopBubbleType.None
  local bubbleParam
  if info == nil then
    return
  end
  cast(info, typeof(CS.BuildPointInfo))
  if info.destroyStartTime > 0 then
    self:RemoveOneEffect(bUuid)
    return
  end
  local bubbleParams = {}
  bubbleParams.plotGroupId = plotId
  local targetPos = SceneUtils.TileIndexToWorld(info.mainIndex)
  bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 1, targetPos.z)
  bubbleParams.mode = "3D"
  bubbleParams.playerInfo = playerInfo
  bubbleParams.pointIndex = info.mainIndex
  bubbleParams.pointUuid = bUuid
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, bubbleParams)
end

BuildTopBubbleManager.__init = __init
BuildTopBubbleManager.__delete = __delete
BuildTopBubbleManager.AddListener = AddListener
BuildTopBubbleManager.RemoveListener = RemoveListener
BuildTopBubbleManager.BuildOutViewSignal = BuildOutViewSignal
BuildTopBubbleManager.CheckDomeOpen = CheckDomeOpen
BuildTopBubbleManager.RefreshTopBubble = RefreshTopBubble
BuildTopBubbleManager.TriggerPlotBubble = TriggerPlotBubble
BuildTopBubbleManager.RemoveOneEffect = RemoveOneEffect
BuildTopBubbleManager.CheckShowEffect = CheckShowEffect
BuildTopBubbleManager.ShowBubbleEffect = ShowBubbleEffect
BuildTopBubbleManager.OnLodChange = OnLodChange
BuildTopBubbleManager.TimeRefresh = TimeRefresh
BuildTopBubbleManager.AddTimer = AddTimer
BuildTopBubbleManager.DeleteTimer = DeleteTimer
BuildTopBubbleManager.AddNeedRefreshBuildUuidTime = AddNeedRefreshBuildUuidTime
return BuildTopBubbleManager
