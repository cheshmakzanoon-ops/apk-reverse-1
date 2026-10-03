local UICapacityTipCtrl = BaseClass("UICapacityTipCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTip, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function __init(self)
  self.currentItemNum = nil
end

local function __delete(self)
  self.currentItemNum = nil
end

local function CheckMax(self, num, maxNum)
  local final = math.min(num, maxNum)
  if final < 0 then
    final = 0
  end
  return final
end

local function OnSoldClick(self, uuid, num, itemId)
  if self.currentItemNum == nil then
    self.currentItemNum = 0
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByUuid(uuid)
    if itemData ~= nil then
      self.currentItemNum = itemData.number
    end
  end
  if self.currentItemNum == 0 then
    self:CloseSelf()
    return
  end
  local needConfirm = DataCenter.ResourceItemDataManager:GetSellConfirmFlag()
  needConfirm = false
  local resourceItemConfig = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
  if resourceItemConfig == nil then
    return
  end
  if needConfirm then
    local title = ""
    local str = Localization:GetString(resourceItemConfig.name) .. "x" .. string.GetFormattedSeperatorNum(num)
    local content = Localization:GetString("128004", str)
    UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
      SFSNetwork.SendMessage(MsgDefines.SoldResourceItem, uuid, num)
    end, function(needSellConfirm)
      DataCenter.ResourceItemDataManager:SetSellConfirmFlag(needSellConfirm)
    end, nil, nil, true)
  else
    SFSNetwork.SendMessage(MsgDefines.SoldResourceItem, uuid, num)
  end
  self.currentItemNum = self.currentItemNum - num
  if self.currentItemNum <= 0 then
    self:CloseSelf()
    return
  end
end

local function DoGetItem(self, itemId)
  GoToUtil.GotoColdStorage(itemId)
  self.CloseSelf()
end

local function DoResourceClick(self, resourceType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, {anim = true}, resourceType)
  self.CloseSelf()
end

local function GetIconAndDesc(self, tabType, id)
  local result = {}
  if tabType == UICapacityTableTab.Resource then
    result.pic = DataCenter.ResourceManager:GetResourceIconByType(id)
    result.itemName = CommonUtil.GetResourceNameByType(id)
    result.desc = CommonUtil.GetResourceDescriptionByType(id)
  else
    local itemList = DataCenter.ResourceItemDataManager:GetResourceItemListByTypeFromTemplate(tabType)
    if itemList ~= nil then
      for k, v in ipairs(itemList) do
        if id == v then
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v)
          if template ~= nil then
            result.pic = template.pic
            result.itemName = Localization:GetString(template.name)
            result.desc = Localization:GetString(template.desc)
          end
          break
        end
      end
    end
  end
  return result
end

local function GetResourceItemData(self, uuid)
  local data = {}
  data.uuid = uuid
  local itemData = DataCenter.ResourceItemDataManager:GetItemDataByUuid(uuid)
  if itemData ~= nil then
    data.itemId = itemData.itemId
    data.maxNum = itemData.number
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemData.itemId)
    if template ~= nil then
      data.itemName = template.name
      data.price = template.price
      data.desc = template.desc
      data.pic = template.pic
      data.discard = template.discard
      data.use_type = template.use_type
      data.activity_discard = template.activity_discard
      data.condition_discard = template.condition_discard
      data.price = DataCenter.HeroStationManager:CalcEffectedValue(data.price, HeroStationEffectType.GlobalMoney)
      data.price = Mathf.Round(data.price)
    end
  end
  return data
end

local function IsSell(self)
  return LuaEntry.DataConfig:CheckSwitch("purchase_product")
end

UICapacityTipCtrl.CloseSelf = CloseSelf
UICapacityTipCtrl.Close = Close
UICapacityTipCtrl.CheckMax = CheckMax
UICapacityTipCtrl.OnSoldClick = OnSoldClick
UICapacityTipCtrl.GetResourceItemData = GetResourceItemData
UICapacityTipCtrl.GetIconAndDesc = GetIconAndDesc
UICapacityTipCtrl.DoResourceClick = DoResourceClick
UICapacityTipCtrl.DoGetItem = DoGetItem
UICapacityTipCtrl.__init = __init
UICapacityTipCtrl.__delete = __delete
UICapacityTipCtrl.IsSell = IsSell
return UICapacityTipCtrl
