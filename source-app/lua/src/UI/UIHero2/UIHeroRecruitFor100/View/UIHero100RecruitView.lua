local UIHero100RecruitView = BaseClass("UIHero100RecruitView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local other_title_text_path = "Root/Panel/CongrationArea/OtherTitleBg/OtherTitleText"
local top_area_text_path = "Root/Panel/CongrationArea/topAreaText"
local repeat_hero_tip_text_path = "Root/Panel/repeatHeroTipText"
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local HeroContent = require("UI.UIHero2.UIHeroRecruitFor100.Component.Hero100RecruitHeroContent")
local ItemContent = require("UI.UIHero2.UIHeroRecruitFor100.Component.Hero100RecruitItemContent")
local OpeningAni = require("UI.UIHero2.UIHeroRecruitFor100.Component.Recruit100OpeningAniViewer")
local node_bottom_path = "Root/NodeBottom"
local content_path = "Root/Panel/Scroll View/Viewport/Content"
local hero_area_content_path = "Root/Panel/Scroll View/Viewport/Content/HeroAreaContent"
local item_area_content_path = "Root/Panel/Scroll View/Viewport/Content/ItemAreaContent"
local panel_path = "Root/Panel"
local scroll_view_path = "Root/Panel/Scroll View"
local viewport_path = "Root/Panel/Scroll View/Viewport"
local select_skip_btn_path = "Root/NodeBottom/SkipRoot/SelectSkipBtn"
local select_img_path = "Root/NodeBottom/SkipRoot/SelectSkipBtn/SelectImg"
local recruit100_show_ani_path = "Recruit100ShowAni"
local bgs_path = "Bgs"
local root_path = "Root"
local sendMsgTime = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local lotteryId, message, isSkipOpenAni, isHeroDraw = self:GetUserData()
  self.isHeroDraw = isHeroDraw
  if self.isHeroDraw then
    self.lotteryHeroData = message.lotteryHero
    self.repeatHeroTipText:SetLocalText("hero_recruit_100_tips2")
  else
    self.lotteryWorkerData = message.result
    self.repeatHeroTipText:SetLocalText("worker_recruit_100_tips1")
  end
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  self.isSkipOpeningAni = isSkipOpenAni
  self:OnOpen()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.CloseRecruit100Panel, self.isHeroDraw)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/closeBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
  self.topBarCanvasGroup = self:AddComponent(UICanvasGroup, "Root/TopBar")
  self.bottomArea = self:AddComponent(UIBaseContainer, node_bottom_path)
  self.bottomCanvasGroup = self:AddComponent(UICanvasGroup, node_bottom_path)
  self.textTitle = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.textTitle:SetLocalText(110021)
  self.itemBar1 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar1")
  self.itemBar2 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar2")
  self.itemBarList = {
    self.itemBar1,
    self.itemBar2
  }
  self.TextBtn2 = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/TextBtn2")
  self.imgCost = self:AddComponent(UIImage, "Root/NodeBottom/BtnRecruit/ImgCost")
  self.textCost = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/ImgCost/TextCost")
  self.viewPort = self:AddComponent(UIBaseContainer, viewport_path)
  self.scrollContent = self:AddComponent(UIBaseContainer, content_path)
  self.heroRowContent = self:AddComponent(HeroContent, hero_area_content_path)
  self.scrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scrollView:AddValueChangeListener(function()
    self:UpdateOnContentRoll()
  end)
  self.heroRowContent:Init(self.scrollView, self.viewPort, self.scrollContent)
  self.itemContent = self:AddComponent(ItemContent, item_area_content_path)
  self.btnRecruit = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit")
  self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.cardRoot = self:AddComponent(UIBaseContainer, panel_path)
  self.congrationTitleText = self:AddComponent(UIText, other_title_text_path)
  self.congrationTitleText:SetLocalText(128027)
  self.recruitGetTipText = self:AddComponent(UIText, top_area_text_path)
  self.recruitGetTipText:SetLocalText("hero_recruit_100_tips1")
  self.repeatHeroTipText = self:AddComponent(UIText, repeat_hero_tip_text_path)
  self.scrollViewMask = self.transform:Find(viewport_path):GetComponent(typeof(CS.UnityEngine.UI.Mask))
  self.scrollViewImg = self.transform:Find(viewport_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.openingAniViewer = self:AddComponent(OpeningAni, recruit100_show_ani_path)
  self.bgObj = self:AddComponent(UIBaseContainer, bgs_path)
  self.rootObj = self:AddComponent(UIBaseContainer, root_path)
  self.heroCardContentAni = self:AddComponent(UISimpleAnimation, hero_area_content_path)
  self.skipToggleBtn = self:AddComponent(UIButton, select_skip_btn_path)
  self.skipToggleBtn:SetOnClick(function()
    self:ClickChangeSkipBtn()
  end)
  self.skipSelectImgObj = self:AddComponent(UIBaseContainer, select_img_path)
  self.rootCanvasGroup = self:AddComponent(UICanvasGroup, root_path)
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.topBar = nil
  self.topBarCanvasGroup = nil
  self.bottomArea = nil
  self.bottomCanvasGroup = nil
  self.textTitle = nil
  self.itemBar1 = nil
  self.itemBar2 = nil
  self.itemBarList = nil
  self.scrollContent = nil
  self.heroRowContent = nil
  self.itemContent = nil
  self.btnRecruit = nil
  self.TextBtn2 = nil
  self.imgCost = nil
  self.textCost = nil
  self.contentLayout = nil
  self.scrollView = nil
  self.congrationTitleText = nil
  self.recruitGetTipText = nil
  self.repeatHeroTipText = nil
  self.scrollViewMask = nil
  self.scrollViewImg = nil
  self.openingAniViewer = nil
  self.bgObj = nil
  self.rootObj = nil
  self.heroCardContentAni = nil
  self.skipToggleBtn = nil
  self.skipSelectImgObj = nil
end

local function DataDefine(self)
  self.lotteryData = nil
  self.lotteryHeroData = nil
  self.lotteryWorkerData = nil
  self.displayResultTimer = nil
  self.closeEnterAniTimer = nil
  self.flipTimer = nil
  self.scrollMoveTween = nil
  self.curScrollMoveTarget = Vector2(0, 0)
  self.scrollContentHeight = 0
  self.scrollViewHeight = 0
  self.isPlaySplitTime = nil
  self.bottomTween = nil
  self.viewPortAnchorY = -self.viewPort.transform.rect.height * 0.3
end

local function DataDestroy(self)
  self:StopAllTimer()
  self:StopTween()
  self.lotteryData = nil
  self.lotteryHeroData = nil
  self.lotteryWorkerData = nil
  self.curScrollMoveTarget = nil
  self.scrollContentHeight = nil
  self.scrollViewHeight = nil
  self.flipIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse_Hero)
  self:AddUIListener(EventId.WorkericRecruitmentData, self.OnHandleRecruitResponse_Worker)
  self:AddUIListener(EventId.ToggleRecruitScene, self.OnToggleRecruitScene)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse_Hero)
  self:RemoveUIListener(EventId.WorkericRecruitmentData, self.OnHandleRecruitResponse_Worker)
  self:RemoveUIListener(EventId.ToggleRecruitScene, self.OnToggleRecruitScene)
