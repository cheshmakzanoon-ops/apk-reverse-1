local UILWAlFeatureMemberView = BaseClass("UILWAlFeatureMemberView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWAlFeatureMemberItem = require("UI.UILWAlliance.UILWAlFeatureMember.Component.UILWAlFeatureMemberItem")

function UILWAlFeatureMemberView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlFeatureMemberView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlFeatureMemberView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textTip1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compEmptyPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTip2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTitle:SetLocalText("alliance_invite_btn")
  self.textEmpty:SetLocalText("alliance_invite_tips_empty")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  local isOn = CommonUtil.PlayerPrefsGetBool(SettingKeys.ALLIANCE_FEATURE_HOW_TO_PLAY, true)
  if isOn then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100006}
    })
    CommonUtil.PlayerPrefsSetBool(SettingKeys.ALLIANCE_FEATURE_HOW_TO_PLAY, false)
  end
  self.btnHowToPlay = self:AddComponent(UIButton, "Root/TopBar/HowToPlayBtn")
  self.btnHowToPlay:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100006}
    })
  end)
end

function UILWAlFeatureMemberView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textTitle = nil
  self.scrollView = nil
  self.btnBack = nil
  self.textTip1 = nil
  self.compEmptyPanel = nil
  self.textEmpty = nil
  self.textTip2 = nil
end

function UILWAlFeatureMemberView:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AllianceManagerGainRecommendationInfo)
end

function UILWAlFeatureMemberView:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.AllianceManagerGainRecommendationInfo)
end

function UILWAlFeatureMemberView:DataDestroy()
  self.tomorrowZeroTime = nil
end

function UILWAlFeatureMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceGainRecommendationInfo, self.OnAllianceGainRecommendationInfo)
  self:AddUIListener(EventId.AllianceRecommendationInvite, self.OnAllianceRecommendationInvite)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UILWAlFeatureMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceGainRecommendationInfo, self.OnAllianceGainRecommendationInfo)
  self:RemoveUIListener(EventId.AllianceRecommendationInvite, self.OnAllianceRecommendationInvite)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UILWAlFeatureMemberView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWAlFeatureMemberView:OnAllianceGainRecommendationInfo(msg)
  self.ctrl:OnAllianceGainRecommendationInfo(msg)
  self:Refresh(true)
end

function UILWAlFeatureMemberView:OnAllianceRecommendationInvite(msg)
  self.ctrl:OnAllianceRecommendationInvite(msg)
  self:Refresh(false)
end

function UILWAlFeatureMemberView:Refresh(needReInit)
  local data = self.ctrl.recommendation
  if data and 0 < #data then
    self.compEmptyPanel:SetActive(false)
    self.scrollView:SetActive(true)
    self.showDatalist = data
    if needReInit then
      self.scrollView:SetTotalCount(#self.showDatalist)
      self.scrollView:RefillCells()
    else
      self.scrollView:RefreshCells()
    end
  else
    self.compEmptyPanel:SetActive(true)
    self.scrollView:SetActive(false)
  end
  local maxInviteCountCfg = DataCenter.AllianceFeatureManager.maxInviteCountCfg
  if 0 < self.ctrl.remainCount then
    self.textTip1:SetLocalText("alliance_invite_tips_remains", self.ctrl.remainCount, maxInviteCountCfg)
    self.textTip2:SetActive(false)
    self.tomorrowZeroTime = nil
  else
    self.textTip1:SetLocalText("alliance_invite_tips_remains", self.ctrl.remainCount, maxInviteCountCfg)
    self.textTip2:SetActive(true)
    self.tomorrowZeroTime = UITimeManager:GetInstance():GetTomorrowZero()
  end
end

function UILWAlFeatureMemberView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UILWAlFeatureMemberItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index])
end

function UILWAlFeatureMemberView:OnItemMoveOut(itemObj, index)
end

function UILWAlFeatureMemberView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UILWAlFeatureMemberItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UILWAlFeatureMemberView:Update1000MS()
  if self.tomorrowZeroTime then
    local diff = self.tomorrowZeroTime - UITimeManager:GetInstance():GetServerTime()
    self.textTip2:SetLocalText("alliance_invite_tips_recover", UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  end
end

return UILWAlFeatureMemberView
