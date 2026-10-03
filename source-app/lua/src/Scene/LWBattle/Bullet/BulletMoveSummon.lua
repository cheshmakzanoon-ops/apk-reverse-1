local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletMoveSummon = BaseClass("BulletMoveSummon", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletMoveSummon:InitAnimCurve()
  self.summonInterval = self.meta.mvt_type_para_2 / 1000
  self.summonMoveTimer = self.summonInterval
  self.summonCountOnce = self.meta.mvt_type_para
  self.summonTimer = 0
  self.summonRadius = self.meta.mvt_type_para_3
end

function BulletMoveSummon:CollisionDetection()
end

function BulletMoveSummon:OnShow()
  base.OnShow(self)
  local worldForwardX, worldForwardY, worldForwardZ
  worldForwardX, worldForwardY, worldForwardZ = BulletViewFacade.GetForward(self.viewHandle)
  self.summonMoveDir = Vector2.New(worldForwardX * self.meta.bullet_fly_speed, worldForwardZ * self.meta.bullet_fly_speed)
  self.summonMoveValid = true
end

function BulletMoveSummon:OnUpdateTransform(deltaTime)
  if not self.summonMoveValid then
    return
  end
  self.summonMoveTimer = self.summonMoveTimer + deltaTime
  local offX = self.summonMoveDir.x * self.summonMoveTimer
  local offZ = self.summonMoveDir.y * self.summonMoveTimer
  self:SetPositionXYZ(self.startPos.x + offX, self.startPos.y, self.startPos.z + offZ)
  self.summonTimer = self.summonTimer + deltaTime
  if self.summonTimer >= self.summonInterval then
    self.summonTimer = 0
    for i = 1, self.summonCountOnce do
      self:SummonBullet()
    end
  end
end

function BulletMoveSummon:SummonBullet()
  local angle = Mathf.Random(0, 360) * Mathf.Deg2Rad
  local radius = Mathf.Random(0, 1) * self.summonRadius
  local offX = Mathf.Cos(angle) * radius
  local offZ = Mathf.Sin(angle) * radius
  local summonPos = Vector3.New(self.curPos.x + offX, 0, self.curPos.z + offZ)
  if not table.IsNullOrEmpty(self.meta.death_rattle_bullet) then
    local _index = self.index + 1
    for i = 1, #self.meta.death_rattle_bullet do
      local bulletId = self.meta.death_rattle_bullet[i]
      if 0 < bulletId then
        local bulletTemplate = DataCenter.PveBulletTemplateManager:GetTemplate(bulletId)
        if bulletTemplate and bulletTemplate.mvt_type == BulletMoveType.Revert then
          self.bulletMgr:CreateBulletCreator(bulletId, self.skill, {
            pos = self:GetPosition(),
            angle = self:GetAngle(),
            index = _index,
            redirect = false,
            target = self.owner
          })
        else
          self.bulletMgr:CreateBulletCreator(bulletId, self.skill, {
            pos = summonPos,
            angle = self:GetAngle(),
            index = _index,
            redirect = false
          })
        end
      end
    end
  end
end

return BulletMoveSummon
