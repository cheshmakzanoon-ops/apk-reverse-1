local PersonalArms = BaseClass("PersonalArms", UIBaseView)
local UIPersonalArmsTargetItem = require("UI.UIActivityCenterTable.Component.PersonalArms.UIPersonalArmsTargetItem")
local UIPersonalArmsRankItem = require("UI.UIActivityCenterTable.Component.PersonalArms.UIPersonalArmsRankItem")
local uiPersonalArmsDailyTipComponent = require("UI.UIActivityCenterTable.Component.PersonalArms.UIPersonalArmsDailyTipComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local string_IsNullOrEmpty = string.IsNullOrEmpty
local tonumber = _ENV.tonumber
local string_format = string.format
local table_count = table.count
local root_path = "ScrollView/Viewport/rootContent"
local detailContent_path = root_path .. "/detailContent/"
local rankRoot_path = root_path .. "/"
local duel_score_check_path = "ScrollView/Viewport/rootContent/detailContent/infoContent/Img_CurrentBg/DuelScoreCheck"
local p_go_calendar_red_path = "ScrollView/Viewport/rootContent/detailContent/infoContent/Btn_Calendar/p_go_calendar_red"
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")

function PersonalArms:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PersonalArms:OnDestroy()
  self:DataDestroy()
  self:ClearBoxRewards()
  self:SetAllCellDestroy()
  self:SetAllRankCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PersonalArms:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityPersonalArmsUpdate, self.OnDataUpdate)
  self:AddUIListener(EventId.ActivityPersonalArmsScoreReward, self.OnScoreRewardGot)
  self:AddUIListener(EventId.PersonalArmsRank, self.OnRankViewUpdate)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.DoPointFly)
  self:AddUIListener(EventId.MultiRewardDataUpdate, self.RefreshDailySliderView)
  self:AddUIListener(EventId.ActivityPersonalArmsExchangeCallback, self.OnExchangeCallback)
  self:AddUIListener(EventId.ActivityPersonalArmsCalendarExchangeRed, self.OnExchangeClicked)
end

function PersonalArms:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityPersonalArmsUpdate, self.OnDataUpdate)
  self:RemoveUIListener(EventId.ActivityPersonalArmsScoreReward, self.OnScoreRewardGot)
  self:RemoveUIListener(EventId.PersonalArmsRank, self.OnRankViewUpdate)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.DoPointFly)
  self:RemoveUIListener(EventId.MultiRewardDataUpdate, self.RefreshDailySliderView)
  self:RemoveUIListener(EventId.ActivityPersonalArmsExchangeCallback, self.OnExchangeCallback)
  self:RemoveUIListener(EventId.ActivityPersonalArmsCalendarExchangeRed, self.OnExchangeClicked)
end

