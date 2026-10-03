local LWGateTruckGoodsManager = BaseClass("LWGateTruckGoodsManager")

function LWGateTruckGoodsManager:__init()
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_done, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():AddListener(EventId.HangRewardRefreshed, self.RefreshTruckGoods)
  EventManager:GetInstance():AddListener(EventId.GF_guide_start, self.OnGuideFlowStart)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

function LWGateTruckGoodsManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_done, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():RemoveListener(EventId.HangRewardRefreshed, self.RefreshTruckGoods)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_start, self.OnGuideFlowStart)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self:OnDisable()
end

local TRUCK_REFRESH_TIME = 10
local TRUCK_GOODS_GROUP_DUMMY = "ModelGo/Normal/A_build@transportcar/A_build@transportcar_skin/To_unity/DeformationSystem"
local TRUCK_GOODS_ICON_PREFABS = {
  "Assets/Main/Prefabs/LWGateDefence/GoodsFood.prefab",
  "Assets/Main/Prefabs/LWGateDefence/GoodsGold.prefab",
  "Assets/Main/Prefabs/LWGateDefence/GoodsIron.prefab"
}
local TRUCK_SOLIDER_TRANS_PATH = "A_Hero_bubing02"
local TRUCK_TRANS_PATH = "ModelGo/Normal/A_build@transportcar/A_build@transportcar_skin/To_unity/A_Vehicle_transportcar"
local _G = -30
local OBSORB_DEST = Vector3(98, 3, 63)
local bubbleAnchor = Vector3.New(0, 3.5, 0)
local _specialEventFlag = false
local Localization = CS.GameEntry.Localization
local TRUCK_GOODS_GROUP_SETTING = {
  [1] = {
    maxProgress = 0.05,
    groupNum = 0,
    groupPath = UIAssets.Truckgoodsgroup_01_01,
    space = 0.2
  },
  [2] = {
    maxProgress = 0.3,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_01,
    space = 0.2
  },
  [3] = {
    maxProgress = 0.6,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [4] = {
    maxProgress = 0.8,
    groupNum = 2,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [5] = {
    maxProgress = 0.999,
    groupNum = 3,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [6] = {
    maxProgress = 1,
    groupNum = 1,
    groupPath = UIAssets.TruckFullGoods,
    space = 1
  }
}

function LWGateTruckGoodsManager:Starup()
  self.progressGroups = {}
  self.dropGoods = {}
  self.buildObj = nil
  self.dummyObj = nil
  self.refreshTimer = 1
  self.bubbleTimer = 1
  self.truckObj = nil
  self.bFirstRefreshGoods = false
end

function LWGateTruckGoodsManager:OnEnable()
  local self = DataCenter.LWGateTruckGoodsManager
  if self.active then
    return
  end
  local truckBuilding = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  truckBuilding = truckBuilding and truckBuilding[1]
  self.active = CS.SceneManager:IsInCity() and truckBuilding and truckBuilding.level > 0
  if self.active then
    self:InitPlotBubbleInfo()
  end
  self.refreshTimer = 1
end

function LWGateTruckGoodsManager:OnDisable()
  local self = DataCenter.LWGateTruckGoodsManager
  if not self.active then
    return
  end
  self.active = false
  for _, groups in pairs(self.progressGroups) do
    for _, group in pairs(groups) do
      if not IsNull(group) then
        group:Destroy()
      end
    end
  end
  self.progressGroups = {}
  for _, dropGoods in ipairs(self.dropGoods) do
    if dropGoods and not IsNull(dropGoods.handle) then
      dropGoods.handle:Destroy()
    end
  end
  self.dropGoods = {}
  self.dummyObj = nil
  self.soliderTrans = nil
  self.truckObj = nil
  self.buildObj = nil
  self.bFirstRefreshGoods = false
end

function LWGateTruckGoodsManager.OnUpdate()
  local self = DataCenter.LWGateTruckGoodsManager
  local dt = Time.deltaTime
  if not self.active and not _specialEventFlag then
    return
  end
  self.refreshTimer = self.refreshTimer - dt
  if self.refreshTimer <= 0 then
    if self.bFirstRefreshGoods then
      self.refreshTimer = TRUCK_REFRESH_TIME
    else
      self.refreshTimer = 1
    end
    self.RefreshTruckGoods()
  end
  if self.curSetting and self.curSetting.maxProgress == 1 then
    self.bubbleTimer = self.bubbleTimer - dt
    if 0 >= self.bubbleTimer then
      self.bubbleTimer = self.nBubbleInterval
      self:PlayPlotBubble3D()
    end
  end
  for i = #self.dropGoods, 1, -1 do
    local dropGoods = self.dropGoods[i]
    if dropGoods and not IsNull(dropGoods.handle) and not IsNull(dropGoods.handle.gameObject) then
      if 0 < dropGoods.state and (IsNull(dropGoods.tween) or not dropGoods.tween:IsActive()) then
        table.remove(self.dropGoods, i)
        dropGoods.tween = nil
        dropGoods.handle:Destroy()
      elseif not IsNull(dropGoods.handle) and not IsNull(dropGoods.handle.gameObject) then
        local transform = dropGoods.handle.gameObject.transform
        if dropGoods.state == 0 then
          dropGoods.x = dropGoods.x + dropGoods.vx * dt
          dropGoods.z = dropGoods.z + dropGoods.vz * dt
          dropGoods.y = dropGoods.y + dropGoods.vy * dt
          if 0 >= dropGoods.y then
            dropGoods.y = 0
            if dropGoods.bounce < 2 then
              dropGoods.bounce = dropGoods.bounce + 1
              dropGoods.vy = 8 / (dropGoods.bounce * 2)
            else
              dropGoods.state = 1
              dropGoods.closeShadowDelay = 0.4 + dropGoods.delay
              dropGoods.tween = CS.AnimationHelper.DOBezierCurve3D(transform, Vector3(dropGoods.x, dropGoods.y, dropGoods.z), OBSORB_DEST, 1, 0.2):SetDelay(dropGoods.delay):SetEase(CS.DG.Tweening.Ease.OutCubic)
            end
          else
            dropGoods.vy = dropGoods.vy + _G * dt
          end
          transform:Set_position(dropGoods.x, dropGoods.y, dropGoods.z)
        elseif dropGoods.state == 1 and 0 < dropGoods.closeShadowDelay then
          dropGoods.closeShadowDelay = dropGoods.closeShadowDelay - dt
          if 0 >= dropGoods.closeShadowDelay and not IsNull(dropGoods.renderer) then
            dropGoods.renderer.gameObject.layer = CS.UnityEngine.LayerMask.NameToLayer("Default")
          end
        end
      end
    end
  end
end

function LWGateTruckGoodsManager.RefreshTruckGoods()
  local self = DataCenter.LWGateTruckGoodsManager
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local lastTime = DataCenter.StageManager.lastIdleRewardTimeStamp
  if not lastTime then
    return
  end
  local isInCity = SceneUtils.GetIsInCity()
  if not isInCity then
    return
  end
  if IsNull(self.buildObj) then
    local truckBuildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
    if truckBuildingData and truckBuildingData[1] then
      self.buildObj = CS.SceneManager.World:GetBuildingByPoint(truckBuildingData[1].pointId)
    end
  end
  if IsNull(self.buildObj) then
    return
  end
  if IsNull(self.dummyObj) then
    local dummyTrans = self.buildObj.gameObject.transform:Find(TRUCK_GOODS_GROUP_DUMMY)
    if dummyTrans then
      self.dummyObj = dummyTrans.gameObject
    end
  end
  if IsNull(self.dummyObj) then
    return
  end
  if IsNull(self.truckObj) then
    local truckTrans = self.buildObj.gameObject.transform:Find(TRUCK_TRANS_PATH)
    if truckTrans then
      self.truckObj = truckTrans.gameObject
    end
  end
  if IsNull(self.truckObj) then
    return
  end
  if not self.bFirstRefreshGoods then
    self.bFirstRefreshGoods = true
  end
  local passedTime = serverTime - DataCenter.StageManager.lastIdleRewardTimeStamp
  local maxTime = DataCenter.StageManager.hangUpMaxTime
  local progress = math.min(1, passedTime / maxTime)
  local setting = TRUCK_GOODS_GROUP_SETTING[1]
  for i, v in ipairs(TRUCK_GOODS_GROUP_SETTING) do
    if progress <= v.maxProgress then
      setting = v
      break
    end
  end
  self.curSetting = setting
  local isMax = setting.maxProgress == 1
  self.truckObj:SetActive(not isMax)
  if self.progressGroups[setting.groupPath] == nil then
    self.progressGroups[setting.groupPath] = {}
  end
  local curGroups = self.progressGroups[setting.groupPath]
  for k, groups in pairs(self.progressGroups) do
    if k ~= setting.groupPath then
      for _, group in pairs(groups) do
        if not IsNull(group) and not IsNull(group.gameObject) then
          group.gameObject:SetActive(false)
        end
      end
    end
  end
  for i = 1, math.max(setting.groupNum, #curGroups) do
    local goodsGroup = curGroups[i]
    if not IsNull(goodsGroup) then
      if not IsNull(goodsGroup.gameObject) then
        goodsGroup.gameObject:SetActive(i <= setting.groupNum)
      end
    else
      local idx = i
      local handle = CS.GameEntry.Resource:InstantiateAsync(setting.groupPath, ObjectPoolTag.Normal, LoadPriority.Low)
      local space = setting.space
      handle:completed("+", function()
        if IsNull(self.dummyObj) then
          return
        end
        local transform = handle.gameObject.transform
        transform:SetParent(self.dummyObj.transform)
        if isMax then
          transform:Set_localPosition(0, 0, 0)
          self.soliderTrans = transform:Find(TRUCK_SOLIDER_TRANS_PATH)
        else
          transform:Set_localPosition(0, 1.6 + space * (idx - 1), -1.2)
        end
        transform:Set_localEulerAngles(0, 180, 0)
        transform:Set_localScale(1, 1, 1)
        handle.gameObject:SetActive(self.curSetting.groupPath == setting.groupPath and idx <= setting.groupNum)
      end)
      curGroups[i] = handle
    end
  end
end

function LWGateTruckGoodsManager:DropGoods(srcPos, goodsType)
  local armedUpgradeOpen = DataCenter.LWArmedUpgradeManager:IsArmedUpgradeOpen(true)
  if armedUpgradeOpen and not self.active and not _specialEventFlag then
    return
  end
  local handle = CS.GameEntry.Resource:InstantiateAsync(TRUCK_GOODS_ICON_PREFABS[goodsType])
  local randVec = Quaternion.AngleAxis(math.random() * 360, Vector3.up) * Vector3.forward * 3
  local task = {
    handle = handle,
    x = srcPos.x,
    y = srcPos.y,
    z = srcPos.z,
    vx = randVec.x,
    vy = 8,
    vz = randVec.z,
    delay = 1,
    closeShadowDelay = 0,
    bounce = 0,
    state = 0
  }
  handle:completed("+", function(handle)
    if handle.isError or IsNull(handle.gameObject) then
      task.renderer = nil
    else
      task.renderer = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Renderer))
      task.renderer.gameObject.layer = CS.UnityEngine.LayerMask.NameToLayer("PlaneShadowObject")
    end
  end)
  table.insert(self.dropGoods, task)
end

function LWGateTruckGoodsManager.OnGuideFlowStart(flowId)
  if flowId == 1004 or flowId == 1005 then
    _specialEventFlag = true
  end
end

function LWGateTruckGoodsManager.OnGuideFlowDone(flowId)
  if flowId == 1004 or flowId == 1005 then
    _specialEventFlag = false
  end
end

function LWGateTruckGoodsManager:InitPlotBubbleInfo()
  local sDesc = LuaEntry.DataConfig:TryGetStr("stage_idle_reward", "k5")
  local tDesc = string.split(sDesc, "|")
  self.tBubbleContentList = {}
  for i, v in ipairs(tDesc) do
    local sContent = Localization:GetString(v)
    self.tBubbleContentList[i] = sContent
  end
  local sTimeInfo = LuaEntry.DataConfig:TryGetStr("stage_idle_reward", "k6")
  local tTimeInfo = string.split(sTimeInfo, "|")
  self.nBubbleInterval = tonumber(tTimeInfo[1]) or 5
  self.nBubbleDuration = tonumber(tTimeInfo[2]) or 4
end

function LWGateTruckGoodsManager:PlayPlotBubble3D()
  if IsNull(self.dummyObj) or IsNull(self.soliderTrans) or not self.buildObj.gameObject.activeSelf then
    return
  end
  local transform = self.soliderTrans
  local bubbleParams = {}
  local sContent = ""
  local tBubbleContentList = self.tBubbleContentList
  if tBubbleContentList and 0 < #tBubbleContentList then
    local i = math.random(1, #tBubbleContentList)
    sContent = tBubbleContentList[i]
  end
  bubbleParams.fakePlotMeta = {
    duration = self.nBubbleDuration,
    contentString = sContent,
    left = 1
  }
  bubbleParams.followTarget = transform
  bubbleParams.anchor = bubbleAnchor
  bubbleParams.mode = "3DFollow"
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

function LWGateTruckGoodsManager:SetBuildObjState(value)
  if self.buildObj then
    self.buildObj.gameObject:SetActive(value)
  end
end

return LWGateTruckGoodsManager
