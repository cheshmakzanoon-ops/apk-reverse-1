local UIBuildListCell = require("UI.UIBuildList.Component.UIBuildListCell")
local UIBuildListTabTypeCell = require("UI.UIBuildList.Component.UIBuildListTabTypeCell")
local UIBuildRobotFreeView = require("UI.UIBuildList.Component.UIBuildRobotFreeView")
local UIBuildBuffList = require("UI.UIBuildList.Component.UIBuildBuffList")
local UIBuildBuffDetail = require("UI.UIBuildList.Component.UIBuildBuffDetail")
local UIBuildListView = BaseClass("UIBuildListView", UIBaseView)
local base = UIBaseView
local UserDataRange = 10
local BuildingRange = 10000
local HideProtectTime = 2
local return_btn_path = "Panel"
local scroll_view_path = "ScrollView"
local tab_type1_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem1"
local tab_type2_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem2"
local tab_type3_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem3"
local tab_type4_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem4"
local tab_type5_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem5"
local tab_type6_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem6"
local tab_type7_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem7"
local tab_type8_path = "mainBg/tabScrollView/Viewport/Content/buildSelectItem8"
local tab_scroll_view_path = "mainBg/tabScrollView"
local main_bg_path = "mainBg"
local gray_go_path = "GrayGo"
local content_path = "ScrollView/Viewport/Content"
local select_go_path = "SelectGo"
local select_text_path = "SelectGo/SelectDesText"
local btnRecommendBuildList_path = "mainBg/btnRecommendBuildList"
local BuildRobotFree_path = "BuildRobotFree"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:UpDateBuildListBtnState()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:HideBuffDetail()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.gray_go = self:AddComponent(UIImage, gray_go_path)
  self.select_go = self:AddComponent(UIAnimator, select_go_path)
  self.select_text = self:AddComponent(UIText, select_text_path)
  self.main_bg = self:AddComponent(UIBaseContainer, main_bg_path)
  self.noDecorateBtn = self:AddComponent(UIText, "NoDecorateBtn")
  self.btnRecommendBuildList = self:AddComponent(UIButton, btnRecommendBuildList_path)
  self.btnRecommendBuildList:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.RecommendBtnClick1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRecommendBuildList)
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.content_anim = self:AddComponent(UIAnimator, content_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, content_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.return_btn:SetOnClick(function()
    self:DoWhenClickReturnBtn()
  end)
  self.buff_list = self:AddComponent(UIBuildBuffList, "BuildingBuff")
  self.tabTypeCells = {}
  self.tabTypeCells[UIBuildListTabType.Decorate] = self:AddComponent(UIBuildListTabTypeCell, tab_type4_path)
  self.tabTypeCells[UIBuildListTabType.Economy] = self:AddComponent(UIBuildListTabTypeCell, tab_type2_path)
  self.tabTypeCells[UIBuildListTabType.Military] = self:AddComponent(UIBuildListTabTypeCell, tab_type3_path)
  self.tabTypeCells[UIBuildListTabType.SeasonBuild] = self:AddComponent(UIBuildListTabTypeCell, tab_type6_path)
  self.tabTypeCells[UIBuildListTabType.SeasonCityBuild] = self:AddComponent(UIBuildListTabTypeCell, tab_type8_path)
  self.tab_scroll_view = self:AddComponent(UIScrollRect, tab_scroll_view_path)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.tabTypeCells = nil
  self.gray_go = nil
  self.content_anim = nil
  self.scroll_view = nil
  self.select_go = nil
  self.select_text = nil
  self:HideRobotFreeView()
  self.robotFreeView = nil
  self.tab_scroll_view = nil
  if self.t then
    self.t:Stop()
    self.t = nil
  end
  if self.allianceTipReq then
    self.allianceTipReq:Destroy()
    self.allianceTipReq = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.isTabClick = nil
end

local function OnDrag(self, eventData)
  self.scroll_view:OnDrag(eventData)
end

local function OnBeginDrag(self, eventData)
  self:HideRobotFreeView()
  self.scroll_view:OnBeginDrag(eventData)
end

local function OnEndDrag(self, eventData)
  self.scroll_view:OnEndDrag(eventData)
end

local function DataDefine(self)
  self.gray = self.gray_go:GetMaterial()
  self.tabType = nil
  self.selectBuildId = nil
  self.buildIds = {}
  self.list = {}
  self.cells = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.animIndex = 1
  self.isLoad = false
  self.isSendResCancel = true
  self.loadAfter = true
  self.InitCell = nil
  self.allAnimNum = 0
  self.isArrow = false
  self.stationBuildUuid = nil
  self.guideSpecialBuildId = nil
  self.pointId = 0
end

local function DataDestroy(self)
  Setting:SetPrivateInt("UIBuildListSeasonBuild", 0)
  DataCenter.BuildQueueManager:ClearWillUpgradeParam()
  if self.tabType ~= UIBuildListTabType.SeasonBuild then
    DataCenter.BuildManager.buildListTab = self.tabType
  end
  self.stationBuildUuid = nil
  self.timer_action = nil
  self:DeleteTimer()
  self.gray = nil
  self.tabType = nil
  self.selectBuildId = nil
  self.buildIds = nil
  self.list = nil
  self.cells = nil
  self.animIndex = nil
  self.isLoad = nil
  self.isSendResCancel = nil
  self.loadAfter = nil
  self.InitCell = nil
  self.allAnimNum = nil
  self.isArrow = nil
  self.guideSpecialBuildId = nil
  self.pointId = 0
  self.hideProtect = nil
  self.openTime = nil
  if self.allianceTipReq then
    self.allianceTipReq:Destroy()
    self.allianceTipReq = nil
  end
  self.allianceTips = nil
  if self.allianceScaleTween then
    self.allianceScaleTween:Kill()
    self.allianceScaleTween = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:UpDateBuildListBtnState()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_BuildList, false)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.select_go:SetActive(false)
  local buildIdStr, isArrow, stationBuildUuid, isSeasonMode, pointId, hideProtect = self:GetUserData()
  self.isArrow = isArrow
  self.isSeasonMode = false
  self.pointId = pointId or 0
  self.hideProtect = hideProtect or false
  if self.hideProtect then
    self.openTime = Time.realtimeSinceStartup
  end
  if isSeasonMode ~= nil and isSeasonMode == 1 or buildIdStr == UIBuildListTabType.SeasonBuild then
    self.isSeasonMode = true
  end
  self.ctrl.isSeasonMode = self.isSeasonMode
  self:CheckGuide()
  if not self.isGuide then
    if stationBuildUuid ~= nil then
      self.stationBuildUuid = tonumber(stationBuildUuid)
    end
    if buildIdStr ~= nil then
      local tempTab = tonumber(buildIdStr)
      tempTab = tonumber(buildIdStr)
      if tempTab > BuildingRange then
        self.selectBuildId = tempTab
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.selectBuildId)
        if template ~= nil then
          self.tabType = template.tab_type
        end
      elseif tempTab > UserDataRange then
        self.selectBuildId = tempTab - 1000
        self.tabType = self.isSeasonMode and UIBuildListTabType.SeasonBuild or UIBuildListTabType.Economy
      else
        self.tabType = tempTab
      end
    else
      self.tabType = nil
    end
  end
  local isOpenSeasonBuildInCity = SeasonUtil.IsOpenSeasonBuildInCity()
  if self.isSeasonMode == true then
    self.tabType = UIBuildListTabType.SeasonBuild
  elseif isOpenSeasonBuildInCity and buildIdStr == nil then
    self.tabType = UIBuildListTabType.SeasonCityBuild
  end
  self:CheckSpecialGuide()
  for k, v in pairs(self.tabTypeCells) do
    v:ReInit(k)
    if k == UIBuildListTabType.SeasonBuild then
      v:SetActive(self.isSeasonMode and SceneUtils.GetIsInWorld())
    elseif k == UIBuildListTabType.SeasonCityBuild then
      v:SetActive(isOpenSeasonBuildInCity and SceneUtils.GetIsInCity())
    elseif k == UIBuildListTabType.Decorate then
      local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.BuildListDecorate)
      v:SetActive(self.isSeasonMode == false and unlock)
    else
      v:SetActive(self.isSeasonMode == false)
    end
  end
  self.animIndex = 1
  self:AddTimer()
  self.buff_list:ReInit(self.isSeasonMode)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GOTO_BUILD, self.GoToBuildSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
  self:AddUIListener(EventId.Build_Time_End, self.BuildTimeEndSignal)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.UIBuildListScrollMove, self.UIBuildListScrollMoveSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GOTO_BUILD, self.GoToBuildSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
  self:RemoveUIListener(EventId.Build_Time_End, self.BuildTimeEndSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.UIBuildListScrollMove, self.UIBuildListScrollMoveSignal)
