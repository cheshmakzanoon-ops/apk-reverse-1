local FireworkWorldBuildBubble = BaseClass("FireworkWorldBuildBubble")
local FireworkParticleController = CS.FireworkParticleController
local ResourceManager = CS.GameEntry.Resource
local TOTAL_TIME_LENGTH = 1
local CLIENT_FIREWORK_TOTAL_TIME_LENGTH = 10
local PRE_CLIENT_FIREWORK_TOTAL_TIME_LENGTH = 4

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:OnAddListener()
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearOutTimer()
  self:ClearClientFireworkTimer()
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:OnRemoveListener()
  self:ComponentDestroy()
  self:DataDestroy()
end

local function UpdateMaterialTexture(self)
  if self.progressSprite and self.progressSpriteMat then
    local sprite = self.progressSprite.sprite
    if sprite then
      self.progressSpriteMat:SetTexture("_MainTex", sprite.texture)
    end
  end
end

local function ClearOutTimer(self)
  if self.outTimer then
    self.outTimer:Stop()
    self.outTimer = nil
  end
end

local function ComponentDefine(self)
  self.simpleAnim = self.transform:Find("LodRoot/Transform"):GetComponent(typeof(CS.SimpleAnimation))
  self.headIcon = self.transform:Find("LodRoot/Transform/HeadContent/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.foreground = self.transform:Find("LodRoot/Transform/HeadContent/Foreground"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.HeadContentGo = self.transform:Find("LodRoot/Transform/HeadContent").gameObject
  self.HeadContentGo:SetActive(false)
  self.itemGo = self.transform:Find("LodRoot/Transform/Item").gameObject
  self.itemGo:SetActive(false)
  self.itemIcon = self.transform:Find("LodRoot/Transform/Item/Bg/Icon"):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.itemText = self.transform:Find("LodRoot/Transform/Item/Bg/Icon/Num"):GetComponent(typeof(CS.TextMeshProEx))
  self.touchEvent = self.transform:Find("LodRoot/Transform/Item/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  if self.touchEvent then
    self.touchEvent.previewType = WorldPreviewType.HighThanMultiObjects
    
    function self.touchEvent.onPointerClick()
      self:OnClick()
    end
  end
  self.itemEffectGo = self.transform:Find("LodRoot/Transform/Item/Eff_Fireworks_Icon_wrapper").gameObject
  self.itemEffectGo:SetActive(false)
  self.cdTimeText = self.transform:Find("LodRoot/Transform/Item/Bg/CDTime"):GetComponent(typeof(CS.TextMeshProEx))
end

local function DestroyUpdateTimer(self)
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

local function DestroyUpdateCountDownTimer(self)
  self.showCountDown = false
  if self.updateCDTimer ~= nil then
    self.updateCDTimer:Stop()
    self.updateCDTimer = nil
  end
end

local function DestroyBeginEffectTimer(self)
  if self.beginEffectTimer ~= nil then
    self.beginEffectTimer:Stop()
    self.beginEffectTimer = nil
  end
end

local function ComponentDestroy(self)
  self:DestroyPreClientFireworkEffect()
  self:DestroyClientFireworkEffect()
  self:DestroyFireworkEffect()
  DestroyBeginEffectTimer(self)
  DestroyUpdateTimer(self)
  DestroyUpdateCountDownTimer(self)
  self.HeadContentGo = nil
  self.simpleAnim = nil
  self.headIcon = nil
  self.foreground = nil
  self.meshRenderer = nil
  self.itemText = nil
  self.itemIcon = nil
  self.itemGo = nil
  self.cdTimeText = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
  self.beginFireTime = nil
  self.curFireworkEndTime = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
  self.beginFireTime = nil
  self.curFireworkEndTime = nil
end

local function ReInit(self, param, bUuid, isRefresh)
  self.param = param
  self.bUuid = bUuid
  self.isRefresh = isRefresh
  self:ShowPanel()
  Logger.Log("FireworkWorldBuildBubble ReInit, isRefresh = " .. tostring(self.isRefresh))
end

local function OnClick(self)
  if self.curBoxData then
    local type = GetTableData(TableName.Firework, self.curBoxData.ConfigId, "type", 0)
    local data = {
      uuid = self.curBoxData.Uuid,
      ownerUid = self.param.buildingInfo.ownerUid,
      type = type
    }
    SFSNetwork.SendMessage(MsgDefines.GetFireworksGift, data)
    if self.fireworkEffectReq == nil then
      DataCenter.LWFireworkManager:SetClientFirework(self.param.buildingInfo.ownerUid, true)
      self:ShowClientFireworkEffect(self.curBoxData.ConfigId)
    end
  end
end

local function ShowHeadIconAnim(self)
  if self.simpleAnim then
    self.itemGo.transform:Set_localPosition(0, self.curFireworkData and 0.96 or 0, 0)
    self:ShowBoxOrItem()
    self.HeadContentGo:SetActive(self.curFireworkData ~= nil)
    if self.curFireworkData then
      self:ShowHeadIcon()
    end
    local enterAnimName = "Default"
    local outAnimName = "out"
    local anim = self.simpleAnim:GetState(enterAnimName)
    if anim == nil then
      return false
    end
    local animTime = self.simpleAnim:GetClipLength(enterAnimName)
    self.simpleAnim:Play(enterAnimName)
    self:ClearOutTimer()
    self.itemEffectGo:SetActive(false)
    self.outTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.curFireworkData then
        self:ShowBeginEffect()
      end
      if self.simpleAnim then
        local outAnimTime = self.simpleAnim:GetClipLength(outAnimName)
        self.simpleAnim:Play(outAnimName)
        TimerManager:GetInstance():DelayInvoke(function()
          if self.itemGo then
            self.itemGo.transform:DOLocalMoveY(0, 0.2)
            self.itemEffectGo:SetActive(true)
          end
        end, outAnimTime)
      end
    end, animTime)
  end
end

local function ShowBeginEffect(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.curFireworkData.StartTime > 1000 * TOTAL_TIME_LENGTH then
    DestroyUpdateTimer(self)
    self.updateTimer = TimerManager:GetInstance():GetTimer(1, self.updateTimer_action, self, false, false, false)
    self.updateTimer:Start()
    if self.curFireworkData then
      self:LoadFireworkEffect(self.curFireworkData.ConfigId)
    end
  else
    DestroyBeginEffectTimer(self)
    self.beginEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.curFireworkData then
        self:LoadFireworkEffect(self.curFireworkData.ConfigId)
      end
      DestroyUpdateTimer(self)
      self.updateTimer = TimerManager:GetInstance():GetTimer(1, self.updateTimer_action, self, false, false, false)
      self.updateTimer:Start()
    end, self.curFireworkData.StartTime / 1000 + TOTAL_TIME_LENGTH - curTime / 1000)
    self.beginEffectTimer:Start()
  end
end

local function ShowHeadIcon(self)
  if self.curFireworkData then
    self.headIcon:SetData(self.curFireworkData.SendUid, self.curFireworkData.Pic, tonumber(self.curFireworkData.PicVer), false)
  end
end

local function ShowBoxOrItem(self)
  local count
  self.curBoxData, count = self:GetCurAvailableBox()
  self.itemGo:SetActive(self.curBoxData ~= nil)
  if self.curBoxData then
    self.itemText.gameObject:SetActive(true)
    local rewardIconPathStr = GetTableData(TableName.Firework, self.curBoxData.ConfigId, "reward_icon", "")
    local countDown = count ~= nil
    self.cdTimeText.gameObject:SetActive(countDown)
    DestroyUpdateCountDownTimer(self)
    if count then
      self.itemText.text = count
      local isReady = CS.GameEntry.Resource:PrefabAssetsDownloaded(rewardIconPathStr)
      self.itemIcon:LoadSprite(rewardIconPathStr, nil, not isReady)
      if self.fireworksDuration == nil then
        self.fireworksDuration = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 0) * 60 * 1000
      end
      self.showCountDown = true
      self.updateCDTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateCountDownTimer, self, false, false, false)
      self.updateCDTimer:Start()
    else
      local rewardIconPathList = string.split(rewardIconPathStr, "|")
      if #rewardIconPathList >= self.curBoxData.Index + 1 then
        local rewardIconPath = rewardIconPathList[self.curBoxData.Index + 1]
        self.itemIcon:LoadSprite(rewardIconPath)
      end
      self.itemText.text = self.curBoxData.Max - self.curBoxData.Num
    end
    return
  end
  if self.curFireworkData then
    self.itemText.gameObject:SetActive(false)
    self.itemGo:SetActive(false)
  end
