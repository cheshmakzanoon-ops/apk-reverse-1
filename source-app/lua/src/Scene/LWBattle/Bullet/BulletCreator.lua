local BulletCreator = BaseClass("BulletCreator")
local BulletStraight = require("Scene.LWBattle.Bullet.BulletStraight")
local BulletStraightTracking = require("Scene.LWBattle.Bullet.BulletStraightTracking")
local BulletCurve = require("Scene.LWBattle.Bullet.BulletCurve")
local BulletCurveTracking = require("Scene.LWBattle.Bullet.BulletCurveTracking")
local BulletStatic = require("Scene.LWBattle.Bullet.BulletStatic")
local BulletFollow = require("Scene.LWBattle.Bullet.BulletFollow")
local BulletRay = require("Scene.LWBattle.Bullet.BulletRay")
local BulletStaticLineTracking = require("Scene.LWBattle.Bullet.BulletStaticLineTracking")
local BulletStaticLineTrackingCenter = require("Scene.LWBattle.Bullet.BulletStaticLineTrackingCenter")
local BulletStraightGatlingSpecial = require("Scene.LWBattle.Bullet.BulletStraightGatlingSpecial")
local BulletAngleCurveTracking = require("Scene.LWBattle.Bullet.BulletAngleCurveTracking")
local BulletAngleCurve = require("Scene.LWBattle.Bullet.BulletAngleCurve")
local BulletTargetAngleCurve = require("Scene.LWBattle.Bullet.BulletTargetAngleCurve")
local BulletCircleRandom = require("Scene.LWBattle.Bullet.BulletCircleRandom")
local BulletMoveSummon = require("Scene.LWBattle.Bullet.BulletMoveSummon")
local BulletCurvePos = require("Scene.LWBattle.Bullet.BulletCurvePos")
local tmpCreatePos = Vector3.zero
local gatlingSpecialBulletId = 4451
local gatlingSpecialBulletIdV2 = 10013

function BulletCreator:__delete()
  self:Destroy()
end

function BulletCreator:Destroy()
  if self.logic and self.logic.detailLog and self.meta and self.skill and self.skill.owner and self.skill.owner.team and self.bulletMgr and self.bulletMgr.RecordBulletCreate then
    self.bulletMgr:RecordBulletCreate(self.meta.id, self.createCount or 0)
  end
  self.meta = nil
  self.skill = nil
  self.context = nil
  if self.timers then
    for _, timer in pairs(self.timers) do
      timer = {}
    end
  end
  self.timers = {}
  self.timerCount = 0
  self.pastTime = nil
  self.timerStartIndex = nil
  self.objId = nil
  self.logic = nil
  self.bulletMgr = nil
  self.firePointPos = nil
  self.offsetIndex = 0
end

local function IsWillBeCritcalBullet(self)
  if self.skill.owner then
    local critical
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      if self.skill.owner.GetCritProperty then
        critical = self.skill.owner:GetCritProperty()
      else
        critical = self.skill.owner:GetProperty(HeroEffectDefine.CriticalRate_Result)
      end
    else
      critical = self.skill.owner:GetProperty(HeroEffectDefine.CriticalRate_Result)
    end
    return critical > math.random()
  else
    return false
  end
end

local function GetFirePoint(self, id)
  local firePointTransform
  local firePointTransformNull = false
  if self.skill and self.skill.owner then
    if self.skill.owner.GetFirePointById then
      firePointTransform, firePointTransformNull = self.skill.owner:GetFirePointById(id)
    else
      firePointTransform, firePointTransformNull = self.skill.owner:GetFirePoint()
    end
  end
  return firePointTransform, firePointTransformNull
end

local function GetRandomPositionInRingRange(x, y, r1, r2)
  local angle = Mathf.Random(0, 360) * Mathf.Deg2Rad
  local s1 = r1 * r1
  local s2 = r2 * r2
  local s = s1 + Mathf.Random() * (s2 - s1)
  local r = Mathf.Sqrt(s)
  return x + r * Mathf.Cos(angle), y + r * Mathf.Sin(angle)
end

