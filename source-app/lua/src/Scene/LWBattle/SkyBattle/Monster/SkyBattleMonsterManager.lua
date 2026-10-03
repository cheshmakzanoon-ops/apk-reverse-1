local SkyBattleAIMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.SkyBattleAIMonster")
local SkyBattleColliderAIMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.SkyBattleColliderAIMonster")
local TableMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TableMonster")
local DynamicTableMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.DynamicTableMonster")
local NumberDoorMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.NumberDoorMonster")
local StaticNumberDoorMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.StaticNumberDoorMonster")
local TriggerGate = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGate")
local TriggerGoods = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoods")
local TriggerGoodsAlwaysGet = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoodsAlwaysGet")
local TriggerGoodsCountdownGet = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoodsCountdownGet")
local GenMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.GenMonsterTask")
local GenSummonMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.GenSummonMonsterTask")
local GenSummonTriggerItemTask = require("Scene.LWBattle.ParkourBattle.TriggerEvent.GenSummonTriggerItemTask")
local RangeGenSummonTriggerItemTask = require("Scene.LWBattle.ParkourBattle.TriggerEvent.RangeGenSummonTriggerItemTask")
local RangeGenSummonMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.RangeGenSummonMonsterTask")
local GenSummonMonsterBatchTask = require("Scene.LWBattle.ParkourBattle.Monster.GenSummonMonsterBatchTask")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local Const = require("Scene.LWBattle.Const")
local SkyBattleMonsterManager = BaseClass("SkyBattleMonsterManager")
local ViewDisForward = 90
local CreateCountPerFrame = 10
local MonsterBornType = {
  SingleMonster = 1,
  BirthArea = 2,
  BirthPoint = 3,
  BuffTrigger = 4,
  ResTrigger = 5,
  MonsterDeath = 6
}
local BattleColliderUtils = CS.BattleColliderUtils

function SkyBattleMonsterManager:Init(logic)
  self.logic = logic
  self.allMonster = {}
  self.showList = {}
  self.waitCreate = {}
  local line = logic.data.meta
  self.parkourBattleType = Const.ParkourBattleType.Attack
  if logic.battleType then
    self.parkourBattleType = logic.battleType
  end
  self.farmMonster = {}
  self.triggerEvent = {}
  self.deathEvent = {}
  self.tasks = {}
  self.taskGuid = 1
  local monsterArr = string.split(line:getValue("farm_monster") or "", "|")
  for _, monsterId in ipairs(monsterArr) do
    local monster = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_SkyBattle_MonsterBorn), monsterId)
    if monster == nil then
      Logger.LogError("LW_SkyBattle_MonsterBorn \230\178\161\230\156\137id:" .. monsterId)
    elseif monster.type == MonsterBornType.SingleMonster or monster.type == MonsterBornType.BuffTrigger or monster.type == MonsterBornType.ResTrigger then
      if monster.y == nil then
        local spl = string.split(monster.coord, ",")
        monster.x = tonumber(spl[1])
        monster.y = tonumber(spl[2])
      end
      table.insert(self.farmMonster, monster)
    elseif monster.type == MonsterBornType.BirthPoint then
      local minZtoBorn = self.logic.safeTeamZMoveDelta * 1.5
      local cordStr = string.split(monster.coord, ",")
      local bornZ = tonumber(cordStr[2]) or 0
      local spl = string.split(monster.para, "|")
      local cfgLineZ = tonumber(spl[1])
      local triggerLineZ = math.max(cfgLineZ, bornZ - minZtoBorn)
      local trigger = {line = triggerLineZ, param = monster}
      table.insert(self.triggerEvent, trigger)
    elseif monster.type == MonsterBornType.MonsterDeath then
      local spl = string.split(monster.para, ";")
      local triggers = {}
      for _, v in ipairs(spl) do
        local spl2 = string.split(v, ",")
        if #spl2 == 2 then
          triggers[spl2[1]] = tonumber(spl2[2])
        end
      end
      if monster.y == nil then
        local splCoord = string.split(monster.coord, ",")
        monster.x = tonumber(splCoord[1])
        monster.y = tonumber(splCoord[2])
      end
      local event = {triggers = triggers, param = monster}
      table.insert(self.deathEvent, event)
    end
  end
  self.bossMonster = {}
  monsterArr = string.split(line:getValue("battle_monster") or "", "|")
  for _, monsterId in ipairs(monsterArr) do
    if not string.IsNullOrEmpty(monsterId) then
      local monster = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_SkyBattle_MonsterBorn), monsterId)
      table.insert(self.bossMonster, monster)
    end
  end
  self.randomDeadAnimPool = StringPool.New("dead;dead1;dead2", ";")
  self.colliderMap = {}
  self.colliderResultList = nil
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
end

