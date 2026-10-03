local BuffManager = BaseClass("BuffManager")
local BuffBase = require("Scene.LWBattle.Buff.BuffBase")
local BuffProperty = require("Scene.LWBattle.Buff.BuffProperty")
local BuffBeTaunt = require("Scene.LWBattle.Buff.BuffBeTaunt")
local BuffShield = require("Scene.LWBattle.Buff.BuffShield")
local BuffModelScale = require("Scene.LWBattle.Buff.BuffModelScale")
local BuffDot = require("Scene.LWBattle.Buff.BuffDot")
local BuffTransformer = require("Scene.LWBattle.Buff.BuffTransformer")
local BuffAbsorbItem = require("Scene.LWBattle.Buff.BuffAbsorbItem")
local BuffNewHot = require("Scene.LWBattle.Buff.BuffNewHot")
local BuffChangeMaxBlood = require("Scene.LWBattle.Buff.BuffChangeMaxBlood")

function BuffManager:__init(logic, unit)
  self.logic = logic
  self.unit = unit
  self.buffs = {}
  self.propertyBuffs = {}
  self.dotBuffs = {}
  self.dotCDs = {}
  self.newHotBuffs = {}
  self.hotCDs = {}
  self.metaId2Count = {}
  self.metaId2Buff = {}
  self.haloBuff = {}
  self.subType2Count = {}
  self.type2Count = {}
  self.metaId2BuffIdMap = {}
  self.metaId2ActivingEffectId = {}
  self.shieldBuffs = {}
  self.modelScaleBuffs = {}
  self.singleType2Buff = {}
  self.buffGroupId2OrderValue = {}
  self.buffGroupId2BuffsMap = {}
  self.changeMaxBloodBuffs = {}
  self.nextUid = 0
  self.shieldValue = 0
  self.modelScale = 1
  self.changeMaxBlood = 0
end

function BuffManager:__delete()
  self:Destroy()
end

function BuffManager:AddBuff(metaId, param, lv, triggerNewBuffUpperLimit, sourceType, sourceId)
  metaId = tonumber(metaId)
  local meta = DataCenter.LWBuffTemplateManager:GetTemplate(metaId)
  local newBuff
  local additiveType = meta.additive_type
  if additiveType == 1 then
    if triggerNewBuffUpperLimit then
      return nil
    end
    local oldBuff = self.metaId2Buff[metaId]
    if oldBuff then
      oldBuff:Reset()
      return oldBuff
    else
      newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
      self.metaId2Buff[metaId] = newBuff
    end
  elseif additiveType == 2 then
    if meta.add_buff_order and meta.add_buff_order > 0 then
      local curBuffOrder = self.buffGroupId2OrderValue[meta.group] or 0
      if curBuffOrder > meta.add_buff_order then
        return nil
      end
    end
    local curCount = self.metaId2Count[metaId]
    if curCount then
      if curCount >= meta.max_level then
        if meta.add_buff_max_level == 0 or triggerNewBuffUpperLimit then
          return nil
        end
        self:RemoveBuffByMetaId(metaId, curCount)
        return self:AddBuff(meta.add_buff_max_level, param, lv, nil, sourceType, sourceId)
      else
        newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
        self.metaId2Count[metaId] = curCount + 1
      end
    else
      newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
      self.metaId2Count[metaId] = 1
    end
    self:OnBuffLevelChange(meta, newBuff)
  elseif additiveType == 3 then
    if triggerNewBuffUpperLimit then
      return nil
    end
    local oldBuff = self.metaId2Buff[metaId]
    if oldBuff then
      self:InnerRemoveBuff(oldBuff)
    end
    newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
    self.metaId2Buff[metaId] = newBuff
  elseif additiveType == 4 then
    local type = meta.type
    local oldBuff = self.singleType2Buff[type]
    if oldBuff then
      if oldBuff.meta.id == meta.id then
        oldBuff:Reset()
        return oldBuff
      end
      newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
      self:InnerRemoveBuff(oldBuff)
      oldBuff:RemoveActivatingEffect()
      self.singleType2Buff[type] = newBuff
    else
      newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
      self.singleType2Buff[type] = newBuff
    end
  elseif additiveType == 5 then
    if triggerNewBuffUpperLimit then
      return nil
    end
    if self:HasAnyBuffWithType(meta.type) then
      return nil
    end
    newBuff = self:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
    self.metaId2Buff[metaId] = newBuff
  end
  self.buffs[newBuff.id] = newBuff
  return newBuff
