local BulletViewUtilManager = BaseClass("BulletViewUtilManager")
local BulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")

function BulletViewUtilManager:__delete()
  BulletViewUtil.UnInitView()
end

return BulletViewUtilManager
