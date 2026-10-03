local FogTileCount = 100
local FogCount = 10000
local FogTileSize = 2
local GameObject = CS.UnityEngine.GameObject
local fogWhitePath = "Assets/Main/Prefabs/FogOfWar/FogVolume.prefab"
local Fog = BaseClass("Fog")
local Resource = CS.GameEntry.Resource
local FOWSystem = CS.FOWSystem
local ProfilePath = "Assets/Main/Prefabs/PVE/VolumetricFog/%s.asset"
local DefaultProfile = "DistanceFog"

function Fog:__init(battleLevel)
  self.battleLevel = battleLevel
  self.loadComplete = false
  self.unlockFogIds = {}
  self.fogType = battleLevel:GetFogType()
  if self.fogType == FogType.White then
    for i = 1, FogTileCount * FogTileCount do
      self.unlockFogIds[i] = true
    end
  end
  if not DataCenter.LWBattleManager:IsOpenReturnOpt() then
    local field = typeof(CS.FOWSystem):GetField("mRevealers", 56)
    self.revealers = field:GetValue(nil)
  end
  
  function self.onFogLoadComplete()
    self:OnFogLoadComplete()
  end
  
  self.profileAsset = nil
end

function Fog:__delete()
  self:RemoveAll()
  if self.profileAsset then
    self.profileAsset.completed = nil
    Resource:UnloadAsset(self.profileAsset)
    self.profileAsset = nil
  end
end

function Fog:RemoveAll()
  if self.fowSystem then
    if DataCenter.LWBattleManager:IsOpenReturnOpt() then
      if nil == self.revealers and self.fowSystem then
        self.revealers = FOWSystem.mRevealers
      end
      if self.revealers then
        self.revealers:Clear()
      end
    elseif self.revealers then
      self.revealers:Clear()
    end
    if self.inst ~= nil then
      GameObject.Destroy(self.inst.gameObject)
    end
    GameObject.Destroy(self.fowSystem.gameObject)
    self.fowSystem = nil
    self.inst = nil
    Logger.Log("Destroy pve fog")
  end
end

function Fog:InitFog()
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    self.fowSystem = GameObject("FOWSystem"):AddComponent(typeof(CS.FOWSystem))
  else
    self.fowSystem = GameObject("FOWSystem", typeof(CS.FOWSystem)):GetComponent(typeof(CS.FOWSystem))
  end
  self.fowSystem.transform:Set_position(128, 0, 128)
  self.fowSystem.worldSize = 256
  self.fowSystem.textureSize = 256
  self.fowSystem.updateFrequency = 0.33
  self.fowSystem.textureBlendTime = 0.2
  self.fowSystem.blurIterations = 10
  self.fowSystem.isRevealRect = true
  if self.fowSystem.RegisterCompleteAction ~= nil then
    self.loadComplete = false
    self.fowSystem:RegisterCompleteAction(self.onFogLoadComplete)
  else
    self.loadComplete = true
    self:OnFogLoadComplete()
  end
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    if nil == self.revealers and self.fowSystem then
      self.revealers = FOWSystem.mRevealers
    end
    if self.revealers then
      self.revealers:Clear()
    end
  elseif self.revealers then
    self.revealers:Clear()
  end
  if self.fogType == FogType.White and self.fowSystem.CanShowWhiteFog ~= nil then
    RenderSetting.SetHeightFogVisible(false)
    self.fowSystem.blurIterations = 4
    self.inst = Resource:InstantiateAsync(fogWhitePath)
    self.inst:completed("+", function(req)
      local transform = req.gameObject.transform
      transform:SetParent(self.fowSystem.transform)
      transform.localPosition = Vector3.New(0, -5, 0)
      transform.localRotation = Quaternion.Euler(0, 0, 0)
      local profileName = self.battleLevel.pveTemplate.fogVolumeProfile
      if string.IsNullOrEmpty(profileName) then
        profileName = DefaultProfile
      end
      local profilePath = string.format(ProfilePath, profileName)
      self.profileAsset = Resource:LoadAssetAsync(profilePath, typeof(CS.VolumetricFogAndMist2.VolumetricFogProfile))
      
      function self.profileAsset.completed(_)
        if self.profileAsset == nil then
          return
        end
        if self.fowSystem == nil or IsNull(self.fowSystem.transform) or IsNull(transform) then
          Resource:UnloadAsset(self.profileAsset)
          self.profileAsset = nil
          return
        end
        local profile = self.profileAsset.asset
        cast(profile, typeof(CS.VolumetricFogAndMist2.VolumetricFogProfile))
        local vf = transform:GetComponent(typeof(CS.VolumetricFogAndMist2.VolumetricFog))
        vf.profile = profile
      end
    end)
  elseif self.fogType == FogType.White then
    RenderSetting.SettingHeightFog(20, 10, WhiteFogColor, WhiteFogColor, 1)
  else
    RenderSetting.SettingHeightFog(20, 10, BlackFogColor, BlackFogColor, 1)
  end