function PersonalArms:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.infoContent = self:AddComponent(UIBaseContainer, detailContent_path .. "infoContent")
  self.titleText = self:AddComponent(UIText, detailContent_path .. "infoContent/TitleText")
  self.timeText = self:AddComponent(UIText, detailContent_path .. "infoContent/timeText")
  self.currentNum_txt = self:AddComponent(UIText, detailContent_path .. "infoContent/Img_CurrentBg/Txt_CurrentNum")
  self.eventImg = self:AddComponent(UIRawImage, detailContent_path .. "infoContent/eventImg")
  self.calender_icon = self:AddComponent(UIImage, detailContent_path .. "infoContent/Btn_Calendar/Icon")
  self.calender_btn = self:AddComponent(UIButton, detailContent_path .. "infoContent/Btn_Calendar")
  self.calender_btn:SetOnClick(function()
    self:OnClickCalender()
  end)
  self.tip_btn = self:AddComponent(UIButton, detailContent_path .. "infoContent/Btn_Tip")
  self.tip_btn:SetOnClick(function()
    self:OnClickTip()
  end)
  self.desc_txt = self:AddComponent(UIText, detailContent_path .. "infoContent/Txt_Desc")
  self.dailyContent = self:AddComponent(UIBaseContainer, detailContent_path .. "dailyContent")
  self.dailyTitleText = self:AddComponent(UIText, detailContent_path .. "dailyContent/dailyTitleText")
  self.dailyTitleText:SetLocalText(2000375)
  self.dailyProgressVal = self:AddComponent(UIBaseContainer, detailContent_path .. "dailyContent/dailyProgressBg/dailyProgressVal")
  self.dailyScoreNum = self:AddComponent(UIText, detailContent_path .. "dailyContent/dailyProgressBg/dailyScoreBg/dailyScoreNum")
  self.dailyBoxList = {}
  for i = 1, 3 do
    local boxRoot = self:AddComponent(UIButton, detailContent_path .. "dailyContent/dailyProgressBg/dailyBoxContent/dailyBoxItem" .. i)
    self.dailyBoxList[i] = {
      root = boxRoot,
      dailyBoxIcon = boxRoot:AddComponent(UIImage, "dailyBoxIcon"),
      dailyBoxNum = boxRoot:AddComponent(UIText, "dailyBoxNum"),
      effect = boxRoot:AddComponent(UIBaseContainer, "effect"),
      doubleMark = boxRoot:AddComponent(UIBaseContainer, "doubleMark")
    }
    boxRoot:SetOnClick(function()
      self:OnDailyBoxClick(i)
    end)
  end
  self.btnDailyBox = self:AddComponent(UIButton, detailContent_path .. "dailyContent/BtnDailyBox")
  self.imgDailyBox = self:AddComponent(UIImage, detailContent_path .. "dailyContent/BtnDailyBox")
  self.btnDailyBox:SetOnClick(function()
    self:OnBtnDailyBoxClick()
  end)
  self.dailyProgressText = self:AddComponent(UITextMeshProUGUIEx, detailContent_path .. "dailyContent/dailyProgressText")
  self.dailyBoxProgressVal = self:AddComponent(UIBaseContainer, detailContent_path .. "dailyContent/dailyProgressBgImg/dailyProgressVal2")
  self.dailyBoxAnimator = self.imgDailyBox.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  self.scoreContent = self:AddComponent(UIBaseContainer, detailContent_path .. "scoreContent")
  self.scoreProgressVal = self:AddComponent(UIBaseContainer, detailContent_path .. "scoreContent/progressBg/scoreProgressVal")
  self.scoreBoxList = {}
  for i = 1, 3 do
    local boxRoot = self:AddComponent(UIBaseContainer, detailContent_path .. "scoreContent/group/scoreBoxItem" .. i)
    self.scoreBoxList[i] = {
      root = boxRoot,
      bg = boxRoot:AddComponent(UIImage, "bg"),
      icon = boxRoot:AddComponent(UIImage, "Icon"),
      btnReward = boxRoot:AddComponent(UIButton, "BtnReward"),
      dimondBg = boxRoot:AddComponent(UIBaseContainer, "dimondBg"),
      dimondTxt = boxRoot:AddComponent(UIText, "dimondBg/dimondTxt"),
      targetNum = boxRoot:AddComponent(UIText, "targetNum"),
      effect = boxRoot:AddComponent(UIBaseContainer, "effect"),
      bgGold = boxRoot:AddComponent(UIBaseContainer, "bgGold")
    }
    if self.scoreBoxList[i].icon then
      self.scoreBoxList[i].iconAnimator = self.scoreBoxList[i].icon.transform:GetComponent(typeof(CS.UnityEngine.Animator))
    end
    self.scoreBoxList[i].btnReward:SetOnClick(function()
      self:OnScoreBoxClick(i)
    end)
  end
  self.taskContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "taskContent")
  self.taskTitleTxt = self:AddComponent(UIText, rankRoot_path .. "taskContent/taskTitleTxt")
  self.taskTitleTxt:SetLocalText(2000373)
  self.taskListContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "taskContent/ScrollView/Viewport/taskListContent")
  self.rankContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "rankContent")
  self.rankTitleTxt = self:AddComponent(UIText, rankRoot_path .. "rankContent/rankTitleTxt")
  self.rankTitleTxt:SetLocalText("activity_arms_race_tips02")
  self.rankTitleTxt:SetActive(false)
  self.rankListContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "rankContent/rankListContent")
  self.emojiContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "rankContent/emojiContent")
  self.emptyContent = self:AddComponent(UIBaseContainer, rankRoot_path .. "rankContent/emptyContent")
  self.emptyTxt1 = self:AddComponent(UIText, rankRoot_path .. "rankContent/emptyContent/emptyTxt1")
  self.emptyTxt2 = self:AddComponent(UIText, rankRoot_path .. "rankContent/emptyContent/emptyTxt2")
  self.emoji1 = self:AddComponent(UIImage, rankRoot_path .. "rankContent/emojiContent/emoji1")
  self.emoji2 = self:AddComponent(UIImage, rankRoot_path .. "rankContent/emojiContent/emoji2")
  self.emoji3 = self:AddComponent(UIImage, rankRoot_path .. "rankContent/emojiContent/emoji3")
  self.btnRankReward = self:AddComponent(UIButton, "BtnRankReward")
  self.btnRankReward:SetOnClick(function()
    self:OnBtnRankReward()
  end)
  self.selfRankItem = self:AddComponent(UIPersonalArmsRankItem, "selfRankData")
  self.rankItemPrefab = self:AddComponent(UIBaseContainer, rankRoot_path .. "rankContent/rankListContent/PersonalArmsRankItem")
  self.boxMultiMarkObj = self:AddComponent(UIBaseContainer, detailContent_path .. "dailyContent/BtnDailyBox/doubleMark")
  self.effectBox = self:AddComponent(UIBaseContainer, detailContent_path .. "dailyContent/effectParent")
  self.comp_reward_change_entrance = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, detailContent_path .. "infoContent/RewardChangeBtn")
  self.p_go_calendar_red = self:AddComponent(UIBaseContainer, p_go_calendar_red_path)
