local UILWGuarantBoxCtrl = BaseClass("UILWGuarantBoxCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWGuarantBox)
end

local function UseItem(self, goodsId, count)
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

local function FilterDataByShowType(curGoodsList, goodsList)
  local list = {}
  local dict = {}
  if curGoodsList then
    for i = 1, #curGoodsList do
      dict[curGoodsList[i].id] = true
    end
  end
  for i = 1, #goodsList do
    if dict[goodsList[i].id] then
      list[#list + 1] = goodsList[i]
    elseif goodsList[i].showType == GuaranteedBoxGoodsShowType.Always then
      list[#list + 1] = goodsList[i]
    elseif goodsList[i].showType == GuaranteedBoxGoodsShowType.ShowWhenHave then
      local count = DataCenter.ItemData:GetItemCount(goodsList[i].id)
      if 0 < count then
        list[#list + 1] = goodsList[i]
      end
    end
  end
  return list
end

UILWGuarantBoxCtrl.CloseSelf = CloseSelf
UILWGuarantBoxCtrl.UseItem = UseItem
UILWGuarantBoxCtrl.FilterDataByShowType = FilterDataByShowType
return UILWGuarantBoxCtrl
