local MailDecoItem = BaseClass("MailDecoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local IconPath = {
  [3] = "Assets/Main/Sprites/ItemIcons/daoju_building_103301000.png",
  [4] = "Assets/Main/Sprites/ItemIcons/daoju_building_103401000.png",
  [5] = "Assets/Main/Sprites/ItemIcons/daoju_building_103506000.png"
}

function MailDecoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDecoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDecoItem:ComponentDefine()
  self.quality1 = self:AddComponent(UIImage, "quality1")
  self.quality2 = self:AddComponent(UIImage, "quality2")
  self.icon1 = self:AddComponent(UIImage, "icon1")
  self.icon2 = self:AddComponent(UIImage, "icon2")
  self.num1 = self:AddComponent(UIText, "num1")
  self.num2 = self:AddComponent(UIText, "num2")
  self.level1 = self:AddComponent(UIText, "level1")
  self.level2 = self:AddComponent(UIText, "level2")
end

function MailDecoItem:ComponentDestroy()
  self.quality1 = nil
  self.quality2 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.num1 = nil
  self.num2 = nil
  self.level1 = nil
  self.level2 = nil
end

function MailDecoItem:SetData(param1, param2)
  self.quality1:LoadSprite(UIUtil.GetItemQualityBg(param1.decoQualityId))
  self.icon1:LoadSprite(IconPath[param1.decoQualityId])
  self.num1:SetLocalText(320479, param1.totalCount)
  self.level1:SetText("Lv." .. param1.totalLv)
  self.quality2:LoadSprite(UIUtil.GetItemQualityBg(param2.decoQualityId))
  self.icon2:LoadSprite(IconPath[param2.decoQualityId])
  self.num2:SetLocalText(320479, param2.totalCount)
  self.level2:SetText("Lv." .. param2.totalLv)
end

function MailDecoItem:DataDefine()
end

function MailDecoItem:DataDestroy()
end

function MailDecoItem:OnEnable()
  base.OnEnable(self)
end

function MailDecoItem:OnDisable()
  base.OnDisable(self)
end

function MailDecoItem:OnAddListener()
  base.OnAddListener(self)
end

function MailDecoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailDecoItem
