local PveAtomTemplate = BaseClass("PveAtomTemplate")

function PveAtomTemplate:__init()
  self.id = 0
  self.type = 0
  self.lv = 0
  self.hp = 0
  self.energy_cost = 0
  self.outResource = {}
  self.cutNum = 0
  self.outResItem = {}
end

function PveAtomTemplate:__delete()
  self.id = nil
  self.type = nil
  self.lv = nil
  self.hp = nil
  self.energy_cost = nil
  self.outResource = nil
  self.cutNum = nil
  self.outResItem = nil
end

function PveAtomTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.lv = row:getValue("lv")
  self.hp = row:getValue("hp")
  self.energy_cost = row:getValue("energy_cost")
  self.outResource = {}
  local resource = row:getValue("resource")
  if not string.IsNullOrEmpty(resource) then
    local spl = string.split_ss_array(resource, "|")
    for k, v in ipairs(spl) do
      local spl1 = string.split_ii_array(v, ";")
      if 2 <= #spl1 then
        local param = {}
        param.resourceType = spl1[1]
        param.count = spl1[2]
        table.insert(self.outResource, param)
      end
    end
  end
  self.cutNum = tonumber(row:getValue("num")) or 1
  self.outResItem = {}
  local outResItemStr = row:getValue("resource_item")
  if not string.IsNullOrEmpty(outResItemStr) then
    local strs = string.split(outResItemStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local param = {}
        param.itemId = tonumber(spls[1])
        param.count = tonumber(spls[2])
        table.insert(self.outResItem, param)
      end
    end
  end
end

function PveAtomTemplate:GetEffectOutResourceNum()
  local result = 0
  if self.type == PveAtomType.Tree then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_ATTACK_WOOD_OUT_NUM)
  elseif self.type == PveAtomType.Stone then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_ATTACK_STONE_OUT_NUM)
  end
  return result
end

return PveAtomTemplate