function SkyBattleMonsterManager:Update(viewY, screenY, deltaTime)
  if self.logic == nil or self.waitCreate == nil then
    return
  end
  self.createForwardDis = self.logic.safeTeamZMoveDelta * 1.5
  self.viewDisBack = self.logic.safeTeamZMoveDelta * 4
  self.viewY = viewY
  self.screenY = screenY
  self.realCreateYOffset = screenY - viewY
  self:UpdateFixPointMonster(self.screenY, viewY)
  self:UpdateTrigger(viewY)
  self:UpdateTask(deltaTime)
  self:UpdateAllMonster(deltaTime)
end

function SkyBattleMonsterManager:UpdateFixPointMonster(screenCenterY, viewY)
  ProfilerUtil.BeginSample("UpdateFixPointMonster")
  for k, monster in pairs(self.farmMonster) do
    if monster.y - viewY < self.createForwardDis then
      table.insert(self.waitCreate, monster)
      self.farmMonster[k] = nil
    end
  end
  for k, monster in pairs(self.showList) do
    if screenCenterY - monster.y > self.viewDisBack then
      self:RemoveMonster(monster.guid)
    end
  end
  for k, monster in pairs(self.waitCreate) do
    if screenCenterY - monster.y > self.viewDisBack then
      self.waitCreate[k] = nil
    end
  end
  local count = 0
  for k, meta in pairs(self.waitCreate) do
    self.waitCreate[k] = nil
    local m = self:CreateFarmMonster(meta)
    if m then
      m:Load()
      self.showList[m.guid] = m
      count = count + 1
    end
    if count > CreateCountPerFrame then
      break
    end
  end
  ProfilerUtil.EndSample()
end

function SkyBattleMonsterManager:UpdateTrigger(viewY)
  ProfilerUtil.BeginSample("UpdateTrigger")
  for k, trigger in pairs(self.triggerEvent) do
    if viewY >= trigger.line then
      if trigger.param.type == MonsterBornType.BirthPoint then
        local task = GenMonsterTask.New(self, trigger.param)
        self:AddTask(task)
      end
      self.triggerEvent[k] = nil
    end
  end
  ProfilerUtil.EndSample()
end

function SkyBattleMonsterManager:UpdateTask(deltaTime)
  ProfilerUtil.BeginSample("UpdateTask")
  for k, task in pairs(self.tasks) do
    if task.Update then
      task:Update(deltaTime)
    end
  end
  ProfilerUtil.EndSample()
end

function SkyBattleMonsterManager:UpdateAllMonster(deltaTime)
  ProfilerUtil.BeginSample("MonsterColliderUpdate")
  local resultList = PvePhysicsUtil.MonsterCollider()
  self.colliderResultList = resultList
  self.colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local cacheId = 0
    local countPos = false
    local indexPos = 0
    if 0 < length and 0 < resultList[1] then
      table.clear(self.colliderMap)
      self.colliderResultCount = length
      idPos = true
      for i = 1, length do
        local data = resultList[i]
        if data < 0 then
          break
        end
        if idPos then
          cacheId = data
          idPos = false
          countPos = true
          indexPos = 0
        elseif countPos then
          idPos = false
          countPos = false
          indexPos = data
          self.colliderMap[cacheId] = i
        elseif 0 < indexPos then
          indexPos = indexPos - 1
          if indexPos == 0 then
            idPos = true
            countPos = false
            indexPos = 0
          end
        end
      end
    end
  end
  if self.colliderResultCount > 0 then
    for objId, countIndex in pairs(self.colliderMap) do
      local monster = self.allMonster[objId]
      if monster and 0 < countIndex then
        local count = self.colliderResultList[countIndex]
        if 0 < count then
          monster:OnCollisionViewHandle(count, countIndex, self.colliderResultList)
        end
      end
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("MonsterUpdate")
  for k, monster in pairs(self.allMonster) do
    if monster then
      monster:OnUpdate(deltaTime)
    end
  end
  ProfilerUtil.EndSample()
end

function SkyBattleMonsterManager:HideAllMonsterHpBar()
  for k, monster in pairs(self.allMonster) do
    if monster then
      monster:HideHpBar()
    end
  end
end

