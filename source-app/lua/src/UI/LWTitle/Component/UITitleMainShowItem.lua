local base = UIBaseContainer
local UITitleMainShowItem = BaseClass("UITitleMainShowItem", base)
local icon_path = "icon"
local toggle_path = ""
local btnDelete_path = "delete"

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
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.btnDelete = self:AddComponent(UIButton, btnDelete_path)
  self.toggle:SetOnValueChanged(function(isOn)
    if isOn and self.callback then
      self.callback(self.callbackTarget, self.position)
    end
  end)
  self.btnDelete:SetOnClick(function()
    if self.configId then
      SFSNetwork.SendMessage(MsgDefines.UserTitleSetPosition, self.position, self.configId, true)
    end
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.toggle = nil
  self.btnDelete = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UITitleMainShowItem:ReInit(index, data, callback, callbackTarget)
  self.position = index
  self.configId = data and data.title
  self.callback = callback
  self.callbackTarget = callbackTarget
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(self.configId)
  if not info then
    self.icon:SetActive(false)
    self.btnDelete:SetActive(false)
    return
  end
  if string.IsNullOrEmpty(info.title_show_icon) then
    self.icon:SetActive(false)
  else
    self.icon:LoadSpriteAsyncEx(info.title_show_icon)
    self.icon:SetActive(true)
  end
  self.icon:SetActive(true)
  self.btnDelete:SetActive(true)
end

function UITitleMainShowItem:SetIsOn(flag)
  self.toggle:SetIsOn(flag)
end

UITitleMainShowItem.OnCreate = OnCreate
UITitleMainShowItem.OnDestroy = OnDestroy
UITitleMainShowItem.OnEnable = OnEnable
UITitleMainShowItem.OnDisable = OnDisable
UITitleMainShowItem.ComponentDefine = ComponentDefine
UITitleMainShowItem.ComponentDestroy = ComponentDestroy
UITitleMainShowItem.DataDefine = DataDefine
UITitleMainShowItem.DataDestroy = DataDestroy
return UITitleMainShowItem
