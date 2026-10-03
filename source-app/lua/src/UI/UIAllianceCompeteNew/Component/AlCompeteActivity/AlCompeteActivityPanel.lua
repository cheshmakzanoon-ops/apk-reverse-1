local AlCompeteActivityPanel = BaseClass("AlCompeteActivityPanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceArmsBox = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsActivityBoxItem")
local AllianceArmsCondition = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsActivityConditionItem")
local AllianceScoreProg = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsScoreProgress")
local sliderDataTb = {
  {
    num = 0,
    percent = 0,
    isHide = true
  },
  {num = 20, percent = 0.15},
  {num = 50, percent = 0.5},
  {num = 100, percent = 0.85}
}
local titleBg_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader"
local goldNum_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageGold/goldNum"
local titleTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/titleTxt"
local titleName_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/titleName"
local descTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Img_DescBg/descTxt"
local RewardTips_path = "Imagetips"
local readyGo_path = "bgReady"
local leftBtn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/leftBtn"
local rightBtn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/rightBtn"
local closeTipsBtn_path = "Imagetips/bgBtn"
local myScoreTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Button calendar/myScoreTxt"
local myScorePreTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Button calendar/myScorePreTxt"
local rankPreTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ButtonRanking/rankPreTxt"
local rankTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ButtonRanking/rankTxt"
local rankNum_path = "rightLayer/rankEffectGo/rankBtn/rankNum"
local cdTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Image Time/txtTime"
local boxContainer_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor"
local cdTrs_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Image Time"
local goldGo_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageGold"
local scoreGo_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Button calendar"
local rankGo_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ButtonRanking"
local infoTxt_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/botTitle/infoTxt"
local rankBtn_path = "rightLayer/rankEffectGo/rankBtn"
local rankBtnTxt_path = "rightLayer/rankEffectGo/rankBtn/rankBtnTxt"
local leftImg_path = "Imagetips/leftImg"
local rightImg_path = "Imagetips/rightImg"
local valuaTipsTxt_path = "Imagetips/diamondbg/valuaTipsTxt"
local botttomTipTxt_path = "Imagetips/bottomLegGo/bg/botttomTipTxt"
local gotoLegBtn_path = "Imagetips/bottomLegGo/bg/gotoLegBtn"
local bottomLegGo_path = "Imagetips/bottomLegGo"
local noAllianceGo_path = "noAllianceGo"
local noAllianceTxt_path = "noAllianceGo/noAllianceTxt"
local legIconImg_path = "Imagetips/bottomLegGo/bg/bg2/legIconImg"
local conditionItem_path = "ScrollRoot/ScrollView/Viewport/Content/Image Lower part/AllianceArmConditionItem"
local bottomDesTxt_path = "Imagetips/bottomLegGo/bg/bottomDesTxt"
local Viewport1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1"
local Viewport2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2"
local groupBox1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/groupBox1"
local groupBox2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/groupBox2"
local groupBox3_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/groupBox3"
local groupBox4_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/groupBox4"
local groupBox5_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/groupBox5"
local groupBox6_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/groupBox6"
local infoBtn_path = "rightLayer/infoBtn"
local scoreCardBtn_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/scoreCardBtn"
local scoreCardIcon_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/scoreCardBtn/scoreCardIcon"
local scoreCardName_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/scoreCardBtn/scoreCardName"
local scoreCardGo_path = "scoreCardGo"
local scoreCardBgBtn_path = "scoreCardGo"
local cardItem_path = "scoreCardGo/BgImg/cardItem"
local conditionTrs_path = "ScrollRoot/ScrollView/Viewport/Content/Image Lower part"
local slider1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/slider1"
local slider2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/slider2"
local contentVerticalGroup_path = "ScrollRoot/ScrollView/Viewport/Content"
local contentSv_path = "ScrollRoot/ScrollView"
local readyTip1_path = "bgReady/readyDes1Txt"
local readyTip2_path = "bgReady/readyDes2Txt"
local scrollRect_path = "ScrollRoot/ScrollView"
local rewardBtn_path = "rightLayer/rewardBtn"
local rewardBtnTxt_path = "rightLayer/rewardBtn/rewawdTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ComponentDestroy()
  self:StopTimer()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceArms_OpenBox, self.OpenRewardTips)
  self:AddUIListener(EventId.RefreshAllianceArmsUI, self.RefreshAll)
  self:AddUIListener(EventId.OnUpdateActivityEventData, self.RefreshAll)
  self:AddUIListener(EventId.OnRecvNewActivityInfo, self.OnActivityInfoUpdate)
  self:AddUIListener(EventId.AllianceCompeteRankListUpdated, self.OnRankInfoUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceArms_OpenBox, self.OpenRewardTips)
  self:RemoveUIListener(EventId.RefreshAllianceArmsUI, self.RefreshAll)
  self:RemoveUIListener(EventId.OnUpdateActivityEventData, self.RefreshAll)
  self:RemoveUIListener(EventId.OnRecvNewActivityInfo, self.OnActivityInfoUpdate)
  self:RemoveUIListener(EventId.AllianceCompeteRankListUpdated, self.OnRankInfoUpdate)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleBg = self:AddComponent(UIImage, titleBg_path)
  self.goldNum = self:AddComponent(UIText, goldNum_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.titleName = self:AddComponent(UIText, titleName_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.RewardTips = self:AddComponent(UIBaseContainer, RewardTips_path)
  self.readyGo = self:AddComponent(UIBaseContainer, readyGo_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.leftBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickLeftBtn()
  end)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.rightBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRightBtn()
  end)
  self.conditionTrs = self:AddComponent(UIBaseContainer, conditionTrs_path)
  self.closeTipsBtn = self:AddComponent(UIButton, closeTipsBtn_path)
  self.closeTipsBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickCloseTipBtn()
  end)
  self.myScoreTxt = self:AddComponent(UIText, myScoreTxt_path)
  self.myScorePreTxt = self:AddComponent(UIText, myScorePreTxt_path)
  self.rankPreTxt = self:AddComponent(UIText, rankPreTxt_path)
  self.rankPreTxt:SetLocalText(361055)
  self.rankTxt = self:AddComponent(UIText, rankTxt_path)
  self.rankNumN = self:AddComponent(UIText, rankNum_path)
  self.cdTxt = self:AddComponent(UIText, cdTxt_path)
  self.boxContainer = self:AddComponent(UIBaseContainer, boxContainer_path)
  self.cdTrs = self:AddComponent(UIBaseContainer, cdTrs_path)
  self.goldGo = self:AddComponent(UIBaseContainer, goldGo_path)
  self.scoreGo = self:AddComponent(UIBaseContainer, scoreGo_path)
  self.rankGo = self:AddComponent(UIBaseContainer, rankGo_path)
  self.infoTxt = self:AddComponent(UIText, infoTxt_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rankBtnTxtN = self:AddComponent(UIText, rankBtnTxt_path)
  self.rankBtnTxtN:SetLocalText(361055)
  self.rankBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRankBtn()
  end)
  self.leftImg = self:AddComponent(UIImage, leftImg_path)
  self.rightImg = self:AddComponent(UIImage, rightImg_path)
  self.valuaTipsTxt = self:AddComponent(UIText, valuaTipsTxt_path)
  self.botttomTipTxt = self:AddComponent(UIText, botttomTipTxt_path)
  self.gotoLegBtn = self:AddComponent(UIButton, gotoLegBtn_path)
  self.gotoLegBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickGotoLegBtn()
  end)
  self.bottomLegGo = self:AddComponent(UIBaseContainer, bottomLegGo_path)
  self.noAllianceGo = self:AddComponent(UIBaseContainer, noAllianceGo_path)
  self.noAllianceTxt = self:AddComponent(UIText, noAllianceTxt_path)
  self.legIconImg = self:AddComponent(UIImage, legIconImg_path)
  self.conditionItem = self:AddComponent(UIBaseContainer, conditionItem_path)
  self.bottomDesTxt = self:AddComponent(UIText, bottomDesTxt_path)
  self.Viewport1 = self:AddComponent(UIBaseContainer, Viewport1_path)
  self.firstGroupGo = self.Viewport1
  self.Viewport2 = self:AddComponent(UIBaseContainer, Viewport2_path)
  self.secondGroupGo = self.Viewport2
  self.firstBoxes = {}
  table.insert(self.firstBoxes, self:AddComponent(AllianceArmsBox, groupBox1_path))
  table.insert(self.firstBoxes, self:AddComponent(AllianceArmsBox, groupBox2_path))
  table.insert(self.firstBoxes, self:AddComponent(AllianceArmsBox, groupBox3_path))
  self.secondBoxes = {}
  table.insert(self.secondBoxes, self:AddComponent(AllianceArmsBox, groupBox4_path))
  table.insert(self.secondBoxes, self:AddComponent(AllianceArmsBox, groupBox5_path))
  table.insert(self.secondBoxes, self:AddComponent(AllianceArmsBox, groupBox6_path))
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickInfoBtn()
  end)
  self.scoreCardBtn = self:AddComponent(UIButton, scoreCardBtn_path)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.scoreCardIcon = self:AddComponent(UIImage, scoreCardIcon_path)
  self.scoreCardName = self:AddComponent(UIText, scoreCardName_path)
  self.scoreCardGo = self:AddComponent(UIBaseContainer, scoreCardGo_path)
  self.scoreCardBgBtn = self:AddComponent(UIButton, scoreCardBgBtn_path)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.cardItem = self:AddComponent(UIBaseContainer, cardItem_path)
  self.slider1 = self:AddComponent(AllianceScoreProg, slider1_path)
  self.slider2 = self:AddComponent(AllianceScoreProg, slider2_path)
  self.contentVerticalGroup = self:AddComponent(UIBaseContainer, contentVerticalGroup_path)
  self.contentSv = self:AddComponent(UIBaseContainer, contentSv_path)
  self.readyTip1 = self:AddComponent(UIText, readyTip1_path)
  self.readyTip1:SetLocalText(361030)
  self.readyTip2 = self:AddComponent(UIText, readyTip2_path)
  self.readyTip2:SetLocalText(361031)
  self.scrollRectN = self:AddComponent(UIScrollRect, scrollRect_path)
  self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnN:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.rewardBtnTxtN = self:AddComponent(UIText, rewardBtnTxt_path)
  if DataCenter.LeagueMatchManager:CheckIsMatchOpen() then
    self.rewardBtnTxtN:SetLocalText(372815)
  else
    self.rewardBtnTxtN:SetLocalText(361012)
  end