function SkyBattleMonsterManager:CreateFarmMonster(bornMeta)
  local monsterArr = {}
  local monster
  if bornMeta.type == MonsterBornType.SingleMonster or bornMeta.type == MonsterBornType.MonsterDeath then
    local spl = string.split(bornMeta.monster, ",")
    for k, v in pairs(spl) do
      local innerSpl = string.split(v, "|")
      local randomParam = {
        id = tonumber(innerSpl[1]),
        p = tonumber(innerSpl[2])
      }
      table.insert(monsterArr, randomParam)
    end
    local r = math.random(0, 10000)
    local mId = 0
    for _, v in ipairs(monsterArr) do
      mId = v.id
      if r > v.p then
        break
      end
    end
    if 0 < mId then
      monster = self:CreateMonster(bornMeta.x, bornMeta.y, mId, bornMeta.view_Param, bornMeta.move_Param)
    end
  elseif bornMeta.type == MonsterBornType.BuffTrigger then
    if bornMeta.buff_item ~= "" then
      monster = self:CreateTriggerGate(bornMeta.x, bornMeta.y, bornMeta.buff_item)
    end
  elseif bornMeta.type == MonsterBornType.ResTrigger and bornMeta.buff_item ~= "" then
    monster = self:CreateTriggerGoods(bornMeta.x, bornMeta.y, bornMeta.buff_item)
  end
  return monster
end

local NumberDoorRed = "Assets/Main/Prefabs/Skybattle/Prop/O_env_beizengmen_hong.prefab"
local NumberDoorRedX3 = "Assets/Main/Prefabs/Skybattle/Prop/O_env_beizengmen_hong_x3.prefab"
local NumberDoorBlue = "Assets/Main/Prefabs/Skybattle/Prop/O_env_beizengmen_lan.prefab"
local NumberDoorBlueX3 = "Assets/Main/Prefabs/Skybattle/Prop/O_env_beizengmen_lan_x3.prefab"

function SkyBattleMonsterManager:CreateMonster(x, y, metaId, viewParam, moveParam)
  local meta = DataCenter.PveMonsterTemplateManager:GetSkyBattleTemplate(metaId)
  if not meta then
    return
  end
  local monster
  if meta.monster_type == Const.MonsterType.Table then
    monster = ObjectPool:GetInstance():Load(TableMonster)
  elseif meta.monster_type == Const.MonsterType.DynamicTable then
    monster = ObjectPool:GetInstance():Load(DynamicTableMonster)
  elseif meta.monster_type == Const.MonsterType.NumberDoor then
    monster = ObjectPool:GetInstance():Load(NumberDoorMonster)
    monster:SetCustomRedDoorPath(NumberDoorRed)
    monster:SetCustomBlueDoorPath(NumberDoorBlue)
    monster:SetCustomRedDoorX3Path(NumberDoorRedX3)
    monster:SetCustomBlueDoorX3Path(NumberDoorBlueX3)
  elseif meta.monster_type == Const.MonsterType.StaticNumberDoor then
    monster = ObjectPool:GetInstance():Load(StaticNumberDoorMonster)
  elseif meta.monster_type == Const.MonsterType.SkyBattleNormal then
    monster = ObjectPool:GetInstance():Load(SkyBattleAIMonster)
    monster:SetViewParam(viewParam)
    monster:SetMoveParam(moveParam)
  elseif meta.monster_type == Const.MonsterType.SkyBattleCollider then
    monster = ObjectPool:GetInstance():Load(SkyBattleColliderAIMonster)
    monster:SetViewParam(viewParam)
    monster:SetMoveParam(moveParam)
  end
  if monster then
    monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, self:GetRealBornZ(y), meta)
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function SkyBattleMonsterManager:GetRealBornZ(cfgZ)
  return cfgZ + self.realCreateYOffset
end

function SkyBattleMonsterManager:CreateTriggerGate(x, y, buff_item)
  local fakemeta = {hp = 0, death_trigger_item = buff_item}
  local monster = ObjectPool:GetInstance():Load(TriggerGate)
  monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, self:GetRealBornZ(y), fakemeta)
  if monster then
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function SkyBattleMonsterManager:CreateTriggerGoods(x, y, buff_item)
  local fakeMeta = {hp = 0, death_trigger_item = buff_item}
  local spl = string.split(fakeMeta.death_trigger_item or "", ",")
  local deathEvent = {}
  for _, pair in ipairs(spl) do
    local _spl = string.split(pair, "|")
    if #_spl == 2 then
      table.insert(deathEvent, {
        tonumber(_spl[1]),
        tonumber(_spl[2])
      })
    end
  end
  if not deathEvent or #deathEvent < 1 then
    return
  end
  local cnt = 0
  local triggerItemId
  for _, event in ipairs(deathEvent) do
    cnt = cnt + event[2]
  end
  cnt = math.random(0, cnt)
  for _, event in ipairs(deathEvent) do
    cnt = cnt - event[2]
    if cnt <= 0 then
      triggerItemId = event[1]
      break
    end
  end
  if not triggerItemId then
    return
  end
  local triggerMeta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(triggerItemId)
  if not triggerMeta then
    return
  end
  local monster
  if triggerMeta.type == TriggerEnum.EventType.CountdownGetGoods then
    monster = ObjectPool:GetInstance():Load(TriggerGoodsCountdownGet)
  elseif triggerMeta.type == TriggerEnum.EventType.AlwaysGetGoods then
    monster = ObjectPool:GetInstance():Load(TriggerGoodsAlwaysGet)
  else
    monster = ObjectPool:GetInstance():Load(TriggerGoods)
  end
  monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, self:GetRealBornZ(y), fakeMeta, triggerMeta)
  if monster then
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function SkyBattleMonsterManager:Summon(pos, metaId, count, hp, ownerMeta)
  local task = GenSummonMonsterTask.New(self, pos, metaId, count, hp, ownerMeta)
  self:AddTask(task)
