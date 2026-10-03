local SurfingCoinObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingCoinObj")
local SurfingBoxObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBoxObj")
local SurfingColliderMonster = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingColliderMonster")
local SurfingBuffMagnetObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffMagnetObj")
local SurfingBuffJetPackObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffJetPackObj")
local SurfingBuffDoubleObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffDoubleObj")
local SurfingBuffShieldObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffShieldObj")
local SurfingBuffAllyObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffAllyObj")
local SurfingMovableMonster = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingMovableMonster")
local SurfingBuffMorphObj = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffMorphObj")
local GhostParkourBuffSpeedUpObj = require("Scene.LWBattle.GhostParkour.Monster.MonsterImpl.GhostParkourBuffSpeedUpObj")
local GhostParkourEnergyObj = require("Scene.LWBattle.GhostParkour.Monster.MonsterImpl.GhostParkourEnergyObj")
local Const = require("Scene.LWBattle.Const")
local SurfingObjectMoveState = require("Scene.LWBattle.Surfing.Monster.MonsterState.SurfingObjectMoveState")
local SurfingObjectIdleState = require("Scene.LWBattle.Surfing.Monster.MonsterState.SurfingObjectIdleState")
local FSM = require("Framework.Common.FSMWithPool")
local SurfingMonsterManager = BaseClass("SurfingMonsterManager")
local ViewDisForward = 210
local ViewDisBack = 8
local CreateCountPerFrame = 10
local MonsterBornType = {
  None = 0,
  Static = 1,
  Box = 2,
  Buff = 3,
  Ally = 4,
  RandomBuff = 5
}
SurfingMonsterManager.MonsterBornType = MonsterBornType
local BattleColliderUtils = CS.BattleColliderUtils

function SurfingMonsterManager:Init(logic)
  self.logic = logic
  self.allMonster = {}
  self.showList = {}
  self.waitCreate = {}
  self.farmMonster = {}
  self.waitShowObjs = nil
  self.colliderResultList = nil
  self.colliderMap = {}
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
end

function SurfingMonsterManager:Destroy()
  self.logic = nil
  self.allMonster = nil
  self.showList = nil
  self.waitCreate = nil
  self.farmMonster = nil
  self.waitShowObjs = nil
  self.colliderResultList = nil
  self.colliderMap = nil
  BattleColliderUtils.ClearMonsterColliderData()
  ObjectPool:GetInstance():Clear(SurfingCoinObj)
  ObjectPool:GetInstance():Clear(SurfingBoxObj)
  ObjectPool:GetInstance():Clear(SurfingColliderMonster)
  ObjectPool:GetInstance():Clear(SurfingBuffMagnetObj)
  ObjectPool:GetInstance():Clear(SurfingBuffJetPackObj)
  ObjectPool:GetInstance():Clear(SurfingBuffDoubleObj)
  ObjectPool:GetInstance():Clear(SurfingBuffShieldObj)
  ObjectPool:GetInstance():Clear(SurfingBuffAllyObj)
  ObjectPool:GetInstance():Clear(SurfingMovableMonster)
  ObjectPool:GetInstance():Clear(SurfingBuffMorphObj)
  ObjectPool:GetInstance():Clear(FSM)
  ObjectPool:GetInstance():Clear(SurfingObjectMoveState)
  ObjectPool:GetInstance():Clear(SurfingObjectIdleState)
end

function SurfingMonsterManager:ReInit(bornArr, offset, stageSceneIndex)
  if table.IsNullOrEmpty(bornArr) then
    return
  end
  ProfilerUtil.BeginSample("SurfingMonsterManager.ReInit")
  offset = offset or 0
  for _, bornId in ipairs(bornArr) do
    local born = DataCenter.SurfingMonsterBornTemplateManager:GetTemplate(bornId)
    if born == nil then
      Logger.LogError("lw_monster_born \230\178\161\230\156\137id:" .. bornId)
    else
      local data = {}
      data.born = born
      data.x = born.coord[1]
      data.y = born.coord[2]
      data.z = offset + born.coord[3]
      local triggerLine = tonumber(born.para) or 0
      if 0 < triggerLine then
        data.triggerLine = offset + triggerLine
        data.triggerLineOffset = triggerLine
        data.stageSceneIndex = stageSceneIndex
      end
      table.insert(self.farmMonster, data)
    end
  end
  ProfilerUtil.EndSample()
