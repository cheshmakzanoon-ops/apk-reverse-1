local ColliderMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonster")
local CommonAIMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster")
local TableMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TableMonster")
local DynamicTableMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.DynamicTableMonster")
local NumberDoorMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.NumberDoorMonster")
local StaticNumberDoorMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.StaticNumberDoorMonster")
local TyreMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TyreMonster")
local TriggerGate = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGate")
local TriggerGoods = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoods")
local TriggerGoodsAlwaysGet = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoodsAlwaysGet")
local TriggerGoodsCountdownGet = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoodsCountdownGet")
local CarMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CarMonster")
local BusMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.BusMonster")
local WanderMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.WanderMonster")
local AisillaBoss = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.AisillaBoss")
local BonusDashMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.BonusDashMonster")
local WaterBottleMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.WaterBottleMonster")
local ColliderWithSkillMonster = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderWithSkillMonster")
local GenMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.GenMonsterTask")
local GenDefenseMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.GenDefenseMonsterTask")
local GenSummonMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.GenSummonMonsterTask")
local GenSummonTriggerItemTask = require("Scene.LWBattle.ParkourBattle.TriggerEvent.GenSummonTriggerItemTask")
local RangeGenSummonTriggerItemTask = require("Scene.LWBattle.ParkourBattle.TriggerEvent.RangeGenSummonTriggerItemTask")
local RangeGenSummonMonsterTask = require("Scene.LWBattle.ParkourBattle.Monster.RangeGenSummonMonsterTask")
local GenSummonMonsterBatchTask = require("Scene.LWBattle.ParkourBattle.Monster.GenSummonMonsterBatchTask")
local GenAirdropTask = require("Scene.LWBattle.ParkourBattle.Monster.GenAirdropTask")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local Const = require("Scene.LWBattle.Const")
local MonsterManager = BaseClass("MonsterManager")
local ViewDisForward = 90
local ViewDisBack = 30
local CreateCountPerFrame = 10
local MonsterBornType = {
  SingleMonster = 1,
  BirthArea = 2,
  BirthPoint = 3,
  BuffTrigger = 4,
  ResTrigger = 5,
  MonsterDeath = 6,
  Bonus = 7,
  BossAirdrop = 8,
  Bonus_Delay = 9
}
local BattleColliderUtils = CS.BattleColliderUtils

function MonsterManager:Init(logic)
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
  self.bonusEvent = {}
  self.airdropEvent = {}
  self.cacheBossLineMonster = {}
  self.tasks = {}
  self.taskGuid = 1
  local monsterArr = string.split(line:getValue("farm_monster") or "", "|")
  for _, monsterId in ipairs(monsterArr) do
    local monster = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Monster_Born), monsterId)
    if monster == nil then
      Logger.LogError("lw_monster_born \230\178\161\230\156\137id:" .. monsterId)
    elseif monster.type == MonsterBornType.SingleMonster or monster.type == MonsterBornType.BuffTrigger or monster.type == MonsterBornType.ResTrigger then
      if monster.y == nil then
        local spl = string.split(monster.coord, ",")
        monster.x = tonumber(spl[1])
        monster.y = tonumber(spl[2])
      end
      table.insert(self.farmMonster, monster)
    elseif monster.type == MonsterBornType.BirthArea or monster.type == MonsterBornType.BirthPoint then
      local spl = string.split(monster.para, "|")
      local trigger = {
        line = tonumber(spl[1]),
        param = monster
      }
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
    elseif monster.type == MonsterBornType.Bonus then
      if monster.y == nil then
        local spl = string.split(monster.coord, ",")
        monster.x = tonumber(spl[1])
        monster.y = tonumber(spl[2])
      end
      table.insert(self.bonusEvent, {param = monster})
    elseif monster.type == MonsterBornType.Bonus_Delay then
      if monster.y == nil then
        local spl = string.split(monster.coord, ",")
        monster.x = tonumber(spl[1])
        monster.y = tonumber(spl[2])
        local delayTimeMS = tonumber(monster.para) or 0
        monster.delayGenTime = delayTimeMS / 1000
      end
      table.insert(self.bonusEvent, {param = monster})
    elseif monster.type == MonsterBornType.BossAirdrop and monster.y == nil then
      local spl = string.split(monster.coord, ",")
      monster.x = tonumber(spl[1])
      monster.y = tonumber(spl[2])
      local spl = string.split(monster.para, "|")
      monster.time = tonumber(spl[1])
      monster.offset = tonumber(spl[2])
      table.insert(self.airdropEvent, monster)
    end
  end
  self.bossMonster = {}
  monsterArr = string.split(line:getValue("battle_monster") or "", "|")
  for _, monsterId in ipairs(monsterArr) do
    if not string.IsNullOrEmpty(monsterId) then
      local monster = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Monster_Born), monsterId)
      table.insert(self.bossMonster, monster)
    end
  end
  self.randomDeadAnimPool = StringPool.New("dead;dead1;dead2", ";")
  self.colliderMap = {}
  self.colliderResultList = nil
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
end