end

local function ComponentDestroy(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function ShowPanel(self)
  self.scrollRectN:SetVerticalNormalizedPosition(1)
  self:InitUI()
end

local function InitUI(self)
  self:RefreshAll()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(actInfo.activityid))
  end
end

local function OnRankInfoUpdate(self)
  local rank = DataCenter.AllianceCompeteDataManager:GetPersonalRank()
  self.rankBtn:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UIleagueduel_btn_individual_rewards.png")
  self.rankNumN:SetText(0 < rank and rank or "")
end

local function OnActivityInfoUpdate(self)
  if IsNull(self.gameObject) then
    return
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(actInfo.activityid))
  end
end

local function RefreshAll(self)
  if IsNull(self.gameObject) then
    return
  end
  self:SetActive(true)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  self:RefreshData(true)
  self:OnRankInfoUpdate()
  self:CheckActBoxJump()
  local isMatchOpen = DataCenter.LeagueMatchManager:CheckIsMatchOpen()
  self.rewardBtnN:SetActive(isMatchOpen)
end

local function CheckActBoxJump(self)
  if self.view.boxIndex then
    local index = self.view.boxIndex
    self.view.boxIndex = nil
    index = 9
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if index <= 3 then
      elseif index <= 6 then
        self:OnClickRightBtn()
      elseif index <= 9 then
        for i = 1, 2 do
          self:OnClickRightBtn()
        end
      end
      self:OpenRewardTips(index)
    end, 0.6)
  end
