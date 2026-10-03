local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local TreasureHuntActivityMain = BaseClass("TreasureHuntActivityMain", base)
local Localization = CS.GameEntry.Localization
local TreasureHuntItem = require("UI.UIActivityCenterTable.Component.TreasureHunt.TreasureHuntItem")
local TreasurehuntShowBox = require("UI.UIActivityCenterTable.Component.TreasureHunt.TreasurehuntShowBox")
local UITreasureHuntBigRewardSelectView = require("UI.UIActivityTreasureHunt.UITreasureHuntBigRewardSelect.View.UITreasureHuntBigRewardSelectView")
local UITreasureHuntTipsView = require("UI.UIActivityTreasureHunt.UITreasureHuntTips.View.UITreasureHuntTipsView")
local title_path = "Content/Top/title"
local info_btn_path = "Content/Top/InfoBtn"
local openTime_path = "Content/Top/TimeBg/openTime"
local resourceNum_path = "Content/Top/ResBar/root/resourceNum"
local resourceIcon_path = "Content/Top/ResBar/root/resourceIcon"
local addBtn_path = "Content/Top/ResBar/addBtn"
local btnGoal_path = "Content/Bottom/BtnGoal"
local goalText_path = "Content/Bottom/BtnGoal/GoalText"
local levelNum_path = "Content/Top/levelNum"
local activityFlagStr = "_DigActivityLevel"
local cardPosDataList = {
  {x = -266, y = 211},
  {x = -90, y = 211},
  {x = 90, y = 211},
  {x = 266, y = 211},
  {x = -266, y = 0},
  {x = -90, y = 0},
  {x = 90, y = 0},
  {x = 266, y = 0},
  {x = -266, y = -211},
  {x = -90, y = -211},
  {x = 90, y = -211},
  {x = 266, y = -211}
}
local cardNum = 12
local oneLevelSize = 25

function TreasureHuntActivityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TreasureHuntActivityMain:OnDestroy()
  self:CloseAutoDigTimer()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TreasureHuntActivityMain:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.btnGoal = self:AddComponent(UIButton, btnGoal_path)
  self.btnGoal:SetOnClick(function()
    self:OnGoalBtnClick()
  end)
  self.goalText = self:AddComponent(UIText, goalText_path)
  self.addBtn = self:AddComponent(UIButton, addBtn_path)
  self.addBtn:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.resourceNum = self:AddComponent(UIText, resourceNum_path)
  self.resourceIcon = self:AddComponent(UIImage, resourceIcon_path)
  self.openTime = self:AddComponent(UIText, openTime_path)
  self.cardPosList = {}
  for i = 1, cardNum do
    local cardPosItemName = string.format("Content/cardContent/cardPos%d", i)
    local cardPosItem = self:AddComponent(UIBaseContainer, cardPosItemName)
    cardPosItem.cardItem = cardPosItem:AddComponent(TreasureHuntItem, "UITreasureHuntActivityItem")
    table.insert(self.cardPosList, cardPosItem)
  end
  self.animN = self:AddComponent(UIAnimator, "")
  self.animN:Enable(false)
  self.levelNum = self:AddComponent(UIText, levelNum_path)
  self._extra_stage_txt = self:AddComponent(UIText, "Content/progress/ProgressText")
  self._extra_stage_content = self:AddComponent(UIBaseContainer, "Content/progress/StagesScroll/Viewport/Content")
  self._extra_stage_sliderBg = self:AddComponent(UIImage, "Content/progress/StagesScroll/Viewport/Content/Background")
  self._extra_stage_slider = self:AddComponent(UISlider, "Content/progress/StagesScroll/Viewport/Content/Background/Slider")
  self._extra_box_temp = self:AddComponent(UIBaseContainer, "Content/progress/Box")
  self._extra_box_container = self:AddComponent(UIBaseContainer, "Content/progress/StagesScroll/Viewport/Content/Boxes")
  self._extra_box_temp.gameObject:GameObjectCreatePool()
  self.listBox = {}