end

local function GetCurFireworkData(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.param and self.param.buildingInfo.fireworksInfoList then
    local newData
    for i = 0, self.param.buildingInfo.fireworksInfoList.Count - 1 do
      local data = self.param.buildingInfo.fireworksInfoList[i]
      if curTime > data.StartTime and curTime < data.EndTime then
        local type = GetTableData(TableName.Firework, data.ConfigId, "type", 0)
        if type == 1 then
          newData = data
        else
          return data
        end
      end
    end
    if newData then
      return newData
    end
  end
  self:DestroyFireworkEffect()
end

local function GetCurAvailableBox(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local myAllianceUid = LuaEntry.Player:GetAllianceUid()
  if self.param and self.param.buildingInfo.fireworksGiftList then
    local newData
    local count = 0
    if self.fireworksDuration == nil then
      self.fireworksDuration = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 0) * 60 * 1000
    end
    for i = 0, self.param.buildingInfo.fireworksGiftList.Count - 1 do
      local data = self.param.buildingInfo.fireworksGiftList[i]
      if curTime > data.SendTime and data.Num < data.Max and not DataCenter.LWFireworkGiftManager:IsThisGiftUuidGot(data.Uuid) then
        local type = GetTableData(TableName.Firework, data.ConfigId, "type", 0)
        if type == 1 then
          if not string.IsNullOrEmpty(myAllianceUid) and self.param.buildingInfo.allianceId == myAllianceUid and curTime < data.SendTime + self.fireworksDuration then
            newData = data
            count = count + 1
          end
        else
          local isAlly = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.param.buildingInfo.ownerUid) ~= nil
          if isAlly then
            newData = data
            count = nil
            return data
          end
        end
      end
    end
    return newData, count
  end