end

function PersonalArms:ComponentDestroy()
  self.root = nil
  self.infoContent = nil
  self.titleText = nil
  self.timeText = nil
  self.currentNum_txt = nil
  self.eventImg = nil
  self.calender_btn = nil
  self.tip_btn = nil
  self.desc_txt = nil
  self.dailyContent = nil
  self.dailyTitleText = nil
  self.dailyProgressVal = nil
  self.dailyScoreNum = nil
  self.dailyBoxList = nil
  self.scoreContent = nil
  self.scoreProgressVal = nil
  self.scoreBoxList = nil
  self.taskContent = nil
  self.taskTitleTxt = nil
  self.taskContent = nil
  self.rankContent = nil
  self.rankTitleTxt = nil
  self.rankListContent = nil
  self.emojiContent = nil
  self.emptyContent = nil
  self.emptyTxt1 = nil
  self.emptyTxt2 = nil
  self.emoji1 = nil
  self.emoji2 = nil
  self.emoji3 = nil
  self.btnRankReward = nil
  self.effectBox = nil
  self.p_go_calendar_red = nil
end

function PersonalArms:DataDefine()
  self.activityId = nil
  self.showData = nil
  self.refreshTime = 0
  self.heroEventCfg = nil
  self.emojiHideTime = 0
  self.curDayEndTime = 0
  self.dailyBoxShowData = {}
  self.dailyBoxShowData.sliderLen = 400
  self.dailyBoxShowData.boxListData = {
    [1] = {
      pos = {x = 70, y = 17.8},
      perPos = 0,
      valPos = 70,
      closeImg = "wxy_junbei_baoxiang1_01",
      openImg = "wxy_junbei_baoxiang1_02"
    },
    [2] = {
      pos = {x = 230, y = 17.8},
      perPos = 70,
      valPos = 230,
      closeImg = "wxy_junbei_baoxiang2_01",
      openImg = "wxy_junbei_baoxiang2_02"
    },
    [3] = {
      pos = {x = 400, y = 17.8},
      perPos = 230,
      valPos = 400,
      closeImg = "wxy_junbei_baoxiang3_01",
      openImg = "wxy_junbei_baoxiang3_02"
    }
  }
  self.scoreBoxShowData = {}
  self.scoreBoxShowData.sliderLen = 590
  self.scoreBoxShowData.boxListData = {
    [1] = {
      perPos = 0,
      valPos = 75,
      bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_lan",
      closeImg = "UIactivities_icon_box1",
      openImg = "UIactivities_icon_box1_1"
    },
    [2] = {
      perPos = 75,
      valPos = 340,
      bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_zi",
      closeImg = "UIactivities_icon_box2",
      openImg = "UIactivities_icon_box2_1"
    },
    [3] = {
      perPos = 340,
      valPos = 590,
      bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_jin",
      closeImg = "UIactivities_icon_box3",
      openImg = "UIactivities_icon_box3_1"
    }
  }
  self.emojiIdList = {
    1,
    3,
    5,
    7,
    13,
    14,
    17,
    21,
    27,
    45,
    50
  }
  self.readyPlayAnimFlag = false
end

function PersonalArms:DataDestroy()
  self.activityId = nil
  self.showData = nil
  self.refreshTime = nil
  self.heroEventCfg = nil
  self.emojiHideTime = nil
  self.curDayEndTime = 0
  self.dailyBoxShowData = nil
  self.scoreBoxShowData = nil
  self.emojiIdList = nil
  self.scoreBoxIndex = nil
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
  self.progressBoxCurIndex = nil
  if self.stateValues then
    table.clear(self.stateValues)
    self.stateValues = nil
  end
  self.pointNum = nil
  self.readyPlayAnimFlag = nil
  self:StopTimer()