end

function SurfingMonsterManager:Update(dataY, deltaTime)
  if self.logic == nil or self.waitCreate == nil then
    return
  end
  self.viewY = dataY
  self:UpdateFixPointMonster(dataY)
  self:UpdateAllMonster(deltaTime, dataY)
end

function SurfingMonsterManager:UpdateFixPointMonster(viewY)
  for k, monster in pairs(self.farmMonster) do
    if monster.z - viewY < ViewDisForward then
      table.insert(self.waitCreate, monster)
      self.farmMonster[k] = nil
    end
  end
  if self.waitShowObjs then
    for k, monster in pairs(self.waitShowObjs) do
      if monster.z - viewY < ViewDisForward and monster.z <= self.waitObjLimit then
        table.insert(self.waitCreate, monster)
        self.waitShowObjs[k] = nil
      end
    end
  end
  for k, monster in pairs(self.showList) do
    if viewY - monster:GetDataZ() > ViewDisBack then
      self:RemoveMonster(monster.guid)
    end
  end
  for k, monster in pairs(self.waitCreate) do
    if viewY - monster.z > ViewDisBack then
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

function SurfingMonsterManager:UpdateAllMonster(deltaTime, dataY)
  for k, monster in pairs(self.allMonster) do
    if monster then
      monster:OnUpdate(deltaTime, dataY)
    end
  end
end

function SurfingMonsterManager:CreateFarmMonster(bornMeta)
  local monster
  local type = bornMeta.born.type
  if type <= MonsterBornType.None then
    return
  end
  local mId = bornMeta.born:GetOriMonsterId()
  local oriId = 0
  local param
  local index, level = 0, 0
  if mId == nil or mId == 0 then
    mId = self.logic:GetSwitchMonsterId()
  else
    local monsterMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(mId)
    if monsterMeta == nil then
      return
    end
    if monsterMeta:RandomOriginal() then
      if type == MonsterBornType.Box then
        local check = self.logic.CheckRemainBox and self.logic:CheckRemainBox()
        if check then
          index = 1
        else
          mId = self.logic:GetSwitchMonsterId()
        end
      elseif type == MonsterBornType.Buff then
        local unlock, _, l = monsterMeta:CheckBuffIsUnlock()
        if unlock then
          index = 1
          level = l
        else
          mId = self.logic:GetSwitchMonsterId()
        end
      elseif type == MonsterBornType.Ally then
        local build = false
        local random = self.logic.GetRemainHelpTimes and self.logic:GetRemainHelpTimes()
        if random then
          local bMId, i = monsterMeta:GetRandomBuff()
          if bMId and 0 < bMId then
            local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(bMId)
            if bMMeta then
              local unlock, _, l = bMMeta:CheckBuffIsUnlock()
              if unlock then
                local playerInfo = self.logic.GetRandomPlayer and self.logic:GetRandomPlayer()
                if playerInfo then
                  build = true
                  param = {playerInfo = playerInfo, monsterId = bMId}
                  index = i
                  level = l
                end
              end
            end
          end
        end
        if not build then
          mId = self.logic:GetSwitchMonsterId()
        end
      elseif type == MonsterBornType.RandomBuff then
        oriId = mId
        local build
        local bMId, i = monsterMeta:GetRandomBuff()
        if bMId and 0 < bMId then
          local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(bMId)
          if bMMeta then
            local unlock, _, l = bMMeta:CheckBuffIsUnlock()
            if unlock then
              mId = bMId
              build = true
              index = i
              level = l
            end
          end
        end
        if not build then
          mId = self.logic:GetSwitchMonsterId()
        end
      end
    else
      mId = self.logic:GetSwitchMonsterId()
    end
  end
  if 0 < mId then
    if param == nil then
      param = {}
    end
    param.triggerLine = bornMeta.triggerLine
    param.triggerLineOffset = bornMeta.triggerLineOffset
    param.stageSceneIndex = bornMeta.stageSceneIndex
    monster = self:CreateMonster(bornMeta.x, bornMeta.y, bornMeta.z, mId, bornMeta.born.id, param, oriId)
  end
  if (type == MonsterBornType.Box or type == MonsterBornType.Buff or type == MonsterBornType.Ally or type == MonsterBornType.RandomBuff) and self.logic.LogMonsterObj then
    self.logic:LogMonsterObj(index, level, mId)
  end
  return monster
