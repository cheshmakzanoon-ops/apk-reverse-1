local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActivityTreasureHuntNewMainComponent = BaseClass("ActivityTreasureHuntNewMainComponent", base)
local Localization = CS.GameEntry.Localization
local TreasureHuntItem = require("UI/UIActivityCenterTable/Component/TreasureHuntNew/ActivityTreasureHuntNewItemComponent")
local TreasurehuntShowBox = require("UI/UIActivityCenterTable/Component/TreasureHuntNew/ActivityTreasureHuntNewShowBoxComponent")
local UITreasureHuntBigRewardSelectView = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewBigRewardSelect/View/UITreasureHuntNewBigRewardSelectView")
local UITreasureHuntTipsView = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewTips/View/UITreasureHuntNewTipsView")
local title_path = "Content/Top/title"
local info_btn_path = "Content/Top/InfoBtn"
local openTime_path = "Content/Top/TimeBg/openTime"
local resourceNum_path = "Content/Top/ResBar/root/resourceNum"
local resourceIcon_path = "Content/Top/ResBar/root/resourceIcon"
local addBtn_path = "Content/Top/ResBar/addBtn"
local btnGoal_path = "Content/Bottom/BtnGoal"
local goalText_path = "Content/Bottom/BtnGoal/GoalText"
local levelNum_path = "Content/Top/levelNum"
local activityFlagStr = "_TreasureHuntNewActivityLevel"
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
local oneLevelSize = 125

function ActivityTreasureHuntNewMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityTreasureHuntNewMainComponent:OnDestroy()
  self:CloseAutoDigTimer()
  self:CloseFlyTimer()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityTreasureHuntNewMainComponent:OnEnable()
  base.OnEnable(self)
end

function ActivityTreasureHuntNewMainComponent:OnDisable()
  base.OnDisable(self)
end

function ActivityTreasureHuntNewMainComponent:ComponentDefine()
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
  self._extra_stage_viewport = self:AddComponent(UIBaseContainer, "Content/progress/StagesScroll/Viewport")
  self._extra_stage_content = self:AddComponent(UIBaseContainer, "Content/progress/StagesScroll/Viewport/Content")
  self._extra_stage_sliderBg = self:AddComponent(UIImage, "Content/progress/StagesScroll/Viewport/Content/Background")
  self._extra_stage_slider = self:AddComponent(UISlider, "Content/progress/StagesScroll/Viewport/Content/Background/Slider")
  self._extra_box_temp = self:AddComponent(UIBaseContainer, "Content/progress/Box")
  self._extra_box_container = self:AddComponent(UIBaseContainer, "Content/progress/StagesScroll/Viewport/Content/Boxes")
  self._extra_box_temp.gameObject:GameObjectCreatePool()
  self.listBox = {}
  self.btnStoredReward = self:AddComponent(UIButton, "Content/StoredReward")
  self.btnStoredReward:SetOnClick(function()
    self:OnStoredRewardClick()
  end)
  self.textStoredReward = self:AddComponent(UIText, "Content/StoredReward/StoredRewardText")
  self.objStoredRewardIcon = self:AddComponent(UIBaseContainer, "Content/StoredReward/StoredRewardBoxIcon")
  self.animStoredReward = self:AddComponent(UIAnimator, "Content/StoredReward")
  self.animStoredRewardGun = self:AddComponent(UIAnimator, "Content/StoredReward/StoredRewardBoxIcon/StoredRewardGun")
  self.objVfxStoredRewardAdd = self:AddComponent(UIBaseContainer, "Content/StoredReward/StoredRewardBoxIcon/VfxAddReward")
  self.objVfxStoredRewardCanClaim = self:AddComponent(UIBaseContainer, "Content/StoredReward/StoredRewardBoxIcon/StoredRewardGun/VfxCanClaimReward")
  self.objStoredRewardRedPoint = self:AddComponent(UIBaseContainer, "Content/StoredReward/RedPoint")
end

function ActivityTreasureHuntNewMainComponent:ComponentDestroy()
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
  self.objStoredRewardIcon = nil
  self.animStoredReward = nil
  self.animStoredRewardGun = nil
  self.objVfxStoredRewardAdd = nil
  self.objVfxStoredRewardCanClaim = nil
end

function ActivityTreasureHuntNewMainComponent:DataDefine()
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

