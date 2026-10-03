local UILWScienceMainView = BaseClass("UILWScienceMainView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Item = require("UI.UILWScience.UILWScienceMain.Component.UILWScienceMainItem")
local queueItem = require("UI.UILWScience.UILWScienceMain.Component.UILWScienceQueueItem")
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path = "Root/BottomBar/BtnBack"
local recommend_go_path = "Root/MiddleContentContainer/Recommend"
local recommend_icon_path = "Root/MiddleContentContainer/Recommend/Science/Icon"
local recommend_lv_txt_path = "Root/MiddleContentContainer/Recommend/Science/LvTxt"
local recommend_name_txt_path = "Root/MiddleContentContainer/Recommend/Name"
local recommend_btn_path = "Root/MiddleContentContainer/Recommend/Btn"
local recommend_btn_txt_path = "Root/MiddleContentContainer/Recommend/Btn/Txt"
local scroll_path = "Root/MiddleContentContainer/Bg/Scroll"
local content_path = "Root/MiddleContentContainer/Bg/Scroll/Viewport/Content"
local viewport_path = "Root/MiddleContentContainer/Bg/Scroll/Viewport"
local researching_go_path = "Root/MiddleContentContainer/Researching"
local researching_btn_path = "Root/MiddleContentContainer/Researching/Btn2"
local researching_btn_name_path = "Root/MiddleContentContainer/Researching/Btn2/Txt2"
local researching_icon_path = "Root/MiddleContentContainer/Researching/Science/Icon2"
local researching_level_path = "Root/MiddleContentContainer/Researching/Science/LvTxt2"
local researching_slider_path = "Root/MiddleContentContainer/Researching/Slider"
local researching_left_time_path = "Root/MiddleContentContainer/Researching/Slider/SliderText2"
local middle_content_container_path = "Root/MiddleContentContainer"
local root_container_path = "Root"
local research_queues_path = "Root/BottomBar/ResearchQueues"
local TITLE_TXT = GameDialogDefine.SCIENCE
local RECOMMEND_TXT = 110003
local SliderLength = 196

function UILWScienceMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Technology_UI, false)
end

function UILWScienceMainView:ClearQueuesInfoScroll()
  if self.queuesContent then
    self.queuesContent:RemoveComponents(queueItem)
  end
  for i, v in ipairs(self.loadRequest) do
    self:GameObjectDestroy(v)
  end
end

function UILWScienceMainView:OnDestroy()
  self:RestoreContentHeight()
  self:ClearQueuesInfoScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceMainView:OnItemMoveIn(itemObj, index)
  local cellItem = self.scrollCellPool[itemObj.name]
  if not cellItem then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    cellItem = self.scroll:AddComponent(Item, itemObj)
    self.scrollCellPool[name] = cellItem
    self.itemIndex = self.itemIndex + 1
  end
  local tabInfo = self.allTab[index]
  local param = {}
  param.template = tabInfo
  if self.researchTabList[param.template.id] ~= nil then
    param.isResearching = true
    param.isResearchingScienceId = self.researchTabList[param.template.id]
  else
    param.isResearching = false
    param.isResearchingScienceId = 0
  end
  if self.gotoTab ~= nil and self.gotoTab == tabInfo.id and self.isNeedRollTargetTable then
    param.isLightFrame = true
  end
  cellItem:SetData(param)
end

function UILWScienceMainView:OnItemMoveOut(itemObj, index)
end

