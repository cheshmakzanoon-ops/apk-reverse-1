local base = UIBaseContainer
local SeasonPhotoItem = BaseClass("SeasonPhotoItem", base)
local txtName_path = "bg/txtName"
local txtAbbr_path = "bg/txtAbbr"
local bg_path = "bg"
local bgImg_path = "bg"
local bgEmpty_path = "bgEmpty"

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
  self.txtName = self:AddComponent(UIText, txtName_path)
  self.txtAbbr = self:AddComponent(UIText, txtAbbr_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bgImg = self:AddComponent(UIRawImage, bgImg_path)
  self.bgEmpty = self:AddComponent(UIBaseContainer, bgEmpty_path)
  self.bg:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoMain, {anim = true}, nil, nil, self.data.season, self.data.allianceId)
    end
  end)
end

local function ComponentDestroy(self)
  self.txtName = nil
  self.txtAbbr = nil
  self.bg = nil
  self.bgImg = nil
  self.bgEmpty = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoItem:ReInit(index, data)
  if not data then
    self.bgEmpty:SetActive(true)
    self.bg:SetActive(false)
    return
  end
  self.data = data
  self.bgEmpty:SetActive(false)
  self.bg:SetActive(true)
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigData(data.photoConfigId)
  self.txtName:SetLocalText(config and config.photo_name or data.serverId)
  self.txtAbbr:SetText(data.abbr)
  if config and not string.IsNullOrEmpty(config.photo_icon) then
    self.bgImg:LoadSpriteAsync(config.photo_icon)
  end
  DataCenter.SeasonPhotoManager:ChangeSkin(self, data.season)
end

SeasonPhotoItem.OnCreate = OnCreate
SeasonPhotoItem.OnDestroy = OnDestroy
SeasonPhotoItem.OnEnable = OnEnable
SeasonPhotoItem.OnDisable = OnDisable
SeasonPhotoItem.ComponentDefine = ComponentDefine
SeasonPhotoItem.ComponentDestroy = ComponentDestroy
SeasonPhotoItem.DataDefine = DataDefine
SeasonPhotoItem.DataDestroy = DataDestroy
return SeasonPhotoItem
