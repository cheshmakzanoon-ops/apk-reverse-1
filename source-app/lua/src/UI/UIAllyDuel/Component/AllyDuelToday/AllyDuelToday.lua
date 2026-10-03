local AllyDuelToday = BaseClass("AllyDuelToday", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceArmsBox = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsActivityBoxItem")
local AllianceArmsCondition = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsActivityConditionItem")
local AllianceScoreProg = require("UI.UIActivityCenterTable.Component.AllianceArms.AllianceArmsScoreProgress")
local AllyDuelTodayGacha = require("UI.UIAllyDuel.Component.AllyDuelToday.AllyDuelTodayGacha")
local BOX_NUM_PER_PAGE = 3
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
local dayRaw_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/DayRaw"
local goldNum_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageGold/goldNum"
local titleTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/titleTxt"
local titleName_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/titleName"
local descTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/Img_DescBg/descTxt"
local RewardTips_path = "Imagetips"
local readyGo_path = "bgReady"
local leftBtn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/leftBtn"
local rightBtn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/rightBtn"
local closeTipsBtn_path = "Imagetips/bgBtn"
local cdTxt_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageTime/txtTime"
local boxContainer_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor"
local cdTrs_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageTime"
local goldGo_path = "ScrollRoot/ScrollView/Viewport/Content/ImageTitleheader/ImageGold"
local infoTxt_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/botTitle/infoTxt"
local leftImg_path = "Imagetips/leftImg"
local rightImg_path = "Imagetips/rightImg"
local valuaTipsTxt_path = "Imagetips/diamondbg/valuaTipsTxt"
local botttomTipTxt_path = "Imagetips/bottomLegGo/bg/botttomTipTxt"
local gotoLegBtn_path = "Imagetips/bottomLegGo/bg/gotoLegBtn"
local bottomLegGo_path = "Imagetips/bottomLegGo"
local noAllianceGo_path = "noAllianceGo"
local noAllianceTxt_path = "noAllianceGo/noAllianceTxt"
local legIconImg_path = "Imagetips/bottomLegGo/bg/bg2/legIconImg"
local conditionItem_path = "ScrollRoot/ScrollView/Viewport/Content/Image Lower part/TaskItem"
local bottomDesTxt_path = "Imagetips/bottomLegGo/bg/bottomDesTxt"
local Viewport1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1"
local Viewport2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2"
local groupBox1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/AllyDuelBox1"
local groupBox2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/AllyDuelBox2"
local groupBox3_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/group1/AllyDuelBox3"
local groupBox4_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/AllyDuelBox4"
local groupBox5_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/AllyDuelBox5"
local groupBox6_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/group2/AllyDuelBox6"
local infoBtn_path = "rightLayer/infoBtn"
local conditionTrs_path = "ScrollRoot/ScrollView/Viewport/Content/Image Lower part"
local slider1_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport1/content1/slider1"
local slider2_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport2/content2/slider2"
local contentVerticalGroup_path = "ScrollRoot/ScrollView/Viewport/Content"
local contentSv_path = "ScrollRoot/ScrollView"
local readyTip1_path = "bgReady/readyDes1Txt"
local readyTip2_path = "bgReady/readyDes2Txt"
local scrollRect_path = "ScrollRoot/ScrollView"
local effectInfoBtn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/botTitle/effectInfoBtn"
local desc_btn_path = "rightLayer/DescBtn"
local desc_text_path = "rightLayer/DescBtn/DescIcon/DescText"
local lock_mask_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/lockMask"
local lock_tips_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/lockMask/lockTips"
local jump_btn_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/lockMask/jumpBtn"
local gachaParentItem_path = "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/Viewport3"
local DAY_IMG_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/Today/lrb_lianmengduijue_DAY%s_BANNER.png"

function AllyDuelToday:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.isShown = nil
  self.pageNum = 3
  local isScienceOpen = DataCenter.AllyDuelScoreGachaManager:IsScienceOpen()
  local gachaSwitch = LuaEntry.DataConfig:CheckSwitch("alliance_duel_zhuanpan")
  if isScienceOpen and gachaSwitch then
    self.isShowGacha = true
  end
end

function AllyDuelToday:OnEnable()
  base.OnEnable(self)
  if self.isShown then
    self:InitUI()
  end
end

function AllyDuelToday:OnDestroy()
  self.isShown = nil
  self.isShowGacha = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ComponentDestroy()
  self:StopTimer()
  if self.seenNewPage then
    CommonUtil.PlayerPrefsSetInt("AllyDuelBoxSeenPage", self.seenNewPage)
  end
  base.OnDestroy(self)
end

function AllyDuelToday:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceArms_OpenBox, self.OpenRewardTips)
  self:AddUIListener(EventId.RefreshAllianceArmsUI, self.RefreshAll)
  self:AddUIListener(EventId.OnUpdateActivityEventData, self.RefreshAll)
  self:AddUIListener(EventId.OnRecvNewActivityInfo, self.OnActivityInfoUpdate)
  self:AddUIListener(EventId.AllyDuelScoreRefresh, self.InitUI)
