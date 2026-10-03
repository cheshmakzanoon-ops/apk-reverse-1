local UIProbabilityNoticeItem = BaseClass("UIProbabilityNoticeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "topContent/titleText"
local rate_text_path = "topContent/rateText"
local rate_img_path = "topContent/Image"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rate_text = self:AddComponent(UIText, rate_text_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.rarity_img = self:AddComponent(UIImage, rate_img_path)
  self.content = self:AddComponent(UIBaseContainer, "rewardContent")
end

local function ComponentDestroy(self)
  self.rate_text = nil
  self.title_text = nil
  self.content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UpdateItem(self, data)
  self.title_text:SetText(data.name)
  if not string.IsNullOrEmpty(data.rate) then
    local rateNum = tonumber(data.rate) or 0
    if 100 < rateNum then
      rateNum = 100
    end
    self.rate_text:SetText(rateNum .. "%")
  else
    self.rate_text:SetText("")
  end
  if not string.IsNullOrEmpty(data.icon) then
    self.rarity_img:LoadSprite(data.icon)
  end
end

UIProbabilityNoticeItem.OnCreate = OnCreate
UIProbabilityNoticeItem.OnDestroy = OnDestroy
UIProbabilityNoticeItem.ComponentDefine = ComponentDefine
UIProbabilityNoticeItem.ComponentDestroy = ComponentDestroy
UIProbabilityNoticeItem.DataDefine = DataDefine
UIProbabilityNoticeItem.DataDestroy = DataDestroy
UIProbabilityNoticeItem.UpdateItem = UpdateItem
return UIProbabilityNoticeItem
