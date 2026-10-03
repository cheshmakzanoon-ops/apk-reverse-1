local base = UIBaseContainer
local MailDetailScoutResourceItem = BaseClass("MailDetailScoutResourceItem", base)
local numTxt_path = "NumText"
local icon_path = "Icon"

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
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.numTxt = nil
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function MailDetailScoutResourceItem:RefreshData(param)
  if param.rewardType == RewardType.RESOURCE then
    local spritePath = DataCenter.ResourceManager:GetResourceIconByType(param.itemId)
    self.icon:LoadSprite(spritePath)
    self.numTxt:SetText(string.GetFormattedStr(param.count))
  end
end

MailDetailScoutResourceItem.OnCreate = OnCreate
MailDetailScoutResourceItem.OnDestroy = OnDestroy
MailDetailScoutResourceItem.OnEnable = OnEnable
MailDetailScoutResourceItem.OnDisable = OnDisable
MailDetailScoutResourceItem.ComponentDefine = ComponentDefine
MailDetailScoutResourceItem.ComponentDestroy = ComponentDestroy
MailDetailScoutResourceItem.DataDefine = DataDefine
MailDetailScoutResourceItem.DataDestroy = DataDestroy
return MailDetailScoutResourceItem
