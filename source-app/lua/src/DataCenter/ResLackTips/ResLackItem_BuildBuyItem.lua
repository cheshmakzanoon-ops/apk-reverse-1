local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_BuildBuyItem = BaseClass("ResLackItem_BuildBuyItem", ResLackItemBase)
local MaxFlyNum = 5
local Localization = CS.GameEntry.Localization

function ResLackItem_BuildBuyItem:CheckIsOk(_itemId, _count)
  self.lackItems = {}
  table.insert(self.lackItems, {itemId = _itemId, count = _count})
  return true
end

function ResLackItem_BuildBuyItem:TodoAction(pos)
  if LuaEntry.Player.gold >= self.allPrice then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(self.allPrice), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(self.lackItems[1].itemId)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:ConfirmBuy(self.needCount, pos)
    end, function()
    end)
  else
    GoToUtil.GotoPayTips(self.allPrice)
  end
end

function ResLackItem_BuildBuyItem:GetBtnName()
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.lackItems[1].itemId)
  local list = template.sales
  local own = 0
  local item = DataCenter.ItemData:GetItemById(self.lackItems[1].itemId)
  if item ~= nil then
    own = item.count
  end
  self.needCount = self.lackItems[1].count - own
  self.allPrice = list[1].price * self.needCount
  return self.allPrice
end

function ResLackItem_BuildBuyItem:GetBuyNum()
  return self.needCount
end

function ResLackItem_BuildBuyItem:ConfirmBuy(count, pos)
  local item = {}
  item[tostring(self.lackItems[1].itemId)] = count
  SFSNetwork.SendMessage(MsgDefines.BuyItemAndResource, nil, item)
  local showCount = count > MaxFlyNum and MaxFlyNum or count
  local flyEndPos = UIUtil.GetResourcePos(self.lackItems[1].itemId)
  if flyEndPos == nil then
    flyEndPos = Vector3.New(0, 0, 0)
  end
  UIUtil.DoFly(RewardType.GOODS, showCount, DataCenter.ItemTemplateManager:GetIconPath(self.lackItems[1].itemId), pos, flyEndPos)
end

return ResLackItem_BuildBuyItem
