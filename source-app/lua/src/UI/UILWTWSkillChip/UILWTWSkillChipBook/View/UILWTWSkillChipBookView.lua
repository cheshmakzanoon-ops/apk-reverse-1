local UILWTWSkillChipBookView = BaseClass("UILWTWSkillChipBookView", UIBaseView)
local base = UIBaseView
local UITWSkillChipBookContainer = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.Component.UITWSkillChipBookContainer")
local UITWSkillChipDescriptionContainer = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.Component.UITWSkillChipDescriptionContainer")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local book_container_path = "PopUpTitle/Common_bg_orange2/bookContainer"
local description_container_path = "PopUpTitle/Common_bg_orange2/descriptionContainer"
local tab_path = "PopUpTitle/tabs/tab%d"
local tab_selected_path = "PopUpTitle/tabs/tab%d/selected%d"
local tab_btn_path = "PopUpTitle/tabs/tab%d/btn%d"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function GotoTab(self, index)
  if self.curIndex and self.curIndex == index then
    return
  end
  self.book_container:SetActive(index == 2)
  self.description_container:SetActive(index == 1)
  if index == 1 then
    self.description_container:Init()
  else
    self.book_container:Init()
  end
  self.curIndex = index
  for i = 1, 2 do
    self.tab_selecteds[i]:SetActive(i == index)
  end
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.book_container = self:AddComponent(UITWSkillChipBookContainer, book_container_path)
  self.description_container = self:AddComponent(UITWSkillChipDescriptionContainer, description_container_path)
  self.tab_btns = {}
  self.tab_selecteds = {}
  self.tabs = {}
  for i = 1, 2 do
    self.tab_btns[i] = self:AddComponent(UIButton, string.format(tab_btn_path, i, i))
    self.tab_selecteds[i] = self:AddComponent(UIImage, string.format(tab_selected_path, i, i))
    self.tabs[i] = self:AddComponent(UIText, string.format(tab_path, i))
    self.tab_btns[i]:SetOnClick(function()
      GotoTab(self, i)
    end)
  end
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  GotoTab(self, 1)
end

UILWTWSkillChipBookView.OnCreate = OnCreate
UILWTWSkillChipBookView.OnDestroy = OnDestroy
UILWTWSkillChipBookView.OnEnable = OnEnable
UILWTWSkillChipBookView.OnDisable = OnDisable
UILWTWSkillChipBookView.OnAddListener = OnAddListener
UILWTWSkillChipBookView.OnRemoveListener = OnRemoveListener
UILWTWSkillChipBookView.ComponentDefine = ComponentDefine
UILWTWSkillChipBookView.DataDefine = DataDefine
UILWTWSkillChipBookView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipBookView.DataDestroy = DataDestroy
UILWTWSkillChipBookView.OnOpen = OnOpen
return UILWTWSkillChipBookView
