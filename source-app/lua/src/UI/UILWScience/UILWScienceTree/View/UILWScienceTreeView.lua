local UILWScienceTreeView = BaseClass("UILWScienceTreeView", UIBaseView)
local base = UIBaseView
local LWScienceCell = require("UI.UILWScience.UILWScienceTree.Component.UILWScienceTreeCell")
local UILWRowCell = require("UI.UILWScience.UILWScienceTree.Component.UILWScienceTreeRowCell")
local UILWLineCell = require("UI.UILWScience.UILWScienceTree.Component.UILWScienceTreeLineCell")
local queueItem = require("UI.UILWScience.UILWScienceMain.Component.UILWScienceQueueItem")
local tonumber = _ENV.tonumber
local tostring = _ENV.tostring
local DataCenter = _ENV.DataCenter
local NewQueueState = _ENV.NewQueueState
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path = "Root/BottomBar/BtnBack"
local scroll_view_path = "Root/MiddleContentContainer/ScrollView"
local line_content_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content"
local researching_go_path = "Root/BottomBar/Recommend"
local researching_btn_path = "Root/BottomBar/Recommend/Btn"
local researching_btn_name_path = "Root/BottomBar/Recommend/Btn/Txt"
local researching_icon_path = "Root/BottomBar/Recommend/Science/Icon"
local researching_level_path = "Root/BottomBar/Recommend/Science/LvTxt"
local researching_slider_path = "Root/BottomBar/Recommend/Slider"
local researching_left_time_path = "Root/BottomBar/Recommend/Slider/SliderText"
local first_queue_info_path = "Root/BottomBar/ResearchQueues/FirstQueueInfo"
local second_queue_info_path = "Root/BottomBar/ResearchQueues/SecondQueueInfo"
local middle_content_container_path = "Root/MiddleContentContainer"
local research_queues_path = "Root/BottomBar/ResearchQueues"
local bottom_img_b_g_path = "BottomImgBG"
local line_parent_path = "Root/MiddleContentContainer/lineParent"
local SliderLength = 196
local ScreenCell = 4
local CellLocalPosition = Vector3.New(0, 0, 0)
local TITLE_TXT = GameDialogDefine.SCIENCE
local FinishedTextStr = ""

function UILWScienceTreeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Tech_Lvl2_UI, false)
end

function UILWScienceTreeView:ClearQueuesInfoScroll()
  if self.queuesContent then
    self.queuesContent:RemoveComponents(queueItem)
  end
  for i, v in ipairs(self.loadRequest) do
    self:GameObjectDestroy(v)
  end
end

function UILWScienceTreeView:OnDestroy()
  self:RestoreContentHeight()
  self:SetAllCellsDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceTreeView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
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
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetExtraFillSize(0, IntMaxValue)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.titleText:SetLocalText(TITLE_TXT)
  self.queuesContent = self:AddComponent(UIBaseContainer, research_queues_path)
  self.queuesContentLayout = self:AddComponent(UIGridLayoutGroup, research_queues_path)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middle_content_container_path)
  self.lineParent = self:AddComponent(UIBaseContainer, line_parent_path)
  local contentWidth, contentHeight = self.middleContentContainer.rectTransform:Get_sizeDelta()
  self.middleContentOriWidth = contentWidth
  self.middleContentOriHeight = contentHeight
  self.bottomBarBG = self:AddComponent(UIBaseContainer, bottom_img_b_g_path)
  local bottomBarWidth, bottomBarHeight = self.bottomBarBG.rectTransform:Get_sizeDelta()
  self.bottomBarBGOriWidth = bottomBarWidth
  self.bottomBarBGOriHeight = bottomBarHeight
end

function UILWScienceTreeView:ComponentDestroy()
  self.titleText = nil
  self.closeBtn = nil
  self.researching_go = nil
  self.researching_btn = nil
  self.researching_btn_name = nil
  self.researching_icon = nil
  self.researching_level = nil
  self.researching_slider = nil
  self.researching_left_time = nil
  self.line_content = nil
  self.scroll_view = nil
  self.queuesContent = nil
  self.queuesContentLayout = nil
  self.middleContentOriWidth = nil
  self.middleContentOriHeight = nil
  self.bottomBarBG = nil
  self.lineParent = nil
