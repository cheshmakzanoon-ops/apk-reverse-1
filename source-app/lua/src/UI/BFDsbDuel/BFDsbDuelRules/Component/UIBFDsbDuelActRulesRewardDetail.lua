local base = UIBaseContainer
local UIBFDsbDuelActRulesRewardDetail = BaseClass("UIBFDsbDuelActRulesRewardDetail", UIBaseContainer)
local UIBFDsbDuelActRulesRewardDetailItem = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesRewardDetailItem")
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesRewardDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitToggleEvents()
  self:RefreshRedDot()
end

function UIBFDsbDuelActRulesRewardDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesRewardDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleToggle1 = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.textTab1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTab12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.toggleToggle2 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.textTab2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTab22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.loopListView2ScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textTimeTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTimeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compTimeContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compRedAward2 = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.compRedAward1 = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.btnTipReward = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnTipReward:SetOnClick(function()
    self:OnBtnTipRewardClick()
  end)
  self.compViewport = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTimeTips:SetLocalText("dsb_duel_interface_1035")
  self.loopListView2ScrollView:InitListView(0, function(loopScroll, index)
    return self:OnGetItemByIndex(loopScroll, index)
  end)
  self.loopListView2ScrollView:SetOnDragingAction(function()
    self:OnDraggingAction()
  end)
end

function UIBFDsbDuelActRulesRewardDetail:ComponentDestroy()
  self:ClearItems()
  self.viewSkin = nil
  self.toggleToggle1 = nil
  self.textTab1 = nil
  self.textTab12 = nil
  self.toggleToggle2 = nil
  self.textTab2 = nil
  self.textTab22 = nil
  self.loopListView2ScrollView = nil
  self.compContent = nil
  self.textTimeTips = nil
  self.textTimeTxt = nil
  self.textTips = nil
  self.compTimeContent = nil
  self.compRedAward2 = nil
  self.compRedAward1 = nil
  self.btnTipReward = nil
  self.compViewport = nil
  self.btnInfo = nil
end

function UIBFDsbDuelActRulesRewardDetail:OnBtnTipRewardClick()
  if self.targetIdx and self.targetIdx > 0 then
    self.loopListView2ScrollView:MovePanelToItemIndex(self.targetIdx - 1)
    self.targetIdx = nil
    self.btnTipReward:SetActive(false)
  end
end

function UIBFDsbDuelActRulesRewardDetail:OnBtnInfoClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = "dsb_duel_tips_1035"
  param.alignObject = self.btnInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIBFDsbDuelActRulesRewardDetail:CheckTipReward()
  local showFlag = false
  for i = 1, #self.dataList do
    local hasReward = BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNum(self.dataList[i].id, true) > 0 or BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNum(self.dataList[i].id, false) > 0
    if hasReward and i >= self.nextCheckIndex then
      showFlag = true
      self.targetIdx = i
      break
    end
  end
  self.btnTipReward:SetActive(showFlag)
end

function UIBFDsbDuelActRulesRewardDetail:ClearItems()
  if self.compContent then
    self.compContent:RemoveComponents(UIBFDsbDuelActRulesRewardDetailItem)
  end
  if self.loopListView2ScrollView then
    self.loopListView2ScrollView:ClearAllItems()
  end
end

function UIBFDsbDuelActRulesRewardDetail:DataDefine()
  BattlefieldDsbDuelUtils.ActInfo:SendActRewardInfoMsg()
  self.currentTabIndex = 2
  self.itemIndex = 0
  self.inGroupRewardList = {}
  self.totalGroupRewardList = {}
  self.sTime = nil
  self.eTime = nil
  self.nextCheckIndex = 2
end

function UIBFDsbDuelActRulesRewardDetail:DataDestroy()
  self.currentTabIndex = nil
  self.itemIndex = nil
  self.inGroupRewardList = nil
  self.totalGroupRewardList = nil
  self.sTime = nil
  self.eTime = nil
  self.nextCheckIndex = nil
end

function UIBFDsbDuelActRulesRewardDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActOnGetRewardList)
end

function UIBFDsbDuelActRulesRewardDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActOnGetRewardList)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesRewardDetail:OnDsbDuelActOnGetRewardList()
  self:OnReceiveData()
  self:RefreshRedDot()
  self:CheckTipReward()
end

