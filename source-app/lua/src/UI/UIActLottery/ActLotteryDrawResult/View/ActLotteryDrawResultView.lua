local ActLotteryDrawResultView = BaseClass("ActLotteryDrawResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local ActLotteryDrawResultItem = require("UI.UIActLottery.ActLotteryDrawResult.Component.ActLotteryDrawResultItem")
local cardPosDataList = {
  {x = -123.9, y = 433.9},
  {x = -248.6, y = 142.6},
  {x = -248.6, y = -142.6},
  {x = -123.9, y = -433.9},
  {x = 123.9, y = -433.9},
  {x = 248.6, y = -142.6},
  {x = 248.6, y = 142.6},
  {x = 123.9, y = 433.9},
  {x = 0, y = 142.6},
  {x = 0, y = -142.6}
}
local openAni = "Eff_UIHeroRecruitRewardNew_chouka"
local openOneAni = "Eff_UIHeroRecruitRewardNew_fapai_danchou"
local openAniTime = 1.2
local shockAniTime = 0.5
local openCardAniTime = 1
local autoWaitOpenTime = 0.5
local sendMsgTime = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local message = self:GetUserData()
  self:RefreshMessageData(message)
  self.drawCardTime = 0
  self:OnOpen()
end

local function StopDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnDestroy(self)
  StopDelayTimer(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  self.rootAni = self:AddComponent(UIAnimator, "")
  self.rootAni:Enable(false)
  self.btnClose = self:AddComponent(UIButton, "Root/NodeBottom/closeBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
  self.textTitle = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.textTitle:SetLocalText(110021)
  self.itemBar1 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar1")
  self.itemBar2 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar2")
  self.itemBarList = {
    self.itemBar1,
    self.itemBar2
  }
  self.content = self:AddComponent(UIBaseContainer, "Root/Panel")
  self.cardPosList = {}
  for i = 1, 10 do
    local cardPosItemName = string.format("Root/Panel/cardPos%d", i)
    local cardPosItem = self:AddComponent(UIBaseContainer, cardPosItemName)
    cardPosItem.cardItem = cardPosItem:AddComponent(ActLotteryDrawResultItem, "ActLotteryDrawRewardItem")
    table.insert(self.cardPosList, cardPosItem)
  end
  self.nodeBottom = self:AddComponent(UIBaseContainer, "Root/NodeBottom")
  self.btnRecruit = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit")
  self.btnRecruit2 = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit2")
  self.textRecruit = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/TextRecruit")
  self.TextBtn2 = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit2/TextBtn2")
  self.imgCost = self:AddComponent(UIImage, "Root/NodeBottom/BtnRecruit2/ImgCost")
  self.textCost = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit2/ImgCost/TextCost")
  self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.btnRecruit2:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
end

local function ComponentDestroy(self)
  self.nodeRoot = nil
  self.rootAni = nil
  self.btnClose = nil
  self.topBar = nil
  self.textTitle = nil
  self.itemBar1 = nil
  self.itemBar2 = nil
  self.itemBarList = nil
  self.content = nil
  self.cardPosList = nil
  self.nodeBottom = nil
  self.btnRecruit = nil
  self.textRecruit = nil
  self.imgCost = nil
  self.textCost = nil
end

local function DataDefine(self)
  self.nodeCards = {}
  self.cardRequestList = {}
  self.eventHandler = {}
  self.canClick = true
  self.directEnd = false
  self.delayTimer = nil
  self.touchCardEnable = true
end

local function DataDestroy(self)
  self.nodeCards = nil
  self.cardRequestList = nil
  self.eventHandler = nil
  self.directEnd = nil
  self.touchCardEnable = true
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.ActLotteryDrawResultMsg, self.OnHandleRecruitResponse)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLotteryDrawResultMsg, self.OnHandleRecruitResponse)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  local isFirstPlayAni = self.drawCardTime == 0
  self.isMoreThanOne = #self.lotteryData > 1
  self.isPlayingWaitAni = false
  local isSkip = DataCenter.ActLotteryDataManager:GetIsSkip()
  if isFirstPlayAni and isSkip <= 0 then
    if self.isMoreThanOne then
      self.lotteryState = HeroRecruitState.PlayOpenAni
    else
      self.lotteryState = HeroRecruitState.PlayOpenAni
    end
  else
    self.lotteryState = HeroRecruitState.OpenWithoutAni
  end
  self.itemId = self.activityTemp.ticket
  local costNum = DataCenter.ActLotteryDataManager:GetDrawNumByType(self.drawType)
  self.recruitCost1 = costNum
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self.openCardDict = {}
  self.openCardCount = 0
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
  self:RefreshContentAtOpen()
  self:TryStateFunc()
end

local function RefreshNodeBottom(self)
  self.btnRecruit:SetActive(true)
  if self.lotteryState == HeroRecruitState.PlayOpenAni then
    self.nodeBottom:SetActive(false)
  elseif self.lotteryState == HeroRecruitState.Manual then
    if self.isMoreThanOne then
      self.nodeBottom:SetActive(true)
      self.btnRecruit:SetActive(true)
      self.btnRecruit2:SetActive(false)
      self.imgCost:SetActive(false)
      self.btnClose:SetActive(false)
      self.textRecruit:SetLocalText("150218")
    else
      self.nodeBottom:SetActive(false)
    end
  elseif self.lotteryState == HeroRecruitState.Auto then
    self.nodeBottom:SetActive(true)
    self.btnRecruit:SetActive(true)
    self.btnRecruit2:SetActive(false)
    self.imgCost:SetActive(false)
    self.btnClose:SetActive(false)
    self.textRecruit:SetLocalText("150219")
  elseif self.lotteryState == HeroRecruitState.All then
    self.nodeBottom:SetActive(false)
  elseif self.lotteryState == HeroRecruitState.OpenWithoutAni then
    self.nodeBottom:SetActive(false)
  elseif self.lotteryState == HeroRecruitState.QuicklyAuto then
    self.nodeBottom:SetActive(false)
  elseif self.lotteryState == HeroRecruitState.Fin then
    self.nodeBottom:SetActive(true)
    self.btnRecruit:SetActive(false)
    self.btnRecruit2:SetActive(true)
    self.imgCost:SetActive(true)
    self.btnClose:SetActive(true)
    local canFreeRecruit = false
    if canFreeRecruit then
      self.imgCost:SetActive(false)
    else
      local item = DataCenter.ItemData:GetItemByItemId(tonumber(self.itemId))
      local itemCount = item and item.count or 0
      local needCount = self.recruitCost1
      if itemCount >= needCount then
        self.imgCost:SetActive(true)
        self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
        self.textCost:SetText(string.GetFormattedSeperatorNum(self.recruitCost1))
      else
        self.imgCost:SetActive(true)
        self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
        self.textCost:SetText(string.format("<color=#CD2626>%s</color>", needCount))
        self.btnRecruit:SetActive(false)
      end
    end
    self.TextBtn2:SetLocalText(self.isMoreThanOne and "thxgiv_Lottery_Open10" or "thxgiv_Lottery_Open")
  end
end

local function UpdateTopItemBar(self)
  local goldIndex = 2
  local itemIndex = 1
  self.itemBarList[goldIndex]:SetActive(true)
  self.itemBarList[goldIndex]:SetData(nil, ResourceType.Gold)
  self.itemBarList[itemIndex]:SetActive(true)
  self.itemBarList[itemIndex]:SetData(self.itemId)
end

local function RefreshItemViewByIndex(self, i)
  if self.lotteryData[i] ~= nil then
    local data = self.lotteryData[i]
    self.cardPosList[i].cardItem:SetData(i, data, function()
      self:OnCardItemClick(i)
    end, false)
    if self.openCardDict[i] == nil then
      self.cardPosList[i].cardItem:SetCoverView()
    else
      self.cardPosList[i].cardItem:SetNormalView()
    end
  end
end

local function RefreshContentAtOpen(self)
  if self.isMoreThanOne then
    for i = 1, #self.cardPosList do
      self.cardPosList[i]:SetActive(true)
      self.cardPosList[i]:SetAnchoredPositionXY(cardPosDataList[i].x, cardPosDataList[i].y)
      self.cardPosList[i]:SetEulerAnglesXYZ(0, 0, 0)
      self.cardPosList[i]:SetLocalScaleXYZ(1, 1, 1)
      self:RefreshItemViewByIndex(i)
    end
  else
    for i = 1, #self.cardPosList do
      if i == 1 then
        self.cardPosList[i]:SetActive(true)
        self.cardPosList[i]:SetAnchoredPositionXY(0, 0)
        self.cardPosList[i]:SetEulerAnglesXYZ(0, 0, 0)
        self.cardPosList[i]:SetLocalScaleXYZ(1, 1, 1)
        self:RefreshItemViewByIndex(i)
      else
        self.cardPosList[i]:SetActive(false)
      end
    end
  end
end

local function TryStateFunc(self)
  if self.lotteryState == HeroRecruitState.PlayOpenAni then
    self:StopDelayTimer()
    self.rootAni:Enable(true)
    if self.isMoreThanOne then
      self.rootAni:Play(openAni)
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.RecruitTenTimes)
    else
      self.rootAni:Play(openOneAni)
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.RecruitOnceCard)
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self ~= nil then
        self:StopDelayTimer()
        self.rootAni:Enable(false)
        self.lotteryState = HeroRecruitState.Manual
        self:UpdateTopItemBar()
        self:RefreshNodeBottom()
        self:RefreshContentAtOpen()
        self:TryStateFunc()
      end
    end, openAniTime)
  elseif self.lotteryState == HeroRecruitState.Manual then
    if #self.lotteryData == self.openCardCount then
      self.lotteryState = HeroRecruitState.Fin
      self:TryStateFunc()
    end
  elseif self.lotteryState == HeroRecruitState.Auto then
    if #self.lotteryData > self.openCardCount then
      local getNextIndex = 1
      for i = 1, #self.lotteryData do
        if self.openCardDict[i] == nil then
          getNextIndex = i
          break
        end
      end
      if self.openCardDict[getNextIndex] == nil then
        self.openCardDict[getNextIndex] = 1
        self.openCardCount = self.openCardCount + 1
        local delayTime = 1
        self.cardPosList[getNextIndex].cardItem:PlayOpenAni()
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Recruit_Flip, false)
        delayTime = autoWaitOpenTime
        self:StopDelayTimer()
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self ~= nil then
            self:StopDelayTimer()
            self:TryStateFunc()
          end
        end, delayTime)
      end
    elseif #self.lotteryData == self.openCardCount then
      self.lotteryState = HeroRecruitState.Fin
      self:TryStateFunc()
    end
  elseif self.lotteryState == HeroRecruitState.All then
    if #self.lotteryData > self.openCardCount then
      local delayTime = autoWaitOpenTime
      for i = 1, #self.lotteryData do
        if self.openCardDict[i] == nil and self.openCardDict[i] == nil then
          self.openCardDict[i] = 1
          self.openCardCount = self.openCardCount + 1
          self.cardPosList[i].cardItem:PlayOpenAni()
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Recruit_Flip, false)
        end
      end
      if 0 < delayTime then
        self:StopDelayTimer()
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self ~= nil then
            self:StopDelayTimer()
            self:TryStateFunc()
          end
        end, delayTime)
      end
    else
      self.lotteryState = HeroRecruitState.Fin
      self:TryStateFunc()
    end
  elseif self.lotteryState == HeroRecruitState.Fin then
    self:UpdateTopItemBar()
    self:RefreshNodeBottom()
  elseif self.lotteryState == HeroRecruitState.OpenWithoutAni then
    self:StopDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.lotteryState = HeroRecruitState.All
      self:TryStateFunc()
    end, 0.3)
  elseif self.lotteryState == HeroRecruitState.QuicklyAuto then
  end