function UILWScienceMainView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.recommendGo = self:AddComponent(UIBaseContainer, recommend_go_path)
  self.recommendIcon = self:AddComponent(UIImage, recommend_icon_path)
  self.recommendLvText = self:AddComponent(UIText, recommend_lv_txt_path)
  self.recommendNameText = self:AddComponent(UIText, recommend_name_txt_path)
  self.recommendBtn = self:AddComponent(UIButton, recommend_btn_path)
  self.recommendBtn:SetOnClick(function()
    self:OnClickRecommendBtn()
  end)
  self.recommendBtnTxt = self:AddComponent(UIText, recommend_btn_txt_path)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middle_content_container_path)
  self.rootContainer = self:AddComponent(UIBaseContainer, root_container_path)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.middleContentContainer.transform)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIGridLayoutGroup, content_path)
  self.viewport = self:AddComponent(UIBaseContainer, viewport_path)
  local viewportSize = self.viewport.rectTransform.rect.size
  local viewportWidthX = viewportSize.x
  local cellSize = self.content:GetCellSize()
  local cellSizeX = cellSize.x
  local cellSpacing = self.content:GetCellSpacing()
  local cellSpacingX = cellSpacing.x
  local padding = self.content:GetCellPadding()
  local paddingX = padding.left + padding.right
  local realViewportWidthX = viewportWidthX - paddingX
  local constraintCount = math.floor((realViewportWidthX + cellSpacingX) / (cellSizeX + cellSpacingX))
  if constraintCount <= 0 then
    constraintCount = 1
  end
  self.content:SetConstraintCount(constraintCount)
  self.researching_go = self:AddComponent(UIBaseContainer, researching_go_path)
  self.researching_btn = self:AddComponent(UIButton, researching_btn_path)
  self.researching_btn:SetOnClick(function()
    self:OnResearchingBtnClick()
  end)
  self.researching_btn_name = self:AddComponent(UIText, researching_btn_name_path)
  self.researching_icon = self:AddComponent(UIImage, researching_icon_path)
  self.researching_level = self:AddComponent(UIText, researching_level_path)
  self.researching_slider = self:AddComponent(UISlider, researching_slider_path)
  self.researching_left_time = self:AddComponent(UIText, researching_left_time_path)
  self.giftTitle = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/giftTitle")
  self.giftBuyBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/giftTitle/giftBuyBtn")
  self.giftBuyBtnText = self:AddComponent(UIText, "Root/MiddleContentContainer/giftTitle/giftBuyBtn/giftBuyBtnText")
  self.blackTimeBgImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/blackTimeBg")
  self.giftBuyBtn:SetOnClick(function()
    DataCenter.ScienceManager:OpenScienceGiftView()
    local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
    if data then
      GoToUtil.GotoPos(data:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime)
    end
    self.ctrl:CloseSelf()
  end)
  self.recommendBtnTxt:SetLocalText(RECOMMEND_TXT)
  self.titleText:SetLocalText(TITLE_TXT)
  self.queuesContent = self:AddComponent(UIBaseContainer, research_queues_path)
  self.queuesContentLayout = self:AddComponent(UIGridLayoutGroup, research_queues_path)
  local contentWidth, contentHeight = self.middleContentContainer.rectTransform:Get_sizeDelta()
  self.middleContentOriWidth = contentWidth
  self.middleContentOriHeight = contentHeight
end

function UILWScienceMainView:ComponentDestroy()
  self:ClearItemCell()
  self.titleText = nil
  self.closeBtn = nil
  self.recommendGo = nil
  self.recommendIcon = nil
  self.recommendLvText = nil
  self.recommendNameText = nil
  self.recommendBtn = nil
  self.recommendBtnTxt = nil
  self.scroll = nil
  self.content = nil
  self.researchingActive = nil
  self.giftTitle = nil
  self.giftBuyBtn = nil
  self.giftBuyBtnText = nil
  self.scroll_view = nil
  self.queuesContent = nil
  self.queuesContentLayout = nil
  self.middleContentOriWidth = nil
  self.middleContentOriHeight = nil
end

function UILWScienceMainView:DataDefine()
  self.ctrl:SetView(self)
  self.researchingActive = nil
  self.researchScienceList = {}
  self.researchTabList = {}
  self.gotoTab = nil
  self.queue = nil
  self.bUuid = nil
  self.reachingScienceList = {}
  self.lastChangeTime = 0
  self.init = false
  self.loadRequest = {}
  self.queuesInfoCells = {}
end

function UILWScienceMainView:DataDestroy()
  self.ctrl:ClearView()
  self.researchScienceList = nil
  self.researchTabList = nil
  self.gotoTab = nil
  self.queue = nil
  self.bUuid = nil
  self.reachingScienceList = nil
  self.lastChangeTime = nil
  self.init = nil
  self.isNeedRollTargetTable = nil
end

function UILWScienceMainView:OnEnable()
  base.OnEnable(self)
  self:InitUI()
end

function UILWScienceMainView:OnDisable()
  base.OnDisable(self)
  self.isNeedRollTargetTable = nil