end

local function OnOpen(self)
  self:StopAllTimer()
  if self.isHeroDraw then
    self:ParseData_Hero()
  else
    self:ParseData_Worker()
  end
  local costItems = self.lotteryData:GetHundredCost()
  self.itemId = costItems.itemId
  self.costNum = costItems.itemNum
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self.openCardDict = {}
  self.openCardCount = 0
  self.flipIndex = 0
  self.isNeedShowRepeatHeroTips = false
  self.scrollContent.transform.anchoredPosition = Vector3(0, 0, 0)
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
  self.scrollViewHeight = self.scrollView.transform.rect.height
  self:ShowEnterAni()
end

local function OnHandleRecruitResponse_Hero(self, message)
  local lotteryHeroData = message.lotteryHero
  self.lotteryHeroData = lotteryHeroData
  self:OnOpen()
end

local function OnHandleRecruitResponse_Worker(self, message)
  local lotteryWorkerData = message.result
  self.lotteryWorkerData = lotteryWorkerData
  self:OnOpen()
end

function UIHero100RecruitView:ParseData_Hero()
  local allHeroDataList = {}
  local allItemDataList = {}
  for k, v in ipairs(self.lotteryHeroData) do
    local data = v
    local type = data.type
    local id = data.id
    if type == 2 then
      local itemId = data.GoodsId
      local num = data.addNumber
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
        local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(toInt(itemTemplate.para2))
        if not string.IsNullOrEmpty(heroUuid) then
          local heroPieces = GetTableData(HeroUtils.GetLWHeroXmlName(), toInt(itemTemplate.para2), "hero_pieces")
          if table.count(heroPieces) == 2 and num >= toInt(heroPieces[2]) then
            data.uuid = heroUuid
            local heroNum = num // heroPieces[2]
            for j = 1, heroNum do
              local fakeHeroCardData = DeepCopy(data)
              fakeHeroCardData.addNumber = heroPieces[2]
              table.insert(allHeroDataList, fakeHeroCardData)
            end
            local remainChipNum = num % 10
            if remainChipNum <= 0 then
              goto lbl_98
            end
            data.addNumber = remainChipNum
          end
        end
      end
    end
    if type == 0 then
      table.insert(allHeroDataList, v)
    elseif type == 5 or type == 2 then
      table.insert(allItemDataList, v)
    end
    ::lbl_98::
  end
  self.allHeroDataList = allHeroDataList
  self.allItemDataList = allItemDataList
  self:SortHeroDataList_Hero(self.allHeroDataList)
  self:SortItemDataList_Hero(self.allItemDataList)
