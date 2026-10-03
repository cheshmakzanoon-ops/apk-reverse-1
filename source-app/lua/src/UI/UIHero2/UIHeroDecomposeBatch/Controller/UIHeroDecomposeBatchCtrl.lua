local UIHeroDecomposeBatchCtrl = BaseClass("UIHeroDecomposeBatchCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDecomposeBatch)
end

local function IsItemCanDecomposeBatch(self, itemTemplate)
  if itemTemplate == nil then
    return false
  end
  local heroId = toInt(itemTemplate.para2)
  local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
  if string.IsNullOrEmpty(hasHero) then
    return false
  end
  return not HeroUtils.IsCommonHeroDebris(itemTemplate.id)
end

local function Decompose(self, types)
  local type99Items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_99)
  local result = {}
  table.walk(type99Items, function(k, v)
    if v ~= nil and v.count > 0 then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if itemTemplate ~= nil then
        local heroId = toInt(itemTemplate.para2)
        if not self:IsItemCanDecomposeBatch(itemTemplate) then
          return
        end
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        if types[rarity] ~= nil then
          result[v.itemId] = v.count
        end
      end
    end
  end)
  if table.count(result) > 0 then
    SFSNetwork.SendMessage(MsgDefines.HeroDecomposePiece, result)
    self.CloseSelf()
  end
end

local function GetDecomposeNum(self, types)
  local type99Items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_99)
  local num = 0
  table.walk(type99Items, function(k, v)
    if v ~= nil and v.count > 0 then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if itemTemplate ~= nil then
        local heroId = toInt(itemTemplate.para2)
        if not self:IsItemCanDecomposeBatch(itemTemplate) then
          return
        end
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        if types[rarity] ~= nil and not string.IsNullOrEmpty(itemTemplate.para3) then
          local para3 = string.split(itemTemplate.para3, "|")
          if para3 ~= nil and #para3 == 2 then
            num = num + v.count * toInt(para3[2])
          end
        end
      end
    end
  end)
  return num
end

local function GetDecomposeItemNumByRarity(self, rarity)
  local type99Items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_99)
  local result = 0
  table.walk(type99Items, function(k, v)
    if v ~= nil and v.count > 0 then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if itemTemplate ~= nil then
        local heroId = toInt(itemTemplate.para2)
        if not self:IsItemCanDecomposeBatch(itemTemplate) then
          return
        end
        local tmpRarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        if tmpRarity == rarity then
          result = result + v.count
        end
      end
    end
  end)
  return result
end

UIHeroDecomposeBatchCtrl.CloseSelf = CloseSelf
UIHeroDecomposeBatchCtrl.Decompose = Decompose
UIHeroDecomposeBatchCtrl.GetDecomposeNum = GetDecomposeNum
UIHeroDecomposeBatchCtrl.GetDecomposeItemNumByRarity = GetDecomposeItemNumByRarity
UIHeroDecomposeBatchCtrl.IsItemCanDecomposeBatch = IsItemCanDecomposeBatch
return UIHeroDecomposeBatchCtrl