function ActivityTreasureHuntNewMainComponent:DataDestroy()
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

function ActivityTreasureHuntNewMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTreasureHuntNewDigOneBlockSuccess, self.OnDigOneMsg)
  self:AddUIListener(EventId.ActivityTreasureHuntNewFinalResultUpdated, self.RefreshAll)
  self:AddUIListener(EventId.ActivityTreasureHuntNewActivityInfoUpdated, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemNumView)
  self:AddUIListener(EventId.ActivityTreasureHuntNewDigBatchBlockSuccess, self.OnDigBatchMsg)
  self:AddUIListener(EventId.ActivityTreasureHuntNewDigBatchBlockFail, self.OnDigBatchMsgFail)
end

function ActivityTreasureHuntNewMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewDigOneBlockSuccess, self.OnDigOneMsg)
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewFinalResultUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewActivityInfoUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemNumView)
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewDigBatchBlockSuccess, self.OnDigBatchMsg)
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewDigBatchBlockFail, self.OnDigBatchMsgFail)
  base.OnRemoveListener(self)
end

function ActivityTreasureHuntNewMainComponent:SetBigrewardShowData()
  local allHighlightLevelData = {}
  local paramTempLsi = DataCenter.ActivityTreasureHuntNewManager:GetDigParamTemplateDic(self.activityId)
  for i = 1, #paramTempLsi do
    local paramData = paramTempLsi[i]
    if paramData and checknumber(paramData.highlight_reward) == 1 then
      table.insert(allHighlightLevelData, {
        level = paramData.level
      })
    end
  end
  
  local function IsHighlightRewardLevel(level)
    local allLevels = allHighlightLevelData
    for _, v in pairs(allLevels) do
      if v.level == level then
        return true
      end
    end
    return false
  end
  
  self.bigRewardList = {}
  local template = DataCenter.ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(self.activityId)
  if template ~= nil and not table.IsNullOrEmpty(template.bigRewardPreviewDict) then
    for i = 1, #template.bigRewardPreviewDict do
      local bigRewardData = template.bigRewardPreviewDict[i]
      if not table.IsNullOrEmpty(bigRewardData) then
        local data = {
          level = bigRewardData.level,
          big_reward_Preview = checknumber(bigRewardData.itemId),
          count = checknumber(bigRewardData.itemCount),
          highlight_reward = IsHighlightRewardLevel(bigRewardData.level)
        }
        table.insert(self.bigRewardList, data)
      end
    end
  end
  table.sort(self.bigRewardList, function(a, b)
    return a.level < b.level
  end)
end

function ActivityTreasureHuntNewMainComponent:SetData(activityId)
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
  DataCenter.ActivityTreasureHuntNewManager:RequestDigInfo(self.activityId)
  self.activityState = TreasureHuntNewActivityState.OpenCard
  self:RefreshAll()
  self:RefreshLevelProgressViewBg()
end

function ActivityTreasureHuntNewMainComponent:UpdateInfoView()
  self.title:SetLocalText(self.activityInfo.activityName)
end

function ActivityTreasureHuntNewMainComponent:UpdateItemNumView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
  if not pickaxId then
    return
  end
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(pickaxId)
  self.resourceIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
  self.resourceNum:SetText(curNum)
end

function ActivityTreasureHuntNewMainComponent:Update1000MS()
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

function ActivityTreasureHuntNewMainComponent:RefreshCardView()
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
  if self.activityState == TreasureHuntNewActivityState.SelectBigReward then
    local previewList = DataCenter.ActivityTreasureHuntNewManager:GetPreviewRewardsList(self.activityId, self.digInfo.finishedLv + 1)
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

function ActivityTreasureHuntNewMainComponent:RefreshBottomView()
  if self.activityState == TreasureHuntNewActivityState.SelectBigReward then
    local hasSelectFinal = false
    if self.digInfo ~= nil and self.digInfo.finalRewardIndex > 0 then
      hasSelectFinal = true
    end
    self.btnGoal:SetActive(hasSelectFinal)
    self.goalText:SetLocalText(2000641)
  elseif self.activityState == TreasureHuntNewActivityState.OpenCard then
    self.btnGoal:SetActive(true)
    self.goalText:SetLocalText("2000825")
  elseif self.activityState == TreasureHuntNewActivityState.AutoOpen then
    self.btnGoal:SetActive(true)
    self.goalText:SetLocalText("digactivity_button001")
  else
    self.btnGoal:SetActive(false)
  end
  local maxLevel = DataCenter.ActivityTreasureHuntNewManager:GetMaxLvCount(self.activityId)
  local curLevel = self.digInfo.finishedLv + 1
  local isMaxLevel = self:CheckIfIsMaxLv()
  if isMaxLevel then
    self.levelNum:SetLocalText(2000808)
  else
    self.levelNum:SetLocalText(2000806, curLevel, maxLevel)
  end
