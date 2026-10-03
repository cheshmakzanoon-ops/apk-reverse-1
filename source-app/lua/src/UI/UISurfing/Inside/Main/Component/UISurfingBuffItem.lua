local base = UIBaseContainer
local UISurfingBuffItem = BaseClass("UISurfingBuffItem", base)
local icon_path = "Icon"
local mark_path = "Mark"
local timing_text_path = "TimingText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.mark = self:AddComponent(UIImage, mark_path)
  self.timing_text = self:AddComponent(UITextMeshProUGUIEx, timing_text_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.mark = nil
  self.timing_text = nil
end

local function DataDefine(self)
  self.buff = nil
  self.remainTime = nil
end

local function DataDestroy(self)
  self.buff = nil
  self.remainTime = nil
end

function UISurfingBuffItem:OnUpdate()
  if self.buff then
    local remainTime = self.buff.duration
    if remainTime and 0 <= remainTime then
      local remainProgress = remainTime / self.duration
      self.mark:SetFillAmount(remainProgress)
      remainTime = Mathf.Max(0, Mathf.Floor(remainTime))
      if self.remainTime ~= remainTime then
        self.remainTime = remainTime
        self.timing_text:SetLocalText("parkour_meters_show_second", remainTime)
      end
    else
      self:SetActive(false)
    end
  end
end

local function SetData(self, buff, level)
  self.buff = buff
  if buff and buff.meta then
    self.duration = buff.meta.buff_time
    local remainTime = self.duration
    remainTime = Mathf.Floor(remainTime)
    self.timing_text:SetLocalText("parkour_meters_show_second", remainTime)
    local remainProgress = remainTime / self.duration
    self.mark:SetFillAmount(remainProgress)
    local buffIcon = buff.meta.buff_icon
    self.buff_icon = buffIcon
    if level then
      local path = self:GetBuffIcon(level)
      self.icon:LoadSpriteAuto(path)
    else
      self.icon:LoadSpriteAuto(buffIcon)
    end
  end
end

local function UpdateData(self, buff, level)
  self.buff = buff
  if buff and buff.meta then
    self.duration = buff.meta.buff_time
    local remainTime = self.duration
    remainTime = Mathf.Floor(remainTime)
    self.timing_text:SetLocalText("parkour_meters_show_second", remainTime)
    local remainProgress = remainTime / self.duration
    self.mark:SetFillAmount(remainProgress)
    local buffIcon = buff.meta.buff_icon
    self.buff_icon = buffIcon
    if level then
      local path = self:GetBuffIcon(level)
      self.icon:LoadSpriteAuto(path)
    else
      self.icon:LoadSpriteAuto(buffIcon)
    end
  end
end

local function ResetData(self)
  self.buff = nil
  self.buff_icon = nil
  self.buffIcons = nil
end

function UISurfingBuffItem:GetBuffIcon(level)
  if self.buffIcons == nil then
    if self.buff_icon == nil or self.buff_icon == "" then
      self.buff_icon = self.buff.meta.buff_icon
    end
    if self.buff_icon then
      local iconStr = string.split(self.buff_icon, "|")
      self.buffIcons = iconStr
    end
  end
  if self.buffIcons then
    local count = #self.buffIcons
    if level > count then
      level = count
    end
    local path = self.buffIcons[level]
    return path
  end
end

UISurfingBuffItem.OnCreate = OnCreate
UISurfingBuffItem.OnDestroy = OnDestroy
UISurfingBuffItem.ComponentDefine = ComponentDefine
UISurfingBuffItem.ComponentDestroy = ComponentDestroy
UISurfingBuffItem.DataDefine = DataDefine
UISurfingBuffItem.DataDestroy = DataDestroy
UISurfingBuffItem.SetData = SetData
UISurfingBuffItem.UpdateData = UpdateData
UISurfingBuffItem.ResetData = ResetData
return UISurfingBuffItem
