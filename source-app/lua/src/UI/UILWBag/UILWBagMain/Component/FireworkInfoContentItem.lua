local base = UIBaseContainer
local FireworkInfoContentItem = BaseClass("FireworkInfoContentItem", base)
local linkBtn_path = "InfoNameContent/LinkBtn"
local infoName_path = "InfoNameContent/InfoName"
local infoDes_path = "InfoDesScroll/ViewPort/InfoDes"
local defaultToggleTxt_path = "DefaultToggle"
local defaultToggle_path = "DefaultToggle/toggle"
local rateBtn_path = "rateBtn"

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
  self.linkBtn = self:AddComponent(UIButton, linkBtn_path)
  self.infoName = self:AddComponent(UIText, infoName_path)
  self.infoDes = self:AddComponent(UIText, infoDes_path)
  self.defaultToggleTxt = self:AddComponent(UIText, defaultToggleTxt_path)
  self.defaultToggle = self:AddComponent(UIToggle, defaultToggle_path)
  self.rateBtn = self:AddComponent(UIButton, rateBtn_path)
  self.rateBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRateBtnClick()
  end)
  self.defaultToggleTxt:SetLocalText("firework_interface_1011")
  self.defaultToggle:SetOnValueChanged(function(isOn)
    if isOn then
      DataCenter.LWFireworkManager:SetDefaultFireworkItemId(self.itemData.id)
    else
      UIUtil.ShowTipsId("firework_tips_1020")
      self.defaultToggle:SetIsOnWithoutNotify(true)
    end
  end)
  self.linkBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkPreviewWindow, self.itemData.id)
  end)
end

local function ComponentDestroy(self)
  self.linkBtn = nil
  self.infoName = nil
  self.infoDes = nil
  self.defaultToggleTxt = nil
  self.defaultToggle = nil
  self.rateBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  self.itemData = data
  self.defaultToggle:SetIsOnWithoutNotify(DataCenter.LWFireworkManager:GetDefaultFireworkItemId() == self.itemData.id)
  local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemData.id)
  if itemData then
    self.infoName:SetLocalText(itemData.name)
    self.infoDes:SetLocalText(itemData.description)
  end
end

function FireworkInfoContentItem:OnRateBtnClick()
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemData.id)
  if itemTemplate then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, itemTemplate.drop_info_para)
  else
    Logger.LogError("OnRateBtnClick: not found " .. tostring(itemId))
  end
end

FireworkInfoContentItem.OnCreate = OnCreate
FireworkInfoContentItem.OnDestroy = OnDestroy
FireworkInfoContentItem.OnEnable = OnEnable
FireworkInfoContentItem.OnDisable = OnDisable
FireworkInfoContentItem.ComponentDefine = ComponentDefine
FireworkInfoContentItem.ComponentDestroy = ComponentDestroy
FireworkInfoContentItem.DataDefine = DataDefine
FireworkInfoContentItem.DataDestroy = DataDestroy
FireworkInfoContentItem.SetData = SetData
return FireworkInfoContentItem
