local base = UIBaseContainer
local UIAllianceInfoItem = BaseClass("UIAllianceInfoItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAllianceInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceInfoItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compFireEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textFireTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compFireEffect:SetActive(false)
  self.textFireTip:SetActive(false)
end

function UIAllianceInfoItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textTip = nil
  self.btnInfo = nil
  self.compFireEffect = nil
  self.textFireTip = nil
end

function UIAllianceInfoItem:DataDefine()
end

function UIAllianceInfoItem:DataDestroy()
end

function UIAllianceInfoItem:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceInfoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceInfoItem:Refresh(cellType, tipText, isMyChat, chatThemeIndex, showFire)
  self.cellType = cellType
  self.imgIcon:LoadSprite(AllianceInvite_CellSetting[cellType].IconPath)
  self.textTip:SetText(tipText)
  if chatThemeIndex then
    local myChatIndex = isMyChat and 2 or 1
    self.imgIcon:SetAlpha(ChatUIThemeConfig.AllianceInvite_IconAlpha[chatThemeIndex])
    self.imgBg:SetColor(ChatUIThemeConfig.AllianceInvite_GridBgColor[myChatIndex][chatThemeIndex])
    self.textTip:SetColor(ChatUIThemeConfig.AllianceInvite_CellTextColor[chatThemeIndex])
  end
  if showFire then
    self.compFireEffect:SetActive(true)
    self.textFireTip:SetActive(true)
    self.textTip:SetActive(false)
    self.textFireTip:SetText(tipText)
  else
    self.compFireEffect:SetActive(false)
    self.textFireTip:SetActive(false)
    self.textTip:SetActive(true)
    self.textTip:SetText(tipText)
  end
end

function UIAllianceInfoItem:OnBtnInfoClick()
  if self.cellType then
    UIUtil.ShowBubbleTipsAuto(Localization:GetString(AllianceInvite_CellSetting[self.cellType].dialogTextId), self.imgIcon.transform.position, 0, -30, 0)
  end
end

return UIAllianceInfoItem