end

function AllyDuelToday:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceArms_OpenBox, self.OpenRewardTips)
  self:RemoveUIListener(EventId.RefreshAllianceArmsUI, self.RefreshAll)
  self:RemoveUIListener(EventId.OnUpdateActivityEventData, self.RefreshAll)
  self:RemoveUIListener(EventId.OnRecvNewActivityInfo, self.OnActivityInfoUpdate)
  self:RemoveUIListener(EventId.AllyDuelScoreRefresh, self.InitUI)
  base.OnRemoveListener(self)
end

function AllyDuelToday:ComponentDefine()
  self.titleBg = self:AddComponent(UIImage, titleBg_path)
  self.dayRaw = self:AddComponent(UIRawImage, dayRaw_path)
  self.goldNum = self:AddComponent(UIText, goldNum_path)
  self.titleTxt = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
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
  self.cdTxt = self:AddComponent(UIText, cdTxt_path)
  self.boxContainer = self:AddComponent(UIBaseContainer, boxContainer_path)
  self.cdTrs = self:AddComponent(UIBaseContainer, cdTrs_path)
  self.goldGo = self:AddComponent(UIBaseContainer, goldGo_path)
  self.infoTxt = self:AddComponent(UIText, infoTxt_path)
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
  self.conditionItem:SetActive(false)
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
  self.slider1 = self:AddComponent(AllianceScoreProg, slider1_path)
  self.slider2 = self:AddComponent(AllianceScoreProg, slider2_path)
  self.contentVerticalGroup = self:AddComponent(UIBaseContainer, contentVerticalGroup_path)
  self.contentSv = self:AddComponent(UIBaseContainer, contentSv_path)
  self.readyTip1 = self:AddComponent(UIText, readyTip1_path)
  self.readyTip1:SetLocalText(361030)
  self.readyTip2 = self:AddComponent(UIText, readyTip2_path)
  self.readyTip2:SetLocalText(361031)
  self.scrollRectN = self:AddComponent(UIScrollRect, scrollRect_path)
  self.pageToggleGroup = self:AddComponent(UIBaseContainer, "ScrollRoot/ScrollView/Viewport/Content/Imagefloor/ToggleGroup")
  self.toggleItem = self.transform:Find("ScrollRoot/ScrollView/Viewport/Content/Imagefloor/ToggleGroup/Toggle0").gameObject
  self.toggleItem:GameObjectCreatePool()
  self.toggleItem:SetActive(false)
  self.effectShowInfoBtn = self:AddComponent(UIButton, effectInfoBtn_path)
  self.effectShowInfoBtn:SetOnClick(function()
    self:OnClickEffectShowInfoBtn()
  end)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.desc_text:SetLocalText("gogncheng_liantu_tips1001")
  self.desc_btn:SetOnClick(function()
    self:OnDescBtnClick()
  end)
  self.lock_mask = self:AddComponent(UIBaseComponent, lock_mask_path)
  self.lock_tips = self:AddComponent(UIText, lock_tips_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.allyDuelTodayGachaParent = self:AddComponent(UIBaseContainer, gachaParentItem_path)
end

function AllyDuelToday:OnClickEffectShowInfoBtn()
  local effectInfos = self:RefreshEffectInfo()
  local datalist = {}
  local name = ""
  local value = ""
  for i = 1, #effectInfos do
    name = Localization:GetString(effectInfos[i].language)
    value = effectInfos[i].value
    datalist[i] = {}
    datalist[i].name = name
    datalist[i].value = value
  end
  local parameter = {
    titleAlignment = CS.UnityEngine.TextAnchor.UpperCenter,
    comtentWidthAdd = 120,
    layoutShow = true,
    datalist = datalist
  }
  UIUtil.ShowBubbleTips(nil, self.effectShowInfoBtn.transform.position, 0, -15, -120, nil, Localization:GetString(500035), parameter)
end

function AllyDuelToday:RefreshEffectInfo()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  local effectShowList = actInfo.eventInfo.effectShowList
  local effectInfos = {}
  for i = 1, #effectShowList do
    local num = LuaEntry.Effect:GetGameEffect(tonumber(effectShowList[i].id)) or 0
    effectInfos[i] = {}
    effectInfos[i].value = "+" .. string.format("%.0f", num * 100) .. "%"
    effectInfos[i].language = effectShowList[i].languageId
  end
  return effectInfos
end

function AllyDuelToday:ComponentDestroy()
  self:RemoveToggle()
  if self.readyTimer then
    self.readyTimer:Stop()
    self.readyTimer = nil
  end
  self.desc_btn = nil
  self.desc_text = nil
end

function AllyDuelToday:OnDisable()
  base.OnDisable(self)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function AllyDuelToday:ShowPanel()
  self.isShown = true
  self.scrollRectN:SetVerticalNormalizedPosition(1)
  self:InitUI()
end

function AllyDuelToday:InitUI()
  self:RefreshAll()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(actInfo.activityid))
  end
