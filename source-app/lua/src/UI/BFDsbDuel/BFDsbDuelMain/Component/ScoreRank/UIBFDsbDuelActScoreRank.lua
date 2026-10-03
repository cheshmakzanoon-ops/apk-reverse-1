local base = UIBaseContainer
local UIBFDsbDuelActScoreRank = BaseClass("UIBFDsbDuelActScoreRank", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActScoreRankItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.ScoreRank.UIBFDsbDuelActScoreRankItem")
local UIBFDsbDuelActScoreSelect = require("UI.BFDsbDuel.BFDsbDuelMain.Component.ScoreRank.UIBFDsbDuelActScoreSelect")

function UIBFDsbDuelActScoreRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActScoreRank:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScoreRank:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textAlliance = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView2ScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compRankSelf = self.viewSkin:AddComponent(self, UIBFDsbDuelActScoreRankItem, 5)
  self.compUIBFDsbDuelActScoreSelect = self.viewSkin:AddComponent(self, UIBFDsbDuelActScoreSelect, 6)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnScoreInfo = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnScoreInfo:SetOnClick(function()
    self:OnBtnScoreInfoClick()
  end)
  self.btnPointInfo = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnPointInfo:SetOnClick(function()
    self:OnBtnPointInfoClick()
  end)
  self.btnPowerInfo = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnPowerInfo:SetOnClick(function()
    self:OnBtnPowerInfoClick()
  end)
  self.compEmptyTxt = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self:InitLoopListView()
  self.compRankSelf:SetActive(false)
end

function UIBFDsbDuelActScoreRank:ComponentDestroy()
  self:ClearLoopList()
  self.viewSkin = nil
  self.textRank = nil
  self.textAlliance = nil
  self.loopListView2ScrollView = nil
  self.compContent = nil
  self.compRankSelf = nil
  self.compUIBFDsbDuelActScoreSelect = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.btnScoreInfo = nil
  self.btnPointInfo = nil
  self.btnPowerInfo = nil
  self.compEmptyTxt = nil
end

function UIBFDsbDuelActScoreRank:DataDefine()
  self.rankInfos = {}
  self.curShowGroupIndex = BattlefieldDsbConst.BF_DSB_GROUP_TYPE.ALL
  self.itemIndex = 0
end

function UIBFDsbDuelActScoreRank:DataDestroy()
  self.rankInfos = nil
  self.curShowGroupIndex = nil
  self.itemIndex = nil
end

function UIBFDsbDuelActScoreRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
end

function UIBFDsbDuelActScoreRank:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScoreRank:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true}, BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward)
end

function UIBFDsbDuelActScoreRank:InitLoopListView()
  self.loopListView2ScrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIBFDsbDuelActScoreRank:ClearLoopList()
  self.compContent:RemoveComponents(UIBFDsbDuelActScoreRankItem)
  self.loopListView2ScrollView:ClearAllItems()
end

function UIBFDsbDuelActScoreRank:RefreshLoopListView()
  if #self.rankInfos == 0 then
    self.loopListView2ScrollView:SetActive(false)
    self.compEmptyTxt:SetActive(true)
  else
    self.compEmptyTxt:SetActive(false)
    self.loopListView2ScrollView:SetActive(true)
    self.loopListView2ScrollView:SetListItemCount(#self.rankInfos, false, false)
    self.loopListView2ScrollView:RefreshAllShownItem()
  end
end

function UIBFDsbDuelActScoreRank:OnGetItemByIndex(listview, index)
  local count = table.count(self.rankInfos)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listview:NewListViewItem("UIBFDsbDuelActScoreRankItem")
  local script = self.compContent:GetComponent(item.gameObject.name, UIBFDsbDuelActScoreRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(UIBFDsbDuelActScoreRankItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.rankInfos[index])
  return item
end

function UIBFDsbDuelActScoreRank:UpdateSelfRankInfo(selfRankInfo)
  local showSelfRank = not table.IsNullOrEmpty(selfRankInfo) and (self.curShowGroupIndex == BattlefieldDsbConst.BF_DSB_GROUP_TYPE.ALL or self.curShowGroupIndex == BattlefieldDsbDuelUtils.ActInfo:GetSelfGroup())
  self.compRankSelf:SetActive(showSelfRank)
  self.loopListView2ScrollView:SetSizeDeltaXY(-8, showSelfRank and -270 or -100)
  if table.IsNullOrEmpty(selfRankInfo) then
    return
  end
  self.compRankSelf:SetData(selfRankInfo)
end

function UIBFDsbDuelActScoreRank:ReInit()
  self.textRank:SetText(Localization:GetString("302043"))
  self.textAlliance:SetText(Localization:GetString("393081"))
  self.textBtnReward:SetText(Localization:GetString("131004"))
  self.compUIBFDsbDuelActScoreSelect:SetData()
  self:RequestRankData()
end

function UIBFDsbDuelActScoreRank:RequestRankData()
  BattlefieldDsbDuelUtils.ActInfo:SendActGroupListMsg(self.curShowGroupIndex)
end

function UIBFDsbDuelActScoreRank:OnDsbDuelActRankInfoUpdate()
  self.rankInfos = BattlefieldDsbDuelUtils.ActInfo:GetAllianceRankList()
  self:RefreshLoopListView()
  self:UpdateSelfRankInfo(BattlefieldDsbDuelUtils.ActInfo:GetSelfAllianceRank())
end

function UIBFDsbDuelActScoreRank:OnBtnScoreInfoClick()
  local param = {
    alignObject = self.btnScoreInfo.gameObject,
    title = "dsb_duel_guide_tips_1020",
    offsetY = -30
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActScoreTipsView, {anim = true}, param)
end

function UIBFDsbDuelActScoreRank:OnBtnPointInfoClick()
  local param = {
    alignObject = self.btnPointInfo.gameObject,
    title = "dsb_duel_guide_tips_1021",
    offsetY = -30
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActScoreTipsView, {anim = true}, param)
end

function UIBFDsbDuelActScoreRank:OnBtnPowerInfoClick()
  local param = {
    alignObject = self.btnPowerInfo.gameObject,
    title = "dsb_duel_guide_tips_1022",
    offsetY = -30
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActScoreTipsView, {anim = true}, param)
end

return UIBFDsbDuelActScoreRank