function UIBFDsbDuelActRulesRewardDetail:InitToggleEvents()
  self.toggleToggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnTabChanged(1)
    end
  end)
  self.toggleToggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnTabChanged(2)
    end
  end)
  self.toggleToggle2:SetIsOn(true)
end

function UIBFDsbDuelActRulesRewardDetail:OnTabChanged(tabIndex)
  if self.currentTabIndex == tabIndex then
    return
  end
  self.currentTabIndex = tabIndex
  self.nextCheckIndex = 2
  self:RefreshRewardList()
  self:CheckTipReward()
end

function UIBFDsbDuelActRulesRewardDetail:RefreshRewardList()
  self.dataList = self.currentTabIndex == 1 and self.inGroupRewardList or self.totalGroupRewardList
  self.loopListView2ScrollView:SetListItemCount(#self.dataList, true, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
end

function UIBFDsbDuelActRulesRewardDetail:OnGetItemByIndex(loopScroll, index)
  local count = #self.dataList
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local data = self.dataList[index]
  local item
  if string.IsNullOrEmpty(data.rank_zone) then
    item = loopScroll:NewListViewItem("UIBFDsbDuelActRulesRewardDetailItem2")
  else
    item = loopScroll:NewListViewItem("UIBFDsbDuelActRulesRewardDetailItem1")
  end
  local script = self.compContent:GetComponent(item.gameObject.name, UIBFDsbDuelActRulesRewardDetailItem)
  if script == nil then
    local name = "item_" .. self.itemIndex
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = name
    script = self.compContent:AddComponent(UIBFDsbDuelActRulesRewardDetailItem, name)
  end
  script:SetData(data)
  return item
end

function UIBFDsbDuelActRulesRewardDetail:OnUpdateTimeTxt()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  self.compTimeContent:SetActive(self.sTime and serverTime < self.sTime)
  if self.sTime and serverTime < self.sTime then
    local timeTxt = UITimeManager:GetInstance():MilliSecondToFmtString(self.sTime - serverTime)
    self.textTimeTxt:SetText(timeTxt)
  end
end

function UIBFDsbDuelActRulesRewardDetail:Update1000MS()
  self:OnUpdateTimeTxt()
end

function UIBFDsbDuelActRulesRewardDetail:UpdateData()
end

function UIBFDsbDuelActRulesRewardDetail:OnReceiveData()
  self.inGroupRewardList = BattlefieldDsbDuelUtils.ActInfo:GetCurrentRankRewards(1) or {}
  self.totalGroupRewardList = BattlefieldDsbDuelUtils.ActInfo:GetCurrentRankRewards(2) or {}
  self.textTab1:SetLocalText("dsb_duel_guide_tips_1023")
  self.textTab12:SetLocalText("dsb_duel_guide_tips_1023")
  self.textTab2:SetLocalText("dsb_duel_guide_tips_1024")
  self.textTab22:SetLocalText("dsb_duel_guide_tips_1024")
  self.sTime = BattlefieldDsbDuelUtils.ActInfo:GetResultShowStartTime()
  self:OnUpdateTimeTxt()
  self:RefreshRewardList()
  if BattlefieldDsbDuelUtils.ActInfo:IsInResultShowPhase() then
    self.textTips:SetLocalText("dsb_duel_interface_1048")
  else
    self.textTips:SetLocalText("dsb_duel_guide_tips_1026")
  end
end

function UIBFDsbDuelActRulesRewardDetail:RefreshRedDot()
  self.compRedAward1:SetActive(BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNumByToggle(BattlefieldDsbConst.BF_DSB_REWARD_GROUP_TYPE.InGroupReward) > 0)
  self.compRedAward2:SetActive(0 < BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNumByToggle(BattlefieldDsbConst.BF_DSB_REWARD_GROUP_TYPE.TotalReward))
end

function UIBFDsbDuelActRulesRewardDetail:OnDraggingAction()
  local nextItem = self.loopListView2ScrollView:GetShownItemByItemIndex(self.nextCheckIndex - 1)
  if nextItem == nil then
    return
  end
  local _nextItemY = self.loopListView2ScrollView:GetItemCornerPosInViewPort(nextItem).y
  local _viewPortSize = self.loopListView2ScrollView.unity_looplistview2.ViewPortSize
  if -200 <= _nextItemY + _viewPortSize then
    self.nextCheckIndex = self.nextCheckIndex + 1
  end
  self:CheckTipReward()
end

return UIBFDsbDuelActRulesRewardDetail