end

local function RefreshData(self)
  if not self.activityInfo then
    return
  end
  self.RewardTips:SetActive(false)
  self.titleTxt:SetLocalText(self.activityInfo.activityName)
  self.titleName:SetLocalText(372284)
  self.descTxt:SetLocalText(self.activityInfo.desc_info)
  self.myScorePreTxt:SetLocalText(361029)
  if self.activityInfo.ranking == nil or self.activityInfo.ranking <= 0 then
    self.rankTxt:SetLocalText(361054)
  else
    self.rankTxt:SetText(self.activityInfo.ranking)
  end
  self.infoTxt:SetLocalText(370018)
  self.goldGo:SetActive(false)
  self:OpenTimer()
  if self:IsShowReady() then
    self.readyGo:SetActive(true)
    self.boxContainer:SetActive(false)
    self.scoreCardBtn:SetActive(false)
    self.conditionTrs:SetActive(false)
    return
  else
    self.goldGo:SetActive(true)
    self:RefreshScoreCard()
  end
  self.boxContainer:SetActive(true)
  self.eventInfo = self.activityInfo:GetEventInfo()
  if self.eventInfo == nil then
    return
  end
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if myAllianceId ~= nil and self.eventInfo.vsAllianceList ~= nil then
    local myScore = 0
    local vs = self.eventInfo.vsAllianceList[myAllianceId]
    if vs ~= nil then
      myScore = self.eventInfo.vsAllianceList[myAllianceId].alScore
    end
    local scoreStr = string.GetFormattedStr(myScore)
    self.myScoreTxt:SetText(scoreStr)
  else
    self.myScoreTxt:SetText(0)
    if self.eventInfo.vsAllianceList == nil then
    end
  end
  local score = string.GetFormattedSeperatorNum(tostring(self.eventInfo.currentScore))
  self.goldNum:SetText(score)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.readyGo:SetActive(curTime < self.eventInfo.startTime)
  self.firstGroupGo:SetActive(false)
  self.secondGroupGo:SetActive(true)
  self.curPage = self:GetTargetPageIndex()
  self:RefreshGroupBoxes(self.curPage)
  self.leftBtn:SetActive(self.curPage > 1)
  local showArrow = LuaEntry.DataConfig:CheckSwitch("armsbox_only_3")
  self.rightBtn:SetActive(showArrow and self.curPage < 3)
  self:SetProgress()
  self:RefreshCondition()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentVerticalGroup.transform)
