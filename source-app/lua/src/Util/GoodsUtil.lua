local GoodsUtil = {}

local function GetGoodsReturnItemCount(goodsId, returnItemId)
  local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if not goodsTemplate then
    return 0
  end
  local type = goodsTemplate.type
  if type == GOODS_TYPE.GOODS_TYPE_109 then
    local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goodsTemplate.para1), DataCenter.BuildManager.MainLv, tonumber(goodsTemplate.para2))
    local perGainCount = returnItem.count * tonumber(goodsTemplate.para3)
    return perGainCount
  elseif type == GOODS_TYPE.GOODS_TYPE_3 then
    return tonumber(goodsTemplate.para2)
  elseif type == GOODS_TYPE.GOODS_TYPE_59 and goodsTemplate.popupType == GOODS_POPUP_TYPE.Hero and goodsTemplate.tipsType == GOODS_TIPS_TYPE.BoxTag then
    local List = string.split(goodsTemplate.para1, "|")
    for i = 1, #List do
      local item = string.split(List[i], ",")
      if not returnItemId or tonumber(item[2]) == returnItemId then
        return tonumber(item[3])
      end
    end
  else
    local List = string.split(goodsTemplate.para1, "|")
    for i = 1, #List do
      local item = string.split(List[i], ",")
      if not returnItemId or tonumber(item[1]) == returnItemId then
        return tonumber(item[2])
      end
    end
  end
  return 0
end

GoodsUtil.GetGoodsReturnItemCount = GetGoodsReturnItemCount
return ConstClass("GoodsUtil", GoodsUtil)