end

function AllyDuelToday:OnActivityInfoUpdate()
  if IsNull(self.gameObject) then
    return
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(actInfo.activityid))
  end
end

function AllyDuelToday:RefreshAll()
  if IsNull(self.gameObject) then
    return
  end
  self:SetActive(true)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  self:RefreshData(true)
  self:CheckActBoxJump()
end

function AllyDuelToday:CheckActBoxJump()
  if self.view.boxIndex then
    local index = self.view.boxIndex
    self.view.boxIndex = nil
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if index <= 3 then
        self.curPage = 1
      elseif index <= 6 then
        self.curPage = 2
      elseif index <= 9 then
        self.curPage = 3
      elseif self.isShowGacha then
        self.curPage = 4
      end
      self:RefreshPage()
      if index <= 9 then
        self:OpenRewardTips(index)
      end
    end, 1)
  end
end

function AllyDuelToday:RefreshData()
  if not self.activityInfo then
    return
  end
  self.eventInfo = self.activityInfo:GetEventInfo()
  local dayIdx = UITimeManager:GetInstance():GetNowWeekdayIndex()
  if self.dayIdx == nil or self.dayIdx ~= dayIdx then
    self.dayRaw:LoadSpriteAuto(string.format(DAY_IMG_PATH, dayIdx))
    self.dayIdx = dayIdx
  end
  self:InitToggle()
  self.RewardTips:SetActive(false)
  self.titleName:SetLocalText(372284)
  self.infoTxt:SetLocalText(370018)
  self.goldGo:SetActive(false)
  self:OpenTimer()
  if self:IsShowReady() then
    self.readyGo:SetActive(true)
    self.boxContainer:SetActive(false)
    self.conditionTrs:SetActive(false)
    if self.eventInfo == nil then
      return
    end
    self.titleTxt:SetLocalText(self.eventInfo.actName)
    self.titleTxt:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.Right or CS.TMPro.TextAlignmentOptions.Left)
    self.descTxt:SetLocalText(self.eventInfo.actDesc)
    return
  else
    self.goldGo:SetActive(true)
  end
  self.boxContainer:SetActive(true)
  if self.eventInfo == nil then
    return
  end
  self.titleTxt:SetLocalText(self.eventInfo.actName)
  self.titleTxt:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.Right or CS.TMPro.TextAlignmentOptions.Left)
  self.descTxt:SetLocalText(self.eventInfo.actDesc)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if myAllianceId ~= nil and self.eventInfo.vsAllianceList ~= nil then
    local myScore = 0
    local vs = self.eventInfo.vsAllianceList[myAllianceId]
    if vs ~= nil then
      myScore = self.eventInfo.vsAllianceList[myAllianceId].alScore
    end
  end
  local score = string.GetFormattedSeperatorNum(tostring(self.eventInfo.currentScore))
  self.goldNum:SetText(score)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.readyGo:SetActive(curTime < self.eventInfo.startTime)
  self.firstGroupGo:SetActive(false)
  self.secondGroupGo:SetActive(true)
  self.curPage = self:GetTargetPageIndex()
  self:RefreshGroupBoxes()
  self:RefreshLeftRightBtn()
  self:RefreshToggles()
  self:SetProgress()
  self:RefreshCondition()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentVerticalGroup.transform)