function BulletCreator:Init(logic, bulletMgr, objId, meta, skill, context, criticalMeta)
  self.logic = logic
  self.bulletMgr = bulletMgr
  self.objId = objId
  self.meta = meta
  self.criticalMeta = criticalMeta
  self.PVP = PVPType[self.logic:GetPVEType()]
  self.bullet_row_count = self.PVP and self.meta.bullet_row_count_replay or self.meta.bullet_row_count
  self.bullet_wave_count = self.PVP and self.meta.bullet_wave_count_replay or self.meta.bullet_wave_count
  self.bullet_diff_time = self.PVP and self.meta.bullet_diff_time_replay or self.meta.bullet_diff_time
  self.bullet_wave_diff_time = self.PVP and self.meta.bullet_wave_diff_time_replay or self.meta.bullet_wave_diff_time
  self.skill = skill
  self.context = context
  self.gatlingSpecialBullet = meta.id == gatlingSpecialBulletId or meta.id == gatlingSpecialBulletIdV2
  if not self.context.pos and meta.start_pos_offset and self.skill and self.skill.owner then
    local firePointTransform, firePointTransformNull = self.skill.owner:GetFirePoint()
    if not firePointTransformNull then
      self.firePointPos = firePointTransform.position
    end
  end
  self.offsetIndex = 0
  self.createCount = 0
  if self.logic and self.logic.detailLog and self.meta and self.skill and self.skill.owner and self.skill.owner.team and self.bulletMgr and self.bulletMgr.LogBulletData then
    self.bulletMgr:LogBulletData(self.meta.id, self.bullet_wave_count, self.bullet_row_count)
  end
  if self.meta and self.skill and self.skill.owner and self.skill.owner.team and self.skill.owner.CheckBulletCreate then
    local ownerId = self.skill.owner:CheckBulletCreate()
    if 0 < ownerId and context.index == 1 and self.logic and self.logic.TryCheatBullet then
      self.logic:TryCheatBullet(self.meta, self.bullet_row_count, self.bullet_wave_count, ownerId, self.skill.meta.id)
    end
  end
  if self.bullet_wave_count == 1 and self.bullet_row_count == 1 then
    if self.gatlingSpecialBullet then
      self:CreateOneBulletGatling(nil, false, false)
    else
      local isCritical = IsWillBeCritcalBullet(self)
      self:CreateOneBullet(nil, self.context.redirect, isCritical)
    end
    self:Destroy()
    return false
  end
  self.pastTime = 0
  self.timerStartIndex = 1
  self.timers = {}
  self.timerCount = 0
  local firstOffsetAngle
  if 0 >= self.meta.random_angle_range then
    firstOffsetAngle = (1 - self.bullet_row_count) * 0.5 * self.meta.bullet_angle_diff
  end
  for i = 0, self.bullet_wave_count - 1 do
    for j = 0, self.bullet_row_count - 1 do
      local delayTime = self.bullet_wave_diff_time * i + self.bullet_diff_time * j
      local angleOffset
      if 0 < self.meta.random_angle_range then
        angleOffset = (math.random() * 2 - 1) * self.meta.random_angle_range
      else
        angleOffset = firstOffsetAngle + j * self.meta.bullet_angle_diff
      end
      local timerParam = {}
      timerParam.angleOffset = angleOffset
      timerParam.delayTime = delayTime
      if 0 < i and j == 0 then
        if self.PVP then
          timerParam.redirect = true
        elseif self.logic:GetPVEType() ~= PVEType.World and self.meta.is_following then
          timerParam.redirect = true
        end
      end
      self.timerCount = self.timerCount + 1
      self.timers[self.timerCount] = timerParam
    end
  end
  if self.gatlingSpecialBullet and SceneUtils.GetIsInWorld() then
    local skillId = 0
    if self.skill and self.skill.meta then
      skillId = self.skill.meta.id or 0
      Logger.LogError("BulletCreator init gatling invalid skillId : " .. tostring(skillId))
      self:Destroy()
      return false
    end
  end
  return true
end

function BulletCreator:OnUpdate(deltaTime)
  if self.timerStartIndex > self.timerCount then
    return
  end
  self.pastTime = self.pastTime + deltaTime
  for i = self.timerStartIndex, self.timerCount do
    local timerParam = self.timers[i]
    if timerParam.delayTime <= self.pastTime then
      if self.skill == nil or self.skill.owner == nil or self.skill.owner.curBlood <= 0 then
        self.bulletMgr:RemoveCreator(self)
        return
      end
      if self.gatlingSpecialBullet then
        self:CreateOneBulletGatling(nil, false, false)
      else
        local isCritical = IsWillBeCritcalBullet(self)
        self:CreateOneBullet(timerParam.angleOffset, self.context.redirect or timerParam.redirect, isCritical)
      end
    else
      self.timerStartIndex = i
      return
    end
  end
  self.bulletMgr:RemoveCreator(self)
end