end

local function ShowPanel(self)
  self:ShowPreClientFireworkEffect()
  local oldCurFireworkData = self.curFireworkData
  self.curFireworkData = self:GetCurFireworkData()
  self.curBoxData = self:GetCurAvailableBox()
  local isShowAnim = self.curFireworkData ~= nil or self.curBoxData ~= nil
  local isShowFireworkDiff = oldCurFireworkData == nil and self.curFireworkData ~= nil or oldCurFireworkData ~= nil and self.curFireworkData == nil or self.curFireworkData and oldCurFireworkData and oldCurFireworkData.EndTime ~= self.curFireworkData.EndTime
  if self.isRefresh and isShowAnim then
    isShowAnim = isShowFireworkDiff
  end
  if isShowAnim then
    self:ShowHeadIconAnim()
  else
    if self.curFireworkData then
      self:ShowHeadIcon()
      if isShowFireworkDiff then
        self:ShowBeginEffect()
      end
    end
    self.itemGo.transform:Set_localPosition(0, 0, 0)
    self:ShowBoxOrItem()
  end
end

local function updateTimer_action(self)
  if self.curFireworkData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.curFireworkData.EndTime then
      self:DestroyFireworkEffect()
      self.curFireworkData = self:GetCurFireworkData()
      self:ShowBoxOrItem()
      if self.curFireworkData then
        self:ShowHeadIconAnim()
        return
      end
    end
  end
  if not self.curFireworkData and not self.curBoxData and not self.clientFireworkEffectReq and not self.preClientFireworkEffectReq then
    EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleRefresh, self.param.buildingInfo.uuid)
  end
end

local function UpdateCountDownTimer(self)
  if self.curBoxData and self.fireworksDuration and self.showCountDown then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.curBoxData.SendTime + self.fireworksDuration
    local offset = endTime - curTime
    if 0 <= offset then
      self.cdTimeText.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offset)
    else
      self.showCountDown = false
      self:ShowBoxOrItem()
    end
  end