end

local function OnBtnRecruitClick(self)
  if self.lotteryState == HeroRecruitState.PlayOpenAni then
  elseif self.lotteryState == HeroRecruitState.Manual then
    self.lotteryState = HeroRecruitState.Auto
    self:RefreshNodeBottom()
    self:TryStateFunc()
  elseif self.lotteryState == HeroRecruitState.Auto then
    self.lotteryState = HeroRecruitState.All
    self:RefreshNodeBottom()
    self:TryStateFunc()
  elseif self.lotteryState == HeroRecruitState.All then
  elseif self.lotteryState == HeroRecruitState.Fin then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < sendMsgTime + 1000 then
      return
    end
    sendMsgTime = curTime
    if self.itemHave < self.recruitCost1 then
      LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self.recruitCost1 - self.itemHave)
      return
    end
    SFSNetwork.SendMessage(MsgDefines.LottoDraw, self.activityId, self.drawType)
    return
  end
end

local function OnCardItemClick(self, index)
  if self.lotteryState == HeroRecruitState.Manual and self.openCardDict[index] == nil then
    self.openCardDict[index] = 1
    self.openCardCount = self.openCardCount + 1
    self.cardPosList[index].cardItem:PlayOpenAni()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Recruit_Flip, false)
    self:TryStateFunc()
  end
