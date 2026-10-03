local ResourceItemDataManager = BaseClass("ResourceItemDataManager")
local Localization = CS.GameEntry.Localization
local ERROR_GET_ITEM_TIME_GAP = 10000

local function __init(self)
  self.itemList = {}
  self.freezerStorageMax = 0
  self.warehouseStorageMax = 0
  self.freezerProtectMax = 0
  self.warehouseProtectMax = 0
  self.needSellConfirm = true
  self.itemTemplateDic = {}
  self.itemTemplateTypeList = {}
  EventManager:GetInstance():AddListener(EventId.EffectNumChange, self.UpdateMaxValueSignal)
  self.maxErrorMessageFlag = false
  self.lastGetResourceItemTime = 0
end

local function __delete(self)
  EventManager:GetInstance():RemoveListener(EventId.EffectNumChange, self.UpdateMaxValueSignal)
  self.itemList = {}
  self.freezerStorageMax = 0
  self.warehouseStorageMax = 0
  self.freezerProtectMax = 0
  self.warehouseProtectMax = 0
  self.needSellConfirm = true
  self.itemTemplateDic = {}
  self.itemTemplateTypeList = {}
  self.maxErrorMessageFlag = false
  self.lastGetResourceItemTime = 0
end

local function Startup()
end

local function GetResourceItemTemplate(self, id)
  if self.itemTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.Aps_Resource_Item, id)
    if oneTemplate ~= nil then
      local item = ResourceItemTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.itemTemplateDic[item.id] = item
      end
    end
  end
  return self.itemTemplateDic[tonumber(id)]
end

local function RefreshItemList(self, message)
  local list = message.resource_items
  self.soldierDataChanged = false
  if list ~= nil then
    table.walk(list, function(k, v)
      self:RefreshOneItem(v)
    end)
    EventManager:GetInstance():Broadcast(EventId.RefreshResourceItem)
  end
  if self.soldierDataChanged then
    EventManager:GetInstance():Broadcast(EventId.SoldierDataChanged)
    self.soldierDataChanged = false
  end
end

local function InitRefreshItemList(self, message)
  self.itemList = {}
  RefreshItemList(self, message)
end

local function GetSellConfirmFlag(self)
  return self.needSellConfirm
end

local function SetSellConfirmFlag(self, value)
  self.needSellConfirm = value
end

local function RefreshOneItem(self, data)
  if data ~= nil then
    local uuid = data.uuid
    if uuid ~= nil then
      local itemData = self.itemList[uuid]
      if itemData ~= nil then
        itemData:RefreshData(data)
        if itemData.number <= 0 then
          self.itemList[uuid] = nil
          itemData = nil
        end
      else
        itemData = ResourceItemData.New()
        itemData:InitData(data)
        if itemData.number > 0 then
          self.itemList[uuid] = itemData
        end
      end
      if itemData ~= nil and itemData.template and (itemData.template.type == ResourceItemRealType.Soldier or itemData.template.type == ResourceItemRealType.DragonSoldier or itemData.template.type == ResourceItemRealType.MummySoldier) then
        self.soldierDataChanged = true
      end
      self:TryShowGiftGetPopup(itemData, data.addNum)
    end
  end
end

function ResourceItemDataManager:TryShowGiftGetPopup(itemData, addNum)
  if not (itemData and itemData.template and addNum) or addNum <= 0 then
    return
  end
  if itemData.template.type == ResourceItemRealType.MasterExp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUITCExpGet, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, itemData.itemId, addNum)
  end
end

local function GetItemDataByUuid(self, uuid)
  return self.itemList[uuid]
end

local function GetItemDataByItemId(self, itemId)
  local oneData
  for k, v in pairs(self.itemList) do
    if v.itemId == itemId then
      oneData = v
      break
    end
  end
  return oneData
end

local function AddItemNum(self, itemId, num)
  for _, v in pairs(self.itemList) do
    if v.itemId == itemId then
      v.number = v.number + num
      EventManager:GetInstance():Broadcast(EventId.RefreshResourceItem)
      break
    end
  end
end

local function UpdateMaxValueSignal(self, data)
  DataCenter.ResourceItemDataManager:UpdateResourceItemMaxValue()
end

local function UpdateResourceItemMaxValue(self)
  self.freezerStorageMax = LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_MAX_LIMIT) + LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_ADD) + LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
  self.freezerProtectMax = 0
  self.warehouseStorageMax = LuaEntry.Effect:GetGameEffect(EffectDefine.WAREHOUSE_STORAGE_MAX_LIMIT)
  self.warehouseProtectMax = LuaEntry.Effect:GetGameEffect(EffectDefine.WAREHOUSE_PROTECT_MAX_LIMIT)
end

