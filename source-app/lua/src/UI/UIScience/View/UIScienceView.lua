local UIScienceView = BaseClass("UIScienceView", UIBaseView)
local base = UIBaseView
local ScienceCell = require("UI.UIScience.Component.ScienceCell")
local UIRowCell = require("UI.UIScience.Component.UIRowCell")
local UILineCell = require("UI.UIScience.Component.UILineCell")
local Localization = CS.GameEntry.Localization
local close_btn_path = "BgGo/CloseBtn"
local back_btn_path = "BgGo/backBtn"
local scroll_view_path = "BgGo/MiddleBg/ScrollView"
local gray_img_path = "GrayImg"
local researching_go_path = "BgGo/MiddleBg/UITechnology_imgbg_study"
local researching_btn_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Common_btn_yellow71"
local researching_btn_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Common_btn_yellow71/btnTxt_yellow_small_new"
local researching_icon_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Science/Icon"
local researching_level_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Science/LvTxt"
local researching_slider_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Slider"
local researching_left_time_path = "BgGo/MiddleBg/UITechnology_imgbg_study/Slider/SliderText"
local line_content_path = "BgGo/MiddleBg/ScrollView/Viewport/Content"
local scrollingMask_path = "BgGo"
local rocketBgContainers_path = "RocketContainer/Rockets"
local image_path = "Image"
local SliderLength = 196
local ScreenCell = 3
local CellLocalPosition = Vector3.New(0, 0, 0)
local rocket_design_width = 1750
local rocket_design_height = 750

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetResBarVisible(false)
  self:ReInit()
end

local function OnDestroy(self)
  self:SetResBarVisible(true)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.gray_img = self:AddComponent(UIImage, gray_img_path)
  self.researching_go = self:AddComponent(UIBaseContainer, researching_go_path)
  self.researching_btn = self:AddComponent(UIButton, researching_btn_path)
  self.researching_btn_name = self:AddComponent(UIText, researching_btn_name_path)
  self.researching_icon = self:AddComponent(UIImage, researching_icon_path)
  self.researching_level = self:AddComponent(UIText, researching_level_path)
  self.researching_slider = self:AddComponent(UISlider, researching_slider_path)
  self.researching_left_time = self:AddComponent(UIText, researching_left_time_path)
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
  self.scrollingMask = self:AddComponent(UIBaseContainer, scrollingMask_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.researching_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnResearchingBtnClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetExtraFillSize(1334, 0)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceTab) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScienceTab)
    end
  end)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.scroll_view = nil
  self.gray_img = nil
  self.researching_go = nil
  self.researching_btn = nil
  self.researching_btn_name = nil
  self.researching_btn_name = nil
  self.researching_icon = nil
  self.researching_level = nil
  self.researching_slider = nil
  self.researching_left_time = nil
  self.line_content = nil
  self.image = nil
end

local function DataDefine(self)
  self.gray = self.gray_img:GetMaterial()
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
  self.SendFinishFlagList = {}
  self.tabLine = {}
  self.lineCells = {}
  self.lineParentIndex = LongMaxValue
  self.rowCells = {}
  self.needWaitLoadLine = {}
  self.bUuid = nil
end

local function DataDestroy(self)
  self.gray = nil
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
  self.SendFinishFlagList = nil
  self.tabLine = nil
  self.lineCells = nil
  self.lineParentIndex = nil
  self.rowCells = nil
  self.needWaitLoadLine = nil
  self.bUuid = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnResearchingScienceInfoChangeWithId)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
  self:AddUIListener(EventId.AddSpeedSuccess, self.OnResearchingScienceInfoChange)
  self:AddUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.OnResearchingScienceInfoChange)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnResearchingScienceInfoChangeWithId)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnResearchingScienceInfoChange)
  self:RemoveUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.OnResearchingScienceInfoChange)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
end

local function ReInit(self)
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
  local scaleX = Screen.width / rocket_design_width
  local scaleY = Screen.height / rocket_design_height
  local scale = math.max(scaleX, scaleY)
  local realW = rocket_design_width * scale
  local realH = rocket_design_height * scale
  local realScale = 750 / realH
  self.image.transform:Set_sizeDelta(realW, realH)
  if scaleX < scaleY then
    self.image.transform:Set_localScale(realScale, realScale, realScale)
  else
    self.image.transform:Set_localScale(1, 1, 1)
  end
  self:ShowResearching()
  self:SetTitle()
  self:ShowCells()
end

local function SetResBarVisible(self, isShow)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if not window or window.View then
  end
end

local function SetTitle(self)
end

