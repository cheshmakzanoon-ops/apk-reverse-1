local LWHummerSceneBulletCreator = BaseClass("LWHummerSceneBulletCreator")
local ClassTitle = "Scene.LWHummerScene.Bullet.LWHummerSceneBullet%s"

function LWHummerSceneBulletCreator:__init(logic)
end

function LWHummerSceneBulletCreator:__delete()
  self:Destory()
end

function LWHummerSceneBulletCreator:Destory()
  self.bulletMgr = nil
  self.objId = nil
  self.meta = nil
  self.fireTrans = nil
  self.firePointPos = nil
  self.bullet_row_count = nil
  self.bullet_wave_count = nil
  self.bullet_diff_time = nil
  if self.timers then
    for _, timer in pairs(self.timers) do
      timer = nil
    end
    self.timers = nil
  end
  self.pastTime = nil
  self.timerStartIndex = nil
  self.offsetIndex = nil
end

function LWHummerSceneBulletCreator:Init(bulletMgr, objId, meta, fireTrans, target)
  self.bulletMgr = bulletMgr
  self.objId = objId
  self.meta = meta
  self.fireTrans = fireTrans
  self.firePointPos = self.fireTrans.position
  self.target = target
  self.bullet_row_count = self.meta.bullet_row_count
  self.bullet_wave_count = self.meta.bullet_wave_count
  self.bullet_diff_time = self.meta.bullet_diff_time
  if self.bullet_wave_count == 1 and self.bullet_row_count == 1 then
    self:CreateOneBullet()
    self.bulletMgr:RemoveCreator(self)
    return false
  end
  self.timers = {}
  self.pastTime = 0
  self.timerStartIndex = 1
  self.offsetIndex = 0
  local firstOffsetAngle = (1 - self.bullet_row_count) * 0.5 * self.meta.bullet_angle_diff
  for i = 0, self.bullet_wave_count - 1 do
    for j = 0, self.bullet_row_count - 1 do
      local angleOffset = firstOffsetAngle + j * self.meta.bullet_angle_diff
      local delayTime = self.bullet_diff_time * j
      local timerParam = {}
      timerParam.delayTime = delayTime
      timerParam.angleOffset = angleOffset
      self.timers[#self.timers + 1] = timerParam
    end
  end
  return true
end

function LWHummerSceneBulletCreator:GetBulletPos()
  local pos
  if self.meta.start_pos_offset then
    local forward = 1
    if not IsNull(self.fireTrans) then
      forward = self.fireTrans.forward.z
    end
    self.offsetIndex = self.offsetIndex % #self.meta.start_pos_offset
    pos = forward * self.meta.start_pos_offset[self.offsetIndex + 1]
    self.offsetIndex = self.offsetIndex + 1
  else
    pos = Vector3.zero
  end
  return pos
end

function LWHummerSceneBulletCreator:CreateOneBullet(angleOffset)
  local objId = self.bulletMgr:GetNextObjId()
  local params = {}
  params.meta = self.meta
  params.startPos = self:GetBulletPos()
  params.target = self.target
  params.angleOffset = angleOffset
  params.fireTrans = self.fireTrans
  local class = require(string.format(ClassTitle, self:GetClassExtend(self.meta.mvt_type)))
  self.bulletMgr:CreateBullet(class, self.bulletMgr, objId, params)
end

function LWHummerSceneBulletCreator:OnUpdate(dt)
  if self.timerStartIndex > #self.timers then
    return
  end
  self.pastTime = self.pastTime + dt
  for i = self.timerStartIndex, #self.timers do
    local timerParam = self.timers[i]
    if timerParam.delayTime <= self.pastTime then
      self:CreateOneBullet(timerParam.angleOffset)
    else
      self.timerStartIndex = i
      return
    end
  end
  self.bulletMgr:RemoveCreator(self)
end

function LWHummerSceneBulletCreator:GetClassExtend(mvtType)
  if mvtType == 0 then
    return "Static"
  elseif mvtType == 2 then
    return "Curve"
  end
end

return LWHummerSceneBulletCreator