end

function PersonalArms:RefreshNoDataView()
  self.infoContent:SetActive(false)
  self.dailyContent:SetActive(false)
  self.scoreContent:SetActive(false)
  self.taskContent:SetActive(false)
  self.rankContent:SetActive(false)
end

function PersonalArms:RefreshView()
  self.infoContent:SetActive(true)
  self.scoreContent:SetActive(true)
  self.taskContent:SetActive(true)
  self.rankContent:SetActive(true)
  self:RefreshInfoView()
  self:RefreshScoreView()
  self:RefreshTaskView()
  self:RefreshRankView()
end

function PersonalArms:RefreshDailySliderView()
  if self.showData then
    self.dailyContent:SetActive(true)
    self:RefreshDailyView()
  end
end

function PersonalArms:RefreshInfoView()
  if self.heroEventCfg then
    local titleKey = self.heroEventCfg.name
    self.titleText:SetLocalText(titleKey)
    if self.showData.minLevelStage > 0 or 0 < self.showData.maxLevelStage then
      local rangStr = string.format("%d-%d", self.showData.minLevelStage, self.showData.maxLevelStage)
      local descKey = self.heroEventCfg.desc
      local descStr = Localization:GetString(descKey, rangStr)
      self.desc_txt:SetText(descStr)
    else
      self.desc_txt:SetText("")
    end
    local picName = self.heroEventCfg.pic
    local dirStr = "Assets/Main/TextureEx/UIPersonalArms/%s.png"
    local picPath = string.format(dirStr, picName)
    self.eventImg:LoadSprite(picPath)
  end
  self.currentNum_txt:SetText(string.GetFormattedSeparatorNum(self.showData.sc))
  self:RefreshTimeView()
end