end

function UIHero100RecruitView:SortHeroDataList_Hero(heroDataList)
  table.sort(heroDataList, function(a, b)
    local heroAUuid = a.uuid
    if not heroAUuid then
      return false
    end
    local heroBUuid = b.uuid
    if not heroBUuid then
      return false
    end
    local heroAData = DataCenter.HeroDataManager:GetHeroByUuid(heroAUuid)
    if not heroAData then
      return false
    end
    local heroBData = DataCenter.HeroDataManager:GetHeroByUuid(heroBUuid)
    if not heroBData then
      return false
    end
    if heroAData.quality ~= heroBData.quality then
      return heroAData.quality > heroBData.quality
    end
    return heroAData.heroId > heroBData.heroId
  end)
end

function UIHero100RecruitView:SortItemDataList_Hero(itemDataList)
  table.sort(itemDataList, function(a, b)
    local typeA = a.type
    local typeB = b.type
    if typeA ~= typeB then
      return typeA < typeB
    end
    if typeA == 5 then
      local idA = a.id
      local idB = b.id
      local qualityA = DataCenter.ResourceItemDataManager:GetResourceItemQuality(idA)
      local qualityB = DataCenter.ResourceItemDataManager:GetResourceItemQuality(idB)
      if qualityA ~= qualityB then
        return qualityA > qualityB
      end
      return idA > idB
    elseif typeA == 2 then
      local idA = a.GoodsId
      local idB = b.GoodsId
      local itemTemplateA = DataCenter.ItemTemplateManager:GetItemTemplate(idA)
      local itemTemplateB = DataCenter.ItemTemplateManager:GetItemTemplate(idB)
      if itemTemplateA.recruitOrder ~= itemTemplateB.recruitOrder then
        return itemTemplateA.recruitOrder > itemTemplateB.recruitOrder
      end
      if itemTemplateA.order ~= itemTemplateB.order then
        return itemTemplateA.order < itemTemplateB.order
      end
      if itemTemplateA.quality ~= itemTemplateB.quality then
        return itemTemplateA.quality > itemTemplateB.quality
      end
      return itemTemplateA.id < itemTemplateB.id
    end
  end)
