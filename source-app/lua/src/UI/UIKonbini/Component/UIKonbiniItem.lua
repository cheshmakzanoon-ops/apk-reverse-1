local UIKonbiniItem = BaseClass("UIKonbiniItem", UIBaseContainer)
local base = UIBaseContainer
local top_icon_path = "Root/TopIcon"
local middle_icon_path = "Root/MiddleIcon"
local count_path = "Root/Count"
local buy_path = "Root/Buy"
local free_path = "Root/Buy/FreeText"
local exchange_icon_path = "Root/Buy/ExchangeIcon"
local exchange_desc_path = "Root/Buy/ExchangeText"
local exchange_count_path = "Root/Buy/ExchangeCount"
local FREE_ITEM_ID = 200031
local State = {
  Normal = 1,
  Free = 2,
  Locked = 3,
  CostItem = 4
}

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
  self.btn = self:AddComponent(UIButton, buy_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.top_icon_image = self:AddComponent(UIImage, top_icon_path)
  self.middle_icon_image = self:AddComponent(UIImage, middle_icon_path)
  self.count_text = self:AddComponent(UIText, count_path)
  self.free_text = self:AddComponent(UIText, free_path)
  self.free_text:SetLocalText(130126)
  self.exchange_icon_image = self:AddComponent(UIImage, exchange_icon_path)
  self.exchange_desc_text = self:AddComponent(UIText, exchange_desc_path)
  self.exchange_desc_text:SetLocalText(110029)
  self.exchange_count_text = self:AddComponent(UIText, exchange_count_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.top_icon_image = nil
  self.middle_icon_image = nil
  self.count_text = nil
  self.free_text = nil
  self.exchange_icon_image = nil
  self.exchange_desc_text = nil
  self.exchange_count_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  local topIcon, middleIcon = "", ""
  if data.resType then
    topIcon = string.format(LoadPath.UIKonbiniRes, data.resType)
    middleIcon = DataCenter.ResourceManager:GetResourceIconByType(data.resType)
  elseif data.resItemId then
    topIcon = string.format(LoadPath.UIKonbiniResItem, data.resItemId)
    middleIcon = DataCenter.ResourceItemDataManager:GetIconPath(data.resItemId)
  end
  self.top_icon_image:LoadSprite(icon)
  self.middle_icon_image:LoadSprite(middleIcon)
  self.count_text:SetText(data.count)
  if data.state == State.Normal then
    self.btn:SetActive(true)
    self.free_text:SetActive(false)
    self.exchange_icon_image:SetActive(true)
    self.exchange_icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    self.exchange_desc_text:SetActive(true)
    self.exchange_count_text:SetActive(true)
    self.exchange_count_text:SetText(data.cost)
  elseif data.state == State.Free then
    self.btn:SetActive(true)
    self.free_text:SetActive(true)
    self.exchange_icon_image:SetActive(false)
    self.exchange_desc_text:SetActive(false)
    self.exchange_count_text:SetActive(false)
  elseif data.state == State.Locked then
    self.btn:SetActive(false)
  elseif data.state == State.CostItem then
    self.btn:SetActive(true)
    self.free_text:SetActive(false)
    self.exchange_icon_image:SetActive(true)
    self.exchange_icon_image:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(FREE_ITEM_ID))
    self.exchange_desc_text:SetActive(true)
    self.exchange_count_text:SetActive(true)
    self.exchange_count_text:SetText("1")
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

UIKonbiniItem.OnCreate = OnCreate
UIKonbiniItem.OnDestroy = OnDestroy
UIKonbiniItem.OnEnable = OnEnable
UIKonbiniItem.OnDisable = OnDisable
UIKonbiniItem.ComponentDefine = ComponentDefine
UIKonbiniItem.ComponentDestroy = ComponentDestroy
UIKonbiniItem.DataDefine = DataDefine
UIKonbiniItem.DataDestroy = DataDestroy
UIKonbiniItem.OnAddListener = OnAddListener
UIKonbiniItem.OnRemoveListener = OnRemoveListener
UIKonbiniItem.State = State
UIKonbiniItem.SetData = SetData
UIKonbiniItem.SetOnClick = SetOnClick
UIKonbiniItem.OnClick = OnClick
return UIKonbiniItem
