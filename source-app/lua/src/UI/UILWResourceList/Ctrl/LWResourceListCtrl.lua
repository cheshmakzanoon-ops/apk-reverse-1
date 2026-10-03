local LWResourceListCtrl = BaseClass("LWResourceListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWResourceListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWResourceList)
end

function LWResourceListCtrl:GetShowTypeTitle(showType)
  if showType == DataCenter.ResourceListManager.ShowType.Resource then
    return Localization:GetString("resource_list_tag1")
  elseif showType == DataCenter.ResourceListManager.ShowType.Material then
    return Localization:GetString("resource_list_tag2")
  end
  return ""
end

function LWResourceListCtrl:GetResourceSpeedCountPerHour(resourceType)
  local res = 0
  local uuids = DataCenter.ProductLineManager:GetBuildUuidsByProductRes(resourceType)
  for k, bUuid in pairs(uuids) do
    local num = DataCenter.ProductLineManager:GetProductRes(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductRes(bUuid))[1]]
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductResItem(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductResItem(bUuid))[1]]
    end
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductGoods(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductGoods(bUuid))[1]]
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData then
      local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
      if BuildingUtils.IsSeasonWeekCardCityBuilding(buildData.itemId) then
        local flag = true
        if buildData.level == 0 then
        else
          local actWeek = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonPeriodicCard.Type)
          if actWeek ~= nil and actWeek.endTime ~= nil then
            local now = UITimeManager:GetInstance():GetServerTime()
            if now < actWeek.endTime then
              local cardId = toInt(actWeek.para)
              local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
              if cardData and cardData:IsBought() then
                flag = false
              end
            else
              flag = false
            end
          end
        end
        if flag then
          buildLevelTemplate = nil
        end
      end
      if buildLevelTemplate then
        local cnt = 3600000 / buildLevelTemplate.produce_time
        local effectValue = 1 + DataCenter.ProductLineManager:GetBuildingWorkerEffect(bUuid) + DataCenter.ProductLineManager:GetAdditionTechnological(buildData)
        res = res + cnt * num * effectValue
      end
    end
  end
  return res
end

function LWResourceListCtrl:GetResourceItemSpeedCountPerHour(resourceType)
  local res = 0
  local uuids = DataCenter.ProductLineManager:GetBuildUuidsByProductResItem(resourceType)
  for k, bUuid in pairs(uuids) do
    local num = DataCenter.ProductLineManager:GetProductRes(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductRes(bUuid))[1]]
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductResItem(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductResItem(bUuid))[1]]
    end
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductGoods(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductGoods(bUuid))[1]]
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData then
      local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
      if buildLevelTemplate then
        local cnt = 3600000 / buildLevelTemplate.produce_time
        local effectValue = 1 + DataCenter.ProductLineManager:GetBuildingWorkerEffect(bUuid) + DataCenter.ProductLineManager:GetAdditionTechnological(buildData)
        res = res + cnt * num * effectValue
      end
    end
  end
  return res
end

function LWResourceListCtrl:GetGoodsSpeedCountPerHour(resourceType)
  local res = 0
  local uuids = DataCenter.ProductLineManager:GetBuildUuidsByProductGoods(resourceType)
  for k, bUuid in pairs(uuids) do
    local num = DataCenter.ProductLineManager:GetProductRes(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductRes(bUuid))[1]]
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductResItem(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductResItem(bUuid))[1]]
    end
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductGoods(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductGoods(bUuid))[1]]
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData then
      local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
      if buildLevelTemplate then
        local cnt = 3600000 / buildLevelTemplate.produce_time
        local effectValue = 1 + DataCenter.ProductLineManager:GetBuildingWorkerEffect(bUuid) + DataCenter.ProductLineManager:GetAdditionTechnological(buildData)
        res = res + cnt * num * effectValue
      end
    end
  end
  return res
end

function LWResourceListCtrl:IsShowSpeedShowTemplate(template)
  if template.type == DataCenter.ResourceListManager.Type.Resource then
    local resourceType = template.resources_id
    local speed = self:GetResourceSpeedCountPerHour(resourceType)
    return 0 < speed
  elseif template.type == DataCenter.ResourceListManager.Type.ResourceItem then
    local resourceItemId = template.resource_item_id
    local speed = self:GetResourceItemSpeedCountPerHour(resourceItemId)
    return 0 < speed
  elseif template.type == DataCenter.ResourceListManager.Type.Goods then
    local itemId = template.goods_id
    local speed = self:GetGoodsSpeedCountPerHour(itemId)
    return 0 < speed
  end
  return false
end

return LWResourceListCtrl
