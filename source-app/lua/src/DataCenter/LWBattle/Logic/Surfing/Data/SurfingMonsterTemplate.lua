local SurfingMonsterTemplate = BaseClass("SurfingMonsterTemplate")

function SurfingMonsterTemplate:__init()
  self.id = nil
  self.asset = nil
  self.vfx_path = nil
  self.vfxPath = nil
  self.model_size = nil
  self.relation_type = nil
  self.monster_type = nil
  self.para1 = nil
  self.goodsParam = nil
  self.para2 = nil
  self.move_speed = nil
  self.collide_damage = nil
  self.buffType = nil
  self.randomData = nil
  self.para3 = nil
end

function SurfingMonsterTemplate:__delete()
  self.id = nil
  self.asset = nil
  self.vfx_path = nil
  self.vfxPath = nil
  self.model_size = nil
  self.relation_type = nil
  self.monster_type = nil
  self.para1 = nil
  self.goodsParam = nil
  self.para2 = nil
  self.move_speed = nil
  self.collide_damage = nil
  self.buffType = nil
  self.randomData = nil
  self.para3 = nil
end

function SurfingMonsterTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.asset = row:getValue("asset")
  self.vfx_path = row:getValue("vfx_path")
  self.model_size = row:getValue("model_size")
  self.relation_type = row:getValue("relation_type")
  self.monster_type = row:getValue("monster_type")
  self.para1 = row:getValue("para1")
  self.para2 = row:getValue("para2")
  self.move_speed = row:getValue("move_speed")
  self.collide_damage = row:getValue("collide_damage")
  self.para3 = row:getValue("para3")
end

function SurfingMonsterTemplate:GetBuffType()
  if self.buffType == nil then
    local param1 = self.para1
    if param1 and 0 < #param1 then
      local buffType = tonumber(param1[1]) or 0
      self.buffType = buffType
    end
  end
  return self.buffType
end

function SurfingMonsterTemplate:CheckBuffIsUnlock()
  local buffType = self:GetBuffType()
  if buffType and 0 < buffType then
    local p_buffData = DataCenter.LWSurfingDataManager:GetCurrentBuffTemplateByType(buffType)
    if p_buffData and 0 < p_buffData.buff_id then
      local buff_id = p_buffData.buff_id
      return true, buff_id, p_buffData.level
    end
  end
  return false
end

function SurfingMonsterTemplate:GetRandomData()
  if self.randomData == nil then
    local rData = {}
    local para1 = self.para1
    if para1 and 0 < #para1 then
      for _, v in ipairs(para1) do
        if not string.IsNullOrEmpty(v) then
          local arr = string.split(v, ";")
          if arr and 1 < #arr then
            local randomParam = {
              id = tonumber(arr[1]),
              p = tonumber(arr[2])
            }
            table.insert(rData, randomParam)
          end
        end
      end
    end
    self.randomData = rData
  end
  return self.randomData
end

function SurfingMonsterTemplate:GetRandomBuff()
  local rData = self:GetRandomData()
  if rData then
    local sum_p = 0
    local r = math.random(1, 10000)
    local mId, index
    for i, v in ipairs(rData) do
      if v then
        sum_p = sum_p + v.p
        if r <= sum_p then
          mId = v.id
          index = i
          break
        end
      end
    end
    return mId, index
  end
end

function SurfingMonsterTemplate:GetBuff(index)
  if index == 0 then
    Logger.LogError("index = 0")
    return
  end
  local rData = self:GetRandomData()
  if rData then
    local v = rData[index]
    return v and v.id
  end
end

function SurfingMonsterTemplate:RandomOriginal()
  if self.para2 and self.para2 > 0 then
    local random = math.random(1, 10000)
    if random <= self.para2 then
      return true
    end
  end
  return false
end

function SurfingMonsterTemplate:GetEffectData()
  if self.vfxPath == nil then
    local effectDataStr = self.vfx_path
    if string.IsNullOrEmpty(effectDataStr) then
      return
    end
    local arr = string.split(effectDataStr, "|")
    if arr and 1 < #arr then
      self.vfxPath = {
        path = arr[1],
        root = arr[2]
      }
    end
  end
  return self.vfxPath
end

function SurfingMonsterTemplate:GetGoodsParam()
  if self.goodsParam == nil then
    local param1 = self.para1
    if param1 and 1 < #param1 then
      local goodsId = tonumber(param1[1]) or 0
      self.goodsParam = {
        goodsId = goodsId,
        goodsCount = tonumber(param1[2]) or 0
      }
    end
  end
  return self.goodsParam
end

return SurfingMonsterTemplate
