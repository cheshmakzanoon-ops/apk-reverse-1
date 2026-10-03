local base = UIBaseContainer
local UIAllianceInfoScorePanel = BaseClass("UIAllianceInfoScorePanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIAllianceInfoStarItem = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoStarItem")

function UIAllianceInfoScorePanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceInfoScorePanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceInfoScorePanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgScoreBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compStarItem1 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 3)
  self.compStarItem2 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 4)
  self.compStarItem3 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 5)
  self.compStarItem4 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 6)
  self.compStarItem5 = self.viewSkin:AddComponent(self, UIAllianceInfoStarItem, 7)
  self.btnScoreInfo = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnScoreInfo:SetOnClick(function()
    self:OnBtnScoreInfoClick()
  end)
end

function UIAllianceInfoScorePanel:ComponentDestroy()
  self.viewSkin = nil
  self.imgScoreBg = nil
  self.textScore = nil
  self.compStarItem1 = nil
  self.compStarItem2 = nil
  self.compStarItem3 = nil
  self.compStarItem4 = nil
  self.compStarItem5 = nil
  self.btnScoreInfo = nil
end

function UIAllianceInfoScorePanel:DataDefine()
end

function UIAllianceInfoScorePanel:DataDestroy()
end

function UIAllianceInfoScorePanel:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceInfoScorePanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceInfoScorePanel:OnBtnScoreInfoClick()
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

function UIAllianceInfoScorePanel:SetData(allianceInfo)
  local comprehensiveScore = allianceInfo.comprehensiveScore or 0
  self.scoreInfo = allianceInfo
  self.textScore:SetText(comprehensiveScore)
  local setting = allianceInfo:GetScoreSetting()
  self.imgScoreBg:LoadSprite(UIAssets.UIAllianceInvite .. setting.ShortScoreBgPath)
  self:RefreshStarPanel(comprehensiveScore)
end

function UIAllianceInfoScorePanel:RefreshStarPanel(comprehensiveScore)
  for i = 1, 5 do
    local starItem = self["compStarItem" .. i]
    starItem:SetData(comprehensiveScore)
    comprehensiveScore = comprehensiveScore - 1
  end
end

return UIAllianceInfoScorePanel
