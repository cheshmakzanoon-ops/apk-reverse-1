local base = UIBaseContainer
local UIChatAllianceInviteScoreCell = BaseClass("UIChatAllianceInviteScoreCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIChatAllianceInviteScoreCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIChatAllianceInviteScoreCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatAllianceInviteScoreCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgCellBg = self.viewSkin:AddComponent(self, UIImage, 4)
end

function UIChatAllianceInviteScoreCell:ComponentDestroy()
  self.viewSkin = nil
  self.textNumTxt = nil
  self.textTip = nil
  self.imgIcon = nil
  self.imgCellBg = nil
end

function UIChatAllianceInviteScoreCell:DataDefine()
end

function UIChatAllianceInviteScoreCell:DataDestroy()
end

function UIChatAllianceInviteScoreCell:OnAddListener()
  base.OnAddListener(self)
end

function UIChatAllianceInviteScoreCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChatAllianceInviteScoreCell:SetData(cellType, isMyChat, chatThemeIndex, num)
  self.imgIcon:LoadSprite(AllianceInvite_CellSetting[cellType].IconPath)
  self.textTip:SetLocalText(AllianceInvite_CellSetting[cellType].tipTextId)
  self.textNumTxt:SetText(num)
  if num >= DataCenter.AllianceFeatureManager.boldScore then
    self.textNumTxt:SetFontSize(30)
  else
    self.textNumTxt:SetFontSize(26)
  end
  self.imgIcon:SetAlpha(ChatUIThemeConfig.AllianceInvite_IconAlpha[chatThemeIndex])
  self.textTip:SetColor(ChatUIThemeConfig.AllianceInvite_TipTextColor[chatThemeIndex])
  self.textNumTxt:SetColor(ChatUIThemeConfig.AllianceInvite_TipTextColor[chatThemeIndex])
  self.imgCellBg:SetColor(ChatUIThemeConfig.AllianceInvite_TipBgColor[chatThemeIndex])
  if cellType == AllianceInvite_CellType.R4Limit or cellType == AllianceInvite_CellType.BlackIndustry then
    self.textTip:SetColor(ChatUIThemeConfig.AllianceInvite_WarnTextColor[chatThemeIndex])
    self.textNumTxt:SetColor(ChatUIThemeConfig.AllianceInvite_WarnTextColor[chatThemeIndex])
    self.imgCellBg:SetColor(ChatUIThemeConfig.AllianceInvite_WarnBgColor[chatThemeIndex])
  end
end

return UIChatAllianceInviteScoreCell