end

function UIHero100RecruitView:ParseData_Worker()
  local allHeroDataList = {}
  local allItemDataList = {}
  for k, v in ipairs(self.lotteryWorkerData) do
    local data = v
    local type = data.type
    local id = data.value.id
    local num = data.value.num
    if type == RewardType.GOODS then
      if id == "510050" then
        table.insert(allItemDataList, v)
      else
        local goodsNum = num // 10
        while 0 < goodsNum do
          local fakeData = DeepCopy(data)
          fakeData.value.num = 10
          table.insert(allHeroDataList, fakeData)
          goodsNum = goodsNum - 1
        end
        local remainNum = num % 10
        if 0 < remainNum then
          data.value.num = remainNum
          table.insert(allItemDataList, data)
        end
      end
    elseif type == RewardType.WORKER then
      table.insert(allHeroDataList, v)
    else
      Logger.LogError("UIHero100RecruitView   \229\185\184\229\173\152\232\128\133\231\153\190\230\138\189\228\184\139\229\143\145\228\186\134\230\156\170\231\159\165\231\177\187\229\158\139\231\154\132\229\165\150\229\138\177\239\188\154" .. type)
    end
  end
  self.allHeroDataList = allHeroDataList
  self.allItemDataList = allItemDataList
  self:SortHeroDataList_Worker(self.allHeroDataList)
  self:SortItemDataList_Worker(self.allItemDataList)
end

function UIHero100RecruitView:SortHeroDataList_Worker(heroDataList)
  table.sort(heroDataList, function(a, b)
    if a.value == nil then
      return false
    end
    if b.value == nil then
      return false
    end
    local workerIdA = a.value.workerId
    if workerIdA == nil then
      local itemATemplate = DataCenter.ItemTemplateManager:GetItemTemplate(a.value.id)
      if itemATemplate == nil then
        return false
      end
      workerIdA = tonumber(itemATemplate.para2)
    end
    local workerATemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerIdA)
    if workerATemplate == nil then
      return false
    end
    local qualityA = workerATemplate.quality
    local workerIdB = b.value.workerId
    if workerIdB == nil then
      local itemBTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(b.value.id)
      if itemBTemplate == nil then
        return false
      end
      workerIdB = tonumber(itemBTemplate.para2)
    end
    local workerBTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerIdB)
    if workerBTemplate == nil then
      return false
    end
    local qualityB = workerBTemplate.quality
    if qualityA ~= qualityB then
      return qualityA > qualityB
    end
    return workerIdA > workerIdB
  end)
end

function UIHero100RecruitView:SortItemDataList_Worker(itemDataList)
  table.sort(itemDataList, function(a, b)
    if a.value == nil or a.value.id == nil then
      return false
    end
    if b.value == nil or b.value.id == nil then
      return false
    end
    local itemATemplate = DataCenter.ItemTemplateManager:GetItemTemplate(a.value.id)
    if itemATemplate == nil then
      return false
    end
    local itemBTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(b.value.id)
    if itemBTemplate == nil then
      return false
    end
    if itemATemplate.color ~= itemBTemplate.color then
      return itemATemplate.color > itemBTemplate.color
    end
    return itemATemplate.id > itemBTemplate.id
  end)
end

function UIHero100RecruitView:UpdateTopItemBar()
  local goldIndex = 2
  local itemIndex = 1
  self.itemBarList[goldIndex]:SetActive(true)
  self.itemBarList[goldIndex]:SetData(nil, ResourceType.Gold)
  self.itemBarList[itemIndex]:SetActive(true)
  self.itemBarList[itemIndex]:SetData(self.itemId)