local function ShowResearching(self)
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
          self.researching_icon:LoadSprite(string.format(LoadPath.ScienceIcons, template.icon))
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
        if not self.SendFinishFlagList[v.uuid] then
          self.SendFinishFlagList[v.uuid] = false
        end
      end
    end
  end)
end

local function ClearScroll(self)
  self.rowCells = {}
  self.lineParentIndex = LongMaxValue
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIRowCell)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = "row_" .. index
  local item = self.scroll_view:AddComponent(UIRowCell, itemObj)
  self.rowCells[index] = item
  if index < self.lineParentIndex then
    self.lineParentIndex = index
    self:SetLineParent()
  end
  local data = self.tabLine[index]
  if data ~= nil then
    for k, v in pairs(data) do
      local param = ScienceCell.Param.New()
      param.scienceId = v
      param.gray = self.gray
      param.index = index
      param.y = k
      self:AddOneScienceCells(param, item, index)
    end
    item:ReInit({index = index})
  end
end

local function ClearScienceCells(self)
  for k, v in pairs(self.scienceCells) do
    self:GameObjectDestroy(v.param.req)
  end
  self.needUpdateCell = {}
  self.scienceCells = {}
end

local function OnDeleteCell(self, itemObj, index)
  self.rowCells[index] = nil
  local removeIds = {}
  for k, v in pairs(self.scienceCells) do
    if v.param.index == index then
      self.needUpdateCell[v.param.scienceId] = nil
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
  self.scroll_view:RemoveComponent(itemObj.name, UIRowCell)
end

local function ShowCells(self)
  self.needWaitLoadLine = {}
  self:ClearScienceCells()
  self:ClearLineCells()
  self:ClearScroll()
  self:GetGotoScienceRow()
  local count = self:GetCellCount()
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    local min = math.floor(ScreenCell / 2)
    local max = count - ScreenCell + 1
    local showIndex = self.gotoRow
    if min >= showIndex then
      showIndex = 1
    elseif max < showIndex then
      showIndex = max
    else
      showIndex = showIndex - min
    end
    local startRow = min
    if self.needScroll then
      if 3 < showIndex then
        startRow = showIndex - 3
      end
      self.scroll_view:RefillCells(startRow)
      self.scroll_view:ScrollToCell(showIndex, 2000)
    else
      self.scroll_view:RefillCells(showIndex)
    end
  end
end

local function RefreshCells(self)
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

local function SetAllCellsDestroy(self)
  self:ClearScienceCells()
  self:ClearLineCells()
  self:ClearScroll()
end

local function AddOneScienceCells(self, param, parentTransform, index)
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
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local tran = parentTransform:AddComponent(ScienceCell, nameStr)
    param.req = request
    if self.reachingScienceList[param.scienceId] ~= nil then
      param.isReaching = true
      self.needUpdateCell[param.scienceId] = tran
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
      local param = {}
      local x, y, z = go.transform:Get_position()
      param.position = Vector3.New(x, y, z)
      param.arrowType = ArrowType.Capacity
      param.positionType = PositionType.Screen
      TimerManager:GetInstance():DelayInvoke(function()
        if self and self.transform then
          DataCenter.ArrowManager:ShowArrow(param)
          self.gotoRow = nil
        end
      end, 0.3)
    end
  end)
end

local function OnAddSpeedClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
end

local function SetResearchingActive(self, value)
  if self.researchingActive ~= value then
    self.researchingActive = value
    self.researching_go:SetActive(value)
  end
end

local function UpdateScienceSignal(self)
  if not self.isSendFinish then
    self:RefreshCells()
  end
end

local function OnResearchingScienceInfoChangeWithId(self, targetScienceId)
  self:ShowResearching()
  if not self.scienceCells or not self.scienceCells[targetScienceId] then
    return
  end
  local tempScienceCell = self.scienceCells[targetScienceId]
  if self.reachingScienceList[tonumber(targetScienceId)] ~= nil then
    tempScienceCell:ResetResearchState(true)
    self.needUpdateCell[tonumber(targetScienceId)] = tempScienceCell
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

local function OnResearchingScienceInfoChange(self)
  self:ShowResearching()
  if self.scienceCells == nil then
    return
  end
  table.walk(self.reachingScienceList, function(k, v)
    local tempScienceCell = self.scienceCells[k]
    if tempScienceCell ~= nil then
      tempScienceCell:ResetResearchState(true)
      self.needUpdateCell[k] = tempScienceCell
    end
  end)
  self:SetLineParent()
  self:UpdateLeftTime(true)
  for i, v in pairs(self.scienceCells) do
    v:RefreshUI()
  end
end

