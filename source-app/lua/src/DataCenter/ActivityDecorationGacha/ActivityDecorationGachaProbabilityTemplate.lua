local ActivityDecorationGachaProbabilityTemplate = BaseClass("ActivityDecorationGachaProbabilityTemplate")

function ActivityDecorationGachaProbabilityTemplate:__init()
  self.id = 0
  self.groupId = 0
  self.type = 0
  self.color = 0
  self.para1 = 0
  self.num = 0
  self.dropShow = 0
  self.order = 0
  self.decorationBuildingId = 0
  self.decorationBuildingNum = 0
  self.decorationBuildingBaseId = 0
  self.decorationBuildingTemplate = nil
  self.itemTemplate = nil
end

function ActivityDecorationGachaProbabilityTemplate:__delete()
  self.id = nil
  self.groupId = nil
  self.type = nil
  self.color = nil
  self.para1 = nil
  self.num = nil
  self.dropShow = nil
  self.order = nil
  self.decorationBuildingId = nil
  self.decorationBuildingNum = nil
  self.decorationBuildingTemplate = nil
  self.itemTemplate = nil
  self.decorationBuildingBaseId = nil
end

function ActivityDecorationGachaProbabilityTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupId = tonumber(row:getValue("group_id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.color = tonumber(row:getValue("color")) or 0
  self.para1 = tonumber(row:getValue("para1")) or 0
  self.num = tonumber(row:getValue("num")) or 0
  self.dropShow = tonumber(row:getValue("drop_show")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.para1)
  if self.itemTemplate ~= nil and not string.IsNullOrEmpty(self.itemTemplate.para1) then
    local line = LocalController:instance():getLine(TableName.RewardConfig, self.itemTemplate.para1)
    if line ~= nil then
      local buildingStr = tostring(line:getValue("building")) or ""
      if not string.IsNullOrEmpty(buildingStr) then
        local pair = string.split(buildingStr, ";")
        if #pair == 2 then
          local buildingId = checknumber(pair[1])
          local buildingNum = checknumber(pair[2])
          if 0 < buildingId and 0 < buildingNum then
            self.decorationBuildingId = buildingId
            self.decorationBuildingBaseId = buildingId - buildingId % BuildLevelCap
            self.decorationBuildingNum = buildingNum
            self.decorationBuildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingId)
          end
        end
      end
    end
  end
end

function ActivityDecorationGachaProbabilityTemplate:GetItemImagePath()
  return DataCenter.RewardManager:GetPicByType(self.itemType, self.itemId)
end

function ActivityDecorationGachaProbabilityTemplate:GetDecorationBaseImage()
  return BuildingUtils.GetDecoratorBookBg(self.color)
end

function ActivityDecorationGachaProbabilityTemplate:GetDecorationImage()
  return DataCenter.BuildManager:GetBuildIconPath(self.decorationBuildingId, 0)
end

function ActivityDecorationGachaProbabilityTemplate:GetItemBaseImagePath()
  if self.itemTemplate ~= nil then
    if self.itemTemplate.quality == 1 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg1.png"
    end
    if self.itemTemplate.quality == 2 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg2.png"
    end
    if self.itemTemplate.quality == 3 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
    end
  end
  return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
end

function ActivityDecorationGachaProbabilityTemplate:GetItemType()
  if self.decorationBuildingTemplate ~= nil then
    return DataCenter.ActivityDecorationGachaManager.ItemType.Decoration
  end
  return DataCenter.ActivityDecorationGachaManager.ItemType.Goods
end

function ActivityDecorationGachaProbabilityTemplate:GetDecorationQuality()
  if self.decorationBuildingTemplate ~= nil then
    return tonumber(self.decorationBuildingTemplate.para3)
  end
  return 0
end

function ActivityDecorationGachaProbabilityTemplate:GetGoodsQuality()
  if self.itemTemplate ~= nil then
    return self.itemTemplate.color
  end
  return 0
end

return ActivityDecorationGachaProbabilityTemplate
