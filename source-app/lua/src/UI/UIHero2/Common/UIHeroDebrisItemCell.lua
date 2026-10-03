local UIHeroDebrisItemCell = BaseClass("UIHeroDebrisItemCell", UIBaseContainer)
local base = UIBaseContainer
local debris_text_path = "root/resourceNum"
local debris_icon_path = "root/resourceIcon"
local debris_btn_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.itemId = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.debris_icon = self:AddComponent(UIImage, debris_icon_path)
  self.debris_text = self:AddComponent(UIText, debris_text_path)
  self.debris_btn = self:AddComponent(UIButton, debris_btn_path)
  self.debris_btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
end

local function SetData(self, itemId)
  self.itemId = itemId
  self:RefreshView(true)
end

local function RefreshView(self, setPic)
  local itemCount = DataCenter.ItemData:GetItemCount(self.itemId) or 0
  self.debris_text:SetText(string.GetFormattedSeperatorNum(itemCount))
  if setPic then
    self.debris_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.itemId))
  end
end

local function OnBtnClick(self)
  if self.itemId == HeroUtils.GetGoldHeroDebrisId() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, UICapacityTableTab.Item, self.itemId)
  end
end

UIHeroDebrisItemCell.OnCreate = OnCreate
UIHeroDebrisItemCell.OnDestroy = OnDestroy
UIHeroDebrisItemCell.ComponentDefine = ComponentDefine
UIHeroDebrisItemCell.ComponentDestroy = ComponentDestroy
UIHeroDebrisItemCell.SetData = SetData
UIHeroDebrisItemCell.RefreshView = RefreshView
UIHeroDebrisItemCell.OnBtnClick = OnBtnClick
return UIHeroDebrisItemCell
