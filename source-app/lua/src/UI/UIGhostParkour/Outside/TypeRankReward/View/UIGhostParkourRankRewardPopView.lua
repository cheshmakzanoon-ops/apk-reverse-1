local UIGhostParkourRankRewardPopView = BaseClass("UIGhostParkourRankRewardPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardObj = require("UI.UIGhostParkour.Outside.TypeRankReward.Component.RankScrollViewComponent")

function UIGhostParkourRankRewardPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if self.selectIndex == GhostParkourTypeRank.ServerRank then
    self.toggleToggle2:SetIsOn(true)
  elseif self.selectIndex == GhostParkourTypeRank.AreaRank then
    self.toggleToggle3:SetIsOn(true)
  elseif self.selectIndex == GhostParkourTypeRank.AllianceRank then
    self.toggleToggle1:SetIsOn(true)
  end
  self:RefreshList(self.selectIndex)
end

function UIGhostParkourRankRewardPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankRewardPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggleToggle1 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.textTab1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTab12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.toggleToggle2 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.textTab2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTab22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compAllianceRankScrollView = self.viewSkin:AddComponent(self, RewardObj, 10)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.toggleToggle3 = self.viewSkin:AddComponent(self, UIToggle, 12)
  self.textTab3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTab33 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.toggleToggle1:SetIsOn(true)
  self.toggleToggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(GhostParkourTypeRank.AllianceRank)
    end
  end)
  self.toggleToggle2:SetIsOn(false)
  self.toggleToggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(GhostParkourTypeRank.ServerRank)
    end
  end)
  self.toggleToggle3:SetIsOn(false)
  self.toggleToggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(GhostParkourTypeRank.AreaRank)
    end
  end)
end

function UIGhostParkourRankRewardPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.toggleToggle1 = nil
  self.textTab1 = nil
  self.textTab12 = nil
  self.toggleToggle2 = nil
  self.textTab2 = nil
  self.textTab22 = nil
  self.compAllianceRankScrollView = nil
  self.btnInfo = nil
  self.toggleToggle3 = nil
  self.textTab3 = nil
  self.textTab33 = nil
end

function UIGhostParkourRankRewardPopView:DataDefine()
  self.selectIndex = self:GetUserData() or GhostParkourTypeRank.AllianceRank
end

function UIGhostParkourRankRewardPopView:DataDestroy()
  self.selectIndex = nil
end

function UIGhostParkourRankRewardPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourTypeRankRewardRefresh, self.RefreshList)
  self:AddUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
end

function UIGhostParkourRankRewardPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourTypeRankRewardRefresh, self.RefreshList)
  self:RemoveUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UIGhostParkourRankRewardPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankRewardPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankRewardPopView:OnBtnInfoClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("ghost_parkour_champion_alliance_reward")
  param.alignObject = self.btnInfo
  param.yPosFix = -50
  param.addPosX = -15 * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = true
  param.width = 600
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UIGhostParkourRankRewardPopView:RefreshList(type)
  if self.selectIndex == type then
    self:TrySendGetDataMsg(type)
    if self.toggleToggle1:GetIsOn() == true then
      self.compAllianceRankScrollView:SetActive(true)
      self.compAllianceRankScrollView:RefreshList(type)
    elseif self.toggleToggle2:GetIsOn() == true then
      self.compAllianceRankScrollView:SetActive(true)
      self.compAllianceRankScrollView:RefreshList(type)
    elseif self.toggleToggle3:GetIsOn() == true then
      self.compAllianceRankScrollView:SetActive(true)
      self.compAllianceRankScrollView:RefreshList(type)
    end
  end
end

function UIGhostParkourRankRewardPopView:ToggleControlBorS(type)
  self.selectIndex = type
  self:RefreshList(type)
end

function UIGhostParkourRankRewardPopView:TrySendGetDataMsg(type)
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  local showData = DataCenter.LWGhostParkourDataManager:GetTypeRankRewardInfo(self.round, type)
  if showData == nil then
    DataCenter.LWGhostParkourDataManager:SendGhostTypeRankRewardInfoMessage(self.round, type)
  end
end

function UIGhostParkourRankRewardPopView:SendMsg()
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if self.toggleToggle1:GetIsOn() == true then
    DataCenter.LWGhostParkourDataManager:SendGhostTypeRankRewardInfoMessage(self.round, GhostParkourTypeRank.AllianceRank)
  elseif self.toggleToggle2:GetIsOn() == true then
    DataCenter.LWGhostParkourDataManager:SendGhostTypeRankRewardInfoMessage(self.round, GhostParkourTypeRank.ServerRank)
  elseif self.toggleToggle3:GetIsOn() == true then
    DataCenter.LWGhostParkourDataManager:SendGhostTypeRankRewardInfoMessage(self.round, GhostParkourTypeRank.AreaRank)
  end
end

return UIGhostParkourRankRewardPopView
