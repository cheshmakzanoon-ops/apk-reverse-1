local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_LoesCamp = BaseClass("ResLackItem_LoesCamp", ResLackItemBase)

function ResLackItem_LoesCamp:CheckIsOk(_resType, _needCnt, isResItem)
  self._needCnt = _needCnt
  self.isResItem = isResItem
  self.buildId = tonumber(self._config:getValue("para1"))
  local freeItemData = DataCenter.ItemData:GetItemById(FREE_ITEM_ID)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.buildId))
  if list ~= nil and table.count(list) > 0 then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1].uuid)
    self.template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(tonumber(self.buildId), buildData.level)
    if self.template then
      local strs = string.split(self.template.para1, "|")
      for i = 1, #strs do
        local spls = string.split(strs[i], ";")
        if 2 <= #spls and tonumber(spls[2]) == _resType and freeItemData then
          self.index = i
          self.resType = _resType
          self.scale = tonumber(spls[3])
          return true
        end
      end
    end
  end
  return false
end

function ResLackItem_LoesCamp:GetConsume()
  local useCount = {}
  local param = {}
  param.itemId = FREE_ITEM_ID
  param.rewardType = RewardType.GOODS
  table.insert(useCount, param)
  return useCount
end

function ResLackItem_LoesCamp:TodoAction(pos, isRefresh, lacktab)
  local item1 = {}
  item1.itemId = FREE_ITEM_ID
  local curCount = 0
  if self.isResItem then
    local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.resType)
    if item ~= nil then
      curCount = item.number
    end
  else
    curCount = LuaEntry.Resource:GetCntByResType(self.resType)
  end
  local count = Mathf.Ceil((self._needCnt - curCount) / self.scale)
  if count <= 0 then
    count = 1
  end
  local freeItemData = DataCenter.ItemData:GetItemById(FREE_ITEM_ID)
  if freeItemData then
    if count > freeItemData.count then
      item1.count = freeItemData.count
    else
      item1.count = count
    end
  end
  item1.index = self.index
  item1.rewardType = RewardType.GOODS
  item1.isRefresh = isRefresh
  item1.lacktab = lacktab
  item1.tips = self:GetTips()
  item1.exchangeType = 2
  local item2 = {}
  item2.scale = self.scale
  if self.resType >= ResourceType.ResourceItem then
    item2.rewardType = RewardType.RESOURCE_ITEM
    item2.itemId = self.resType
  else
    item2.rewardType = ResTypeToReward[self.resType]
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceExchange, {anim = true}, nil, 110046, nil, nil, nil, item1, item2)
end

return ResLackItem_LoesCamp
