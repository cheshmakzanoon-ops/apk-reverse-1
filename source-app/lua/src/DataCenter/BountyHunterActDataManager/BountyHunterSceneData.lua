local BountyHunterSceneData = BaseClass("BountyHunterSceneData")
local Localization = CS.GameEntry.Localization
local BountyHunterMonsterData = require("DataCenter.BountyHunterActDataManager.BountyHunterMonsterData")
local BountyHunterFreeChestData = require("DataCenter.BountyHunterActDataManager.BountyHunterFreeChestData")

local function __init(self)
  self.curStageId = -1
  self.stageTmpData = nil
  self.allMonsterDataDic = {}
  self.allChestDataDic = {}
  self.allMonsterDataDic = {}
end

local function __delete(self)
  self.curStageId = nil
  self.stageTmpData = nil
  self.allMonsterDataDic = nil
  self.allChestDataDic = nil
end

function BountyHunterSceneData:Init(activityId)
  self.activityId = activityId
end

function BountyHunterSceneData:UpdateStageData(stageInfo, isClearMonsterData)
  local stageId = stageInfo.stageId
  local monsterServerData = stageInfo.monsterArray
  local freeChestServerData = stageInfo.chestArray
  if stageId then
    local oldStageId = self.stageId
    self.stageId = toInt(stageId)
    if oldStageId and oldStageId ~= stageId then
      self.ShowHunterLog("stage id change : " .. self.stageId)
    end
  else
    self.ShowHunterLog("stageId is null!")
    return
  end
  if isClearMonsterData then
    self.allMonsterDataDic = {}
  end
  self.stageTmpData = LocalController:instance():getLine(TableName.Bounty_Hunter_Stage, self.stageId)
  self:ParseMonsterDataInScene(monsterServerData)
  self:ParseChestData(freeChestServerData)
end

function BountyHunterSceneData:ParseMonsterDataInScene(monsterServerData)
  if not monsterServerData or #monsterServerData <= 0 then
    return
  end
  for _, v in ipairs(monsterServerData) do
    self:UpdateOneMonsterData(v)
  end
end

function BountyHunterSceneData:ParseChestData(chestDataList)
  if not chestDataList then
    return
  end
  for _, v in ipairs(chestDataList) do
    self:UpdateChestData(v)
  end
end

function BountyHunterSceneData:UpdateChestData(chestData)
  if not chestData then
    return
  end
  local uuid = chestData.uuid
  local chestItemData = self.allChestDataDic[uuid]
  chestItemData = chestItemData or BountyHunterFreeChestData.New()
  chestItemData:UpdateData(chestData)
  self.allChestDataDic[uuid] = chestItemData
end

function BountyHunterSceneData:ReceiveFreeChestFromScene(uuid, rewardData)
  if not self.allChestDataDic or not self.allChestDataDic[uuid] then
    return
  end
  self.allChestDataDic[uuid] = nil
  local params = {}
  params.actionType = BountyHunterAniActionType.ReceiveFreeChest
  params.triggerType = BountyHunterActionTriggerType.Immediate
  params.data = {}
  params.data.uuid = uuid
  params.data.rewardData = rewardData
  EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
end

function BountyHunterSceneData:ClearAllChestData()
  local list = {}
  for k, v in pairs(self.allChestDataDic) do
    table.insert(list, k)
  end
  for _, v in pairs(list) do
    self.allChestDataDic[v] = nil
  end
end

function BountyHunterSceneData:UpdateMonsterDataWhenTakeDamage(msg, damageSource)
  local targetUuid = msg.uuid
  local targetData = self.allMonsterDataDic[targetUuid]
  if not targetData then
    self.ShowHunterLog("not find monster data. uuid: " .. targetUuid)
    return
  end
  local oldHp = targetData.curHp
  local newHp = toInt(msg.hp)
  local hpChange = newHp - oldHp
  targetData:UpdateHp(newHp)
  if newHp <= 0 and self.allMonsterDataDic[targetUuid] ~= nil then
    self.allMonsterDataDic[targetUuid] = nil
    self.ShowHunterLog("remove monster data from allMonsterDataDic. uid: " .. targetUuid)
  end
  local aniMonsterData = {}
  aniMonsterData.uuid = targetUuid
  aniMonsterData.maxHp = targetData.maxHp
  aniMonsterData.newHp = newHp
  aniMonsterData.hpChange = hpChange
  aniMonsterData.damageSource = damageSource
  aniMonsterData.monsterId = targetData.monsterId
  return aniMonsterData
