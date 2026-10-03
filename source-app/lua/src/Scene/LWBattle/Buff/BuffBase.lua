local BuffBase = BaseClass("BuffBase")

function BuffBase:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.mgr = mgr
  self.unit = unit
  self.meta = meta
  self.id = id
  self.commonParam = param
  if meta.buff_time < 0 then
    self.duration = nil
  else
    self.duration = meta.buff_time
  end
  local pveType = self.logic:GetPVEType()
  self.isPVP = PVPType[pveType]
  self.sourceType = BuffFromSourceType.None
  self.sourceId = 0
end

function BuffBase:SetLv(lv)
  if lv and self.meta.buffLvAddTime > 0 then
    self.duration = self.meta:GetTime(lv)
  end
end

function BuffBase:__delete()
  self:Destroy()
end

function BuffBase:Destroy()
  self.unit = nil
  self.meta = nil
  self.mgr = nil
  self.duration = nil
  self.id = nil
  self.sourceType = nil
  self.sourceId = nil
end

function BuffBase:Update()
  if self.duration then
    self.duration = self.duration - Time.deltaTime
    if self.duration < 0 then
      self:End()
      return
    end
  end
  self:OnUpdate()
end

function BuffBase:Start()
  self.logic:ShowEffectObj(self.meta.active_effect, nil, Quaternion.identity, nil, self.unit:GetBuffTransform(self.meta.buff_path), nil, true)
  self.effectId = nil
  if self.meta.additive_type ~= 2 then
    local trans = self.unit:GetBuffTransform(self.meta.buff_path)
    if self.meta.ignore_rotate then
      if trans then
        self.effectId = self.logic:ShowEffectObj(self.meta.activing_effect, trans.localPosition, Quaternion.identity, 0, trans.parent, nil, true)
      end
    else
      self.effectId = self.logic:ShowEffectObj(self.meta.activing_effect, nil, Quaternion.identity, 0, trans, nil, true)
    end
  end
  self:PlaySound()
  self:OnStart()
  EventManager:GetInstance():Broadcast(EventId.LWBattleBuffStart, self.meta.id)
end

function BuffBase:ReshowActivatingEffect()
  if self.effectId and self.unit and self.meta then
    local trans = self.unit:GetBuffTransform(self.meta.buff_path)
    self.logic:ShowEffectParent(self.effectId, trans)
  end
end

function BuffBase:RemoveActivatingEffect()
  if self.effectId and self.logic then
    self.logic:RemoveEffectObj(self.effectId)
  end
end

function BuffBase:End()
  local cacheId = self.meta.id
  self.logic:RemoveEffectObj(self.effectId)
  self:OnEnd()
  self.mgr:InnerRemoveBuff(self)
  self:Destroy()
  EventManager:GetInstance():Broadcast(EventId.LWBattleBuffEnd, cacheId)
end

function BuffBase:Reset()
  if self.duration then
    self.duration = self.meta.buff_time
  end
  self:PlaySound()
end

function BuffBase:OnStart()
end

function BuffBase:OnEnd()
end

function BuffBase:Remove()
  self:OnRemove()
  self:End()
end

function BuffBase:OnRemove()
  if not self.isPVP and self.meta.remove_convert and self.meta.remove_convert > 0 and self.unit and self.unit.buffManager then
    self.unit.buffManager:AddBuff(self.meta.remove_convert, nil, self.lv)
  end
end

function BuffBase:OnUpdate()
end

function BuffBase:PlaySound()
  if self.meta.sound_id_buff and self.meta.sound_id_buff ~= 0 then
    DataCenter.LWSoundManager:PlaySound(self.meta.sound_id_buff, false)
  end
end

function BuffBase:SetBuffFromSourceData(sourceType, sourceId)
  self.sourceType = sourceType
  self.sourceId = sourceId
end

return BuffBase
