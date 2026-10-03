local BaseUnitItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBaseItem")
local BountyHunterMonsterItem = BaseClass("BountyHunterMonsterItem", BaseUnitItem)
local base = BaseUnitItem
local BehaviourStateBirth = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateBirth")
local BehaviourStateIdle = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateIdle")
local BehaviourStateBeHit = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateBeHit")
local MonsterBehaviourStateSeek = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateSeek")
local MonsterBehaviourStatePatrol = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStatePatrol")
local MonsterBehaviourStateFleeBoss = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateFleeBoss")
local MonsterBehaviourStateStun = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateStun")
local MonsterBehaviourStateAlert = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateAlert")
local BehaviourStateDead = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.MonsterBehaviourState.MonsterBehaviourStateDead")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local Localization = CS.GameEntry.Localization

local function __init(self, scene)
  base.__init(self, scene)
  self:RegisterBehaviourState(BountyMonsterStateType.Birth, BehaviourStateBirth.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Idle, BehaviourStateIdle.New())
  self:RegisterBehaviourState(BountyMonsterStateType.BeHit, BehaviourStateBeHit.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Dead, BehaviourStateDead.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Seek, MonsterBehaviourStateSeek.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Patrol, MonsterBehaviourStatePatrol.New())
  self:RegisterBehaviourState(BountyMonsterStateType.FleeBoss, MonsterBehaviourStateFleeBoss.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Stun, MonsterBehaviourStateStun.New())
  self:RegisterBehaviourState(BountyMonsterStateType.Alert, MonsterBehaviourStateAlert.New())
end

local function __delete(self)
  base.__delete(self)
  self.freeChestBornEffectRewards = nil
end

function BountyHunterMonsterItem:Init()
  base.Init(self, "monster")
end

function BountyHunterMonsterItem:LoadItem(monsterData, parent, birthLocalPos, slotIndex, callback)
  if not monsterData then
    self.ShowHunterLog("monsterData is null")
    return
  end
  self.monsterData = monsterData
  self.curHp = self.monsterData.curHp
  self.slotIndex = slotIndex
  self.uuid = monsterData.uuid
  self.itemType = monsterData.itemType
  self.monsterQuality = monsterData.monsterQuality
  self.maxHp = monsterData.maxHp
  self.freeChestBornEffectRewards = nil
  local monsterId = self.monsterData.monsterId
  local monsterTmp = self.monsterData.monsterTmp
  self.monsterTmp = monsterTmp
  if not monsterTmp then
    self.ShowHunterLog("monsterTmp is null, monsterId : " .. monsterId)
    return
  end
  if string.IsNullOrEmpty(monsterTmp.model_name) then
    self.ShowHunterLog("model_name is null, monsterId : " .. monsterId)
    return
  end
  local scale = monsterTmp.scale or 1
  local rotation = Vector3.New(0, 0, 0)
  if monsterTmp.init_rotation then
    local rotationInfo = string.split(monsterTmp.init_rotation, ";")
    if 3 <= #rotationInfo then
      rotation.x = tonumber(rotationInfo[1])
      rotation.y = tonumber(rotationInfo[2])
      rotation.z = tonumber(rotationInfo[3])
    end
  end
  self.clickWidth = monsterTmp.clickWidth
  self.clickHeight = monsterTmp.clickHeight
  self:LoadModel(monsterTmp.model_name, parent, birthLocalPos, rotation, scale, function()
    self.birthWorldPos = self.transform.position
    self:OnLoadedFinish()
    if callback then
      callback()
    end
    if self.transform then
      self.transform.name = self.uuid
    end
  end)
end

function BountyHunterMonsterItem:SetExtraData(extraParam)
  self.hunterWorldPos = extraParam.hunterWorldPos
  self.cameraDir = extraParam.cameraDir
end

function BountyHunterMonsterItem:ChangeBehaviourState(behaviourStateType, ...)
  if self.curState and self.curState.stateType == BountyMonsterStateType.Dead then
    return
  end
  base.ChangeBehaviourState(self, behaviourStateType, ...)
end

function BountyHunterMonsterItem:SetMonsterHpBar(hpBarCpt)
  self.hpBar = hpBarCpt
end

function BountyHunterMonsterItem:IsExistHpBar()
  return self.hpBar ~= nil
end

function BountyHunterMonsterItem:RefreshHpBar(hitParams)
  if not self.hpBar then
    return
  end
  self.hpBar:RefreshHpBar(hitParams)
end

function BountyHunterMonsterItem:OnLoadedFinish()
  if not self.transform then
    return
  end
  self.beHitEffectRoot = self.transform:Find(Const.MONSTER_BE_HIT_EFFECT_PATH)
  self:ChangeBehaviourState(BountyMonsterStateType.Birth)
end

function BountyHunterMonsterItem:UpdateHp(hp)
  self.curHp = hp
  self.ShowHunterLog(string.format("uuid: %s update hp: %s", self.monsterData.uuid, hp))
end

function BountyHunterMonsterItem:IsDied()
  return not self.monsterData or self.monsterData.curHp <= 0
end

function BountyHunterMonsterItem:IsHurt()
  return not self.monsterData or self.monsterData.curHp < self.monsterData.maxHp
end

function BountyHunterMonsterItem:IsBoss()
  return self.monsterQuality == BountyMonsterQualityType.Boss
