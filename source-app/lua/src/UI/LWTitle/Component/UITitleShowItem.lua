local base = UIBaseContainer
local UITitleShowItem = BaseClass("UITitleShowItem", base)
local icon_path = "icon"
local btn_path = ""
local bg_path = "bg"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.btn:SetOnClick(function()
    DataCenter.PlayerInfoDataManager:ShowTitleDetail(self.configId, self.uid)
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UITitleShowItem:ReInit(data, uid, scale_)
  self.configId = data and data.title
  self.uid = uid
  scale_ = scale_ or 1
  self:SetLocalScaleXYZ(scale_, scale_, scale_)
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(self.configId)
  if not info then
    self.bg:SetActive(true)
    self.icon:SetActive(false)
    return
  end
  self.bg:SetActive(0.5 < scale_)
  local iconPath = scale_ <= 0.5 and info.message_show_icon or info.title_show_icon
  if string.IsNullOrEmpty(iconPath) then
    self.icon:SetActive(false)
  else
    self.icon:LoadSpriteAsyncEx(iconPath)
    self.icon:SetActive(true)
  end
end

UITitleShowItem.OnCreate = OnCreate
UITitleShowItem.OnDestroy = OnDestroy
UITitleShowItem.OnEnable = OnEnable
UITitleShowItem.OnDisable = OnDisable
UITitleShowItem.ComponentDefine = ComponentDefine
UITitleShowItem.ComponentDestroy = ComponentDestroy
UITitleShowItem.DataDefine = DataDefine
UITitleShowItem.DataDestroy = DataDestroy
return UITitleShowItem
