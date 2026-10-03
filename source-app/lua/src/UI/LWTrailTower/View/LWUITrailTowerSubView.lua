local LWUITrailTowerSubView = BaseClass("LWUITrailTowerSubView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local CSUIEventTrigger = typeof(CS.UIEventTrigger)
local LWUITrailTowerDifficultyGroupItemRender = require("UI.LWTrailTower.Component.LWUITrailTowerDifficultyGroupItemRender")
local LWUITrailTowerItemRender = require("UI.LWTrailTower.Component.LWUITrailTowerItemRender")
local left_btn_path = "Root/TopContainer/LeftBtn"
local right_btn_path = "Root/TopContainer/RightBtn"
local buffTips_btn_path = "Root/TopContainer/BuffTipsBtn"
local fight_btn_path = "Root/BottomContainer/FightBtn"
local rank_btn_path = "Root/BottomContainer/RankBtn"
local shopBtn_path = "Root/BottomContainer/ShopBtn"
local countDown_text_path = "Root/BottomContainer/CountDownText"
local reward_scrollView_path = "Root/BottomContainer/RewardContainer/RewardScrollView"
local difficultyGroup_scrollView_path = "Root/BottomContainer/DifficultyGroupScrollView"
local difficultyGroup_scrollView_content_path = "Root/BottomContainer/DifficultyGroupScrollView/Viewport/DifficultyGroupContent"
local unlockTipsText_path = "Root/BottomContainer/UnlockTipsText"
local rewardContainer_path = "Root/BottomContainer/RewardContainer"
local trailTower_scrollView_path = "Root/TopContainer/TrailTowerScrollView"
local fightBtnText_path = "Root/BottomContainer/FightBtn/FightBtnText"
local trailTowerItemObj_path = "Root/TopContainer/TrailTowerScrollView/TrailTowerContent/UILWTrailTowerItemRender"
local curDifficultyGroupContent_path = "Root/BottomContainer/CurDifficultyGroupContent"
local curDifficultyGroupText_path = "Root/BottomContainer/CurDifficultyGroupContent/CurDifficultyGroupText"
local shopRedPointImage_path = "Root/BottomContainer/ShopBtn/ImgWarn"
local shopRedPointText_path = "Root/BottomContainer/ShopBtn/ImgWarn/TxtNum"
local endTipsText_path = "Root/BottomContainer/EndTipsText"
local heroSpineContainer_path = "Root/TopContainer/BuffTipsBtn/HeroIconMask/HeroSpineContainer"
local buffCountDownText_path = "Root/TopContainer/BuffTipsBtn/BuffCountDownText"
local buffTipsTargetObj_path = "Root/TopContainer/BuffTipsBtn/TipsTargetObj"
local ScrollViewData = {
  siblingIndex = 0,
  localPos = 0,
  localScale = 0,
  color = 0
}
local TrailTowerScrollData = DataClass("ScrollViewData", ScrollViewData)

function LWUITrailTowerSubView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshShowHeroBuff()
end

function LWUITrailTowerSubView:OnDestroy()
  self:ClearDifficultyGroupScroll()
  self:ClearRewardScroll()
  self:DestroyHeroSpine()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerSubView:DataDefine()
  self.curSelectTrailTowerInfo = nil
  self.curSelectTrailTowerIsOpen = false
  self.curSelectDifficultyGroupId = 0
  self.curSelectTrailTowerTemplate = nil
  self.difficultyGroupRewardList = {}
  self.trailTowerItemRenderList = {}
  self.trailTowerScrollViewDataList = {}
  self.curSelectTrailTowerIndex = 1
  self.allTrailTowerData = {}
  self.isUpdateTime = false
  self.difficultyGroupLock = false
  self.heroSpineLoadRequest = nil
  self.lastSpinePath = ""
  self.displayBuffTemplateList = {}
  self.buffEndMilliSecond = 0
  self.hasShowBuff = false
  self.difficultyGroupItemIndex = 1
  self.trailTowerCellInterval = 115
  self.trailTowerCount = 3
  self.isInDrag = false
  self.lastDragPosition = nil
  self.isNotOpenState = false
end

function LWUITrailTowerSubView:DataDestroy()
  self.curSelectTrailTowerInfo = nil
  self.curSelectTrailTowerIsOpen = nil
  self.curSelectDifficultyGroupId = nil
  self.curSelectTrailTowerTemplate = nil
  self.difficultyGroupRewardList = nil
  self.trailTowerItemRenderList = nil
  self.trailTowerScrollViewDataList = nil
  self.curSelectTrailTowerIndex = nil
  self.allTrailTowerData = nil
  self.isUpdateTime = nil
  self.difficultyGroupLock = nil
  self.heroSpineLoadRequest = nil
  self.lastSpinePath = nil
  self.displayBuffTemplateList = nil
  self.buffEndMilliSecond = nil
  self.hasShowBuff = nil
  self.difficultyGroupItemIndex = nil
  self.trailTowerCellInterval = nil
  self.trailTowerCount = nil
  self.isInDrag = nil
  self.lastDragPosition = nil
  self.isNotOpenState = nil
end

function LWUITrailTowerSubView:OnEnable()
  base.OnEnable(self)
  self:Update1000MS()
end

function LWUITrailTowerSubView:OnDisable()
  base.OnDisable(self)
end

function LWUITrailTowerSubView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeTrailTowerDiffGroupSelect, self.OnDifficultyGroupItemClick)
  self:AddUIListener(EventId.OnCommonShopRedChange, self.RefreshShopRedPoint)
  self:AddUIListener(EventId.TrailTowerPickGroup, self.RefreshCurSelectTrailTowerInfo)
  self:AddUIListener(EventId.RefreshTrailTowerDifficultyGroupNewMark, self.RefreshCurSelectTrailTowerInfo)