end

function UILWScienceTreeView:DataDefine()
  self.ctrl:SetView(self)
  FinishedTextStr = CS.GameEntry.Localization:GetString("research_finish")
  self.queue = nil
  self.scienceCells = {}
  self.researchingActive = nil
  self.laseTime = 0
  self.lastChangeTime = 0
  self.curSliderValue = nil
  self.curTimeValue = nil
  self.gotoTab = nil
  self.gotoId = nil
  self.gotoRow = nil
  self.reachingScienceList = {}
  self.needUpdateCell = {}
  self.tabLine = {}
  self.lineCells = {}
  self.lineParentIndex = LongMaxValue
  self.rowCells = {}
  self.needWaitLoadLine = {}
  self.bUuid = nil
  self.isGoToScience = nil
  self.loadRequest = {}
  self.queuesInfoCells = {}
  self.lineParentObj = nil
end

function UILWScienceTreeView:DataDestroy()
  self.ctrl:ClearView()
  self:ClearScrollTween()
  self.queue = nil
  self.scienceCells = nil
  self.researchingActive = nil
  self.laseTime = nil
  self.lastChangeTime = nil
  self.curSliderValue = nil
  self.curTimeValue = nil
  self.gotoTab = nil
  self.gotoId = nil
  self.gotoRow = nil
  self.reachingScienceList = nil
  self.needUpdateCell = nil
  self.tabLine = nil
  self.lineCells = nil
  self.lineParentIndex = nil
  self.rowCells = nil
  self.needWaitLoadLine = nil
  self.bUuid = nil
  self.isGoToScience = nil
  self.loadRequest = nil
  self.queuesInfoCells = nil
  self.lineParentObj = nil
end

function UILWScienceTreeView:OnEnable()
  base.OnEnable(self)
end

function UILWScienceTreeView:OnDisable()
  base.OnDisable(self)
end

function UILWScienceTreeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnResearchingScienceInfoChangeWithId)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
  self:AddUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.OnResearchingScienceInfoChange)
  self:AddUIListener(EventId.ScienceRecommendDataDirty, self.OnScienceRecommendSignal)
end

function UILWScienceTreeView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnResearchingScienceInfoChangeWithId)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
  self:RemoveUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.OnResearchingScienceInfoChange)
  self:RemoveUIListener(EventId.ScienceRecommendDataDirty, self.OnScienceRecommendSignal)
end

function UILWScienceTreeView:ReInit()
  local tab, goId, isNeedScroll, bUuid = self:GetUserData()
  self.bUuid = bUuid
  self.needScroll = isNeedScroll
  if tab ~= nil and tab ~= "" then
    self.gotoTab = tonumber(tab)
  end
  if goId ~= nil and goId ~= "" then
    self.gotoId = tonumber(goId)
  end
  self.isSendFinish = false
  self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
  self:ShowResearching()
  self:ShowCells()
  self:RefreshTitle()
end

function UILWScienceTreeView:ShowResearching()
  local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.reachingScienceList = {}
  table.walk(queueList, function(k, v)
    if v ~= nil then
      local state = v:GetQueueState()
      local scienceId = tonumber(v.itemId)
      if state ~= NewQueueState.Free then
        local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
        if template ~= nil then
          self.reachingScienceList[scienceId] = v
        end
      end
    end
  end)
  self:ClearQueuesInfoScroll()
  local queueCount = #queueList
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
  if data and data.level == 0 then
    queueCount = queueCount + 1
  end
  self:ReSetCellSizeByCellCount(queueCount)
  for i = 1, queueCount do
    self:GenQueuesInfoCell(i, queueCount)
  end
end

function UILWScienceTreeView:ClearScroll()
  self.rowCells = {}
  self.lineParentIndex = LongMaxValue
  self.lineParentObj = nil
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWRowCell)
end

function UILWScienceTreeView:OnCreateCell(itemObj, index)
  itemObj.name = "row_" .. index
  local item = self.scroll_view:AddComponent(UILWRowCell, itemObj)
  self.rowCells[index] = item
  if index < self.lineParentIndex then
    self.lineParentIndex = index
    self:SetLineParent()
  end
  local data = self.tabLine[index]
  if data ~= nil then
    for k, v in pairs(data) do
      local param = LWScienceCell.Param.New()
      param.scienceId = v
      param.gray = self.gray
      param.index = index
      param.y = k
      self:AddOneScienceCells(param, item, index)
    end
    item:ReInit({index = index})
  end
