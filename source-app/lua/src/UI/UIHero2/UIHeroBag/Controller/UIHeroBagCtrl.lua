local UIHeroBagCtrl = BaseClass("UIHeroBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroBag)
end

local function GetPanelData(self, showRarity)
  local type99Items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_99)
  local allItems = {}
  table.walk(type99Items, function(k, v)
    local itemId = toInt(v.itemId)
    local count = DataCenter.ItemData:GetItemCount(itemId)
    if 0 < count then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), toInt(itemTemplate.para2))
      if heroConfig == nil or 0 < showRarity and heroConfig.rarity ~= showRarity then
        return
      end
      local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(toInt(itemTemplate.para2))
      if not string.IsNullOrEmpty(hasHero) then
        local param = {}
        param.itemId = itemId
        param.count = count
        if not string.IsNullOrEmpty(itemTemplate.para3) then
          local para3 = string.split(itemTemplate.para3, "|")
          if para3 ~= nil and #para3 == 2 then
            param.exchangeMedalId = toInt(para3[1])
            param.exchangeMedalNum = toInt(para3[2])
            table.insert(allItems, param)
          end
        end
      end
    end
  end)
  table.sort(allItems, function(k, v)
    local item1 = DataCenter.ItemTemplateManager:GetItemTemplate(k.itemId)
    local heroConfigA = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), toInt(item1.para2))
    local item2 = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
    local heroConfigB = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), toInt(item2.para2))
    if heroConfigA == nil or heroConfigB == nil then
      return false
    end
    return heroConfigA.rarity < heroConfigB.rarity
  end)
  local allCommonDebris = HeroUtils.GetAllCommonHeroDebris()
  for k, v in pairs(allCommonDebris) do
    local count = DataCenter.ItemData:GetItemCount(k)
    if 0 < count then
      local param = {}
      param.itemId = toInt(k)
      param.count = count
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
      local para3 = string.split(itemTemplate.para3, "|")
      if para3 ~= nil and #para3 == 2 then
        param.exchangeMedalId = toInt(para3[1])
        param.exchangeMedalNum = toInt(para3[2])
        table.insert(allItems, param)
      end
    end
  end
  local result = {}
  local row = math.ceil(#allItems / HeroBagCellNumPerLine)
  for k = 1, row do
    local startIndex = HeroBagCellNumPerLine * (k - 1) + 1
    local endIndex = math.min(startIndex + HeroBagCellNumPerLine - 1, #allItems)
    local rowData = {
      table.unpack(allItems, startIndex, endIndex)
    }
    table.insert(result, rowData)
  end
  return result
end

UIHeroBagCtrl.CloseSelf = CloseSelf
UIHeroBagCtrl.GetPanelData = GetPanelData
return UIHeroBagCtrl