end

function TreasureHuntActivityMain:ComponentDestroy()
  self.title = nil
  self.info_btn = nil
  self.btnGoal = nil
  self.goalText = nil
  self.addBtn = nil
  self.resourceNum = nil
  self.resourceIcon = nil
  self.openTime = nil
  self.cardPosList = nil
  self.animN = nil
  self.levelNum = nil
  self._extra_box_container:RemoveComponents(TreasurehuntShowBox)
  self._extra_box_temp.gameObject:GameObjectRecycleAll()
  self._extra_stage_txt = nil
  self._extra_stage_content = nil
  self._extra_stage_sliderBg = nil
  self._extra_stage_slider = nil
  self._extra_box_temp = nil
  self._extra_box_container = nil
  self.listBox = nil
end

function TreasureHuntActivityMain:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.digInfo = nil
  self.cachePickaxCount = 0
  self.isLevelFinished = false
  self.autoDigList = {}
  self.autoDigIndex = -1
  self.autoDigSendMsgIndex = -1
  self.selectAuto = false
end

function TreasureHuntActivityMain:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.digInfo = nil
  self.cachePickaxCount = nil
  self.isLevelFinished = nil
  self.autoDigList = nil
  self.autoDigIndex = nil
  self.autoDigSendMsgIndex = nil
  self.selectAuto = nil
end

function TreasureHuntActivityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnDigOneBlockSucc, self.OnDigOneMsg)
  self:AddUIListener(EventId.OnDigActFinalResultUpdated, self.RefreshAll)
  self:AddUIListener(EventId.OnDigActivityInfoUpdated, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemNumView)
end

function TreasureHuntActivityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.OnDigOneBlockSucc, self.OnDigOneMsg)
  self:RemoveUIListener(EventId.OnDigActFinalResultUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.OnDigActivityInfoUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemNumView)
  base.OnRemoveListener(self)
end

function TreasureHuntActivityMain:SetBigrewardShowData()
  self.bigRewardList = {}
  local paramTempLsi = DataCenter.DigActivityManager:GetDigParamTemplateDic(self.activityId)
  for i = 1, #paramTempLsi do
    local paramData = paramTempLsi[i]
    if paramData.big_reward_Preview_Arr and #paramData.big_reward_Preview_Arr == 2 then
      local data = {
        level = paramData.level,
        big_reward_Preview = tonumber(paramData.big_reward_Preview_Arr[1]),
        count = tonumber(paramData.big_reward_Preview_Arr[2]),
        highlight_reward = paramData.highlight_reward
      }
      table.insert(self.bigRewardList, data)
    end
  end
  table.sort(self.bigRewardList, function(a, b)
    return a.level < b.level
  end)
end

function TreasureHuntActivityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.selectAuto = false
  self:SetBigrewardShowData()
  DataCenter.DigActivityManager:RequestDigInfo(self.activityId)
  self.activityState = TreasureHuntActivityState.OpenCard
  self:RefreshAll()
  self:RefreshLevelProgressViewBg()
end

function TreasureHuntActivityMain:UpdateInfoView()
  self.title:SetLocalText(self.activityInfo.activityName)
end

function TreasureHuntActivityMain:UpdateItemNumView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local pickaxId = DataCenter.DigActivityManager:GetPickaxId(self.activityId)
  if not pickaxId then
    return
  end
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(pickaxId)
  self.resourceIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
  self.resourceNum:SetText(curNum)
end

function TreasureHuntActivityMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.activityInfo.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.openTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.openTime:SetText("")
  end
end

