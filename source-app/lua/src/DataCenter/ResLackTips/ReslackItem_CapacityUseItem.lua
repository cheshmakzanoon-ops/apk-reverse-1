local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_CapacityUseItem = BaseClass("ReslackItem_CapacityUseItem", ResLackItemBase)

function ReslackItem_CapacityUseItem:CheckIsOk(_resType, _needCnt)
  local para1 = self._config:getValue("para1")
  local list = string.split(para1, "|")
  for i = 1, #list do
    local item = DataCenter.ItemData:GetItemById(list[i])
    if item then
      self.itemID = list[i]
      return true
    end
  end
  return false
end

function ReslackItem_CapacityUseItem:TodoAction()
  GoToUtil.GoBagPackUseItem(self.itemID)
end

return ReslackItem_CapacityUseItem