local function QueueTimeEndSignal(self, data)
  local queueType = data
  if queueType == NewQueueType.Science and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceTab) and table.count(self.SendFinishFlagList) > 0 then
    table.walk(self.SendFinishFlagList, function(k, v)
      if v == false then
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(k)
        if queue ~= nil then
          self.SendFinishFlagList[k] = true
          DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(queue.funcUuid))
        end
      end
    end)
  end
end

local function Update(self)
  if self.reachingScienceList ~= nil and table.count(self.reachingScienceList) > 0 then
    self:UpdateLeftTime()
    table.walk(self.reachingScienceList, function(k, v)
      if v ~= nil and v:GetQueueState() == NewQueueState.Finish and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo) and self.SendFinishFlagList[v.uuid] == false then
        self.SendFinishFlagList[v.uuid] = true
        DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(v.funcUuid))
      end
    end)
  end
end

local function UpdateLeftTime(self, forceRefresh)
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

local function OnScienceSearchingSignal(self)
  self:ShowResearching()
  self:RefreshCells()
end

local function GetGotoScienceRow(self)
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

local function GotoScienceSignal(self, scienceId)
  if scienceId ~= nil then
    self.needScroll = false
    local temp = tonumber(scienceId)
    if 10000 < temp then
      local scienceTem = DataCenter.ScienceTemplateManager:GetScienceTemplate(temp)
      if scienceTem ~= nil then
        self.gotoTab = scienceTem.tab
        self.gotoId = temp
        self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
        self:SetTitle()
        self:ShowCells()
      end
    else
      self.gotoTab = temp
      self.gotoId = nil
      self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
      self:SetTitle()
      self:ShowCells()
    end
  end
end

local function RefreshResearchingBtnName(self)
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    self.researching_btn_name:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
  elseif self:IsUseHeroFreeAddTime() then
    self.researching_btn_name:SetLocalText(130126)
  else
    self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
  end
end

local function OnResearchingBtnClick(self)
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

local function IsUseHeroFreeAddTime(self)
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

local function OnScienceQueueFinishSignal(self, queueUuid)
  self.SendFinishFlagList[queueUuid] = false
  self:OnResearchingScienceInfoChange()
end

local function AllianceQueueHelpNewSignal(self)
  self:RefreshResearchingBtnName()
end

local function GetCellCount(self)
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

local function GetCellLocalPosition(self, positionY)
  CellLocalPosition.y = positionY * -70
  return CellLocalPosition
end

local function AddOneScienceLines(self, scienceId)
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

