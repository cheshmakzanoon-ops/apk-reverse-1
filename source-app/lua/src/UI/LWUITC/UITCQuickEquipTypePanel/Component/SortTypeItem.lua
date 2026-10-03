local SortTypeItem = BaseClass("SortTypeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.callback = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "selectBtn")
  self.checkMark = self:AddComponent(UIImage, "selectBtn/Background/Checkmark")
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "selectBtn/type_txt")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.checkMark = nil
  self.btn = nil
end

function SortTypeItem:SetData(index, name)
  self.index = index
  self.name = name
  self.name_txt:SetLocalText(self.name)
end

function SortTypeItem:SetSelectState(select_state)
  self.select_state = select_state
  self.checkMark:SetActive(self.select_state)
end

function SortTypeItem:SetOnClick(callback)
  self.callback = callback
end

function SortTypeItem:OnClick()
  if self.callback then
    self.callback(self.index, self)
  end
end

SortTypeItem.OnCreate = OnCreate
SortTypeItem.OnDestroy = OnDestroy
SortTypeItem.ComponentDestroy = ComponentDestroy
SortTypeItem.ComponentDefine = ComponentDefine
return SortTypeItem
