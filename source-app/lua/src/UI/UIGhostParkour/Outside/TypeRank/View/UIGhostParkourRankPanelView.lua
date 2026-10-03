local UIGhostParkourRankPanelView = BaseClass("UIGhostParkourRankPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UIGhostParkour.Outside.TypeRank.Component.SelfDataComponent")
local UIRankItem = require("UI.UIGhostParkour.Outside.TypeRank.Component.UIGhostRankItemComponent")

function UIGhostParkourRankPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitSettingState()
  self:ReInit()
  self:SendAlMemberDataMsg()
  self:UpdateRedPoint()
end

function UIGhostParkourRankPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnSetting = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnSetting:SetOnClick(function()
    self:OnBtnSettingClick()
  end)
  self.showListScroll = self.viewSkin:AddComponent(self, UIScrollView, 7)
  self.rankContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.conditionBtnScroll = self.viewSkin:AddComponent(self, UIScrollRect, 9)
  self.conditionBtnsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compTab1 = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compTab2 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compTab3 = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compSelfData = self.viewSkin:AddComponent(self, UIItem, 15)
  self.compTabRedPoint1 = self.viewSkin:AddComponent(self, UICommonRedPoint, 16)
  self.compTabRedPoint2 = self.viewSkin:AddComponent(self, UICommonRedPoint, 17)
  self.compTabRedPoint3 = self.viewSkin:AddComponent(self, UICommonRedPoint, 18)
  self.compTabRedPoint1:SetType(CommonRedPointPriority.Level1)
  self.compTabRedPoint1:SetActive(false)
  self.compTabRedPoint2:SetType(CommonRedPointPriority.Level1)
  self.compTabRedPoint2:SetActive(false)
  self.compTabRedPoint3:SetType(CommonRedPointPriority.Level1)
  self.compTabRedPoint3:SetActive(false)
  self.itemIncNo = 1
  self.itemComps = {}
  self.showListScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.showListScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIGhostParkourRankPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnBack = nil
  self.textRemainTime = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.btnSetting = nil
  self.showListScroll = nil
  self.rankContent = nil
  self.conditionBtnScroll = nil
  self.conditionBtnsContent = nil
  self.compTab1 = nil
  self.compTab2 = nil
  self.compTab3 = nil
  self.textEmpty = nil
  self.compSelfData = nil
  self.compTabRedPoint1 = nil
  self.compTabRedPoint2 = nil
  self.compTabRedPoint3 = nil
end

function UIGhostParkourRankPanelView:DataDefine()
  self.allTimes = DataCenter.LWGhostParkourDataManager:GetAllChallengeTimes()
  self.tabs = {}
  for i = 1, 3 do
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
    GhostParkourTypeRank.AllianceRank,
    GhostParkourTypeRank.ServerRank,
    GhostParkourTypeRank.AreaRank
  }
  self.itemIndex = 0
end

function UIGhostParkourRankPanelView:DataDestroy()
  self:ClearScroll()
  self.tabs = nil
  self.selectIndex = nil
  self.showTabData = nil
  self.rankData = nil
  self.rankType = nil
  self.lastRankInfo = nil
  self.endTime = nil
  self.StageId = nil
  self.allTimes = nil
end

function UIGhostParkourRankPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourTypeRankRefresh, self.RefreshContent)
  self:AddUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
  self:AddUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdateRedPoint)
  self:AddUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateRedPoint)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
end

function UIGhostParkourRankPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourTypeRankRefresh, self.RefreshContent)
  self:RemoveUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
  self:RemoveUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdateRedPoint)
  self:RemoveUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateRedPoint)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

function UIGhostParkourRankPanelView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankPanelView:OnBtnRewardClick()
  if self.showTabData and self.showTabData[self.selectIndex] then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankRewardPopView, self.showTabData[self.selectIndex])
  end
end

function UIGhostParkourRankPanelView:OnBtnSettingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourSettingView)
end

function UIGhostParkourRankPanelView:InitSettingState()
  self.btnSetting.gameObject:SetActive(DataCenter.LWGhostParkourDataManager:GetBtnSettingSwitch())
end

function UIGhostParkourRankPanelView:ReInit()
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

function UIGhostParkourRankPanelView:GetTabNameByType(type)
  local name = ""
  if type == GhostParkourTypeRank.AllianceRank then
    name = Localization:GetString("ghost_parkour_alliance_rank_title")
  elseif type == GhostParkourTypeRank.ServerRank then
    name = Localization:GetString("ghost_parkour_zone_rank_title")
  elseif type == GhostParkourTypeRank.AreaRank then
    name = Localization:GetString("ghost_parkour_season_rank_title")
  end
  return name
end

function UIGhostParkourRankPanelView:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function UIGhostParkourRankPanelView:RefreshRankData()
  self.rankType = self.showTabData[self.selectIndex]
  if self.rankType == nil then
    return
  end
  self:RefreshBar()
end

