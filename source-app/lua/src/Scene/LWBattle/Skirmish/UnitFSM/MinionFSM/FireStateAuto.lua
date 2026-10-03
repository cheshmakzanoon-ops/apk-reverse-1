local FireStateAuto = BaseClass("FireStateAuto")
local speed = Vector3.zero

function FireStateAuto:__init(unit)
  self.unit = unit
end

function FireStateAuto:__delete()
  self.unit = nil
  self.skill = nil
  self.bulletMeta = nil
  if self.bulletEffectReq then
    self.bulletEffectReq:Destroy()
    self.bulletEffectReq = nil
    self.bulletTransform = nil
  end
  self.hasBullet = nil
end

function FireStateAuto:OnEnter(curCD, maxCD, skillMeta, fakeFire)
  self.curCD = curCD
  self.maxCD = maxCD
  self.skillMeta = skillMeta
  self.fakeFire = fakeFire
  self.bulletMeta = nil
  if self.skillMeta.bullet > 0 then
    self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.skillMeta.bullet)
  end
  if 0 < self.skillMeta.skill_effect then
    self.effectMeta = DataCenter.PveSkillEffectTemplateManager:GetTemplate(self.skillMeta.skill_effect)
  end
  if self.effectMeta then
    self.meta_fire_delay = self.effectMeta.fire_delay
  else
    self.meta_fire_delay = 0
  end
  self.realFireDelay = -1
  self.duration = -1
  self.hasBullet = self.bulletMeta ~= nil
end

function FireStateAuto:OnExit()
  self.skillMeta = nil
  self.bulletMeta = nil
  if self.bulletEffectReq then
    self.bulletEffectReq:Destroy()
    self.bulletEffectReq = nil
    self.bulletTransform = nil
  end
  self.hasBullet = nil
end

function FireStateAuto:OnUpdate()
  local deltaTime = Time.deltaTime
  if self.curCD >= 0 then
    self.curCD = self.curCD - deltaTime
    if self.curCD < 0 then
      if self.unit:IsMoving() then
        self.unit:CrossFadeSimpleAnim(AnimName.AttackMove, 1, 0.2)
      else
        self.unit:CrossFadeSimpleAnim(AnimName.Attack, self.animSpeed, 0.2)
      end
      self.realFireDelay = self.meta_fire_delay
      self.curCD = self.maxCD
    end
  end
  if self.hasBullet and 0 <= self.realFireDelay then
    self.realFireDelay = self.realFireDelay - deltaTime
    if 0 > self.realFireDelay then
      if not self.bulletEffectReq then
        self.bulletEffectReq = CS.GameEntry.Resource:InstantiateAsync(self.bulletMeta.bullet_effect, ObjectPoolTag.Battle)
        self.bulletEffectReq:completed("+", function(req)
          if req.gameObject then
            self.bulletTransform = req.gameObject.transform
            self:InitBulletEffect()
          else
            Logger.LogError("\232\181\132\230\186\144\230\137\190\228\184\141\229\136\176\239\188\129\232\175\183\230\163\128\230\159\165\232\183\175\229\190\132\239\188\129" .. self.bulletMeta.bullet_effect)
          end
        end)
      else
        self:InitBulletEffect()
      end
    end
  end
  if self.bulletTransform and 0 <= self.duration then
    speed.z = self.bulletMeta.bullet_fly_speed * deltaTime
    self.bulletTransform:Translate(speed)
    self.duration = self.duration - deltaTime
    if 0 > self.duration then
      self.bulletTransform.gameObject:SetActive(false)
      self.bulletTransform.position = self.unit:GetFirePoint().position
      if self.unit:IsMoving() then
        self.unit:CrossFadeSimpleAnim(AnimName.Run, 1, 0.2)
      else
        self.unit:CrossFadeSimpleAnim(AnimName.Idle, 1, 0.2)
      end
    end
  end
end

function FireStateAuto:InitBulletEffect()
  if IsNull(self.bulletTransform) then
    return
  end
  self.bulletTransform.gameObject:SetActive(true)
  local startPos = self.unit:GetFirePoint().position
  self.bulletTransform.position = startPos
  local targetPos = self.unit.logic:GetRandomTargetPos(self.unit.platoon.army.index)
  self.bulletTransform:LookAt(targetPos)
  local displace = Vector3.New(targetPos.x - startPos.x, 0, targetPos.z - startPos.z)
  local distance = displace:Magnitude()
  if self.bulletMeta.bullet_fly_speed == 0 then
    self.duration = 1
  else
    self.duration = distance / self.bulletMeta.bullet_fly_speed
  end
end

return FireStateAuto
