local SeasonGreenRankPanel = BaseClass("SeasonGreenRankPanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCompeteRankItem = require("UI.LWUIAllyDuel.LWUIAllyDuelRankPanel.Component.UIAllyDuelPersonalRankItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local MaxWeek = 8
local TabType = {WeekRank = 1, SeasonRank = 2}
local TabToRankType = {
  [TabType.SeasonRank] = SeasonGreenRank.Season,
  [TabType.WeekRank] = SeasonGreenRank.Week
}
local container1Go_path = "safeArea/panelContainer/Container1Go"
local container2Go_path = "safeArea/panelContainer/Container2Go"
local loopListView1_path = "safeArea/panelContainer/Container1Go/RectScroll1"
local loopListView2_path = "safeArea/panelContainer/Container2Go/RectScroll2"
local titleTxt_path = "safeArea/TopBar/TextTitle"
local closeBtn_path = "safeArea/BottomBar/BtnBackWhite"
local descBtn_path = "safeArea/TopBar/DesBtn"
local selfObj_path = "safeArea/panelContainer/SelfObj"
local selfRankTxt_path = "safeArea/panelContainer/SelfObj/RankIconNum"
local selfRankIcon_path = "safeArea/panelContainer/SelfObj/RankIcon"
local selfHeadIcon_path = "safeArea/panelContainer/SelfObj/playerFlag/UIPlayerHead"
local selfFirstTxt_path = "safeArea/panelContainer/SelfObj/firstNameTxt"
local selfSecondTxt_path = "safeArea/panelContainer/SelfObj/secondNameTxt"
local selfScoreTxt_path = "safeArea/panelContainer/SelfObj/scoreTxt"
local btn_reward_path = "safeArea/BottomBar/BtnReward"
local leagueTog_path = "safeArea/BottomBar/MyAllyToggle"
local empty_txt_path = "safeArea/panelContainer/TxtEmpty"
local rankTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle1"
local nickNameTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle2"
local scoreTitle_path = "safeArea/panelContainer/BG/BG2/TextTitle3"
local leagueTitle_path = "safeArea/BottomBar/MyAllyToggle/ToggleText"
local tab_path = "safeArea/tabSv/Viewport/Content/AllyDuelTab"
local infoBtn_path = "safeArea/panelContainer/BG/BG2/InfoBtn"
local toggleScroll = "safeArea/panelContainer/BG/ScrollView"
local toggle_group_path = "safeArea/panelContainer/BG/ScrollView/Viewport/ToggleGroup"
local toggle_item_path = "safeArea/panelContainer/BG/ScrollView/Viewport/ToggleGroup/Toggle"

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
  self.titleTxt:SetLocalText("season_oasis_UI_18")
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.desBtn = self:AddComponent(UIButton, descBtn_path)
  self.desBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.selfObj = self:AddComponent(UIBaseContainer, selfObj_path)
  self.selfRankTxt = self:AddComponent(UIText, selfRankTxt_path)
  self.selfScoreTxt = self:AddComponent(UIText, selfScoreTxt_path)
  self.selfRankIcon = self:AddComponent(UIImage, selfRankIcon_path)
  self.selfHeadIcon = self:AddComponent(UICommonHead, selfHeadIcon_path)
  self.tabTbN = {}
  local tabName = {
    "season_oasis_UI_19",
    "season_oasis_UI_20"
  }
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
    local newTab = {
      btnN = tabBtn,
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      isVisible = true
    }
    table.insert(self.tabTbN, newTab)
  end
  self.btnReward = self:AddComponent(UIButton, btn_reward_path)
  self.btnReward:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonGreenRankReward, {anim = true})
  end)
  self.leagueTog = self:AddComponent(UIToggle, leagueTog_path)
  self.leagueTog:SetIsOn(false)
  self.leagueTog:SetOnValueChanged(function(tf)
    self:RefreshRankList()
  end)
  self.selfFirstTxt = self:AddComponent(UIText, selfFirstTxt_path)
  self.selfSecondTxt = self:AddComponent(UIText, selfSecondTxt_path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText("season_oasis_UI_4")
  self.rankTxt = self:AddComponent(UIText, rankTitle_path)
  self.rankTxt:SetLocalText(361013)
  self.nickNameTxt = self:AddComponent(UIText, nickNameTitle_path)
  self.nickNameTxt:SetLocalText(100184)
  self.scoreTxt = self:AddComponent(UIText, scoreTitle_path)
  self.scoreTxt:SetLocalText("season_oasis_UI_21")
  self.leagueTxt = self:AddComponent(UIText, leagueTitle_path)
  self.leagueTxt:SetLocalText(361058)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowTips(Localization:GetString("season_oasis_tips_7"))
  end)
  self.toggleGroupScroll = self:AddComponent(UIScrollRect, toggleScroll)
  self.weekDayToggleGroup = self:AddComponent(UIBaseContainer, toggle_group_path)
  local weekDayToggle = self:AddComponent(UIBaseContainer, toggle_item_path)
  self.weekDayToggleItem = weekDayToggle.gameObject
  self.weekDayToggleItem:SetActive(false)
  self.weekDayToggleItem:GameObjectCreatePool()
  self.weekDayToggles = {}
  MaxWeek = DataCenter.SeasonGreenManager:GetActivityDurationWeek()
  for i = 1, MaxWeek do
    local goItem = self.weekDayToggleItem:GameObjectSpawn(self.weekDayToggleGroup.transform)
    goItem.name = "toggle_" .. i
    goItem:SetActive(true)
    local segment = self.weekDayToggleGroup:AddComponent(UIBaseContainer, goItem.name)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickWeekDayToggle(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(459009, i)
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(459009, i)
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      btnN = btn
    }
    table.insert(self.weekDayToggles, newSeg)
  end
