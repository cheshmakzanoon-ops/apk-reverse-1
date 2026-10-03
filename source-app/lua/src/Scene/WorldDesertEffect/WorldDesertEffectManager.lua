local WorldDesertEffectManager = BaseClass("WorldDesertEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldDesertProtectEffect = require("Scene.WorldDesertEffect.WorldDesertProtectEffect")
local WorldDesertGiveUpEffect = require("Scene.WorldDesertEffect.WorldDesertGiveUpEffect")
local WorldDesertAssistanceBubble = require("Scene.WorldDesertEffect.WorldDesertAssistanceBubble")
local WorldDesertEffectFire = require("Scene.WorldDesertEffect.WorldDesertEffectFire")

function WorldDesertEffectManager:__init()
  self.allProtectTips = {}
  self.OnCreateProtectTips = {}
  self.allGiveUpTips = {}
  self.OnCreateGiveUpTips = {}
  self.allFire = {}
  self.OnCreateFire = {}
  self.needShowList = {}
  self.OnCreateAssistanceBubble = {}
  self.AssistanceBubble = {}
  self.lodCache = 1
  self:AddListener()
end

function WorldDesertEffectManager:__delete()
  self:RemoveListener()
  self:RemoveAllBuff()
end

function WorldDesertEffectManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, WorldDesertEffectManager.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.DesertEffectInView, WorldDesertEffectManager.ShowDesertSignal)
  EventManager:GetInstance():AddListener(EventId.DesertEffectOutView, WorldDesertEffectManager.HideDesertSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, WorldDesertEffectManager.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, WorldDesertEffectManager.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, WorldDesertEffectManager.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.DesertMineInView, WorldDesertEffectManager.OnDesertMineInView)
  EventManager:GetInstance():AddListener(EventId.DesertMineOutView, WorldDesertEffectManager.OnDesertMineOutView)
end

function WorldDesertEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, WorldDesertEffectManager.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.DesertEffectInView, WorldDesertEffectManager.ShowDesertSignal)
  EventManager:GetInstance():RemoveListener(EventId.DesertEffectOutView, WorldDesertEffectManager.HideDesertSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, WorldDesertEffectManager.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, WorldDesertEffectManager.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, WorldDesertEffectManager.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.DesertMineInView, WorldDesertEffectManager.OnDesertMineInView)
  EventManager:GetInstance():RemoveListener(EventId.DesertMineOutView, WorldDesertEffectManager.OnDesertMineOutView)
end

function WorldDesertEffectManager.OnDesertMineInView(desertUuid)
  local desertData = CS.SceneManager.World:GetDesertInfoByUuid(desertUuid)
  if desertData then
    local mgr = WorldDesertEffectManager:GetInstance()
    if desertData.hasAssistance and desertData.lastAssistanceUser ~= nil then
      mgr:ShowAssistanceBubble(desertUuid, desertData.pointIndex, desertData.lastAssistanceUser)
    else
      mgr:RemoveAssistanceBubble(desertUuid)
    end
    local playerType = desertData:GetPlayerType()
    if playerType == CS.PlayerType.PlayerNone then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local fireEndTime = tonumber(desertData.fireEndTime or 0)
      if fireEndTime and fireEndTime > curTime + 3000 then
        mgr:ShowFireEffect(desertUuid, desertData.pointIndex, fireEndTime)
      else
        mgr:RemoveFireEffect(desertUuid)
      end
    else
      mgr:RemoveFireEffect(desertUuid)
    end
  end
end

function WorldDesertEffectManager.OnDesertMineOutView(desertUuid)
  local desertData = CS.SceneManager.World:GetDesertInfoByUuid(desertUuid)
  if desertData then
    WorldDesertEffectManager:GetInstance():RemoveAssistanceBubble(desertUuid)
  end
end

function WorldDesertEffectManager:ShowAssistanceBubble(desertUuid, pointIndex, lastAssistanceUser)
  if self.OnCreateAssistanceBubble[desertUuid] or self.AssistanceBubble[desertUuid] then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/March/WorldDesertAssistanceUser.prefab")
  local param = {}
  param.request = request
  self.OnCreateAssistanceBubble[desertUuid] = param
  self.AssistanceBubble[desertUuid] = nil
  request:completed("+", function()
    self.OnCreateAssistanceBubble[desertUuid] = nil
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = WorldDesertAssistanceBubble.New()
    effect:OnCreate(request)
    effect:ReInit(desertUuid, pointIndex, lastAssistanceUser)
    param.script = effect
    self.AssistanceBubble[desertUuid] = param
  end)
end

function WorldDesertEffectManager:RemoveAssistanceBubble(desertUuid)
  local temp1 = self.AssistanceBubble[desertUuid]
  if temp1 ~= nil then
    if temp1.script then
      temp1.script:OnDestroy()
    end
    if temp1.request then
      temp1.request:Destroy()
    end
    temp1.request = nil
    temp1.script = nil
    self.AssistanceBubble[desertUuid] = nil
  end
  local temp2 = self.OnCreateAssistanceBubble[desertUuid]
  if temp2 ~= nil then
    if temp2.request then
      temp2.request:Destroy()
    end
    self.OnCreateAssistanceBubble[desertUuid] = nil
  end
