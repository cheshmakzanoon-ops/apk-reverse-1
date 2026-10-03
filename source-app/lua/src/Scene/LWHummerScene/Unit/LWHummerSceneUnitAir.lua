local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitAir = BaseClass("LWHummerSceneUnitAir", base)
local delayTime = 2
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function LWHummerSceneUnitAir:OnDestroy()
  base.OnDestroy(self)
  self.countdown = nil
end

function LWHummerSceneUnitAir:__init(param)
end

function LWHummerSceneUnitAir:OnInited()
  self.animLength = self:GetAnimLength(MemberAnim.Attack)
  self.animLength = self.animLength > 0 and self.animLength or 2
  self.countdown = self.animLength
  self.skillDelayTime = Constant.AIR_BULLET_DELAY
  self.x = self:GetPosition().x
  self:PlaySimpleAnim("attack")
end

function LWHummerSceneUnitAir:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.skillDelayTime then
    self.skillDelayTime = self.skillDelayTime - Time.deltaTime
    if self.skillDelayTime <= 0 then
      self.logic:CastSkill(self.stage.airBulletId, self.transform)
      self.skillDelayTime = nil
    end
    self:SetPosition(self.x, self.logic.player:GetPosition().z)
  end
  if self.countdown then
    self.countdown = self.countdown - Time.deltaTime
    if 0 > self.countdown then
      self.logic:RemoveUnit(self)
      self.countdown = nil
    end
  end
end

return LWHummerSceneUnitAir
