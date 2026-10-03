local base = require("Scene.LWBattle.Bullet.BulletStraight")
local VIEW_INVALID_HANDLE = -1
local BulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")
local BulletStraightGatlingSpecial = BaseClass("BulletStraightGatlingSpecial", base)

function BulletStraightGatlingSpecial:ReInit(logic, bulletMgr, objId, params)
  self.hasData = true
  self.logic = logic
  self.bulletMgr = bulletMgr
  self.objId = objId
  self.meta = params.meta
  self.metaId = self.meta.id
  self.skill = params.skill
  self.owner = params.skill.owner
  self.index = params.index
  local gatlingData = bulletMgr:GetGatlingData()
  self.noCollision = gatlingData.noCollision
  self.lifetime = gatlingData.lifeTime
  self.colliderCenterOffset = Vector3.zero
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  self.dotCD = 0
  self.targetLayerMask = gatlingData.targetLayerMask
  self.targetAllyExcludeSelf = gatlingData.targetAllyExcludeSelf
  self.targetSelfExcludeAlly = gatlingData.targetSelfExcludeAlly
  self.targetSearchType = gatlingData.targetSearchType
  self.colliderExclusion = self.targetAllyExcludeSelf and self.owner or nil
  self.collidedIdList = {}
  self.collidedTimes = 0
  self.base_type = gatlingData.base_type
  self.bulletHp = gatlingData.limit
  self.firePointIndex = 1
  self.dead_delay = gatlingData.dead_delay
  self:DoCreateSound()
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    local loadedValue, px, py, pz
    self.viewHandle, px, py, pz, loadedValue = BulletViewUtil.CreateStraightGatlingView(self.objId, self.owner.viewHandle)
    self.startPos = Vector3.New(px, py, pz)
    self.curPos = Vector3.New(px, py, pz)
    self.viewLoaded = loadedValue == 1
    self.isBulletVisible = true
    self.lifeTimeEnd = false
    self.curColliderCenterPos = self.curPos * 1
    if self.viewLoaded then
      self:OnLoaded(0)
    end
  end
end

function BulletStraightGatlingSpecial:AfterCreateViewList(viewHandle, px, py, pz, loadedValue)
  self.viewHandle = viewHandle
  self.startPos = Vector3.New(px, py, pz)
  self.curPos = Vector3.New(px, py, pz)
  self.viewLoaded = loadedValue == 1
  self.isBulletVisible = true
  self.lifeTimeEnd = false
  self.curColliderCenterPos = self.curPos * 1
  if self.viewLoaded then
    self:OnLoaded(0)
  end
end

return BulletStraightGatlingSpecial
