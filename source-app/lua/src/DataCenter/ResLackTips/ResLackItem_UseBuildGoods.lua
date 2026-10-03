local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_UseBuildGoods = BaseClass("ResLackItem_UseBuildGoods", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_UseBuildGoods:CheckIsOk(_resType, _needCnt, isResItem)
  local para1 = self._config:getValue("para1")
  self.itemData = nil
  self._resType = _resType
  self.isResItem = isResItem
  self._needCnt = _needCnt
  local list = string.split(para1, ";")
  for i = 1, #list do
    local item = DataCenter.ItemData:GetItemById(list[i])
    if item then
      self.itemData = item
      return true
    end
  end
  return false
end

function ResLackItem_UseBuildGoods:CheckCount()
  local str = string.split(self.itemData.para1, "|")
  for i = 1, table.count(str) do
    local item = string.split(str[i], ",")
    if item[1] ~= "" and self._resType == tonumber(item[1]) then
      self.scale = tonumber(item[2])
      self.selectIndex = i
    end
  end
end

function ResLackItem_UseBuildGoods:GetConsume()
  local useCount = {}
  local param = {}
  param.itemId = tonumber(self.itemData.itemId)
  param.rewardType = RewardType.GOODS
  table.insert(useCount, param)
  return useCount
end

function ResLackItem_UseBuildGoods:TodoAction(pos, isRefresh, lacktab)
  self:CheckCount()
  local item1 = {}
  item1.itemId = self.itemData.itemId
  local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self._resType)
  local selfNum = 0
  if item ~= nil then
    selfNum = item.number
  end
  local count = Mathf.Ceil((self._needCnt - selfNum) / self.scale)
  if count <= 0 then
    count = 1
  end
  if count > self.itemData.count then
    item1.count = self.itemData.count
  else
    item1.count = count
  end
  item1.rewardType = RewardType.GOODS
  item1.isRefresh = isRefresh
  item1.lacktab = lacktab
  item1.tips = self:GetTips()
  item1.exchangeType = 3
  item1.selectIndex = self.selectIndex
  item1.uuid = self.itemData.uuid
  local item2 = {}
  item2.scale = self.scale
  if self.isResItem then
    item2.rewardType = RewardType.RESOURCE_ITEM
    item2.itemId = self._resType
  else
    item2.rewardType = ResTypeToReward[self._resType]
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceExchange, {anim = true}, nil, 110046, nil, nil, nil, item1, item2)
end

function ResLackItem_UseBuildGoods:GetParam()
  return Localization:GetString(121282, self.itemData.count)
end

return ResLackItem_UseBuildGoods