end

local function OnAddListener(self)
  function self.OnFireworkGiftDataTimeUpdate(playerUidMap)
    if self.param and self.param.buildingInfo and playerUidMap[self.param.buildingInfo.ownerUid] then
      ShowBoxOrItem(self)
    end
  end
  
  function self.OnWorldMarchUpdateDisplayMode()
    if not DisplaySettings.ShowFireworkEffect() then
      self:DestroyClientFireworkEffect()
      self:DestroyPreClientFireworkEffect()
      self:DestroyFireworkEffect()
    elseif self.curFireworkData then
      self:LoadFireworkEffect(self.curFireworkData.ConfigId)
    end
  end
  
  EventManager:GetInstance():AddListener(EventId.FireworkGiftDataTimeUpdate, self.OnFireworkGiftDataTimeUpdate)
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.OnWorldMarchUpdateDisplayMode)
end

local function OnRemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.FireworkGiftDataTimeUpdate, self.OnFireworkGiftDataTimeUpdate)
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.OnWorldMarchUpdateDisplayMode)
end

local function DestroyFireworkEffect(self)
  if self.fireworkEffectReq then
    DataCenter.LWFireworkManager:SubCurFireworkNumInScene()
    self.fireworkEffectReq:Destroy()
    self.fireworkEffectReq = nil
  end
  if self.stressTestEffects then
    for _, req in ipairs(self.stressTestEffects) do
      if req and not req.isError then
        req:Destroy()
      end
    end
    self.stressTestEffects = nil
  end
end

local function ShowTestEffect(self, effectPath)
  local basePosition = SceneUtils.TileIndexToWorld(self.param.buildingInfo.mainIndex, ForceChangeScene.World, self.param.serverId)
  self.stressTestEffects = {}
  Logger.LogWarning("\229\188\128\229\167\139\229\138\160\232\189\189100\228\184\170\231\131\159\232\138\177\232\191\155\232\161\140\230\128\167\232\131\189\230\181\139\232\175\149...")
  local gridSize = 20
  local spacing = 3
  local startOffsetX = -(gridSize * spacing / 2)
  local startOffsetZ = -(gridSize * spacing / 2)
  local index = 0
  for row = 0, gridSize - 1 do
    for col = 0, gridSize - 1 do
      local offsetX = startOffsetX + col * spacing
      local offsetZ = startOffsetZ + row * spacing
      local position = CS.UnityEngine.Vector3(basePosition.x + offsetX, basePosition.y, basePosition.z + offsetZ)
      local stressReq = ResourceManager:InstantiateAsync(effectPath .. ".prefab")
      table.insert(self.stressTestEffects, stressReq)
      stressReq:completed("+", function()
        if stressReq.isError then
          return
        end
        stressReq.gameObject:SetActive(true)
        stressReq.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        stressReq.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        stressReq.gameObject.transform.position = position
      end)
      index = index + 1
    end
  end
  Logger.LogWarning("\229\174\140\230\136\144100\228\184\170\231\131\159\232\138\177\231\154\132\229\138\160\232\189\189\232\175\183\230\177\130\239\188\140\233\135\135\231\148\168\231\189\145\230\160\188\230\142\146\229\136\151\230\150\185\229\188\143")
end

