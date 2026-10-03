local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_UsePaperItem = BaseClass("ResLackItem_UsePaperItem", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_UsePaperItem:CheckIsOk(_resType, _needCnt)
  local para1 = self._config:getValue("para1")
  self.itemData = nil
  local list = string.split(para1, "|")
  for i = 1, #list do
    local item = DataCenter.ItemData:GetItemById(list[i])
    if item then
      self.itemData = item
      return true
    end
  end
  return false
end

function ResLackItem_UsePaperItem:TodoAction()
  if DataCenter.ResourceItemDataManager:CheckIsStorageFull(self.itemData.count) then
    GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = self.itemData.uuid,
    num = self.itemData.count,
    useItemFromType = 0
  })
end

function ResLackItem_UsePaperItem:GetParam()
  return Localization:GetString(121282, self.itemData.count)
end

return ResLackItem_UsePaperItem
