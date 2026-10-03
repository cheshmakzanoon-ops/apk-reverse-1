local LWUIRefundApplicationCtrl = BaseClass("LWUIRefundApplicationCtrl", UIBaseCtrl)

function LWUIRefundApplicationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIRefund)
end

function LWUIRefundApplicationCtrl:InitData()
  self.curSelectOrderId = 0
end

function LWUIRefundApplicationCtrl:SetSelectOrder(orderId)
  self.curSelectOrderId = orderId
end

function LWUIRefundApplicationCtrl:DeSelectOrder()
  self.curSelectOrderId = 0
end

function LWUIRefundApplicationCtrl:GetSelectOrder()
  return self.curSelectOrderId
end

function LWUIRefundApplicationCtrl:IsSelect(orderId)
  return orderId == self.curSelectOrderId
end

function LWUIRefundApplicationCtrl:RequestRefund()
  if not self.curSelectOrderId or self.curSelectOrderId == 0 then
    return
  end
  local orderId = self.curSelectOrderId
  local refundData = DataCenter.LWRefundManager:GetPayDataByOrderId(orderId)
  if not refundData then
    Logger.LogError("RefundData is nil")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PayRefundRequest, refundData.orderId, refundData.pf)
  self:DeSelectOrder()
end

function LWUIRefundApplicationCtrl:GetItemNum(itemId, rewardType)
  local num = 0
  if rewardType == RewardType.GOODS then
    num = self:GetGoodsNum(itemId)
  elseif rewardType == RewardType.RESOURCE_ITEM then
    num = self:ShowRes(itemId)
  elseif rewardType == RewardType.HERO then
  elseif rewardType == RewardType.Building then
  elseif rewardType == RewardType.GOLD then
    num = LuaEntry.Player.gold
  elseif rewardType == RewardType.ALLIANCE_GIFT then
  elseif rewardType == RewardType.DragonWorldPoint then
  end
  return num
end

function LWUIRefundApplicationCtrl:GetGoodsNum(itemId)
  local haveCount = 0
  if itemId ~= nil then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil then
      if goods.type == GOODS_TYPE.GOODS_TYPE_146 then
        haveCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
      elseif goods.linked_item_type ~= ItemLinkType.None then
        haveCount = self:GetGoodsLinkItemCount(goods.linked_item_type, goods.linked_item_id)
      else
        haveCount = DataCenter.ItemData:GetItemCount(itemId)
      end
      if goods.type == GOODS_TYPE.GOODS_TYPE_134 then
        haveCount = DataCenter.MasteryManager:GetItemUseCount(itemId)
      end
    end
  end
  return haveCount
end

function LWUIRefundApplicationCtrl:GetGoodsLinkItemCount(linkItemType, linkItemId)
  local haveCount = 0
  if linkItemType == ItemLinkType.RES_ITEM then
    haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(tonumber(linkItemId))
  elseif linkItemType == ItemLinkType.EQUIP then
    local equipList = DataCenter.EquipDataManager:GetAllEquipListByEquipId(linkItemId)
    haveCount = table.count(equipList)
  elseif linkItemType == ItemLinkType.SQUAD_EQUIP then
    local equipList = DataCenter.CommonEquipDataManager:GetAllEquipsByCfgId(linkItemId)
    haveCount = table.count(equipList)
  end
  return haveCount
end

function LWUIRefundApplicationCtrl:ShowRes(itemId)
  return DataCenter.ResourceItemDataManager:GetCountByItemId(tonumber(itemId))
end

return LWUIRefundApplicationCtrl