local function GetFireLogic(self)
  if self.skill then
    return self.skill.firelogic
  end
  return 0
end

local function GetFirePoints(self)
  if self.skill then
    return self.skill.firepoint
  end
  return {}
end

function BulletCreator:GetBulletPosAndAngle(bulletIndex)
  local pos = self.context.pos
  local angle = self.context.angle
  local firePointTransform
  local firePointTransformNull = false
  local firePointIndex = 1
  local fireLogic = GetFireLogic(self)
  if 0 < fireLogic and self.meta then
    local firePoints = GetFirePoints(self)
    local range = #firePoints
    if fireLogic == 1 then
      local index = bulletIndex % range
      if index == 0 then
        index = range
      end
      local firePointId = firePoints[index]
      firePointIndex = firePointId
      firePointTransform, firePointTransformNull = GetFirePoint(self, firePointId)
    elseif fireLogic == 2 then
      local index = math.random(1, range)
      local firePointId = firePoints[index]
      firePointIndex = firePointId
      firePointTransform, firePointTransformNull = GetFirePoint(self, firePointId)
    end
  else
    firePointTransform, firePointTransformNull = self.skill.owner:GetFirePoint()
  end
  if self.meta.start_pos_offset and not pos and self.firePointPos then
    local forward = 1
    if not firePointTransformNull then
      forward = firePointTransform.forward.z
    end
    self.offsetIndex = self.offsetIndex % #self.meta.start_pos_offset
    pos = self.firePointPos + forward * self.meta.start_pos_offset[self.offsetIndex + 1]
    if self.meta.start_pos_born_random_ring then
      local index = bulletIndex % #self.meta.start_pos_born_random_ring
      if index == 0 then
        index = #self.meta.start_pos_born_random_ring
      end
      if self.meta.start_pos_born_random_ring[index] then
        local x, z = GetRandomPositionInRingRange(pos.x, pos.z, self.meta.start_pos_born_random_ring[index].r1, self.meta.start_pos_born_random_ring[index].r2)
        pos = Vector3(x, pos.y, z)
      end
    end
    self.offsetIndex = self.offsetIndex + 1
    if self.meta.bullet_effect_onground then
      pos.y = 0
    end
    return pos, 0, firePointIndex, firePointTransform, firePointTransformNull
  end
  if self.meta.start_pos_offset and pos then
    self.offsetIndex = self.offsetIndex % #self.meta.start_pos_offset
    local tmpOffset = self.meta.start_pos_offset[self.offsetIndex + 1]
    local newPos
    self.offsetIndex = self.offsetIndex + 1
    if angle then
      newPos = pos + Quaternion.Euler(0, angle, 0):MulVec3(tmpOffset)
    elseif not firePointTransformNull then
      newPos = pos + Quaternion.Euler(0, firePointTransform.rotation.eulerAngles.y, 0):MulVec3(tmpOffset)
    else
      newPos = pos + tmpOffset
    end
    return newPos, angle or 0, firePointIndex, firePointTransform, firePointTransformNull
  end
  if self.skill and self.skill.owner and not firePointTransformNull then
    local posX, posY, posZ, angleY
    local get = false
    if not pos then
      posX, posY, posZ, angleY = CS.CSUtils.GetPositionAndEulerAngleY(firePointTransform)
      tmpCreatePos.x = posX
      tmpCreatePos.y = posY
      tmpCreatePos.z = posZ
      pos = tmpCreatePos
      get = true
    end
    if not angle then
      if get then
        angle = angleY
      else
        angle = firePointTransform.eulerAngles.y
      end
    end
  end
  if self.meta.bullet_effect_onground then
    pos.y = 0
  end
  return pos or Vector3.zero, angle or 0, firePointIndex, firePointTransform, firePointTransformNull
end

local function GetBulletIndex(self)
  if not self.bulletIndex then
    self.bulletIndex = 1
  else
    self.bulletIndex = self.bulletIndex + 1
  end
  return self.bulletIndex
end

