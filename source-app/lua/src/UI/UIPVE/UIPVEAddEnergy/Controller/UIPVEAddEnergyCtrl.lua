local UIPVEAddEnergyCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAddEnergy)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetItemList(self)
  local showList = {}
  local list, list1 = DataCenter.ItemData:GetResourceItem(GOODS_TYPE2.PVEEnergy)
  if list ~= nil and 0 < #list then
    table.sort(list, function(a, b)
      local goodsTemplate1 = a
      local goodsTemplate2 = b
      if goodsTemplate1 == nil then
        return false
      elseif goodsTemplate2 == nil then
        return true
      elseif goodsTemplate1.order > goodsTemplate2.order then
        return false
      elseif goodsTemplate1.order < goodsTemplate2.order then
        return true
      else
        local id1 = tonumber(a.id)
        local id2 = tonumber(b.id)
        if id1 > id2 then
          return true
        elseif id1 < id2 then
          return false
        end
      end
      return false
    end)
    for i = 1, #list do
      local param = {}
      param.btnType = UIResourceBagBtnType.Buy
      param.template = list[i]
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      param.index = i
      table.insert(showList, 1, param)
    end
  end
  if list1 ~= nil and 0 < #list1 then
    table.sort(list, function(a, b)
      local goodsTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
      local goodsTemplate2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
      if goodsTemplate1 == nil then
        return false
      elseif goodsTemplate2 == nil then
        return true
      elseif goodsTemplate1.order > goodsTemplate2.order then
        return false
      elseif goodsTemplate1.order < goodsTemplate2.order then
        return true
      else
        local id1 = tonumber(a.itemId)
        local id2 = tonumber(b.itemId)
        if id1 > id2 then
          return true
        elseif id1 < id2 then
          return false
        end
      end
      return false
    end)
    for i = 1, #list1 do
      local param = {}
      param.template = DataCenter.ItemTemplateManager:GetItemTemplate(list1[i].itemId)
      param.btnType = UIResourceBagBtnType.Use
      param.count = list1[i].count
      for k, v in ipairs(showList) do
        if list1[i].itemId == v.template.id then
          table.remove(showList, k)
          break
        end
      end
      table.insert(showList, 1, param)
    end
  end
  return showList
end

UIPVEAddEnergyCtrl.CloseSelf = CloseSelf
UIPVEAddEnergyCtrl.Close = Close
UIPVEAddEnergyCtrl.GetItemList = GetItemList
return UIPVEAddEnergyCtrl
