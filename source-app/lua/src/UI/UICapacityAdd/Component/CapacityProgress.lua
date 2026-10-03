local CapacityProgress = BaseClass("CapacityProgress", UIBaseContainer)
local base = UIBaseContainer
local this_path = "capacity"
local slider_path = "capacity/slider"
local item_icon_path = "capacity/item_icon"
local capacity_num_path = "capacity/itemNum"
local icon_obj_path = "iconObj"
local capacityShowTime = 300
local capacityHideTime = 3000

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

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.resource_icon = self:AddComponent(UIImage, item_icon_path)
  self.slider_num = self:AddComponent(UIText, capacity_num_path)
  self.icon_obj = self:AddComponent(UIBaseContainer, icon_obj_path)
  self.transform.gameObject:SetActive(false)
  local ret, time = self.animator:GetAnimationReturnTime("capacity_hide_up")
  if ret then
    self.animatorTime = time * 1000
  else
    self.animatorTime = 0
  end
end

local function ComponentDestroy(self)
  self.animatorTime = nil
  self.animator = nil
  self.slider = nil
  self.resource_icon = nil
  self.slider_num = nil
end

local function DataDefine(self)
  self.storageMax = 0
  self.storage = 0
  self.pro = 0
  self.isShow = false
  self.endTime = 0
  self.deltaPro = 0
  self.isShowAnimUpdate = false
  self.flyEffectStartCount = 0
  self.isLast = false
  self.itemId = 0
  self.hideTime = 0
end

local function DataDestroy(self)
  self.storageMax = nil
  self.storage = nil
  self.pro = nil
  self.isShow = nil
  self.endTime = nil
  self.deltaPro = nil
  self.isShowAnimUpdate = nil
  self.flyEffectStartCount = nil
  self.isLast = nil
  self.hideTime = nil
end

local function ShowCapacity(self, resourceType)
  self.itemType = resourceType
  self.flyEffectStartCount = self.flyEffectStartCount + 1
  if self.isShow == false then
    self.transform.gameObject:SetActive(true)
    if self.itemType == ResourceItemType.Farming then
      local icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_icon_cold"
      self.resource_icon:LoadSprite(icon)
      self.storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
    else
      local icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_icon_multiple"
      self.resource_icon:LoadSprite(icon)
      self.storageMax = DataCenter.ResourceItemDataManager.warehouseStorageMax
    end
    self.storage = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(self.itemType)
    self.slider_num:SetText(self.storage .. "/" .. math.floor(self.storageMax))
    self.pro = math.min(1, self.storage / math.max(1, self.storageMax))
    self.slider:SetValue(self.pro)
    self.isShow = true
    self.isLast = false
    self.animator:Play("capacity_show_up", 0, 0)
  end
end

local function AddResourceItem(self, num)
  if self.isShow then
    self.storage = self.storage + num
    local willPro = math.min(1, self.storage / math.max(1, self.storageMax))
    self.slider_num:SetText(self.storage .. "/" .. math.floor(self.storageMax))
    local startTime = UITimeManager:GetInstance():GetServerTime()
    self.endTime = startTime + capacityShowTime
    self.deltaPro = willPro - self.pro
    self.isShowAnimUpdate = true
    self.animator:Play("capacity_add", 0, 0)
    self.flyEffectStartCount = self.flyEffectStartCount - 1
    self.hideTime = self.endTime + capacityHideTime + self.animatorTime
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function Update(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isShowAnimUpdate then
    local changeTime = self.endTime - curTime
    if 0 < changeTime then
      local changePro = changeTime / capacityShowTime
      local pro = 1 - changePro
      local sliderPro = self.pro + pro * self.deltaPro
      self.slider:SetValue(sliderPro)
    else
      self.isShowAnimUpdate = false
      self.pro = self.pro + self.deltaPro
    end
  end
  if 0 >= self.flyEffectStartCount then
    local deltaTime = self.hideTime - curTime
    if deltaTime <= self.animatorTime and self.isLast == false then
      self.animator:Play("capacity_hide_up", 0, 0)
      self.isLast = true
      self.isShow = false
    elseif deltaTime <= 0 then
      self.view:DestroyCapacityItemByItemId(self.itemId)
    end
  end
end

local function GetCapacityPos(self)
  if self.isShow then
    return self.icon_obj.transform.position
  end
end

CapacityProgress.OnDestroy = OnDestroy
CapacityProgress.OnCreate = OnCreate
CapacityProgress.ComponentDefine = ComponentDefine
CapacityProgress.ComponentDestroy = ComponentDestroy
CapacityProgress.DataDefine = DataDefine
CapacityProgress.DataDestroy = DataDestroy
CapacityProgress.Update = Update
CapacityProgress.OnEnable = OnEnable
CapacityProgress.OnDisable = OnDisable
CapacityProgress.GetCapacityPos = GetCapacityPos
CapacityProgress.AddResourceItem = AddResourceItem
CapacityProgress.ShowCapacity = ShowCapacity
return CapacityProgress
