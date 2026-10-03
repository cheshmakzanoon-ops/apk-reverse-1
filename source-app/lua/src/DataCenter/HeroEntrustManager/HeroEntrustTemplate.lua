local HeroEntrustTemplate = BaseClass("HeroEntrustTemplate")

function HeroEntrustTemplate:__init()
  self.id = 0
  self.Description = 0
  self.Npc_Model = ""
  self.Position = {}
  self.Npc_Pic = ""
  self.need = {}
  self.Reward_hero_fake = ""
  self.dub = ""
end

function HeroEntrustTemplate:__delete()
  self.id = 0
  self.Description = 0
  self.Npc_Model = ""
  self.Position = {}
  self.Npc_Pic = ""
  self.need = {}
  self.Reward_hero_fake = ""
  self.dub = ""
end

function HeroEntrustTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.Description = row:getValue("Description")
  self.Npc_Model = row:getValue("Npc_Model")
  self.Position = row:getValue("Position")
  self.Npc_Pic = row:getValue("Npc_Pic")
  self.dub = row:getValue("dub")
  self.Reward_hero_fake = row:getValue("Reward_hero_fake")
  self.need = {}
  local Demand = row:getValue("Demand")
  if Demand ~= nil and Demand ~= "" then
    local spl = string.split_ss_array(Demand, "|")
    for k, v in ipairs(spl) do
      local spl2 = string.split_ii_array(v, ";")
      if table.count(spl2) > 2 then
        local need = {}
        need.needType = spl2[1]
        need.needId = spl2[2]
        need.count = spl2[3]
        table.insert(self.need, need)
      end
    end
  end
end

function HeroEntrustTemplate:GetTilePosition()
  if self.Position ~= nil and table.count(self.Position) > 1 then
    local vec = {}
    vec.x = DataCenter.BuildManager.main_city_pos.x + self.Position[1]
    vec.y = DataCenter.BuildManager.main_city_pos.y + self.Position[2]
    return vec
  end
end

function HeroEntrustTemplate:GetPosition()
  return SceneUtils.TileToWorld(self:GetTilePosition())
end

function HeroEntrustTemplate:GetOwnCountByIndex(index)
  local ownNum = 0
  local need = self.need[index]
  if need ~= nil then
    if need.needType == HeroEntrustNeedType.ResourceItem then
      local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(need.needId)
      if data ~= nil then
        ownNum = data.number
      end
    elseif need.needType == HeroEntrustNeedType.Resource then
      ownNum = LuaEntry.Resource:GetCntByResType(need.needId)
    elseif need.needType == HeroEntrustNeedType.Goods then
      local data = DataCenter.ItemData:GetItemById(need.needId)
      if data ~= nil then
        ownNum = data.count
      end
    end
  end
  return ownNum
end

function HeroEntrustTemplate:HaveEnoughGoods(index)
  if DataCenter.HeroEntrustManager:IsCompleteByIndex(self.id, index) then
    return true
  end
  local need = self.need[index]
  if need ~= nil then
    return self:GetOwnCountByIndex(index) >= need.count
  end
  return false
end

function HeroEntrustTemplate:IsSubmit()
  local info = DataCenter.HeroEntrustManager:GetHeroEntrustById(self.id)
  if info ~= nil and not info:IsAllComplete() then
    for k, v in ipairs(self.need) do
      if not self:HaveEnoughGoods(k) then
        return false
      end
    end
    return true
  end
  return false
end

return HeroEntrustTemplate