end

function UIHero100RecruitView:RefreshNodeBottom()
  local item = DataCenter.ItemData:GetItemByItemId(tonumber(self.itemId))
  local itemCount = item and item.count or 0
  self.btnRecruit:SetActive(itemCount >= self.costNum)
  if itemCount < self.costNum then
    return
  end
  self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
  self.textCost:SetText(self.costNum)
  self.TextBtn2:SetLocalText("hero_recruit_100_tips4")
  self:UpdateSkipToggleState()
end

function UIHero100RecruitView:OnBtnRecruitClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 3000 then
    return
  end
  sendMsgTime = curTime
  if self.isHeroDraw then
    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 2, 0, self.itemId)
  else
    SFSNetwork.SendMessage(MsgDefines.LotteryWorkerCard, 0, 2, tonumber(self.lotteryData.id))
  end
end

local function OnRefreshItems(self)
  local costItems = self.lotteryData:GetHundredCost()
  self.itemId = costItems.itemId
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
end

function UIHero100RecruitView:ExecuteNextAniStep()
  if not self.heroRowContent:IsAniAllFinish() then
    self.flipIndex = self.flipIndex + 1
    return self.heroRowContent:ExecuteOneAniStep()
  end
  if not self.itemContent:IsAniAllFinish() then
    self.flipIndex = self.flipIndex + 1
    return self.itemContent:ExecuteOneAniStep()
  end
  self:OnAllAniFinish()
end

function UIHero100RecruitView:OnAniStartPlay()
  self:StopAllTimer()
  self:StopTween()
  self.repeatHeroTipText.gameObject:SetActive(false)
  self.curScrollMoveTarget = Vector2(0, 0)
  self.scrollView:SetEnable(false)
  self.scrollViewMask.enabled = false
  self.scrollViewImg.enabled = false
end

function UIHero100RecruitView:OnAllAniFinish()
  self:StopTween()
  self.itemContent:ShowAllItem()
  self.scrollMoveTween = self.scrollContent.transform:DOLocalMoveY(0, 0.5):SetDelay(0.85):OnUpdate(function()
    self:UpdateOnContentRoll()
  end)
  
  function self.scrollMoveTween.onComplete()
    self.scrollView:SetEnable(true)
    self.scrollMoveTween = nil
  end
  
  self.scrollViewMask.enabled = true
  self.scrollViewImg.enabled = true
  self:CheckIsNeedShowRepeatHeroTips()
  self.topBarCanvasGroup.alpha = 0
  self.topBar.gameObject:SetActive(true)
  self.topBarTween = self.topBarCanvasGroup:FadeIn(0.5)
  self.topBarTween:OnComplete(function()
    self.topBarTween = nil
  end)
  self.bottomCanvasGroup.alpha = 0
  self.bottomArea.gameObject:SetActive(true)
  self.bottomTween = self.bottomCanvasGroup:FadeIn(0.5)
  self.bottomTween:OnComplete(function()
    self.bottomTween = nil
  end)
end

function UIHero100RecruitView:IsAniAllFinish()
  return self.heroRowContent:IsAniAllFinish() and self.itemContent:IsAniAllFinish()
end

function UIHero100RecruitView:StartPlayFlipCardAni()
  local aniTime, screenPos, isRepeatHeroChip = self:ExecuteNextAniStep()
  if not aniTime or not screenPos then
    return
  end
  if self.flipTimer then
    self.flipTimer:Stop()
  end
  if self.flipIndex == #self.allHeroDataList then
    aniTime = aniTime + 0.2
  end
  if screenPos then
    self:ContentYMoveCheck(screenPos)
  end
  self.flipTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:StartPlayFlipCardAni()
  end, aniTime)
  if isRepeatHeroChip then
    self.isNeedShowRepeatHeroTips = true
  end
end

function UIHero100RecruitView:PauseFlipCardAni()
  if self.flipTimer then
    self.flipTimer:Stop()
  end
