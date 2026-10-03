local UILWSurfingBattleRankPanelView = BaseClass("UILWSurfingBattleRankPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UISurfing.UIAct.AllianceRankView.Component.UILWSurfingRankItem")

function UILWSurfingBattleRankPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:SendAlMemberDataMsg()
end

function UILWSurfingBattleRankPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingBattleRankPanelView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankData then
    return nil
  end
  local ShowInfo = self.rankData[index]
  local item = loopScroll:NewListViewItem("UILWSurfingRankItem")
  local script = self.rankContent:GetComponent(item.gameObject.name, UIItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.rankContent:AddComponent(UIItem, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(self.rankType, ShowInfo)
  return item
end

function UILWSurfingBattleRankPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textRankDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textNameDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textValueDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.showListScroll = self:AddComponent(UIDynamicVerticleScrollRectEx, "Root/MiddleContentContainer/ContentContainer/rankContent/ShowListScroll")
  self.rankContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compSelfData = self.viewSkin:AddComponent(self, UIItem, 8)
  self.conditionBtnScroll = self.viewSkin:AddComponent(self, UIScrollRect, 9)
  self.conditionBtnsContent = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compTab1 = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compTab2 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.btnReward = self:AddComponent(UIButton, "Root/BottomBar/BtnReward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/BtnReward/BtnRewardIcon/BtnRewardText")
  self.textRemainTime = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/textRemainTime")
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleContentContainer/textEmpty")
  self.itemIncNo = 1
  self.itemComps = {}
  self.showListScroll:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "item_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local itemComp = self:AddComponent(UIItem, itemObj)
    self.itemComps[itemObj] = itemComp
  end)
  self.showListScroll:AddDisplayItemListener(function(itemObj, dataIdx)
    local itemComp = self.itemComps[itemObj]
    local vo = self.rankData[dataIdx + 1]
    itemComp:SetItemShow(self.rankType, vo)
  end)
end

function UILWSurfingBattleRankPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnBack = nil
  self.textRankDes = nil
  self.textNameDes = nil
  self.textValueDes = nil
  self.showListScroll = nil
  self.rankContent = nil
  self.compSelfData = nil
  self.conditionBtnScroll = nil
  self.conditionBtnsContent = nil
  self.compTab1 = nil
  self.compTab2 = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.textRemainTime = nil
  self.textEmpty = nil
end

function UILWSurfingBattleRankPanelView:DataDefine()
  self.tabs = {}
  for i = 1, 2 do
    local tab = {}
    tab.tab = self["compTab" .. i]
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
    tab.tab_name = tab.tab:AddComponent(UIText, "activityName")
    tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.selectIndex = 1
  self.showTabData = {
    SurfingBattleRankType.AllianceRank,
    SurfingBattleRankType.TopServersRank
  }
  self.itemIndex = 0
  self.timeStr = Localization:GetString("parkour_rank_count_down")
end

function UILWSurfingBattleRankPanelView:DataDestroy()
  self:ClearScroll()
  self.tabs = nil
  self.selectIndex = nil
  self.showTabData = nil
  self.rankData = nil
  self.rankType = nil
  self.lastRankInfo = nil
  self.endTime = nil
end

function UILWSurfingBattleRankPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingRefreshRankInfo, self.RefreshContent)
  self:AddUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
end

function UILWSurfingBattleRankPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingRefreshRankInfo, self.RefreshContent)
  self:RemoveUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UILWSurfingBattleRankPanelView:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
  local jumpType = self:GetUserData()
  if jumpType ~= nil then
    for k, v in pairs(self.showTabData) do
      if v == jumpType then
        self.selectIndex = k
        break
      end
    end
  end
  self.rankType = self.showTabData[self.selectIndex]
  if self.rankType == nil then
    return
  end
  self:RefreshBar()
end

function UILWSurfingBattleRankPanelView:GetTabNameByType(type)
  local name = ""
  if type == SurfingBattleRankType.AllianceRank then
    name = Localization:GetString("parkour_alliance_rank_title")
  elseif type == SurfingBattleRankType.TopServersRank then
    name = Localization:GetString("parkour_zone_rank_title")
  end
  return name
end

function UILWSurfingBattleRankPanelView:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function UILWSurfingBattleRankPanelView:RefreshRankData()
  self.rankType = self.showTabData[self.selectIndex]
  if self.rankType == nil then
    return
  end
  self:RefreshBar()