function TreasureHuntActivityMain:RefreshCardView()
  for i = 1, #self.cardPosList do
    self.cardPosList[i]:SetActive(true)
    self.cardPosList[i]:SetAnchoredPositionXY(cardPosDataList[i].x, cardPosDataList[i].y)
    self.cardPosList[i]:SetEulerAnglesXYZ(0, 0, 0)
    self.cardPosList[i]:SetLocalScaleXYZ(1, 1, 1)
    self.cardPosList[i].cardItem:SetClickCallBack(function()
      self:OnCardItemClick(i)
    end)
    self.cardPosList[i].cardItem:SetCurState(self.activityState)
  end
  if self.activityState == TreasureHuntActivityState.SelectBigReward then
    local previewList = DataCenter.DigActivityManager:GetPreviewRewardsList(self.activityId, self.digInfo.finishedLv + 1)
    for i, v in ipairs(self.cardPosList) do
      if i <= #previewList then
        self.cardPosList[i].cardItem:SetActive(true)
        self.cardPosList[i].cardItem:ShowPreview(self.activityId, self.digInfo, i, previewList[i])
      else
        self.cardPosList[i].cardItem:SetActive(false)
      end
    end
  else
    for i, v in ipairs(self.cardPosList) do
      self.cardPosList[i].cardItem:ShowItem(self.activityId, self.digInfo, i)
    end
  end
end

function TreasureHuntActivityMain:RefreshBottomView()
  if self.activityState == TreasureHuntActivityState.SelectBigReward then
    self.btnGoal:SetActive(true)
    self.goalText:SetLocalText(2000641)
  elseif self.activityState == TreasureHuntActivityState.OpenCard then
    self.btnGoal:SetActive(true)
    self.goalText:SetLocalText("2000825")
  elseif self.activityState == TreasureHuntActivityState.AutoOpen then
    self.btnGoal:SetActive(true)
    self.goalText:SetLocalText("digactivity_button001")
  else
    self.btnGoal:SetActive(false)
  end
  local maxLevel = DataCenter.DigActivityManager:GetMaxLvCount(self.activityId)
  local curLevel = self.digInfo.finishedLv + 1
  local isMaxLevel = self:CheckIfIsMaxLv()
  if isMaxLevel then
    self.levelNum:SetLocalText(2000808)
  else
    self.levelNum:SetLocalText(2000806, curLevel, maxLevel)
  end
end

function TreasureHuntActivityMain:RefreshLevelProgressViewBg()
  local maxLevel = DataCenter.DigActivityManager:GetMaxLvCount(self.activityId)
  local curLevel = self.digInfo.finishedLv + 1
  local sliderWidth = maxLevel * oneLevelSize
  local contentWidth = sliderWidth + 80
  self._extra_stage_sliderBg.transform:Set_sizeDelta(sliderWidth, 25)
  self._extra_stage_content.transform:Set_sizeDelta(contentWidth, 0)
  local sliderShowWidth = 620
  local posX = -1 * curLevel / maxLevel * (contentWidth - sliderShowWidth)
  self._extra_stage_content:SetAnchoredPositionXY(posX, 0)
end

function TreasureHuntActivityMain:RefreshLevelProgressViewByCurLevel()
  local maxLevel = DataCenter.DigActivityManager:GetMaxLvCount(self.activityId)
  local curLevel = self.digInfo.finishedLv + 1
  if maxLevel < curLevel then
    curLevel = maxLevel
  end
  self._extra_stage_txt:SetText(string.format("<size=48>%d</size>/%d", curLevel, maxLevel))
  local progress = 1
  if 0 < maxLevel then
    progress = curLevel / maxLevel
  end
  self._extra_stage_slider:SetValue(progress)
  local count = #self.bigRewardList
  if #self.listBox == 0 then
    for i = 1, count do
      local item = self._extra_box_temp.gameObject:GameObjectSpawn(self._extra_box_container.transform)
      item.name = "item" .. i
      local obj = self._extra_box_container:AddComponent(TreasurehuntShowBox, item.name)
      obj:SetActive(true)
      obj:SetAnchoredPositionXY(self.bigRewardList[i].level * oneLevelSize, -13)
      self.listBox[i] = obj
      self.listBox[i]:SetData(self.bigRewardList[i], self.digInfo)
    end
  end
  for i = 1, count do
    self.listBox[i]:SetData(self.bigRewardList[i], self.digInfo)
  end