local function LoadFireworkEffect(self, fireworkId)
  self:DestroyFireworkEffect()
  if not DisplaySettings.ShowFireworkEffect() or DataCenter.LWFireworkManager:IsReachThresholdFireworkNumInScene() then
    return
  end
  local effectPath = GetTableData(TableName.Firework, fireworkId, "effect", "")
  self.curFireworkEndTime = self.curFireworkData.EndTime
  self.fireworkEffectReq = ResourceManager:InstantiateAsync(effectPath .. ".prefab")
  DataCenter.LWFireworkManager:AddCurFireworkNumInScene()
  self.fireworkEffectReq:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(self.param.buildingInfo.mainIndex, ForceChangeScene.World, self.param.serverId)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local elapsedTime = (curTime - self.curFireworkData.StartTime) / 1000 - TOTAL_TIME_LENGTH
    local totalTime = (self.curFireworkData.EndTime - self.curFireworkData.StartTime) / 1000 - TOTAL_TIME_LENGTH
    if 0 < elapsedTime and elapsedTime < totalTime then
      local have, fireworkParticleController = req.gameObject:TryGetComponent(typeof(CS.FireworkParticleController))
      if not have then
        fireworkParticleController = req.gameObject:AddComponent(typeof(CS.FireworkParticleController))
      end
      if fireworkParticleController then
        local cycleTime = LocalController:instance():getIntValue(TableName.Firework, fireworkId, "cycleTime", 10)
        fireworkParticleController:Configure(totalTime, tonumber(cycleTime), elapsedTime / totalTime)
      end
    end
  end)
end

local function DestroyClientFireworkEffect(self)
  if self.param and self.param.buildingInfo and self.param.buildingInfo.ownerUid then
    DataCenter.LWFireworkManager:SetClientFirework(self.param.buildingInfo.ownerUid, nil)
  end
  if self.clientFireworkEffectReq then
    DataCenter.LWFireworkManager:SubCurFireworkNumInScene()
    self.clientFireworkEffectReq:Destroy()
    self.clientFireworkEffectReq = nil
  end
end

local function DestroyPreClientFireworkEffect(self)
  if self.param and self.param.buildingInfo and self.param.buildingInfo.ownerUid then
    DataCenter.LWFireworkManager:SetPreClientFirework(self.param.buildingInfo.ownerUid, nil)
  end
  if self.preClientFireworkEffectReq then
    self.preClientFireworkEffectReq:Destroy()
    self.preClientFireworkEffectReq = nil
  end
end

local function ShowClientFireworkEffect(self, fireworkId)
  if self.clientFireworkEffectReq then
    return
  end
  if not DisplaySettings.ShowFireworkEffect() or DataCenter.LWFireworkManager:IsReachThresholdFireworkNumInScene() then
    return
  end
  local effectPath = GetTableData(TableName.Firework, fireworkId, "effect", "")
  if effectPath == nil or effectPath == "" then
    return
  end
  self.clientFireworkEffectReq = ResourceManager:InstantiateAsync(effectPath .. ".prefab")
  DataCenter.LWFireworkManager:AddCurFireworkNumInScene()
  self.clientFireworkEffectReq:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(self.param.buildingInfo.mainIndex, ForceChangeScene.World, self.param.serverId)
    local have, fireworkParticleController = req.gameObject:TryGetComponent(typeof(CS.FireworkParticleController))
    if not have then
      fireworkParticleController = req.gameObject:AddComponent(typeof(CS.FireworkParticleController))
    end
    local cycleTime = LocalController:instance():getIntValue(TableName.Firework, fireworkId, "cycleTime", 10)
    if fireworkParticleController then
      fireworkParticleController:Configure(tonumber(cycleTime), tonumber(cycleTime), 0)
    end
    self:ClearClientFireworkTimer()
    self.clientFireworkTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DestroyClientFireworkEffect()
      if self.param and self.param.buildingInfo and self.param.buildingInfo.ownerUid then
        EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleRefresh, self.param.buildingInfo.uuid)
      end
    end, tonumber(cycleTime))
  end)
end

local PRE_FIREWORK_EFFECT_PATH_LIST = {
  [1] = "Assets/Main/Prefabs/Firework/Eff_Fireworks_0623_Blue_02.prefab",
  [2] = "Assets/Main/Prefabs/Firework/Eff_Fireworks_0623_Purple_02.prefab",
  [3] = "Assets/Main/Prefabs/Firework/Eff_Fireworks_0623_Orange_02.prefab"
}