end

function UILWScienceTreeView:ClearScienceCells()
  for k, v in pairs(self.scienceCells) do
    self:GameObjectDestroy(v.param.req)
  end
  self.needUpdateCell = {}
  self.scienceCells = {}
end

function UILWScienceTreeView:OnDeleteCell(itemObj, index)
  self.rowCells[index] = nil
  local removeIds = {}
  for k, v in pairs(self.scienceCells) do
    if v.param.index == index then
      if self.needUpdateCell[v.param.scienceId] ~= nil then
        self.needUpdateCell[v.param.scienceId] = nil
      end
      self:GameObjectDestroy(v.param.req)
      table.insert(removeIds, k)
    end
  end
  if table.count(removeIds) > 0 then
    for k, v in ipairs(removeIds) do
      self.scienceCells[v] = nil
    end
  end
  removeIds = {}
  for k, v in pairs(self.lineCells) do
    if v and table.count(v) > 0 and v[1].param.index == index then
      table.insert(removeIds, v[1].param.goName)
      self:GameObjectDestroy(v[1].param.req)
      if #v == 2 then
        self:GameObjectDestroy(v[2].param.req)
      end
    end
  end
  if table.count(removeIds) > 0 then
    for k, v in ipairs(removeIds) do
      self.lineCells[v] = nil
    end
  end
  if self.lineParentIndex == index then
    self.lineParentIndex = self:GetLineParentIndex()
    self:SetLineParent()
  end
  self.scroll_view:RemoveComponent(itemObj.name, UILWRowCell)
end

function UILWScienceTreeView:RefreshGoToCells()
  self.gotoRow = 0
  if self.tabLine ~= nil then
    local isContinue = true
    for k, v in pairs(self.tabLine) do
      if isContinue then
        for k1, v1 in pairs(v) do
          if isContinue and self.gotoId ~= nil and 0 < self.gotoId and v1 == self.gotoId then
            self.gotoRow = k
            isContinue = false
          end
        end
      end
    end
  end
  if self.gotoRow <= 0 then
    return
  end
  local count = self:GetCellCount()
  if 0 < count then
    local min = ScreenCell
    local max = count
    local showIndex = self.gotoRow
    if min >= showIndex then
      showIndex = 0
    elseif max < showIndex then
      showIndex = max
    end
    self:ScrollToCell(showIndex)
  end
  if self.gotoId == nil then
    return
  end
  local tran = self.scienceCells[self.gotoId]
  if tran == nil then
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self and self.transform and tran and tran.OnBtnClick then
      if tran.ShowSelect then
        tran:ShowSelect()
      end
      if self.isGoToScience then
        self.isGoToScience = nil
        tran:OnBtnClick()
      end
      self.gotoId = nil
    end
  end, 0.3)
end

function UILWScienceTreeView:ShowCells()
  self.needWaitLoadLine = {}
  self:ClearScienceCells()
  self:ClearLineCells()
  self:ClearScroll()
  self:GetGotoScienceRow()
  local count = self:GetCellCount()
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    local min = ScreenCell
    local max = count
    local showIndex = self.gotoRow
    if min >= showIndex then
      showIndex = 0
    elseif max < showIndex then
      showIndex = max
    end
    local startRow = 0
    if self.needScroll then
      if showIndex > ScreenCell then
        startRow = showIndex - ScreenCell
      end
      self.scroll_view:RefillCells()
      self:ScrollToCell(showIndex, startRow)
    else
      self.scroll_view:RefillCells()
      self:ScrollToCell(showIndex, showIndex)
    end
  end
end

function UILWScienceTreeView:ClearScrollTween()
  if self.scrollTween then
    self.scrollTween:Kill()
    self.scrollTween = nil
  end
end