end

function TreasureHuntActivityMain:RefreshAll()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  self.digInfo = DataCenter.DigActivityManager:GetDigInfo(self.activityId)
  if not self.digInfo then
    return
  end
  self:CloseAutoDigTimer()
  self:RefreshCurState()
  self:TryAutoDo()
  self:UpdateInfoView()
  self:UpdateItemNumView()
  self:RefreshCardView()
  self:RefreshBottomView()
  self:RefreshLevelProgressViewByCurLevel()
  self:Update1000MS()
end

function TreasureHuntActivityMain:UpdateData()
  self:RefreshAll()
end

function TreasureHuntActivityMain.GetEventCanRewardCount()
  return 0
end

function TreasureHuntActivityMain:RefreshCurState()
  self.isDigStarted = self:CheckIfStarted()
  self.isMaxLevel = self:CheckIfIsMaxLv()
  if not self.isDigStarted then
    self.activityState = TreasureHuntActivityState.SelectBigReward
  elseif self.isMaxLevel then
    self.activityState = TreasureHuntActivityState.MaxLevelFin
  else
    self.activityState = TreasureHuntActivityState.OpenCard
  end
end

function TreasureHuntActivityMain:TryAutoDo()
  if self.selectAuto == false then
    return
  end
  if self.activityState == TreasureHuntActivityState.SelectBigReward then
    if self.digInfo.finalRewardIndex == 0 then
      self.selectAuto = false
    else
      self:OnGoalBtnClick()
    end
  elseif self.activityState == TreasureHuntActivityState.OpenCard then
    self:OnGoalBtnClick()
  end
end

function TreasureHuntActivityMain:CheckIfStarted()
  if self.digInfo.finalRewardIndex == 0 then
    return false
  else
    local isMaxLevel = self:CheckIfIsMaxLv()
    if isMaxLevel then
      return true
    else
      local digNum = table.count(self.digInfo.digRecordDic)
      local strK = LuaEntry.Player.uid .. activityFlagStr .. self.activityId
      local cacheLv = Setting:GetInt(strK, 0)
      if cacheLv ~= self.digInfo.finishedLv + 1 and digNum == 0 then
        return false
      else
        return true
      end
    end
  end
end

function TreasureHuntActivityMain:CheckIfIsMaxLv(level)
  level = level or self.digInfo.finishedLv
  local maxLvCount = DataCenter.DigActivityManager:GetMaxLvCount(self.activityId)
  return level >= maxLvCount
end

function TreasureHuntActivityMain:IsHaveGetFinalReward()
  return false
end

function TreasureHuntActivityMain:OnCardItemClick(index)
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if not self.digInfo then
    return
  end
  if self.activityState == TreasureHuntActivityState.SelectBigReward then
    if index == 1 then
      local tempIndex, isSuperLv = DataCenter.DigActivityManager:GetSelectedFinalRewardInfo(self.activityId, self.digInfo.finishedLv + 1)
      self.curSelectedIndex = tempIndex
      self.targetRewardType = isSuperLv and RewardType.SuperReward or RewardType.NormalReward
      self.normalFinalRewards, self.superFinalRewards = DataCenter.DigActivityManager:GetFinalRewards(self.activityId, self.digInfo.finishedLv + 1)
      self.curRewardsList = self.normalFinalRewards
      local param = UITreasureHuntBigRewardSelectView.ParamDataClass.New()
      param.position = self.cardPosList[1]:GetPosition()
      param.deltaY = 30
      param.rewardList = self.curRewardsList
      param.selectIndex = self.curSelectedIndex
      param.activityId = self.activityId
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntBigRewardSelect, {anim = false}, param)
    elseif self.cardPosList[index].cardItem.digReward then
      local reward = self.cardPosList[index].cardItem.digReward
      local param = {}
      param.itemId = reward.itemId
      param.alignObject = self.cardPosList[index].cardItem
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.activityState == TreasureHuntActivityState.OpenCard then
    if not self.cardPosList[index].cardItem.digReward then
      local pickaxId = DataCenter.DigActivityManager:GetPickaxId(self.activityId)
      local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
      if 0 < curNum then
        DataCenter.DigActivityManager:RequestDigOneBlock(self.activityId, index)
      else
        UIUtil.ShowTipsId(120021)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntShop, {anim = true}, self.activityId, tonumber(self.digInfo.exchange), pickaxId)
      end
    else
      local reward = self.cardPosList[index].cardItem.digReward
      local param = {}
      param.itemId = reward.itemId
      param.alignObject = self.cardPosList[index].cardItem
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.activityState == TreasureHuntActivityState.OpenCardGetBigReward then
  elseif self.activityState == TreasureHuntActivityState.MaxLevelFin then
    UIUtil.ShowTipsId("2000807")
  end