end

function UILWScienceMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.OnScienceHelpSignal)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.OnMonthCardUpdateSignal)
  self:AddUIListener(EventId.ScienceRecommendDataDirty, self.OnScienceRecommendSignal)
  self:AddUIListener(EventId.ScienceTabProgressDataChanged, self.OnScienceTabProgressDataChangedSignal)
end

function UILWScienceMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.OnScienceHelpSignal)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.OnMonthCardUpdateSignal)
  self:RemoveUIListener(EventId.ScienceRecommendDataDirty, self.OnScienceRecommendSignal)
  self:RemoveUIListener(EventId.ScienceTabProgressDataChanged, self.OnScienceTabProgressDataChangedSignal)
end

function UILWScienceMainView:InitUI()
  local tab, bUuid, isNeedRollTargetTable = self:GetUserData()
  self.bUuid = bUuid
  self.isNeedRollTargetTable = isNeedRollTargetTable or false
  if not string.IsNullOrEmpty(tab) then
    self.gotoTab = tonumber(tab)
  else
    self.gotoTab = ScienceTab.Resource
  end
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
  self.scienceUid = data.uuid
  self:RefreshAll()
  DataCenter.ScienceDataManager:SendScienceTabProgressGetMessage()
end

function UILWScienceMainView:OnSelectViewBtnClick(itemId)
  local data = DataCenter.BuildManager:GetFunbuildByItemID(itemId)
  if data then
    self.bUuid = data.uuid
    self.gotoTab = ScienceTab.Resource
    self:RefreshAll()
  end
end

function UILWScienceMainView:RefreshAll()
  if not (self.bUuid and self.gotoTab) or self.gotoTab <= 0 then
    return
  end
  self:RefreshSelectViewBtn()
  self:RefreshResearching()
  self:ShowGridCells()
  self:QueueTimeEndSignal(NewQueueType.Science)
end

function UILWScienceMainView:RefreshSelectViewBtn()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if buildData.itemId == BuildingTypes.FUN_BUILD_SCIENE then
    local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
    if data then
      if data.level == 0 then
        local pack = DataCenter.ScienceManager:GetGiftPack()
        if pack then
          self.giftBuyBtnText:SetText(pack:getPriceText())
        end
      end
      local isOn = data.level == 0
      self.giftTitle:SetActive(isOn)
    else
      self.giftTitle:SetActive(false)
    end
  else
    self.giftTitle:SetActive(false)
  end
end

function UILWScienceMainView:RefreshResearching()
  self.queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.researchScienceList = {}
  self.researchTabList = {}
  table.walk(self.queueList, function(k, v)
    if v ~= nil and v:GetQueueState() ~= NewQueueState.Free then
      local scienceId = tonumber(v.itemId)
      local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        if not self.researchTabList[template.tab] then
          self.researchTabList[template.tab] = {}
        end
        table.insert(self.researchTabList[template.tab], scienceId)
        self.researchScienceList[v.uuid] = false
      end
    end
  end)
  self:RefreshRecommend()
  self:ClearQueuesInfoScroll()
  local queueCount = #self.queueList
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
  if data and data.level == 0 then
    queueCount = queueCount + 1
  end
  self:ReSetCellSizeByCellCount(queueCount)
  for i = 1, queueCount do
    self:GenQueuesInfoCell(i, queueCount)
  end
end

function UILWScienceMainView:RefreshRecommend()
  if table.count(self.researchTabList) > 0 then
    self.recommendGo:SetActive(false)
  else
    local recommendID = self.ctrl:GetRecommendScience()
    self.recommendId = recommendID
    if not recommendID then
      self.recommendGo:SetActive(false)
    else
      self.recommendGo:SetActive(true)
      local template = DataCenter.ScienceManager:GetScienceTemplate(recommendID)
      if template then
        self.recommendIcon:LoadSprite(string.format(LoadPath.UILWScience, template.icon))
        local curLv = DataCenter.ScienceManager:GetScienceLevel(recommendID)
        local maxLv = DataCenter.ScienceManager:GetScienceMaxLevel(recommendID)
        self.recommendLvText:SetText(curLv .. "/" .. maxLv)
        self.recommendNameText:SetLocalText(template.name)
      else
        self.recommendGo:SetActive(false)
      end
    end
  end
