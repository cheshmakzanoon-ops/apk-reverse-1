local base = UIBaseContainer
local ProbabProductItem = BaseClass("ProbabProductItem", base)
local item_path = "item"
local probab_txt_path = "probabBg/probab_txt"
local price_txt_path = "priceLayout/price_txt"
local itemIcon_img_path = "priceLayout/costItemIcon_img"

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
  self.probab_txt = self:AddComponent(UIText, probab_txt_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.itemIcon_img = self:AddComponent(UIImage, itemIcon_img_path)
  self.item = self:AddComponent(UICommonResItem, item_path)
end

local function ComponentDestroy(self)
  self.item = nil
  self.probab_txt = nil
  self.price_txt = nil
  self.itemIcon_img = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  if data == nil then
    return
  end
  self.item:ReInit(data.item.showRewardInfo)
  self.probab_txt:SetText(string.format("%s%%", data.probab))
  local _isFree = false
  local _costId, _costNum = data.item.costItemId, data.item.costNum
  if _costId <= 0 or _costNum <= 0 then
    _isFree = true
  end
  if _isFree then
    self.price_txt:SetLocalText("blackmarket_desc5")
    self.itemIcon_img:SetActive(false)
  else
    self.price_txt:SetText(_costNum)
    self.itemIcon_img:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, _costId))
    self.itemIcon_img:SetActive(true)
  end
end

ProbabProductItem.OnCreate = OnCreate
ProbabProductItem.OnDestroy = OnDestroy
ProbabProductItem.OnEnable = OnEnable
ProbabProductItem.OnDisable = OnDisable
ProbabProductItem.ComponentDefine = ComponentDefine
ProbabProductItem.ComponentDestroy = ComponentDestroy
ProbabProductItem.DataDefine = DataDefine
ProbabProductItem.DataDestroy = DataDestroy
ProbabProductItem.SetData = SetData
return ProbabProductItem
