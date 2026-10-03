local UICommonActivityGiftPackageTitleItem = BaseClass("UICommonActivityGiftPackageTitleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICommonActivityGiftPackageTitleItem:OnCreate()
  base.OnCreate(self)
  self.textTitle = self:AddComponent(UIText, "packTitle")
end

function UICommonActivityGiftPackageTitleItem:OnDestroy()
  base.OnDestroy(self)
end

function UICommonActivityGiftPackageTitleItem:OnEnable()
  base.OnEnable(self)
end

function UICommonActivityGiftPackageTitleItem:OnDisable()
  base.OnDisable(self)
end

function UICommonActivityGiftPackageTitleItem:SetData(param)
  self.textTitle:SetLocalText(param.title)
end

return UICommonActivityGiftPackageTitleItem