end

local function OnHandleRecruitResponse(self, message)
  self:RefreshMessageData(message)
  self.drawCardTime = self.drawCardTime + 1
  self:OnOpen()
end

local function OnRefreshItems(self)
  self.itemId = self.activityTemp.ticket
  local costNum = DataCenter.ActLotteryDataManager:GetDrawNumByType(self.drawType)
  self.recruitCost1 = costNum
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
end

local function RefreshMessageData(self, message)
  self.message = message
  self.activityId = self.message.activityId
  self.drawType = self.message.type
  self.lotteryData = self.message.recordArr
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.isSkip = DataCenter.ActLotteryDataManager:GetIsSkip()
end

ActLotteryDrawResultView.OnCreate = OnCreate
ActLotteryDrawResultView.OnDestroy = OnDestroy
ActLotteryDrawResultView.OnEnable = OnEnable
ActLotteryDrawResultView.OnDisable = OnDisable
ActLotteryDrawResultView.OnAddListener = OnAddListener
ActLotteryDrawResultView.OnRemoveListener = OnRemoveListener
ActLotteryDrawResultView.ComponentDefine = ComponentDefine
ActLotteryDrawResultView.ComponentDestroy = ComponentDestroy
ActLotteryDrawResultView.DataDefine = DataDefine
ActLotteryDrawResultView.DataDestroy = DataDestroy
ActLotteryDrawResultView.OnOpen = OnOpen
ActLotteryDrawResultView.RefreshNodeBottom = RefreshNodeBottom
ActLotteryDrawResultView.UpdateTopItemBar = UpdateTopItemBar
ActLotteryDrawResultView.RefreshContentAtOpen = RefreshContentAtOpen
ActLotteryDrawResultView.RefreshItemViewByIndex = RefreshItemViewByIndex
ActLotteryDrawResultView.OnBtnRecruitClick = OnBtnRecruitClick
ActLotteryDrawResultView.OnHandleRecruitResponse = OnHandleRecruitResponse
ActLotteryDrawResultView.OnRefreshItems = OnRefreshItems
ActLotteryDrawResultView.OnCardItemClick = OnCardItemClick
ActLotteryDrawResultView.TryStateFunc = TryStateFunc
ActLotteryDrawResultView.StopDelayTimer = StopDelayTimer
ActLotteryDrawResultView.RefreshMessageData = RefreshMessageData
return ActLotteryDrawResultView
