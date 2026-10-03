local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local WanderStateRun = BaseClass("WanderStateRun")
local Time = _ENV.Time
local CHECK_DESTINATION_DISTANCE_CD = 0.2
local DESTINATION_DISTANCE_THRESHOLD = 0.8

function WanderStateRun:Init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
  self.curTargetPos = nil
  self.areaCenterPos = nil
  self.areaWidth = nil
  self.areaHeight = nil
  if not string.IsNullOrEmpty(self.unit.meta.monster_param) then
    local _param = string.split(self.unit.meta.monster_param, ",")
    if _param[1] and _param[2] then
      self.areaCenterPos = Vector3(tonumber(_param[1]) or 0, 0, tonumber(_param[2]) or 0)
    end
    if _param[3] then
      self.areaWidth = tonumber(_param[3]) or 0
    end
    if _param[4] then
      self.areaHeight = tonumber(_param[4]) or 0
    end
    if CS.CommonUtils.IsDebug() then
      local halfWidth = self.areaWidth / 2
      local halfHeight = self.areaHeight / 2
      self.topLeft = self.areaCenterPos + Vector3.New(-halfWidth, 0, halfHeight)
      self.topRight = self.areaCenterPos + Vector3.New(halfWidth, 0, halfHeight)
      self.bottomLeft = self.areaCenterPos + Vector3.New(-halfWidth, 0, -halfHeight)
      self.bottomRight = self.areaCenterPos + Vector3.New(halfWidth, 0, -halfHeight)
    end
  end
  self.checkDistanceCd = 0
end

function WanderStateRun:__delete()
  self.curTargetPos = nil
  self.areaCenterPos = nil
  self.areaWidth = nil
  self.areaHeight = nil
  self.checkDistanceCd = nil
  self.unit = nil
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
end

function WanderStateRun:OnEnter()
  local pos = self.unit:GetPosition()
  self.unit.agent:SetCurPosition(pos.x, pos.z)
  local speedPercent = self.unit:GetMoveSpeedPercent()
  if 1 < speedPercent then
    self.unit:PlaySimpleAnim(ZombieAnim.Run, 1)
  else
    self.unit:PlaySimpleAnim(ZombieAnim.Walk, 1)
  end
end

function WanderStateRun:OnExit()
end

function WanderStateRun:OnUpdate(deltaTime)
  if self.curTargetPos == nil then
    self.curTargetPos = self:GetRandomPosInArea()
    self:SetDestination(self.curTargetPos)
    return
  end
  if self.curTargetPos == nil then
    return
  end
  if self.checkDistanceCd <= 0 then
    self.checkDistanceCd = CHECK_DESTINATION_DISTANCE_CD
    self:CheckDestinationDistance()
  else
    self.checkDistanceCd = self.checkDistanceCd - deltaTime
  end
  if CS.CommonUtils.IsDebug() then
    self:DrawRect()
  end
end

function WanderStateRun:SetDestination(pos)
  if pos == nil then
    return
  end
  self.unit:SetDestination(pos.x, pos.z)
end

function WanderStateRun:GetRandomPosInArea()
  if not (self.areaCenterPos and self.areaWidth) or not self.areaHeight then
    return nil
  end
  local dirX = math.random(math.floor(self.areaWidth / 2 * -1 * 1000), math.floor(self.areaWidth / 2 * 1000)) / 1000
  local dirZ = math.random(math.floor(self.areaHeight / 2 * -1 * 1000), math.floor(self.areaHeight / 2 * 1000)) / 1000
  return Vector3(dirX, 0, dirZ) + self.areaCenterPos
end

function WanderStateRun:CheckDestinationDistance()
  local curPos = self.unit:GetPosition()
  local distance = Vector3.Distance(curPos, self.curTargetPos)
  if distance < DESTINATION_DISTANCE_THRESHOLD then
    self.curTargetPos = self:GetRandomPosInArea()
    self:SetDestination(self.curTargetPos)
  end
end

function WanderStateRun:DrawRect()
  if self.topLeft then
    CS.UnityEngine.Debug.DrawLine(self.topLeft, self.topRight, HeroBountyRarityColor[HeroBountyRarity.Red])
    CS.UnityEngine.Debug.DrawLine(self.topRight, self.bottomRight, HeroBountyRarityColor[HeroBountyRarity.Red])
    CS.UnityEngine.Debug.DrawLine(self.bottomRight, self.bottomLeft, HeroBountyRarityColor[HeroBountyRarity.Red])
    CS.UnityEngine.Debug.DrawLine(self.bottomLeft, self.topLeft, HeroBountyRarityColor[HeroBountyRarity.Red])
  end
end

return WanderStateRun
