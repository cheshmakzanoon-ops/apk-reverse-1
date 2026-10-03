local SeasonPreviewRankPanelView = BaseClass("SeasonPreviewRankPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISeasonPreviewRankItem = require("UI.LWSeasonShared.SeasonPreviewRank.Component.UISeasonPreviewRankItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local TabType = {DayRank = 1, WeekRank = 2}
local TabToRankType = {
  [TabType.DayRank] = AllyDuelRankType.Day,
  [TabType.WeekRank] = AllyDuelRankType.Week
}
local container1Go_path = "safeArea/panelContainer/Container1Go"
local container2Go_path = "safeArea/panelContainer/Container2Go"
local loopListView1_path = "safeArea/panelContainer/Container1Go/RectScroll1"
local loopListView2_path = "safeArea/panelContainer/Container2Go/RectScroll2"
local titleTxt_path = "safeArea/TopBar/TextTitle"
local closeBtn_path = "safeArea/BottomBar/BtnBackWhite"
local selfObj_path = "safeArea/panelContainer/SelfObj"
local selfRankTxt_path = "safeArea/panelContainer/SelfObj/RankIconNum"
local selfRankIcon_path = "safeArea/panelContainer/SelfObj/RankIcon"
local selfHeadIcon_path = "safeArea/panelContainer/SelfObj/playerFlag/UIPlayerHead"
local selfFirstTxt_path = "safeArea/panelContainer/SelfObj/firstNameTxt"
local selfSecondTxt_path = "safeArea/panelContainer/SelfObj/secondNameTxt"
local selfScoreTxt_path = "safeArea/panelContainer/SelfObj/scoreTxt"
local leagueTog_path = "safeArea/BottomBar/MyAllyToggle"
local empty_txt_path = "safeArea/panelContainer/TxtEmpty"
local rankTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle1"
local nickNameTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle2"
local scoreTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle3"
local leagueTitle_path = "safeArea/BottomBar/MyAllyToggle/ToggleText"
local tab_path = "safeArea/tabSv/Viewport/Content/AllyDuelTab"
local infoBtn_path = "safeArea/panelContainer/BG/BG2/InfoBtn"
local toggle_group_path = "safeArea/panelContainer/BG/ToggleGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.container1Go = self:AddComponent(UIBaseContainer, container1Go_path)
  self.container2Go = self:AddComponent(UIBaseContainer, container2Go_path)
  self.containerTbN = {
    self.container1Go,
    self.container2Go
  }
  self.loopListView1 = self:AddComponent(UIScrollView, loopListView1_path)
  self.loopListView1:SetOnItemMoveIn(function(itemObj, curIndex)
    self:SetDailyRankItemIn(itemObj, curIndex)
  end)
  self.loopListView1:SetOnItemMoveOut(function(itemObj, curIndex)
    self:SetDailyRankItemOut(itemObj, curIndex)
  end)
  self.loopListView2 = self:AddComponent(UIScrollView, loopListView2_path)
  self.loopListView2:SetOnItemMoveIn(function(itemObj, curIndex)
    self:SetWeeklyRankItemIn(itemObj, curIndex)
  end)
  self.loopListView2:SetOnItemMoveOut(function(itemObj, curIndex)
    self:SetWeeklyRankItemOut(itemObj, curIndex)
  end)
  self.loopListTbN = {
    self.loopListView1,
    self.loopListView2
  }
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.titleTxt:SetLocalText(361055)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.selfObj = self:AddComponent(UIBaseContainer, selfObj_path)
  self.selfRankTxt = self:AddComponent(UIText, selfRankTxt_path)
  self.selfScoreTxt = self:AddComponent(UIText, selfScoreTxt_path)
  self.selfRankIcon = self:AddComponent(UIImage, selfRankIcon_path)
  self.selfHeadIcon = self:AddComponent(UICommonHead, selfHeadIcon_path)
  self.tabTbN = {}
  local tabName = {361056, 361057}
  for i = 1, 2 do
    local tab = self:AddComponent(UIBaseContainer, tab_path .. i)
    local tabBtn = tab:AddComponent(UIButton, "TypeButton")
    tabBtn:SetOnClick(function()
      self:OnClickTab(i)
    end)
    local select = tab:AddComponent(UIBaseContainer, "select")
    local selectTxt = tab:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(tabName[i])
    local unselectTxt = tab:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(tabName[i])
    local red = tab:AddComponent(UIBaseContainer, "RedPoint")
    local visible = self:CheckIfTabVisible(i)
    tab:SetActive(visible)
    local newTab = {
      btnN = tabBtn,
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      isVisible = visible
    }
    table.insert(self.tabTbN, newTab)
  end
  self.leagueTog = self:AddComponent(UIToggle, leagueTog_path)
  self.leagueTog:SetIsOn(false)
  self.leagueTog:SetOnValueChanged(function(tf)
    self:RefreshRankList()
  end)
  self.selfFirstTxt = self:AddComponent(UIText, selfFirstTxt_path)
  self.selfSecondTxt = self:AddComponent(UIText, selfSecondTxt_path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText(371004)
  self.rankTxt = self:AddComponent(UIText, rankTitle_path)
  self.rankTxt:SetLocalText(361013)
  self.nickNameTxt = self:AddComponent(UIText, nickNameTitle_path)
  self.nickNameTxt:SetLocalText(100184)
  self.scoreTxt = self:AddComponent(UIText, scoreTitle_path)
  self.scoreTxt:SetLocalText(361001)
  self.leagueTxt = self:AddComponent(UIText, leagueTitle_path)
  self.leagueTxt:SetLocalText(361058)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowTips(Localization:GetString("season_pre_score_desc_tips"))
  end)
  self.weekDayToggleGroup = self:AddComponent(UIBaseComponent, toggle_group_path)
  local taskList = DataCenter.SeasonPreviewManager:GetTaskList()
  self.weekDayToggles = {}
  for i = 1, 5 do
    local task = taskList[i]
    if task then
      local staticData = task:GetStaticData()
      local segment = self:AddComponent(UIBaseContainer, "safeArea/panelContainer/BG/ToggleGroup/Toggle" .. i)
      local btn = segment:AddComponent(UIButton, "")
      btn:SetOnClick(function()
        self:OnClickWeekDayToggle(i)
      end)
      local select = segment:AddComponent(UIBaseContainer, "select")
      local selectTxt = segment:AddComponent(UIText, "select/selectText")
      selectTxt:SetLocalText(staticData.rank_title)
      local unselectTxt = segment:AddComponent(UIText, "unselectText")
      unselectTxt:SetLocalText(staticData.rank_title)
      local newSeg = {
        selectN = select,
        selectTxtN = selectTxt,
        unselectTxtN = unselectTxt,
        btnN = btn
      }
      table.insert(self.weekDayToggles, newSeg)
    end
  end
end

local function ComponentDestroy(self)
  self.loopListView2 = nil
  self.titleTxt = nil
  self.closeBtn = nil
  self.selfObj = nil
  self.selfRankTxt = nil
  self.selfScoreTxt = nil
  self.selfHeadIcon = nil
  self.tab1Tog = nil
  self.leagueTog = nil
  self.tab2Tog = nil
  self.selfFirstTxt = nil
  self.selfSecondTxt = nil
  self.container2Go = nil
  self.loopListView1 = nil
  self.container1Go = nil
  self.infoBtn = nil
  self.container1Animator = nil
  self.container2Animator = nil
  self.maskBtn = nil
  self.rankTxt = nil
  self.nickNameTxt = nil
  self.scoreTxt = nil
  self.leagueTxt = nil
  self.infoBtn = nil
end

local function DataDefine(self)
  self.rankList = {}
  self.curTabType = nil
  self.curToggleIndex = nil
end

local function DataDestroy(self)
  self.rankList = {}
  self.curTabType = nil
  self.curToggleIndex = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetSeasonPreviewRankList, self.RefreshRankList)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetSeasonPreviewRankList, self.RefreshRankList)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnPassDay(self)
  self:UpdateRankList(TabToRankType[self.curTabType])
