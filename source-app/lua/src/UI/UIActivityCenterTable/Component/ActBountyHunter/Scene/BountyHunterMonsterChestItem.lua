local BaseUnitItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBaseItem")
local BountyHunterMonsterChestItem = BaseClass("BountyHunterMonsterChestItem", BaseUnitItem)
local Localization = CS.GameEntry.Localization
local base = BaseUnitItem
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local TIME_OPEN_ANIMATION_BLANK = 1

local function __init(self, scene)
  base.__init(self, scene)
end

local function __delete(self)
  base.__delete(self)
end

function BountyHunterMonsterChestItem:Init()
  base.Init(self, "chest")
end

function BountyHunterMonsterChestItem:LoadItem(chestData, parent, birthWorldPos, curSceneGroundPosY, recycleFunc)
  self.prefabPath = chestData.prefabPath
  self.uuid = chestData.uuid
  self.rewardData = chestData.rewardData
  self.birthWorldPos = birthWorldPos
  self.curSceneGroundPosY = curSceneGroundPosY
  self.recycleFunc = recycleFunc
  self.monsterQuality = chestData.type
  self.monsterId = chestData.monsterId
  local rotation = Vector3.New(0, 0, 0)
  local scale = 1
  self:LoadModel(self.prefabPath, parent, birthWorldPos, rotation, scale, function()
    self:OnLoadedFinish()
  end)
end

function BountyHunterMonsterChestItem:OnLoadedFinish()
  if not self.transform then
    return
  end
  self.transform.gameObject:SetActive(true)
  self:PlayDropGroundAni()
end

function BountyHunterMonsterChestItem:PlayDropGroundAni()
  self:PlayAni("idle")
  self.transform.position = self.birthWorldPos
  local startWorldPos = Vector3(self.birthWorldPos.x, self.birthWorldPos.y, self.birthWorldPos.z)
  local randomEndPosX = startWorldPos.x + math.random(15, 50) / 10 * (math.random(0, 1) == 0 and 1 or -1)
  local randomEndPosZ = startWorldPos.z + math.random(15, 50) / 10 * (math.random(0, 1) == 0 and 1 or -1)
  local endWorldPos = Vector3(randomEndPosX, self.curSceneGroundPosY, randomEndPosZ)
  local endPosX = (startWorldPos.x + endWorldPos.x) / 2
  local endPosY = startWorldPos.y + math.random(30, 50) / 10
  local endPosZ = (startWorldPos.z + endWorldPos.z) / 2
  local controlPos = Vector3(endPosX, endPosY, endPosZ)
  local path = {
    startWorldPos,
    controlPos,
    endWorldPos
  }
  self.tween = self.transform:DOPath(path, 0.7, CS.DG.Tweening.PathType.CatmullRom):SetEase(CS.DG.Tweening.Ease.OutCubic)
  self.tween:OnComplete(function()
    self.tween = nil
    self:PlayDropAni()
  end)
  if self.preOpenEffReq then
    self.preOpenEffReq:Destroy()
    self.preOpenEffReq = nil
  end
  self.preOpenEffReq = self:GenOneEff(self:GetBoxPreOpenEffPath(self.monsterQuality), self.transform, nil)
end

function BountyHunterMonsterChestItem:PlayDropAni()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:PlayOpenBoxAni()
  end, TIME_OPEN_ANIMATION_BLANK)
  if self.bornEffReq then
    self.bornEffReq:Destroy()
    self.bornEffReq = nil
  end
  self.bornEffReq = self:GenOneEff(self:GetBoxBornEffPath(self.monsterQuality), self.transform, self.transform.position)
end

function BountyHunterMonsterChestItem:PlayOpenBoxAni()
  local ret, time = self:PlayAni("open")
  if not ret then
    time = 0.5
  end
  if self.preOpenEffReq then
    self.preOpenEffReq:Destroy()
    self.preOpenEffReq = nil
  end
  if self.openEffReq then
    self.openEffReq:Destroy()
    self.openEffReq = nil
  end
  self.openEffReq = self:GenOneEff(self:GetBoxOpenEffPath(self.monsterQuality), self.transform, self.transform.position)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:PlayDisappearAni(function()
      if self.recycleFunc then
        self.recycleFunc(self)
      end
    end)
  end, time)
  self:ShowFlyReward()
end

function BountyHunterMonsterChestItem:PlayDisappearAni(callback)
  local ret, time = self:PlayAni("dead")
  if not ret then
    time = 0.5
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    if callback then
      callback()
    end
    if self.openEffReq then
      self.openEffReq:Destroy()
      self.openEffReq = nil
    end
  end, time)
  if self.openEffReq then
    self.openEffReq:Destroy()
  end
  self.openEffReq = nil
end

function BountyHunterMonsterChestItem:ShowFlyReward()
  if not self.rewardData then
    return
  end
  local flyRewardParam = {}
  flyRewardParam.rewardData = self.rewardData
  flyRewardParam.startWorldPos = self.transform.position
  EventManager:GetInstance():Broadcast(EventId.BountyHunterPlayStashRewardAni, flyRewardParam)
end

function BountyHunterMonsterChestItem:Clear()
  self.uuid = nil
  self.rewardData = nil
  self.birthWorldPos = nil
end

function BountyHunterMonsterChestItem:Hide()
  if self.transform then
    self.transform.gameObject:SetActive(false)
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.flyRewardTimer then
    self.flyRewardTimer:Stop()
    self.flyRewardTimer = nil
  end
  if self.openEffReq then
    self.openEffReq:Destroy()
    self.openEffReq = nil
  end
  if self.bornEffReq then
    self.bornEffReq:Destroy()
    self.bornEffReq = nil
  end
end

function BountyHunterMonsterChestItem:GetBoxBornEffPath(monsterQuality)
  local ret = Const.BOX_BORN__EFF_CONFIG[monsterQuality]
  if not ret then
    return Const.BOX_BORN__EFF_CONFIG[BountyMonsterQualityType.NormalMonster]
  end
  return ret
end

function BountyHunterMonsterChestItem:GetBoxOpenEffPath(monsterQuality)
  local ret = Const.BOX_OPEN__EFF_CONFIG[monsterQuality]
  if not ret then
    return Const.BOX_OPEN__EFF_CONFIG[BountyMonsterQualityType.NormalMonster]
  end
  return ret
end

function BountyHunterMonsterChestItem:GetBoxPreOpenEffPath(monsterQuality)
  local ret = Const.BOX_PRE_OPEN__EFF_CONFIG[monsterQuality]
  return ret
end

function BountyHunterMonsterChestItem:Destroy()
  base.Destroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.flyRewardTimer then
    self.flyRewardTimer:Stop()
    self.flyRewardTimer = nil
  end
  if self.openEffReq then
    self.openEffReq:Destroy()
    self.openEffReq = nil
  end
  if self.bornEffReq then
    self.bornEffReq:Destroy()
    self.bornEffReq = nil
  end
  if self.preOpenEffReq then
    self.preOpenEffReq:Destroy()
    self.preOpenEffReq = nil
  end
end

BountyHunterMonsterChestItem.__init = __init
BountyHunterMonsterChestItem.__delete = __delete
return BountyHunterMonsterChestItem
