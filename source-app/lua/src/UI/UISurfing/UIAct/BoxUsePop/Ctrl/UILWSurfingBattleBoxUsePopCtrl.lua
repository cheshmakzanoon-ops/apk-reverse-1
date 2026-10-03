local UILWSurfingBattleBoxUsePopCtrl = BaseClass("UILWSurfingBattleBoxUsePopCtrl", UIBaseCtrl)

function UILWSurfingBattleBoxUsePopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingBattleBoxUsePopView)
end

function UILWSurfingBattleBoxUsePopCtrl:UseItem(goodsId, count)
  if not goodsId or not count then
    return
  end
  local itemData = DataCenter.ItemData:GetItemById(goodsId)
  if not itemData or not itemData.goods then
    return
  end
  local template = itemData.goods
  if template.type ~= GOODS_TYPE.GOODS_TYPE_5 and not template:IsSelectBox() then
    return
  end
  if template.type == GOODS_TYPE.GOODS_TYPE_59 and template.popupType == GOODS_POPUP_TYPE.TWSkillChip then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelectTypeTWSkillChip, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, itemData.uuid, count, template)
    return
  end
  if template:IsSelectBox() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, itemData.uuid, count, template)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = itemData.uuid,
    num = count,
    useItemFromType = 0
  })
end

return UILWSurfingBattleBoxUsePopCtrl
