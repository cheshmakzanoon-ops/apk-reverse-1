local base = UIBaseContainer
local UIAllianceInfoHorizontalPanel = BaseClass("UIAllianceInfoHorizontalPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIAllianceInfoItem = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoItem")
local UIAllianceInfoScorePanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoScorePanel")

function UIAllianceInfoHorizontalPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceInfoHorizontalPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceInfoHorizontalPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFlagIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgCountry = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textLanguage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnBaseInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBaseInfo:SetOnClick(function()
    self:OnBtnBaseInfoClick()
  end)
  self.compInfoMemberPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 6)
  self.compInfoPowerPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 7)
  self.compInfoGiftPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 8)
  self.compInfoEngagementPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 9)
  self.imgBestIcon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.compScorePanel = self.viewSkin:AddComponent(self, UIAllianceInfoScorePanel, 11)
end

function UIAllianceInfoHorizontalPanel:ComponentDestroy()
  self.viewSkin = nil
  self.imgFlagIcon = nil
  self.textName = nil
  self.imgCountry = nil
  self.textLanguage = nil
  self.btnBaseInfo = nil
  self.compInfoMemberPanel = nil
  self.compInfoPowerPanel = nil
  self.compInfoGiftPanel = nil
  self.compInfoEngagementPanel = nil
  self.imgBestIcon = nil
  self.compScorePanel = nil
end

function UIAllianceInfoHorizontalPanel:DataDefine()
end

function UIAllianceInfoHorizontalPanel:DataDestroy()
end

function UIAllianceInfoHorizontalPanel:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceInfoHorizontalPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceInfoHorizontalPanel:OnBtnBaseInfoClick()
  if self.allianceName and self.allianceId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceName, self.allianceId)
  end
end

function UIAllianceInfoHorizontalPanel:OnBtnScoreInfoClick()
  if self.scoreInfo == nil then
    return
  end
  local param = {}
  param.cfg = self.cfg
  param.width = 376
  param.alignObject = self.textScore
  param.yPosFix = -35
  param.xPadding = 20
  param.showArrow = true
  param.preferTop = true
  param.isMyChat = self.isMyChat
  param.chatThemeIndex = self.chatThemeIndex
  param.scoreInfo = self.scoreInfo
  if not IsNull(self.textScore) and not IsNull(self.textScore.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatAllianceInviteScoreTip, {anim = true}, param)
  end
end

local function Refresh(self, allianceInfo, showBest, comprehensiveScoreShowValue)
  self.imgBestIcon:SetActive(showBest)
  self.isMyChat = true
  self.chatThemeIndex = 1
  self.textName:SetText(allianceInfo:GetAllianceFullName())
  self.imgCountry:LoadSprite(allianceInfo:GetCountryFlagPath())
  self.imgFlagIcon:LoadSprite(allianceInfo:GetAllianceFlagPath())
  self.textLanguage:SetText(allianceInfo:GetLanguageStr())
  local cellType = AllianceInvite_CellType.Member
  local showFire = allianceInfo:NeedShowFireByScoreType(cellType)
  self.compInfoMemberPanel:Refresh(cellType, allianceInfo:GetMemberStr(), self.isMyChat, self.chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Power
  showFire = allianceInfo:NeedShowFireByScoreType(cellType)
  self.compInfoPowerPanel:Refresh(cellType, allianceInfo:GetPowerStr(), self.isMyChat, self.chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Gift
  showFire = allianceInfo:NeedShowFireByScoreType(cellType)
  self.compInfoGiftPanel:Refresh(cellType, allianceInfo:GetGiftLevelStr(), self.isMyChat, self.chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Engagement
  showFire = allianceInfo:NeedShowFireByScoreType(cellType)
  self.compInfoEngagementPanel:Refresh(cellType, allianceInfo:GetAllianceEngagementPointStr(), self.isMyChat, self.chatThemeIndex, showFire)
  if allianceInfo.comprehensiveScore and (comprehensiveScoreShowValue == nil or comprehensiveScoreShowValue < allianceInfo.comprehensiveScore) then
    self.compScorePanel:SetActive(true)
    self.compScorePanel:SetData(allianceInfo)
  else
    self.compScorePanel:SetActive(false)
  end
end

function UIAllianceInfoHorizontalPanel:RefreshByBaseInfo(allianceInfo, showBest, comprehensiveScoreShowValue)
  self.allianceName = allianceInfo.allianceName
  self.allianceId = allianceInfo.uid
  self.scoreInfo = allianceInfo
  Refresh(self, allianceInfo, showBest, comprehensiveScoreShowValue)
end

function UIAllianceInfoHorizontalPanel:RefreshByRecommendInfo(allianceInfo, showBest, comprehensiveScoreShowValue)
  self.allianceName = allianceInfo.alliancename
  self.allianceId = allianceInfo.allianceId
  self.scoreInfo = allianceInfo
  Refresh(self, allianceInfo, showBest, comprehensiveScoreShowValue)
end

function UIAllianceInfoHorizontalPanel:RefreshStarPanel(comprehensiveScore)
  for i = 1, 5 do
    local starItem = self["compStarItem" .. i]
    starItem:SetData(comprehensiveScore)
    comprehensiveScore = comprehensiveScore - 1
  end
end

return UIAllianceInfoHorizontalPanel
