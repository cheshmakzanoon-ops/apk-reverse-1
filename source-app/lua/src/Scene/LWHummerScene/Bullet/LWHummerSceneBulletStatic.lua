local base = require("Scene.LWHummerScene.Bullet.LWHummerSceneBulletBase")
local LWHummerSceneBulletStatic = BaseClass("LWHummerSceneBulletStatic", base)

function LWHummerSceneBulletStatic:OnUpdateTransform()
  self:CollisionDetection()
  self:LogicDie()
end

return LWHummerSceneBulletStatic
