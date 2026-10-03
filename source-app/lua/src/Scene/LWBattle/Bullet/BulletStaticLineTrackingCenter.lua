local base = require("Scene.LWBattle.Bullet.BulletStaticLineTracking")
local BulletStaticLineTrackingCenter = BaseClass("BulletStaticLineTrackingCenter", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletStaticLineTrackingCenter:SetEffectStartEndPosition()
  if not self.lineRenderers then
    return
  end
  local endPos = self:GetTargetPos()
  if not endPos then
    self:LogicDie()
    return
  end
  if not self.cachedStartVector3 then
    self.cachedStartVector3 = Vector3.New()
  end
  if not self.cachedEndVector3 then
    self.cachedEndVector3 = Vector3.New()
  end
  local startX, startY, startZ = 0, 0, 0
  if self.sourceTransform then
    startX, startY, startZ = self.sourceTransform:Get_position()
  end
  local targetColliderPosY = self:GetTargetColliderPosY()
  self.cachedStartVector3.x = startX
  self.cachedStartVector3.y = startY
  self.cachedStartVector3.z = startZ
  self.cachedEndVector3.x = endPos.x
  self.cachedEndVector3.y = targetColliderPosY or self.constantY
  self.cachedEndVector3.z = endPos.z
  if not self.posArray then
    self.posArray = {}
  end
  self.posArray[1] = self.cachedStartVector3
  self.posArray[2] = self.cachedEndVector3
  for i = 1, #self.lineRenderers do
    self.lineRenderers[i]:SetPositions(self.posArray)
  end
end

return BulletStaticLineTrackingCenter
