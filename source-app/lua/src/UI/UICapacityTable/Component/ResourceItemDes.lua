local ResourceItemDes = BaseClass("ResourceItemDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_quality_path = "ResourceItem/item_quality"
local item_icon_path = "ResourceItem/item_icon"
local item_name_path = "item_name"
local own_des_path = "own_des"
local protect_des_path = "protect_des"
local protect_num_path = "protect_des/protect_num"
local des_txt_path = "des_txt"
local slider_path = "Slider"
local pro_txt_path = "pro_txt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.item_name = self:AddComponent(UIText, item_name_path)
  self.own_des = self:AddComponent(UIText, own_des_path)
  self.protect_des = self:AddComponent(UIText, protect_des_path)
  self.protect_num = self:AddComponent(UIText, protect_num_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.pro_txt = self:AddComponent(UIText, pro_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.item_name = nil
  self.own_des = nil
  self.protect_des = nil
  self.protect_num = nil
  self.des_txt = nil
  self.pro_txt = nil
  self.slider = nil
end

local function DataDefine(self)
  self.param = {}
  self.itemId = 0
end

local function DataDestroy(self)
  self.param = nil
  self.itemId = nil
end

local function RefreshData(self)
  self.itemId = self.view.ctrl:GetCurrentItemId()
  self.param = self.view.ctrl:GetItemDataByItemId(self.itemId)
  self.item_icon:LoadSprite(string.format(LoadPath.CommonNewPath, self.param.icon_name))
  self.item_quality:LoadSprite(string.format(LoadPath.ItemPath, self.param.quality_name))
  self.item_name:SetLocalText(self.param.name)
  self.own_des:SetText(Localization:GetString(GameDialogDefine.CAPACITY) .. ": ")
  self.protect_des:SetText(Localization:GetString(GameDialogDefine.PROTECT_CAPACITY) .. ": ")
  local storageMax = 0
  local curNum = 0
  local protectMax = 0
  local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.itemId)
  if itemData ~= nil then
    curNum = itemData.number
  end
  if self.param.itemType == UICapacityTableTab.Farming then
    storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
    protectMax = DataCenter.ResourceItemDataManager.freezerProtectMax
  else
    storageMax = DataCenter.ResourceItemDataManager.warehouseStorageMax
    protectMax = DataCenter.ResourceItemDataManager.warehouseProtectMax
  end
  self.pro_txt:SetText(tostring(curNum) .. "/" .. math.floor(storageMax))
  local percent = curNum / math.max(1, storageMax)
  self.slider:SetValue(percent)
  self.protect_num:SetText(math.floor(protectMax))
  self.des_txt:SetLocalText(self.param.des)
end

ResourceItemDes.OnCreate = OnCreate
ResourceItemDes.OnDestroy = OnDestroy
ResourceItemDes.OnEnable = OnEnable
ResourceItemDes.OnDisable = OnDisable
ResourceItemDes.ComponentDefine = ComponentDefine
ResourceItemDes.ComponentDestroy = ComponentDestroy
ResourceItemDes.DataDefine = DataDefine
ResourceItemDes.DataDestroy = DataDestroy
ResourceItemDes.RefreshData = RefreshData
return ResourceItemDes
