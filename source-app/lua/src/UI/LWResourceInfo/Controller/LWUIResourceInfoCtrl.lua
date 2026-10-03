local LWUIResourceInfoCtrl = BaseClass("LWUIResourceInfoCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWResourceInfo, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function LWUIResourceInfoCtrl:GetTotalConvertNum(resType, lackTemplates)
  local res = 0
  if not table.IsNullOrEmpty(lackTemplates) then
    for i, template in pairs(lackTemplates) do
      if template.tips == LWResourceLackGetWay.UseItem then
        local items = DataCenter.ItemData:GetItemById(template.para1)
        if items then
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
          local itemCount = items and items.count or 0
          local itemType = itemTemplate.type
          if itemType == GOODS_TYPE.GOODS_TYPE_109 then
            local perGainCount = self:GetPerGainCount(resType, itemType, itemTemplate)
            if perGainCount and 0 < perGainCount then
              res = res + perGainCount * itemCount
            end
          elseif not itemTemplate:IsSelectBox() then
            local type = tonumber(itemTemplate.type)
            local give
            if type == GOODS_TYPE.GOODS_TYPE_3 then
              give = tonumber(items.para2) or 0
            else
              give = tonumber(items.para1) or 0
            end
            if give and 0 < give then
              res = res + give * itemCount
            end
          end
        end
      end
    end
  end
  return res
end

function LWUIResourceInfoCtrl:GetTotalConvertNumSelect(resType, lackTemplates)
  local res = 0
  if not table.IsNullOrEmpty(lackTemplates) then
    for i, template in pairs(lackTemplates) do
      if template.tips == LWResourceLackGetWay.UseItem then
        local items = DataCenter.ItemData:GetItemById(template.para1)
        if items then
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
          local itemCount = items and items.count or 0
          local itemType = itemTemplate.type
          local isSelectItem = itemTemplate:IsSelectBox()
          if isSelectItem then
            local perGainCount = self:GetPerGainCount(resType, itemType, itemTemplate)
            if perGainCount and 0 < perGainCount then
              res = res + perGainCount * itemCount
            end
          end
        end
      end
    end
  end
  return res
end

function LWUIResourceInfoCtrl:GetPerGainCount(resType, lackType, template)
  if template and template:IsSelectBox() and not template:IsGuarantBox() then
    local List = string.split(template.para1, "|")
    local options = {}
    local optionsIndices = {}
    for i = 1, #List do
      local item = string.split(List[i], ",")
      options[tonumber(item[1])] = tonumber(item[2])
      optionsIndices[tonumber(item[1])] = i
    end
    local templates = {}
    templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
    if templates then
      for i = 1, #templates do
        local lackTemplate = templates[i]
        local para1Num = tonumber(lackTemplate.para1)
        if para1Num and (lackTemplate.tips == LWResourceLackGetWay.UseItem or lackTemplate.tips == LWResourceLackGetWay.DecoSelfSelectItem) and options[para1Num] then
          local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para1Num)
          local perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(goodsTemplate.id, resType)
          return perGainItemCount * options[para1Num]
        end
      end
    end
  else
    return GoodsUtil.GetGoodsReturnItemCount(template.id, resType)
  end
end

function LWUIResourceInfoCtrl:IsShowSelectConvert(resType)
  if resType == ResourceType.Food then
    return true
  elseif resType == ResourceType.Metal then
    return true
  elseif resType == ResourceType.Wood then
    return true
  end
  return false
end

LWUIResourceInfoCtrl.CloseSelf = CloseSelf
LWUIResourceInfoCtrl.Close = Close
return LWUIResourceInfoCtrl