end

function BuffManager:AddHaloBuff(skillUid, propertyDic, skillId, lv)
  local oldBuff = self.haloBuff[skillUid]
  if oldBuff then
    oldBuff:Reset()
    return oldBuff
  else
    local fakeMeta = {}
    fakeMeta.id = -1 * (skillId or 99999)
    fakeMeta.type = BuffType.Halo
    fakeMeta.buff_time = HALO_BUFF_DURATION
    fakeMeta.sub_type = 0
    local newBuff = self:InnerCreateBuff(fakeMeta, propertyDic, lv)
    self.haloBuff[skillUid] = newBuff
    self.buffs[newBuff.id] = newBuff
  end
end

function BuffManager:RemoveAllBuff()
  for _, buff in pairs(self.buffs) do
    buff:End()
  end
end

function BuffManager:RemoveAllBuffByType(type)
  for _, buff in pairs(self.buffs) do
    if buff.meta.type == type then
      buff:End()
    end
  end
end

function BuffManager:RemoveBuffByMetaId(metaId, count)
  local removeCount = count or 1
  if self.metaId2BuffIdMap[metaId] then
    local list = self.metaId2BuffIdMap[metaId]
    local buffList = {}
    for _, mId in pairs(list) do
      if self.buffs[mId] then
        table.insert(buffList, self.buffs[mId])
      end
    end
    local buffCount = #buffList
    local maxCount = math.min(buffCount, removeCount)
    if buffCount > maxCount then
      table.sort(buffList, function(a, b)
        local durationA = a.duration
        local durationB = b.durationB
        if durationA ~= nil and durationB ~= nil then
          return durationA < durationB
        elseif durationA ~= nil then
          return true
        elseif durationB ~= nil then
          return false
        else
          local buffAId = a.id
          local buffBId = b.id
          return buffAId < buffBId
        end
      end)
    end
    for i = 1, maxCount do
      local b = buffList[i]
      if b then
        b:End()
      end
    end
  end
end

function BuffManager:RemoveBuffByMetaIdTimeOrder(metaId, count)
  local _removeCount = count or 1
  if self.metaId2BuffIdMap[metaId] then
    local list = self.metaId2BuffIdMap[metaId]
    local buffList = {}
    for _, mId in pairs(list) do
      if self.buffs[mId] then
        table.insert(buffList, self.buffs[mId])
      end
    end
    local buffCount = #buffList
    local maxCount = math.min(buffCount, _removeCount)
    if buffCount > maxCount then
      table.sort(buffList, function(a, b)
        local aUid = a.id
        local bUid = b.id
        if aUid < bUid then
          return true
        else
          return false
        end
      end)
    end
    for i = 1, maxCount do
      local b = buffList[i]
      if b then
        b:End()
      end
    end
  end
end

function BuffManager:Destroy()
  for _, buff in pairs(self.buffs) do
    buff:End()
  end
  self.unit = nil
  for _, property in pairs(self.propertyBuffs) do
    property = {}
  end
  self.propertyBuffs = {}
  self.metaId2Count = {}
  self.buffs = {}
  self.haloBuff = {}
  self.subType2Count = {}
  self.type2Count = {}
  self.singleType2Buff = {}
  for _, buffIdList in pairs(self.metaId2BuffIdMap) do
    buffIdList = {}
  end
  self.metaId2BuffIdMap = {}
  for _, effectInfo in pairs(self.metaId2ActivingEffectId) do
    self.logic:RemoveEffectObj(effectInfo.id)
  end
  self.metaId2ActivingEffectId = {}
  self.shieldBuffs = {}
  self.shieldValue = 0
  self.modelScaleBuffs = {}
  self.modelScale = 1
  self.buffGroupId2OrderValue = nil
  self.buffGroupId2BuffsMap = nil
  self.changeMaxBloodValue = {}
  self.changeMaxBlood = 0