function MonsterManager:Update(viewY, deltaTime)
  if self.logic == nil or self.waitCreate == nil then
    return
  end
  self.viewY = viewY
  self:UpdateFixPointMonster(viewY)
  self:UpdateTrigger(viewY)
  self:UpdateAirdropEvent(deltaTime)
  self:UpdateTask(deltaTime)
  self:UpdateAllMonster(deltaTime)
end

function MonsterManager:UpdateFixPointMonster(viewY)
  for k, monster in pairs(self.farmMonster) do
    if monster.y - viewY < ViewDisForward then
      table.insert(self.waitCreate, monster)
      self.farmMonster[k] = nil
    end
  end
  for k, monster in pairs(self.showList) do
    if viewY - monster.y > ViewDisBack then
      self:RemoveMonster(monster.guid)
    end
  end
  for k, monster in pairs(self.waitCreate) do
    if viewY - monster.y > ViewDisBack then
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
end

function MonsterManager:UpdateTrigger(viewY)
  for k, trigger in pairs(self.triggerEvent) do
    if viewY >= trigger.line then
      if trigger.param.type == MonsterBornType.BirthArea or trigger.param.type == MonsterBornType.BirthPoint then
        local task = GenMonsterTask.New(self, trigger.param)
        self:AddTask(task)
      end
      self.triggerEvent[k] = nil
    end
  end
end

function MonsterManager:UpdateTask(deltaTime)
  for k, task in pairs(self.tasks) do
    if task.Update then
      task:Update(deltaTime)
    end
  end
end

function MonsterManager:UpdateAllMonster(deltaTime)
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
  for k, monster in pairs(self.allMonster) do
    if monster then
      monster:OnUpdate(deltaTime)
    end
  end
end

function MonsterManager:HideAllMonsterHpBar()
  for k, monster in pairs(self.allMonster) do
    if monster then
      monster:HideHpBar()
    end
  end
end

function MonsterManager:UpdateDefense(teamPosY, offsetY, deltaTime)
  if self.logic == nil or self.waitCreate == nil then
    return
  end
  self.viewY = teamPosY
  self.defenseOffsetY = offsetY
  self:UpdateDefenseFixPointMonster(teamPosY, offsetY)
  self:UpdateDefenseTrigger(teamPosY, offsetY)
  self:UpdateAirdropEvent(deltaTime)
  self:UpdateTask(deltaTime)
  self:UpdateAllMonster(deltaTime)
end

function MonsterManager:UpdateDefenseFixPointMonster(teamPosY, offsetY)
  for k, monster in pairs(self.farmMonster) do
    if monster.y + offsetY - teamPosY < ViewDisForward then
      monster.offsetY = offsetY
      table.insert(self.waitCreate, monster)
      self.farmMonster[k] = nil
    end
  end
  for k, monster in pairs(self.showList) do
    if teamPosY - monster.y > ViewDisBack then
      self:RemoveMonster(monster.guid)
    end
  end
  for k, monster in pairs(self.waitCreate) do
    if teamPosY - monster.y > ViewDisBack then
      self.waitCreate[k] = nil
    end
  end
  local count = 0
  for k, meta in pairs(self.waitCreate) do
    self.waitCreate[k] = nil
    local m = self:CreateFarmMonster(meta)
    if m then
      m:ModifyPosY(meta.y + meta.offsetY)
      m:Load()
      self.showList[m.guid] = m
      count = count + 1
    end
    if count > CreateCountPerFrame then
      break
    end
  end
end

function MonsterManager:UpdateDefenseTrigger(teamPosY, offsetY)
  for k, trigger in pairs(self.triggerEvent) do
    if teamPosY >= trigger.line + offsetY then
      if trigger.param.type == MonsterBornType.BirthArea or trigger.param.type == MonsterBornType.BirthPoint then
        local task = GenDefenseMonsterTask.New(self, trigger.param)
        self:AddTask(task)
      end
      self.triggerEvent[k] = nil
    end
  end
end

function MonsterManager:CreateFarmMonster(bornMeta)
  local monsterArr = {}
  local monster
  if bornMeta.type == MonsterBornType.SingleMonster or bornMeta.type == MonsterBornType.MonsterDeath or bornMeta.type == MonsterBornType.Bonus then
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
      monster = self:CreateMonster(bornMeta.x, bornMeta.y, mId)
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

