local LWBattleSoundManager = BaseClass("LWBattleSoundManager", CEventable)

function LWBattleSoundManager:__init()
  self:RegisterEvent(EventId.ChangeCameraLod, self.OnLodUpdate)
  self:RegisterEvent(EventId.OnEnterCity, self.ClearData)
  self:RegisterEvent(EventId.OnEnterWorld, self.ClearData)
  self:RegisterEvent(EventId.SetMainWorldPointId, self.RefreshData)
  self.allSound = nil
  self.allSoundCount = 0
  self.curLod = 0
  self.isPlay = false
end

function LWBattleSoundManager:__delete()
  self.allSound = nil
  self.allSoundCount = 0
  self.cityCondition = nil
  self.lodList = nil
  self.curLod = 0
  self.cityIdMap = nil
  self:ClearData()
end

function LWBattleSoundManager:OnEnterGame()
  self:RefreshData()
end

function LWBattleSoundManager:InitConfig()
  if self.allSound == nil then
    self.allSound = {}
    local soundData = LuaEntry.DataConfig:TryGetStr("battle_sound", "k1")
    if not string.IsNullOrEmpty(soundData) then
      local array = string.split(soundData, ",")
      for _, v in ipairs(array) do
        local id = tonumber(v) or 0
        if 0 < id then
          table.insert(self.allSound, id)
        end
      end
    end
    self.allSoundCount = #self.allSound
    self.cityCondition = {}
    local conditionData = LuaEntry.DataConfig:TryGetStr("battle_sound", "k2")
    if not string.IsNullOrEmpty(conditionData) then
      local array = string.split(conditionData, ";")
      for _, v in pairs(array) do
        if not string.IsNullOrEmpty(v) then
          local value = string.split(v, ",")
          if #value == 2 then
            local type = tonumber(value[1]) or 0
            local range = tonumber(value[2]) or 0
            if 0 < type and 0 < range then
              self.cityCondition[type] = range * range
            end
          end
        end
      end
    end
    self.attackerCount = LuaEntry.DataConfig:TryGetNum("battle_sound", "k3")
    self.attackerCheckCount = Mathf.Clamp(self.attackerCount * 10, 0, 60)
    self.lodList = {}
    local lodData = LuaEntry.DataConfig:TryGetStr("battle_sound", "k4")
    if not string.IsNullOrEmpty(lodData) then
      local array = string.split(lodData, ",")
      for _, v in ipairs(array) do
        local lod = tonumber(v) or 0
        if 0 < lod then
          self.lodList[lod] = true
        end
      end
    end
    self.cityIdMap = {}
    self.playingSound = {}
    self.playingSoundCount = 0
  end
end

function LWBattleSoundManager:GetConfig()
  if table.count(self.cityIdMap) == 0 then
    self:RefreshCityIdMap()
  end
  return {
    allSoundCount = self.allSoundCount,
    attackerCount = self.attackerCount,
    attackerCheckCount = self.attackerCheckCount,
    cityIdMap = self.cityIdMap
  }
end

function LWBattleSoundManager:GetCityIdData()
  return self.cityIdMap
end

function LWBattleSoundManager:RefreshData()
  self:InitConfig()
  self:ClearData()
  table.clear(self.cityIdMap)
  if SceneUtils.GetIsInWorld() then
    local world = CS.SceneManager.World
    if IsNotNull(world) then
      self:RefreshCityIdMap()
      world:UpdateBattleSoundData()
    end
  end
end

function LWBattleSoundManager:RefreshCityIdMap()
  table.clear(self.cityIdMap)
  local pointId = LuaEntry.Player:GetMainWorldPos()
  if toInt(pointId) <= 0 then
    return
  end
  local selfPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local template = DataCenter.AllianceCityTemplateManager:GetAllTemplate()
  for _, v in pairs(template) do
    local type = v.type
    local cityId = v.id
    local range = self.cityCondition[type]
    if range then
      local dis = self:DisSq(v.pos, selfPos)
      if range >= dis then
        self.cityIdMap[cityId] = true
      end
    end
  end
end

function LWBattleSoundManager:DisSq(pos1, pos2)
  local num1 = pos1.x - pos2.x
  local num2 = pos1.y - pos2.y
  return num1 * num1 + num2 * num2
end

function LWBattleSoundManager:AddOrUpdateMarch(marchUuid, marchTargetPos)
end

function LWBattleSoundManager:DeleteMarch(uuid)
end

function LWBattleSoundManager:RefreshSoundPlay()
  local play = self.isPlay
  self:SetSoundPlay(play)
end

function LWBattleSoundManager:SetSoundPlay(isPlay)
  self.isPlay = isPlay
  local play = isPlay
  play = play and self.isCurLodCanPlay
  if play then
    if self.playingSoundCount > 0 then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      return
    end
    if 0 < self.allSoundCount then
      for _, soundId in ipairs(self.allSound) do
        local sound = DataCenter.LWSoundManager:PlaySound(soundId, true)
        table.insert(self.playingSound, sound)
        self.playingSoundCount = self.playingSoundCount + 1
      end
    end
  else
    self:TryStopSound()
  end
end

function LWBattleSoundManager:CheckAndPlaySound()
  if self.allSound == nil or self.allSoundCount == 0 then
    return false
  end
  if not LuaEntry.Player:IsInSelfServer() then
    return false
  end
  if not self.isPlay then
  end
  self:TryStopSound()
  self:RefreshSoundPlay()
  return 0 < self.playingSoundCount
end

function LWBattleSoundManager:TryStopSound()
  if self.playingSound ~= nil and self.playingSoundCount > 0 then
    for _, sound in ipairs(self.playingSound) do
      DataCenter.LWSoundManager:StopSound(sound)
    end
    table.clear(self.playingSound)
    self.playingSoundCount = 0
    self.isPlay = false
  end
end

function LWBattleSoundManager:OnLodUpdate(lod)
  self.curLod = lod
  if self.allSound == nil or self.allSoundCount == 0 then
    return false
  end
  if not LuaEntry.Player:IsInSelfServer() then
    return false
  end
  self.isCurLodCanPlay = self.lodList[self.curLod] == true
  self:RefreshSoundPlay()
end

function LWBattleSoundManager:ClearData()
  self:TryStopSound()
  self.isPlay = false
  if CS.SceneManager and CS.SceneManager.World then
    self.curLod = CS.SceneManager.World:GetLodLevel()
  end
end

return LWBattleSoundManager
