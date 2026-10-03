local UIEquipMainPanelView = BaseClass("UIEquipMainPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICraftEquipPage = require("UI.UIEquipMainPanel.Component.UICraftEquipPage")
local UIMergeMaterialPage = require("UI.UIEquipMainPanel.Component.UIMergeMaterialPage")
local UIDecomposeMaterialPage = require("UI.UIEquipMainPanel.Component.UIDecomposeMaterialPage")
local UIDecomposeEquipPage = require("UI.UIEquipMainPanel.Component.UIDecomposeEquipPage")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.PAC_Factory_Interface, false)
end

local function SelectTab(self, tab)
  if self.curTab == tab then
    return
  end
  self.curTab = tab
  for i = 1, #self.tabIcons do
    local btnPosY = 0
    local sizeX = 0
    local sizeY = 0
    if i == tab then
      self.tabIcons[i]:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_1.png")
      btnPosY = -9.2
      sizeX = 194
      sizeY = 84
      self.selectedArrows[i]:SetActive(true)
    else
      self.tabIcons[i]:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_3.png")
      btnPosY = -4
      sizeX = 198
      sizeY = 83
      self.selectedArrows[i]:SetActive(false)
    end
    local anchoredPosX = self.tabIcons[i]:GetAnchoredPositionX()
    self.tabIcons[i]:SetAnchoredPositionXY(anchoredPosX, btnPosY)
    self.tabIcons[i].rectTransform:Set_sizeDelta(sizeX, sizeY)
  end
  for i = 1, #self.pages do
    if i == tab then
      self.pages[i]:SetActive(true)
      self.pages[i]:SetData()
    else
      self.pages[i]:SetActive(false)
    end
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Tab_Switch_01, false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/BottomInfo/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.titleText = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.craftEquipTabBtn = self:AddComponent(UIButton, "Root/TopBar/TabBtns/CraftEquipTabBtn")
  self.decomposeEquipTabBtn = self:AddComponent(UIButton, "Root/TopBar/TabBtns/DecomposeEquipTabBtn")
  self.mergeMaterialTabBtn = self:AddComponent(UIButton, "Root/TopBar/TabBtns/MergeMaterialTabBtn")
  self.decomposeMaterialTabBtn = self:AddComponent(UIButton, "Root/TopBar/TabBtns/DecomposeMaterialTabBtn")
  self.tabBtns = {
    self.craftEquipTabBtn,
    self.decomposeEquipTabBtn,
    self.mergeMaterialTabBtn,
    self.decomposeMaterialTabBtn
  }
  self.craftEquipTabBtn:SetOnClick(function()
    SelectTab(self, 1)
  end)
  self.decomposeEquipTabBtn:SetOnClick(function()
    SelectTab(self, 2)
  end)
  self.mergeMaterialTabBtn:SetOnClick(function()
    SelectTab(self, 3)
  end)
  self.decomposeMaterialTabBtn:SetOnClick(function()
    SelectTab(self, 4)
  end)
  self.craftEquipTabIcon = self:AddComponent(UIImage, "Root/TopBar/TabBtns/CraftEquipTabBtn")
  self.decomposeEquipTabIcon = self:AddComponent(UIImage, "Root/TopBar/TabBtns/DecomposeEquipTabBtn")
  self.mergeMaterialTabIcon = self:AddComponent(UIImage, "Root/TopBar/TabBtns/MergeMaterialTabBtn")
  self.decomposeMaterialTabIcon = self:AddComponent(UIImage, "Root/TopBar/TabBtns/DecomposeMaterialTabBtn")
  self.tabIcons = {
    self.craftEquipTabIcon,
    self.decomposeEquipTabIcon,
    self.mergeMaterialTabIcon,
    self.decomposeMaterialTabIcon
  }
  self.craftEquipTabBtnText = self:AddComponent(UIText, "Root/TopBar/TabBtns/CraftEquipTabBtn/CraftEquipTabBtnText")
  self.decomposeEquipTabBtnText = self:AddComponent(UIText, "Root/TopBar/TabBtns/DecomposeEquipTabBtn/DecomposeEquipTabBtnText")
  self.mergeMaterialTabBtnText = self:AddComponent(UIText, "Root/TopBar/TabBtns/MergeMaterialTabBtn/MergeMaterialTabBtnText")
  self.decomposeMaterialTabBtnText = self:AddComponent(UIText, "Root/TopBar/TabBtns/DecomposeMaterialTabBtn/DecomposeMaterialTabBtnText")
  self.tabBtnTexts = {
    self.craftEquipTabBtnText,
    self.decomposeEquipTabBtnText,
    self.mergeMaterialTabBtnText,
    self.decomposeMaterialTabBtnText
  }
  self.craftEquipTabBtnSelectedArrow = self:AddComponent(UIImage, "Root/TopBar/TabBtns/CraftEquipTabBtn/SelectedArrow1")
  self.decomposeEquipTabBtnSelectedArrow = self:AddComponent(UIImage, "Root/TopBar/TabBtns/DecomposeEquipTabBtn/SelectedArrow2")
  self.mergeMaterialTabBtnSelectedArrow = self:AddComponent(UIImage, "Root/TopBar/TabBtns/MergeMaterialTabBtn/SelectedArrow3")
  self.decomposeMaterialTabBtnSelectedArrow = self:AddComponent(UIImage, "Root/TopBar/TabBtns/DecomposeMaterialTabBtn/SelectedArrow4")
  self.selectedArrows = {
    self.craftEquipTabBtnSelectedArrow,
    self.decomposeEquipTabBtnSelectedArrow,
    self.mergeMaterialTabBtnSelectedArrow,
    self.decomposeMaterialTabBtnSelectedArrow
  }
  self.craftEquipPage = self:AddComponent(UICraftEquipPage, "Root/CraftEquipPage")
  self.decomposeEquipPage = self:AddComponent(UIDecomposeEquipPage, "Root/DecomposeEquipPage")
  self.mergeMaterailPage = self:AddComponent(UIMergeMaterialPage, "Root/MergeMaterialPage")
  self.decomposeMaterialPage = self:AddComponent(UIDecomposeMaterialPage, "Root/DecomposeMaterialPage")
  self.pages = {
    self.craftEquipPage,
    self.decomposeEquipPage,
    self.mergeMaterailPage,
    self.decomposeMaterialPage
  }
  self.titleText:SetLocalText(430701)
  self.craftEquipTabBtnText:SetLocalText(430702)
  self.decomposeEquipTabBtnText:SetLocalText(430703)
  self.mergeMaterialTabBtnText:SetLocalText(430704)
  self.decomposeMaterialTabBtnText:SetLocalText(430705)