end

function AllyDuelToday:RefreshLeftRightBtn()
  self.leftBtn:SetActive(self.curPage > 1)
  local showArrow = LuaEntry.DataConfig:CheckSwitch("armsbox_only_3")
  self.rightBtn:SetActive(showArrow and self.curPage < self.pageNum)
end

function AllyDuelToday:RemoveToggle()
  self.pageToggleGroup:RemoveComponents(UIToggle)
  self.toggleItem:GameObjectRecycleAll()
  self.pageToggles = {}
end

function AllyDuelToday:InitToggle()
  self:RemoveToggle()
  if self.eventInfo and self.eventInfo.targetList then
    self.pageNum = #self.eventInfo.targetList // BOX_NUM_PER_PAGE
  end
  if self.isShowGacha then
    self.pageNum = self.pageNum + 1
  end
  for i = 1, self.pageNum do
    local go = self.toggleItem:GameObjectSpawn(self.pageToggleGroup.transform)
    go.name = "PageToggle" .. i
    self.pageToggles[i] = self.pageToggleGroup:AddComponent(UIToggle, go.name)
    self.pageToggles[i]:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
  end
end

function AllyDuelToday:RefreshToggles()
  self.pageToggles[self.curPage]:SetIsOn(true)
end

function AllyDuelToday:GetTargetPageIndex()
  local isOn = LuaEntry.DataConfig:CheckSwitch("armsbox_only_3")
  if not isOn then
    return 1
  end
  for toIndex = 1, self.pageNum do
    for i = 1, BOX_NUM_PER_PAGE do
      local index = (toIndex - 1) * BOX_NUM_PER_PAGE + i
      local tempStatus = self:GetBoxReceiveState(index)
      if tempStatus ~= 3 then
        return toIndex
      end
    end
  end
  return self.pageNum
end

function AllyDuelToday:OpenTimer()
  if self.deltaTimer == nil then
    self.deltaTimer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false, false, false)
    self.deltaTimer:Start()
  else
    self.deltaTimer:Reset()
  end
  self:OnTimer()
end

function AllyDuelToday:IsShowReady()
  local isReady = false
  local curTime = tonumber(UITimeManager:GetInstance():GetServerTime())
  local readyTime = self.activityInfo.readyTime
  local endTime = self.activityInfo.endTime
  if curTime > readyTime and 0 < endTime and curTime < self.activityInfo.startTime then
    isReady = true
  end
  if isReady and self.readyTimer == nil then
    self.readyTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshAll()
    end, (self.activityInfo.startTime - curTime) / 1000 + 5)
  end
  return isReady
end