end

local function OnTabTypeSelect(self, tabType, showArrow)
  self.isArrow = showArrow
  if self.tabType ~= tabType then
    self:SetTabTypeSelect(self.tabType, false)
    self.tabType = tabType
    self:SetTabTypeSelect(self.tabType, true)
    self.isTabClick = true
    self:ShowCells()
    self.isTabClick = false
    self:TryShowArrow()
  end
  self:HideRobotFreeView()
  EventManager:GetInstance():Broadcast(EventId.GF_build_list_tab_selected, tabType)
end

local function SetTabTypeSelect(self, tabType, value)
  if self.tabTypeCells[tabType] ~= nil then
    self.tabTypeCells[tabType]:SetSelect(value)
  end
end

local function ShowCells(self)
  self:RefreshRedDot()
  self:ClearScroll()
  self.list = self:GetSelectBuildIds()
  local open = DataCenter.LoginGuideManager:BattleCenterBuildingCondition()
  local battleCenterId = DataCenter.LoginGuideManager:GetBattleCenterBuildingId()
  local guided = DataCenter.LWGuideFlowManager:ReadDone(4507)
  if open and not guided then
    table.sort(self.list, function(a, b)
      local a_target = a.id == battleCenterId and a.state == BuildState.BUILD_LIST_STATE_OK and 1 or 0
      local b_target = b.id == battleCenterId and b.state == BuildState.BUILD_LIST_STATE_OK and 1 or 0
      if a_target ~= b_target then
        return a_target > b_target
      end
      return false
    end)
  end
  local tempCount = table.count(self.list)
  self.scroll_view:SetActive(true)
  self.noDecorateBtn:SetActive(false)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.isLoad = true
    if self.guideSpecialBuildId ~= nil then
      for i = 1, tempCount do
        if self.list[i].id == self.guideSpecialBuildId then
          if i < tempCount then
            self.scroll_view:RefillCells(i + 1)
          end
          break
        end
      end
      self.allAnimNum = self.scroll_view:GetChildCount()
      if DataCenter.GuideManager:GetGuideType() == GuideType.UIBuildListSpecial then
        DataCenter.GuideManager:DoNext()
      end
    else
      self.scroll_view:RefillCells()
      self.allAnimNum = self.scroll_view:GetChildCount()
      if self.isArrow then
        for i = 1, tempCount do
          if self.list[i].id == self.selectBuildId then
            self.scroll_view:RefillCells(i)
            break
          end
        end
      else
        self.scroll_view:RefillCells()
      end
    end
  elseif self.tabType == UIBuildListTabType.Decorate then
    self.scroll_view:SetActive(false)
    self.noDecorateBtn:SetActive(true)
  end
