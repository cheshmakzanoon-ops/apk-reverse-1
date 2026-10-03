local base = UIBaseView
local UIFireworkPreviewWindowView = BaseClass("UIFireworkPreviewWindowView", base)
local UIFireworkPreviewRT = require("UI.Firework.UIFireworkPreviewWindow.Component.UIFireworkPreviewRT")
local Localization = CS.GameEntry.Localization
local bgPanel_path = "Panel"
local backBtn_path = "Root/BackBtn"
local nameText_path = "Root/SkillNameText"
local previewRt_path = "Root/PreviewSkillRt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
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
  self.bgPanel = self:AddComponent(UIButton, bgPanel_path)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.previewRt = self:AddComponent(UIFireworkPreviewRT, previewRt_path)
  self.bgPanel:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.backBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.backBtn = nil
  self.nameText = nil
  self.previewRt = nil
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

local function OnOpen(self)
  self.fireworkItemId = self:GetUserData()
  if not self.fireworkItemId then
    self:OnBtnCloseClick()
    return
  end
  local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(self.fireworkItemId)
  self.nameText:SetLocalText(itemData.name)
  local width = self.previewRt.rectTransform.rect.width
  local height = self.previewRt.rectTransform.rect.height
  self.previewRt:SetData(self.fireworkItemId, toInt(width), toInt(height))
end

local function OnBtnCloseClick(self)
  self.ctrl.CloseSelf()
end

UIFireworkPreviewWindowView.OnCreate = OnCreate
UIFireworkPreviewWindowView.OnDestroy = OnDestroy
UIFireworkPreviewWindowView.OnEnable = OnEnable
UIFireworkPreviewWindowView.OnDisable = OnDisable
UIFireworkPreviewWindowView.ComponentDefine = ComponentDefine
UIFireworkPreviewWindowView.ComponentDestroy = ComponentDestroy
UIFireworkPreviewWindowView.DataDefine = DataDefine
UIFireworkPreviewWindowView.DataDestroy = DataDestroy
UIFireworkPreviewWindowView.OnOpen = OnOpen
UIFireworkPreviewWindowView.OnAddListener = OnAddListener
UIFireworkPreviewWindowView.OnRemoveListener = OnRemoveListener
UIFireworkPreviewWindowView.OnBtnCloseClick = OnBtnCloseClick
return UIFireworkPreviewWindowView
