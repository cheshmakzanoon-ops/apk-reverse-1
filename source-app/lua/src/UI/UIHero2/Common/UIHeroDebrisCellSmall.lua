local UIHeroDebrisCellSmall = BaseClass("UIHeroDebrisCellSmall", UIBaseContainer)
local base = UIBaseContainer
local debris_text_path = "HeroDebrisItemNum"
local debris_icon_path = "HeroDebrisItemIcon"
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
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
end

UIHeroDebrisCellSmall.OnAddListener = OnAddListener
UIHeroDebrisCellSmall.OnRemoveListener = OnRemoveListener
UIHeroDebrisCellSmall.OnCreate = OnCreate
UIHeroDebrisCellSmall.OnDestroy = OnDestroy
UIHeroDebrisCellSmall.ComponentDefine = ComponentDefine
UIHeroDebrisCellSmall.ComponentDestroy = ComponentDestroy
UIHeroDebrisCellSmall.SetData = SetData
UIHeroDebrisCellSmall.RefreshView = RefreshView
UIHeroDebrisCellSmall.OnBtnClick = OnBtnClick
return UIHeroDebrisCellSmall
