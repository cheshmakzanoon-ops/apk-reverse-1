local CollectionData = BaseClass("CollectionData")

function CollectionData:__init(cfg, collectionMgr)
  self.config = cfg
  self.configId = cfg.id
  self.collectionMgr = collectionMgr
  self._lastHitTime = UITimeManager:GetInstance():GetServerSeconds()
  self.c_resType = cfg.type
  self.c_refreshCD = cfg.refresh_cd
  self.m_curBloodNum = cfg.max_blood
  self.c_maxBloodNum = cfg.max_blood
  self.buffId = cfg.buffId
  self.outBuffRate = cfg.outBuffRate
  self.superRate = cfg.superRate
  self.outSuperBuffRate = cfg.outSuperBuffRate
  self.outGoods = {}
  self.hasOutGoodsBlood = {}
  self.cutCount = 0
  if cfg.extraParaString ~= nil and cfg.extraParaString ~= "" then
    local spl = string.split_ss_array(cfg.extraParaString, "|")
    for k, v in ipairs(spl) do
      local spl2 = string.split_ss_array(v, ";")
      if table.count(spl2) >= 2 then
        local needBlood = tonumber(spl2[1])
        self.outGoods[needBlood] = {}
        local spl3 = string.split_ss_array(spl2[2], "#")
        for k2, v2 in ipairs(spl3) do
          local spl4 = string.split_ii_array(v2, ",")
          if table.count(spl4) >= 2 and 0 < spl4[2] then
            local out = {}
            out.resType = spl4[1]
            out.num = spl4[2]
            table.insert(self.outGoods[needBlood], out)
          end
        end
      end
    end
  end
  if self.collectionMgr.battleLevel:IsCarryType(self.c_resType) and table.count(self.outGoods) == 0 then
    for i = 0, self.c_maxBloodNum - 1 do
      self.outGoods[i] = {
        {
          resType = self.c_resType,
          num = 1
        }
      }
    end
  end
end

function CollectionData:__delete()
end

function CollectionData:GetConfigId()
  return self.configId
end

function CollectionData:GetObjId()
  return self.configId
end

function CollectionData:GetCurBlood()
  return self.m_curBloodNum
end

function CollectionData:GetMaxBlood()
  return self.c_maxBloodNum
end

function CollectionData:GetObj()
  local obj = self.collectionMgr:GetCollectionObject(self.configId)
  return obj
end

function CollectionData:OnCutOnce(attack)
  if self.m_curBloodNum > 0 then
    self._lastHitTime = UITimeManager:GetInstance():GetServerSeconds()
    self.cutCount = self.cutCount + 1
    self.m_curBloodNum = math.max(self.m_curBloodNum - attack, 0)
    local complete = self.m_curBloodNum == 0
    self.collectionMgr.battleLevel:CutOneCollection(self:GetType(), self.configId, self, complete)
    local obj = self.collectionMgr:GetCollectionObject(self.configId)
    if obj then
      obj:OnCutOnce(attack)
    end
  end
end

function CollectionData:BeAttack(hurt)
  if self.m_curBloodNum > 0 then
    self._lastHitTime = UITimeManager:GetInstance():GetServerSeconds()
    self.m_curBloodNum = math.max(self.m_curBloodNum - hurt, 0)
    local obj = self.collectionMgr:GetCollectionObject(self.configId)
    if obj then
      obj:BeAttack(hurt)
    end
  end
end

function CollectionData:OnResetRes()
  self.m_curBloodNum = self.c_maxBloodNum
  self.hasOutGoodsBlood = {}
  local obj = self.collectionMgr:GetCollectionObject(self.configId)
  if obj then
    obj:RefreshCurState()
  end
end

function CollectionData:GetBloodLeftCnt(n)
  self.m_curBloodNum = math.max(self.m_curBloodNum, 0)
  return self.m_curBloodNum
end

function CollectionData:OnUpdate()
end

function CollectionData:CheckRecover(serverSeconds)
  if self.m_curBloodNum == self.c_maxBloodNum or self.c_refreshCD <= 0 then
    return
  end
  if serverSeconds - self._lastHitTime > self.c_refreshCD then
    self.m_curBloodNum = self.c_maxBloodNum
    self:OnResetRes()
  end
end

function CollectionData:Destroy()
end

function CollectionData:GetType()
  return self.c_resType
end

function CollectionData:GetPosition()
  return self.config.t
end

function CollectionData:GetOutGoods()
  local result = {}
  for k, v in pairs(self.outGoods) do
    if k >= self.m_curBloodNum and self.hasOutGoodsBlood[k] == nil then
      self.hasOutGoodsBlood[k] = true
      for k1, v1 in ipairs(v) do
        if result[v1.resType] == nil then
          result[v1.resType] = v1.num
        else
          result[v1.resType] = result[v1.resType] + v1.num
        end
      end
    end
  end
  return result
end

function CollectionData:GetNeedPveStamina()
  return DataCenter.PveAtomTemplateManager:GetCostStamina(self:GetType())
end

return CollectionData