end

local function DataDefine(self)
  self.curTab = 0
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.titleText = nil
  self.craftEquipTabBtn = nil
  self.mergeMaterialTabBtn = nil
  self.tabBtns = nil
  self.craftEquipTabIcon = nil
  self.mergeMaterialTabIcon = nil
  self.tabIcons = nil
  self.craftEquipTabBtnText = nil
  self.mergeMaterialTabBtnText = nil
  self.tabBtnTexts = nil
  self.craftEquipTabBtnSelectedArrow = nil
  self.mergeMaterialTabBtnSelectedArrow = nil
  self.selectedArrows = nil
  self.craftEquipPage = nil
  self.mergeMaterailPage = nil
  self.pages = nil
end

local function DataDestroy(self)
  self.curTab = nil
  self.defaultTab = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  for i = 1, #self.pages do
    self.pages[i]:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function UpdateView(self)
end

local function OnOpen(self)
  self.buildingUuid, self.defaultTab = self:GetUserData()
  for i = 1, #self.pages do
    self.pages[i].buildingUuid = self.buildingUuid
  end
  if self.curTab == nil or self.curTab <= 0 then
    SelectTab(self, self.defaultTab or 1)
  end
end

local function OnBtnCloseClick(self)
  if self.callBack ~= nil then
    self.callBack()
  end
  self.ctrl.CloseSelf()
end

UIEquipMainPanelView.OnCreate = OnCreate
UIEquipMainPanelView.OnDestroy = OnDestroy
UIEquipMainPanelView.OnEnable = OnEnable
UIEquipMainPanelView.OnDisable = OnDisable
UIEquipMainPanelView.OnAddListener = OnAddListener
UIEquipMainPanelView.OnRemoveListener = OnRemoveListener
UIEquipMainPanelView.ComponentDefine = ComponentDefine
UIEquipMainPanelView.DataDefine = DataDefine
UIEquipMainPanelView.ComponentDestroy = ComponentDestroy
UIEquipMainPanelView.DataDestroy = DataDestroy
UIEquipMainPanelView.OnOpen = OnOpen
UIEquipMainPanelView.OnBtnCloseClick = OnBtnCloseClick
UIEquipMainPanelView.UpdateView = UpdateView
return UIEquipMainPanelView
