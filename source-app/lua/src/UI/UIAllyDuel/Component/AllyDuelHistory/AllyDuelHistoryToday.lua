local AllyDuelHistoryToday = BaseClass("AllyDuelHistoryToday", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local AllyDuelHistoryTodayCell = require("UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryTodayCell")
local MAX_LENGTH = 20

function AllyDuelHistoryToday:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryToday:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryToday:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTimeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnDesc = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnDesc:SetOnClick(function()
    self:OnBtnDescClick()
  end)
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.imgFlagRed = self.viewSkin:AddComponent(self, UIImage, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.scrollRectSv = self.viewSkin:AddComponent(self, UIScrollRect, 7)
  self.textRedAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnRedScore = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRedScore:SetOnClick(function()
    self:OnBtnRedScoreClick()
  end)
  self.textRedScoreNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.imgFlagBlue = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textBlueAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnBlueScore = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnBlueScore:SetOnClick(function()
    self:OnBtnBlueScoreClick()
  end)
  self.textBlueScoreNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textTips1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.sliderBlue = self.viewSkin:AddComponent(self, UISlider, 17)
  self.sliderRed = self.viewSkin:AddComponent(self, UISlider, 18)
  self.textRedRatTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textBlueTatTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.btnAlInfo = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnAlInfo:SetOnClick(function()
    self:OnBtnAlInfoClick()
  end)
  self.loopListView2Sv = self.viewSkin:AddComponent(self, UILoopListView2, 23)
  self.compEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
end

function AllyDuelHistoryToday:ComponentDestroy()
  self.viewSkin = nil
  self.textTimeTxt = nil
  self.btnDesc = nil
  self.textTitleTxt = nil
  self.btnInfo = nil
  self.imgFlagRed = nil
  self.compContent = nil
  self.scrollRectSv = nil
  self.textRedAllianceNameTxt = nil
  self.btnRedScore = nil
  self.textRedScoreNumTxt = nil
  self.textTips = nil
  self.imgFlagBlue = nil
  self.textBlueAllianceNameTxt = nil
  self.btnBlueScore = nil
  self.textBlueScoreNumTxt = nil
  self.textTips1 = nil
  self.sliderBlue = nil
  self.sliderRed = nil
  self.textRedRatTxt = nil
  self.textBlueTatTxt = nil
  self.btnEmpty = nil
  self.btnAlInfo = nil
  self.loopListView2Sv = nil
  self.compEmpty = nil
  self.btnJump = nil
end

function AllyDuelHistoryToday:DataDefine()
  self.rankCells = {}
  self.rankList = {}
  self.cellCount = MAX_LENGTH
  self.loopListView2Sv:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

function AllyDuelHistoryToday:DataDestroy()
  self.compContent:RemoveComponents(AllyDuelHistoryTodayCell)
  self.loopListView2Sv:ClearAllItems()
  self.rankCells = nil
  self.rankList = nil
  self.cellCount = 0
end

function AllyDuelHistoryToday:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshRank)
end

function AllyDuelHistoryToday:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshRank)
  base.OnRemoveListener(self)
end

function AllyDuelHistoryToday:OnBtnDescClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 4)
end

function AllyDuelHistoryToday:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local strTips = ""
  if DataCenter.LeagueMatchManager:CheckIsMatchOpen() then
    strTips = Localization:GetString("372813")
  else
    strTips = Localization:GetString("361059") .. [[


]] .. Localization:GetString("361034") .. [[


]] .. Localization:GetString("361035") .. [[


]] .. Localization:GetString("361060")
  end
  UIUtil.ShowIntro(Localization:GetString("361000"), Localization:GetString("100239"), strTips)
end

function AllyDuelHistoryToday:OnBtnRedScoreClick()
  local content = Localization:GetString(361068)
  UIUtil.ShowBubbleTips(content, self.btnRedScore.transform.position, 0, 0, -20)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

function AllyDuelHistoryToday:OnBtnBlueScoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local content = Localization:GetString(361068)
  UIUtil.ShowBubbleTips(content, self.btnBlueScore.transform.position, 0, 0, -20)
end

function AllyDuelHistoryToday:OnBtnEmptyClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIUtil.ShowTipsId("alliance_duel10001")
end

function AllyDuelHistoryToday:OnBtnAlInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not string.IsNullOrEmpty(self.otherAlUid) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.otherAlName, self.otherAlUid)
  end
end

function AllyDuelHistoryToday:OnBtnJumpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueToday)
end

function AllyDuelHistoryToday:UpdateTime(timeStr, leftTime)
  if 0 < leftTime then
    if leftTime > OneDayTime * 1000 then
      local UITMgr = UITimeManager:GetInstance()
      local serverTimeS = UITMgr:GetServerSeconds()
      local todayZero = UITMgr:GetTodayZeroServerTime(serverTimeS)
      leftTime = (todayZero + OneDayTime - serverTimeS) * 1000
    end
    timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  end
  self.textTimeTxt:SetText(timeStr)
end

function AllyDuelHistoryToday:UpdateInfo()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
end

function AllyDuelHistoryToday:GetEventInfo()
  return self.actInfo ~= nil and self.actInfo:GetEventInfo() or nil
end

function AllyDuelHistoryToday:UpdateData()
  self:UpdateInfo()
  self:RefreshAlliance()
  self:SendRank()
  self:RefreshRank()
end

