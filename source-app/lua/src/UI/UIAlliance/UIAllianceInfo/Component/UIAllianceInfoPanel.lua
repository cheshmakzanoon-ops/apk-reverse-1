local base = UIBaseContainer
local UIAllianceInfoPanel = BaseClass("UIAllianceInfoPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIAllianceInfoItem = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoItem")
local UIAllianceInfoStarItem = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoStarItem")

function UIAllianceInfoPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceInfoPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceInfoPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFlagIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgCountry = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textLanguage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnBaseInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBaseInfo:SetOnClick(function()
    self:OnBtnBaseInfoClick()
  end)
  self.compInfoMemberPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 6)
  self.compInfoPowerPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 7)
  self.compInfoGiftPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 8)
  self.compInfoEngagementPanel = self.viewSkin:AddComponent(self, UIAllianceInfoItem, 9)
  self.compScorePanel = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compScoreInfoImg = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textScoreTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compStarItem1 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 13)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnScoreInfo = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnScoreInfo:SetOnClick(function()
    self:OnBtnScoreInfoClick()
  end)
  self.imgScoreBg = self.viewSkin:AddComponent(self, UIImage, 16)
  self.compStarItem2 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 17)
  self.compStarItem3 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 18)
  self.compStarItem4 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 19)
  self.compStarItem5 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 20)
  self.textScoreTip:SetLocalText("alliance_invite_point_average")
end

function UIAllianceInfoPanel:ComponentDestroy()
  self.viewSkin = nil
  self.imgFlagIcon = nil
  self.imgCountry = nil
  self.textName = nil
  self.textLanguage = nil
  self.btnBaseInfo = nil
  self.compInfoMemberPanel = nil
  self.compInfoPowerPanel = nil
  self.compInfoGiftPanel = nil
  self.compInfoEngagementPanel = nil
  self.compScorePanel = nil
  self.compScoreInfoImg = nil
  self.textScoreTip = nil
  self.compStarItem1 = nil
  self.textScore = nil
  self.btnScoreInfo = nil
  self.imgScoreBg = nil
  self.compStarItem2 = nil
  self.compStarItem3 = nil
  self.compStarItem4 = nil
  self.compStarItem5 = nil
end

function UIAllianceInfoPanel:DataDefine()
  self.recommendInfo = nil
  self.isMyChat = nil
  self.chatThemeIndex = nil
end

function UIAllianceInfoPanel:DataDestroy()
end

function UIAllianceInfoPanel:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceInfoPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceInfoPanel:OnBtnBaseInfoClick()
  if self.allianceName and self.allianceId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceName, self.allianceId)
  end
end

function UIAllianceInfoPanel:OnBtnScoreInfoClick()
  if self.scoreInfo == nil then
    return
  end
  local param = {}
  param.cfg = self.cfg
  param.width = 376
  param.alignObject = self.compScoreInfoImg
  param.yPosFix = 25
  param.xPadding = 20
  param.showArrow = true
  param.isMyChat = self.isMyChat
  param.chatThemeIndex = self.chatThemeIndex
  param.scoreInfo = self.scoreInfo
  if not IsNull(self.compScoreInfoImg) and not IsNull(self.compScoreInfoImg.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatAllianceInviteScoreTip, {anim = true}, param)
  end
end

function UIAllianceInfoPanel:Refresh(recommendInfo, isMyChat, chatThemeIndex)
  self.recommendInfo = recommendInfo
  self.isMyChat = isMyChat
  self.chatThemeIndex = chatThemeIndex
  self.allianceName = self.recommendInfo.alliancename
  self.allianceId = self.recommendInfo.allianceId
  self.scoreInfo = self.recommendInfo
  self.textName:SetText(self.recommendInfo:GetAllianceFullName())
  self.imgCountry:LoadSprite(self.recommendInfo:GetCountryFlagPath())
  self.imgFlagIcon:LoadSprite(self.recommendInfo:GetAllianceFlagPath())
  self.textLanguage:SetText(self.recommendInfo:GetLanguageStr())
  local cellType = AllianceInvite_CellType.Member
  local showFire = self.recommendInfo:NeedShowFireByScoreType(cellType)
  self.compInfoMemberPanel:Refresh(cellType, self.recommendInfo:GetMemberStr(), isMyChat, chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Power
  showFire = self.recommendInfo:NeedShowFireByScoreType(cellType)
  self.compInfoPowerPanel:Refresh(cellType, self.recommendInfo:GetPowerStr(), isMyChat, chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Gift
  showFire = self.recommendInfo:NeedShowFireByScoreType(cellType)
  self.compInfoGiftPanel:Refresh(cellType, self.recommendInfo:GetGiftLevelStr(), isMyChat, chatThemeIndex, showFire)
  cellType = AllianceInvite_CellType.Engagement
  showFire = self.recommendInfo:NeedShowFireByScoreType(cellType)
  self.compInfoEngagementPanel:Refresh(cellType, self.recommendInfo:GetAllianceEngagementPointStr(), isMyChat, chatThemeIndex, showFire)
  if not isMyChat and self.recommendInfo.comprehensiveScore then
    local comprehensiveScore = self.recommendInfo.comprehensiveScore
    self.compScorePanel:SetActive(true)
    self.textScore:SetText(comprehensiveScore)
    local setting = self.recommendInfo:GetScoreSetting()
    self.imgScoreBg:LoadSprite(UIAssets.UIAllianceInvite .. setting.LongScoreBgPath)
    self:RefreshStarPanel(comprehensiveScore)
  else
    self.compScorePanel:SetActive(false)
  end
  if chatThemeIndex then
    self.textName:SetColor(ChatUIThemeConfig.AllianceInvite_NameColor[chatThemeIndex])
    self.textLanguage:SetColor(ChatUIThemeConfig.AllianceInvite_NameColor[chatThemeIndex])
  end
end

function UIAllianceInfoPanel:RefreshStarPanel(comprehensiveScore)
  for i = 1, 5 do
    local starItem = self["compStarItem" .. i]
    starItem:SetData(comprehensiveScore)
    comprehensiveScore = comprehensiveScore - 1
  end
end

return UIAllianceInfoPanel