function UILWScienceTreeView:ScrollToCell(targetIndex, beginIndex)
  self:ClearScrollTween()
  local totalCount = self:GetCellCount()
  if totalCount <= ScreenCell then
    return
  end
  local singlePart = 1 / (totalCount - ScreenCell)
  local targetNormalizedPos = singlePart * math.max(0, targetIndex - ScreenCell)
  if beginIndex then
    local beginNormalizedPos = singlePart * math.max(0, beginIndex - ScreenCell)
    self.scroll_view:SetVerticalNormalizedPosition(beginNormalizedPos)
  end
  self.scrollTween = DOTween.To(function()
    return self.scroll_view:GetVerticalNormalizedPosition()
  end, function(pos)
    self.scroll_view:SetVerticalNormalizedPosition(pos)
  end, targetNormalizedPos, 1):SetEase(CS.DG.Tweening.Ease.OutQuad)
end

function UILWScienceTreeView:RefreshCells()
  local showIndex = self:GetLineParentIndex()
  self.needWaitLoadLine = {}
  self:ClearScienceCells()
  self:ClearLineCells()
  self.rowCells = {}
  self.lineParentIndex = LongMaxValue
  if showIndex < 1 then
    showIndex = 1
  end
  self.scroll_view:RefillCells(showIndex)
end

function UILWScienceTreeView:SetAllCellsDestroy()
  self:ClearScienceCells()
  self:ClearLineCells()
  self:ClearQueuesInfoScroll()
end

function UILWScienceTreeView:AddOneScienceCells(param, parentTransform, index)
  self:GameObjectInstantiateAsync(UIAssets.UIScienceCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local go_tf = go.transform
    local v = self:GetCellLocalPosition(param.y)
    go:SetActive(true)
    go_tf:SetParent(parentTransform.transform)
    go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_tf:Set_anchoredPosition(v.x, v.y, v.z)
    local nameStr = tostring(param.scienceId)
    go.name = nameStr
    NameCount = NameCount + 1
    local tran = parentTransform:AddComponent(LWScienceCell, nameStr)
    param.req = request
    if self.reachingScienceList[param.scienceId] ~= nil then
      param.isReaching = true
      local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(param.scienceId))
      if queue and queue:GetQueueState() == NewQueueState.Work then
        self.needUpdateCell[param.scienceId] = tran
      end
    else
      param.isReaching = false
    end
    tran:ReInit(param)
    self.scienceCells[param.scienceId] = tran
    self:AddOneScienceLines(param.scienceId)
    local count = table.count(self.needWaitLoadLine)
    for k = count, 1, -1 do
      self:LoadOneLine(self.needWaitLoadLine[k])
    end
    if param.isReaching then
      self:UpdateLeftTime(true)
    end
    if self.gotoId ~= nil and index == self.gotoRow and param.scienceId == self.gotoId then
      TimerManager:GetInstance():DelayInvoke(function()
        if self and self.transform and tran and tran.OnBtnClick then
          if tran.ShowSelect then
            tran:ShowSelect()
          end
          if self.isGoToScience then
            self.isGoToScience = nil
            tran:OnBtnClick()
          end
          self.gotoRow = nil
        end
      end, 0.3)
    end
  end)
end

function UILWScienceTreeView:OnAddSpeedClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
end

function UILWScienceTreeView:SetResearchingActive(value)
  if self.researchingActive ~= value then
    self.researchingActive = value
    self.researching_go:SetActive(value)
  end
end

function UILWScienceTreeView:UpdateScienceSignal()
  if not self.isSendFinish then
    self:RefreshCells()
  end
end

function UILWScienceTreeView:OnResearchingScienceInfoChangeWithId(targetScienceId)
  self:ShowResearching()
  if not self.scienceCells or not self.scienceCells[targetScienceId] then
    return
  end
  local tempScienceCell = self.scienceCells[targetScienceId]
  if self.reachingScienceList[tonumber(targetScienceId)] ~= nil then
    tempScienceCell:ResetResearchState(true)
    local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(targetScienceId)
    if queue and queue:GetQueueState() == NewQueueState.Work then
      self.needUpdateCell[tonumber(targetScienceId)] = tempScienceCell
    end
  else
    tempScienceCell:ResetResearchState(false)
  end
  self:ClearLineCells()
  for i, v in pairs(self.scienceCells) do
    self:AddOneScienceLines(v.param.scienceId)
    local count = table.count(self.needWaitLoadLine)
    for k = count, 1, -1 do
      self:LoadOneLine(self.needWaitLoadLine[k])
    end
    v:RefreshUI()
  end
  self:SetLineParent()
  self:UpdateLeftTime(true)