end

function TreasureHuntActivityMain:OnGoalBtnClick()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if not self.digInfo then
    return
  end
  if self.activityState == TreasureHuntActivityState.SelectBigReward then
    if self.digInfo.finalRewardIndex == 0 then
    else
      local strK = LuaEntry.Player.uid .. activityFlagStr .. self.activityId
      Setting:SetInt(strK, self.digInfo.finishedLv + 1)
      self:PlayOpenSeq()
    end
  elseif self.activityState == TreasureHuntActivityState.OpenCard then
    self.selectAuto = true
    self:StartAutoDig()
    self:RefreshBottomView()
  elseif self.activityState == TreasureHuntActivityState.AutoOpen then
    self.selectAuto = false
    self:CloseAutoDigTimer()
    if self.activityState == TreasureHuntActivityState.AutoOpen then
      self.activityState = TreasureHuntActivityState.OpenCard
    end
    self:RefreshBottomView()
  elseif self.activityState == TreasureHuntActivityState.OpenCardGetBigReward then
    self.selectAuto = false
  end
end

function TreasureHuntActivityMain:StartAutoDig()
  if self.activityState ~= TreasureHuntActivityState.OpenCard then
    return
  end
  self.activityState = TreasureHuntActivityState.AutoOpen
  self.autoDigList = {}
  self.autoDigIndex = 1
  self.autoDigSendMsgIndex = -1
  for i = 1, cardNum do
    local curLevel = self.digInfo.finishedLv + 1
    local rewardIndex = DataCenter.DigActivityManager:GetDiggedOutRewardIndex(self.activityId, curLevel, i)
    if rewardIndex <= 0 then
      table.insert(self.autoDigList, i)
    end
  end
  local listSize = #self.autoDigList
  if listSize == 0 then
    return
  end
  for i = 1, listSize do
    local randomNum = math.random(i, listSize)
    if i < randomNum then
      self.autoDigList[i], self.autoDigList[randomNum] = self.autoDigList[randomNum], self.autoDigList[i]
    end
  end
  self:StartAutoDigTimer()
end

function TreasureHuntActivityMain:CloseAutoDigTimer()
  if self.autoDigTimer ~= nil then
    self.autoDigTimer:Stop()
    self.autoDigTimer = nil
  end
end

function TreasureHuntActivityMain:StartAutoDigTimer()
  self:CloseAutoDigTimer()
  self.autoDigTimer = TimerManager:GetInstance():GetTimer(0.15, self.AutoDigTimeFunc, self, false, false, false)
  self.autoDigTimer:Start()
end