local function LoadOneLine(self, param)
  if self.scienceCells[param.originalScienceId] ~= nil and self.scienceCells[param.needScienceId] ~= nil then
    self:RemoveOneWaitLoadLine(param)
    self.lineCells[param.goName] = {}
    if not param.isGray then
      local tempParam = DeepCopy(param)
      tempParam.isGray = true
      self:GameObjectInstantiateAsync(UIAssets.UIScienceLine, function(request)
        if request.isError then
          return
        end
        if self.scienceCells[tempParam.originalScienceId] ~= nil and self.scienceCells[tempParam.needScienceId] ~= nil then
          local go = request.gameObject
          tempParam.req = request
          go:SetActive(true)
          local transformTra = self:GetLineParent()
          go.transform:SetParent(transformTra.transform)
          if tempParam.isGray == true then
            go.transform:SetAsFirstSibling()
          else
            go.transform:SetSiblingIndex(3)
          end
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.transform:Set_pivot(0.5, 0.5)
          tempParam.needPosition = self.scienceCells[tempParam.needScienceId]:GetLineCenterPosition(false)
          tempParam.originalPosition = self.scienceCells[tempParam.originalScienceId]:GetLineCenterPosition(true)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          if not self.lineCells[tempParam.goName] then
            self.lineCells[tempParam.goName] = {}
          end
          local tempTb = self.lineCells[tempParam.goName]
          local newLine = self:AddComponent(UILineCell, line_content_path .. "/" .. transformTra.gameObject.name .. "/" .. nameStr)
          tempTb[1] = newLine
          newLine:ReInit(tempParam)
        else
          self:GameObjectDestroy(request)
        end
      end)
    end
    self:GameObjectInstantiateAsync(UIAssets.UIScienceLine, function(request)
      if request.isError then
        return
      end
      if self.scienceCells[param.originalScienceId] ~= nil and self.scienceCells[param.needScienceId] ~= nil then
        local go = request.gameObject
        param.req = request
        go:SetActive(true)
        local transformTra = self:GetLineParent()
        go.transform:SetParent(transformTra.transform)
        if param.isGray == true then
          go.transform:SetAsFirstSibling()
        else
          go.transform:SetSiblingIndex(3)
        end
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_pivot(0.5, 0.5)
        param.needPosition = self.scienceCells[param.needScienceId]:GetLineCenterPosition(false)
        param.originalPosition = self.scienceCells[param.originalScienceId]:GetLineCenterPosition(true)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        if not self.lineCells[param.goName] then
          self.lineCells[param.goName] = {}
        end
        local tempTb = self.lineCells[param.goName]
        local newLine = self:AddComponent(UILineCell, line_content_path .. "/" .. transformTra.gameObject.name .. "/" .. nameStr)
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

local function ClearLineCells(self)
  for k, v in pairs(self.lineCells) do
    for i = 1, #v do
      self:GameObjectDestroy(v[i].param.req)
    end
  end
  self.lineCells = {}
end

local function SetLineParent(self)
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

local function GetLineParentIndex(self)
  local result = LongMaxValue
  for k, v in pairs(self.rowCells) do
    if k < result then
      result = k
    end
  end
  return result
end

local function GetLineParent(self)
  if self.rowCells[self.lineParentIndex] ~= nil then
    return self.rowCells[self.lineParentIndex]
  else
    return self
  end
end

local function RemoveOneWaitLoadLine(self, param)
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

local function AddOneWaitLoadLine(self, param)
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

local function GetScienceGuideBtn(self, scienceId)
  if self.gotoId ~= scienceId then
    self:GotoScienceSignal(scienceId)
  end
  if self.scienceCells[scienceId] ~= nil then
    return self.scienceCells[scienceId]:GetGuideBtn()
  end
end

UIScienceView.OnCreate = OnCreate
UIScienceView.OnDestroy = OnDestroy
UIScienceView.OnEnable = OnEnable
UIScienceView.OnDisable = OnDisable
UIScienceView.ComponentDefine = ComponentDefine
UIScienceView.ComponentDestroy = ComponentDestroy
UIScienceView.DataDefine = DataDefine
UIScienceView.DataDestroy = DataDestroy
UIScienceView.OnAddListener = OnAddListener
UIScienceView.OnRemoveListener = OnRemoveListener
UIScienceView.ReInit = ReInit
UIScienceView.OnDeleteCell = OnDeleteCell
UIScienceView.ShowCells = ShowCells
UIScienceView.OnCreateCell = OnCreateCell
UIScienceView.ClearScroll = ClearScroll
UIScienceView.SetAllCellsDestroy = SetAllCellsDestroy
UIScienceView.OnAddSpeedClick = OnAddSpeedClick
UIScienceView.SetResearchingActive = SetResearchingActive
UIScienceView.SetTitle = SetTitle
UIScienceView.Update = Update
UIScienceView.UpdateLeftTime = UpdateLeftTime
UIScienceView.AddOneScienceCells = AddOneScienceCells
UIScienceView.ShowResearching = ShowResearching
UIScienceView.ClearScienceCells = ClearScienceCells
UIScienceView.UpdateScienceSignal = UpdateScienceSignal
UIScienceView.OnScienceSearchingSignal = OnScienceSearchingSignal
UIScienceView.GetGotoScienceRow = GetGotoScienceRow
UIScienceView.GotoScienceSignal = GotoScienceSignal
UIScienceView.RefreshResearchingBtnName = RefreshResearchingBtnName
UIScienceView.OnResearchingBtnClick = OnResearchingBtnClick
UIScienceView.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
UIScienceView.AllianceQueueHelpNewSignal = AllianceQueueHelpNewSignal
UIScienceView.GetCellCount = GetCellCount
UIScienceView.GetCellLocalPosition = GetCellLocalPosition
UIScienceView.AddOneScienceLines = AddOneScienceLines
UIScienceView.LoadOneLine = LoadOneLine
UIScienceView.ClearLineCells = ClearLineCells
UIScienceView.SetLineParent = SetLineParent
UIScienceView.GetLineParentIndex = GetLineParentIndex
UIScienceView.GetLineParent = GetLineParent
UIScienceView.RemoveOneWaitLoadLine = RemoveOneWaitLoadLine
UIScienceView.AddOneWaitLoadLine = AddOneWaitLoadLine
UIScienceView.RefreshCells = RefreshCells
UIScienceView.OnResearchingScienceInfoChange = OnResearchingScienceInfoChange
UIScienceView.OnResearchingScienceInfoChangeWithId = OnResearchingScienceInfoChangeWithId
UIScienceView.QueueTimeEndSignal = QueueTimeEndSignal
UIScienceView.SetResBarVisible = SetResBarVisible
UIScienceView.IsUseHeroFreeAddTime = IsUseHeroFreeAddTime
UIScienceView.GetScienceGuideBtn = GetScienceGuideBtn
return UIScienceView