end

local function UpdateRankList(self, param, index)
  DataCenter.SeasonPreviewManager:ReqRankList(index)
end

local function InitData(self)
  local targetTab = self:GetUserData()
  if not self.tabTbN[targetTab] or not self.tabTbN[targetTab].isVisible then
    for i, v in ipairs(self.tabTbN) do
      if v.isVisible then
        targetTab = i
        break
      end
    end
  end
  targetTab = targetTab or TabType.DayRank
  targetTab = TabType.DayRank
  local todayIndex = DataCenter.SeasonPreviewManager:GetTodayIndex()
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == todayIndex)
  end
  self:ChangeTab(targetTab)
end

local function ChangeTab(self, tabType)
  self.curTabType = tabType
  for i, v in ipairs(self.tabTbN) do
    if i == tabType then
      v.selectN:SetActive(true)
      self.containerTbN[i]:SetActive(true)
    else
      v.selectN:SetActive(false)
      self.containerTbN[i]:SetActive(false)
    end
  end
  self.weekDayToggleGroup:SetActive(tabType == TabType.DayRank)
  self.leagueTog:SetActive(true)
  self:UpdateRankList(TabToRankType[tabType])
end

local function CheckIfTabVisible(self, tabType)
  if tabType == TabType.DayRank then
    local tempData = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not tempData or tempData.finish or tempData:GetEventInfo() == nil then
      return false
    else
      return true
    end
  else
    return true
  end