end

function WorldDesertEffectManager:RemoveALLAssistanceBubble()
  local uuidList = {}
  for uuid, _ in pairs(self.OnCreateAssistanceBubble) do
    uuidList[uuid] = 1
  end
  for uuid, _ in pairs(self.AssistanceBubble) do
    uuidList[uuid] = 1
  end
  for uuid, _ in pairs(uuidList) do
    self:RemoveAssistanceBubble(uuid)
  end
end

function WorldDesertEffectManager.ChangeCameraLodSignal(lod)
  WorldDesertEffectManager:GetInstance():UpdateLod(lod)
end

function WorldDesertEffectManager:UpdateLod(lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.lodCache > 3 then
      if self.allProtectTips ~= nil then
        for k, v in pairs(self.allProtectTips) do
          self.needShowList[k] = 1
        end
      end
      if self.OnCreateProtectTips ~= nil then
        for k, v in pairs(self.OnCreateProtectTips) do
          self.needShowList[k] = 1
        end
      end
      if self.allGiveUpTips ~= nil then
        for k, v in pairs(self.allGiveUpTips) do
          self.needShowList[k] = 1
        end
      end
      if self.OnCreateGiveUpTips ~= nil then
        for k, v in pairs(self.OnCreateGiveUpTips) do
          self.needShowList[k] = 1
        end
      end
      if self.allFire ~= nil then
        for k, v in pairs(self.allFire) do
          self.needShowList[k] = 1
        end
      end
      if self.OnCreateFire ~= nil then
        for k, v in pairs(self.OnCreateFire) do
          self.needShowList[k] = 1
        end
      end
      self:RemoveAllEffect()
    else
      for k, v in pairs(self.needShowList) do
        self:CheckShowDesert(k)
      end
      self.needShowList = {}
    end
  end
end

function WorldDesertEffectManager.RemoveAllTips(data)
  WorldDesertEffectManager:GetInstance():RemoveAllBuff()
end

function WorldDesertEffectManager.OnEnterWorld(data)
end

function WorldDesertEffectManager.OnEnterCity(data)
  WorldDesertEffectManager:GetInstance():RemoveAllBuff()
end

function WorldDesertEffectManager:RemoveAllBuff()
  self:RemoveALLAssistanceBubble()
  if self.allProtectTips ~= nil then
    for k, v in pairs(self.allProtectTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allProtectTips = {}
  end
  if self.OnCreateProtectTips ~= nil then
    for k, v in pairs(self.OnCreateProtectTips) do
      v:Destroy()
    end
    self.OnCreateProtectTips = {}
  end
  if self.allGiveUpTips ~= nil then
    for k, v in pairs(self.allGiveUpTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allGiveUpTips = {}
  end
  if self.OnCreateGiveUpTips ~= nil then
    for k, v in pairs(self.OnCreateGiveUpTips) do
      v:Destroy()
    end
    self.OnCreateGiveUpTips = {}
  end
  if self.allFire ~= nil then
    for k, v in pairs(self.allFire) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allFire = {}
  end
  if self.OnCreateFire ~= nil then
    for k, v in pairs(self.OnCreateFire) do
      v:Destroy()
    end
    self.OnCreateFire = {}
  end
  self.needShowList = {}
end

function WorldDesertEffectManager:RemoveAllEffect()
  if self.allProtectTips ~= nil then
    for k, v in pairs(self.allProtectTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allProtectTips = {}
  end
  if self.OnCreateProtectTips ~= nil then
    for k, v in pairs(self.OnCreateProtectTips) do
      v:Destroy()
    end
    self.OnCreateProtectTips = {}
  end
  if self.allGiveUpTips ~= nil then
    for k, v in pairs(self.allGiveUpTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allGiveUpTips = {}
  end
  if self.OnCreateGiveUpTips ~= nil then
    for k, v in pairs(self.OnCreateGiveUpTips) do
      v:Destroy()
    end
    self.OnCreateGiveUpTips = {}
  end
end

function WorldDesertEffectManager.ShowDesertSignal(data)
  WorldDesertEffectManager:GetInstance():CheckShowDesert(tonumber(data))
end

function WorldDesertEffectManager.HideDesertSignal(data)
  WorldDesertEffectManager:GetInstance():RemoveOneEffect(tonumber(data))
end

function WorldDesertEffectManager:CheckShowDesert(uuid)
  if SceneUtils.GetIsInWorld() == false then
    return
  end
  if self.lodCache > 3 then
    self.needShowList[uuid] = 1
    return
  end
  if CS.SceneManager.World.GetDesertInfoByUuid == nil then
    return
  end
  local desertData = CS.SceneManager.World:GetDesertInfoByUuid(uuid)
  if desertData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local pointId = desertData.pointIndex
    local protectTime = (desertData.protectEndTime or 0) * 1000
    local giveUpTime = (desertData.giveUpTime or 0) * 1000
    local playerType = desertData:GetPlayerType()
    if not string.IsNullOrEmpty(desertData.ownerUid) then
      local selfDesertData = DataCenter.DesertDataManager:GetSelfDesertDataByUuid(uuid)
      if selfDesertData == nil then
        selfDesertData = DataCenter.DesertDataManager:GetSelfEmptyDesertDataByUuid(uuid)
      end
      if selfDesertData ~= nil then
        pointId = selfDesertData.pointId
        giveUpTime = selfDesertData.giveUpTime
        protectTime = selfDesertData.protectTime
      end
    end
    if curTime > giveUpTime then
      self:RemoveGiveUpEffect(uuid)
      if curTime > protectTime then
        self:RemoveProtectEffect(uuid)
      else
        self:ShowProtectEffect(uuid, pointId, protectTime, playerType)
      end
    else
      self:ShowGiveUpEffect(uuid, pointId, giveUpTime, desertData.ownerUid, desertData.allianceId)
    end
  else
    self:RemoveOneEffect(uuid)
  end
end

function WorldDesertEffectManager:RemoveProtectEffect(uuid)
  local temp = self.allProtectTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allProtectTips[uuid] = nil
  end
  temp = self.OnCreateProtectTips[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateProtectTips[uuid] = nil
  end
  self.needShowList[uuid] = nil
end

function WorldDesertEffectManager:RemoveGiveUpEffect(uuid)
  local temp = self.allGiveUpTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allGiveUpTips[uuid] = nil
  end
  temp = self.OnCreateGiveUpTips[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateGiveUpTips[uuid] = nil
  end
  self.needShowList[uuid] = nil
end

function WorldDesertEffectManager:ShowProtectEffect(uuid, pointId, endTime, playerType)
  if SceneUtils.GetIsInWorld() == false then
    return
  end
  self:RemoveGiveUpEffect(uuid)
  if self.allProtectTips[uuid] == nil and self.OnCreateProtectTips[uuid] == nil then
    local modelName = ""
    if playerType == CS.PlayerType.PlayerSelf then
      modelName = "Assets/Main/Prefabs/Building/BuildBlockProtectSelf.prefab"
    elseif playerType == CS.PlayerType.PlayerAlliance then
      modelName = "Assets/Main/Prefabs/Building/BuildBlockProtectAlliance.prefab"
    else
      modelName = "Assets/Main/Prefabs/Building/BuildBlockProtectOther.prefab"
    end
    local request = ResourceManager:InstantiateAsync(modelName)
    self.OnCreateProtectTips[uuid] = request
    request:completed("+", function()
      self.OnCreateProtectTips[uuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local buffTip = WorldDesertProtectEffect.New()
      buffTip:OnCreate(request)
      buffTip:ReInit(uuid, pointId, endTime)
      self.allProtectTips[uuid] = buffTip
    end)
  end
end

function WorldDesertEffectManager:ShowGiveUpEffect(uuid, pointId, endTime, ownerUid, allianceId)
  if SceneUtils.GetIsInWorld() == false then
    return
  end
  self:RemoveProtectEffect(uuid)
  if self.allGiveUpTips[uuid] == nil and self.OnCreateGiveUpTips[uuid] == nil then
    local modelName = "Assets/Main/Prefabs/Building/BuildGiveUpSelf.prefab"
    local request = ResourceManager:InstantiateAsync(modelName)
    self.OnCreateGiveUpTips[uuid] = request
    request:completed("+", function()
      self.OnCreateProtectTips[uuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local buffTip = WorldDesertGiveUpEffect.New()
      buffTip:OnCreate(request)
      buffTip:ReInit(uuid, pointId, endTime, ownerUid, allianceId)
      self.allGiveUpTips[uuid] = buffTip
    end)
  end
end

function WorldDesertEffectManager:ShowFireEffect(uuid, pointId, endTime)
  if SceneUtils.GetIsInWorld() == false then
    return
  end
  if self.allFire[uuid] == nil and self.OnCreateFire[uuid] == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/Build/Eff_dafuw_fire_shu_xiao.prefab")
    self.OnCreateFire[uuid] = request
    request:completed("+", function()
      self.OnCreateFire[uuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local fireScript = WorldDesertEffectFire.New()
      fireScript:OnCreate(request)
      fireScript:ReInit(uuid, pointId, endTime)
      self.allFire[uuid] = fireScript
    end)
  end
end

function WorldDesertEffectManager:RemoveFireEffect(uuid)
  local temp = self.allFire[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allFire[uuid] = nil
  end
  temp = self.OnCreateFire[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateFire[uuid] = nil
  end
  self.needShowList[uuid] = nil
end

function WorldDesertEffectManager:RemoveOneEffect(uuid)
  self:RemoveProtectEffect(uuid)
  self:RemoveGiveUpEffect(uuid)
  self:RemoveFireEffect(uuid)
  self.needShowList[uuid] = nil
end

return WorldDesertEffectManager