end

function UIHero100RecruitView:StopAllTimer()
  if self.displayResultTimer then
    self.displayResultTimer:Stop()
    self.displayResultTimer = nil
  end
  if self.closeEnterAniTimer then
    self.closeEnterAniTimer:Stop()
    self.closeEnterAniTimer = nil
  end
  if self.flipTimer then
    self.flipTimer:Stop()
    self.flipTimer = nil
  end
end

function UIHero100RecruitView:ShowEnterAni()
  self:OnAniStartPlay()
  self:SetRootShowHideState(false)
  if not self.isSkipOpeningAni then
    local allHeroCardScreenPos = self:GetAllHeroCardScreenPos()
    local heroCardQualityInfo = self:GetHeroCardQuality()
    self.openingAniViewer:StartShowOpeningAni(allHeroCardScreenPos, heroCardQualityInfo, function()
      self:ShowRecruitRewardResult()
    end)
  else
    self:ShowRecruitRewardResult()
  end
end

function UIHero100RecruitView:GetHeroCardQuality()
  local ret = {}
  if self.isHeroDraw then
    for _, v in ipairs(self.allHeroDataList) do
      local heroUuid = v.uuid
      if heroUuid then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData then
          table.insert(ret, heroData.quality)
        end
      end
    end
  else
    for _, v in ipairs(self.allHeroDataList) do
      local type = v.type
      if type == RewardType.WORKER then
        local workerId = v.value.workerId
        local temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerId)
        table.insert(ret, temp.quality)
      elseif type == RewardType.GOODS then
        local itemId = tonumber(v.value.id)
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        local color = itemTemplate.color
        local workerTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(tonumber(itemTemplate.para2))
        local quality = workerTemplate.quality or color
        table.insert(ret, quality)
      end
    end
  end
  return ret
end

function UIHero100RecruitView:ShowRecruitRewardResult()
  self.heroRowContent:SetData(self.allHeroDataList, self.isHeroDraw, function()
    self.itemContent:InstRewardItem()
    self:OnAllItemLoadFinish()
  end)
  self.itemContent:SetData(self.allItemDataList, self.isHeroDraw)
end

function UIHero100RecruitView:OnAllItemLoadFinish()
  self:SetRootShowHideState(true)
  self.topBar.gameObject:SetActive(false)
  self.bottomArea.gameObject:SetActive(false)
  self.btnClose.gameObject:SetActive(false)
  self.cardRoot:SetActive(false)
  self.cardRoot:SetActive(true)
  self.btnClose.gameObject:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.transform)
  local maxCardAniCount = math.min(#self.allHeroDataList, 9)
  self.heroCardContentAni:Enable(true)
  local ret, carFlyAniTime = self.heroCardContentAni:PlayAnimationReturnTime(string.format("Card%s", maxCardAniCount))
  self.heroRowContent:PlayCardFlyEff()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Recruit100OrangeItemShow)
  if not ret then
    carFlyAniTime = 1
  end
  self.displayResultTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.heroCardContentAni:Enable(false)
    self:StartPlayFlipCardAni()
  end, carFlyAniTime)
end

function UIHero100RecruitView:OnToggleRecruitScene(visible)
  if visible then
    self:StartPlayFlipCardAni()
  else
    self:PauseFlipCardAni()
  end
end