function MonsterManager:CreateMonster(x, y, metaId)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(metaId)
  if not meta then
    return
  end
  local monster
  if meta.monster_type == Const.MonsterType.Junk then
    monster = ObjectPool:GetInstance():Load(ColliderMonster)
  elseif meta.monster_type == Const.MonsterType.Table then
    monster = ObjectPool:GetInstance():Load(TableMonster)
  elseif meta.monster_type == Const.MonsterType.Car then
    monster = ObjectPool:GetInstance():Load(CarMonster)
  elseif meta.monster_type == Const.MonsterType.Normal or meta.monster_type == Const.MonsterType.Boss or meta.monster_type == Const.MonsterType.Elite then
    monster = ObjectPool:GetInstance():Load(CommonAIMonster)
  elseif meta.monster_type == Const.MonsterType.DynamicTable then
    monster = ObjectPool:GetInstance():Load(DynamicTableMonster)
  elseif meta.monster_type == Const.MonsterType.NumberDoor then
    monster = ObjectPool:GetInstance():Load(NumberDoorMonster)
  elseif meta.monster_type == Const.MonsterType.Tyre then
    monster = ObjectPool:GetInstance():Load(TyreMonster)
  elseif meta.monster_type == Const.MonsterType.Bus then
    monster = ObjectPool:GetInstance():Load(BusMonster)
  elseif meta.monster_type == Const.MonsterType.Wander then
    monster = ObjectPool:GetInstance():Load(WanderMonster)
  elseif meta.monster_type == Const.MonsterType.AisillaBoss then
    monster = ObjectPool:GetInstance():Load(AisillaBoss)
    if self.enterAirdropTime == nil then
      table.insert(self.cacheBossLineMonster, {
        monster = monster,
        x = x,
        y = y,
        metaId = metaId
      })
      return nil
    end
  elseif meta.monster_type == Const.MonsterType.BonusDash then
    monster = ObjectPool:GetInstance():Load(BonusDashMonster)
  elseif meta.monster_type == Const.MonsterType.StaticNumberDoor then
    monster = ObjectPool:GetInstance():Load(StaticNumberDoorMonster)
  elseif meta.monster_type == Const.MonsterType.HorizontalWaterBottle or meta.monster_type == Const.MonsterType.StandingWaterBottle then
    monster = ObjectPool:GetInstance():Load(WaterBottleMonster)
  elseif meta.monster_type == Const.MonsterType.JunkWithSkill then
    monster = ObjectPool:GetInstance():Load(ColliderWithSkillMonster)
  end
  if monster then
    monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, y, meta)
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
    if monster.monsterMeta.is_boss == 1 or monster.monsterMeta.monster_type == Const.MonsterType.Boss then
      self.logic:OnBossEnterBattle(monster)
    end
  end
  return monster
end

function MonsterManager:CreateTriggerGate(x, y, buff_item)
  local fakemeta = {hp = 0, death_trigger_item = buff_item}
  local monster = ObjectPool:GetInstance():Load(TriggerGate)
  monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, y, fakemeta)
  if monster then
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function MonsterManager:CreateTriggerGoods(x, y, buff_item)
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
  monster:Init(self.logic, self, self.logic:AllotUnitGuid(), x, y, fakeMeta, triggerMeta)
  if monster then
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function MonsterManager:Summon(pos, metaId, count, hp, ownerMeta)
  local task = GenSummonMonsterTask.New(self, pos, metaId, count, hp, ownerMeta)
  self:AddTask(task)
end

function MonsterManager:RangeSummon(pos, r1, r2, metaId, count, hp, ownerMeta)
  local task = RangeGenSummonMonsterTask.New(self, pos, r1, r2, metaId, count, hp, ownerMeta)
  self:AddTask(task)
end

function MonsterManager:SummonBatch(startPos, metaId, count, posOffset, hp, ownerMeta)
  local task = GenSummonMonsterBatchTask.New(self, startPos, metaId, count, posOffset, hp, ownerMeta)
  self:AddTask(task)
end

function MonsterManager:SummonTriggerItem(pos, metaId, count, ownerMeta, castType)
  local task = GenSummonTriggerItemTask.New(self, pos, metaId, count, ownerMeta, castType)
  self:AddTask(task)
end

function MonsterManager:RangeSummonTriggerItem(pos, r1, r2, metaId, count, ownerMeta, castType)
  local task = RangeGenSummonTriggerItemTask.New(self, pos, r1, r2, metaId, count, ownerMeta, castType)
  self:AddTask(task)
end