local function GetFreezerStorageMax(self, withoutExtra)
  self.freezerStorageMax = LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_MAX_LIMIT) + LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_ADD) + LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
  if not withoutExtra then
    return math.floor(self.freezerStorageMax)
  else
    return math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_MAX_LIMIT) + LuaEntry.Effect:GetGameEffect(EffectDefine.FREEZER_STORAGE_ADD))
  end
end

local function GetResourceItemTotalNumByType(self, type)
  local num = 0
  if self.itemList then
    table.walk(self.itemList, function(k, v)
      if v.itemType == type then
        num = num + v.number
      end
    end)
  end
  return num
end

local function GetResourceItemListByTypeFromTemplate(self, type)
  local itemTemplateTypeList = {}
  LocalController:instance():visitTable(TableName.Aps_Resource_Item, function(id, lineData)
    local item = ResourceItemTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil and item.itemType == type then
      local isUnlock = self:ResourceItemShowInCapacity(item)
      if isUnlock then
        table.insert(itemTemplateTypeList, item.id)
      end
      if self.itemTemplateDic[item.id] == nil then
        self.itemTemplateDic[item.id] = item
      end
    end
  end)
  return itemTemplateTypeList
end

local function ResourceItemShowInCapacity(self, item)
  return item and item:ShowInCapacity()
end

local function ResourceItemCanBuyInOrder(self, itemId)
  local template = self:GetResourceItemTemplate(itemId)
  return template ~= nil and template.price_diamond > 0
end

local function GetResourceItemBuyPriceTotal(self, itemId, needNum)
  local template = self:GetResourceItemTemplate(itemId)
  if template == nil then
    return false, 0, 0
  end
  local hasNum = self:GetCountByItemId(itemId)
  if needNum > hasNum then
    if 0 >= template.price_diamond then
      return false, 0, 0
    end
    return true, math.ceil(template.price_diamond * (needNum - hasNum)), needNum - hasNum
  end
  return true, 0, 0
end

local function CheckResourceItemNum(self, itemId, needNum)
  local template = self:GetResourceItemTemplate(itemId)
  if template == nil then
    return false
  end
  local data = self:GetItemDataByItemId(itemId)
  local hasNum = 0
  if data ~= nil then
    hasNum = data.number
  end
  if needNum > hasNum then
    return false
  end
  return true
end

local function GetAllLackResourceItemParams(self, allItems, action, closeAction)
  local all = {}
  local lackItems = {}
  local result = true
  local totalDiamond = 0
  for k, v in pairs(allItems) do
    local tmpResult, tmpPrice, tmpNum = self:GetResourceItemBuyPriceTotal(k, v)
    totalDiamond = totalDiamond + tmpPrice
    if tmpResult == false then
      result = false
      break
    end
    if 0 < tmpNum then
      lackItems[k] = tmpNum
    end
  end
  all.canBuy = result
  all.totalDiamond = totalDiamond
  all.lackItems = lackItems
  all.action = action
  all.closeAction = closeAction
  return all
end

local function CheckIsStorageFull(self, addCount)
  return false
end

local function DoWhenStorageMaxError(self)
  if self.maxErrorMessageFlag ~= false then
    return
  end
  self.maxErrorMessageFlag = true
  local now = UITimeManager:GetInstance():GetServerTime()
  self.lastGetResourceItemTime = now
  SFSNetwork.SendMessage(MsgDefines.UserGetAllResourceItem)
end

local function DoWhenStorageMaxErrorHandle(self, message)
  self.maxErrorMessageFlag = false
  self:RefreshItemList(message)
end