end

local function OnCellMoveIn(self, itemObj, index)
  local param = {}
  local data = self.list[index]
  param.buildType = data.buildType
  param.buildId = data.id
  param.buildDataList = data.buildDataList
  param.buildTemplate = data.buildTemplate
  param.scrollView = self.scroll_view
  param.gray = self.gray
  param.state = data.state
  param.isDelay = not self.isLoad
  param.isBuy = data.isBuy
  itemObj.name = tostring(param.buildId) .. "index" .. index
  local cellItem = self.scroll_view:AddComponent(UIBuildListCell, itemObj)
  cellItem:ReInit(param, self.isTabClick, index, self.allAnimNum)
  self.cells[index] = cellItem
end

local function OnCellMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UIBuildListCell)
end

local function ClearScroll(self)
  if self.scroll_view ~= nil then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIBuildListCell)
  end
  self.cells = {}
end

local function GetSelectBuildIds(self)
  local stateDic = {}
  local tempResult = self.buildIds[self.tabType]
  if self.tabType == UIBuildListTabType.Decorate then
    tempResult = self.ctrl:GetAllDecorate()
  end
  if self.tabType == UIBuildListTabType.SeasonCityBuild then
    local filter = {}
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    local seasonBuildingGroup = tostring(config.building)
    for key, value in pairs(tempResult) do
      if value.buildTemplate.season_group == seasonBuildingGroup then
        table.insert(filter, value)
      end
    end
    tempResult = filter
  end
  if tempResult ~= nil then
    if self.tabType == UIBuildListTabType.Economy or self.tabType == UIBuildListTabType.Military or self.tabType == UIBuildListTabType.SeasonBuild or self.tabType == UIBuildListTabType.SeasonCityBuild then
      table.sort(tempResult, function(a, b)
        local state1 = stateDic[a.id]
        if state1 == nil then
          state1 = DataCenter.BuildManager:GetBuildState(a.id)
          stateDic[a.id] = state1
          a.state = state1
        end
        local state2 = stateDic[b.id]
        if state2 == nil then
          state2 = DataCenter.BuildManager:GetBuildState(b.id)
          stateDic[b.id] = state2
          b.state = state2
        end
        if self.tabType == UIBuildListTabType.SeasonBuild and (state1 == BuildState.BUILD_LIST_STATE_OK or state1 == BuildState.BUILD_LIST_RECEIVED) and (state2 == BuildState.BUILD_LIST_STATE_OK or state2 == BuildState.BUILD_LIST_RECEIVED) then
          local allianceCenterIdA = a.allianceCenterId
          local allianceCenterIdB = b.allianceCenterId
          local allianceCenterAData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterIdA)
          local allianceCenterBData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterIdB)
          local canPlaceA = allianceCenterAData ~= nil
          local canPlaceB = allianceCenterBData ~= nil
          if canPlaceA and canPlaceB then
            canPlaceA = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(self.pointId, allianceCenterIdA)
            canPlaceB = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(self.pointId, allianceCenterIdB)
          end
          if canPlaceA ~= canPlaceB then
            if canPlaceB then
              return false
            elseif canPlaceA then
              return true
            end
          end
        end
        if not self.isArrow then
          if a.id == self.selectBuildId then
            return true
          end
          if b.id == self.selectBuildId then
            return false
          end
        end
        if (state1 == BuildState.BUILD_LIST_PREBUILD or state1 == BuildState.BUILD_LIST_REACH_CUR_MAX) and (state2 == BuildState.BUILD_LIST_PREBUILD or state2 == BuildState.BUILD_LIST_REACH_CUR_MAX) then
          local aNeedBaseLevel = -1
          local aCurBaseLevel = LongMaxValue
          local bNeedBaseLevel = -1
          local bCurBaseLevel = LongMaxValue
          if state1 == BuildState.BUILD_LIST_PREBUILD then
            aNeedBaseLevel = a.needLevel
          elseif state1 == BuildState.BUILD_LIST_REACH_CUR_MAX then
            local unlockInfo = a.buildTemplate:GetCurNoBuildUnlockBuildInfo()
            if unlockInfo ~= nil then
              if unlockInfo.canBuildNun == 1 then
                aNeedBaseLevel = unlockInfo.level
              elseif unlockInfo.canBuildNun > 1 then
                aCurBaseLevel = unlockInfo.level
              end
            end
          end
          if state2 == BuildState.BUILD_LIST_PREBUILD then
            bNeedBaseLevel = b.needLevel
          elseif state2 == BuildState.BUILD_LIST_REACH_CUR_MAX then
            local unlockInfo = b.buildTemplate:GetCurNoBuildUnlockBuildInfo()
            if unlockInfo ~= nil then
              if unlockInfo.canBuildNun == 1 then
                bNeedBaseLevel = unlockInfo.level
              elseif unlockInfo.canBuildNun > 1 then
                bCurBaseLevel = unlockInfo.level
              end
            end
          end
          if aCurBaseLevel == bCurBaseLevel then
            if aCurBaseLevel < LongMaxValue then
              if a.order == b.order then
                return a.id < b.id
              else
                return a.order < b.order
              end
            elseif aNeedBaseLevel == bNeedBaseLevel then
              if a.order == b.order then
                return a.id < b.id
              else
                return a.order < b.order
              end
            else
              return aNeedBaseLevel < bNeedBaseLevel
            end
          else
            return aCurBaseLevel < bCurBaseLevel
          end
        end
        if state1 == state2 then
          local redDotA = state1 == BuildState.BUILD_LIST_STATE_OK and DataCenter.BuildManager:IsShowRedDotByOnce(a.id)
          local redDotB = state2 == BuildState.BUILD_LIST_STATE_OK and DataCenter.BuildManager:IsShowRedDotByOnce(b.id)
          if redDotA ~= redDotB then
            if redDotB then
              return false
            elseif redDotA then
              return true
            end
          end
          if a.order == b.order then
            return a.id < b.id
          else
            return a.order < b.order
          end
        else
          return state1 < state2
        end
        return a.id < b.id
      end)
    elseif self.tabType == UIBuildListTabType.Decorate then
      table.sort(tempResult, function(a, b)
        local stateA = DataCenter.BuildManager:GetBuildState(a.id)
        local stateB = DataCenter.BuildManager:GetBuildState(b.id)
        local showRedDotA = DataCenter.BuildManager:IsDecorateBuildingShowRedDotByTemplateAndState(a.buildTemplate, stateA)
        local showRedDotB = DataCenter.BuildManager:IsDecorateBuildingShowRedDotByTemplateAndState(b.buildTemplate, stateB)
        if showRedDotA ~= showRedDotB then
          return showRedDotA == true and true or false
        end
        if type(a.buildDataList) ~= type(b.buildDataList) then
          return a.buildDataList ~= nil and true or false
        end
        if a.buildDataList and b.buildDataList then
          local listA = BuildingUtils.GetDecorateUpLevelBuilds(a.buildDataList[1])
          local listB = BuildingUtils.GetDecorateUpLevelBuilds(b.buildDataList[1])
          local canUpgradeA = listA and not listA[#listA].nextScore
          local canUpgradeB = listB and not listB[#listB].nextScore
          if canUpgradeA ~= canUpgradeB then
            return canUpgradeA == true and true or false
          end
        end
        if a.order ~= b.order then
          return a.order < b.order
        end
        return a.id > b.id
      end)
    end
  end
  if tempResult ~= nil then
    local isSeasonOpen = SeasonUtil.IsOpen()
    local tmp = {}
    for _, data in ipairs(tempResult) do
      if data and (isSeasonOpen or data.id ~= BuildingTypes.SEASON_CAREER_BUILD) then
        local state = stateDic[data.id] or DataCenter.BuildManager:GetBuildState(data.id)
        if state ~= BuildState.BUILD_LIST_SEASON_TIME_CONDITION and state ~= BuildState.BUILD_LIST_SEASON_TIME_PRE_CONDITION and state ~= BuildState.BUILD_LIST_TABLE_SWITCH_CONDITION and (data.id ~= BuildingTypes.LW_BUILD_RACE_ENTRANCE or RaceEntranceUtil.IsNewEntranceOpen()) then
          table.insert(tmp, data)
        end
      end
    end
    tempResult = tmp
  end
  return tempResult
end

local function SetTabType(self)
  self.buildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  if self.tabType == nil then
    self.tabType = self.isSeasonMode and UIBuildListTabType.SeasonBuild or UIBuildListTabType.Economy
  end
end

local function GoToBuildSignal(self, buildParam)
  local buildId = buildParam.buildId
  if buildId ~= nil then
    local showArrow = buildParam.showArrow
    self.selectBuildId = tonumber(buildId)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.selectBuildId)
    if template ~= nil then
      if self.tabType == template.tab_type then
        self:ShowCells()
      else
        self:OnTabTypeSelect(template.tab_type, showArrow)
      end
    end
  end
end

local function UpdateResourceSignal(self)
  for k, v in pairs(self.cells) do
    v:RefreshResource()
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    local time = self.content_anim:GetFloat("DuringTime")
    self.timer = TimerManager:GetInstance():GetTimer(time / 10, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.InitCell then
    self.InitCell = false
    self:ShowCells()
    for i = 1, self.allAnimNum do
      local temp = self.cells[i]
      if temp ~= nil then
        temp:DoEnterAnimDefault()
      end
    end
  end
  if self.loadAfter then
    self.loadAfter = false
    self.InitCell = true
    self:SetTabType()
    for k, v in pairs(self.tabTypeCells) do
      v:SetSelect(k == self.tabType)
    end
  end
  if self.isLoad then
    if self.allAnimNum >= self.animIndex then
      if self.cells[self.animIndex] ~= nil then
        self.cells[self.animIndex]:DoEnterAnim()
      end
      self.animIndex = self.animIndex + 1
    else
      self:TryShowArrow()
      self:DeleteTimer()
    end
  end
end

local function TryShowArrow(self, delayed)
  if self.isArrow then
    self.scroll_view:StopMovement()
    local param = {}
    param.arrowType = ArrowType.Building
    param.positionType = PositionType.Screen
    local idx
    for i, v in pairs(self.cells) do
      if v.param.buildId == self.selectBuildId then
        if self.tabType ~= UIBuildListTabType.Road and self.selectBuildId < BuildingRange then
          param.position = self.cells[i]:GetBtnPos()
        else
          param.position = self.cells[i]:GetPos()
        end
        idx = i
        break
      end
    end
    if param.position ~= nil then
      DataCenter.ArrowManager:ShowArrow(param)
    end
    self.selectBuildId = nil
  end
end

local function TryShowAllianceTips(self)
  local find = false
  local followPos
  for k, v in pairs(self.cells) do
    if v ~= nil and v.gameObject.activeSelf and v.buildTemplate.id == BuildingTypes.LW_BUILD_ALLIANCE_CENTER then
      local siblingIndex = v.transform:GetSiblingIndex()
      local screenPos = PosConverse.UIWorldToScreenPos(v.transform.position)
      if screenPos.x > 90 and screenPos.x < 500 then
        find = true
        followPos = v:GetPos()
        if self.allianceTipReq == nil then
          self.allianceTipReq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/UILWAllianceBuildingTips/AllianceBuildingTips.prefab")
          self.allianceTipReq:completed("+", function()
            self.allianceTips = self.allianceTipReq.gameObject
            self.allianceTips.transform:SetParent(self.return_btn.transform.parent)
            self.allianceTips.transform:Set_localScale(0, 0, 0)
          end)
        end
        if self.allianceTips then
          self.allianceTips.transform:Set_position(followPos.x, followPos.y, followPos.z)
          local x, y = self.allianceTips.transform:Get_anchoredPosition()
          self.allianceTips.transform:Set_anchoredPosition(x, y + 160)
          if not self.allianceTipsShow then
            self.allianceTipsShow = true
            self.allianceTips.transform:Set_localScale(0, 0, 0)
            if self.allianceScaleTween then
              self.allianceScaleTween:Kill()
              self.allianceScaleTween = nil
            end
            self.allianceScaleTween = self.allianceTips.transform:DOScale(Vector3.New(1.02, 1.02, 1), 0.2):SetEase(CS.DG.Tweening.Ease.OutBack)
          end
        end
      end
      break
    end
  end
  if not find and self.allianceTips then
    if followPos then
      self.allianceTips.transform:Set_position(followPos.x, followPos.y, followPos.z)
      local x, y = self.allianceTips.transform:Get_anchoredPosition()
      self.allianceTips.transform:Set_anchoredPosition(x, y + 160)
    end
    if self.allianceTipsShow then
      self.allianceTipsShow = false
      if self.allianceScaleTween then
        self.allianceScaleTween:Kill()
        self.allianceScaleTween = nil
      end
      self.allianceScaleTween = self.allianceTips.transform:DOScale(Vector3.New(0, 0, 0), 0.1):OnComplete(function()
        if self.allianceTipReq then
          self.allianceTipReq:Destroy()
          self.allianceTipReq = nil
          self.allianceTips = nil
        end
      end):SetEase(CS.DG.Tweening.Ease.Linear)
    end
  end
end

local function SetCancelRedGreen(self, isSend)
  self.isSendResCancel = isSend
end

local function UpdateBuildSignal(self, data)
  self:ShowCells()
end

local function BuildTimeEndSignal(self, data)
  self:ShowCells()
end

local function RefreshRedDot(self)
  for k, v in pairs(self.tabTypeCells) do
    local redDotNum = DataCenter.BuildManager:GetBuildRedDotByTabType(k)
    v:RefreshRedDot(redDotNum)
  end
end

local function Update(self)
  if self.loadAfter == false and table.count(self.cells) > 0 then
    table.walk(self.cells, function(k, v)
      v:UpdateSlider()
    end)
  end
end

local function CheckGuide(self)
  self.isGuide = false
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil and guideTemplate.para3 ~= nil and guideTemplate.para3 ~= "" and guideTemplate.type == GuideType.ClickButton then
      self.isGuide = true
      self.selectBuildId = tonumber(guideTemplate.para3)
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.selectBuildId)
      if template ~= nil then
        self.tabType = template.tab_type
      end
    end
  end
  self.scroll_view:SetEnable(not self.isGuide)
end

local function RefreshGuideSignal(self)
  if self.guideSpecialBuildId == nil then
    self:CheckGuide()
    if self.selectBuildId ~= nil and self.selectBuildId > BuildingRange then
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.selectBuildId)
      if template ~= nil then
        if self.tabType == template.tab_type then
          self:ShowCells()
        else
          self:OnTabTypeSelect(template.tab_type)
        end
      end
    end
  end