end

local function RefreshRankList(self)
  if IsNull(self.gameObject) then
    return
  end
  local maxLength = 999
  local rankData = DataCenter.SeasonPreviewManager:GetRankData(self.curToggleIndex)
  local rankList = rankData.ranks or {}
  self.rankList = {}
  local mySelfRakIndex = rankData.rank
  if self.leagueTog:GetIsOn() then
    local realIndex = 0
    for rank, v in ipairs(rankList) do
      local myAllianceId = LuaEntry.Player:GetAllianceUid()
      if v.allianceId and myAllianceId == tostring(v.allianceId) then
        realIndex = realIndex + 1
        if maxLength >= realIndex then
          v.rank = rank
          table.insert(self.rankList, v)
        end
      end
    end
  else
    for i, v in ipairs(rankList) do
      if maxLength >= i then
        table.insert(self.rankList, v)
      end
    end
  end
  self:ClearScroll()
  if #self.rankList > 0 then
    local totalCount = #self.rankList
    self.loopListTbN[self.curTabType]:SetTotalCount(totalCount)
    self.loopListTbN[self.curTabType]:RefillCells()
    self.empty_txt:SetActive(false)
  else
    self.empty_txt:SetActive(true)
  end
  self:SetSelfInfo(mySelfRakIndex, rankData.score)
end

local function SetSelfInfo(self, rankIndex, score)
  self.selfObj:SetActive(true)
  rankIndex = math.max(rankIndex or 0, 0)
  score = math.max(score or 0, 0)
  if score == 0 then
    self.selfRankTxt:SetLocalText(361054)
  else
    self.selfRankTxt:SetText(rankIndex)
  end
  self.selfScoreTxt:SetText(string.GetFormattedSeparatorNum(score))
  local player = LuaEntry.Player
  self.selfHeadIcon:SetActive(true)
  self.selfHeadIcon:SetEnableClickShowInfo(true, true)
  self.selfHeadIcon:SetHead(player.uid, player.pic, player.picVer, nil, player:GetHeadBgImg())
  UISeasonPreviewRankItem.SetRankIcon(self.selfRankIcon, rankIndex)
  local strName = selfData and selfData.name or LuaEntry.Player.name
  self.selfFirstTxt:SetText(strName)
  if LuaEntry.Player:IsInAlliance() then
    local alInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self.selfSecondTxt:SetText("[" .. alInfo.abbr .. "]" .. alInfo.allianceName)
  else
    self.selfSecondTxt:SetText("")
  end
