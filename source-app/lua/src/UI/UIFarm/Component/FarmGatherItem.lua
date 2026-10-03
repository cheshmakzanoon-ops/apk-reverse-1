local FarmGatherItem = BaseClass("FarmGatherItem", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local img_path = "icon"
local gray_path = "Gray"
local lack_icon_path = "lackIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.gray_image = self:AddComponent(UIImage, gray_path)
  self.gray = self.gray_image:GetMaterial()
  self.lack_icon = self:AddComponent(UIImage, lack_icon_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
end

local function OnDestroy(self)
  self.event_trigger = nil
  self.gray_image = nil
  self.gray = nil
  self.lack_icon = nil
  self.img = nil
  self.unlock_obj = nil
  self.lock_obj = nil
  self.item_name = nil
  self.need_num = nil
  self.need_icon = nil
  self.lack_icon = nil
  self.need_num = nil
  self.lock_des = nil
  base.OnDestroy(self)
end

local function OnDrag(self, eventData)
  self.view:OnDragItem(eventData, self.data)
end

local function OnBeginDrag(self, eventData)
  local checkState = true
  if self.data.unlock_type ~= nil then
    if self.data.unlock_type == TemplateUnlockType.Build then
      checkState = self.view.ctrl:CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
    elseif self.data.unlock_type == TemplateUnlockType.Science then
      checkState = self.view.ctrl:CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
    end
  end
  if self.data.farmState == FarmStateType.Harvest or self.data.farmState == FarmStateType.HarvestSecond then
    self.view:OnBeginDragItem(eventData, self.data)
  elseif checkState then
    if self.view.ctrl:CheckIsResourceEnough(self.data.needResourceType, self.data.needResourceNum, 1) and self.view.ctrl:CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum, 1) then
      self.view:OnBeginDragItem(eventData, self.data)
    else
      self.animator:Play("farm_tip_shake", 0, 0)
    end
  end
end

local function OnEndDrag(self, eventData)
  self.view:OnEndDragItem(eventData, self.data)
end

local function OnPointerDown(self, eventData)
  if self.data ~= nil then
    local posX = self.img.transform.position.x
    self.view:OnHoldItem(self.data, posX)
  end
end

local function OnPointerUp(self, eventData)
  self.view:OnCancelItem()
end

local function OnEnable(self)
  base.OnEnable(self)
  self.animator:Play("CellChangeDefault", 0, 0)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.data = data
  if self.data ~= nil then
    local checkState = true
    if self.data.unlock_type ~= nil then
      if self.data.unlock_type == TemplateUnlockType.Build then
        checkState = self.view.ctrl:CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
      elseif self.data.unlock_type == TemplateUnlockType.Science then
        checkState = self.view.ctrl:CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
      end
    end
    self.img:LoadSprite(self.data.icon)
    if checkState == false then
      self.img:SetMaterial(self.gray)
      self.lack_icon:SetActive(false)
    else
      if self.view.ctrl:CheckIsResourceEnough(self.data.needResourceType, self.data.needResourceNum, 1) == false or self.view.ctrl:CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum, 1) == false then
        self.lack_icon:SetActive(true)
      else
        self.lack_icon:SetActive(false)
      end
      self.img:SetMaterial(nil)
    end
  end
end

local function DoEnterAnim(self)
  self.animator:Play("CellChange", 0, 0)
end

FarmGatherItem.OnDestroy = OnDestroy
FarmGatherItem.OnCreate = OnCreate
FarmGatherItem.OnEnable = OnEnable
FarmGatherItem.OnDisable = OnDisable
FarmGatherItem.OnDrag = OnDrag
FarmGatherItem.OnBeginDrag = OnBeginDrag
FarmGatherItem.OnEndDrag = OnEndDrag
FarmGatherItem.OnPointerDown = OnPointerDown
FarmGatherItem.OnPointerUp = OnPointerUp
FarmGatherItem.RefreshData = RefreshData
FarmGatherItem.DoEnterAnim = DoEnterAnim
return FarmGatherItem