function PersonalArms:RefreshDailyView(showAnim)
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
  self.dailyScoreNum:SetText(self.showData.resourceItemNum)
  local progressNum = self.showData.resourceItemNum
  if progressNum > self.showData.day_rewards_max then
    progressNum = self.showData.day_rewards_max
  end
  local progressLen = 0
  local isProgressSet = false
  self.curShowIndex = 1
  local isSetCurShowIndex = false
  local curOpenBoxIndex = 0
  if self.stateValues == nil then
    self.stateValues = {}
  else
    table.clear(self.stateValues)
  end
  for i = 1, #self.dailyBoxList do
    local boxItem = self.dailyBoxList[i]
    local boxItemData = self.dailyBoxShowData.boxListData[i]
    local boxItemServerData = self.showData.day_rewards[i]
    if not showAnim then
      self:SetBoxItemStatus(i)
    end
    boxItem.root:SetAnchoredPositionXY(boxItemData.pos.x, boxItemData.pos.y)
    local boxNum = boxItemServerData.resourceNum
    boxItem.dailyBoxNum:SetText(boxNum)
    if not isProgressSet and progressNum <= boxNum then
      isProgressSet = true
      progressLen = boxItemData.perPos + 1.0 * progressNum / boxNum * (boxItemData.valPos - boxItemData.perPos)
    end
    self.stateValues[i] = boxItemData.valPos
    local curMultiRewardVal = MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue()
    if curMultiRewardVal then
      boxItem.doubleMark:SetActive(1 < curMultiRewardVal)
    else
      boxItem.doubleMark:SetActive(false)
    end
    local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, i)
    if not isSetCurShowIndex then
      if boxState == ActivityBoxState.CanOpen then
        self.curShowIndex = i
        isSetCurShowIndex = true
      elseif boxState == ActivityBoxState.Open then
        curOpenBoxIndex = i
      end
    end
    local isShowDoubleMark = MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue()
    self.boxMultiMarkObj:SetActive(1 < isShowDoubleMark)
  end
  if not isSetCurShowIndex then
    local totalBoxNum = #self.dailyBoxList
    if totalBoxNum >= curOpenBoxIndex + 1 then
      self.curShowIndex = curOpenBoxIndex + 1
    else
      self.curShowIndex = totalBoxNum
    end
  end
  local minCanOpenboxData = self.showData.day_rewards[self.curShowIndex]
  local curStageNeedNum = minCanOpenboxData.resourceNum
  self.dailyProgressText:SetText(string.format("%d/%d", self.showData.resourceItemNum, curStageNeedNum))
  local showBoxData = self.dailyBoxShowData.boxListData[self.curShowIndex]
  local showBoxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, self.curShowIndex)
  if showBoxState == ActivityBoxState.Open then
    local iconPath = string_format(LoadPath.UIPersonalArms, showBoxData.openImg)
    self.imgDailyBox:LoadSprite(iconPath)
    self:SetDailyBoxCanOpenAnim(false)
  else
    local iconPath = string_format(LoadPath.UIPersonalArms, showBoxData.closeImg)
    self.imgDailyBox:LoadSprite(iconPath)
    if showBoxState == ActivityBoxState.CanOpen then
      self:SetDailyBoxCanOpenAnim(true)
    else
      self:SetDailyBoxCanOpenAnim(false)
    end
  end
  local maxLength = 126
  local curProgress = self.showData.resourceItemNum / curStageNeedNum
  curProgress = math.min(curProgress, 1)
  self.dailyBoxProgressVal:SetSizeDeltaX(maxLength * curProgress)
  if not showAnim then
    self.dailyProgressVal:SetSizeDeltaX(progressLen)
    return
  end
  self.progressBoxCurIndex = 1
  
  local function getCallback()
    return self.dailyProgressVal:GetSizeDelta().x
  end
  
  local function setCallback(value)
    self.dailyProgressVal:SetSizeDeltaX(value)
    if value >= self.stateValues[self.progressBoxCurIndex] then
      self:SetBoxItemStatus(self.progressBoxCurIndex)
      self.progressBoxCurIndex = self.progressBoxCurIndex + 1
    end
  end
  
  self.progressTween = CS.DG.Tweening.DOTween.To(getCallback, setCallback, progressLen, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function PersonalArms:SetBoxItemStatus(index)
  if index > table_count(self.dailyBoxList) then
    return
  end
  local boxItem = self.dailyBoxList[index]
  local boxItemData = self.dailyBoxShowData.boxListData[index]
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, index)
  if boxState == ActivityBoxState.Close then
    local iconPath = string_format(LoadPath.UIPersonalArms, boxItemData.closeImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(false)
  elseif boxState == ActivityBoxState.CanOpen then
    local iconPath = string_format(LoadPath.UIPersonalArms, boxItemData.closeImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(true)
  elseif boxState == ActivityBoxState.Open then
    local iconPath = string_format(LoadPath.UIPersonalArms, boxItemData.openImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(false)
  end
end

function PersonalArms:RefreshScoreView()
  local progressNum = self.showData.sc
  if progressNum > self.showData.score_reward_max then
    progressNum = self.showData.score_reward_max
  end
  local progressLen = 0
  local isProgressSet = false
  for i = 1, #self.scoreBoxList do
    local boxItem = self.scoreBoxList[i]
    local boxItemData = self.scoreBoxShowData.boxListData[i]
    local boxItemServerData = self.showData.score_rewards[i]
    local boxState = DataCenter.ActivityPersonalArmsDataManager:GetScoreBoxState(self.showData, i)
    if boxState == ActivityBoxState.Close then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
      boxItem.bgGold:SetActive(false)
      if boxItem.iconAnimator then
        boxItem.iconAnimator:Play("box_unOpen", 0, 0)
      end
    elseif boxState == ActivityBoxState.CanOpen then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(true)
      boxItem.bgGold:SetActive(true)
      if boxItem.iconAnimator then
        boxItem.iconAnimator:Play("box_open", 0, 0)
      end
    elseif boxState == ActivityBoxState.Open then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.openImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
      boxItem.bgGold:SetActive(false)
      if boxItem.iconAnimator then
        boxItem.iconAnimator:Play("box_unOpen", 0, 0)
      end
    end
    local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.bgImg)
    boxItem.bg:LoadSprite(iconPath)
    local boxNum = boxItemServerData.target
    boxItem.targetNum:SetText(string.GetFormattedSeparatorNum(boxNum))
    boxItem.dimondTxt:SetText(string.GetFormattedSeparatorNum(boxItemServerData.value))
    if not isProgressSet and progressNum <= boxNum then
      isProgressSet = true
      progressLen = boxItemData.perPos + 1.0 * progressNum / boxNum * (boxItemData.valPos - boxItemData.perPos)
    end
  end
  local sizeDelta = self.scoreProgressVal.transform.sizeDelta
  self.scoreProgressVal.transform.sizeDelta = Vector2(progressLen, sizeDelta.y)
end

function PersonalArms:RefreshTaskView()
  self.taskListContent:SetAnchoredPositionXY(0, 0)
  self:RefreshTargetListView()
end

function PersonalArms:RefreshTimeView()
  if self.showData then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local leftTime = self.showData.stage_end_time - curTime
    if leftTime < 0 then
      leftTime = 0
      self:SendGetNewDataMsg()
    end
    self.timeText:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
    local curDayLeftTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if curDayLeftTime < 0 then
      curDayLeftTime = 0
    end
    self.emptyTxt1:SetText(UITimeManager:GetInstance():SecondToFmtString(curDayLeftTime))
  end
end

function PersonalArms:RefreshBoxRewards(openView)
  local param = {}
  param.showData = self.showData
  param.pos = self.btnDailyBox.transform.position
  if self.uIPersonalArmsDailyTip and self.dailyTip then
    self.dailyTip:SetData(param, openView)
  elseif not self.haveIt then
    self.haveIt = true
    self.uIPersonalArmsDailyTip = self:GameObjectInstantiateAsync(UIAssets.UIPersonalArmsDailyTip, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.dailyContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.dailyTip = self.dailyContent:AddComponent(uiPersonalArmsDailyTipComponent, go.name)
      self.dailyTip:SetData(param, openView)
    end)
  end
end

function PersonalArms:ClearBoxRewards()
  self.dailyContent:RemoveComponents(uiPersonalArmsDailyTipComponent)
  if self.uIPersonalArmsDailyTip ~= nil then
    self:GameObjectDestroy(self.uIPersonalArmsDailyTip)
    self.uIPersonalArmsDailyTip = nil
    self.dailyTip = nil
    self.haveIt = nil
  end
end

function PersonalArms:RefreshTargetListView()
  self:SetAllCellDestroy()
  self.model = {}
  local list = self.showData.scoresList
  if list ~= nil then
    local isFullProgress = self.showData and self.showData.sc >= self.showData.score_reward_max
    for i = 1, table.length(list) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.PersonalArmsTargetItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.taskListContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.taskListContent:AddComponent(UIPersonalArmsTargetItem, go.name)
        cell:RefreshData(list[i], not isFullProgress)
        cell:SetBg(i == table.length(list))
      end)
    end
  end
end

function PersonalArms:SetAllCellDestroy()
  self.taskListContent:RemoveComponents(UIPersonalArmsTargetItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.model = nil
  end
end

function PersonalArms:RefreshRankView()
  self.rankListContent:SetAnchoredPositionXY(0, 0)
  self:RefreshRankList()
end

function PersonalArms:RefreshRankList()
  self:SetAllRankCellDestroy()
  self.rankModel = {}
  local list = DataCenter.ActivityPersonalArmsDataManager:GetRankDataByActId(tostring(self.activityId))
  local maxScore = 1
  local rankList
  if list ~= nil then
    rankList = list.rankList
    maxScore = math.max(maxScore, list.maxScore)
    for i = 1, table.length(rankList) do
      self.rankModel[i] = self:GameObjectInstantiateAsync(UIAssets.PersonalArmsRankItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.rankListContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.rankListContent:AddComponent(UIPersonalArmsRankItem, go.name)
        local selfType = rankList[i].uid == LuaEntry.Player.uid
        cell:SetData(rankList[i], maxScore, self.activityId, selfType)
        if selfType and rankList[i].rank ~= 1 then
          self.selfRankItem:SetData(rankList[i], maxScore, self.activityId, selfType)
          self.selfRankItem:SetActive(true)
        elseif selfType then
          self.selfRankItem:SetActive(false)
        end
      end)
    end
  end
  if rankList ~= nil and #rankList ~= 0 then
    self.emptyContent:SetActive(false)
  else
    self.emptyContent:SetActive(true)
    local mainRangeStr = ""
    local selfMainLevel = DataCenter.BuildManager:GetMainLevel()
    local data = ""
    local temp = LocalController:instance():getLine(TableName.HERO_ACTIVITY, self.showData.heroActivityId)
    if temp then
      data = temp.ranksub
    end
    local arr = string.split(data, "|")
    for _, v in pairs(arr) do
      local rangeArr = string.split(v, "-")
      if #rangeArr == 2 then
        local rangeMin = tonumber(rangeArr[1])
        local rangeMax = tonumber(rangeArr[2])
        if selfMainLevel >= rangeMin and selfMainLevel <= rangeMax then
          mainRangeStr = v
          break
        end
      end
    end
    local player = LuaEntry.Player
    local showStr = ""
    if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
      showStr = Localization:GetString("armsRace_rank_err_01")
      self.emptyTxt1:SetActive(false)
    else
      showStr = Localization:GetString("activity_arms_race_tips01", mainRangeStr)
      self.emptyTxt1:SetActive(true)
    end
    self.emptyTxt2:SetText(showStr)
  end
end

function PersonalArms:SetAllRankCellDestroy()
  self.rankListContent:RemoveComponents(UIPersonalArmsRankItem)
  if self.rankModel ~= nil then
    for k, v in pairs(self.rankModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.rankModel = nil
  end
end

function PersonalArms:Update()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime > self.refreshTime then
    self.refreshTime = curTime
    self:RefreshTimeView()
    if curTime > self.emojiHideTime then
      self.emojiContent:SetActive(false)
    end
  end
end

function PersonalArms:SetData(activityId, actId)
  self.activityId = tonumber(activityId)
  if self.uIPersonalArmsDailyTip and self.dailyTip then
    self.dailyTip:SetData()
  end
  self:GetShowDataAndRefreshView()
  self:RefreshDailySliderView()
  self.emojiHideTime = 0
  self.emojiContent:SetActive(false)
  self:SendGetNewDataMsg()
  self.root:SetAnchoredPositionXY(0, 0)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData then
    self.comp_reward_change_entrance:ReInit(activityData, nil, true)
  end
  self:UpdateExchangeIcon()
  self:UpdateExchangeRed()
end

function PersonalArms:UpdateExchangeIcon()
  local calendarImg = "Assets/Main/Sprites/UI/UIPersonalArms/wxy_junbei_qiehuan2_btn.png"
  if DataCenter.ActivityPersonalArmsDataManager:GetLeftExchangeTimes(self.activityId) > 0 then
    calendarImg = "Assets/Main/Sprites/UI/UIPersonalArms/wxy_junbei_qiehuan_btn.png"
  end
  self.calender_icon:LoadSpriteAsync(calendarImg)
end

function PersonalArms:UpdateExchangeRed()
  self.p_go_calendar_red:SetActive(DataCenter.ActivityPersonalArmsDataManager:NeedExchangeGuide(self.activityId))
end

function PersonalArms:GetShowDataAndRefreshView(openView)
  self.showData = DataCenter.ActivityPersonalArmsDataManager:GetCurData(self.activityId)
  if self.showData then
    local eventId = self.showData.event_id
    self.heroEventCfg = LocalController:instance():getLine(TableName.HERO_EVENT, eventId)
    self:RefreshView()
    if tonumber(self.showData.resourceItemNum) == 0 and self.uIPersonalArmsDailyTip and self.dailyTip then
      self.dailyTip:SetData()
    end
  else
    self:RefreshNoDataView()
  end
end

function PersonalArms:OnDailyBoxClick(index)
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, index)
  if boxState == ActivityBoxState.CanOpen then
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroDayReward, toInt(self.activityId), index - 1)
  else
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.dailyBoxList[index].root:GetPosition()
    param.deltaX = -30
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    param.rewardList = self.showData.day_rewards[index].reward
    param.rewardMultiVal = MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

function PersonalArms:OnScoreBoxClick(index)
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetScoreBoxState(self.showData, index)
  self.scoreBoxIndex = nil
  self.pointNum = nil
  if boxState == ActivityBoxState.CanOpen then
    local badgeItemId = DataCenter.ActivityPersonalArmsDataManager:GetBadgeItemId(self.activityId)
    self.pointNum = DataCenter.ResourceItemDataManager:GetCountByItemId(badgeItemId)
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroScoreReward, toInt(self.activityId), index - 1)
    self.scoreBoxIndex = index
  else
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.scoreBoxList[index].root:GetPosition()
    if index == 1 or index == 2 then
      param.deltaX = 30
      if CommonUtil.IsArabicAutoMirrorOpen() and index == 1 then
        param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
      else
        param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
      end
    else
      param.deltaX = -30
      if CommonUtil.IsArabicAutoMirrorOpen() then
        param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
      else
        param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
      end
    end
    param.rewardList = self.showData.score_rewards[index].reward
    param.totalVal = self.showData.score_rewards[index].value
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