end

function UILWScienceMainView:ShowResearching()
  self.queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
  if self.queue == nil or self.queue:GetQueueState() == NewQueueState.Free or self.queue:GetQueueState() == NewQueueState.Finish then
    self.queue = nil
    self:SetResearchingActive(false)
  else
    if self.queue.itemId ~= nil and self.queue.itemId ~= "" then
      local scienceId = tonumber(self.queue.itemId)
      self:SetResearchingActive(true)
      local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
        local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
        if curLevel < maxLevel then
          self.researching_icon:LoadSprite(string.format(LoadPath.UILWScience, template.icon))
          self.researching_level:SetText(curLevel .. "/" .. maxLevel)
        end
      end
    end
    self:RefreshResearchingBtnName()
  end
  local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.reachingScienceList = {}
  table.walk(queueList, function(k, v)
    if v ~= nil and v:GetQueueState() ~= NewQueueState.Free then
      local scienceId = tonumber(v.itemId)
      local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        self.reachingScienceList[scienceId] = v
      end
    end
  end)
end

function UILWScienceMainView:Update()
  if self.reachingScienceList ~= nil and table.count(self.reachingScienceList) > 0 then
    self:UpdateLeftTime()
  end
end

function UILWScienceMainView:UpdateLeftTime(forceRefresh)
  if self.queue ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.queue.endTime - curTime
    local maxTime = self.queue.endTime - self.queue.startTime
    if changeTime < maxTime and 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime or forceRefresh then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.researching_left_time:SetText(tempTimeValue)
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.lastChangeTime, maxTime, SliderLength) then
          self.lastChangeTime = changeTime
          self.researching_slider:SetValue(tempValue)
        end
      end
    else
      self.laseTime = 0
      self.researching_slider:SetValue(0)
      self.researching_left_time:SetText("")
      return
    end
  end
  if self.needUpdateCell ~= nil and 0 < table.count(self.needUpdateCell) then
    table.walk(self.needUpdateCell, function(k, v)
      local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(k))
      if queue ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = queue.endTime - curTime
        local maxTime = queue.endTime - queue.startTime
        if changeTime < maxTime and 0 < changeTime then
          local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
          if v ~= nil then
            v:SetSliderText(tempTimeValue)
            local tempValue = 1 - changeTime / maxTime
            v:SetSliderValue(tempValue)
          end
          if 0 < maxTime then
            local tempValue = 1 - changeTime / maxTime
            if v ~= nil then
              v:SetSliderValue(tempValue)
            end
          end
        else
          if v ~= nil then
            v:SetSliderValue(0)
            v:SetSliderText("")
            v:ResetResearchState(false)
          end
          return
        end
      end
    end)
  end
end

function UILWScienceMainView:SetResearchingActive(value)
  if self.researchingActive ~= value then
    self.researchingActive = value
    self.researching_go:SetActive(value)
    self.blackTimeBgImg:SetActive(value)
  end
end

function UILWScienceMainView:RefreshResearchingBtnName()
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    self.researching_btn_name:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
  elseif self:IsUseHeroFreeAddTime() then
    self.researching_btn_name:SetLocalText(130126)
  else
    self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
  end
end

function UILWScienceMainView:OnResearchingBtnClick()
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.queue.uuid, AllianceHelpType.Queue, NewQueueType.Science, self.queue.itemId)
    if self:IsUseHeroFreeAddTime() then
      self.researching_btn_name:SetLocalText(130126)
    else
      self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
    end
  elseif self:IsUseHeroFreeAddTime() then
    SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
      qUUID = self.queue.uuid,
      itemIDs = "",
      isGold = IsGold.NoUseGold
    })
    return
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
  end
end

function UILWScienceMainView:IsUseHeroFreeAddTime()
  local isUseFreeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(ItemSpdMenu.ItemSpdMenu_Science)
  local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
  if isUseFreeTime or 0 < freeTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.queue.endTime - curTime <= freeTime * SecToMilSec then
      return true
    end
  end
  return false
end

function UILWScienceMainView:QueueTimeEndSignal(data)
  local queueType = data
  if queueType == NewQueueType.Science and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWScienceDetail) and table.count(self.researchScienceList) > 0 then
    table.walk(self.researchScienceList, function(k, v)
      if v == false then
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(k)
        if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish and not self.researchScienceList[k] then
          self.researchScienceList[k] = true
          self:RefreshResearching()
        end
      end
    end)
  end