end

function ActivityTreasureHuntNewMainComponent:RefreshLevelProgressViewBg()
  local maxProgressLv = 0
  local bigRewardCount = 0
  if not table.IsNullOrEmpty(self.bigRewardList) then
    for _, v in pairs(self.bigRewardList) do
      if maxProgressLv < v.level then
        maxProgressLv = v.level
      end
      bigRewardCount = bigRewardCount + 1
    end
  end
  local curLevel = self.digInfo.finishedLv + 1
  local sliderWidth = bigRewardCount * oneLevelSize
  local contentWidth = sliderWidth + 80
  self._extra_stage_sliderBg.transform:Set_sizeDelta(sliderWidth, 25)
  self._extra_stage_content.transform:Set_sizeDelta(contentWidth, 0)
  self.progressContentWidth = contentWidth
end

function ActivityTreasureHuntNewMainComponent:UpdateProgressBoxFocusPosition()
  local function GetLastReachedBigRewardLevel()
    local res = 0
    
    if self.digInfo ~= nil then
      local curLevel = self.digInfo.finishedLv + 1
      if not table.IsNullOrEmpty(self.bigRewardList) then
        for i, v in ipairs(self.bigRewardList) do
          if curLevel < v.level then
            break
          end
          res = v.level
        end
      end
    end
    return res
  end
  
  local function GetRewardIndexByLevel(level)
    local res = 0
    if not table.IsNullOrEmpty(self.bigRewardList) then
      for i, v in ipairs(self.bigRewardList) do
        if v.level == level then
          res = i
          break
        end
      end
    end
    return res
  end
  
  if self.progressContentWidth == nil then
    return
  end
  local posX = 0
  local lastReachedRewardLevel = GetLastReachedBigRewardLevel()
  if 0 < lastReachedRewardLevel then
    local focusIndex = GetRewardIndexByLevel(lastReachedRewardLevel) - 1
    if 0 <= focusIndex then
      posX = -1 * focusIndex * oneLevelSize - 62.5
    end
  end
  local viewportWidth = self._extra_stage_viewport.transform.rect.width
  local minPos = viewportWidth - self.progressContentWidth
  if posX < minPos then
    posX = minPos
  end
  self._extra_stage_content:SetAnchoredPositionXY(posX, 0)
end

function ActivityTreasureHuntNewMainComponent:RefreshLevelProgressViewByCurLevel()
  local function GetProgressFillAmount()
    local res = 0
    
    if self.digInfo ~= nil and not table.IsNullOrEmpty(self.bigRewardList) then
      local curLevel = self.digInfo.finishedLv + 1
      local totalCount = #self.bigRewardList
      local maxLevel = 0
      local reachedIndex = 0
      local reachedLevel = 0
      for i, v in ipairs(self.bigRewardList) do
        if curLevel >= v.level then
          reachedIndex = i
          reachedLevel = v.level
        end
        if maxLevel < v.level then
          maxLevel = v.level
        end
      end
      if curLevel >= maxLevel then
        res = 1
      else
        local nextIndex = reachedIndex + 1
        if self.bigRewardList[nextIndex] ~= nil then
          local nextLevel = self.bigRewardList[nextIndex].level
          res = reachedIndex / totalCount + (curLevel - reachedLevel) / (nextLevel - reachedLevel) * 1 / totalCount
        end
      end
    end
    return res
  end
  
  local maxProgressLv = DataCenter.ActivityTreasureHuntNewManager:GetMaxLvCount(self.activityId)
  local curLevel = self.digInfo.finishedLv + 1
  if maxProgressLv < curLevel then
    curLevel = maxProgressLv
  end
  self._extra_stage_txt:SetText(string.format("<size=48>%d</size>/%d", curLevel, maxProgressLv))
  local progress = GetProgressFillAmount()
  self._extra_stage_slider:SetValue(progress)
  local count = #self.bigRewardList
  if #self.listBox == 0 then
    for i = 1, count do
      local item = self._extra_box_temp.gameObject:GameObjectSpawn(self._extra_box_container.transform)
      item.name = "item" .. i
      local obj = self._extra_box_container:AddComponent(TreasurehuntShowBox, item.name)
      obj:SetActive(true)
      obj:SetAnchoredPositionXY(i * oneLevelSize, -13)
      self.listBox[i] = obj
      self.listBox[i]:SetData(self.bigRewardList[i], self.digInfo)
    end
  end
  for i = 1, count do
    self.listBox[i]:SetData(self.bigRewardList[i], self.digInfo)
  end
  self:UpdateStoredReward()
