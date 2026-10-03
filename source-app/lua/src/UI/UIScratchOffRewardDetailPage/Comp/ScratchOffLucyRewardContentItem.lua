local ScratchOffLucyRewardContentItem = BaseClass("ScratchOffLucyRewardContentItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desTxt_path = "desTxt"
local icon1_path = "icon1"
local icon2_path = "icon2"
local icon3_path = "icon3"
local diamondText_path = "DiamondText"
local line_path = "Image (1)"

function ScratchOffLucyRewardContentItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffLucyRewardContentItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffLucyRewardContentItem:DataDefine()
end

function ScratchOffLucyRewardContentItem:DataDestroy()
end

function ScratchOffLucyRewardContentItem:ComponentDefine()
  self.desTxt = self:AddComponent(UIText, desTxt_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.line = self:AddComponent(UIImage, line_path)
end

function ScratchOffLucyRewardContentItem:ComponentDestroy()
  self.desTxt = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.line = nil
end

function ScratchOffLucyRewardContentItem:SetData(itemInfo, isLast)
  if itemInfo == nil then
    return
  end
  self.desTxt:SetText(Localization:GetString("2000701", itemInfo.diamondProportion .. "%"))
  self.icon1:LoadSprite(itemInfo.icon)
  self.icon2:LoadSprite(itemInfo.icon)
  self.icon3:LoadSprite(itemInfo.icon)
  self.line:SetActive(not isLast)
end

return ScratchOffLucyRewardContentItem