end

function UILWScienceMainView:ShowGridCells()
  local allTabs = DataCenter.ScienceTemplateManager:GetCurShowTab(ScienceType.Build, true)
  self.allTab = {}
  local tmpTabState = {}
  local gotoIndex = 1
  for i, v in ipairs(allTabs) do
    local tabId = v.id
    local tabState = DataCenter.ScienceTemplateManager:GetTabState(tabId)
    if tabState == ScienceTabState.UnLock or tabState == ScienceTabState.LockShow then
      table.insert(self.allTab, v)
      tmpTabState[tabId] = tabState
    end
    if tabId == self.gotoTab then
      gotoIndex = i
    end
  end
  table.sort(self.allTab, function(a, b)
    local tabState = tmpTabState[a.id]
    local tabState2 = tmpTabState[b.id]
    if tabState ~= tabState2 and (tabState == ScienceTabState.UnLock or tabState2 == ScienceTabState.UnLock) then
      return tabState == ScienceTabState.UnLock
    end
    return a.order < b.order
  end)
  local count = table.count(self.allTab)
  self.scroll:SetTotalCount(count)
  if 0 < count then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootContainer.transform)
    self.scroll:RefillCells()
    if not self.init then
      self.init = true
    end
    if gotoIndex and 0 < gotoIndex and self.isNeedRollTargetTable then
      self.scroll:ScrollToCell(gotoIndex, 1000)
    else
      self.scroll:ScrollToCell(1, 1)
    end
  end
end

function UILWScienceMainView:ClearItemCell()
  self.scroll:RemoveComponents(Item)
  self.scroll:ClearCells()
  self.scrollCellPool = {}
end

function UILWScienceMainView:OnClickRecommendBtn()
  local baseId = CommonUtil.GetScienceBaseType(self.recommendId)
  GoToUtil.GotoScience(baseId)
end

function UILWScienceMainView:UpdateScienceSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:UpdateBuildDataSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:OnScienceSearchingSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:OnScienceQueueFinishSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:OnScienceHelpSignal()
  self:RefreshResearching()
end

function UILWScienceMainView:OnMonthCardUpdateSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:OnScienceRecommendSignal()
  self:ShowGridCells()
end

function UILWScienceMainView:OnScienceTabProgressDataChangedSignal()
  self:RefreshResearching()
  self:ShowGridCells()
end

function UILWScienceMainView:GenQueuesInfoCell(index, queueCount)
  local cellScale = 2 < queueCount and 0.8 or 1
  self.loadRequest[index] = self:GameObjectInstantiateAsync(UIAssets.UILWScienceQueueInfoCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.queuesContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    NameCount = NameCount + 1
    go.name = nameStr
    self.queuesInfoCells[index] = self.queuesContent:AddComponent(queueItem, nameStr)
    self.queuesInfoCells[index]:SetData(index)
    self.queuesInfoCells[index]:RefreshQueueShowState()
    self.queuesInfoCells[index]:SetQueueScale(cellScale)
  end)
end

function UILWScienceMainView:ReSetCellSizeByCellCount(cellCount)
  if not cellCount or cellCount <= 0 then
    return
  end
  local height = 2 < cellCount and 81 or 112
  self.queuesContentLayout:SetCellSize(317, height)
  self:ReCalMiddleContentHeightByCellSize(cellCount)
end

function UILWScienceMainView:ReCalMiddleContentHeightByCellSize(cellCount)
  if not self.queuesContent or not self.middleContentContainer then
    return
  end
  local bottomOffset = 2 < cellCount and -100 or 0
  local height = self.middleContentOriHeight + bottomOffset
  self.middleContentContainer.rectTransform:Set_sizeDelta(self.middleContentOriWidth, height)
end

function UILWScienceMainView:RestoreContentHeight()
  if self.middleContentContainer and self.middleContentOriWidth and self.middleContentOriHeight then
    self.middleContentContainer.rectTransform:Set_sizeDelta(self.middleContentOriWidth, self.middleContentOriHeight)
  end
end

return UILWScienceMainView