end

function ActivityTreasureHuntNewMainComponent:RefreshAll()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  self.digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(self.activityId)
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
  self:UpdateProgressBoxFocusPosition()
  self:Update1000MS()
  self:UpdateStoredRewardRed()
end

function ActivityTreasureHuntNewMainComponent:UpdateData()
  self:RefreshAll()
end

function ActivityTreasureHuntNewMainComponent.GetEventCanRewardCount()
  return 0
end

function ActivityTreasureHuntNewMainComponent:RefreshCurState()
  self.isDigStarted = self:CheckIfStarted()
  self.isMaxLevel = self:CheckIfIsMaxLv()
  if not self.isDigStarted then
    self.activityState = TreasureHuntNewActivityState.SelectBigReward
  elseif self.isMaxLevel then
    self.activityState = TreasureHuntNewActivityState.MaxLevelFin
  else
    self.activityState = TreasureHuntNewActivityState.OpenCard
  end
end

function ActivityTreasureHuntNewMainComponent:TryAutoDo()
  if not self.selectAuto then
    return
  end
  
  local function StopAutoDig()
    self.selectAuto = false
    self:CloseAutoDigTimer()
    if self.activityState == TreasureHuntNewActivityState.AutoOpen then
      self.activityState = TreasureHuntNewActivityState.OpenCard
      self:RefreshBottomView()
    end
  end
  
  local UIActivityDetailPopupWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIActivityDetailPopup)
  if UIActivityDetailPopupWindow then
    StopAutoDig()
    return
  end
  local UITreasureHuntNewShop = UIManager:GetInstance():GetWindow(UIWindowNames.UITreasureHuntNewShop)
  if UITreasureHuntNewShop then
    StopAutoDig()
    return
  end
  local UITreasureHuntNewHistory = UIManager:GetInstance():GetWindow(UIWindowNames.UITreasureHuntNewHistory)
  if UITreasureHuntNewHistory then
    StopAutoDig()
    return
  end
  if self.activityState == TreasureHuntNewActivityState.SelectBigReward then
    local stopLevel = DataCenter.ActivityTreasureHuntNewManager:GetStopLevel(self.activityId)
    local curLevel = self.digInfo.finishedLv + 1
    if self.digInfo.finalRewardIndex == 0 then
      self.selectAuto = false
    elseif 0 < stopLevel and curLevel == stopLevel then
      self.selectAuto = false
      local selfComp = self
      UIUtil.ShowNoToggleSecondMessage(Localization:GetString("activity_dig_auto_notice_title_1"), Localization:GetString("activity_dig_auto_notice_desc_1", stopLevel), 2, "400027", "digactivity_button001", function()
        if selfComp then
          selfComp.selectAuto = true
          selfComp:OnGoalBtnClick()
        end
      end, function(needSellConfirm)
      end, function()
      end, nil, "tongyong_cfm_anniu_5|tongyong_cfm_anniu_5", nil, nil, nil, nil, false)
    else
      self:OnGoalBtnClick()
    end
  elseif self.activityState == TreasureHuntNewActivityState.OpenCard then
    self:OnGoalBtnClick()
  end
end

function ActivityTreasureHuntNewMainComponent:CheckIfStarted()
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

function ActivityTreasureHuntNewMainComponent:CheckIfIsMaxLv(level)
  level = level or self.digInfo.finishedLv
  local maxLvCount = DataCenter.ActivityTreasureHuntNewManager:GetMaxLvCount(self.activityId)
  return level >= maxLvCount
end

function ActivityTreasureHuntNewMainComponent:IsHaveGetFinalReward()
  return false
end

