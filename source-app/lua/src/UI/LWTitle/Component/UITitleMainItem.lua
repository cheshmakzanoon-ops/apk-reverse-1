local base = UIBaseContainer
local UITitleMainItem = BaseClass("UITitleMainItem", base)
local btnInfo_path = "top/btnInfo"
local txtTitle_path = "top/title"
local txtTime_path = "top/timeRoot/time"
local timeRoot_path = "top/timeRoot"
local btnShare_path = "top/btnShare"
local icon_path = "icon"
local txtDesc_path = "desc"
local btn_path = "btn"

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
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.txtTime = self:AddComponent(UIText, txtTime_path)
  self.timeRoot = self:AddComponent(UIBaseContainer, timeRoot_path)
  self.btnShare = self:AddComponent(UIButton, btnShare_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txtDesc = self:AddComponent(UIText, txtDesc_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.callback and self.data then
      self.callback(self.callbackTarget, self.data.cfgId)
    end
  end)
  self.btnInfo:SetOnClick(function()
    if self.data and self.data.cfgId then
      DataCenter.PlayerInfoDataManager:ShowTitleDetail(self.data.cfgId, self.uid)
    end
  end)
  self.btnShare:SetOnClick(function()
    DataCenter.PlayerInfoDataManager:ShareTitle(self.data.cfgId, self.uid)
  end)
end

local function ComponentDestroy(self)
  self.btnInfo = nil
  self.txtTitle = nil
  self.txtTime = nil
  self.timeRoot = nil
  self.btnShare = nil
  self.icon = nil
  self.txtDesc = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UITitleMainItem:ReInit(data, uid, callback, callbackTarget)
  self.data = data
  self.uid = uid
  self.callback = callback
  self.callbackTarget = callbackTarget
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(data.cfgId)
  if not info then
    return
  end
  if not string.IsNullOrEmpty(info.title_show_icon) then
    self.icon:LoadSpriteAsyncEx(info.title_show_icon)
  end
  self.txtTitle:SetLocalText(info.name)
  self.txtDesc:SetLocalText(info.description)
  self.EndTime = data.endTime
  self.btn:SetActive(not data.position or data.position <= 0)
  if self.EndTime then
    self.timeRoot:SetActive(true)
    self:Update1000MS()
  else
    self.timeRoot:SetActive(false)
  end
end

function UITitleMainItem:Update1000MS()
  if self.EndTime and UIUtil.SetLeftTimeText(self.txtTime, nil, self.EndTime) then
    self.EndTime = nil
    self.timeRoot:SetActive(false)
  end
end

UITitleMainItem.OnCreate = OnCreate
UITitleMainItem.OnDestroy = OnDestroy
UITitleMainItem.OnEnable = OnEnable
UITitleMainItem.OnDisable = OnDisable
UITitleMainItem.ComponentDefine = ComponentDefine
UITitleMainItem.ComponentDestroy = ComponentDestroy
UITitleMainItem.DataDefine = DataDefine
UITitleMainItem.DataDestroy = DataDestroy
return UITitleMainItem