function PersonalArms:OnClickCalender()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsCalendarExchange, {anim = false}, self.activityId)
end

function PersonalArms:OnClickTip()
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = activityData.howtoplay
  param.story = activityData.story
  param.defaulfTitle = activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function PersonalArms:OnDataUpdate(activityId)
  if self.activityId == tonumber(activityId) then
    self:GetShowDataAndRefreshView()
    self:RefreshDailySliderView()
    self:UpdateExchangeIcon()
  end
end

function PersonalArms:OnScoreRewardGot()
  self.readyPlayAnimFlag = true
  self:GetShowDataAndRefreshView(true)
end

function PersonalArms:OnRankViewUpdate()
  if self.activityId == nil then
    return
  end
  self:RefreshRankView()
end

function PersonalArms:TryShowFirstRankEmoji()
  local list = DataCenter.ActivityPersonalArmsDataManager:GetRankDataByActId(tostring(self.activityId))
  if list ~= nil then
    local rankList = list.rankList
    local selfUid = LuaEntry.Player.uid
    if 0 < #rankList and rankList[1].uid ~= selfUid then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      self.emojiHideTime = curTime + 1
      self.emojiContent:SetActive(true)
      local randomNum = math.random(1, #self.emojiIdList)
      local emojiId = self.emojiIdList[randomNum]
      local lineData = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
      local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. lineData.path .. ".png"
      self.emoji1:LoadSprite(path)
      self.emoji2:LoadSprite(path)
      self.emoji3:LoadSprite(path)
    end
  end
end

function PersonalArms:SendGetNewDataMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityHeroGetInfo, toInt(self.activityId))
  SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, tostring(self.activityId), 1, 100, -1)
  SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, tostring(self.activityId), -1)