end

function SkyBattleMonsterManager:RangeSummon(pos, r1, r2, metaId, count, hp, ownerMeta)
  local task = RangeGenSummonMonsterTask.New(self, pos, r1, r2, metaId, count, hp, ownerMeta)
  self:AddTask(task)
end

function SkyBattleMonsterManager:SummonBatch(startPos, metaId, count, posOffset, hp, ownerMeta)
  local task = GenSummonMonsterBatchTask.New(self, startPos, metaId, count, posOffset, hp, ownerMeta)
  self:AddTask(task)
end

function SkyBattleMonsterManager:SummonTriggerItem(pos, metaId, count, ownerMeta, castType)
  local task = GenSummonTriggerItemTask.New(self, pos, metaId, count, ownerMeta, castType)
  self:AddTask(task)
end

function SkyBattleMonsterManager:RangeSummonTriggerItem(pos, r1, r2, metaId, count, ownerMeta, castType)
  local task = RangeGenSummonTriggerItemTask.New(self, pos, r1, r2, metaId, count, ownerMeta, castType)
  self:AddTask(task)
end

function SkyBattleMonsterManager:AddShowList(monster)
  if monster and monster.guid then
    self.showList[monster.guid] = monster
  end
end

function SkyBattleMonsterManager:GetMonster(guid)
  return self.showList[guid]
end

function SkyBattleMonsterManager:GetMonsters()
  return self.showList
end

function SkyBattleMonsterManager:RemoveMonster(guid)
  if self.showList == nil then
    return
  end
  if self.showList[guid] then
    self.showList[guid] = nil
  end
  if self.allMonster[guid] then
    self.allMonster[guid] = nil
  end
  self.logic:RemoveUnit(guid)
end

function SkyBattleMonsterManager:AddTask(task)
  self.taskGuid = self.taskGuid + 1
  task.id = self.taskGuid
  self.tasks[self.taskGuid] = task
end

function SkyBattleMonsterManager:RemoveTask(task)
  if self.tasks == nil or self.tasks[task.id] == nil then
    return
  end
  task:Delete()
  self.tasks[task.id] = nil
end

function SkyBattleMonsterManager:Destroy()
  self.allMonster = nil
  self.showList = nil
  self.waitCreate = nil
  BattleColliderUtils.ClearMonsterColliderData()
  if self.tasks then
    for k, task in pairs(self.tasks) do
      if task then
        task:Delete()
      end
    end
    self.tasks = nil
  end
end

function SkyBattleMonsterManager:GetRandomDeadAnim()
  return self.randomDeadAnimPool:GetRandom()
end

function SkyBattleMonsterManager:OnMonsterDeath(guid)
  local monster = self:GetMonster(guid)
  if monster then
    local id = tostring(monster.monsterMeta.id)
    if self.deathEvent then
      for i, event in pairs(self.deathEvent) do
        if event.triggers[id] then
          event.triggers[id] = event.triggers[id] - 1
          local isTrigger = true
          for monsterId, count in pairs(event.triggers) do
            if 0 < count then
              isTrigger = false
              break
            end
          end
          if isTrigger then
            local task = GenMonsterTask.New(self, self.deathEvent[i].param)
            self:AddTask(task)
            self.deathEvent[i] = nil
          end
        end
      end
    end
  end
end

function SkyBattleMonsterManager:ClearMonsterByView()
  local viewY = self.viewY
  if viewY == nil then
    return
  end
  local offsetY = self.defenseOffsetY or 0
  for k, monster in pairs(self.farmMonster) do
    if 0 > monster.y + offsetY - viewY then
      self.farmMonster[k] = nil
    end
  end
  for k, monster in pairs(self.showList) do
    if 0 < viewY - monster.y and monster and monster.Death then
      monster:Death()
    end
  end
  for k, monster in pairs(self.waitCreate) do
    if 0 < viewY - monster.y then
      self.waitCreate[k] = nil
    end
  end
end

function SkyBattleMonsterManager:SetGamePause(pause)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if nil == self.allMonster then
      return
    end
    for k, monster in pairs(self.allMonster) do
      if monster then
        monster:PauseUpdateReversePos(pause)
      end
    end
  end
end

return SkyBattleMonsterManager
