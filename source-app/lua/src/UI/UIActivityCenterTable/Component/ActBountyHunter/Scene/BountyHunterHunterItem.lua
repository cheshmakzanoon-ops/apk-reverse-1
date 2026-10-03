local BaseUnitItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBaseItem")
local BountyHunterHunterItem = BaseClass("BountyHunterHunterItem", BaseUnitItem)
local Localization = CS.GameEntry.Localization
local base = BaseUnitItem
local BehaviourStateBirth = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateBirth")
local BehaviourStateIdle = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateIdle")
local BehaviourStateAttack = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateAttack")
local BehaviourStateReload = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateReload")
local HunterBehaviourStateAlert = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateAlert")
local HunterBehaviourStateChangeScene = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateChangeScene")
local HunterBehaviourStateFullAtk = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateFullAtk")
local HunterBehaviourStateTurnFront = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateTurnFront")
local HunterBehaviourStateTurnBack = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateTurnBack")
local HunterBehaviourStateChangeGun = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateChangeGun")
local HunterBehaviourStateConfuseMonster = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.HunterBehaviourState.HunterBehaviourStateConfuseMonster")
local BountyHunterBullet = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBullet")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self, scene)
  base.__init(self, scene)
  self:RegisterBehaviourState(BountyHunterStateType.Birth, BehaviourStateBirth.New())
  self:RegisterBehaviourState(BountyHunterStateType.Idle, BehaviourStateIdle.New())
  self:RegisterBehaviourState(BountyHunterStateType.Attack, BehaviourStateAttack.New())
  self:RegisterBehaviourState(BountyHunterStateType.Reload, BehaviourStateReload.New())
  self:RegisterBehaviourState(BountyHunterStateType.Alert, HunterBehaviourStateAlert.New())
  self:RegisterBehaviourState(BountyHunterStateType.ChangeScene, HunterBehaviourStateChangeScene.New())
  self:RegisterBehaviourState(BountyHunterStateType.FullAttack, HunterBehaviourStateFullAtk.New())
  self:RegisterBehaviourState(BountyHunterStateType.TurnFront, HunterBehaviourStateTurnFront.New())
  self:RegisterBehaviourState(BountyHunterStateType.TurnBack, HunterBehaviourStateTurnBack.New())
  self:RegisterBehaviourState(BountyHunterStateType.ChangeGun, HunterBehaviourStateChangeGun.New())
  self:RegisterBehaviourState(BountyHunterStateType.ConfuseMonster, HunterBehaviourStateConfuseMonster.New())
  self.curBulletList = {}
  self.bulletPool = {}
  self.aimController = nil
  self.parentTrans = nil
  self.lastShootIsBig = false
end

local function __delete(self)
  base.__delete(self)
  self.parentTrans = nil
end

local function ChangeBehaviourState(self, behaviourStateType, ...)
  base.ChangeBehaviourState(self, behaviourStateType, ...)
  if self.scene then
    if self:IsAttackVirtualCameraMode(behaviourStateType) then
      self.scene:SetVirtualCameraMachine(true)
    else
      self.scene:SetVirtualCameraMachine(false)
    end
  end
end

function BountyHunterHunterItem:Init()
  base.Init(self, "hunter")
end

function BountyHunterHunterItem:LoadItem(prefabPath, parent, birthLocalPos, localRotation, callback)
  self.prefabPath = prefabPath
  self.callback = callback
  self.uuid = "hunterItem"
  self.parentTrans = parent
  self.lastShootIsBig = false
  local rotation = localRotation
  local scale = 1
  self:LoadModel(prefabPath, parent, birthLocalPos, rotation, scale, function()
    self:OnLoadedFinish()
    if callback then
      callback()
    end
  end)
end

function BountyHunterHunterItem:OnLoadedFinish()
  if not self.transform then
    return
  end
  self.firePointGun1 = self.transform:Find(Const.HUNTER_FIRE_POINT_PATH_GUN1).transform
  self.firePointGun2 = self.transform:Find(Const.HUNTER_FIRE_POINT_PATH_GUN2).transform
  self.effectRootGun2 = self.transform:Find(Const.HUNTER_GUN2_EFFECT_PATH).transform
  self.aimController = self.transform:GetComponent(typeof(CS.BountyHunterHunterItemAimController))
end

function BountyHunterHunterItem:AimTarget(worldPos)
  if not worldPos then
    return
  end
  if self.aimRotateTween then
    self.aimRotateTween:Kill()
    self.aimRotateTween = nil
  end
  self.aimRotateTween = self.aimController:DoRotate(worldPos, Const.HUNTER_AIM_ANIM_LENGTH, self:IsAimingBoss()):OnComplete(function()
    self.aimRotateTween = nil
  end)
end

function BountyHunterHunterItem:CreateBullet(shootParam)
  if not shootParam or not shootParam.targetPos then
    return
  end
  local bulletPrefab = Const.BULLET_PREFAB_PATH[BountyMonsterBulletType.Gun1]
  local hitPrefab = Const.BULLET_HIT_PREFAB_PATH[BountyMonsterBulletType.Gun1]
  local monsterWorldPos = shootParam.targetPos
  local fromWorldPos = self.firePointGun1.transform.position
  local delayTime = 0
  for i = 1, Const.HUNTER_GUN1_BULLET_COUNT do
    local bullet = self:GetBulletFromPool()
    bullet:ReInit(bulletPrefab, hitPrefab, fromWorldPos, monsterWorldPos, function()
      self:ReturnBulletToPool(bullet)
    end, delayTime)
    delayTime = delayTime + Const.HUNTER_GUN1_BULLET_DELTA_TIME
  end
  self:CreateGun1FireEffect(shootParam)
end

