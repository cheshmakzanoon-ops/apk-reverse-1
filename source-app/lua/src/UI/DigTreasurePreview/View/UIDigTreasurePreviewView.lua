local UIDigTreasurePreviewView = BaseClass("UIDigTreasurePreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textIntro = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textConfirmBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.rawImg = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.textConfirmBtn:SetLocalText("110006")
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.btnPanel = nil
  self.textIntro = nil
  self.textTitle = nil
  self.btnClose = nil
  self.btnConfirm = nil
  self.textContent = nil
  self.textConfirmBtn = nil
  self.rawImg = nil
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

local function OnBtnPanelClick(self)
  self.ctrl.CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl.CloseSelf()
end

local function OnBtnConfirmClick(self)
  self.ctrl.CloseSelf()
end

function UIDigTreasurePreviewView:InitData()
  local actInfo = DataCenter.DigTreasureManager:IsActPreviewOpen()
  if not table.IsNullOrEmpty(actInfo) and not string.IsNullOrEmpty(actInfo.activityId) then
    local lineData = LocalController:instance():getLine(TableName.Activity, actInfo.activityId)
    if lineData then
      local icon = lineData.para_1
      local desc = lineData.para_2
      local title = lineData.para_3
      self.textContent:SetLocalText(desc)
      self.rawImg:LoadSpriteAsync(icon)
      self.textTitle:SetLocalText(title)
    end
  end
end

UIDigTreasurePreviewView.OnCreate = OnCreate
UIDigTreasurePreviewView.OnDestroy = OnDestroy
UIDigTreasurePreviewView.OnEnable = OnEnable
UIDigTreasurePreviewView.OnDisable = OnDisable
UIDigTreasurePreviewView.ComponentDefine = ComponentDefine
UIDigTreasurePreviewView.ComponentDestroy = ComponentDestroy
UIDigTreasurePreviewView.DataDefine = DataDefine
UIDigTreasurePreviewView.DataDestroy = DataDestroy
UIDigTreasurePreviewView.OnAddListener = OnAddListener
UIDigTreasurePreviewView.OnRemoveListener = OnRemoveListener
UIDigTreasurePreviewView.OnBtnPanelClick = OnBtnPanelClick
UIDigTreasurePreviewView.OnBtnCloseClick = OnBtnCloseClick
UIDigTreasurePreviewView.OnBtnConfirmClick = OnBtnConfirmClick
return UIDigTreasurePreviewView
