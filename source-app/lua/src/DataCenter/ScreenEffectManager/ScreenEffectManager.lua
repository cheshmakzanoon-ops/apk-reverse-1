local ScreenEffectManager = BaseClass("ScreenEffectManager", CEventable)
local ScreenEffectSnowStormEffect = require("DataCenter.ScreenEffectManager.ScreenEffectSnowStormEffect")

function ScreenEffectManager:__init()
  self.effectMap = {}
  self:AddListener()
end

function ScreenEffectManager:__delete()
  if self.effectMap and #self.effectMap > 0 then
    for key, value in pairs(self.effectMap) do
      value:Delete()
    end
  end
  self.effectMap = nil
  self:RemoveListener()
end

function ScreenEffectManager:AddListener()
  self:RegisterEvent(EventId.OnEnterCity, self.EnterCity)
  self:RegisterEvent(EventId.OnEnterWorld, self.EnterWorld)
  self:RegisterEvent(EventId.PveLevelEnter, self.EnterLevel)
  self:RegisterEvent(EventId.LWSeasonWeatherInfoUpdate, self.OnSeasonWeatherInfoUpdate)
  self:RegisterEvent(EventId.AfterWorldCameraLodChanged, self.AfterWorldCameraLodChanged)
end

function ScreenEffectManager:RemoveListener()
  self:UnregisterEvent(EventId.OnEnterCity)
  self:UnregisterEvent(EventId.OnEnterWorld)
  self:UnregisterEvent(EventId.PveLevelEnter)
  self:UnregisterEvent(EventId.LWSeasonWeatherInfoUpdate)
  self:UnregisterEvent(EventId.AfterWorldCameraLodChanged)
end

function ScreenEffectManager:OnEnterGame()
  local isInSeason = SeasonUtil.IsInSeason(true)
  local data = ScreenEffectSnowStormEffect.New()
  table.insert(self.effectMap, data)
  if not isInSeason then
    return
  end
  if DataCenter.SeasonWeatherManager:IsOpen() then
    self:OnSeasonWeatherInfoUpdate()
  end
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Snow then
    local SnowStormWorldEffect = require("DataCenter.ScreenEffectManager.SnowStormWorldEffect")
    data = SnowStormWorldEffect.New()
    table.insert(self.effectMap, data)
  elseif seasonType == SeasonMapType.Mummy then
    local MummyDesertEffect = require("DataCenter.ScreenEffectManager.MummyDesertEffect")
    data = MummyDesertEffect.New()
    table.insert(self.effectMap, data)
  elseif seasonType == SeasonMapType.Darkness then
    local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
    if not sunrise then
      local ScreenEffectBloodyNightEffect = require("DataCenter.ScreenEffectManager.ScreenEffectBloodyNightEffect")
      data = ScreenEffectBloodyNightEffect.New()
      table.insert(self.effectMap, data)
      local ScreenEffectWhiteNightEffect = require("DataCenter.ScreenEffectManager.ScreenEffectWhiteNightEffect")
      data = ScreenEffectWhiteNightEffect.New()
      table.insert(self.effectMap, data)
    end
  elseif seasonType == SeasonMapType.NineNation then
    local ScreenRandomEffect = require("DataCenter.ScreenEffectManager.ScreenRandomEffect")
    data = ScreenRandomEffect.New()
    table.insert(self.effectMap, data)
  end
end

function ScreenEffectManager:EnterCity()
  local pThis = DataCenter.ScreenEffectManager
  if pThis and pThis.effectMap and #pThis.effectMap > 0 then
    for key, value in pairs(pThis.effectMap) do
      value:OnSceneChange(ScreenEffectSceneFilter.City)
    end
  end
end

function ScreenEffectManager:EnterWorld()
  local pThis = DataCenter.ScreenEffectManager
  if pThis then
    if CS.SceneManager and CS.SceneManager.World then
      pThis.curLod = CS.SceneManager.World:GetLodLevel()
    end
    pThis:UpdateInWorld()
  end
end

function ScreenEffectManager:EnterLevel()
  local pThis = DataCenter.ScreenEffectManager
  if pThis and pThis.effectMap and #pThis.effectMap > 0 then
    for key, value in pairs(pThis.effectMap) do
      value:OnSceneChange(ScreenEffectSceneFilter.None)
    end
  end
end

function ScreenEffectManager:AfterWorldCameraLodChanged(lodLevel)
  local pThis = DataCenter.ScreenEffectManager
  if pThis then
    pThis.curLod = lodLevel
    if pThis and pThis.effectMap and #pThis.effectMap > 0 then
      for key, value in pairs(pThis.effectMap) do
        value:OnLodChanged(lodLevel)
      end
      pThis:UpdateInWorld()
    end
  end
end

function ScreenEffectManager:UpdateInWorld()
  local pThis = DataCenter.ScreenEffectManager
  if pThis then
    local curFilter = ScreenEffectSceneFilter.None
    if not BattleFieldUtil.InBattleField() then
      curFilter = ScreenEffectSceneFilter.World
    end
    if pThis and pThis.effectMap and #pThis.effectMap > 0 then
      for key, value in pairs(pThis.effectMap) do
        value:OnSceneChange(curFilter)
      end
    end
  end
end

function ScreenEffectManager:OnSeasonWeatherInfoUpdate()
  if not DataCenter.SeasonWeatherManager:IsOpen() then
    return
  end
  local pThis = DataCenter.ScreenEffectManager
  if pThis == nil then
    return
  end
  local effectMap = pThis.effectMap
  pThis:UnregisterEvent(EventId.LWSeasonWeatherInfoUpdate)
  if effectMap == nil then
    return
  end
  local WeatherWorldPoints = require("DataCenter.ScreenEffectManager.WeatherWorldPoints")
  local data = WeatherWorldPoints.New(effectMap)
  table.insert(effectMap, data)
  local WeatherWorldEffect = require("DataCenter.ScreenEffectManager.WeatherWorldEffect")
  data = WeatherWorldEffect.New()
  table.insert(effectMap, data)
  local ScreenEffectWeatherEffect = require("DataCenter.ScreenEffectManager.ScreenEffectWeatherEffect")
  data = ScreenEffectWeatherEffect.New()
  table.insert(effectMap, data)
  local ScreenEffectWeatherLoopEffect = require("DataCenter.ScreenEffectManager.ScreenEffectWeatherLoopEffect")
  data = ScreenEffectWeatherLoopEffect.New()
  table.insert(effectMap, data)
  if SceneUtils.GetIsInWorld() then
    pThis:UpdateInWorld()
  end
end

return ScreenEffectManager