end

local function ShowRobotFreeView(self, robotQueueIndex, pos)
  local clickBuild = self.ctrl:DoWhenClickBuild(robotQueueIndex)
  if not clickBuild then
    self.ctrl:DoWhenClickScience()
  end
end

local function HideRobotFreeView(self)
  if self.robotFreeView ~= nil then
    self.robotFreeView:SetActive(false)
  end
end

local function DoWhenClickReturnBtn(self)
  if self.hideProtect and self.openTime and Time.realtimeSinceStartup - self.openTime < HideProtectTime then
    return
  end
  if self.robotFreeView ~= nil and self.robotFreeView:GetActive() then
    self.robotFreeView:SetActive(false)
  else
    self:SetCancelRedGreen(true)
    self.ctrl:CloseSelf(true)
  end
end

local function CheckSpecialGuide(self)
  self.guideSpecialBuildId = nil
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil and guideTemplate.type == GuideType.UIBuildListSpecial then
      self.guideSpecialBuildId = tonumber(guideTemplate.para2)
      self.selectBuildId = nil
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.guideSpecialBuildId)
      if template ~= nil then
        self.tabType = template.tab_type
      end
    end
  end
end

local function UIBuildListScrollMoveSignal(self, buildId)
  for i = 1, #self.list do
    if self.list[i].id == buildId then
      self.scroll_view:ScrollToCell(i, 1000)
      break
    end
  end
