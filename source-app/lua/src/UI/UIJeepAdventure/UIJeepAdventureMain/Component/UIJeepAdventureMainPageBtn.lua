local UIJeepAdventureMainPageBtn = BaseClass("UIJeepAdventureMainPageBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnZhuzaiClick()
  end)
  self.imgSelect = self:AddComponent(UIImage, "SelectImg")
  self.textTitle = self:AddComponent(UIText, "TitleText")
end

local function ComponentDestroy(self)
  self.btn = nil
  self.imgSelect = nil
  self.textTitle = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnZhuzaiClick(self)
  if self.clickFunc then
    self.clickFunc(self.pageType)
  end
end

local function SetData(self, pageType, clickFunc)
  self.pageType = pageType
  self.clickFunc = clickFunc
  if self.pageType == JeepAdventurePageType.TowerUp then
    self.textTitle:SetLocalText("armed_truck_title_name")
  elseif self.pageType == JeepAdventurePageType.Domintor then
    self.textTitle:SetLocalText("dominator_truck_title_name")
  end
end

local function SetSelect(self)
  self.imgSelect:SetActive(true)
end

local function SetUnSelect(self)
  self.imgSelect:SetActive(false)
end

UIJeepAdventureMainPageBtn.OnCreate = OnCreate
UIJeepAdventureMainPageBtn.OnDestroy = OnDestroy
UIJeepAdventureMainPageBtn.OnEnable = OnEnable
UIJeepAdventureMainPageBtn.OnDisable = OnDisable
UIJeepAdventureMainPageBtn.ComponentDefine = ComponentDefine
UIJeepAdventureMainPageBtn.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainPageBtn.DataDefine = DataDefine
UIJeepAdventureMainPageBtn.DataDestroy = DataDestroy
UIJeepAdventureMainPageBtn.OnAddListener = OnAddListener
UIJeepAdventureMainPageBtn.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainPageBtn.OnBtnZhuzaiClick = OnBtnZhuzaiClick
UIJeepAdventureMainPageBtn.SetSelect = SetSelect
UIJeepAdventureMainPageBtn.SetUnSelect = SetUnSelect
UIJeepAdventureMainPageBtn.SetData = SetData
return UIJeepAdventureMainPageBtn
