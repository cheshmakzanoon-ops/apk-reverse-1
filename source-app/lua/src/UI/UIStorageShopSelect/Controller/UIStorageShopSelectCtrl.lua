local UIStorageShopSelectCtrl = BaseClass("UIStorageShopSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStorageShopSelect)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetStorageContents(self)
  local retTb = {}
  local itemList = DataCenter.ResourceItemDataManager:GetResourceItemListByTypeFromTemplate(UICapacityTableTab.Farming)
  if itemList and 0 < #itemList then
    table.sort(itemList, function(a, b)
      local task1 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(a)
      local task2 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(b)
      return task1 ~= nil and task2 ~= nil and task2.order > task1.order
    end)
  end
  for k, v in ipairs(itemList) do
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v)
    if itemData ~= nil and 0 < itemData.number then
      local param = {}
      param.itemId = v
      param.tabType = UICapacityTableTab.Farming
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v)
      if template ~= nil and template.show == 1 and template.type == 0 then
        param.icon_name = template.pic
        param.name = template.name
        param.quality_name = "Common_img_quality_green"
        param.itemType = template.itemType
        param.redState = true
        table.insert(retTb, param)
      end
    end
  end
  return retTb
end

UIStorageShopSelectCtrl.CloseSelf = CloseSelf
UIStorageShopSelectCtrl.Close = Close
UIStorageShopSelectCtrl.GetStorageContents = GetStorageContents
return UIStorageShopSelectCtrl
