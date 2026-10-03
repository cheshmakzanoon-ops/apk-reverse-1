local UIDeclareWarAlliItem = BaseClass("UIDeclareWarAlliItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local flag_path = "flag"
local abbr_path = "abbr"
local name_path = "name"
local power_path = "power"

function UIDeclareWarAlliItem:OnCreate()
  base.OnCreate(self)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.abbr = self:AddComponent(UIText, abbr_path)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
end

function UIDeclareWarAlliItem:OnAddListener()
  base.OnAddListener(self)
end

function UIDeclareWarAlliItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDeclareWarAlliItem:Refresh(data)
  self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.alIcon or 1))
  self.abbr:SetText(string.format("[%s]", data.alAbbr))
  self.name:SetText(data.alName)
  self.power:SetText(string.GetFormattedStr2(data.power or 0))
end

return UIDeclareWarAlliItem