function ActivityTreasureHuntNewMainComponent:OnCardItemClick(index)
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if not self.digInfo then
    return
  end
  if self.activityState == TreasureHuntNewActivityState.SelectBigReward then
    if index == 1 then
      local tempIndex, isSuperLv = DataCenter.ActivityTreasureHuntNewManager:GetSelectedFinalRewardInfo(self.activityId, self.digInfo.finishedLv + 1)
      self.curSelectedIndex = tempIndex
      self.targetRewardType = isSuperLv and RewardType.SuperReward or RewardType.NormalReward
      self.normalFinalRewards, self.superFinalRewards = DataCenter.ActivityTreasureHuntNewManager:GetFinalRewards(self.activityId, self.digInfo.finishedLv + 1)
      self.curRewardsList = self.normalFinalRewards
      local param = UITreasureHuntBigRewardSelectView.ParamDataClass.New()
      param.position = self.cardPosList[1]:GetPosition()
      param.deltaY = 30
      param.rewardList = self.curRewardsList
      param.selectIndex = self.curSelectedIndex
      param.activityId = self.activityId
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntNewBigRewardSelect, {anim = false}, param)
    elseif self.cardPosList[index].cardItem.digReward then
      local reward = self.cardPosList[index].cardItem.digReward
      local param = {}
      param.itemId = reward.itemId
      param.alignObject = self.cardPosList[index].cardItem
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.activityState == TreasureHuntNewActivityState.OpenCard then
    if not self.cardPosList[index].cardItem.digReward then
      local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
      local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
      if 0 < curNum then
        DataCenter.ActivityTreasureHuntNewManager:RequestDigOneBlock(self.activityId, index)
      else
        UIUtil.ShowTipsId(120021)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntNewShop, {anim = true}, self.activityId, tonumber(self.digInfo.exchange), pickaxId)
      end
    else
      local reward = self.cardPosList[index].cardItem.digReward
      local param = {}
      param.itemId = reward.itemId
      param.alignObject = self.cardPosList[index].cardItem
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.activityState == TreasureHuntNewActivityState.OpenCardGetBigReward then
  elseif self.activityState == TreasureHuntNewActivityState.MaxLevelFin then
    UIUtil.ShowTipsId("2000807")
  end
end

function ActivityTreasureHuntNewMainComponent:OnGoalBtnClick()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if not self.digInfo then
    return
  end
  if self.activityState == TreasureHuntNewActivityState.SelectBigReward then
    if self.digInfo.finalRewardIndex == 0 then
    else
      local strK = LuaEntry.Player.uid .. activityFlagStr .. self.activityId
      Setting:SetInt(strK, self.digInfo.finishedLv + 1)
      self:PlayOpenSeq()
    end
  elseif self.activityState == TreasureHuntNewActivityState.OpenCard then
    self.selectAuto = true
    self:StartAutoDig()
    self:RefreshBottomView()
  elseif self.activityState == TreasureHuntNewActivityState.AutoOpen then
    self.selectAuto = false
    self:CloseAutoDigTimer()
    if self.activityState == TreasureHuntNewActivityState.AutoOpen then
      self.activityState = TreasureHuntNewActivityState.OpenCard
    end
    self:RefreshBottomView()
  elseif self.activityState == TreasureHuntNewActivityState.OpenCardGetBigReward then
    self.selectAuto = false
  end
end

function ActivityTreasureHuntNewMainComponent:StartAutoDig()
  if self.activityState ~= TreasureHuntNewActivityState.OpenCard then
    return
  end
  self.activityState = TreasureHuntNewActivityState.AutoOpen
  local ifBatchDig = DataCenter.ActivityTreasureHuntNewManager:CheckOpenBatchDig(self.activityId)
  if ifBatchDig and self.activityId then
    local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
    local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
    if 0 < curNum then
      local sent = DataCenter.ActivityTreasureHuntNewManager:RequestBatchDig(self.activityId)
      if not sent then
        self.selectAuto = false
        self.activityState = TreasureHuntNewActivityState.OpenCard
        self:RefreshBottomView()
      end
    else
      self.selectAuto = false
      UIUtil.ShowTipsId(120021)
      self:RefreshAll()
    end
    return
  end
  self.autoDigList = {}
  self.autoDigIndex = 1
  self.autoDigSendMsgIndex = -1
  for i = 1, cardNum do
    local curLevel = self.digInfo.finishedLv + 1
    local rewardIndex = DataCenter.ActivityTreasureHuntNewManager:GetDiggedOutRewardIndex(self.activityId, curLevel, i)
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