end

local function GetTargetPageIndex(self)
  local isOn = LuaEntry.DataConfig:CheckSwitch("armsbox_only_3")
  if not isOn then
    return 1
  end
  for toIndex = 1, 3 do
    for i = 1, 3 do
      local index = (toIndex - 1) * 3 + i
      local tempStatus = self:GetBoxReceiveState(index)
      if tempStatus ~= 3 then
        return toIndex
      end
    end
  end
  return 3
end

local function OpenTimer(self)
  if self.deltaTimer == nil then
    self.deltaTimer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false, false, false)
    self.deltaTimer:Start()
  else
    self.deltaTimer:Reset()
  end
  self:OnTimer()
end

local function IsShowReady(self)
  local isReady = false
  local curTime = tonumber(UITimeManager:GetInstance():GetServerTime())
  local readyTime = self.activityInfo.readyTime
  local endTime = self.activityInfo.endTime
  if curTime > readyTime and 0 < endTime and curTime < self.activityInfo.startTime then
    isReady = true
  end
  return isReady
end

local function RefreshScoreCard(self)
  self.scoreCardBtn:SetActive(false)
end

local function RefreshGroupBoxes(self, toIndex)
  if self.firstGroupGo:GetActive() == false then
    self.firstGroupGo:SetActive(true)
    self.secondGroupGo:SetActive(false)
    self.boxUIList = {}
    for i = 1, 3 do
      local box = self.firstBoxes[i]
      local index = (toIndex - 1) * 3 + i
      local isGet = self:GetBoxReceiveState(index)
      box:SetBoxInfo(index, isGet, self.eventInfo.gemPriceList[index])
      box:ShowDiamond(true)
      box:SetLocked(index)
    end
  elseif self.secondGroupGo:GetActive() == false then
    self.firstGroupGo:SetActive(false)
    self.secondGroupGo:SetActive(true)
    for i = 1, 3 do
      local box = self.secondBoxes[i]
      local index = (toIndex - 1) * 3 + i
      local isGet = self:GetBoxReceiveState(index)
      box:SetBoxInfo(index, isGet, self.eventInfo.gemPriceList[index])
      box:ShowDiamond(true)
      box:SetLocked(index)
    end
  end
end

local function SetProgress(self)
  local curScore, score0, score1, score2, score3
  curScore = tonumber(self.eventInfo.currentScore)
  local tempInitScore = 0
  local count = #self.eventInfo.targetList
  for i = 1, 3 do
    local fd = math.fmod(i, 3)
    local index = 0
    if fd == 1 then
      index = (self.curPage - 1) * 3 + fd
      score1 = tonumber(self.eventInfo.targetList[index])
    elseif fd == 2 then
      index = (self.curPage - 1) * 3 + fd
      score2 = tonumber(self.eventInfo.targetList[index])
    elseif fd == 0 then
      index = self.curPage * 3
      score3 = tonumber(self.eventInfo.targetList[index])
    end
  end
  local lastEndScore = self.curPage == 1 and 0 or tonumber(self.eventInfo.targetList[(self.curPage - 1) * 3])
  sliderDataTb[1].num = lastEndScore
  sliderDataTb[2].num = score1
  sliderDataTb[3].num = score2
  sliderDataTb[4].num = score3
  self.slider1:SetCurProg(curScore, sliderDataTb)
  self.slider2:SetCurProg(curScore, sliderDataTb)