end

local function SetBuffDetailActive(self, type, pos)
  if self.buff_detail == nil or self.buff_detail:GetCurType() ~= type then
    self:OpenBuffDetail(type, pos)
  else
    self:HideBuffDetail()
  end
end

local function OpenBuffDetail(self, type, pos)
  if self.buff_detail == nil then
    self.buff_detail = self:AddComponent(UIBuildBuffDetail, "BuildingBuffIntro")
  end
  self.buff_detail:SetActive(true)
  self.buff_detail:ReInit(type, self.isSeasonMode)
  self.buff_detail.transform:Set_position(pos.x, pos.y, pos.z)
end

local function HideBuffDetail(self)
  if self.buff_detail ~= nil then
    self.buff_detail:SetActive(false)
    self.buff_detail:ResetCurType()
  end
end

function UIBuildListView:UpDateBuildListBtnState()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_RADAR_CENTER)
  local state = false
  if table.IsNullOrEmpty(buildList) then
    self.btnRecommendBuildList:SetActive(state)
    return
  else
    for key, value in pairs(buildList) do
      if value.level > 0 then
        state = true
        break
      end
    end
  end
  self.btnRecommendBuildList:SetActive(state)
end

UIBuildListView.OnCreate = OnCreate
UIBuildListView.OnDestroy = OnDestroy
UIBuildListView.OnEnable = OnEnable
UIBuildListView.OnDisable = OnDisable
UIBuildListView.OnAddListener = OnAddListener
UIBuildListView.OnRemoveListener = OnRemoveListener
UIBuildListView.ComponentDefine = ComponentDefine
UIBuildListView.ComponentDestroy = ComponentDestroy
UIBuildListView.DataDefine = DataDefine
UIBuildListView.DataDestroy = DataDestroy
UIBuildListView.ReInit = ReInit
UIBuildListView.OnTabTypeSelect = OnTabTypeSelect
UIBuildListView.SetTabTypeSelect = SetTabTypeSelect
UIBuildListView.GetSelectBuildIds = GetSelectBuildIds
UIBuildListView.ShowCells = ShowCells
UIBuildListView.OnCellMoveIn = OnCellMoveIn
UIBuildListView.OnCellMoveOut = OnCellMoveOut
UIBuildListView.ClearScroll = ClearScroll
UIBuildListView.GoToBuildSignal = GoToBuildSignal
UIBuildListView.UpdateResourceSignal = UpdateResourceSignal
UIBuildListView.DeleteTimer = DeleteTimer
UIBuildListView.AddTimer = AddTimer
UIBuildListView.RefreshTime = RefreshTime
UIBuildListView.TryShowArrow = TryShowArrow
UIBuildListView.TryShowAllianceTips = TryShowAllianceTips
UIBuildListView.SetCancelRedGreen = SetCancelRedGreen
UIBuildListView.UpdateBuildSignal = UpdateBuildSignal
UIBuildListView.SetTabType = SetTabType
UIBuildListView.RefreshRedDot = RefreshRedDot
UIBuildListView.Update = Update
UIBuildListView.BuildTimeEndSignal = BuildTimeEndSignal
UIBuildListView.CheckGuide = CheckGuide
UIBuildListView.RefreshGuideSignal = RefreshGuideSignal
UIBuildListView.ShowRobotFreeView = ShowRobotFreeView
UIBuildListView.DoWhenClickReturnBtn = DoWhenClickReturnBtn
UIBuildListView.HideRobotFreeView = HideRobotFreeView
UIBuildListView.OnDrag = OnDrag
UIBuildListView.OnBeginDrag = OnBeginDrag
UIBuildListView.OnEndDrag = OnEndDrag
UIBuildListView.CheckSpecialGuide = CheckSpecialGuide
UIBuildListView.UIBuildListScrollMoveSignal = UIBuildListScrollMoveSignal
UIBuildListView.OpenBuffDetail = OpenBuffDetail
UIBuildListView.HideBuffDetail = HideBuffDetail
UIBuildListView.SetBuffDetailActive = SetBuffDetailActive
return UIBuildListView