end

function UILWScienceTreeView:OnResearchingScienceInfoChange()
  self:ShowResearching()
  if self.scienceCells == nil then
    return
  end
  table.walk(self.scienceCells, function(k, v)
    local reachingCell = self.reachingScienceList[k]
    if reachingCell ~= nil then
      v:ResetResearchState(true)
      local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(k))
      if queue then
        local state = queue:GetQueueState()
        if state == NewQueueState.Work then
          self.needUpdateCell[k] = v
        end
      end
    else
      v:ResetResearchState(false)
    end
  end)
  self:SetLineParent()
  self:UpdateLeftTime(true)
  for i, v in pairs(self.scienceCells) do
    v:RefreshUI()
  end
end

function UILWScienceTreeView:Update()
  if self.reachingScienceList ~= nil and table.count(self.reachingScienceList) > 0 then
    self:UpdateLeftTime()
  end
end

function UILWScienceTreeView:UpdateLeftTime(forceRefresh)
  if self.needUpdateCell ~= nil and table.count(self.needUpdateCell) > 0 then
    table.walk(self.needUpdateCell, function(k, v)
      local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(k))
      if queue ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = queue.endTime - curTime
        if 0 < changeTime then
          local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
          if v ~= nil then
            v:SetSliderText(tempTimeValue)
          end
        elseif queue:GetQueueState() == NewQueueState.Finish then
          if v ~= nil and not v:IsRefreshResearchState() then
            v:SetSliderText(FinishedTextStr)
            v:ResetResearchState(true, true)
          end
        elseif v ~= nil then
          v:SetSliderText("")
          v:ResetResearchState(false)
        end
      end
    end)
  end
end

function UILWScienceTreeView:OnScienceSearchingSignal()
  self:ShowResearching()
  self:RefreshCells()
end

function UILWScienceTreeView:GetGotoScienceRow()
  self.gotoRow = 1
  local researchingList = {}
  local tempQueueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  for i, v in ipairs(tempQueueList) do
    if v and not string.IsNullOrEmpty(v.itemId) then
      table.insert(researchingList, tonumber(v.itemId))
    end
  end
  if self.tabLine ~= nil then
    local isContinue = true
    for k, v in pairs(self.tabLine) do
      if isContinue then
        for k1, v1 in pairs(v) do
          if isContinue then
            if self.gotoId ~= nil and self.gotoId > 0 then
              if v1 == self.gotoId then
                self.gotoRow = k
                isContinue = false
              end
            else
              local isMaxLv = self.ctrl:IsScienceLvMax(v1)
              if not isMaxLv and not table.hasvalue(researchingList, v1) then
                self.gotoRow = k
                isContinue = false
              end
            end
          end
        end
      end
    end
  end
end

function UILWScienceTreeView:GotoScienceSignal(scienceId, isNotOpen)
  if scienceId ~= nil then
    self.needScroll = false
    self.isGoToScience = true
    if isNotOpen then
      self.isGoToScience = nil
    end
    local temp = tonumber(scienceId)
    if 10000 < temp then
      local scienceTem = DataCenter.ScienceTemplateManager:GetScienceTemplate(temp)
      if scienceTem ~= nil then
        if self.gotoTab == scienceTem.tab then
          self.gotoId = temp
          self:RefreshGoToCells()
        else
          self.gotoTab = scienceTem.tab
          self.gotoId = temp
          self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
          self:ShowCells()
        end
      end
    else
      self.gotoTab = temp
      self.gotoId = nil
      self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
      self:ShowCells()
    end
  end
  self:RefreshTitle()
end

function UILWScienceTreeView:RefreshResearchingBtnName()
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    self.researching_btn_name:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
  elseif self:IsUseHeroFreeAddTime() then
    self.researching_btn_name:SetLocalText(130126)
  else
    self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
  end
end

function UILWScienceTreeView:OnResearchingBtnClick()
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

function UILWScienceTreeView:IsUseHeroFreeAddTime()
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

