local base = require("Scene.LWBattle.EffectObj.EffectObjWithPool")
local EffectSpriteWithPool = BaseClass("EffectSpriteWithPool", base)
local FADING_TIME = 0.5
local FADING_SPEED = 1 / FADING_TIME

function EffectSpriteWithPool:Destroy()
  base.Destroy(self)
  self.spriteRender = nil
  self.color = nil
  self.fading = nil
end

function EffectSpriteWithPool:Show(pos, rot, time, parent)
  base.Show(self, pos, rot, time, parent)
  self.spriteRender = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.SpriteRenderer))
  self.color = self.spriteRender.color
  self.color.a = 1
  self.spriteRender.color = self.color
  self.fading = false
end

function EffectSpriteWithPool:OnUpdate()
  if self.countDown <= 0 then
    return
  end
  self.countDown = self.countDown - Time.deltaTime
  if self.countDown <= 0 then
    if self.fading then
      self.mgr:InnerRemove(self)
    else
      self.fading = true
      self.countDown = FADING_TIME
    end
  elseif self.fading then
    self.color.a = self.color.a - Time.deltaTime * FADING_SPEED
    self.spriteRender.color = self.color
  end
end

return EffectSpriteWithPool