end

function BuffManager:OnUpdate()
  for _, buff in pairs(self.buffs) do
    buff:Update()
  end
  local calHot = false
  for interval, buffs in pairs(self.newHotBuffs) do
    local cd = self.hotCDs[interval] or 0
    cd = cd - Time.deltaTime
    if not calHot and cd <= 0 then
      calHot = true
      cd = cd + interval * 0.001
      local hp = 0
      for _, buff in pairs(buffs) do
        hp = hp + buff:GetHp()
      end
      if 0 < hp then
        self.unit:BeHeal(hp)
        self.unit:AfterBeHeal(hp)
      end
    end
    self.hotCDs[interval] = cd
  end
  local calDot = false
  for interval, buffs in pairs(self.dotBuffs) do
    local cd = self.dotCDs[interval] or 0
    cd = cd - Time.deltaTime
    if not calDot and cd <= 0 then
      calDot = true
      cd = cd + interval * 0.001
      local damage = 0
      local damageType = DamageType.None
      for _, buff in pairs(buffs) do
        damage = damage + buff:GetDamage()
        damageType = buff.damageType or DamageType.None
      end
      if 0 < damage then
        self.unit:BeAttack(damage)
        self.unit:AfterBeAttack(damage)
        self.logic:ShowDamageText(damage, self.unit:GetPosition(), DamageTextType.Dot, damageType)
      end
    end
    self.dotCDs[interval] = cd
  end
end

function BuffManager:InnerCreateBuff(meta, param, lv, sourceType, sourceId)
  local newBuff
  local uid = self:GetNextUid()
  local buffType = meta.type
  if buffType == BuffType.Property then
    local propertyDic = meta:GetParaDictByLevel(param)
    newBuff = BuffProperty.New(self.logic, self, self.unit, meta, uid, propertyDic)
  elseif buffType == BuffType.Halo then
    newBuff = BuffProperty.New(self.logic, self, self.unit, meta, uid, param)
  elseif buffType == BuffType.BeTaunt then
    newBuff = BuffBeTaunt.New(self.logic, self, self.unit, meta, uid, param)
  elseif buffType == BuffType.Shield then
    newBuff = BuffShield.New(self.logic, self, self.unit, meta, uid, param)
  elseif buffType == BuffType.ModelScale then
    newBuff = BuffModelScale.New(self.logic, self, self.unit, meta, uid)
  elseif buffType == BuffType.Dot then
    newBuff = BuffDot.New(self.logic, self, self.unit, meta, uid, param)
  elseif buffType == BuffType.Transformer then
    newBuff = BuffTransformer.New(self.logic, self, self.unit, meta, uid, param)
  elseif buffType == BuffType.AbsorbItem then
    newBuff = BuffAbsorbItem.New(self.logic, self, self.unit, meta, uid, param)
  elseif meta.type == BuffType.NewHot then
    newBuff = BuffNewHot.New(self.logic, self, self.unit, meta, uid, param)
  elseif meta.type == BuffType.ChangeMaxBlood then
    newBuff = BuffChangeMaxBlood.New(self.logic, self, self.unit, meta, uid, param)
  else
    newBuff = BuffBase.New(self.logic, self, self.unit, meta, uid, param)
  end
  newBuff:SetLv(lv)
  newBuff:Start()
  if sourceType and sourceId then
    newBuff:SetBuffFromSourceData(sourceType, sourceId)
  end
  if self.unit and self.unit.OnBuffAdded then
    self.unit:OnBuffAdded(newBuff)
  end
  EventManager:GetInstance():Broadcast(EventId.PVEBuffAdded, newBuff)
  self:RegisterSubType(meta.sub_type)
  self:RegisterType(meta.type)
  if not self.metaId2BuffIdMap[meta.id] then
    self.metaId2BuffIdMap[meta.id] = {}
  end
  table.insert(self.metaId2BuffIdMap[meta.id], newBuff.id)
  if meta.add_buff_order and meta.add_buff_order > 0 then
    local curBuffOrder = self.buffGroupId2OrderValue[meta.group] or 0
    if curBuffOrder < meta.add_buff_order then
      self.buffGroupId2OrderValue[meta.group] = meta.add_buff_order
    end
    if not self.buffGroupId2BuffsMap[meta.group] then
      self.buffGroupId2BuffsMap[meta.group] = {}
    end
    table.insert(self.buffGroupId2BuffsMap[meta.group], newBuff)
  end
  return newBuff
