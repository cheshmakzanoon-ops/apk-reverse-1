local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenEffectSnowStormEffect = BaseClass("ScreenEffectSnowStormEffect", base)

function ScreenEffectSnowStormEffect:__init()
  self.curActivity = nil
  self.snowStormState = nil
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.Camera
  self:CheckEffect()
  self:RegisterEvent(EventId.SeasonSnowStormStart, self.SnowStormStart)
  self:RegisterEvent(EventId.SeasonSnowStormEnd, self.SnowStormEnd)
  self:RegisterEvent(EventId.SeasonSnowStormActivityDataUpdate, self.CheckEffect)
end

function ScreenEffectSnowStormEffect:__delete()
  self.curActivity = nil
  self.snowStormState = nil
end

function ScreenEffectSnowStormEffect:CheckEffect()
  local prePath = self.prefabPath
  self.prefabPath = nil
  local curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
  if curActivity then
    self.curActivity = curActivity
    local eventConfig = LocalController:instance():getLine(TableName.StormEvent, curActivity.cfgId)
    if eventConfig then
      local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(eventConfig.env_temperature))
      if dataTemperature then
        if dataTemperature.level <= 3 then
          self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_pingmu_xiaobaofengxue_01.prefab"
        elseif dataTemperature.level <= 7 then
          self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_pingmu_zhongbaofengxue_01.prefab"
        elseif dataTemperature.level <= 10 then
          self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_pingmu_dabaofengxue_01.prefab"
        end
      end
    end
  end
  local state, endTime = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
  local now = UITimeManager:GetInstance():GetServerTime()
  if state == ActivitySnowStormState.SnowStorm and endTime > now then
    self.snowStormState = ActivitySnowStormState.SnowStorm
  else
    self.snowStormState = ActivitySnowStormState.None
  end
  self.curScene = self:GetCurScene()
  if prePath ~= self.prefabPath and self.snowStormState == ActivitySnowStormState.SnowStorm then
    self:LoadEffect()
  end
end

function ScreenEffectSnowStormEffect:CheckShowFlag()
  local flag = false
  if base.CheckShowFlag(self) and self.snowStormState == ActivitySnowStormState.SnowStorm then
    flag = true
  end
  return flag
end

function ScreenEffectSnowStormEffect:SnowStormStart()
  self.snowStormState = ActivitySnowStormState.SnowStorm
  self:OnSceneChange(self.curScene)
end

function ScreenEffectSnowStormEffect:SnowStormEnd()
  self.snowStormState = nil
  self:RelaseEffect()
end

return ScreenEffectSnowStormEffect