function UIGhostParkourRankPanelView:SendAlMemberDataMsg()
  if self.lastRankInfo == nil then
    self.lastRankInfo = {}
    self.lastRankInfo[GhostParkourTypeRank.AllianceRank] = {sendTime = 0}
    self.lastRankInfo[GhostParkourTypeRank.ServerRank] = {sendTime = 0}
    self.lastRankInfo[GhostParkourTypeRank.AreaRank] = {sendTime = 0}
  end
  self.rankContent.gameObject:SetActive(false)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.rankType then
    if curTime > self.lastRankInfo[self.rankType].sendTime + 2000 then
      self.lastRankInfo[self.rankType].sendTime = curTime
      self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
      if self.rankType == GhostParkourTypeRank.AllianceRank then
        DataCenter.LWGhostParkourDataManager:SendGhostParkourRankInfoMessage(self.round, self.rankType, 1, 100)
      else
        DataCenter.LWGhostParkourDataManager:SendGhostParkourRankInfoMessage(self.round, self.rankType, 1, 500)
      end
    else
      self:RefreshContent()
    end
  end
end

function UIGhostParkourRankPanelView:SendMsg()
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if self.rankType == GhostParkourTypeRank.AllianceRank then
    DataCenter.LWGhostParkourDataManager:SendGhostParkourRankInfoMessage(self.round, self.rankType, 1, 100)
  else
    DataCenter.LWGhostParkourDataManager:SendGhostParkourRankInfoMessage(self.round, self.rankType, 1, 500)
  end
end

function UIGhostParkourRankPanelView:DoSelectTabIndex(index)
  if self.showTabData[index] == GhostParkourTypeRank.AllianceRank and not LuaEntry.Player:IsInAlliance() then
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

function UIGhostParkourRankPanelView:RefreshContent()
  self.endTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  self.rankContent.gameObject:SetActive(true)
  self:RefreshView()
end

function UIGhostParkourRankPanelView:RefreshView()
  if self.rankType == nil then
    self.textEmpty.gameObject:SetActive(true)
    return
  end
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  local rankData = DataCenter.LWGhostParkourDataManager:GetTypeRankInfo(self.round, self.rankType)
  if rankData then
    self.rankData = rankData.ranks
    self.selfRankData = rankData.selfInfo
    self.StageId = rankData.stageId
  else
    self:ClearScroll()
    self.showListScroll.gameObject:SetActive(false)
    self.compSelfData:SetActive(false)
    self.textEmpty.gameObject:SetActive(true)
    return
  end
  if self.selfRankData ~= nil then
    self.compSelfData:SetActive(true)
    self.compSelfData:SetItemShow(self.rankType, self.selfRankData, self.StageId)
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
      self.showListScroll:SetTotalCount(#self.rankData)
      self.showListScroll:RefillCells()
    end
  else
    self.showListScroll.gameObject:SetActive(false)
    self.textEmpty.gameObject:SetActive(true)
  end
  self.remainTimes = DataCenter.LWGhostParkourDataManager:GetRemainChallengeTimes()
end

function UIGhostParkourRankPanelView:ClearScroll()
  self.showListScroll:ClearCells()
  self.showListScroll:RemoveComponents(UIRankItem)
  self.rankData = {}
end

function UIGhostParkourRankPanelView:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textRemainTime:SetLocalText("ghost_parkour_challenge_count_desc", self.remainTimes, self.allTimes, countDownTimeStr)
  end
end

function UIGhostParkourRankPanelView:UpdateRedPoint()
  local allianceThumbsUp = DataCenter.LWGhostParkourDataManager:GetTypeRankItemThumbsUpRedPoint(GhostParkourTypeRank.AllianceRank)
  local redRank1Challenge = DataCenter.LWGhostParkourDataManager:GetRankChallengeRedPoint(GhostParkourTypeRank.AllianceRank)
  self.compTabRedPoint1:SetDefaultVisible(allianceThumbsUp or redRank1Challenge)
  local serverThumbsUp = DataCenter.LWGhostParkourDataManager:GetTypeRankItemThumbsUpRedPoint(GhostParkourTypeRank.ServerRank)
  local redRank2Challenge = DataCenter.LWGhostParkourDataManager:GetRankChallengeRedPoint(GhostParkourTypeRank.ServerRank)
  self.compTabRedPoint2:SetDefaultVisible(serverThumbsUp or redRank2Challenge)
  local areaThumbsUp = DataCenter.LWGhostParkourDataManager:GetTypeRankItemThumbsUpRedPoint(GhostParkourTypeRank.AreaRank)
  local redRank3Challenge = DataCenter.LWGhostParkourDataManager:GetRankChallengeRedPoint(GhostParkourTypeRank.AreaRank)
  self.compTabRedPoint3:SetDefaultVisible(areaThumbsUp or redRank3Challenge)
end

function UIGhostParkourRankPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.showListScroll:AddComponent(UIRankItem, itemObj)
  local vo = self.rankData[index]
  cellItem:SetItemShow(self.rankType, vo, self.StageId)
end

function UIGhostParkourRankPanelView:OnItemMoveOut(itemObj, index)
  self.showListScroll:RemoveComponent(itemObj.name, UIRankItem)
end

return UIGhostParkourRankPanelView