end

function LWUITrailTowerSubView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeTrailTowerDiffGroupSelect, self.OnDifficultyGroupItemClick)
  self:RemoveUIListener(EventId.OnCommonShopRedChange, self.RefreshShopRedPoint)
  self:RemoveUIListener(EventId.TrailTowerPickGroup, self.RefreshCurSelectTrailTowerInfo)
  self:RemoveUIListener(EventId.RefreshTrailTowerDifficultyGroupNewMark, self.RefreshCurSelectTrailTowerInfo)
  base.OnRemoveListener(self)
end

function LWUITrailTowerSubView:ComponentDefine()
  self.leftBtn = self:AddComponent(UIButton, left_btn_path)
  self.leftBtn:SetOnClick(function()
    self:LeftBtnClick()
  end)
  self.leftBtn:SetSafeClickMode(true)
  self.rightBtn = self:AddComponent(UIButton, right_btn_path)
  self.rightBtn:SetOnClick(function()
    self:RightBtnClick()
  end)
  self.rightBtn:SetSafeClickMode(true)
  self.buffTipsBtn = self:AddComponent(UIButton, buffTips_btn_path)
  self.buffTipsBtn:SetOnClick(function()
    self:BuffTipsBtnClick()
  end)
  self.fightBtn = self:AddComponent(UIButton, fight_btn_path)
  self.fightBtn:SetOnClick(function()
    self:FightBtnClick()
  end)
  self.rankBtn = self:AddComponent(UIButton, rank_btn_path)
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.shopBtn:SetOnClick(function()
    self:ShopBtnClick()
  end)
  self.countDownText = self:AddComponent(UIText, countDown_text_path)
  self.unlockTipsText = self:AddComponent(UIText, unlockTipsText_path)
  self.fightBtnText = self:AddComponent(UIText, fightBtnText_path)
  self.curDifficultyGroupContent = self:AddComponent(UIImage, curDifficultyGroupContent_path)
  self.curDifficultyGroupText = self:AddComponent(UIText, curDifficultyGroupText_path)
  self.shopRedPointImage = self:AddComponent(UIImage, shopRedPointImage_path)
  self.shopRedPointText = self:AddComponent(UIText, shopRedPointText_path)
  self.endTipsText = self:AddComponent(UIText, endTipsText_path)
  self.rewardContainer = self:AddComponent(UIBaseContainer, rewardContainer_path)
  self.reward_scrollView = self:AddComponent(UIScrollView, reward_scrollView_path)
  self.reward_scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.reward_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.difficultyGroup_scrollView = self:AddComponent(UILoopListView2, difficultyGroup_scrollView_path)
  self.difficultyGroup_scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.difficultyGroup_scrollViewContent = self:AddComponent(UIBaseContainer, difficultyGroup_scrollView_content_path)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainer_path)
  self.buffCountDownText = self:AddComponent(UIText, buffCountDownText_path)
  self.buffTipsTarget = self:AddComponent(UIBaseContainer, buffTipsTargetObj_path)
  for i = 1, self.trailTowerCount do
    local trailTowerItemRender = self:AddComponent(LWUITrailTowerItemRender, trailTowerItemObj_path .. i)
    table.insert(self.trailTowerItemRenderList, trailTowerItemRender)
    local scrollViewData = TrailTowerScrollData.New()
    local index = i - 1
    if index <= self.trailTowerCount / 2 then
      local posX = self.trailTowerCellInterval * index
      scrollViewData.localPos = Vector3.New(posX, -140)
    else
      local posX = self.trailTowerCellInterval * (index - self.trailTowerCount)
      scrollViewData.localPos = Vector3.New(posX, -140)
    end
    scrollViewData.siblingIndex = self.trailTowerCount - i
    scrollViewData.localScale = i == 1 and Vector3.one or Vector3.one * 0.9
    scrollViewData.color = i == 1 and 1 or 0.3
    scrollViewData.alpha = i == 1 and 1 or 0
    table.insert(self.trailTowerScrollViewDataList, scrollViewData)
  end
  local scrollRect = self.transform:Find(trailTower_scrollView_path).gameObject
  self.unityEventTrigger = scrollRect:GetComponent(CSUIEventTrigger)
  
  function self.unityEventTrigger.onBeginDrag(eventData)
    self.isInDrag = true
    self.lastDragPosition = eventData.position
  end
  
  function self.unityEventTrigger.onEndDrag(eventData)
    self.isInDrag = false
    if math.abs(eventData.position.x - self.lastDragPosition.x) < 100 then
      self.isInDrag = false
      return
    end
    if eventData.position.x > self.lastDragPosition.x then
      self:LeftBtnClick()
    elseif eventData.position.x < self.lastDragPosition.x then
      self:RightBtnClick()
    end
  end
