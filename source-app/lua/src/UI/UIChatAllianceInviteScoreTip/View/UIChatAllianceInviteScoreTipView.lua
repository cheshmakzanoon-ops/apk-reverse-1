local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIChatAllianceInviteScoreTipView = BaseClass("UIChatAllianceInviteScoreTipView", base)
local Localization = CS.GameEntry.Localization
local UIChatAllianceInviteScoreCell = require("UI.UIChatAllianceInviteScoreTip.Component.UIChatAllianceInviteScoreCell")

function UIChatAllianceInviteScoreTipView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
end

function UIChatAllianceInviteScoreTipView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatAllianceInviteScoreTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compScoreMemberPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 1)
  self.compScoreEngagementPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 2)
  self.compScoreGiftPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 3)
  self.compScorePowerPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 4)
  self.compScoreR4LimitPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 5)
  self.compScoreBlackIndustryPanel = self.viewSkin:AddComponent(self, UIChatAllianceInviteScoreCell, 6)
end

function UIChatAllianceInviteScoreTipView:ComponentDestroy()
  self.viewSkin = nil
  self.compScoreMemberPanel = nil
  self.compScoreEngagementPanel = nil
  self.compScoreGiftPanel = nil
  self.compScorePowerPanel = nil
  self.compScoreR4LimitPanel = nil
  self.compScoreBlackIndustryPanel = nil
  base.ComponentDestroy(self)
end

function UIChatAllianceInviteScoreTipView:DataDefine()
end

function UIChatAllianceInviteScoreTipView:DataDestroy()
  self.targetPos = nil
  self.isMyChat = nil
  self.chatThemeIndex = nil
  self.scoreInfo = nil
end

function UIChatAllianceInviteScoreTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIChatAllianceInviteScoreTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChatAllianceInviteScoreTipView:RefreshShow()
  base.RefreshShow(self)
  self.isMyChat = self.param.isMyChat
  self.chatThemeIndex = self.param.chatThemeIndex
  self.scoreInfo = self.param.scoreInfo
  if self.chatThemeIndex == nil then
    self.chatThemeIndex = 1
  end
  local allianceScore = 0
  local powerScore = 0
  local rewardScore = 0
  local dailyTaskScore = 0
  local r4LimitScore = 0
  local blackIndustryScore = 0
  if self.scoreInfo then
    allianceScore = Mathf.RoundTo(self.scoreInfo.allianceScore or 0, 1)
    powerScore = Mathf.RoundTo(self.scoreInfo.powerScore or 0, 1)
    rewardScore = Mathf.RoundTo(self.scoreInfo.rewardScore or 0, 1)
    dailyTaskScore = Mathf.RoundTo(self.scoreInfo.dailyTaskScore or 0, 1)
    r4LimitScore = Mathf.RoundTo(self.scoreInfo.r4LimitScore or 0, 1)
    blackIndustryScore = Mathf.RoundTo(self.scoreInfo.blackIndustryScore or 0, 1)
  end
  self.compScoreMemberPanel:SetData(AllianceInvite_CellType.Member, self.isMyChat, self.chatThemeIndex, allianceScore)
  self.compScorePowerPanel:SetData(AllianceInvite_CellType.Power, self.isMyChat, self.chatThemeIndex, powerScore)
  self.compScoreGiftPanel:SetData(AllianceInvite_CellType.Gift, self.isMyChat, self.chatThemeIndex, rewardScore)
  self.compScoreEngagementPanel:SetData(AllianceInvite_CellType.Engagement, self.isMyChat, self.chatThemeIndex, dailyTaskScore)
  if r4LimitScore ~= 0 then
    self.compScoreR4LimitPanel:SetActive(true)
    self.compScoreR4LimitPanel:SetData(AllianceInvite_CellType.R4Limit, self.isMyChat, self.chatThemeIndex, r4LimitScore)
  else
    self.compScoreR4LimitPanel:SetActive(false)
  end
  if blackIndustryScore ~= 0 then
    self.compScoreBlackIndustryPanel:SetActive(true)
    self.compScoreBlackIndustryPanel:SetData(AllianceInvite_CellType.BlackIndustry, self.isMyChat, self.chatThemeIndex, blackIndustryScore)
  else
    self.compScoreBlackIndustryPanel:SetActive(false)
  end
  self.bgRoot:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/cfm_tongyon_tip_kuang"))
  self.imgArrow:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/cfm_tongyon_tip_jiao_3"))
end

return UIChatAllianceInviteScoreTipView