function BulletCreator:CreateOneBullet(angleOffset, redirect, isCritical)
  local objId = self.bulletMgr:GetNextObjId()
  local bulletIndex = GetBulletIndex(self)
  ProfilerUtil.BeginSample("BulletCreateGetPos")
  local pos, angle, firePointIndex, firePointTransform, firePointTransformNull = self:GetBulletPosAndAngle(bulletIndex)
  ProfilerUtil.EndSample()
  local index = self.context.index or 1
  local target = redirect and self.skill:Redirect(pos, self.context.exclusions, index == 1) or self.context.target
  local motherMeta = self.context.mother
  local inheritHitMap = self.context.exclusions
  local source = self.context.source
  local isStraight = false
  local bulletMeta = self.meta
  if isCritical and self.criticalMeta then
    bulletMeta = self.criticalMeta
  end
  local bulletClass
  local bulletMvType = bulletMeta.mvt_type
  if bulletMvType == BulletMoveType.Static then
    bulletClass = BulletStatic
  elseif bulletMvType == BulletMoveType.Straight then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletStraightTracking
      else
        return
      end
    else
      bulletClass = BulletStraight
      isStraight = true
    end
  elseif bulletMvType == BulletMoveType.Parabola then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletCurveTracking
      else
        return
      end
    else
      bulletClass = BulletCurve
    end
  elseif bulletMvType == BulletMoveType.Follow then
    bulletClass = BulletFollow
  elseif bulletMvType == BulletMoveType.Ray then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletStraightTracking
      else
        return
      end
    else
      bulletClass = BulletRay
    end
  elseif bulletMvType == BulletMoveType.Revert then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletCurveTracking
      else
        return
      end
    else
      bulletClass = BulletCurve
    end
  elseif bulletMvType == BulletMoveType.StaticLineTracking then
    bulletClass = BulletStaticLineTracking
  elseif bulletMvType == BulletMoveType.StaticLineTrackingCenter then
    bulletClass = BulletStaticLineTrackingCenter
  elseif bulletMvType == BulletMoveType.CurveByAngle then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletAngleCurveTracking
      else
        return
      end
    else
      bulletClass = BulletAngleCurve
    end
  elseif bulletMvType == BulletMoveType.CurveByTargetAngle then
    if bulletMeta.is_following then
      if target then
        bulletClass = BulletAngleCurveTracking
      else
        return
      end
    else
      bulletClass = BulletTargetAngleCurve
    end
  elseif bulletMvType == BulletMoveType.CircleRandom then
    bulletClass = BulletCircleRandom
  elseif bulletMvType == BulletMoveType.MoveSummon then
    bulletClass = BulletMoveSummon
  elseif bulletMvType == BulletMoveType.ParabolaPos then
    bulletClass = BulletCurvePos
  end
  local params = self.bulletMgr.createBulletParamTable
  params.meta = bulletMeta
  params.skill = self.skill
  params.index = index
  params.startPos = pos
  params.startAngle = angle
  params.angleOffset = angleOffset
  params.target = target
  params.inheritHitMap = inheritHitMap
  params.motherMeta = motherMeta
  params.isCritical = isCritical
  params.firePointIndex = firePointIndex
  params.source = source
  params.isSplash = self.context.isSplash
  params.forceLifeDistance = self.context.forceLifeDistance
  params.motherPos = self.context.motherPos
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if not isStraight then
      self.bulletMgr:CreateBullet(bulletClass, self.logic, self.bulletMgr, objId, params)
    else
      self.bulletMgr:CreateBulletStraightRequest(bulletClass, self.logic, self.bulletMgr, objId, params)
    end
  else
    self.bulletMgr:CreateBullet(bulletClass, self.logic, self.bulletMgr, objId, params, isStraight)
  end
  if self.skill and self.skill.useBulletFireEffect and not firePointTransformNull then
    self.skill:ShowFireEffectImp(firePointTransform)
    self.skill:TryPlayCacheFireSound()
  end
  self.createCount = self.createCount + 1
end

function BulletCreator:CreateOneBulletGatling(angleOffset, redirect, isCritical)
  local objId = self.bulletMgr:GetNextObjId()
  local bulletClass = BulletStraightGatlingSpecial
  local params = self.bulletMgr.createBulletParamTable
  params.meta = self.meta
  params.skill = self.skill
  params.index = self.context.index or 1
  params.startPos = Vector3.New(0, 0, 0)
  params.startAngle = 0
  params.angleOffset = angleOffset
  params.target = self.context.target
  params.inheritHitMap = self.context.exclusions
  params.motherMeta = self.context.mother
  params.isCritical = isCritical
  params.firePointIndex = 1
  params.source = self.context.source
  params.isSplash = self.context.isSplash
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.bulletMgr:CreateBulletGatlingRequest(bulletClass, self.logic, self.bulletMgr, objId, params)
  else
    self.bulletMgr:CreateBulletGatling(bulletClass, self.logic, self.bulletMgr, objId, params)
  end
  self.createCount = self.createCount + 1
end

return BulletCreator