local function CanSendQueueFinishBatchMessage(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - self.lastGetResourceItemTime > ERROR_GET_ITEM_TIME_GAP then
    self.maxErrorMessageFlag = false
  end
  if self.maxErrorMessageFlag ~= false then
    return false
  end
  return true
end

local function IsHaveCanShopResourceItem(self, type)
  local template
  for k, v in pairs(self.itemList) do
    if v.itemType == type and v.number > 0 then
      template = self:GetResourceItemTemplate(v.itemId)
      if template ~= nil and template.show == ResourceItemShowType.Show then
        return true
      end
    end
  end
  return false
end

local function GetCountByItemId(self, id)
  local info = self:GetItemDataByItemId(id)
  if info ~= nil then
    return info.number
  end
  return 0
end

local function GetIconPath(self, itemId)
  local template = self:GetResourceItemTemplate(itemId)
  if template == nil or template.pic == nil then
    return ""
  end
  return string.format(LoadPath.ItemPath, template.pic)
end

local function GetName(self, itemId)
  local template = self:GetResourceItemTemplate(itemId)
  if template == nil or template.name == nil then
    return ""
  end
  return Localization:GetString(template.name)
end

local function GetDes(self, itemId)
  local template = self:GetResourceItemTemplate(itemId)
  if template == nil or template.name == nil then
    return ""
  end
  return Localization:GetString(template.desc)
end

local function GetLeftStorageNum(self)
  return self:GetFreezerStorageMax() - self:GetResourceItemTotalNumByType(ResourceItemType.Farming)
end

local function GetMaxNumItem(self)
  local itemId
  local num = 0
  for k, v in pairs(self.itemList) do
    if num < v.number then
      num = v.number
      itemId = v.itemId
    end
  end
  if itemId then
    return itemId
  end
end

local function GetAllTemplate(self)
  return self.itemTemplateDic
end

local function GetResourceItemCountByTempalteType(self, type)
  local count = 0
  table.walk(self.itemList, function(k, v)
    if v.template ~= nil and v.template.type == type then
      count = count + v.number
    end
  end)
  return count
end

local function GetResourceItemQuality(self, id)
  local template = self:GetResourceItemTemplate(id)
  if template == nil then
    return 0
  end
  return template.quality
end

local function GetHeroExpCount(self)
  return self:GetCountByItemId(ResourceItemId.HeroExp)
end

function ResourceItemDataManager:RemoveItemByItemId(itemId)
  local itemData = self:GetItemDataByItemId(itemId)
  if itemData ~= nil then
    local uuid = itemData.uuid
    self.itemList[uuid] = nil
  end
end

function ResourceItemDataManager:GetItemUuidsByItemId(itemId)
  local list = {}
  for _, v in pairs(self.itemList) do
    if v.itemId == itemId then
      table.insert(list, v.uuid)
    end
  end
  return list
end

function ResourceItemDataManager:RemoveItemByUuid(uuid)
  self.itemList[uuid] = nil
end

ResourceItemDataManager.__init = __init
ResourceItemDataManager.__delete = __delete
ResourceItemDataManager.Startup = Startup
ResourceItemDataManager.RefreshItemList = RefreshItemList
ResourceItemDataManager.InitRefreshItemList = InitRefreshItemList
ResourceItemDataManager.GetItemDataByUuid = GetItemDataByUuid
ResourceItemDataManager.GetItemDataByItemId = GetItemDataByItemId
ResourceItemDataManager.AddItemNum = AddItemNum
ResourceItemDataManager.UpdateResourceItemMaxValue = UpdateResourceItemMaxValue
ResourceItemDataManager.UpdateMaxValueSignal = UpdateMaxValueSignal
ResourceItemDataManager.GetResourceItemTemplate = GetResourceItemTemplate
ResourceItemDataManager.GetResourceItemListByTypeFromTemplate = GetResourceItemListByTypeFromTemplate
ResourceItemDataManager.RefreshOneItem = RefreshOneItem
ResourceItemDataManager.GetResourceItemTotalNumByType = GetResourceItemTotalNumByType
ResourceItemDataManager.GetSellConfirmFlag = GetSellConfirmFlag
ResourceItemDataManager.SetSellConfirmFlag = SetSellConfirmFlag
ResourceItemDataManager.GetFreezerStorageMax = GetFreezerStorageMax
ResourceItemDataManager.ResourceItemShowInCapacity = ResourceItemShowInCapacity
ResourceItemDataManager.ResourceItemCanBuyInOrder = ResourceItemCanBuyInOrder
ResourceItemDataManager.GetResourceItemBuyPriceTotal = GetResourceItemBuyPriceTotal
ResourceItemDataManager.CheckResourceItemNum = CheckResourceItemNum
ResourceItemDataManager.GetAllLackResourceItemParams = GetAllLackResourceItemParams
ResourceItemDataManager.CheckIsStorageFull = CheckIsStorageFull
ResourceItemDataManager.DoWhenStorageMaxError = DoWhenStorageMaxError
ResourceItemDataManager.DoWhenStorageMaxErrorHandle = DoWhenStorageMaxErrorHandle
ResourceItemDataManager.CanSendQueueFinishBatchMessage = CanSendQueueFinishBatchMessage
ResourceItemDataManager.IsHaveCanShopResourceItem = IsHaveCanShopResourceItem
ResourceItemDataManager.GetCountByItemId = GetCountByItemId
ResourceItemDataManager.GetIconPath = GetIconPath
ResourceItemDataManager.GetName = GetName
ResourceItemDataManager.GetDes = GetDes
ResourceItemDataManager.GetLeftStorageNum = GetLeftStorageNum
ResourceItemDataManager.GetMaxNumItem = GetMaxNumItem
ResourceItemDataManager.GetAllTemplate = GetAllTemplate
ResourceItemDataManager.GetResourceItemCountByTempalteType = GetResourceItemCountByTempalteType
ResourceItemDataManager.GetResourceItemQuality = GetResourceItemQuality
ResourceItemDataManager.GetHeroExpCount = GetHeroExpCount
return ResourceItemDataManager