end

function Fog:FogIdToWorldPos(fogId)
  local fogY = (fogId - 1) // FogTileCount
  local fogX = (fogId - 1) % FogTileCount
  return Vector3.New((fogX + 0.5) * FogTileSize, 0, (fogY + 0.5) * FogTileSize)
end

function Fog:GetFogIndexByPos(worldPos)
  local x, _ = math.floor(worldPos.x / FogTileSize)
  local y, _ = math.floor(worldPos.z / FogTileSize)
  return x + y * FogTileCount + 1
end

function Fog:UnlockAreaFog(triggerId)
  local fogIds = GetTableData(TableName.PVETrigger, triggerId, "UnclockFog")
  if string.IsNullOrEmpty(fogIds) then
    return false
  end
  local tabFogIds = string.split_ii_array(fogIds, ";")
  local doUnlock = false
  for i, fogId in ipairs(tabFogIds) do
    if self.unlockFogIds[fogId] == nil then
      self:UnlockOneFogEx(fogId)
      doUnlock = true
    end
  end
  return doUnlock
end

function Fog:UnlockOneFogEx(fogId)
  self.unlockFogIds[fogId] = true
  if self.loadComplete then
    local revealer = CS.FOWRevealer()
    local fogTileCenter = self:FogIdToWorldPos(fogId)
    revealer:Init(fogTileCenter, Vector2.New(FogTileSize * 0.5, FogTileSize * 0.5))
  end
end

function Fog:CheckWalkPos(pos, forward, speed, canChange)
  if self:IsUnlock(pos) then
    local newLeftForward
    if forward.x < 0 then
      newLeftForward = DirectionLeft
    else
      newLeftForward = DirectionRight
    end
    local leftUnlock = self:IsUnlock(pos + newLeftForward * speed)
    local newTopForward
    if 0 > forward.z then
      newTopForward = DirectionDown
    else
      newTopForward = DirectionTop
    end
    local topUnlock = self:IsUnlock(pos + newTopForward * speed)
    if leftUnlock then
      if topUnlock then
        return canChange, forward
      elseif canChange then
        return false, newLeftForward
      else
        return false, nil
      end
    elseif topUnlock and canChange then
      return false, newTopForward
    else
      return false, nil
    end
  else
    return canChange, forward
  end
  return false, nil
end

function Fog:IsUnlock(worldPos)
  local fogId = self:GetFogIndexByPos(worldPos)
  return self.unlockFogIds[fogId] == true
end

function Fog:SetFogVisible(visible)
  RenderSetting.SetHeightFogVisible(visible)
end

function Fog:OnFogLoadComplete()
  self.loadComplete = true
  for k, v in pairs(self.unlockFogIds) do
    self:UnlockOneFogEx(k)
  end
end

function Fog:SetLockAreaFog(triggerId)
  local fogIds = GetTableData(TableName.PVETrigger, triggerId, "UnclockFog")
  if not string.IsNullOrEmpty(fogIds) then
    local tabFogIds = string.split_ii_array(fogIds, ";")
    for i, fogId in ipairs(tabFogIds) do
      if self.unlockFogIds[fogId] ~= nil then
        self.unlockFogIds[fogId] = nil
      end
    end
  end
end

return Fog