function MonsterManager:AddShowList(monster)
  if monster and monster.guid then
    self.showList[monster.guid] = monster
  end
end

function MonsterManager:GetMonster(guid)
  return self.showList[guid]
end

function MonsterManager:GetMonsters()
  return self.showList
end

function MonsterManager:RemoveMonster(guid)
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

function MonsterManager:AddTask(task)
  self.taskGuid = self.taskGuid + 1
  task.id = self.taskGuid
  self.tasks[self.taskGuid] = task
end

function MonsterManager:RemoveTask(task)
  if self.tasks == nil or self.tasks[task.id] == nil then
    return
  end
  task:Delete()
  self.tasks[task.id] = nil
end

function MonsterManager:Destroy()
  self.allMonster = nil
  self.showList = nil
  self.waitCreate = nil
  self.cacheBossLineMonster = nil
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

function MonsterManager:GetRandomDeadAnim()
  return self.randomDeadAnimPool:GetRandom()
end

function MonsterManager:OnMonsterDeath(guid)
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

function MonsterManager:ChangeBonus()
  for k, monster in pairs(self.allMonster) do
    if monster and monster.Death then
      monster:Death()
    end
  end
  for k, bonus in pairs(self.bonusEvent) do
    local task = GenMonsterTask.New(self, bonus.param)
    self:AddTask(task)
    self.bonusEvent[k] = nil
  end
end

function MonsterManager:ClearMonsterByView()
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

function MonsterManager:EnterBossLine()
  self.enterAirdropTime = 0
  local count = #self.cacheBossLineMonster
  for i = count, 1, -1 do
    local data = self.cacheBossLineMonster[i]
    table.remove(self.cacheBossLineMonster, i)
    local monster = data.monster
    if monster then
      local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(data.metaId)
      if meta then
        monster:Init(self.logic, self, self.logic:AllotUnitGuid(), data.x, data.y, meta)
        self.allMonster[monster.guid] = monster
        self.logic:AddUnit(monster)
        if monster.monsterMeta.is_boss == 1 or monster.monsterMeta.monster_type == Const.MonsterType.Boss then
          self.logic:OnBossEnterBattle(monster)
        end
        monster:ModifyPosY(data.y + (self.defenseOffsetY or 0))
        monster:Load()
        self.showList[monster.guid] = monster
      end
    end
  end
end

function MonsterManager:UpdateAirdropEvent(deltaTime)
  if self.enterAirdropTime == nil then
    return
  end
  self.enterAirdropTime = self.enterAirdropTime + deltaTime
  for k, monster in pairs(self.airdropEvent) do
    if monster.time <= self.enterAirdropTime then
      self.airdropEvent[k] = nil
      local task = GenAirdropTask.New(self, monster)
      self:AddTask(task)
    end
  end
end

function MonsterManager:SetGamePause(pause)
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

function MonsterManager:GetPlotDataByMonsterId(targetMonsterId)
  local monsterIdStr = LuaEntry.DataConfig:TryGetStr("battle_hero_plot", "k1")
  local plotStr = LuaEntry.DataConfig:TryGetStr("battle_hero_plot", "k2")
  if not string.IsNullOrEmpty(monsterIdStr) and not string.IsNullOrEmpty(plotStr) then
    local monsterIdArr = string.split(monsterIdStr, "|")
    local plotArr = string.split(plotStr, "|")
    local monsterIdCount = table.count(monsterIdArr)
    local plotCount = table.count(plotArr)
    if 0 < monsterIdCount and 0 < plotCount and monsterIdCount == plotCount then
      for i = 1, monsterIdCount do
        local monsterId = tonumber(monsterIdArr[i])
        if monsterId == targetMonsterId then
          local plotContentStr = plotArr[i]
          if not string.IsNullOrEmpty(plotContentStr) then
            local phasePlotArr = string.split(plotContentStr, ";")
            if table.count(phasePlotArr) then
              local plotDataArr = {}
              for i, v in ipairs(phasePlotArr) do
                local plotIdArr = {}
                local plotIdStrArr = string.split(v, ",")
                for j, k in ipairs(plotIdStrArr) do
                  local plotId = tonumber(k)
                  if 0 < plotId then
                    table.insert(plotIdArr, plotId)
                  end
                end
                plotDataArr[i] = plotIdArr
              end
              return plotDataArr
            end
          end
        end
      end
    end
  end
  return nil
end

function MonsterManager:OnMonsterBornTriggered(monsterBornMeta)
  if monsterBornMeta == nil then
    return
  end
  if self.logic and self.logic.OnMonsterBornTriggered then
    self.logic:OnMonsterBornTriggered(monsterBornMeta)
  end
end

return MonsterManager
