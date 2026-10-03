local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local MummyDesertEffect = BaseClass("MummyDesertEffect", base)

function MummyDesertEffect:__init()
  self.randMin = nil
  self.randMax = nil
  self.effectDuration = 5
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.WorldCameraPoint
  self.prefabPath = nil
  
  function self.timer_action(temp)
    self:Update1000MS()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self:CheckEffect()
  self.timer:Start()
  self:RegisterEvent(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function MummyDesertEffect:__delete()
  self.randMin = nil
  self.randMax = nil
  self.effectDuration = 0
  self.timer_action = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.prefabPath = nil
end

function MummyDesertEffect:CheckEffect()
  self.randMin = 30
  self.randMax = 60
  self.effectDuration = 10
  self.timerT = math.random(self.randMin, self.randMax)
  self.tiemrType = 1
  self.curScene = self:GetCurScene()
end

function MummyDesertEffect:CheckShowFlag()
  if base.CheckShowFlag(self) and self.tiemrType == 2 then
    return true
  end
  return false
end

function MummyDesertEffect:Update1000MS()
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
          self.effectObj.transform:Set_position(pos.x, pos.y, pos.z)
          self.effectObj:SetActive(true)
        elseif self.request == nil then
          local pos = CS.SceneManager.World.CurTarget
          local tilePos = SceneUtils.WorldToTile(pos)
          local pointId = SceneUtils.TilePosToIndex(tilePos)
          self.isGreen = DataCenter.SeasonGreenManager:IsGreen(pointId)
          if self.isGreen then
            self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/S3/Eff_S3_Wind.prefab"
          else
            self.prefabPath = "Assets/_Art_LastWar/Effect/Prefab/S3/Eff_S3_Sand.prefab"
          end
          self:LoadEffect()
        end
      else
        self.prefabPath = nil
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

function MummyDesertEffect:LoadEffectFinish()
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

function MummyDesertEffect:ChangeCameraLodSignal(lod)
  local show = lod <= 2
  if self.effectObj then
    self.effectObj:SetActive(show)
  end
end

return MummyDesertEffect