function UIHero100RecruitView:ContentYMoveCheck(curCardScreenPos)
  if not self.scrollContent or not curCardScreenPos then
    return
  end
  local cardScreenPosInViewPort = PosConverse.ScreenToUIPos(self.viewPort.transform, curCardScreenPos)
  if cardScreenPosInViewPort.y > self.viewPortAnchorY then
    return
  end
  self.scrollViewMask.enabled = true
  self.scrollViewImg.enabled = true
  self:CheckIsNeedShowRepeatHeroTips()
  self.scrollContentHeight = self.scrollContent.transform.rect.height
  if self.scrollContentHeight <= self.scrollViewHeight then
    return
  end
  local moveDistance = self.viewPortAnchorY - cardScreenPosInViewPort.y
  local targetPos = self.scrollContent.transform.anchoredPosition + Vector2(0, moveDistance)
  local maxPosY = self.scrollContentHeight - self.scrollViewHeight
  if maxPosY < targetPos.y then
    targetPos = Vector2(targetPos.x, maxPosY)
  end
  if math.abs(targetPos.y - self.curScrollMoveTarget.y) < 0.1 then
    return
  end
  self:StopTween()
  self.curScrollMoveTarget = targetPos
  self.scrollMoveTween = self.scrollContent.transform:DOLocalMoveY(self.curScrollMoveTarget.y, 1):OnUpdate(function()
    self:UpdateOnContentRoll()
  end)
end

function UIHero100RecruitView:StopTween()
  if self.scrollMoveTween then
    self.scrollMoveTween:Kill()
    self.scrollMoveTween = nil
  end
  if self.bottomTween then
    self.bottomTween:Kill()
    self.bottomTween = nil
  end
  if self.topBarTween then
    self.topBarTween:Kill()
    self.topBarTween = nil
  end
  if self.repeatTextTween then
    self.repeatTextTween:Kill()
    self.repeatTextTween = nil
  end
end

function UIHero100RecruitView:GetAllHeroCardScreenPos()
  if not self.heroRowContent then
    return {}
  end
  return self.heroRowContent:GetAllHeroCardScreenPos()
end

function UIHero100RecruitView:ClickChangeSkipBtn()
  self.isSkipOpeningAni = not self.isSkipOpeningAni
  if self.isHeroDraw then
    CommonUtil.PlayerPrefsSetBool("Recruit100SkipState", self.isSkipOpeningAni)
  else
    CommonUtil.PlayerPrefsSetBool("WorkerRecruit100SkipState", self.isSkipOpeningAni)
  end
  self:UpdateSkipToggleState()
end

function UIHero100RecruitView:UpdateSkipToggleState()
  self.skipSelectImgObj.gameObject:SetActive(self.isSkipOpeningAni)
end

function UIHero100RecruitView:CheckIsNeedShowRepeatHeroTips()
  if self.isNeedShowRepeatHeroTips then
    self.repeatTextTween = self.repeatHeroTipText:DOFade(1, 0.5)
    self.repeatTextTween:OnComplete(function()
      self.repeatTextTween = nil
    end)
    self.repeatHeroTipText.gameObject:SetActive(true)
  end
end

function UIHero100RecruitView:SetRootShowHideState(isShow)
  self.rootCanvasGroup:SetAlpha(isShow and 1 or 0)
  self.rootCanvasGroup:SetInteractable(isShow)
end

function UIHero100RecruitView:UpdateOnContentRoll()
  if self.heroRowContent then
    self.heroRowContent:UpdateOnContentRoll()
  end
end

UIHero100RecruitView.OnCreate = OnCreate
UIHero100RecruitView.OnDestroy = OnDestroy
UIHero100RecruitView.OnEnable = OnEnable
UIHero100RecruitView.OnDisable = OnDisable
UIHero100RecruitView.ComponentDefine = ComponentDefine
UIHero100RecruitView.ComponentDestroy = ComponentDestroy
UIHero100RecruitView.DataDefine = DataDefine
UIHero100RecruitView.DataDestroy = DataDestroy
UIHero100RecruitView.OnAddListener = OnAddListener
UIHero100RecruitView.OnRemoveListener = OnRemoveListener
UIHero100RecruitView.OnOpen = OnOpen
UIHero100RecruitView.OnHandleRecruitResponse_Hero = OnHandleRecruitResponse_Hero
UIHero100RecruitView.OnHandleRecruitResponse_Worker = OnHandleRecruitResponse_Worker
UIHero100RecruitView.OnRefreshItems = OnRefreshItems
return UIHero100RecruitView