function UILWScienceTreeView:OnScienceQueueFinishSignal(queueUuid)
  self:OnResearchingScienceInfoChange()
end

function UILWScienceTreeView:AllianceQueueHelpNewSignal()
end

function UILWScienceTreeView:GetCellCount()
  local result = 0
  if self.tabLine ~= nil then
    for k, v in pairs(self.tabLine) do
      if k > result then
        result = k
      end
    end
  end
  return result
end

function UILWScienceTreeView:GetCellLocalPosition(positionY)
  CellLocalPosition.x = (positionY - 2) * 260
  return CellLocalPosition
end

function UILWScienceTreeView:AddOneScienceLines(scienceId)
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
  if template ~= nil then
    local needScience = template.needScience
    if needScience ~= nil then
      for k, v in ipairs(needScience) do
        local param = {}
        param.isGray = not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level)
        param.index = template.positionX
        param.link = template.links[v.scienceId] or 0
        param.originalScienceId = scienceId
        param.needScienceId = v.scienceId
        param.goName = param.originalScienceId .. param.needScienceId
        self:LoadOneLine(param)
      end
    end
  end
end

function UILWScienceTreeView:LoadOneLine(param)
  if self.scienceCells[param.originalScienceId] ~= nil and self.scienceCells[param.needScienceId] ~= nil then
    self:RemoveOneWaitLoadLine(param)
    self.lineCells[param.goName] = {}
    if not param.isGray then
    end
    self:GameObjectInstantiateAsync(UIAssets.UIScienceLine, function(request)
      if request.isError then
        return
      end
      if self.scienceCells[param.originalScienceId] ~= nil and self.scienceCells[param.needScienceId] ~= nil then
        local go = request.gameObject
        param.req = request
        go:SetActive(true)
        if self.lineParentObj == nil then
          self.lineParentObj = self:CopyRectTransform(self.lineParent, self.line_content.transform)
          self.lineParentObj.transform:SetAsFirstSibling()
        end
        local transformTra = self.lineParentObj.gameObject
        go.transform:SetParent(transformTra.transform)
        if param.isGray == true then
          go.transform:SetAsFirstSibling()
        else
          go.transform:SetAsLastSibling()
        end
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_pivot(0.5, 0.5)
        param.needPosition = self.scienceCells[param.needScienceId]:GetLineCenterPosition(false)
        param.originalPosition = self.scienceCells[param.originalScienceId]:GetLineCenterPosition(true)
        local nameStr = string.format("%s->%s", param.needScienceId, param.originalScienceId)
        go.name = nameStr
        NameCount = NameCount + 1
        if not self.lineCells[param.goName] then
          self.lineCells[param.goName] = {}
        end
        local tempTb = self.lineCells[param.goName]
        local newLine = self:AddComponent(UILWLineCell, line_content_path .. "/" .. transformTra.gameObject.name .. "/" .. nameStr)
        table.insert(tempTb, newLine)
        newLine:ReInit(param)
      else
        self:GameObjectDestroy(request)
      end
    end)
  else
    self:AddOneWaitLoadLine(param)
  end
end

function UILWScienceTreeView:CopyRectTransform(sourceGameObject, targetParent)
  if not sourceGameObject then
    Logger.LogError("\230\186\144 GameObject \228\184\141\232\131\189\228\184\186\231\169\186")
    return nil
  end
  local newGameObject = CS.UnityEngine.GameObject("LineParentTransform")
  CS.UnityEngine.Object.Destroy(newGameObject.transform)
  local targetRect = newGameObject:AddComponent(typeof(CS.UnityEngine.RectTransform))
  newGameObject.transform:SetParent(targetParent, false)
  local sourceRect = sourceGameObject.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if sourceRect and targetRect then
    targetRect.anchorMin = sourceRect.anchorMin
    targetRect.anchorMax = sourceRect.anchorMax
    targetRect.pivot = sourceRect.pivot
    targetRect.anchoredPosition = sourceRect.anchoredPosition
    targetRect.sizeDelta = sourceRect.sizeDelta
    targetRect.localScale = sourceRect.localScale
    targetRect.localRotation = sourceRect.localRotation
  end
  return newGameObject
end