end

local function RefreshCondition(self)
  self.conditionTrs.gameObject:SetActive(true)
  self.conditionItem.gameObject:GameObjectCreatePool()
  self.conditionTrs:RemoveComponents(AllianceArmsCondition)
  self.conditionItem.gameObject:GameObjectRecycleAll()
  local count = #self.eventInfo.scoreIdListNew
  for i = 1, count do
    local item = self.conditionItem.gameObject:GameObjectSpawn(self.conditionTrs.transform)
    item.name = "item" .. i
    local obj = self.conditionTrs:AddComponent(AllianceArmsCondition, item.name)
    obj:RefreshData(self.eventInfo.scoreIdListNew[i], i)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.conditionTrs.transform)
end

local function OnTimer(self)
  if self.activityInfo == nil then
    self.cdTxt:SetText("")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.activityInfo.endTime
  local startTime = self.activityInfo.startTime
  local readyTime = self.activityInfo.readyTime
  if startTime == nil or endTime == nil then
    Logger.LogError("\230\180\187\229\138\168\230\151\182\233\151\180\228\184\141\230\173\163\231\161\174")
    self:StopTimer()
    return
  end
  local leftTime = endTime - curTime
  if curTime > startTime and 0 < leftTime then
    if self.readyGo ~= nil and self.readyGo:GetActiveInHierarchy() then
      self.readyGo:SetActive(false)
    end
    self.cdTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  elseif curTime < startTime and curTime > readyTime then
    local leftTime = startTime - curTime
    if self.readyGo ~= nil and self.readyGo:GetActiveInHierarchy() then
      self.readyGo:SetActive(true)
    end
    self.cdTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.cdTxt:SetLocalText("370100")
    if self.readyGo ~= nil and self.readyGo:GetActiveInHierarchy() then
      self.readyGo:SetActive(true)
    end
  end
end

local function GetBoxReceiveState(self, index)
  local getFlag
  local isGet = 1
  local canReceiveFlag
  if self.eventInfo.rewardFlagList ~= nil then
    canReceiveFlag = self.eventInfo.rewardFlagList[index]
  end
  if canReceiveFlag ~= nil and tonumber(canReceiveFlag) == index then
    isGet = 2
  end
  if self.eventInfo.newRewardFlagList ~= nil then
    getFlag = self.eventInfo.newRewardFlagList[index]
  end
  if getFlag ~= nil and tonumber(getFlag) == index then
    isGet = 3
  end
  return isGet
end

local function StopTimer(self)
  if self.deltaTimer ~= nil then
    self.deltaTimer:Stop()
    self.deltaTimer = nil
  end
end

local function OpenRewardTips(self, index)
  if IsNull(self.gameObject) then
    return
  end
  if self.activityInfo ~= nil then
    if self.eventInfo.newRewardFlagList ~= nil and self.eventInfo.newRewardFlagList[index] == index then
      self:ShowRewardTips(index)
      return
    end
    if tonumber(self.eventInfo.currentScore) < tonumber(self.eventInfo.targetList[index]) then
      self:ShowRewardTips(index)
      return
    end
    local unlocked = false
    if index <= 3 then
      unlocked = true
    elseif index <= 6 then
      unlocked = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_2) == 1
    elseif index <= 9 then
      unlocked = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_3) == 1
    end
    if not unlocked then
      self:ShowRewardTips(index)
      return
    end
    DataCenter.ActivityController:SendActivityGetRewardCommand(self.eventInfo.actId, self.eventInfo.targetList[index], self.eventInfo.type)
  end
end

local function ShowRewardTips(self, index)
  local rewardScience = self.eventInfo:GetRewardScience(index)
  local newIndex = (index - 1) % 3 + 1
  local isLeft = newIndex == 1
  local x = self.firstBoxes[newIndex].transform.position.x
  local y = self.firstBoxes[newIndex].transform.position.y
  local offset = 0
  local width = self.firstBoxes[newIndex].rectTransform.rect.width
  if isLeft then
    width = width * 0.75
  else
    width = width / 2
  end
  local diamondGet = tonumber(self.eventInfo.gemPriceList[index])
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", diamondGet), EnumActivity.AllianceCompete.EventType, x, y, isLeft, self.eventInfo.rewardScoreIndexArr[index], width, offset, nil, rewardScience)
end