end

function PersonalArms:OnBtnRankReward()
  local rewardListData = DataCenter.ActivityPersonalArmsDataManager:GetRewardsDataByActId(tostring(self.activityId))
  if 0 < #rewardListData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, rewardListData)
  end
end

function PersonalArms:DoPointFly()
  if not self.readyPlayAnimFlag then
    return
  end
  if self.scoreBoxList == nil or self.scoreBoxIndex == nil then
    return
  end
  self.readyPlayAnimFlag = false
  local rewardPos = self.scoreBoxList[self.scoreBoxIndex].btnReward.transform.position
  self.scoreBoxIndex = nil
  local rewardType = RewardType.ArmsMedal
  local pic = DataCenter.RewardManager:GetPicByType(rewardType, nil)
  if not string_IsNullOrEmpty(pic) then
    local dstPos = self.btnDailyBox.transform.position
    local num = 1
    if self.pointNum then
      local badgeItemId = DataCenter.ActivityPersonalArmsDataManager:GetBadgeItemId(self.activityId)
      local curPointNum = DataCenter.ResourceItemDataManager:GetCountByItemId(badgeItemId)
      num = curPointNum - self.pointNum
    end
    UIUtil.DoFly(tonumber(rewardType), num, pic, rewardPos, dstPos, nil, nil, function()
      self:DoBoxScaleVX()
    end, nil, 1)
  end