function UILWScienceTreeView:ClearLineCells()
  for k, v in pairs(self.lineCells) do
    for i = 1, #v do
      self:GameObjectDestroy(v[i].param.req)
    end
  end
  self.lineCells = {}
  self:RemoveComponents(UILWLineCell)
end

function UILWScienceTreeView:SetLineParent()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.line_content.rectTransform)
  local parentTrans = self:GetLineParent()
  for k, v in pairs(self.lineCells) do
    if #v == 2 then
      v[2].transform:SetParent(parentTrans.transform)
      if not v[2].param.isGray then
        v[2].transform:SetAsFirstSibling()
      end
    end
  end
  for k, v in pairs(self.lineCells) do
    if 1 <= #v and v[1].transform then
      v[1].transform:SetParent(parentTrans.transform)
      v[1].transform:SetAsFirstSibling()
    end
  end
end

function UILWScienceTreeView:GetLineParentIndex()
  local result = LongMaxValue
  for k, v in pairs(self.rowCells) do
    if k < result then
      result = k
    end
  end
  return result
end

function UILWScienceTreeView:GetLineParent()
  if self.rowCells[self.lineParentIndex] ~= nil then
    return self.rowCells[self.lineParentIndex]
  else
    return self
  end
end

function UILWScienceTreeView:RemoveOneWaitLoadLine(param)
  local haveKey
  for k, v in pairs(self.needWaitLoadLine) do
    if v.goName == param.goName then
      haveKey = k
      break
    end
  end
  if haveKey ~= nil then
    table.remove(self.needWaitLoadLine, haveKey)
  end
end

function UILWScienceTreeView:AddOneWaitLoadLine(param)
  local haveKey
  for k, v in pairs(self.needWaitLoadLine) do
    if v.goName == param.goName then
      haveKey = k
      break
    end
  end
  if haveKey == nil then
    table.insert(self.needWaitLoadLine, param)
  end
end

function UILWScienceTreeView:GetScienceGuideBtn(scienceId)
  if self.gotoId ~= scienceId then
    self:GotoScienceSignal(scienceId, true)
  end
  if self.scienceCells[scienceId] ~= nil then
    return self.scienceCells[scienceId]:GetGuideBtn()
  end
end

function UILWScienceTreeView:OnScienceRecommendSignal()
  for i, v in pairs(self.scienceCells) do
    v:RefreshUI()
  end
end

function UILWScienceTreeView:GenQueuesInfoCell(index, queueCount)
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

function UILWScienceTreeView:ReSetCellSizeByCellCount(cellCount)
  if not cellCount or cellCount <= 0 then
    return
  end
  local height = 2 < cellCount and 81 or 112
  self.queuesContentLayout:SetCellSize(317, height)
  self:ReCalMiddleContentHeightByCellSize(cellCount)
end

function UILWScienceTreeView:ReCalMiddleContentHeightByCellSize(cellCount)
  if not self.queuesContent or not self.middleContentContainer then
    return
  end
  local bottomOffset = 2 < cellCount and -100 or 0
  local height = self.middleContentOriHeight + bottomOffset
  self.middleContentContainer.rectTransform:Set_sizeDelta(self.middleContentOriWidth, height)
  bottomOffset = 2 < cellCount and 45 or 0
  local bottomBarNewHeight = self.bottomBarBGOriHeight + bottomOffset
  self.bottomBarBG.rectTransform:Set_sizeDelta(self.bottomBarBGOriWidth, bottomBarNewHeight)
end

function UILWScienceTreeView:RestoreContentHeight()
  if self.middleContentContainer and self.middleContentOriWidth and self.middleContentOriHeight then
    self.middleContentContainer.rectTransform:Set_sizeDelta(self.middleContentOriWidth, self.middleContentOriHeight)
  end
  if self.bottomBarBG and self.bottomBarBGOriWidth and self.bottomBarBGOriHeight then
    self.bottomBarBG.rectTransform:Set_sizeDelta(self.bottomBarBGOriWidth, self.bottomBarBGOriHeight)
  end
end

function UILWScienceTreeView:RefreshTitle()
  if not self.gotoTab then
    return
  end
  local meta = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(self.gotoTab)
  if meta and self.titleText then
    self.titleText:SetLocalText(meta.name)
  end
end

return UILWScienceTreeView
