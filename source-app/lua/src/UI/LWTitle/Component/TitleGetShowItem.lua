local base = UIBaseContainer
local TitleGetShowItem = BaseClass("TitleGetShowItem", base)
local Icon_path = "Icon"
local Name_path = "Name"
local Desc_path = "Desc"
local TimeText_path = "TimeText"

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
  self.Icon = self:AddComponent(UIImage, Icon_path)
  self.Name = self:AddComponent(UIText, Name_path)
  self.Desc = self:AddComponent(UIText, Desc_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
end

local function ComponentDestroy(self)
  self.Icon = nil
  self.Name = nil
  self.Desc = nil
  self.TimeText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TitleGetShowItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserTitleUpdate, self.UserTitleUpdate)
end

function TitleGetShowItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UserTitleUpdate, self.UserTitleUpdate)
  base.OnRemoveListener(self)
end

function TitleGetShowItem:ReInit(data)
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(data.cfgId)
  if not info then
    return
  end
  self.data = data
  self.Name:SetLocalText(info.name)
  self.Desc:SetText(CS.GameEntry.Localization:GetString("season_s3_title_desc_01", tostring(data.globalNum or 0), tostring(data.rank)))
  if string.IsNullOrEmpty(info.title_show_icon) then
    self.Icon:SetActive(false)
  else
    self.Icon:LoadSpriteAsyncEx(info.title_show_icon)
    self.Icon:SetActive(true)
  end
  self.EndTime = data.endTime
  if self.EndTime then
    self.TimeText:SetActive(true)
    self:Update1000MS()
  else
    self.TimeText:SetActive(false)
  end
  DataCenter.PlayerInfoDataManager:ShowTitleDetail(self.data.cfgId)
end

function TitleGetShowItem:Update1000MS()
  if self.EndTime and UIUtil.SetLeftTimeText(self.TimeText, nil, self.EndTime) then
    self.EndTime = nil
    self.TimeText:SetActive(false)
  end
end

function TitleGetShowItem:UserTitleUpdate(title)
  if not self.data or self.data.cfgId ~= title.cfgId then
    return
  end
  self.Desc:SetText(CS.GameEntry.Localization:GetString("season_s3_title_desc_01", tostring(title.globalNum or 0), tostring(title.rank)))
end

TitleGetShowItem.OnCreate = OnCreate
TitleGetShowItem.OnDestroy = OnDestroy
TitleGetShowItem.OnEnable = OnEnable
TitleGetShowItem.OnDisable = OnDisable
TitleGetShowItem.ComponentDefine = ComponentDefine
TitleGetShowItem.ComponentDestroy = ComponentDestroy
TitleGetShowItem.DataDefine = DataDefine
TitleGetShowItem.DataDestroy = DataDestroy
return TitleGetShowItem