end

function PersonalArms:OnBtnDailyBoxClick()
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, self.curShowIndex)
  if boxState == ActivityBoxState.CanOpen then
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroDayReward, toInt(self.activityId), self.curShowIndex - 1)
  else
    self:RefreshBoxRewards()
  end
end

function PersonalArms:SetDailyBoxCanOpenAnim(isShowAnim)
  if isShowAnim then
    self.dailyBoxAnimator.enabled = true
    self.dailyBoxAnimator:Play("V_ui_icon_rewards")
    self.effectBox.gameObject:SetActive(true)
  else
    self.dailyBoxAnimator.enabled = false
    self.btnDailyBox.transform.localScale = Vector3.one
    self.btnDailyBox.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.effectBox.gameObject:SetActive(false)
  end
end

function PersonalArms:DoBoxScaleVX()
  if not self.activeSelf then
    return
  end
  local isEnable = self.dailyBoxAnimator.enabled
  if not isEnable then
    self.dailyBoxAnimator.enabled = true
  end
  self.dailyBoxAnimator:Play("V_ui_youxiang_ck")
  self:RefreshBoxRewards(true)
  self:RefreshDailyView()
  self:StopTimer()
  self.boxVxTimer = TimerManager:GetInstance():DelayInvoke(function()
    if isEnable then
      self.dailyBoxAnimator:Play("V_ui_icon_rewards")
    else
      self:SetDailyBoxCanOpenAnim(false)
    end
  end, 1.3)
end

function PersonalArms:StopTimer()
  if self.boxVxTimer ~= nil then
    self.boxVxTimer:Stop()
    self.boxVxTimer = nil
  end
end

function PersonalArms:OnExchangeCallback()
  self:UpdateExchangeIcon()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPersonalArmsCalendarExchange) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsCalendarExchange)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPersonalArmsCalendarExchangeConfirmView) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsCalendarExchangeConfirmView)
  end
  self:SendGetNewDataMsg()
end

function PersonalArms:OnExchangeClicked()
  self:UpdateExchangeRed()
end

return PersonalArms