end

local function ComponentDestroy(self)
  self.weekDayToggleItem:GameObjectRecycleAll()
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
  self:AddUIListener(EventId.SeasonGreenCityRank, self.RefreshRankList)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonGreenCityRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnPassDay(self)
  local showRank = SeasonUtil.IsInSeason()
  if showRank then
    self:UpdateRankList(TabToRankType[self.curTabType])
  else
    self.ctrl:CloseSelf()
  end
end

local function UpdateRankList(self, tempParam, day)
  SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityRank, tempParam, day or self.curToggleIndex)
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
  targetTab = targetTab or TabType.SeasonRank
  local seasonId, weekNum = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  self.curToggleIndex = math.min(weekNum or 1, MaxWeek)
  self.toggleGroupScroll:AnimHorizontalNormalizedPos(self.curToggleIndex / MaxWeek, 0.2)
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == self.curToggleIndex)
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
  self.toggleGroupScroll:SetActive(tabType == TabType.WeekRank)
  self.leagueTog:SetActive(true)
  self:UpdateRankList(TabToRankType[tabType])
end

local function RefreshRankList(self)
  if IsNull(self.gameObject) then
    return
  end
  local rankList, selfRank, selfScore = DataCenter.SeasonGreenManager:GetRankList(TabToRankType[self.curTabType], self.curToggleIndex)
  self.rankList = {}
  if self.leagueTog:GetIsOn() then
    if LuaEntry.Player:IsInAlliance() then
      local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local myAllianceId = allianceBase.uid
      table.walk(rankList, function(k, v)
        if myAllianceId ~= nil and v.aid ~= nil and tostring(myAllianceId) == tostring(v.aid) then
          table.insert(self.rankList, v)
        end
      end)
    end
  else
    self.rankList = rankList
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
  self:SetSelfInfo(selfRank, selfScore)
end