function AllyDuelHistoryToday:RefreshAlliance()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if not hasAlliance or myAllianceId == nil then
    return
  end
  local eventInfo = self:GetEventInfo()
  local allianceList = eventInfo ~= nil and eventInfo.vsAllianceList or nil
  if allianceList == nil then
    return
  end
  local myScore, otherScore = 0, 0
  table.walk(allianceList, function(k, v)
    local haveAl = not string.IsNullOrEmpty(v.alName)
    local name = haveAl and string.format([[
#%s [%s]
%s]], v.serverId, v.abbr, v.alName) or Localization:GetString("372814")
    if k == myAllianceId then
      self.textRedAllianceNameTxt:SetText(name)
      self.textRedScoreNumTxt:SetText(string.GetFormattedSeperatorNum(v.alScore or 0))
      if self.selfALIcon ~= v.icon then
        self.imgFlagRed:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, v.icon))
        self.selfALIcon = v.icon
      end
      myScore = tonumber(v.alScore or 0)
    else
      self.otherAlUid = k
      self.otherAlName = v.alName
      self.btnAlInfo:SetActive(haveAl)
      self.btnEmpty:SetActive(not haveAl)
      self.textBlueAllianceNameTxt:SetText(name)
      self.textBlueScoreNumTxt:SetText(string.GetFormattedSeperatorNum(v.alScore or 0))
      local icon = haveAl and v.icon or 1
      if self.otherALIcon ~= icon then
        self.imgFlagBlue:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, icon))
        self.otherALIcon = icon
      end
      otherScore = tonumber(v.alScore or 0)
    end
  end)
  local rate = 0
  self.textTitleTxt:SetText(string.format("<u>%s</u>", Localization:GetString(eventInfo.actName)))
  local myRateScore = myScore
  if myScore < 0 then
    myRateScore = 0
  end
  local otherRateScore = otherScore
  if otherScore < 0 then
    otherRateScore = 0
  end
  if myRateScore == otherRateScore then
    rate = 0.5
    self.sliderRed:SetValue(rate)
    self.textRedRatTxt:SetText("50%")
    self.textBlueTatTxt:SetText("50%")
  else
    local total = myRateScore + otherRateScore
    rate = tonumber(myRateScore / total)
    self.sliderRed:SetValue(rate)
    local redRate = math.floor(rate * 100 + 0.5)
    local blueRate = math.floor((1 - rate) * 100 + 0.5)
    self.textRedRatTxt:SetText(redRate .. "%")
    self.textBlueTatTxt:SetText(blueRate .. "%")
  end
end

function AllyDuelHistoryToday:SendRank()
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  DataCenter.AllianceCompeteDataManager:FetchRankList(AllyDuelRankType.Day, today)
  local list = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryList() or {}
  for _, v in pairs(list) do
    if v.day == today then
      self.textTips:SetLocalText("alliance_duel_tips11003", v.score)
      self.textTips1:SetText(string.format("\195\151%s", v.score))
      break
    end
  end
end

function AllyDuelHistoryToday:RefreshRank()
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  local rankList = DataCenter.AllianceCompeteDataManager:GetRankListState(AllyDuelRankType.Day, today) or {}
  local newCnt = #rankList
  local curCnt = self.rankList ~= nil and #self.rankList or 0
  if 0 < newCnt and curCnt == #rankList then
    local bChanged = false
    for i = 1, MAX_LENGTH do
      local vc = self.rankList[i]
      if vc == nil then
        break
      end
      local vn = rankList[i]
      if vc.uid ~= vn.uid or vc.score ~= vn.score then
        bChanged = true
        break
      end
    end
    if not bChanged then
      return
    end
  end
  self.rankList = rankList
  self.cellCount = math.min(newCnt, MAX_LENGTH)
  if 0 < self.cellCount then
    local maxScore = self.rankList[1].score or 0
    self.maxScore = 0 < maxScore and maxScore or 1
    self.mMvpIdx, self.eMvpIdx = -1, -1
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    for i, info in ipairs(rankList) do
      if info.aid == myAllianceId then
        if self.mMvpIdx == -1 then
          self.mMvpIdx = i
        end
      elseif self.eMvpIdx == -1 then
        self.eMvpIdx = i
      end
      if self.eMvpIdx ~= -1 and self.mMvpIdx ~= -1 then
        break
      end
    end
  end
  local haveCell = 0 < self.cellCount
  self.compContent:SetActive(haveCell)
  self.compEmpty:SetActive(not haveCell)
  if haveCell then
    self.loopListView2Sv:SetListItemCount(self.cellCount, false, false)
    self.loopListView2Sv:RefreshAllShownItem()
  end
end

function AllyDuelHistoryToday:OnGetItemByIndex(listView, index)
  if index < 0 or index > self.cellCount then
    return nil
  end
  self.prefabIndex = self.prefabIndex or 0
  local item = listView:NewListViewItem("AllyDuelHistoryTodayCell")
  if item == nil then
    return nil
  end
  local cell = self.rankCells[item]
  local rank = index + 1
  local info = self.rankList[rank]
  if cell == nil then
    item.gameObject.name = tostring(self.prefabIndex)
    self.prefabIndex = self.prefabIndex + 1
    cell = self.compContent:AddComponent(AllyDuelHistoryTodayCell, item.gameObject)
    self.rankCells[item] = cell
  end
  if info ~= nil then
    cell:SetActive(true)
    local bMvp = rank == self.eMvpIdx or rank == self.mMvpIdx
    cell:RefreshItem(self.rankList[rank], rank, self.maxScore, bMvp)
  else
    cell:SetActive(false)
  end
  return item
end

function AllyDuelHistoryToday:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self.rankCells[loopListViewItem]
  if script ~= nil then
    script:SetActive(false)
  end
end

return AllyDuelHistoryToday