end

function UILWSurfingBattleRankPanelView:SendAlMemberDataMsg()
  if self.lastRankInfo == nil then
    self.lastRankInfo = {}
    self.lastRankInfo[SurfingBattleRankType.AllianceRank] = {sendTime = 0}
    self.lastRankInfo[SurfingBattleRankType.TopServersRank] = {sendTime = 0}
  end
  self.rankContent.gameObject:SetActive(false)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.rankType then
    if curTime > self.lastRankInfo[self.rankType].sendTime + 2000 then
      self.lastRankInfo[self.rankType].sendTime = curTime
      self.round = DataCenter.LWSurfingDataManager:GetRound()
      if self.rankType == SurfingBattleRankType.AllianceRank then
        DataCenter.LWSurfingDataManager:GetParkourRankInfo(self.round, self.rankType, 1, 100)
      else
        DataCenter.LWSurfingDataManager:GetParkourRankInfo(self.round, self.rankType, 1, 500)
      end
    else
      self:RefreshContent()
    end
  end
end

function UILWSurfingBattleRankPanelView:SendMsg()
  self.round = DataCenter.LWSurfingDataManager:GetRound()
  if self.rankType == SurfingBattleRankType.AllianceRank then
    DataCenter.LWSurfingDataManager:GetParkourRankInfo(self.round, self.rankType, 1, 100)
  else
    DataCenter.LWSurfingDataManager:GetParkourRankInfo(self.round, self.rankType, 1, 500)
  end
end

function UILWSurfingBattleRankPanelView:DoSelectTabIndex(index)
  if self.showTabData[index] == SurfingBattleRankType.AllianceRank and not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
    return
  end
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self.rankType = self.showTabData[self.selectIndex]
  if self.rankType == nil then
    return
  end
  self:RefreshBar()
  self:SendAlMemberDataMsg()
end

function UILWSurfingBattleRankPanelView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleRankPanelView:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleRankRewardView, self.selectIndex)
end

function UILWSurfingBattleRankPanelView:RefreshContent()
  self.endTime = DataCenter.LWSurfingDataManager:GetTheBattleEndTime()
  local type = DataCenter.LWSurfingDataManager:GetSelectRoundRankType()
  if type == SurfingBattleRankRoundType.Meters then
    self.textValueDes:SetLocalText("parkour_rank_title_3")
  elseif type == SurfingBattleRankRoundType.CoinNum then
    self.textValueDes:SetLocalText("parkour_rank_title_4")
  end
  self.rankContent.gameObject:SetActive(true)
  self:RefreshView()
end

function UILWSurfingBattleRankPanelView:RefreshView()
  if self.rankType == nil then
    self.textEmpty.gameObject:SetActive(true)
    return
  end
  local rankData = DataCenter.LWSurfingDataManager:GetSurfingRankInfo(self.rankType)
  if rankData then
    self.rankData = rankData.rankList
    self.selfRankData = rankData.selfRank
    self.round = rankData.round
  else
    self.textEmpty.gameObject:SetActive(true)
    return
  end
  if self.selfRankData ~= nil then
    self.compSelfData:SetActive(true)
    self.compSelfData:SetItemShow(self.rankType, self.selfRankData, true)
  else
    self.compSelfData:SetActive(false)
  end
  self.prefabIdxs = {}
  if self.rankData then
    for _, vo in ipairs(self.rankData) do
      table.insert(self.prefabIdxs, 0)
    end
    if #self.rankData == 0 then
      self.showListScroll.gameObject:SetActive(false)
      self.textEmpty.gameObject:SetActive(true)
    else
      self.showListScroll.gameObject:SetActive(true)
      self.textEmpty.gameObject:SetActive(false)
    end
    self.showListScroll:SetDatas(self.prefabIdxs)
    self.showListScroll:SetScrollOffset(0)
  else
    self.showListScroll.gameObject:SetActive(false)
    self.textEmpty.gameObject:SetActive(true)
  end
end

function UILWSurfingBattleRankPanelView:ClearScroll()
  self.showListScroll:SetDatas({})
end

function UILWSurfingBattleRankPanelView:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textRemainTime:SetText(self.timeStr .. countDownTimeStr)
  end
end

return UILWSurfingBattleRankPanelView