end

function BuffManager:GetBuffLevel(metaId)
  local count = self.metaId2Count[metaId] or 0
  return count
end

function BuffManager:OnBuffLevelChange(meta, buff)
  local effectPath, effectLv
  local buffLevel = self:GetBuffLevel(meta.id)
  if self.metaId2ActivingEffectId[meta.id] then
    if buffLevel <= 0 then
      self:RemoveActivingEffect(meta.id)
      return
    end
    local displayingEffectBuffLevel = self.metaId2ActivingEffectId[meta.id].buffLevel
    if buffLevel == displayingEffectBuffLevel then
      return
    end
    local displayingEffectLevel = self.metaId2ActivingEffectId[meta.id].effectLv
    effectPath, effectLv = meta:GetActivingEffectPathByLevel(buffLevel)
    if displayingEffectLevel == effectLv then
      self.metaId2ActivingEffectId[meta.id].buffLevel = buffLevel
      return
    else
      self:RemoveActivingEffect(meta.id)
    end
  else
    effectPath, effectLv = meta:GetActivingEffectPathByLevel(buffLevel)
  end
  local unit = buff.unit
  if unit == nil then
    return
  end
  self:AddActivingEffect(unit, meta, effectPath, buffLevel, effectLv)
end

function BuffManager:AddActivingEffect(unit, meta, effectPath, buffLevel, effectLv)
  if not (unit and meta) or not effectPath then
    return
  end
  local trans = unit:GetBuffTransform(meta.buff_path)
  local effectId
  if meta.ignore_rotate then
    if trans then
      effectId = self.logic:ShowEffectObj(effectPath, trans.localPosition, Quaternion.identity, 0, trans.parent, nil, true)
    end
  else
    effectId = self.logic:ShowEffectObj(effectPath, nil, Quaternion.identity, 0, trans, nil, true)
  end
  self.metaId2ActivingEffectId[meta.id] = {
    id = effectId,
    buffLevel = buffLevel,
    effectLv = effectLv
  }
end

function BuffManager:RemoveActivingEffect(metaId)
  if self.metaId2ActivingEffectId[metaId] then
    self.logic:RemoveEffectObj(self.metaId2ActivingEffectId[metaId].id)
    self.metaId2ActivingEffectId[metaId] = nil
  end
end

