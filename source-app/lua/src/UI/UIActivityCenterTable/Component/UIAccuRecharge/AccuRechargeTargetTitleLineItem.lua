local base = UIBaseContainer
local AccuRechargeTargetTitleLineItem = BaseClass("AccuRechargeTargetTitleLineItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AccuRechargeTargetTitleLineItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AccuRechargeTargetTitleLineItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AccuRechargeTargetTitleLineItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textRange = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function AccuRechargeTargetTitleLineItem:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgBg = nil
  self.textTitle = nil
  self.textRange = nil
  self.btn = nil
end

function AccuRechargeTargetTitleLineItem:DataDefine()
end

function AccuRechargeTargetTitleLineItem:DataDestroy()
end

function AccuRechargeTargetTitleLineItem:OnAddListener()
  base.OnAddListener(self)
end

function AccuRechargeTargetTitleLineItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AccuRechargeTargetTitleLineItem:OnBtnClick()
end

function AccuRechargeTargetTitleLineItem:RefreshData(data, score, activityId, iconPath, index, dataNum)
  if not data then
    return
  end
  self.textTitle:SetLocalText(data.title)
  self.rawImgBg:LoadSpriteAsync(data.icon)
  self.textRange:SetText(string.format("%s-%s", data.rangeMin, data.rangeMax))
end

return AccuRechargeTargetTitleLineItem
