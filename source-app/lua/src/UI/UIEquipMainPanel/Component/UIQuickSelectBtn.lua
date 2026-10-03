local UIQuickSelectBtn = BaseClass("UIQuickSelectBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.selected = false
  self.clickCallBack = nil
end

local function DataDestroy(self)
  self.selected = nil
  self.clickCallBack = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.clickCallBack ~= nil then
      self.clickCallBack(self.qualityType)
    end
  end)
  self.selectedBg = self:AddComponent(UIImage, "SelectedBg")
  self.text = self:AddComponent(UIText, "BtnText")
  self.selectedIcon = self:AddComponent(UIImage, "SelectedIcon")
end

local function ComponentDestroy(self)
  self.btn = nil
  self.selectedBg = nil
  self.text = nil
  self.selectedIcon = nil
end

local function SetClickCallBack(self, clickCallBack)
  self.clickCallBack = clickCallBack
end

local function SetSelected(self, selected)
  self.selected = selected
  self.selectedIcon:SetActive(selected)
  self.selectedBg:SetActive(selected)
end

local function SetLanguageText(self, textId)
  self.text:SetLocalText(textId)
end

UIQuickSelectBtn.OnCreate = OnCreate
UIQuickSelectBtn.OnDestroy = OnDestroy
UIQuickSelectBtn.OnEnable = OnEnable
UIQuickSelectBtn.OnDisable = OnDisable
UIQuickSelectBtn.DataDefine = DataDefine
UIQuickSelectBtn.DataDestroy = DataDestroy
UIQuickSelectBtn.ComponentDefine = ComponentDefine
UIQuickSelectBtn.ComponentDestroy = ComponentDestroy
UIQuickSelectBtn.SetSelected = SetSelected
UIQuickSelectBtn.SetClickCallBack = SetClickCallBack
UIQuickSelectBtn.SetLanguageText = SetLanguageText
return UIQuickSelectBtn