function TreasureHuntActivityMain:AutoDigTimeFunc()
  if self.activityState ~= TreasureHuntActivityState.AutoOpen then
    return
  end
  local curTargetindex = self.autoDigList[self.autoDigIndex]
  if curTargetindex == nil then
    self:RefreshAll()
  else
    local curLevel = self.digInfo.finishedLv + 1
    local rewardIndex = DataCenter.DigActivityManager:GetDiggedOutRewardIndex(self.activityId, curLevel, curTargetindex)
    if 0 < rewardIndex then
      self.autoDigIndex = self.autoDigIndex + 1
    else
      if self.autoDigSendMsgIndex ~= self.autoDigIndex then
        self.autoDigSendMsgIndex = self.autoDigIndex
        local pickaxId = DataCenter.DigActivityManager:GetPickaxId(self.activityId)
        local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
        if 0 < curNum then
          DataCenter.DigActivityManager:RequestDigOneBlock(self.activityId, curTargetindex)
        else
          self.selectAuto = false
          UIUtil.ShowTipsId(120021)
          self:RefreshAll()
        end
      else
      end
    end
  end
end

function TreasureHuntActivityMain:OnDigOneMsg(data)
  local isFinalReward = data.rewardIndex == 0
  local blockIndex = data.blockIndex
  if isFinalReward then
    self.activityState = TreasureHuntActivityState.OpenCardGetBigReward
    self.cardPosList[blockIndex].cardItem:ShowItem(self.activityId, self.digInfo, blockIndex)
    self.cardPosList[blockIndex].cardItem:SetCoverView()
    self.cardPosList[blockIndex].cardItem:PlayOpenAni()
    UIUtil.ShowTipsId(2000660)
    self:CloseAutoDigTimer()
    self:PlayNextLevelSeq()
  else
    self.cardPosList[blockIndex].cardItem:ShowItem(self.activityId, self.digInfo, blockIndex)
    self.cardPosList[blockIndex].cardItem:SetCoverView()
    self.cardPosList[blockIndex].cardItem:PlayOpenAni()
  end
  local reward = DataCenter.DigActivityManager:GetDiggedOutReward(self.digInfo.activityId, self.digInfo.finishedLv + 1, blockIndex)
  local count = reward.count
  if 10 < count then
    count = 10
  end
  local pos = self.cardPosList[blockIndex].transform.position
  UIUtil.DoFly(RewardType.GOODS, count, DataCenter.ItemTemplateManager:GetIconPath(reward.itemId), pos, Vector3.New(0, 0, 0))
end

function TreasureHuntActivityMain:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function TreasureHuntActivityMain:PlayOpenSeq()
  self:CloseAniSeq()
  self.activityState = TreasureHuntActivityState.RefreshAni
  self:RefreshBottomView()
  local coverTime = 0.6
  local refreshTime = 2.2
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendCallback(function()
    for i = 1, #self.cardPosList do
      self.cardPosList[i].cardItem:PlayCoverAniSeq()
    end
  end)
  self.aniSeq:AppendInterval(coverTime)
  self.aniSeq:AppendCallback(function()
    self.animN:Enable(false)
    self:RefreshCurState()
    self:TryAutoDo()
    self:RefreshCardView()
    self:RefreshBottomView()
    self:RefreshLevelProgressViewByCurLevel()
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

function TreasureHuntActivityMain:PlayNextLevelSeq()
  self:CloseAniSeq()
  local delayTime = 2
  local coverTime = 0.6
  local refreshTime = 2.2
  local fankaTime = 1
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendInterval(delayTime)
  self.aniSeq:AppendCallback(function()
    for i = 1, #self.cardPosList do
      if self.cardPosList[i].cardItem.digReward then
        self.cardPosList[i].cardItem:PlayCoverAniSeq()
      end
    end
  end)
  self.aniSeq:AppendInterval(coverTime)
  self.aniSeq:AppendCallback(function()
    DataCenter.DigActivityManager:RequestDigInfo(self.activityId)
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

function TreasureHuntActivityMain:OnHelpBtnClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function TreasureHuntActivityMain:OnGotoBtnClick()
  if self.digInfo ~= nil then
    local pickaxId = DataCenter.DigActivityManager:GetPickaxId(self.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntShop, {anim = true}, self.activityId, tonumber(self.digInfo.exchange), pickaxId)
  end
end

return TreasureHuntActivityMain