local function ShowPreClientFireworkEffect(self)
  local quality = DataCenter.LWFireworkManager:GetPreClientFirework(self.param.buildingInfo.ownerUid)
  if not quality then
    return
  end
  if self.preClientFireworkEffectReq then
    return
  end
  if not DisplaySettings.ShowFireworkEffect() then
    DataCenter.LWFireworkManager:SetPreClientFirework(self.param.buildingInfo.ownerUid, nil)
    return
  end
  local effectPath = PRE_FIREWORK_EFFECT_PATH_LIST[quality]
  if not effectPath then
    return
  end
  self.preClientFireworkEffectReq = ResourceManager:InstantiateAsync(effectPath)
  self.preClientFireworkEffectReq:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(self.param.buildingInfo.mainIndex, ForceChangeScene.World, self.param.serverId)
    local have, fireworkParticleController = req.gameObject:TryGetComponent(typeof(CS.FireworkParticleController))
    if not have then
      fireworkParticleController = req.gameObject:AddComponent(typeof(CS.FireworkParticleController))
    end
    if fireworkParticleController then
      fireworkParticleController:Configure(PRE_CLIENT_FIREWORK_TOTAL_TIME_LENGTH, 2, 0)
    end
    self:ClearPreClientFireworkTimer()
    self.preClientFireworkTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DestroyPreClientFireworkEffect()
    end, PRE_CLIENT_FIREWORK_TOTAL_TIME_LENGTH)
  end)
end

local function ClearClientFireworkTimer(self)
  if self.clientFireworkTimer then
    self.clientFireworkTimer:Stop()
    self.clientFireworkTimer = nil
  end
end

local function ClearPreClientFireworkTimer(self)
  if self.preClientFireworkTimer then
    self.preClientFireworkTimer:Stop()
    self.preClientFireworkTimer = nil
  end
end

FireworkWorldBuildBubble.OnCreate = OnCreate
FireworkWorldBuildBubble.OnDestroy = OnDestroy
FireworkWorldBuildBubble.ComponentDefine = ComponentDefine
FireworkWorldBuildBubble.ComponentDestroy = ComponentDestroy
FireworkWorldBuildBubble.DataDefine = DataDefine
FireworkWorldBuildBubble.DataDestroy = DataDestroy
FireworkWorldBuildBubble.ReInit = ReInit
FireworkWorldBuildBubble.ShowBeginEffect = ShowBeginEffect
FireworkWorldBuildBubble.ShowPanel = ShowPanel
FireworkWorldBuildBubble.OnAddListener = OnAddListener
FireworkWorldBuildBubble.OnRemoveListener = OnRemoveListener
FireworkWorldBuildBubble.OnClick = OnClick
FireworkWorldBuildBubble.updateTimer_action = updateTimer_action
FireworkWorldBuildBubble.UpdateCountDownTimer = UpdateCountDownTimer
FireworkWorldBuildBubble.UpdateMaterialTexture = UpdateMaterialTexture
FireworkWorldBuildBubble.GetCurFireworkData = GetCurFireworkData
FireworkWorldBuildBubble.GetCurAvailableBox = GetCurAvailableBox
FireworkWorldBuildBubble.DestroyFireworkEffect = DestroyFireworkEffect
FireworkWorldBuildBubble.LoadFireworkEffect = LoadFireworkEffect
FireworkWorldBuildBubble.ClearOutTimer = ClearOutTimer
FireworkWorldBuildBubble.ShowHeadIconAnim = ShowHeadIconAnim
FireworkWorldBuildBubble.ShowHeadIcon = ShowHeadIcon
FireworkWorldBuildBubble.ShowBoxOrItem = ShowBoxOrItem
FireworkWorldBuildBubble.DestroyPreClientFireworkEffect = DestroyPreClientFireworkEffect
FireworkWorldBuildBubble.DestroyClientFireworkEffect = DestroyClientFireworkEffect
FireworkWorldBuildBubble.ShowClientFireworkEffect = ShowClientFireworkEffect
FireworkWorldBuildBubble.ShowPreClientFireworkEffect = ShowPreClientFireworkEffect
FireworkWorldBuildBubble.ClearClientFireworkTimer = ClearClientFireworkTimer
FireworkWorldBuildBubble.ClearPreClientFireworkTimer = ClearPreClientFireworkTimer
return FireworkWorldBuildBubble