function AllyDuelToday:RefreshGroupBoxes()
  local isNew = false
  self.seenNewPage = nil
  if self.curPage > 3 then
    local history = CommonUtil.PlayerPrefsGetInt("AllyDuelBoxSeenPage", 3)
    if history < self.curPage then
      isNew = true
      self.seenNewPage = self.curPage
    end
  end
  local showNew = {}
  if not isNew then
    showNew = self.eventInfo:CheckBoxHaveNewReward(self.curPage)
  end
  if self.curPage == self.pageNum and self.isShowGacha then
    self:LoadAndRefreshGachaContent()
    self.firstGroupGo:SetActive(false)
    self.secondGroupGo:SetActive(false)
  else
    self.allyDuelTodayGachaParent:SetActive(false)
    if self.firstGroupGo:GetActive() == false then
      self.firstGroupGo:SetActive(true)
      self.secondGroupGo:SetActive(false)
      self.boxUIList = {}
      for i = 1, BOX_NUM_PER_PAGE do
        local box = self.firstBoxes[i]
        local index = (self.curPage - 1) * BOX_NUM_PER_PAGE + i
        local isGet = self:GetBoxReceiveState(index)
        box:SetBoxInfo(index, isGet, self.eventInfo.gemPriceList[index], isNew or showNew[index])
        box:ShowDiamond(true)
        box:SetLocked(index)
      end
    elseif self.secondGroupGo:GetActive() == false then
      self.firstGroupGo:SetActive(false)
      self.secondGroupGo:SetActive(true)
      for i = 1, BOX_NUM_PER_PAGE do
        local box = self.secondBoxes[i]
        local index = (self.curPage - 1) * BOX_NUM_PER_PAGE + i
        local isGet = self:GetBoxReceiveState(index)
        box:SetBoxInfo(index, isGet, self.eventInfo.gemPriceList[index], isNew or showNew[index])
        box:ShowDiamond(true)
        box:SetLocked(index)
      end
    end
  end
  self:RefreshLockMask()
end

function AllyDuelToday:RefreshLockMask()
  if self.curPage == self.pageNum and self.isShowGacha then
    self.lock_mask:SetActive(false)
    return
  end
  local index = self.curPage * BOX_NUM_PER_PAGE
  self.eventInfo:GetRewardScience(index)
  local lock = not DataCenter.AllianceCompeteDataManager:Check9BoxUnlock(index)
  self.lock_mask:SetActive(lock)
  if lock then
    self.lock_tips:SetLocalText(self.eventInfo:GetRewardScience(index).dialogId)
  end
end

function AllyDuelToday:OnClickJumpBtn()
  local index = self.curPage * BOX_NUM_PER_PAGE
  local id = self.eventInfo:GetRewardScience(index).scienceId
  GoToUtil.GotoScience(id)
end

function AllyDuelToday:ToggleOn(index)
  if self.curPage == index then
    return
  end
  self.curPage = index
  self:RefreshGroupBoxes()
  self:RefreshLeftRightBtn()
  self:SetProgress()
  self:CheckGachaTipsBubble()
end

function AllyDuelToday:SetProgress()
  if self.curPage == self.pageNum and self.isShowGacha then
    return
  end
  local curScore
  curScore = tonumber(self.eventInfo.currentScore)
  local lastEndScore = self.curPage == 1 and 0 or tonumber(self.eventInfo.targetList[(self.curPage - 1) * 3])
  sliderDataTb[1].num = lastEndScore
  sliderDataTb[2].num = tonumber(self.eventInfo.targetList[(self.curPage - 1) * BOX_NUM_PER_PAGE + 1])
  sliderDataTb[3].num = tonumber(self.eventInfo.targetList[(self.curPage - 1) * BOX_NUM_PER_PAGE + 2])
  sliderDataTb[4].num = tonumber(self.eventInfo.targetList[(self.curPage - 1) * BOX_NUM_PER_PAGE + 3])
  if self.curPage * BOX_NUM_PER_PAGE == #self.eventInfo.targetList then
    self.slider1.progSlider:SetSizeDelta(Vector2(-100, 0))
    self.slider2.progSlider:SetSizeDelta(Vector2(-100, 0))
    sliderDataTb[2].percent = 0.17
    sliderDataTb[3].percent = 0.58
    sliderDataTb[4].percent = 1
  else
    self.slider1.progSlider:SetSizeDelta(Vector2(0, 0))
    self.slider2.progSlider:SetSizeDelta(Vector2(0, 0))
    sliderDataTb[2].percent = 0.15
    sliderDataTb[3].percent = 0.5
    sliderDataTb[4].percent = 0.85
  end
  self.slider1:SetCurProg(curScore, sliderDataTb)
  self.slider2:SetCurProg(curScore, sliderDataTb)
