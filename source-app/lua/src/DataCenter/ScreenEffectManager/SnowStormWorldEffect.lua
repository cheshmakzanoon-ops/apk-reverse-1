local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local SnowStormWorldEffect = BaseClass("SnowStormWorldEffect", base)

function SnowStormWorldEffect:__init()
  self.randMin = nil
  self.randMax = nil
  self.effectDuration = 5
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.WorldCameraPoint
  self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_baofengxue_dsj.prefab"
  
  function self.timer_action(temp)
    self:Update1000MS()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self:CheckEffect()
  self.timer:Start()
  self:RegisterEvent(EventId.SeasonSnowStormStart, self.SnowStormStart)
  self:RegisterEvent(EventId.SeasonSnowStormEnd, self.SnowStormEnd)
  self:RegisterEvent(EventId.SeasonSnowStormActivityDataUpdate, self.CheckEffect)
  self:RegisterEvent(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function SnowStormWorldEffect:__delete()
  self.randMin = nil
  self.randMax = nil
  self.effectDuration = 0
  self.timer_action = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.prefabPath = nil
end

function SnowStormWorldEffect:CheckEffect()
  local state, endTime = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
  local now = UITimeManager:GetInstance():GetServerTime()
  if state == ActivitySnowStormState.SnowStorm and endTime > now then
    self.randMin = 5
    self.randMax = 30
    self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_baofengxue_dsj_01.prefab"
    self.effectDuration = 8
  else
    self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_baofengxue_dsj.prefab"
    self.randMin = 10
    self.randMax = 60
    self.effectDuration = 5
  end
  self.timerT = math.random(self.randMin, self.randMax)
  self.tiemrType = 1
  self.curScene = self:GetCurScene()
end

function SnowStormWorldEffect:SnowStormStart()
  self.randMin = 5
  self.randMax = 30
  self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_baofengxue_dsj_01.prefab"
  self.effectDuration = 8
end

function SnowStormWorldEffect:SnowStormEnd()
  self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_daditu_baofengxue_dsj.prefab"
  self.randMin = 10
  self.randMax = 60
  self.effectDuration = 5
end

function SnowStormWorldEffect:CheckShowFlag()
  if base.CheckShowFlag(self) and self.tiemrType == 2 then
    return true
  end
  return false
end

function SnowStormWorldEffect:Update1000MS()
  if IsNull(CS.SceneManager.World) then
    return
  end
  if self.tiemrType == 1 then
    self.timerT = self.timerT - 1
    if self.timerT <= 0 then
      self.tiemrType = 2
      local pos = CS.SceneManager.World.CurTarget
      self.active = self:CheckShowFlag()
      if self.active then
        if not IsNull(self.effectObj) then
          local pos = CS.SceneManager.World.CurTarget
          self.effectObj.transform:Set_position(pos.x, pos.y, pos.z)
          self.effectObj:SetActive(true)
        elseif self.request == nil then
          self:LoadEffect()
        end
      else
        self:RelaseEffect()
      end
      self.timerT = self.effectDuration
    end
  elseif self.tiemrType == 2 then
    self.timerT = self.timerT - 1
    if self.timerT <= 0 then
      self.tiemrType = 1
      self:RelaseEffect()
      self.timerT = math.random(self.randMin, self.randMax)
    end
  end
end

function SnowStormWorldEffect:LoadEffectFinish()
  local world = CS.SceneManager.World
  if not IsNull(world) then
    local lod = world:GetLodLevel()
    local show = lod <= 2
    if self.effectObj then
      self.effectObj:SetActive(show)
    end
  elseif self.effectObj then
    self.effectObj:SetActive(false)
  end
end

function SnowStormWorldEffect:ChangeCameraLodSignal(lod)
  local show = lod <= 2
  if self.effectObj then
    self.effectObj:SetActive(show)
  end
end

return SnowStormWorldEffect