function BuffManager:InnerRemoveBuff(buff)
  self.buffs[buff.id] = nil
  if buff.meta.id then
    self.metaId2Buff[buff.meta.id] = nil
    if self.metaId2Count[buff.meta.id] then
      self.metaId2Count[buff.meta.id] = self.metaId2Count[buff.meta.id] - 1
      self:RemoveActivingEffect(buff.meta.id)
    end
    self:UnregisterSubType(buff.meta.sub_type)
    self:UnregisterType(buff.meta.type)
    if self.metaId2BuffIdMap[buff.meta.id] then
      table.removebyvalue(self.metaId2BuffIdMap[buff.meta.id], buff.id)
    end
  end
  if buff.meta.type then
    self.singleType2Buff[buff.meta.type] = nil
  end
  if buff.meta.add_buff_order and buff.meta.add_buff_order > 0 then
    local buffs = self.buffGroupId2BuffsMap[buff.meta.group] or nil
    if buffs then
      table.removebyvalue(buffs, buff)
      local findMaxBuffOrder = -1
      for i, buffData in pairs(buffs) do
        if findMaxBuffOrder < buffData.meta.add_buff_order then
          findMaxBuffOrder = buffData.meta.add_buff_order
        end
      end
      if findMaxBuffOrder < 0 then
        self.buffGroupId2BuffsMap[buff.meta.group] = nil
        self.buffGroupId2OrderValue[buff.meta.group] = nil
      else
        self.buffGroupId2OrderValue[buff.meta.group] = findMaxBuffOrder
      end
    end
  end
  if self.unit and self.unit.OnBuffRemoved then
    self.unit:OnBuffRemoved(buff)
  end
  EventManager:GetInstance():Broadcast(EventId.PVEBuffRemoved, buff)
end

function BuffManager:GetNextUid()
  self.nextUid = self.nextUid + 1
  return self.nextUid
end

function BuffManager:HasAnyBuffWithType(type)
  return self.type2Count[type] and self.type2Count[type] > 0
end

function BuffManager:GetTypeBuffCount(type)
  return self.type2Count[type] or 0
end

function BuffManager:GetSingleBuffByType(type)
  return self.singleType2Buff[type] or nil
end

function BuffManager:RegisterType(type)
  if not self.type2Count[type] then
    self.type2Count[type] = 0
  end
  self.type2Count[type] = self.type2Count[type] + 1
end

function BuffManager:UnregisterType(type)
  self.type2Count[type] = self.type2Count[type] - 1
end

function BuffManager:GetSubTypeBuffCount(subType)
  return self.subType2Count[subType] or 0
end

function BuffManager:DoActionForTypeBuff(type, action)
  for _, buff in pairs(self.buffs) do
    if buff.meta and buff.meta.type == type then
      local continue = action(buff)
      if not continue then
        break
      end
    end
  end
end

function BuffManager:RegisterSubType(subType)
  if not self.subType2Count[subType] then
    self.subType2Count[subType] = 0
  end
  self.subType2Count[subType] = self.subType2Count[subType] + 1
end

function BuffManager:UnregisterSubType(subType)
  self.subType2Count[subType] = self.subType2Count[subType] - 1
end

function BuffManager:GetPropertyBuff(propertyType)
  local buffs = self.propertyBuffs[propertyType]
  if buffs == nil then
    return 0
  end
  local ret = 0
  for _, buff in pairs(buffs) do
    ret = ret + buff:GetPropertyValue(propertyType)
  end
  return ret
end

function BuffManager:RegisterPropertyBuff(propertyType, buff)
  if not self.propertyBuffs[propertyType] then
    self.propertyBuffs[propertyType] = {}
  end
  self.propertyBuffs[propertyType][buff.id] = buff
end

function BuffManager:UnregisterPropertyBuff(propertyType, buff)
  self.propertyBuffs[propertyType][buff.id] = nil
end

function BuffManager:RegisterShieldBuff(buff)
  self.shieldBuffs[buff.id] = buff
  self.shieldValue = 0
  for _, v in pairs(self.shieldBuffs) do
    self.shieldValue = self.shieldValue + v:GetShieldValue()
  end
end

function BuffManager:UnregisterShieldBuff(buff)
  self.shieldBuffs[buff.id] = nil
  self.shieldValue = 0
  for _, v in pairs(self.shieldBuffs) do
    self.shieldValue = self.shieldValue + v:GetShieldValue()
  end
end

function BuffManager:GetShieldValue()
  return self.shieldValue
end