local function SetSelfInfo(self, selfRank, selfScore)
  local count = #self.rankList
  self.selfObj:SetActive(true)
  if 0 < selfRank and 0 < selfScore then
  else
    local selfData
    selfRank = 0
    for i = 1, count do
      local data = self.rankList[i]
      local uid = data.uid
      if uid ~= nil and uid == LuaEntry.Player.uid then
        selfData = data
        selfRank = i
        break
      end
    end
    selfScore = selfData and selfData.score and selfData.score or 0
  end
  if selfScore == 0 then
    self.selfRankTxt:SetLocalText(361054)
    self.selfScoreTxt:SetLocalText(361054)
  else
    self.selfRankTxt:SetText(selfRank)
    local scoreStr = string.GetFormattedSeparatorNum(selfScore)
    self.selfScoreTxt:SetText(scoreStr)
  end
  local player = LuaEntry.Player
  self.selfHeadIcon:SetActive(true)
  self.selfHeadIcon:SetEnableClickShowInfo(true, true)
  self.selfHeadIcon:SetHead(player.uid, player.pic, player.picVer, nil, player:GetHeadBgImg())
  AllianceCompeteRankItem.SetRankIcon(self.selfRankIcon, selfRank)
  self.selfFirstTxt:SetText(LuaEntry.Player.name)
  if LuaEntry.Player:IsInAlliance() then
    local alInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self.selfSecondTxt:SetText("[" .. alInfo.abbr .. "]" .. alInfo.allianceName)
  else
    self.selfSecondTxt:SetText("")
  end
end

local function SetDailyRankItemIn(self, itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView1:AddComponent(AllianceCompeteRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], curIndex)
end

local function SetDailyRankItemOut(self, itemObj, curIndex)
  self.loopListView1:RemoveComponents(itemObj.name, AllianceCompeteRankItem)
end

local function SetWeeklyRankItemIn(self, itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView2:AddComponent(AllianceCompeteRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], curIndex)
end

local function SetWeeklyRankItemOut(self, itemObj, curIndex)
  self.loopListView2:RemoveComponents(itemObj.name, AllianceCompeteRankItem)
end

local function ClearScroll(self)
  self.loopListView1:ClearCells()
  self.loopListView1:RemoveComponents(AllianceCompeteRankItem)
  self.loopListView2:ClearCells()
  self.loopListView2:RemoveComponents(AllianceCompeteRankItem)
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
  local seasonId, weekNum = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  if index > weekNum then
    UIUtil.ShowTipsId("372853")
    return
  end
  self.curToggleIndex = index
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == index)
  end
  self:UpdateRankList(SeasonGreenRank.Week, index)
  self:RefreshRankList()
end

function SeasonGreenRankPanel:OnClickInfoBtn()
  local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
  local str = mainCfg and mainCfg.rank_help
  local param = {}
  param.activityRulesStr = Localization:GetString(str)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

SeasonGreenRankPanel.OnCreate = OnCreate
SeasonGreenRankPanel.OnDestroy = OnDestroy
SeasonGreenRankPanel.OnEnable = OnEnable
SeasonGreenRankPanel.OnDisable = OnDisable
SeasonGreenRankPanel.ComponentDefine = ComponentDefine
SeasonGreenRankPanel.ComponentDestroy = ComponentDestroy
SeasonGreenRankPanel.DataDefine = DataDefine
SeasonGreenRankPanel.DataDestroy = DataDestroy
SeasonGreenRankPanel.OnAddListener = OnAddListener
SeasonGreenRankPanel.OnRemoveListener = OnRemoveListener
SeasonGreenRankPanel.SetDailyRankItemIn = SetDailyRankItemIn
SeasonGreenRankPanel.SetDailyRankItemOut = SetDailyRankItemOut
SeasonGreenRankPanel.SetWeeklyRankItemIn = SetWeeklyRankItemIn
SeasonGreenRankPanel.SetWeeklyRankItemOut = SetWeeklyRankItemOut
SeasonGreenRankPanel.RefreshRankList = RefreshRankList
SeasonGreenRankPanel.UpdateRankList = UpdateRankList
SeasonGreenRankPanel.InitData = InitData
SeasonGreenRankPanel.ChangeTab = ChangeTab
SeasonGreenRankPanel.ClearScroll = ClearScroll
SeasonGreenRankPanel.SetSelfInfo = SetSelfInfo
SeasonGreenRankPanel.OnclickInfoBtn = OnclickInfoBtn
SeasonGreenRankPanel.OnClickSelfTipBtn = OnClickSelfTipBtn
SeasonGreenRankPanel.OnClickTab = OnClickTab
SeasonGreenRankPanel.OnPassDay = OnPassDay
SeasonGreenRankPanel.OnClickWeekDayToggle = OnClickWeekDayToggle
return SeasonGreenRankPanel