function ActivityTreasureHuntNewMainComponent:CloseAutoDigTimer()
  if self.autoDigTimer ~= nil then
    self.autoDigTimer:Stop()
    self.autoDigTimer = nil
  end
end

function ActivityTreasureHuntNewMainComponent:CloseFlyTimer()
  if self.flyTimer ~= nil then
    self.flyTimer:Stop()
    self.flyTimer = nil
  end
end

function ActivityTreasureHuntNewMainComponent:StartAutoDigTimer()
  self:CloseAutoDigTimer()
  self.autoDigTimer = TimerManager:GetInstance():GetTimer(0.1, self.AutoDigTimeFunc, self, false, false, false)
  self.autoDigTimer:Start()
end

function ActivityTreasureHuntNewMainComponent:AutoDigTimeFunc()
  if self.activityState ~= TreasureHuntNewActivityState.AutoOpen then
    return
  end
  local curTargetindex = self.autoDigList[self.autoDigIndex]
  if curTargetindex == nil then
    self:RefreshAll()
  else
    local curLevel = self.digInfo.finishedLv + 1
    local rewardIndex = DataCenter.ActivityTreasureHuntNewManager:GetDiggedOutRewardIndex(self.activityId, curLevel, curTargetindex)
    if 0 < rewardIndex then
      self.autoDigIndex = self.autoDigIndex + 1
    else
      if self.autoDigSendMsgIndex ~= self.autoDigIndex then
        self.autoDigSendMsgIndex = self.autoDigIndex
        local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
        local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
        if 0 < curNum then
          DataCenter.ActivityTreasureHuntNewManager:RequestDigOneBlock(self.activityId, curTargetindex)
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

function ActivityTreasureHuntNewMainComponent:OnDigOneMsg(data)
  local isFinalReward = data.rewardIndex == 0
  local blockIndex = data.blockIndex
  if isFinalReward then
    self.activityState = TreasureHuntNewActivityState.OpenCardGetBigReward
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
  local reward = DataCenter.ActivityTreasureHuntNewManager:GetDiggedOutReward(self.digInfo.activityId, self.digInfo.finishedLv + 1, blockIndex)
  local count = reward.count
  if 10 < count then
    count = 10
  end
  local pos = self.cardPosList[blockIndex].transform.position
  local endPos = self.objStoredRewardIcon.gameObject.transform.position
  UIUtil.DoFly(RewardType.GOODS, count, DataCenter.ItemTemplateManager:GetIconPath(reward.itemId), pos, endPos, nil, nil, function()
  end, nil, 1.2)
  self:CloseFlyTimer()
  self.flyTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.animStoredReward ~= nil then
      self.animStoredReward:Play("storedReward")
    end
    if self.objVfxStoredRewardAdd ~= nil then
      self.objVfxStoredRewardAdd:SetActive(false)
      self.objVfxStoredRewardAdd:SetActive(true)
    end
  end, 1.2)
end

function ActivityTreasureHuntNewMainComponent:ShowOneDig(data)
  local blockIndex = data.blockIndex
  self.cardPosList[blockIndex].cardItem:ShowItem(self.activityId, self.digInfo, blockIndex)
  self.cardPosList[blockIndex].cardItem:SetCoverView()
  self.cardPosList[blockIndex].cardItem:PlayOpenAni()
  local reward = DataCenter.ActivityTreasureHuntNewManager:GetDiggedOutReward(self.digInfo.activityId, self.digInfo.finishedLv + 1, blockIndex)
  local count = reward.count
  if 10 < count then
    count = 10
  end
  local pos = self.cardPosList[blockIndex].transform.position
  local endPos = self.objStoredRewardIcon.gameObject.transform.position
  UIUtil.DoFly(RewardType.GOODS, count, DataCenter.ItemTemplateManager:GetIconPath(reward.itemId), pos, endPos, nil, nil, function()
  end, nil, 1.2)
end

function ActivityTreasureHuntNewMainComponent:OnDigBatchMsgFail()
  self.selectAuto = false
  self.activityState = TreasureHuntNewActivityState.OpenCard
  self:RefreshAll()
end