end

local function GetScoreIdByGroupAndValue(self, group, value)
  if self.eventInfo.groupId2IdList[group] then
    for k, v in pairs(self.eventInfo.groupId2IdList[group]) do
      if tonumber(v.value) == value then
        return v.id
      end
    end
  end
end

local function ProcessGroupShowData(self, data)
  local targetData
  local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
  if data.groupId == AllyDuelGroup.OpenTWEquipBox then
    targetData = LocalController:instance():getLine("score", AllyDuelGroup.OpenTWEquipBox)
  elseif data.groupId == AllyDuelGroup.TrainSoldier then
    local id = GetScoreIdByGroupAndValue(self, AllyDuelGroup.TrainSoldier, maxLevelSoldier.id)
    targetData = LocalController:instance():getLine("score", id)
  elseif data.groupId == AllyDuelGroup.KillEnemySoldier then
    local id = GetScoreIdByGroupAndValue(self, AllyDuelGroup.KillEnemySoldier, maxLevelSoldier.id)
    targetData = LocalController:instance():getLine("score", id)
  elseif data.groupId == AllyDuelGroup.KillSoldier then
    local id = GetScoreIdByGroupAndValue(self, AllyDuelGroup.KillSoldier, maxLevelSoldier.id)
    targetData = LocalController:instance():getLine("score", id)
  elseif data.groupId == AllyDuelGroup.DeadSoldier then
    local id = GetScoreIdByGroupAndValue(self, AllyDuelGroup.DeadSoldier, maxLevelSoldier.id)
    targetData = LocalController:instance():getLine("score", id)
  end
  if targetData then
    data.name = targetData:getValue("name")
    data.value = targetData:getValue("value")
    data.points = targetData:getValue("points")
    data.tips = targetData:getValue("tips")
    local effectInfo = targetData:getValue("effect_list")
    if effectInfo ~= nil and effectInfo ~= "" then
      data.effectList = {}
      local effects = string.split(effectInfo, ";")
      for i = 1, #effects do
        data.effectList[i] = effects[i]
      end
    end
  end
  return data
end

function AllyDuelToday:RefreshCondition()
  self.conditionTrs.gameObject:SetActive(true)
  self.conditionItem.gameObject:GameObjectCreatePool()
  self.conditionTrs:RemoveComponents(AllianceArmsCondition)
  self.conditionItem.gameObject:GameObjectRecycleAll()
  local showData = {}
  local groupIdCache = {}
  table.walk(self.eventInfo.scoreIdListNew, function(k, v)
    if v.groupId > 0 then
      if not groupIdCache[v.groupId] then
        local data = DeepCopy(v)
        data = ProcessGroupShowData(self, data)
        data.listInGroup = self.eventInfo.groupId2IdList[v.groupId] or {}
        table.insert(showData, data)
        groupIdCache[v.groupId] = true
      end
      return
    else
      table.insert(showData, v)
    end
  end)
  local count = #showData
  for i = 1, count do
    local item = self.conditionItem.gameObject:GameObjectSpawn(self.conditionTrs.transform)
    item.name = "item" .. i
    local obj = self.conditionTrs:AddComponent(AllianceArmsCondition, item.name)
    obj:RefreshData(showData[i], i)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.conditionTrs.transform)
end

function AllyDuelToday:OnTimer()
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
    leftTime = startTime - curTime
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

function AllyDuelToday:GetBoxReceiveState(index)
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

function AllyDuelToday:StopTimer()
  if self.deltaTimer ~= nil then
    self.deltaTimer:Stop()
    self.deltaTimer = nil
  end