function BountyHunterHunterItem:GetBulletFromPool()
  local ret
  if #self.bulletPool <= 0 then
    ret = BountyHunterBullet.New(self.parentTrans)
  else
    ret = self.bulletPool[1]
    table.remove(self.bulletPool, 1)
  end
  local index = #self.curBulletList + 1
  ret.index = index
  self.curBulletList[index] = ret
  return ret
end

function BountyHunterHunterItem:ReturnBulletToPool(bullet)
  if not bullet or not self.bulletPool then
    return
  end
  bullet:Hide()
  self.curBulletList[bullet.index] = nil
  table.insert(self.bulletPool, bullet)
end

function BountyHunterHunterItem:CreateGun1FireEffect(shootParam)
  if self.gun1FireEffReq then
    self.gun1FireEffReq:Destroy()
    self.gun1FireEffReq = nil
  end
  local dir = shootParam.targetPos - self.firePointGun1.transform.position
  local targetRotation = Quaternion.LookRotation(Vector3(dir.x, dir.y, dir.z))
  self.gun1FireEffReq = self:GenOneEff(Const.FIRE_EFFECT_PREFAB_PATH[BountyMonsterBulletType.Gun1], self.firePointGun1.transform, nil, nil)
end

function BountyHunterHunterItem:CreateGun2EffectSmall()
  if self.gun2SmallEffReq then
    self.gun2SmallEffReq:Destroy()
    self.gun2SmallEffReq = nil
  end
  self.gun2SmallEffReq = self:GenOneEff(Const.BULLET_PREFAB_PATH[BountyMonsterBulletType.Gun2Small], self.effectRootGun2)
end

function BountyHunterHunterItem:CreateGun2EffectBig()
  if self.gun2BigEffReq then
    self.gun2BigEffReq:Destroy()
    self.gun2BigEffReq = nil
  end
  self.gun2BigEffReq = self:GenOneEff(Const.BULLET_PREFAB_PATH[BountyMonsterBulletType.Gun2Big], self.effectRootGun2)
end

function BountyHunterHunterItem:ResetAimAngle()
  if self.aimRotateTween then
    self.aimRotateTween:Kill()
    self.aimRotateTween = nil
  end
  if self.aimController then
    self.aimController:ResetRotation()
  end
end

function BountyHunterHunterItem:IsAimAnimPlaying()
  return self.aimRotateTween ~= nil and self.aimRotateTween:IsPlaying()
end

function BountyHunterHunterItem:ShowHunterLog(info)
  if CS.UnityEngine.Application.isEditor then
    UIUtil.ShowTipsId(string.format("[bounty hunter] %s", info))
  end
  Logger.LogError(string.format("[bounty hunter] %s", info))
end

function BountyHunterHunterItem:IsAttackVirtualCameraMode(state)
  for i, v in ipairs(BountyHunterAttackCameraStates) do
    if state == v then
      return true
    end
  end
  return false
end

function BountyHunterHunterItem:Destroy()
  base.Destroy(self)
  if self.aimRotateTween then
    self.aimRotateTween:Kill()
    self.aimRotateTween = nil
  end
  for _, v in pairs(self.curBulletList) do
    v:Destroy()
  end
  self.curBulletList = nil
  for _, v in pairs(self.bulletPool) do
    v:Destroy()
  end
  self.bulletPool = nil
  self.scene = nil
  self.aimController = nil
  self.effectRootGun2 = nil
  if self.gun2BigEffReq then
    self.gun2BigEffReq:Destroy()
    self.gun2BigEffReq = nil
  end
  if self.gun2SmallEffReq then
    self.gun2SmallEffReq:Destroy()
    self.gun2SmallEffReq = nil
  end
end

function BountyHunterHunterItem:SetCurrentAimItem(item)
  if item == nil then
    return
  end
  local needChangeGun = self.curAimItem ~= nil and (self.curAimItem.monsterQuality == BountyMonsterQualityType.Boss and item.monsterQuality ~= BountyMonsterQualityType.Boss or self.curAimItem.monsterQuality ~= BountyMonsterQualityType.Boss and item.monsterQuality == BountyMonsterQualityType.Boss)
  if needChangeGun then
    self:ChangeBehaviourState(BountyHunterStateType.ChangeGun, {
      preItem = self.curAimItem,
      curItem = item
    })
  end
  self.curAimItem = item
  self:SetLastShootIsBig(false)
end

function BountyHunterHunterItem:GetCurrentAimItem()
  return self.curAimItem
end

function BountyHunterHunterItem:IsAimingBoss()
  local curTarget = self:GetCurrentAimItem()
  return curTarget ~= nil and curTarget.IsBoss ~= nil and curTarget:IsBoss()
end

function BountyHunterHunterItem:GetAimingWorldPos()
  local curTarget = self:GetCurrentAimItem()
  if curTarget ~= nil and curTarget.GetAimWorldPos ~= nil then
    return curTarget:GetAimWorldPos()
  end
end

function BountyHunterHunterItem:SetLastShootIsBig(value)
  self.lastShootIsBig = value
end

function BountyHunterHunterItem:GetLastShootIsBig()
  return self.lastShootIsBig
end

function BountyHunterHunterItem:IsCanAttack()
  local curState = self:GetCurBehaviourState()
  if curState and (curState.stateType == BountyHunterStateType.ChangeGun or curState.stateType == BountyHunterStateType.Reload) then
    return false
  end
  if self:IsAimAnimPlaying() then
    return false
  end
  return true
end

function BountyHunterHunterItem:ResetMagicaPhysics()
  if self.aimController then
    self.aimController:ResetMagicaPhysics()
  end
end

BountyHunterHunterItem.__init = __init
BountyHunterHunterItem.__delete = __delete
BountyHunterHunterItem.ChangeBehaviourState = ChangeBehaviourState
return BountyHunterHunterItem