function ActivityTreasureHuntNewMainComponent:OnDigBatchMsg(batchDigData)
  if not batchDigData then
    return
  end
  for _, v in pairs(batchDigData) do
    self:ShowOneDig(v)
  end
  self:CloseFlyTimer()
  self.flyTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.animStoredReward ~= nil then
      self.animStoredReward:Play("storedReward")
    end
    if self.objVfxStoredRewardAdd ~= nil then
      self.objVfxStoredRewardAdd:SetActive(false)
      self.objVfxStoredRewardAdd:SetActive(true)
    end
  end, 1.2)
  local ifGetFinalReward = false
  for _, v in pairs(batchDigData) do
    if v.rewardIndex == 0 then
      ifGetFinalReward = true
      break
    end
  end
  if ifGetFinalReward then
    self.activityState = TreasureHuntNewActivityState.OpenCardGetBigReward
  end
  local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
  local curNum = DataCenter.ItemData:GetItemCount(pickaxId)
  if ifGetFinalReward then
    UIUtil.ShowTipsId(2000660)
    self:CloseAutoDigTimer()
    self:PlayNextLevelSeq()
  elseif curNum <= 0 then
    self.selectAuto = false
    UIUtil.ShowTipsId(120021)
    self:RefreshAll()
  end
end

function ActivityTreasureHuntNewMainComponent:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function ActivityTreasureHuntNewMainComponent:PlayOpenSeq()
  self:CloseAniSeq()
  self.activityState = TreasureHuntNewActivityState.RefreshAni
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

function ActivityTreasureHuntNewMainComponent:PlayNextLevelSeq()
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
    DataCenter.ActivityTreasureHuntNewManager:RequestDigInfo(self.activityId)
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

function ActivityTreasureHuntNewMainComponent:OnHelpBtnClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    if self.activityState == TreasureHuntNewActivityState.OpenCardGetBigReward then
      self.selectAuto = false
    end
    if self.activityState == TreasureHuntNewActivityState.AutoOpen then
      self.selectAuto = false
      self:CloseAutoDigTimer()
      self.activityState = TreasureHuntNewActivityState.OpenCard
      self:RefreshBottomView()
    end
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActivityTreasureHuntNewMainComponent:OnGotoBtnClick()
  if self.digInfo ~= nil then
    if self.activityState == TreasureHuntNewActivityState.OpenCardGetBigReward then
      self.selectAuto = false
    end
    if self.activityState == TreasureHuntNewActivityState.AutoOpen then
      self.selectAuto = false
      self:CloseAutoDigTimer()
      self.activityState = TreasureHuntNewActivityState.OpenCard
      self:RefreshBottomView()
    end
    local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntNewShop, {anim = true}, self.activityId, tonumber(self.digInfo.exchange), pickaxId)
  end
end

function ActivityTreasureHuntNewMainComponent:OnStoredRewardClick()
  if self.activityState == TreasureHuntNewActivityState.OpenCardGetBigReward then
    self.selectAuto = false
  end
  if self.activityState == TreasureHuntNewActivityState.AutoOpen then
    self.selectAuto = false
    self:CloseAutoDigTimer()
    self.activityState = TreasureHuntNewActivityState.OpenCard
    self:RefreshBottomView()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureHuntNewHistory, {anim = true}, self.activityId)
end

function ActivityTreasureHuntNewMainComponent:UpdateStoredReward()
  self.textStoredReward:SetLocalText("activity_armament_desc1")
  if self.activityId ~= nil then
    local canClaimRewardList = DataCenter.ActivityTreasureHuntNewManager:GetCanClaimNormalRewardList(self.activityId)
    local canClaim = not table.IsNullOrEmpty(canClaimRewardList)
    if canClaim then
      if self.animStoredRewardGun ~= nil then
        self.animStoredRewardGun:Play("box_open")
      end
    elseif self.animStoredRewardGun ~= nil then
      self.animStoredRewardGun:Play("box_unOpen")
    end
    if self.objVfxStoredRewardCanClaim ~= nil then
      self.objVfxStoredRewardCanClaim:SetActive(canClaim)
    end
  end
end

function ActivityTreasureHuntNewMainComponent:UpdateStoredRewardRed()
  local red = 0
  if self.activityId ~= nil then
    red = DataCenter.ActivityTreasureHuntNewManager:GetStoredRewardRed(self.activityId)
  end
  self.objStoredRewardRedPoint:SetActive(0 < red)
end

return ActivityTreasureHuntNewMainComponent
