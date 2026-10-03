local UILWTWSkillChipUpgradeCtrl = BaseClass("UILWTWSkillChipUpgradeCtrl", UIBaseCtrl)
local ItemType = {Goods = 1, Chip = 2}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipUpgrade)
end

local function RefreshChipDataList(chipInfo)
  local resultList = {}
  local goodsDict = {}
  local chipDict = {}
  local expItems = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_135)
  for _, v in pairs(expItems) do
    local itemInfo = {}
    itemInfo.type = ItemType.Goods
    itemInfo.data = v
    table.insert(resultList, itemInfo)
    local uuid = v.uuid
    goodsDict[uuid] = itemInfo
  end
  local equipDataList = DataCenter.TWSkillChipManager:GetAllChips()
  for _, v in pairs(equipDataList) do
    if v.uuid ~= chipInfo.uuid and not (v:GetStar() > 0) and not (v:GetQuality() >= ItemColor.ORANGE) and v:IsFree() then
      local itemInfo = {}
      itemInfo.type = ItemType.Chip
      itemInfo.data = v
      table.insert(resultList, itemInfo)
      local uuid = v.uuid
      chipDict[uuid] = itemInfo
    end
  end
  table.sort(resultList, function(a, b)
    if a.type ~= b.type then
      return a.type < b.type
    end
    if a.type == ItemType.Goods and a.data and b.data then
      return a.data.goods.quality < b.data.goods.quality
    end
    if a.type == ItemType.Chip then
      if a.data:GetQuality() ~= b.data:GetQuality() then
        return a.data:GetQuality() < b.data:GetQuality()
      end
      if a.data:GetLevel() ~= b.data:GetLevel() then
        return a.data:GetLevel() < b.data:GetLevel()
      end
      if a.data:GetType() ~= b.data:GetType() then
        return a.data:GetType() < b.data:GetType()
      end
      if a.data:GetId() ~= b.data:GetId() then
        return a.data:GetId() < b.data:GetId()
      end
    end
    return a.data.uuid < b.data.uuid
  end)
  return resultList, goodsDict, chipDict
end

UILWTWSkillChipUpgradeCtrl.CloseSelf = CloseSelf
UILWTWSkillChipUpgradeCtrl.RefreshChipDataList = RefreshChipDataList
return UILWTWSkillChipUpgradeCtrl
