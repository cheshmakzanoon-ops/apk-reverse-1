local WorldShortTimeEffectBubbleManager = BaseClass("WorldShortTimeEffectBubbleManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local musicFestivalPrefix = "MusicFestival2025Bubble_"

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
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.RemoveAllEff)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.RemoveAllEff)
  EventManager:GetInstance():AddListener(EventId.WorldBuildTopBubbleTreasureGet, self.TriggerTreasureDetectBubble)
  EventManager:GetInstance():AddListener(EventId.HelpDetectEndEffectBubbleShow, self.HelpDetectEndEffectBubbleShow)
  EventManager:GetInstance():AddListener(EventId.HelpToTreatVirusBubbleShow, self.HelpToTreatVirusBubbleShow)
  EventManager:GetInstance():AddListener(EventId.VirusPoisonedBubble, self.WhenVirusPoisonedShow)
  EventManager:GetInstance():AddListener(EventId.BuildMainStartPartyShowTips, self.TriggerGetFunBuildMainRewardBubble)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.RemoveAllEff)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.RemoveAllEff)
  EventManager:GetInstance():RemoveListener(EventId.WorldBuildTopBubbleTreasureGet, self.TriggerTreasureDetectBubble)
  EventManager:GetInstance():RemoveListener(EventId.HelpDetectEndEffectBubbleShow, self.HelpDetectEndEffectBubbleShow)
  EventManager:GetInstance():RemoveListener(EventId.HelpToTreatVirusBubbleShow, self.HelpToTreatVirusBubbleShow)
  EventManager:GetInstance():RemoveListener(EventId.VirusPoisonedBubble, self.WhenVirusPoisonedShow)
  EventManager:GetInstance():RemoveListener(EventId.BuildMainStartPartyShowTips, self.TriggerGetFunBuildMainRewardBubble)
end

local function RemoveAllEff()
  WorldShortTimeEffectBubbleManager:GetInstance():RemoveAllEffects()
end

local function OnLodChange(lod)
  for k, v in pairs(WorldShortTimeEffectBubbleManager:GetInstance().allEffect) do
    local request = v.request
    v.script:OnLodChange(lod)
  end
end

local function ShowBubbleEffect(self, bUuid, posIndex, bubbleType, bubbleParam)
  self:RemoveOneEffect(bUuid)
  local bubbleData = WorldEffectBubbleTypeData[bubbleType]
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
    local pos = SceneUtils.TileIndexToWorld(posIndex)
    if string.startswith(bUuid, musicFestivalPrefix) then
      pos = Vector3.New(pos.x - 0.8, pos.y + 1.9, pos.z)
    end
    request.gameObject.transform.position = pos
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