end

function BountyHunterMonsterItem:GetCurHp()
  if self.monsterData then
    return self.monsterData.curHp
  end
  return 0
end

function BountyHunterMonsterItem:GetMaxHp()
  if self.monsterData then
    return self.monsterData.maxHp
  end
  return 0
end

function BountyHunterMonsterItem:GetAimWorldPos()
  if not self.transform then
    return ResetPosition
  end
  return self.transform.position + Vector3(0, self.modelHeight / 2, 0)
end

function BountyHunterMonsterItem:UpdateHpBarPos(sceneCamera, rtRowWidth, rtRowHeight)
  if not self.hpBar or IsNull(self.transform) or not sceneCamera then
    return
  end
  local worldPos = self.transform.position
  local offset = Vector3(0, self.modelHeight, 0)
  local viewPortPos = sceneCamera:WorldToViewportPoint(worldPos + offset)
  local localPos = Vector2.New(rtRowWidth * viewPortPos.x, rtRowHeight * viewPortPos.y)
  self.hpBar.rectTransform:Set_anchoredPosition(localPos.x, localPos.y)
end

function BountyHunterMonsterItem:ShowHunterLog(info)
end

function BountyHunterMonsterItem:MoveToTargetPos(targetPos, duration, aniName, isFaceTarget, callback, delay, easyType)
  if not self.transform then
    return
  end
  if CS.UnityEngine.Application.isEditor then
    CS.UnityEngine.Debug.DrawLine(targetPos, self.transform.position, Color.red, 2)
  end
  if aniName then
    self:CrossFade(aniName)
  end
  local progress = 0
  local to = 1
  
  local function Getter()
    return progress
  end
  
  local function Setter(x)
    progress = x
  end
  
  local startPos = self.transform.position
  local startRot = Quaternion.LookRotation(Vector3.New(self.transform.forward.x, self.transform.forward.y, self.transform.forward.z))
  local toDir = targetPos - self.transform.position
  if toDir.x == 0 and toDir.y == 0 and toDir.z == 0 then
    Logger.LogWarning("toDir is zero!!!")
    return
  end
  local targetRot = startRot
  if toDir.sqrMagnitude > 1.0E-6 then
    targetRot = Quaternion.LookRotation(Vector3.New(toDir.x, toDir.y, toDir.z))
  end
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  self.moveTween = DOTween.To(Getter, Setter, to, duration):OnUpdate(function()
    local curPos = Vector3.Lerp(startPos, targetPos, progress)
    if self.transform then
      self.transform:Set_position(curPos.x, curPos.y, curPos.z)
      if isFaceTarget then
        self.transform.rotation = Quaternion.Lerp(startRot, targetRot, progress * 2)
      end
    end
  end):OnComplete(function()
    self.moveTween:Kill()
    self.moveTween = nil
    if callback then
      callback()
    end
  end):SetDelay(delay or 0):SetEase(easyType or CS.DG.Tweening.Ease.Linear)
end

function BountyHunterMonsterItem:StopMove()
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
end

function BountyHunterMonsterItem:Destroy()
  base.Destroy(self)
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  if self.beHitEffReq then
    self.beHitEffReq:Destroy()
    self.beHitEffReq = nil
  end
  self.beHitEffectRoot = nil
  self.hunterWorldPos = nil
end

function BountyHunterMonsterItem:IsShowFreeChestBornEffect(reward)
  if self.freeChestBornEffectRewards == nil then
    self.freeChestBornEffectRewards = {}
    if self.monsterTmp ~= nil then
      if not table.IsNullOrEmpty(self.monsterTmp.effect_list1) then
        for i, v in ipairs(self.monsterTmp.effect_list1) do
          local stringList = string.split(v, ";")
          if #stringList == 3 then
            local rewardData = {
              rewardType = tonumber(stringList[1]),
              itemId = tonumber(stringList[2]),
              count = tonumber(stringList[3])
            }
            table.insert(self.freeChestBornEffectRewards, rewardData)
          end
        end
      end
      if not table.IsNullOrEmpty(self.monsterTmp.effect_list2) then
        for i, v in ipairs(self.monsterTmp.effect_list2) do
          local stringList = string.split(v, ";")
          if #stringList == 3 then
            local rewardData = {
              rewardType = tonumber(stringList[1]),
              itemId = tonumber(stringList[2]),
              count = tonumber(stringList[3])
            }
            table.insert(self.freeChestBornEffectRewards, rewardData)
          end
        end
      end
    end
  end
  for i, v in ipairs(self.freeChestBornEffectRewards) do
    if v.rewardType == reward.type and v.itemId == tonumber(reward.value.id) and v.count == tonumber(reward.value.num) then
      return true
    end
  end
  return false
end

function BountyHunterMonsterItem:IsFlyMonster()
  return self.itemType == BountyHunterItemType.FlyMonster
end

function BountyHunterMonsterItem:CreateBeHitEffect(prefabPath)
  if self.beHitEffReq then
    self.beHitEffReq:Destroy()
    self.beHitEffReq = nil
  end
  if self.beHitEffectRoot then
    self.beHitEffReq = self:GenOneEff(prefabPath, self.beHitEffectRoot)
  end
end

BountyHunterMonsterItem.__init = __init
BountyHunterMonsterItem.__delete = __delete
return BountyHunterMonsterItem
