local UISandWormFishingRankView = BaseClass("UISandWormFishingRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SandWormFishingRankItem = require("UI.UISandWormFishing.UISandWormFishingRank.Component.SandWormFishingRankItem")
local TabType = {LevelRank = 1, DamageRank = 2}
local WeekDayName = {
  [1] = "372307",
  [2] = "372308",
  [3] = "372309",
  [4] = "372310",
  [5] = "372311",
  [6] = "372312",
  [7] = "372313"
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

function UISandWormFishingRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

function UISandWormFishingRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISandWormFishingRankView:ComponentDefine()
  self.container1Go = self:AddComponent(UIBaseContainer, container1Go_path)
  self.container2Go = self:AddComponent(UIBaseContainer, container2Go_path)
  self.containerTbN = {
    self.container1Go,
    self.container2Go
  }
  self.loopListView1 = self:AddComponent(UIScrollView, loopListView1_path)
  self.loopListView1:SetOnItemMoveIn(function(itemObj, curIndex)
    self:SetLevelRankItemIn(itemObj, curIndex)
  end)
  self.loopListView1:SetOnItemMoveOut(function(itemObj, curIndex)
    self:SetLevelRankItemOut(itemObj, curIndex)
  end)
  self.loopListView2 = self:AddComponent(UIScrollView, loopListView2_path)
  self.loopListView2:SetOnItemMoveIn(function(itemObj, curIndex)
    self:SetDamageRankItemIn(itemObj, curIndex)
  end)
  self.loopListView2:SetOnItemMoveOut(function(itemObj, curIndex)
    self:SetDamageRankItemOut(itemObj, curIndex)
  end)
  self.loopListTbN = {
    self.loopListView1,
    self.loopListView2
  }
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
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
  local tabName = {
    "season_s3_activity_1000074_desc03",
    "season_s3_activity_1000074_desc04"
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
      redN = red
    }
    table.insert(self.tabTbN, newTab)
  end
  self.leagueTog = self:AddComponent(UIToggle, leagueTog_path)
  self.leagueTog:SetIsOn(false)
  self.leagueTog:SetOnValueChanged(function()
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
  self.leagueTxt = self:AddComponent(UIText, leagueTitle_path)
  self.leagueTxt:SetLocalText(361058)
  self.weekDayToggles = {}
  for i = 1, 7 do
    local segment = self:AddComponent(UIBaseContainer, "safeArea/panelContainer/BG/ToggleGroup/Toggle" .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickWeekDayToggle(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(WeekDayName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(WeekDayName[i])
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      btnN = btn
    }
    table.insert(self.weekDayToggles, newSeg)
  end
end

function UISandWormFishingRankView:ComponentDestroy()
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
end

function UISandWormFishingRankView:DataDefine()
  self.rankList = {}
  self.curTabType = nil
  self.curToggleIndex = nil
end

function UISandWormFishingRankView:DataDestroy()
  self.rankList = {}
  self.curTabType = nil
  self.curToggleIndex = nil
end

function UISandWormFishingRankView:OnEnable()
  base.OnEnable(self)
end

function UISandWormFishingRankView:OnDisable()
  base.OnDisable(self)
end

function UISandWormFishingRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSandWormFishingRankRefresh, self.RefreshRankList)
end

function UISandWormFishingRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSandWormFishingRankRefresh, self.RefreshRankList)
end

function UISandWormFishingRankView:FetchRankData()
  DataCenter.SandWormFishingDataManager:FetchRankList(self.curTabType, self.curToggleIndex)
end

function UISandWormFishingRankView:InitData()
  self.curToggleIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == self.curToggleIndex)
  end
  self:OnClickTab(TabType.LevelRank)
end

function UISandWormFishingRankView:OnClickTab(tabType)
  if self.curTabType == tabType then
    return
  end
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
  if tabType == TabType.LevelRank then
    self.titleTxt:SetLocalText("season_s3_activity_1000074_desc05")
    self.scoreTxt:SetLocalText("season_s3_activity_1000074_desc06")
  else
    self.titleTxt:SetLocalText("season_s3_activity_1000074_desc07")
    self.scoreTxt:SetLocalText("season_s3_activity_1000074_desc04")
  end
  self.leagueTog:SetActive(true)
  self:FetchRankData()
  self:RefreshRankList()
end

function UISandWormFishingRankView:OnClickWeekDayToggle(index)
  if self.curToggleIndex == index then
    return
  end
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  if index > today then
    UIUtil.ShowTipsId("372853")
    return
  end
  self.curToggleIndex = index
  for i, v in ipairs(self.weekDayToggles) do
    v.selectN:SetActive(i == index)
  end
  self:FetchRankData()
  self:RefreshRankList()
end

function UISandWormFishingRankView:RefreshRankList()
  if IsNull(self.gameObject) then
    return
  end
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local myUid = LuaEntry.Player:GetUid()
  local rankList = DataCenter.SandWormFishingDataManager:GetRankList(self.curTabType, self.curToggleIndex)
  self.rankList = {}
  local myRankData, myRankIndex
  if self.leagueTog:GetIsOn() then
    local realIndex = 0
    for _, v in ipairs(rankList) do
      if v.aid and myAllianceId == tostring(v.aid) then
        realIndex = realIndex + 1
        table.insert(self.rankList, v)
        if v.uid == myUid then
          myRankData = v
          myRankIndex = realIndex
        end
      end
    end
  else
    for i, v in ipairs(rankList) do
      table.insert(self.rankList, v)
      if v.uid == myUid then
        myRankData = v
        myRankIndex = i
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
  self:SetSelfInfo()
end

function UISandWormFishingRankView:SetSelfInfo()
  self.selfObj:SetActive(true)
  local myRankIndex, myRankScore = DataCenter.SandWormFishingDataManager:GetMyRank(self.curTabType, self.curToggleIndex)
  if myRankIndex <= 0 then
    self.selfRankTxt:SetLocalText(361054)
  else
    self.selfRankTxt:SetText(myRankIndex)
  end
  if self.curTabType == TabType.LevelRank then
    self.selfScoreTxt:SetLocalText(140002, myRankScore)
  elseif self.curTabType == TabType.DamageRank then
    self.selfScoreTxt:SetText(string.GetFormattedStr2(myRankScore))
  end
  local player = LuaEntry.Player
  self.selfHeadIcon:SetActive(true)
  self.selfHeadIcon:SetEnableClickShowInfo(true, true)
  self.selfHeadIcon:SetHead(player.uid, player.pic, player.picVer, nil, player:GetHeadBgImg())
  SandWormFishingRankItem.SetRankIcon(self.selfRankIcon, myRankIndex)
  local strName = LuaEntry.Player.name
  self.selfFirstTxt:SetText(strName)
  if LuaEntry.Player:IsInAlliance() then
    local alInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self.selfSecondTxt:SetText("[" .. alInfo.abbr .. "]" .. alInfo.allianceName)
  else
    self.selfSecondTxt:SetText("")
  end
end

function UISandWormFishingRankView:SetLevelRankItemIn(itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView1:AddComponent(SandWormFishingRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], curIndex, self.curTabType)
end

function UISandWormFishingRankView:SetLevelRankItemOut(itemObj, curIndex)
  self.loopListView1:RemoveComponents(itemObj.name, SandWormFishingRankItem)
end

function UISandWormFishingRankView:SetDamageRankItemIn(itemObj, curIndex)
  itemObj.name = tostring(curIndex)
  local cellItem = self.loopListView2:AddComponent(SandWormFishingRankItem, itemObj)
  cellItem:RefreshItem(self.rankList[curIndex], curIndex, self.curTabType)
end

function UISandWormFishingRankView:SetDamageRankItemOut(itemObj, curIndex)
  self.loopListView2:RemoveComponents(itemObj.name, SandWormFishingRankItem)
end

function UISandWormFishingRankView:ClearScroll()
  self.loopListView1:ClearCells()
  self.loopListView1:RemoveComponents(SandWormFishingRankItem)
  self.loopListView2:ClearCells()
  self.loopListView2:RemoveComponents(SandWormFishingRankItem)
end

return UISandWormFishingRankView