local function OnClickLeftBtn(self)
  if self.curPage > 1 then
    self:RefreshGroupBoxes(self.curPage - 1, true)
    self.curPage = self.curPage - 1
    if self.curPage < 3 then
      self.rightBtn:SetActive(true)
    end
    if self.curPage == 1 then
      self.leftBtn:SetActive(false)
    end
  else
    return
  end
  self:SetProgress()
end

local function OnClickRightBtn(self)
  if self.curPage < 3 then
    self:RefreshGroupBoxes(self.curPage + 1, true)
    self.curPage = self.curPage + 1
    if self.curPage > 1 then
      self.leftBtn:SetActive(true)
    end
    if self.curPage == 3 then
      self.rightBtn:SetActive(false)
    end
  else
    return
  end
  self:SetProgress()
end

local function OnClickRankBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, {anim = true})
end

local function OnClickCloseTipBtn(self)
  self.RewardTips:SetActiveEx(false)
end

local function OnClickGotoLegBtn(self)
end

local function OnClickInfoBtn(self)
  local strTips = ""
  if DataCenter.LeagueMatchManager:CheckIsMatchOpen() then
    strTips = Localization:GetString("372813")
  else
    strTips = Localization:GetString("361074")
  end
  UIUtil.ShowIntro(Localization:GetString("361000"), Localization:GetString("100239"), strTips)
end

local function OnClickScoreCardBgBtn(self)
end

local function OnClickScoreCardBtn(self)
end

local function OnClickRewardBtn(self)
  local targetTab = 1
  local targetSeg = DataCenter.LeagueMatchManager:GetSegment()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILeagueMatchReward, {anim = true}, targetTab, targetSeg)
end

AlCompeteActivityPanel.OnCreate = OnCreate
AlCompeteActivityPanel.OnDestroy = OnDestroy
AlCompeteActivityPanel.ComponentDefine = ComponentDefine
AlCompeteActivityPanel.ComponentDestroy = ComponentDestroy
AlCompeteActivityPanel.OnDisable = OnDisable
AlCompeteActivityPanel.OnAddListener = OnAddListener
AlCompeteActivityPanel.OnRemoveListener = OnRemoveListener
AlCompeteActivityPanel.InitUI = InitUI
AlCompeteActivityPanel.OnActivityInfoUpdate = OnActivityInfoUpdate
AlCompeteActivityPanel.CheckActBoxJump = CheckActBoxJump
AlCompeteActivityPanel.RefreshAll = RefreshAll
AlCompeteActivityPanel.ShowPanel = ShowPanel
AlCompeteActivityPanel.RefreshData = RefreshData
AlCompeteActivityPanel.GetTargetPageIndex = GetTargetPageIndex
AlCompeteActivityPanel.OpenTimer = OpenTimer
AlCompeteActivityPanel.IsShowReady = IsShowReady
AlCompeteActivityPanel.RefreshScoreCard = RefreshScoreCard
AlCompeteActivityPanel.RefreshGroupBoxes = RefreshGroupBoxes
AlCompeteActivityPanel.SetProgress = SetProgress
AlCompeteActivityPanel.RefreshCondition = RefreshCondition
AlCompeteActivityPanel.OnTimer = OnTimer
AlCompeteActivityPanel.GetBoxReceiveState = GetBoxReceiveState
AlCompeteActivityPanel.StopTimer = StopTimer
AlCompeteActivityPanel.OpenRewardTips = OpenRewardTips
AlCompeteActivityPanel.ShowRewardTips = ShowRewardTips
AlCompeteActivityPanel.OnRankInfoUpdate = OnRankInfoUpdate
AlCompeteActivityPanel.OnClickLeftBtn = OnClickLeftBtn
AlCompeteActivityPanel.OnClickRightBtn = OnClickRightBtn
AlCompeteActivityPanel.OnClickRankBtn = OnClickRankBtn
AlCompeteActivityPanel.OnClickCloseTipBtn = OnClickCloseTipBtn
AlCompeteActivityPanel.OnClickGotoLegBtn = OnClickGotoLegBtn
AlCompeteActivityPanel.OnClickInfoBtn = OnClickInfoBtn
AlCompeteActivityPanel.OnClickScoreCardBgBtn = OnClickScoreCardBgBtn
AlCompeteActivityPanel.OnClickScoreCardBtn = OnClickScoreCardBtn
AlCompeteActivityPanel.OnClickScoreBtn = OnClickScoreBtn
AlCompeteActivityPanel.OnClickRewardBtn = OnClickRewardBtn
return AlCompeteActivityPanel
