local UILWSurfingBattleRankRewardView = BaseClass("UILWSurfingBattleRankRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWPVPArenaAllianceRewardObj = require("UI.UISurfing.UIAct.AllianceRankRewardPop.Component.AllianceRankScrollViewComponent")

function UILWSurfingBattleRankRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if self.selectIndex == 2 then
    self.toggleToggle2:SetIsOn(true)
  else
    self.toggleToggle1:SetIsOn(true)
  end
  self:RefreshList(self.selectIndex)
end

function UILWSurfingBattleRankRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingBattleRankRewardView:ComponentDefine()
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
  self.compAllianceRankScrollView = self.viewSkin:AddComponent(self, LWPVPArenaAllianceRewardObj, 10)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.toggleToggle1:SetIsOn(true)
  self.toggleToggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(SurfingBattleRankType.AllianceRank)
    end
  end)
  self.toggleToggle2:SetIsOn(false)
  self.toggleToggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(SurfingBattleRankType.TopServersRank)
    end
  end)
end

function UILWSurfingBattleRankRewardView:ComponentDestroy()
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
end

function UILWSurfingBattleRankRewardView:DataDefine()
  self.selectIndex = self:GetUserData()
end

function UILWSurfingBattleRankRewardView:DataDestroy()
  self.selectIndex = nil
end

function UILWSurfingBattleRankRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingRefreshRewardInfo, self.RefreshList)
  self:AddUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
end

function UILWSurfingBattleRankRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingRefreshRewardInfo, self.RefreshList)
  self:RemoveUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UILWSurfingBattleRankRewardView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleRankRewardView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleRankRewardView:OnBtnInfoClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("parkour_rank_reward_desc")
  param.alignObject = self.btnInfo
  param.yPosFix = -50
  param.addPosX = -15 * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = true
  param.width = 600
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UILWSurfingBattleRankRewardView:RefreshList(type)
  self:TrySendGetDataMsg(type)
  if self.toggleToggle1:GetIsOn() == true then
    self.compAllianceRankScrollView:SetActive(true)
    self.compAllianceRankScrollView:RefreshList(type)
  elseif self.toggleToggle2:GetIsOn() == true then
    self.compAllianceRankScrollView:SetActive(true)
    self.compAllianceRankScrollView:RefreshList(type)
  end
end

function UILWSurfingBattleRankRewardView:ToggleControlBorS(type)
  self:RefreshList(type)
end

function UILWSurfingBattleRankRewardView:TrySendGetDataMsg(type)
  local showData = DataCenter.LWSurfingDataManager:GetRankRewardInfos(type)
  self.round = DataCenter.LWSurfingDataManager:GetRound()
  if showData == nil then
    DataCenter.LWSurfingDataManager:GetParkourRankRewardInfo(self.round, type)
  end
end

function UILWSurfingBattleRankRewardView:SendMsg()
  self.round = DataCenter.LWSurfingDataManager:GetRound()
  if self.toggleToggle1:GetIsOn() == true then
    DataCenter.LWSurfingDataManager:GetParkourRankRewardInfo(self.round, SurfingBattleRankType.AllianceRank)
  elseif self.toggleToggle2:GetIsOn() == true then
    DataCenter.LWSurfingDataManager:GetParkourRankRewardInfo(self.round, SurfingBattleRankType.TopServersRank)
  end
end

return UILWSurfingBattleRankRewardView