local function RemoveAllEffects(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    v.script:OnDestroy()
    request:Destroy()
  end
  self.allEffect = {}
  for k, v in pairs(self.OnCreateEffect) do
    if v ~= nil then
      v.request:Destroy()
    end
  end
  self.OnCreateEffect = {}
end

local function TimeRefresh(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local refreshListCount = 0
  for uuid, time in pairs(self.needRefreshBuildList) do
    if time > curTime then
      refreshListCount = refreshListCount + 1
    else
      self.needRefreshBuildList[uuid] = nil
      WorldShortTimeEffectBubbleManager:GetInstance():RemoveOneEffect(uuid)
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

local function TriggerTreasureDetectBubble(data)
  local theWorld = CS.SceneManager.World
  if data == nil or theWorld == nil then
    return
  end
  local bUuid = data.bUuid
  local msg = data.msg
  local info = theWorld:GetPointInfoByUuid(bUuid)
  local bubbleType = WorldEffectBubbleType.None
  local bubbleParam
  if info == nil then
    return
  end
  bubbleType = WorldEffectBubbleType.TreasureDetectRewardIcon
  bubbleParam = msg
  WorldShortTimeEffectBubbleManager:GetInstance():ShowBubbleEffect(bUuid, info.mainIndex, bubbleType, bubbleParam)
  WorldShortTimeEffectBubbleManager:GetInstance():AddNeedRefreshBuildUuidTime(bUuid, 2)
end

local function HelpDetectEndEffectBubbleShow(data)
  if data == nil then
    return
  end
  local bUuid = data.bUuid
  local msg = data.msg
  if not CS.SceneManager.World ~= nil then
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  local bubbleType = WorldEffectBubbleType.None
  local bubbleParam
  if info == nil then
    return
  end
  bubbleType = WorldEffectBubbleType.HelpDetectEndEffectBubble
  bubbleParam = {}
  WorldShortTimeEffectBubbleManager:GetInstance():ShowBubbleEffect(bUuid, info.mainIndex, bubbleType, bubbleParam)
  WorldShortTimeEffectBubbleManager:GetInstance():AddNeedRefreshBuildUuidTime(bUuid, 2)
end

local function HelpToTreatVirusBubbleShow(data)
  if data == nil then
    return
  end
  local bUuid = data.bUuid
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info == nil then
    return
  end
  local bubbleType = WorldEffectBubbleType.HelpToTreatVirusBubble
  local bubbleParam = {}
  WorldShortTimeEffectBubbleManager:GetInstance():ShowBubbleEffect(bUuid, info.mainIndex, bubbleType, bubbleParam)
  WorldShortTimeEffectBubbleManager:GetInstance():AddNeedRefreshBuildUuidTime(bUuid, 2)
end

local function WhenVirusPoisonedShow(data)
  if data == nil then
    return
  end
  local bUuid = data.bUuid
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local mainIndex = 0
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info == nil or info.mainIndex == nil then
    return
  else
    mainIndex = info.mainIndex
  end
  local bubbleType = WorldEffectBubbleType.VirusPoisonedBubble
  local bubbleParam = {}
  WorldShortTimeEffectBubbleManager:GetInstance():ShowBubbleEffect(bUuid, mainIndex, bubbleType, bubbleParam)
  WorldShortTimeEffectBubbleManager:GetInstance():AddNeedRefreshBuildUuidTime(bUuid, 2)
end

local function TriggerGetFunBuildMainRewardBubble(data)
  local theWorld = CS.SceneManager.World
  if data == nil or theWorld == nil then
    return
  end
  local bubbleType = WorldEffectBubbleType.MusicFestival2025Bubble
  local bubbleParam = data.operator
  local effectKeyStr = musicFestivalPrefix .. data.pointId
  WorldShortTimeEffectBubbleManager:GetInstance():ShowBubbleEffect(effectKeyStr, data.pointId, bubbleType, bubbleParam)
  WorldShortTimeEffectBubbleManager:GetInstance():AddNeedRefreshBuildUuidTime(effectKeyStr, 2)
end

WorldShortTimeEffectBubbleManager.__init = __init
WorldShortTimeEffectBubbleManager.__delete = __delete
WorldShortTimeEffectBubbleManager.AddListener = AddListener
WorldShortTimeEffectBubbleManager.RemoveListener = RemoveListener
WorldShortTimeEffectBubbleManager.RemoveOneEffect = RemoveOneEffect
WorldShortTimeEffectBubbleManager.RemoveAllEffects = RemoveAllEffects
WorldShortTimeEffectBubbleManager.ShowBubbleEffect = ShowBubbleEffect
WorldShortTimeEffectBubbleManager.OnLodChange = OnLodChange
WorldShortTimeEffectBubbleManager.TimeRefresh = TimeRefresh
WorldShortTimeEffectBubbleManager.AddTimer = AddTimer
WorldShortTimeEffectBubbleManager.DeleteTimer = DeleteTimer
WorldShortTimeEffectBubbleManager.AddNeedRefreshBuildUuidTime = AddNeedRefreshBuildUuidTime
WorldShortTimeEffectBubbleManager.TriggerTreasureDetectBubble = TriggerTreasureDetectBubble
WorldShortTimeEffectBubbleManager.HelpDetectEndEffectBubbleShow = HelpDetectEndEffectBubbleShow
WorldShortTimeEffectBubbleManager.HelpToTreatVirusBubbleShow = HelpToTreatVirusBubbleShow
WorldShortTimeEffectBubbleManager.WhenVirusPoisonedShow = WhenVirusPoisonedShow
WorldShortTimeEffectBubbleManager.TriggerGetFunBuildMainRewardBubble = TriggerGetFunBuildMainRewardBubble
WorldShortTimeEffectBubbleManager.RemoveAllEff = RemoveAllEff
return WorldShortTimeEffectBubbleManager