end

function SurfingMonsterManager:CreateMonster(x, y, z, metaId, bornId, param, oriId)
  local meta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(metaId)
  if not meta then
    return
  end
  local monster
  local monsterType = meta.monster_type
  if monsterType == Const.SurfingMonsterType.Normal then
    monster = ObjectPool:GetInstance():Load(SurfingCoinObj)
  elseif monsterType == Const.SurfingMonsterType.Box then
    monster = ObjectPool:GetInstance():Load(SurfingBoxObj)
  elseif monsterType == Const.SurfingMonsterType.Static then
    monster = ObjectPool:GetInstance():Load(SurfingColliderMonster)
  elseif monsterType == Const.SurfingMonsterType.Magnet then
    monster = ObjectPool:GetInstance():Load(SurfingBuffMagnetObj)
  elseif monsterType == Const.SurfingMonsterType.JetPack then
    monster = ObjectPool:GetInstance():Load(SurfingBuffJetPackObj)
  elseif monsterType == Const.SurfingMonsterType.Double then
    monster = ObjectPool:GetInstance():Load(SurfingBuffDoubleObj)
  elseif monsterType == Const.SurfingMonsterType.Shield then
    monster = ObjectPool:GetInstance():Load(SurfingBuffShieldObj)
  elseif monsterType == Const.SurfingMonsterType.Ally then
    monster = ObjectPool:GetInstance():Load(SurfingBuffAllyObj)
  elseif monsterType == Const.SurfingMonsterType.Movable then
    monster = ObjectPool:GetInstance():Load(SurfingMovableMonster)
  elseif monsterType == Const.SurfingMonsterType.Morph then
    monster = ObjectPool:GetInstance():Load(SurfingBuffMorphObj)
  elseif monsterType == Const.SurfingMonsterType.SpeedUp then
    monster = ObjectPool:GetInstance():Load(GhostParkourBuffSpeedUpObj)
  elseif monsterType == Const.SurfingMonsterType.Energy then
    monster = ObjectPool:GetInstance():Load(GhostParkourEnergyObj)
  end
  if monster then
    monster:Init(self.logic, self, x, y, z, meta, bornId, param, oriId)
    self.allMonster[monster.guid] = monster
    self.logic:AddUnit(monster)
  end
  return monster
end

function SurfingMonsterManager:GetMonster(guid)
  return self.allMonster and self.allMonster[guid]
end

function SurfingMonsterManager:RemoveMonster(guid)
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

function SurfingMonsterManager:ClearMonstersByOffset(posZ)
  for _, v in pairs(self.showList) do
    if v and posZ > v.z then
      self:RemoveMonster(v.guid)
    end
  end
end

function SurfingMonsterManager:CreateSkyScores(bornArr, offsetZ, dis)
  if table.IsNullOrEmpty(bornArr) then
    return
  end
  offsetZ = offsetZ or 0
  if self.waitShowObjs == nil then
    self.waitShowObjs = {}
  end
  for _, bornId in ipairs(bornArr) do
    local born = DataCenter.SurfingMonsterBornTemplateManager:GetTemplate(bornId)
    if born == nil then
      Logger.LogError("lw_monster_born \230\178\161\230\156\137id:" .. bornId)
    else
      local data = {}
      data.born = born
      data.x = born.coord[1]
      data.y = born.coord[2]
      data.z = offsetZ + born.coord[3]
      table.insert(self.waitShowObjs, data)
    end
  end
  self.waitObjLimit = offsetZ + dis
end

function SurfingMonsterManager:RemoveSkyScores()
  self.waitShowObjs = nil
  self.waitObjLimit = nil
end

function SurfingMonsterManager:ResetRenderPosition()
  if self.allMonster then
    for _, monster in pairs(self.allMonster) do
      monster:ResetRenderPosition()
    end
  end
end

return SurfingMonsterManager
