local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletStatic = BaseClass("BulletStatic", base)

function BulletStatic:CollisionDetection()
  if self.viewHandle > 0 then
    base.CollisionDetection(self)
  else
    local collider = self.target:GetCollider()
    if collider then
      self:DoCollisionForTarget(collider, self.startPos)
      self:DoCollisionForBullet()
    end
  end
end

return BulletStatic