end

local function SetDailyRankItemIn(self, itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView1:AddComponent(UISeasonPreviewRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], self.rankList[curIndex].rank or curIndex)
end

local function SetDailyRankItemOut(self, itemObj, curIndex)
  self.loopListView1:RemoveComponents(itemObj.name, UISeasonPreviewRankItem)
end

local function SetWeeklyRankItemIn(self, itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView2:AddComponent(UISeasonPreviewRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], self.rankList[curIndex].rank or curIndex)
end

local function SetWeeklyRankItemOut(self, itemObj, curIndex)
  self.loopListView2:RemoveComponents(itemObj.name, UISeasonPreviewRankItem)
end

local function ClearScroll(self)
  self.loopListView1:ClearCells()
  self.loopListView1:RemoveComponents(UISeasonPreviewRankItem)
  self.loopListView2:ClearCells()
  self.loopListView2:RemoveComponents(UISeasonPreviewRankItem)
end

local function OnclickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtn.transform.position + Vector3.New(0, -15, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("361066")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickSelfTipBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.selfTipBtn.transform.position + Vector3.New(0, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("372169")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickTab(self, tabIndex)
  self:ChangeTab(tabIndex)
end

local function OnClickWeekDayToggle(self, index)
  local todayIndex = DataCenter.SeasonPreviewManager:GetTodayIndex()
  if index > todayIndex then
    UIUtil.ShowTipsId("372853")
    return
  end
  self.curToggleIndex = index
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == index)
  end
  self:UpdateRankList(AllyDuelRankType.Day, index)
  self:RefreshRankList()
end

SeasonPreviewRankPanelView.OnCreate = OnCreate
SeasonPreviewRankPanelView.OnDestroy = OnDestroy
SeasonPreviewRankPanelView.OnEnable = OnEnable
SeasonPreviewRankPanelView.OnDisable = OnDisable
SeasonPreviewRankPanelView.ComponentDefine = ComponentDefine
SeasonPreviewRankPanelView.ComponentDestroy = ComponentDestroy
SeasonPreviewRankPanelView.DataDefine = DataDefine
SeasonPreviewRankPanelView.DataDestroy = DataDestroy
SeasonPreviewRankPanelView.OnAddListener = OnAddListener
SeasonPreviewRankPanelView.OnRemoveListener = OnRemoveListener
SeasonPreviewRankPanelView.SetDailyRankItemIn = SetDailyRankItemIn
SeasonPreviewRankPanelView.SetDailyRankItemOut = SetDailyRankItemOut
SeasonPreviewRankPanelView.SetWeeklyRankItemIn = SetWeeklyRankItemIn
SeasonPreviewRankPanelView.SetWeeklyRankItemOut = SetWeeklyRankItemOut
SeasonPreviewRankPanelView.RefreshRankList = RefreshRankList
SeasonPreviewRankPanelView.UpdateRankList = UpdateRankList
SeasonPreviewRankPanelView.InitData = InitData
SeasonPreviewRankPanelView.ChangeTab = ChangeTab
SeasonPreviewRankPanelView.CheckIfTabVisible = CheckIfTabVisible
SeasonPreviewRankPanelView.ClearScroll = ClearScroll
SeasonPreviewRankPanelView.SetSelfInfo = SetSelfInfo
SeasonPreviewRankPanelView.OnclickInfoBtn = OnclickInfoBtn
SeasonPreviewRankPanelView.OnClickSelfTipBtn = OnClickSelfTipBtn
SeasonPreviewRankPanelView.OnClickTab = OnClickTab
SeasonPreviewRankPanelView.OnPassDay = OnPassDay
SeasonPreviewRankPanelView.OnClickWeekDayToggle = OnClickWeekDayToggle
return SeasonPreviewRankPanelView