end

function BountyHunterSceneData:UpdateMonsterDataAfterNormalHit(monsterChange, dropReward, attackReward)
  if not monsterChange then
    return
  end
  local aniData = self:UpdateMonsterDataWhenTakeDamage(monsterChange, BountyMonsterDamageSource.HunterBullet)
  aniData.dropReward = dropReward
  aniData.attackReward = attackReward
  local params = {}
  params.actionType = BountyHunterAniActionType.HunterAttack
  params.triggerType = BountyHunterActionTriggerType.Immediate
  params.data = aniData
  EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
end

function BountyHunterSceneData:UpdateMonsterDataAfterFullScreenAttack(data)
  if not data then
    return
  end
  local damageAniDataList = {}
  for _, v in ipairs(data) do
    local aniData = self:UpdateMonsterDataWhenTakeDamage(v.monsterChange, BountyMonsterDamageSource.HunterBullet)
    aniData.dropReward = v.dropReward
    table.insert(damageAniDataList, aniData)
  end
  if #damageAniDataList <= 0 then
    self.ShowHunterLog("full atk num is 0!")
    return
  end
  local params = {}
  params.actionType = BountyHunterAniActionType.FullScreenAttack
  params.triggerType = BountyHunterActionTriggerType.PushQueue
  params.data = damageAniDataList
  EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
end

function BountyHunterSceneData:UpdateMonsterDataWhenTriggerEvent(data)
  if not data then
    return
  end
  if data.bossEvent then
    local bossMonsterData = self:UpdateOneMonsterData(data.bossEvent)
    local params = {}
    params.actionType = BountyHunterAniActionType.BossBirth
    params.triggerType = BountyHunterActionTriggerType.PushQueue
    params.data = bossMonsterData
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end
  if data.supportEvent then
    local supportData = data.supportEvent
    local damageAniDataList = {}
    for _, v in ipairs(supportData) do
      local monsterChange = v.monsterChange
      local aniData = self:UpdateMonsterDataWhenTakeDamage(monsterChange, BountyMonsterDamageSource.HunterBullet)
      aniData.dropReward = v.monsterReward
      table.insert(damageAniDataList, aniData)
    end
    if #damageAniDataList <= 0 then
      self.ShowHunterLog("random bomb num is 0!")
      return
    end
    local params = {}
    params.actionType = BountyHunterAniActionType.RandomBomb
    params.triggerType = BountyHunterActionTriggerType.PushQueue
    params.data = damageAniDataList
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end
  if data.chestEvent then
    local chestData = data.chestEvent
    self:UpdateChestData(chestData)
    local params = {}
    params.actionType = BountyHunterAniActionType.GetFreeChest
    params.triggerType = BountyHunterActionTriggerType.PushQueue
    params.data = nil
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end
  if data.shopEvent then
    local shopData = data.shopEvent
    local params = {}
    params.actionType = BountyHunterAniActionType.ShopEvent
    params.triggerType = BountyHunterActionTriggerType.PushQueue
    params.unique = true
    params.data = shopData
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end
end

function BountyHunterSceneData:UpdateOneMonsterData(data)
  local uuid = data.uuid
  local targetData = self.allMonsterDataDic[uuid]
  if not targetData then
    targetData = BountyHunterMonsterData.New()
    self.allMonsterDataDic[uuid] = targetData
    self:ShowHunterLog(string.format("add one new  monster data. uuid: %s  hp: %s", uuid, data.hp))
  end
  targetData:UpdateData(data)
  return targetData
end

function BountyHunterSceneData:GetMonsterDataByUuid(uuid)
  if not self.allMonsterDataDic then
    return nil
  end
  return self.allMonsterDataDic[uuid]
end

function BountyHunterSceneData:ShowHunterLog(info)
end

BountyHunterSceneData.__init = __init
BountyHunterSceneData.__delete = __delete
return BountyHunterSceneData