function BuffManager:ReduceShieldValue(hurt)
  if self.shieldValue <= 0 then
    return hurt
  end
  if hurt > self.shieldValue then
    for _, v in pairs(self.shieldBuffs) do
      v:ReduceAll()
    end
    local remain = hurt - self.shieldValue
    self.shieldValue = 0
    return remain
  end
  self.shieldValue = self.shieldValue - hurt
  local buffs = {}
  for _, v in pairs(self.shieldBuffs) do
    table.insert(buffs, v)
  end
  if #buffs == 1 then
    return buffs[1]:ReduceShieldValue(hurt)
  end
  table.sort(buffs, function(a, b)
    local durationA = a.duration
    local durationB = b.duration
    if durationA ~= nil and durationB ~= nil then
      return durationA < durationB
    elseif durationA ~= nil then
      return true
    elseif durationB ~= nil then
      return false
    else
      local buffAId = a.id
      local buffBId = b.id
      return buffAId < buffBId
    end
  end)
  local remainHurt = hurt
  for _, v in ipairs(buffs) do
    remainHurt = v:ReduceShieldValue(remainHurt)
    if remainHurt <= 0 then
      return remainHurt
    end
  end
  return remainHurt
end

function BuffManager:RefreshBuffsParent()
  if self.buffs then
    for _, v in pairs(self.buffs) do
      if v then
        v:ReshowActivatingEffect()
      end
    end
  end
end

function BuffManager:RemoveAllShield()
  for _, v in pairs(self.shieldBuffs) do
    v:ReduceAll()
  end
end

function BuffManager:RegisterModelScaleBuff(buff)
  self.modelScaleBuffs[buff.id] = buff
  self.modelScale = 1
  for _, v in pairs(self.modelScaleBuffs) do
    self.modelScale = self.modelScale * v:GetBuffValue()
  end
end

function BuffManager:UnregisterModelScaleBuff(buff)
  self.modelScaleBuffs[buff.id] = nil
  self.modelScale = 1
  for _, v in pairs(self.modelScaleBuffs) do
    self.modelScale = self.modelScale * v:GetBuffValue()
  end
end

function BuffManager:GetModelScaleValue()
  return self.modelScale
end

function BuffManager:RegisterDotBuff(interval, buff)
  if not self.dotBuffs[interval] then
    self.dotBuffs[interval] = {}
  end
  self.dotBuffs[interval][buff.id] = buff
end

function BuffManager:UnregisterDotBuff(interval, buff)
  self.dotBuffs[interval][buff.id] = nil
end

function BuffManager:RegisterNewHotBuff(interval, buff)
  if not self.newHotBuffs[interval] then
    self.newHotBuffs[interval] = {}
  end
  self.newHotBuffs[interval][buff.id] = buff
end

function BuffManager:UnregisterNewHotBuff(interval, buff)
  self.newHotBuffs[interval][buff.id] = nil
end

function BuffManager:RegisterChangeMaxBloodBuff(buff)
  self.changeMaxBloodBuffs[buff.id] = buff
  self.changeMaxBloodValue = 0
  for _, v in pairs(self.changeMaxBloodBuffs) do
    self.changeMaxBloodValue = self.changeMaxBloodValue + v:GetChangeMaxBloodValue()
  end
end

function BuffManager:UnregisterChangeMaxBloodBuff(buff)
  self.changeMaxBloodBuffs[buff.id] = nil
  self.changeMaxBloodValue = 0
  for _, v in pairs(self.changeMaxBloodBuffs) do
    self.changeMaxBloodValue = self.changeMaxBloodValue + v:GetChangeMaxBloodValue()
  end
end

function BuffManager:GetChangeMaxBloodValue()
  return self.changeMaxBloodValue
end

function BuffManager:SetBuffFromSourceData(buffUid, sourceType, sourceId)
  local buff = self.buffs[buffUid] or nil
  if buff and buff.SetBuffFromSourceData then
    buff:SetBuffFromSourceData(sourceType, sourceId)
  end
end

return BuffManager