end

function LWUITrailTowerSubView:ComponentDestroy()
  self.leftBtn = nil
  self.rightBtn = nil
  self.buffTipsBtn = nil
  self.fightBtn = nil
  self.rankBtn = nil
  self.countDownText = nil
  self.unlockTipsText = nil
  self.rewardContainer = nil
  self.reward_scrollView = nil
  self.difficultyGroup_scrollView = nil
  self.difficultyGroup_scrollViewContent = nil
  self.curDifficultyGroupContent = nil
  self.curDifficultyGroupText = nil
  self.shopBtn = nil
  self.shopRedPointImage = nil
  self.shopRedPointText = nil
  self.endTipsText = nil
  self.heroSpineContainer = nil
  self.buffCountDownText = nil
  self.buffTipsTarget = nil
  self.unityEventTrigger.onBeginDrag = nil
  self.unityEventTrigger.onEndDrag = nil
  self.unityEventTrigger = nil
end

function LWUITrailTowerSubView:Update1000MS()
  if self.isUpdateTime and self.curSelectTrailTowerInfo ~= nil then
    local endTime = self.curSelectTrailTowerInfo.endTime
    local startTime = self.curSelectTrailTowerInfo.startTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isOpen = self.curSelectTrailTowerInfo:IsOpen()
    local isEnd = self.curSelectTrailTowerInfo:IsEnd()
    local surplusTime = 0
    if not isOpen then
      surplusTime = startTime - curTime
      if surplusTime < 0 then
        surplusTime = 0
      end
      self.unlockTipsText:SetText(Localization:GetString("trialtower_017", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)))
    elseif isOpen and not isEnd then
      if self.isNotOpenState then
        self.unlockTipsText:SetText(Localization:GetString("trialtower_017", UITimeManager:GetInstance():MilliSecondToFmtString(0)))
        self.isUpdateTime = false
        SFSNetwork.SendMessage(MsgDefines.TrailTowerInfo)
      else
        surplusTime = endTime - curTime
        if surplusTime < 0 then
          surplusTime = 0
        end
        self.countDownText:SetText(Localization:GetString("trialtower_015") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
      end
    elseif isEnd then
      self.countDownText:SetText(Localization:GetString("trialtower_015") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(0))
      self.isUpdateTime = false
      SFSNetwork.SendMessage(MsgDefines.TrailTowerInfo)
    end
  end
  if self.hasShowBuff then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.buffEndMilliSecond - curTime
    if surplusTime <= 0 then
      self:RefreshShowHeroBuff()
    else
      self.buffCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    end
  end
end

function LWUITrailTowerSubView:ReInit()
  self.curSelectTrailTowerIndex = 1
  local jumpToTrailTowerId = DataCenter.LWTrailTowerManager:GetJumpToTrailTowerIdData()
  self.allTrailTowerData = DataCenter.LWTrailTowerManager:GetAllTrailTowerData()
  local findValidTrailTower = false
  if jumpToTrailTowerId ~= -1 then
    for i = 1, #self.allTrailTowerData do
      local trailTowerInfo = self.allTrailTowerData[i]
      if trailTowerInfo.trailTowerId == jumpToTrailTowerId and trailTowerInfo:IsOpen() and not trailTowerInfo:IsEnd() and not trailTowerInfo.isFinish then
        self.curSelectTrailTowerIndex = i
        findValidTrailTower = true
        break
      end
    end
  end
  if not findValidTrailTower then
    for i = 1, #self.allTrailTowerData do
      local trailTowerInfo = self.allTrailTowerData[i]
      if not trailTowerInfo.isFinish then
        local unlockCondition, conditionTips = DataCenter.LWTrailTowerTemplateManager:JudgeTrailTowerUnlockCondition(trailTowerInfo.trailTowerId)
        if unlockCondition and trailTowerInfo:IsOpen() and not trailTowerInfo:IsEnd() then
          self.curSelectTrailTowerIndex = i
          findValidTrailTower = true
          break
        end
      end
    end
  end
  local index = 1
  for i = self.curSelectTrailTowerIndex, self.trailTowerCount do
    local trailTowerItemRender = self.trailTowerItemRenderList[index]
    local trailTowerInfo = self.allTrailTowerData[i]
    if trailTowerInfo ~= nil then
      trailTowerItemRender:SetActive(true)
      local scrollViewData = self.trailTowerScrollViewDataList[index]
      trailTowerItemRender:SetData(index, trailTowerInfo, scrollViewData)
      index = index + 1
    else
      trailTowerItemRender:SetActive(false)
    end
  end
  if self.curSelectTrailTowerIndex > 1 then
    for i = 1, self.curSelectTrailTowerIndex - 1 do
      local trailTowerItemRender = self.trailTowerItemRenderList[index]
      local trailTowerInfo = self.allTrailTowerData[i]
      if trailTowerInfo ~= nil then
        trailTowerItemRender:SetActive(true)
        local scrollViewData = self.trailTowerScrollViewDataList[index]
        trailTowerItemRender:SetData(index, trailTowerInfo, scrollViewData)
        index = index + 1
      else
        trailTowerItemRender:SetActive(false)
      end
    end
  end
  self:RefreshCurSelectTrailTowerInfo()
  self:RefreshShopRedPoint(CommonShopType.TrailTowerShop)
  DataCenter.LWTrailTowerManager:SetJumpToTrailTowerIdData(-1)
  local sweepStageId = DataCenter.LWTrailTowerManager.cacheNeedShowBattleSweepResultStageId
  if sweepStageId and 0 < sweepStageId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerSweepBattleResult, {anim = true, playEffect = 10024}, DataCenter.LWTrailTowerManager.battleSweepInterrupt, sweepStageId)
  end
  DataCenter.LWTrailTowerManager:SetNeedShowBattleSweepResultStageId(-1, false)
