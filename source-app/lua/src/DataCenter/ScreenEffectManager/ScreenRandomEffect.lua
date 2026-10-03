local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenRandomEffect = BaseClass("ScreenRandomEffect", base)

function ScreenRandomEffect:__init()
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.WorldCameraPoint
  self.changeScale = false
  self.paraConfig = nil
  self.effectsConfig = nil
  self.activeLOD = 2
  self:InitEffect()
  self:RegisterEvent(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  self:RegisterEvent(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeUpdate)
  self:RegisterEvent(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  self:RegisterEvent(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
end

function ScreenRandomEffect:__delete()
  self:UnregisterEvent(EventId.ChangeCameraLod)
  self:UnregisterEvent(EventId.WorldMarchUpdateDisplayMode)
  self:UnregisterEvent(EventId.OnEnterCrossServer)
  self:UnregisterEvent(EventId.OnQuitCrossServer)
  self:DestroyEffect()
end

local function parseParaConfig(str)
  if str == nil or str == "" then
    return nil
  end
  local configs = {}
  local parts = string.split(str, "|")
  if #parts ~= 2 then
    error("[EffectTrigger] config format error: " .. str)
  end
  local timeRange = string.split(parts[1], ",")
  if #timeRange ~= 2 then
    error("[EffectTrigger] time range format error: " .. parts[1])
  end
  local minTime = tonumber(timeRange[1]) or 0
  local maxTime = tonumber(timeRange[2]) or minTime
  local triggerProb = tonumber(parts[2]) or 0
  configs.minTime = minTime
  configs.maxTime = maxTime
  configs.triggerProb = triggerProb
  return configs
end

local function getRandomWaitTime(minT, maxT)
  return minT + math.random() * (maxT - minT)
end

local function checkTrigger(prob)
  return prob > math.random()
end

local function parsEffectsConfig(configStr)
  local configs = {}
  for _, part in ipairs(string.split(configStr, "|")) do
    local fields = string.split(part, ",")
    if #fields == 3 then
      table.insert(configs, {
        weight = tonumber(fields[1]) or 0,
        path = fields[2],
        life = tonumber(fields[3]) or 0
      })
    end
  end
  return configs
end

local function getRandomEffect(configs)
  local totalWeight = 0
  for _, cfg in ipairs(configs) do
    totalWeight = totalWeight + cfg.weight
  end
  if totalWeight <= 0 then
    return nil
  end
  local r = math.random() * totalWeight
  local acc = 0
  for _, cfg in ipairs(configs) do
    acc = acc + cfg.weight
    if r <= acc then
      return cfg
    end
  end
  return nil
end

function ScreenRandomEffect:StartPlayEffectTimer()
  if self.paraConfig == nil then
    return
  end
  local waitTime = getRandomWaitTime(self.paraConfig.minTime, self.paraConfig.maxTime)
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  self.waitTimer = TimerManager:GetInstance():GetTimer(waitTime, self.TryPlayEffect, self, true, false, false)
  self.waitTimer:Start()
end

function ScreenRandomEffect:TryPlayEffect()
  if self.paraConfig == nil then
    return
  end
  local canPlay = checkTrigger(self.paraConfig.triggerProb)
  if canPlay then
    local effectConfig = getRandomEffect(self.effectsConfig)
    if effectConfig ~= nil then
      self:PlayEffect(effectConfig)
    else
      return
    end
  else
    self:StartPlayEffectTimer()
  end
end

function ScreenRandomEffect:PlayEffect(effectConfig)
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if displayLv < 0 then
    self:StartPlayEffectTimer()
  else
    self.prefabPath = effectConfig.path
    self.lifeTime = effectConfig.life
    self:LoadEffect()
  end
end

function ScreenRandomEffect:LoadEffectFinish()
  local world = CS.SceneManager.World
  if not IsNull(world) then
    if self.effectObj then
      local lod = world:GetLodLevel()
      local show = lod <= toInt(self.activeLOD)
      self.effectObj:SetActive(show)
    end
  elseif self.effectObj then
    self.effectObj:SetActive(false)
  end
  base.LoadEffectFinish(self)
end

function ScreenRandomEffect:OnLifeTimeOverCallBack()
  self:StartPlayEffectTimer()
end

function ScreenRandomEffect:InitEffect()
  local seasonConfig = SeasonUtil.GetWorldSkinConfig(SeasonMapType.NineNation)
  if seasonConfig ~= nil then
    self.paraConfig = parseParaConfig(seasonConfig.storm_system_para)
    self.effectsConfig = parsEffectsConfig(seasonConfig.storm_system)
  end
  self:OnSceneChange()
end

function ScreenRandomEffect:OnSceneChange()
  self.curScene = self:GetCurScene()
  self.active = self:CheckShowFlag()
  if self:CheckShowFlag() then
    self:StartPlayEffectTimer()
  else
    self:DestroyEffect()
  end
end

function ScreenRandomEffect:CheckShowFlag()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType ~= SeasonMapType.NineNation then
    return false
  end
  if BattleFieldUtil.InBattleField() then
    return false
  end
  return self.curScene == ScreenEffectSceneFilter.World
end

function ScreenRandomEffect:DestroyEffect()
  self.prefabPath = nil
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  self:RelaseEffect()
end

function ScreenRandomEffect:ChangeCameraLodSignal(lod)
  local show = lod <= self.activeLOD
  if self.effectObj then
    self.effectObj:SetActive(show)
  end
end

function ScreenRandomEffect:OnDisplayModeUpdate(lod)
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if displayLv < 0 then
    self:DestroyEffect()
    self:OnSceneChange()
  else
  end
end

function ScreenRandomEffect:OnEnterCrossServer()
  local serverId = LuaEntry.Player:GetCurServerId()
  local isInBigMap = SeasonUtil.InSeasonBigMapMode(serverId)
  if not isInBigMap then
    self:DestroyEffect()
  end
end

function ScreenRandomEffect:OnQuitCrossServer()
  self:OnSceneChange()
end

return ScreenRandomEffect