end

function AllyDuelToday:OpenRewardTips(index)
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
    local unlocked = DataCenter.AllianceCompeteDataManager:Check9BoxUnlock(index)
    if not unlocked then
      self:ShowRewardTips(index)
      return
    end
    DataCenter.ActivityController:SendActivityGetRewardCommand(self.eventInfo.actId, self.eventInfo.targetList[index], self.eventInfo.type)
  end
end

function AllyDuelToday:ShowRewardTips(index)
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
  end
  local diamondGet = tonumber(self.eventInfo.gemPriceList[index])
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", diamondGet), EnumActivity.AllianceCompete.EventType, x, y, isLeft, self.eventInfo.rewardScoreIndexArr[index], width, offset, nil, rewardScience)
end

function AllyDuelToday:OnClickLeftBtn()
  if self.curPage <= 1 then
    return
  end
  self.curPage = self.curPage - 1
  self:RefreshPage()
end

function AllyDuelToday:OnClickRightBtn()
  if self.curPage >= self.pageNum then
    return
  end
  self.curPage = self.curPage + 1
  self:RefreshPage()
end

function AllyDuelToday:RefreshPage()
  self:RefreshGroupBoxes()
  self:RefreshToggles()
  self:RefreshLeftRightBtn()
  self:SetProgress()
  self:CheckGachaTipsBubble()
end

function AllyDuelToday:OnClickCloseTipBtn()
  self.RewardTips:SetActiveEx(false)
end

function AllyDuelToday:OnClickGotoLegBtn()
end

function AllyDuelToday:OnClickInfoBtn()
  local strTips = ""
  if DataCenter.LeagueMatchManager:CheckIsMatchOpen() then
    strTips = Localization:GetString("372813")
  else
    strTips = Localization:GetString("361074")
  end
  UIUtil.ShowIntro(Localization:GetString("361000"), Localization:GetString("100239"), strTips)
end

function AllyDuelToday:OnDescBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 4)
end

function AllyDuelToday:ClearGachaContent()
  if self.gachaReq then
    self:GameObjectDestroy(self.gachaReq)
    self.gachaReq = nil
  end
  self.allyDuelTodayGachaParent:RemoveComponents(AllyDuelTodayGacha)
  self.allyDuelTodayGachaItem = nil
end

function AllyDuelToday:LoadAndRefreshGachaContent()
  self.allyDuelTodayGachaParent:SetActive(true)
  if not self.gachaReq then
    self.gachaReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelTodayGacha.prefab", function(req)
      if req == nil or IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "gacha"
      item:SetActive(true)
      item.transform:SetParent(self.allyDuelTodayGachaParent.transform)
      item.transform:Set_localScale(1, 1, 1)
      item.transform:Set_pivot(0.5, 0.5)
      item.transform:Set_anchoredPosition(0, 0)
      self.allyDuelTodayGachaItem = self.allyDuelTodayGachaParent:AddComponent(AllyDuelTodayGacha, item.name)
    end)
  elseif self.allyDuelTodayGachaItem then
    self.allyDuelTodayGachaItem:ReInit()
  end
end

function AllyDuelToday:CheckGachaTipsBubble()
  local hasShown = CommonUtil.PlayerPrefsGetBool(SettingKeys.AD_GACHA_TIP_BUBBLE_SHOWN, false)
  local showBubble = not hasShown and self.curPage == self.pageNum - 1 and self.isShowGacha
  if showBubble and not self.gachaTipsBubble then
    local luaPath = "UI.UIAllyDuel.Component.AllyDuelToday.AllyDuelTodayGachaTipBubble"
    local prefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelTodayGachaTipBubble.prefab"
    self.gachaTipsBubble = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self, function(view)
      self.gachaTipsBubble.rectTransform:Set_anchoredPosition(351, -557)
      self.gachaTipsBubble:SetActive(showBubble)
      self.gachaTipsBubble:ReInit()
    end)
  elseif self.gachaTipsBubble then
    self.gachaTipsBubble:SetActive(showBubble)
  end
end

return AllyDuelToday