end

function LWUITrailTowerSubView:RefreshCurSelectTrailTowerInfo()
  self.isUpdateTime = false
  self.difficultyGroupLock = false
  self.isNotOpenState = false
  local trailTowerInfo = self.allTrailTowerData[self.curSelectTrailTowerIndex]
  self.curSelectTrailTowerInfo = trailTowerInfo
  if self.curSelectTrailTowerInfo ~= nil then
    DataCenter.LWTrailTowerManager:ClearAutoNextData(self.curSelectTrailTowerInfo.trailTowerId)
    self.curSelectTrailTowerTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerTemplateById(self.curSelectTrailTowerInfo.trailTowerId)
    self.curSelectDifficultyGroupId = self.curSelectTrailTowerInfo:GetCurCanDoDifficultyGroup()
    self:ShowDifficultyGroupReward()
    if self.curSelectTrailTowerInfo.isFinish then
      self.curDifficultyGroupContent:SetActive(false)
      self.difficultyGroup_scrollView:SetActive(true)
      self:ShowCurTrailTowerDifficultyGroup()
    elseif DataCenter.LWTrailTowerManager:IsDifficultyGroupChange(self.curSelectTrailTowerInfo.trailTowerId) then
      self.curDifficultyGroupContent:SetActive(false)
      self.difficultyGroup_scrollView:SetActive(true)
      self:ShowCurTrailTowerDifficultyGroup()
      self.fightBtnText:SetLocalText("trialtower_016")
    elseif self.curSelectTrailTowerInfo.curGroup == 0 then
      self.curDifficultyGroupContent:SetActive(false)
      self.difficultyGroup_scrollView:SetActive(true)
      self:ShowCurTrailTowerDifficultyGroup()
      self.fightBtnText:SetLocalText("trialtower_016")
    else
      self.curDifficultyGroupContent:SetActive(true)
      self.difficultyGroup_scrollView:SetActive(false)
      self.curDifficultyGroupText:SetText(tostring(self.curSelectDifficultyGroupId))
      self.fightBtnText:SetLocalText("trialtower_019")
    end
    local endTime = self.curSelectTrailTowerInfo.endTime
    local startTime = self.curSelectTrailTowerInfo.startTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local unlockCondition, conditionTips = DataCenter.LWTrailTowerTemplateManager:JudgeTrailTowerUnlockCondition(trailTowerInfo.trailTowerId)
    if not self.curSelectTrailTowerInfo:IsOpen() or not unlockCondition then
      self:RefreshTrailTowerUnlockState(false)
      if not unlockCondition then
        self.unlockTipsText:SetText(conditionTips)
      else
        self.isNotOpenState = true
        self.isUpdateTime = true
        local time = startTime - curTime
        self.unlockTipsText:SetText(Localization:GetString("trialtower_017", UITimeManager:GetInstance():MilliSecondToFmtString(time)))
      end
    elseif not self.curSelectTrailTowerInfo:IsEnd() then
      self.isUpdateTime = true
      local surplusTime = endTime - curTime
      self:RefreshTrailTowerUnlockState(true)
      self.countDownText:SetText(Localization:GetString("trialtower_015") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    else
      self:RefreshTrailTowerUnlockState(false)
      self.unlockTipsText:SetLocalText("trialtower_error_01")
    end
  end
end

function LWUITrailTowerSubView:RefreshTrailTowerUnlockState(unlock)
  self.curSelectTrailTowerIsOpen = unlock
  self.unlockTipsText:SetActive(not unlock)
  self.countDownText:SetActive(unlock)
  if unlock then
    self:RefreshDifficultyGroupState()
  else
    self.fightBtn:SetActive(false)
    self.endTipsText:SetActive(false)
  end
end

function LWUITrailTowerSubView:RefreshDifficultyGroupState()
  if self.curSelectTrailTowerInfo.isFinish then
    self.fightBtn:SetActive(false)
    self.endTipsText:SetActive(true)
    if self.difficultyGroupLock then
      if self.curSelectTrailTowerInfo:IsAchieveChallengesTimesLimit() then
        self.endTipsText:SetLocalText("trialtower_038", self.curSelectTrailTowerInfo.challengeLimit)
      else
        self.endTipsText:SetLocalText("trialtower_043")
      end
    else
      self.endTipsText:SetLocalText("trialtower_037")
    end
  elseif self.curSelectTrailTowerInfo.curGroup == 0 or self.curSelectDifficultyGroupId == self.curSelectTrailTowerInfo:GetCurCanDoDifficultyGroup() then
    self.fightBtn:SetActive(true)
    self.endTipsText:SetActive(false)
    self:RefreshFightBtnState()
  elseif self.curSelectTrailTowerInfo.passGroup >= self.curSelectDifficultyGroupId then
    self.fightBtn:SetActive(false)
    self.endTipsText:SetActive(true)
    self.endTipsText:SetLocalText("trialtower_037")
  else
    self.fightBtn:SetActive(true)
    self.endTipsText:SetActive(false)
    self:RefreshFightBtnState()
  end
end

function LWUITrailTowerSubView:RefreshShopRedPoint(shopType)
  if shopType == CommonShopType.TrailTowerShop then
    local redCount = DataCenter.CommonShopManager:GetRedCount(CommonShopType.TrailTowerShop)
    if 0 < redCount then
      self.shopRedPointImage:SetActive(true)
      self.shopRedPointText:SetText(tostring(redCount))
    else
      self.shopRedPointImage:SetActive(false)
    end
  end
end

function LWUITrailTowerSubView:ShowCurTrailTowerDifficultyGroup()
  if self.curSelectTrailTowerTemplate ~= nil then
    self:ClearDifficultyGroupScroll()
    local count = #self.curSelectTrailTowerTemplate.levelList
    self.difficultyGroup_scrollView:SetListItemCount(count, false, false)
    self.difficultyGroup_scrollView:RefreshAllShownItem()
    local jumpToIndex = table.indexof(self.curSelectTrailTowerTemplate.levelList, self.curSelectDifficultyGroupId)
    if jumpToIndex <= 3 then
      jumpToIndex = 0
    else
      jumpToIndex = jumpToIndex - 3
    end
    self.difficultyGroup_scrollView:MovePanelToItemIndex(jumpToIndex)
  end
end

function LWUITrailTowerSubView:OnGetItemByIndex(loopScroll, index)
  if self.curSelectTrailTowerTemplate ~= nil then
    local count = #self.curSelectTrailTowerTemplate.levelList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("DifficultyGroupItemRender")
    local script = self.difficultyGroup_scrollViewContent:GetComponent(item.gameObject.name, LWUITrailTowerDifficultyGroupItemRender)
    if script == nil then
      local objectName = tostring(self.difficultyGroupItemIndex)
      self.difficultyGroupItemIndex = self.difficultyGroupItemIndex + 1
      item.gameObject.name = objectName
      script = self.difficultyGroup_scrollViewContent:AddComponent(LWUITrailTowerDifficultyGroupItemRender, objectName)
    end
    script:SetActive(true)
    local passGroupId = self.curSelectTrailTowerInfo.passGroup
    local groupId = self.curSelectTrailTowerTemplate.levelList[index]
    script:SetData(self.curSelectTrailTowerInfo.trailTowerId, groupId, passGroupId, self.curSelectDifficultyGroupId)
    return item
  end
end

function LWUITrailTowerSubView:OnDifficultyGroupItemClick(clickParam)
  self.curSelectDifficultyGroupId = clickParam.groupId
  self.difficultyGroupLock = clickParam.lock
  self:ShowDifficultyGroupReward()
  if self.curSelectTrailTowerIsOpen then
    self:RefreshDifficultyGroupState()
  end
end

function LWUITrailTowerSubView:ClearDifficultyGroupScroll()
  self.difficultyGroup_scrollViewContent:RemoveComponents(LWUITrailTowerDifficultyGroupItemRender)
  self.difficultyGroup_scrollView:ClearAllItems()
end

function LWUITrailTowerSubView:ShowDifficultyGroupReward()
  self:ClearRewardScroll()
  self.difficultyGroupRewardList = self.curSelectTrailTowerTemplate ~= nil and self.curSelectTrailTowerTemplate:GetDifficultyGroup2Reward(self.curSelectDifficultyGroupId) or {}
  local rewardCount = #self.difficultyGroupRewardList
  if 0 < rewardCount then
    self.reward_scrollView:SetTotalCount(rewardCount)
    self.reward_scrollView:RefillCells()
  end
end

function LWUITrailTowerSubView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(0.9, 0.9, 0.9)
  local itemRender = self.reward_scrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:ReInit(self.difficultyGroupRewardList[index])
  end
end

function LWUITrailTowerSubView:OnRewardItemMoveOut(itemObj, index)
  itemObj.transform:Set_localScale(1, 1, 1)
  self.reward_scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUITrailTowerSubView:ClearRewardScroll()
  self.reward_scrollView:ClearCells()
  self.reward_scrollView:RemoveComponents(UICommonResItem)
end

function LWUITrailTowerSubView:RefreshShowHeroBuff()
  self.hasShowBuff = false
  self.displayBuffTemplateList = DataCenter.LWTrailTowerTemplateManager:GetCanShowTrailTowerBuffTemplateList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local minSurplusTime, minSurplusTime2Template
  if self.displayBuffTemplateList ~= nil then
    for i = 1, #self.displayBuffTemplateList do
      local endTime = self.displayBuffTemplateList[i]:GetEndTime()
      local surplusTime = endTime - curTime
      if minSurplusTime == nil or minSurplusTime > surplusTime then
        minSurplusTime = surplusTime
        minSurplusTime2Template = self.displayBuffTemplateList[i]
        self.buffEndMilliSecond = endTime
      end
    end
    if minSurplusTime ~= nil then
      self.hasShowBuff = true
      self.buffCountDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(minSurplusTime))
    end
  end
  self.buffTipsBtn:SetActive(self.hasShowBuff)
  if self.hasShowBuff and self.lastSpinePath ~= minSurplusTime2Template.buffResPath then
    self.lastSpinePath = minSurplusTime2Template.buffResPath
    self:DestroyHeroSpine()
    local request = ResourceManager:InstantiateAsync(minSurplusTime2Template.buffResPath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      rectTransform:SetParent(self.heroSpineContainer.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_localPosition(0, 0, 0)
    end)
  end
end

function LWUITrailTowerSubView:DestroyHeroSpine()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

function LWUITrailTowerSubView:LeftBtnClick()
  local preIndex = self.curSelectTrailTowerIndex - 1
  if preIndex <= 0 then
    preIndex = self.trailTowerCount
  end
  self.curSelectTrailTowerIndex = preIndex
  self:RefreshCurSelectTrailTowerInfo()
  for i = 1, self.trailTowerCount do
    local trailTowerItem = self.trailTowerItemRenderList[i]
    local newIndex = trailTowerItem.itemIndex + 1
    local isLast = newIndex == self.trailTowerCount
    newIndex = newIndex > self.trailTowerCount and 1 or newIndex
    trailTowerItem.itemIndex = newIndex
    local scrollViewData = self.trailTowerScrollViewDataList[newIndex]
    trailTowerItem:Move(scrollViewData, isLast)
  end
end

function LWUITrailTowerSubView:RightBtnClick()
  local nextIndex = self.curSelectTrailTowerIndex + 1
  if nextIndex > self.trailTowerCount then
    nextIndex = 1
  end
  self.curSelectTrailTowerIndex = nextIndex
  self:RefreshCurSelectTrailTowerInfo()
  for i = 1, self.trailTowerCount do
    local trailTowerItem = self.trailTowerItemRenderList[i]
    local newIndex = trailTowerItem.itemIndex - 1
    local isLast = newIndex == self.trailTowerCount - 1
    newIndex = newIndex <= 0 and self.trailTowerCount or newIndex
    trailTowerItem.itemIndex = newIndex
    local scrollViewData = self.trailTowerScrollViewDataList[newIndex]
    trailTowerItem:Move(scrollViewData, isLast)
  end
end

function LWUITrailTowerSubView:RefreshFightBtnState()
  CS.UIGray.SetGray(self.fightBtn.transform, self.difficultyGroupLock, true)
end

function LWUITrailTowerSubView:FightBtnClick()
  if self.difficultyGroupLock then
    local group = self.curSelectDifficultyGroupId
    local tips = Localization:GetString("trialtower_036", tostring(group - 1))
    UIUtil.ShowTips(tips)
    return
  end
  if self.curSelectTrailTowerInfo.curGroup <= 0 then
    if self.curSelectTrailTowerInfo.passGroup >= self.curSelectDifficultyGroupId then
      local nMaxGroup = #self.curSelectTrailTowerTemplate.levelList
      local bCurIsMaxGroup = self.curSelectDifficultyGroupId == nMaxGroup
      if bCurIsMaxGroup then
        DataCenter.LWTrailTowerManager:OpenTrailTowerStagePanel(self.curSelectTrailTowerInfo.trailTowerId, self.curSelectDifficultyGroupId, true, false)
      else
        UIUtil.ShowMessage(Localization:GetString("trialtower_044"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          DataCenter.LWTrailTowerManager:OpenTrailTowerStagePanel(self.curSelectTrailTowerInfo.trailTowerId, self.curSelectDifficultyGroupId, true, false)
        end, nil, nil, "trialtower_027", false, nil, nil, nil, nil, nil, nil, nil, nil, nil, false)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerConfirmView, {anim = true}, self.curSelectTrailTowerTemplate, self.curSelectDifficultyGroupId)
    end
  elseif DataCenter.LWTrailTowerManager:IsDifficultyGroupChange(self.curSelectTrailTowerInfo.trailTowerId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerConfirmView, {anim = true}, self.curSelectTrailTowerTemplate, self.curSelectDifficultyGroupId)
  else
    DataCenter.LWTrailTowerManager:OpenTrailTowerStagePanel(self.curSelectTrailTowerInfo.trailTowerId, self.curSelectDifficultyGroupId, false, false)
  end
end

function LWUITrailTowerSubView:RankBtnClick()
  if DataCenter.BuildManager.MainLv >= 10 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable, {anim = true, hideTop = true})
  else
    UIUtil.ShowTipsId(451038)
  end
end

function LWUITrailTowerSubView:ShopBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.TrailTowerShop)
end

function LWUITrailTowerSubView:BuffTipsBtnClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  local des = ""
  for i = 1, #self.displayBuffTemplateList do
    local trailTowerBuffTemplate = self.displayBuffTemplateList[i]
    local displayBuffDataList = trailTowerBuffTemplate:GetDisplayBuffDesList()
    local result = table.concat(displayBuffDataList, "\n")
    des = des .. result
  end
  param.desc = des
  param.isLocal = true
  param.isModify = true
  param.alignObject = self.buffTipsTarget
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return LWUITrailTowerSubView
