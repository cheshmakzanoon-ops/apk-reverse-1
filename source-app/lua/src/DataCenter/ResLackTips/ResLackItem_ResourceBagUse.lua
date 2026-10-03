local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_ResourceBagUse = BaseClass("ResLackItem_ResourceBagUse", ResLackItemBase)
local MaxFlyNum = 5

function ResLackItem_ResourceBagUse:CheckIsOk(_resType, _needCnt, isResItem)
  self._resType = _resType
  self._needCnt = _needCnt
  self.isResItem = isResItem
  local para1 = self._config:getValue("para1")
  local str = string.split(para1, ";")
  for i = 1, #str do
    local item = DataCenter.ItemData:GetItemById(tonumber(str[i]))
    if item then
      self.itemId = tonumber(str[i])
      return true
    end
  end
  return false
end

function ResLackItem_ResourceBagUse:GetConsume()
  self.useCount = {}
  local selfNum = 0
  if self._resType == ResourceType.Metal then
    selfNum = LuaEntry.Resource.metal
  elseif self._resType == ResourceType.Wood then
    selfNum = LuaEntry.Resource.wood
  elseif self._resType == ResourceType.Water then
    selfNum = LuaEntry.Resource.water
  elseif self._resType == ResourceType.Food then
    selfNum = LuaEntry.Resource.money
  elseif self._resType == ResourceType.Electricity then
    selfNum = LuaEntry.Resource.electricity
  elseif self.isResItem then
    local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self._resType)
    if item ~= nil then
      selfNum = item.number
    end
  end
  local needNum = self._needCnt - selfNum
  if needNum <= 0 then
    needNum = 1
  end
  local item = DataCenter.ItemData:GetItemById(self.itemId)
  if item then
    local param = {}
    param.uuid = item.uuid
    param.itemId = item.itemId
    param.para2 = tonumber(item.para2)
    param.rewardType = RewardType.GOODS
    local all = tonumber(item.para2) * item.count
    local value1 = all - needNum
    if 0 < value1 then
      param.count = item.count - Mathf.Floor((all - needNum) / tonumber(item.para2))
    else
      param.count = item.count
    end
    table.insert(self.useCount, param)
  end
  return self.useCount
end

function ResLackItem_ResourceBagUse:GetCount()
  local allNum = 0
  for i = 1, #self.useCount do
    allNum = self.useCount[i].para2 * self.useCount[i].count + allNum
  end
  return allNum
end

function ResLackItem_ResourceBagUse:TodoAction(pos, isRefresh, lacktab)
  self:GetConsume()
  local item1 = {}
  item1.itemId = self.useCount[1].itemId
  item1.count = self.useCount[1].count
  item1.rewardType = RewardType.GOODS
  item1.isRefresh = isRefresh
  item1.lacktab = lacktab
  item1.tips = self:GetTips()
  item1.exchangeType = 1
  local item2 = {}
  if self._resType >= ResourceType.ResourceItem then
    item2.rewardType = RewardType.RESOURCE_ITEM
    item2.itemId = self._resType
  else
    item2.rewardType = ResTypeToReward[self._resType]
  end
  item2.scale = self.useCount[1].para2
  if self.useCount[1].count <= 0 then
    self.useCount[1].count = 1
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceExchange, {anim = true}, nil, 110046, nil, nil, nil, item1, item2)
end

return ResLackItem_ResourceBagUse
