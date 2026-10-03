local ActivityDecorationGachaItemData = BaseClass("ActivityDecorationGachaItemData")
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaItemData:__init()
  self.itemId = 0
  self.itemNum = 0
  self.itemType = 0
  self.decorationBuildingId = 0
  self.decorationBuildingNum = 0
  self.decorationBuildingBaseId = 0
  self.itemTemplate = nil
  self.decorationBuildingTemplate = nil
  self.order = 0
  self.crit = 0
end

function ActivityDecorationGachaItemData:__delete()
  self.itemId = nil
  self.itemNum = nil
  self.itemType = nil
  self.decorationBuildingId = nil
  self.decorationBuildingNum = nil
  self.itemTemplate = nil
  self.decorationBuildingTemplate = nil
  self.order = nil
  self.decorationBuildingBaseId = nil
  self.crit = nil
end

function ActivityDecorationGachaItemData:InitData(data)
  if data == nil then
    return
  end
  if data.reward ~= nil and data.reward[1] ~= nil then
    if data.reward[1].type ~= nil then
      self.itemType = data.reward[1].type
    end
    if data.reward[1].value ~= nil then
      self.itemId = tonumber(data.reward[1].value.id)
      self.itemNum = tonumber(data.reward[1].value.num)
    end
    if data.pos ~= nil then
      self.order = tonumber(data.pos)
    end
    if data.crit ~= nil then
      self.crit = tonumber(data.crit)
    end
  end
  self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
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
            self.decorationBuildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.decorationBuildingBaseId)
          end
        end
      end
    end
  end
end

function ActivityDecorationGachaItemData:InitDataByItemId(itemId, itemNum)
  self.itemId = itemId
  self.itemNum = itemNum
  self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if self.itemTemplate ~= nil then
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
            self.decorationBuildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.decorationBuildingBaseId)
          end
        end
      end
    end
  end
end

function ActivityDecorationGachaItemData:GetOrder()
  return self.order
end

function ActivityDecorationGachaItemData:GetItemImagePath()
  return DataCenter.RewardManager:GetPicByType(self.itemType, self.itemId)
end

function ActivityDecorationGachaItemData:GetSegmentItemBaseImagePath()
  if self.itemTemplate ~= nil then
    if self.itemTemplate.quality == 5 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg1.png"
    end
    if self.itemTemplate.quality == 4 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg2.png"
    end
    if self.itemTemplate.quality == 3 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
    end
  end
  return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
end

function ActivityDecorationGachaItemData:GetWishBaseImagePath()
  local quality = self:GetDecorationQuality()
  if quality == 5 then
    return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_choujiang_bg5.png"
  end
  if quality == 4 then
    return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_choujiang_bg6.png"
  end
  if quality == 3 then
    return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_choujiang_bg7.png"
  end
  return ""
end

function ActivityDecorationGachaItemData:GetItemType()
  if self.decorationBuildingTemplate ~= nil then
    return DataCenter.ActivityDecorationGachaManager.ItemType.Decoration
  end
  return DataCenter.ActivityDecorationGachaManager.ItemType.Goods
end

function ActivityDecorationGachaItemData:GetDecorationBaseImage()
  return BuildingUtils.GetDecoratorBookBg(self:GetDecorationQuality())
end

function ActivityDecorationGachaItemData:GetDecorationQuality()
  if self.decorationBuildingTemplate ~= nil then
    return tonumber(self.decorationBuildingTemplate.para3)
  end
  return 0
end

function ActivityDecorationGachaItemData:GetGoodsQuality()
  if self.itemTemplate ~= nil then
    return self.itemTemplate.color
  end
  return 0
end

function ActivityDecorationGachaItemData:GetDecorationImage()
  if self.decorationBuildingId > 0 then
    return DataCenter.BuildManager:GetBuildIconPath(self.decorationBuildingId, 0)
  end
  return ""
end

function ActivityDecorationGachaItemData:GetDecorationName()
  if self.decorationBuildingTemplate ~= nil then
    return Localization:GetString(self.decorationBuildingTemplate.name)
  end
  return ""
end

function ActivityDecorationGachaItemData:IsDecorationBuildMaxOrUpgradeItemMax()
  if self.decorationBuildingTemplate ~= nil then
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.decorationBuildingBaseId, true)
    if buildData ~= nil and buildData.level >= self.decorationBuildingTemplate.max_level then
      return true
    end
    local hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(self.decorationBuildingBaseId, self.decorationBuildingTemplate.max_level, false)
    if needCountWithoutGlue <= hasCount then
      return true
    end
  end
  return false
end

return ActivityDecorationGachaItemData
