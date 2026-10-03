local base = UIBaseView
local ActivityDecorationGachaBookView = BaseClass("ActivityDecorationGachaBookView", base)
local Localization = CS.GameEntry.Localization
local DecorationBookIllustratedDetailItem = require("UI.LWDecorationBook.Component.DecorationBookIllustratedDetailItem")
local DecorationBookIllustratedFilterItem = require("UI.LWDecorationBook.Component.DecorationBookIllustratedFilterItem")
local panelContainer_path = "safeArea/panelContainer"
local closeBtn_path = "safeArea/BottomBar/BtnBack"
local toggle_path = "safeArea/tabsSv/Viewport/Content/Toggle"
local segmentContainer_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/ToggleGroup"
local segment_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/ToggleGroup/Toggle"
local scroll_view_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/panelContainer/ScrollRect"
local content_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/panelContainer/ScrollRect/Content"
local filter_btn_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/FilterBtn"
local filter_content_path = "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/FilterContent"

function ActivityDecorationGachaBookView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function ActivityDecorationGachaBookView:OnDestroy()
  self:ClearItemCell()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaBookView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, "safeArea/BottomBar/BtnBack")
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.textActivityName = self:AddComponent(UIText, "safeArea/tabsSv/Viewport/Content/Toggle1/activityName")
  self.compRedPoint = self:AddComponent(UIBaseContainer, "safeArea/tabsSv/Viewport/Content/Toggle1/RedPoint")
  self.scrollPanel = self:AddComponent(UIBaseContainer, "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/panelContainer")
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.filter_btn = self:AddComponent(UIButton, filter_btn_path)
  self.filter_btn:SetOnClick(function()
    self:OnFilterBtnClick()
  end)
  self.toggle = self:AddComponent(UIToggle, "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/Toggle")
  self.toggle:SetOnValueChanged(function(tf)
    self:OnToggleValueChanged(tf)
  end)
  self.textToggle = self:AddComponent(UIText, "safeArea/panelContainer/UIDecorationBookillustratedDetail/safeArea/Toggle/ToggleText")
  self.filter_content = self:AddComponent(DecorationBookIllustratedFilterItem, filter_content_path)
  self.filter_content:SetActive(false)
end

function ActivityDecorationGachaBookView:ComponentDestroy()
  self.closeBtnN = nil
  self.textActivityName = nil
  self.scrollPanel = nil
  self.scroll_view = nil
  self.content = nil
  self.filter_btn = nil
  self.toggle = nil
  self.textToggle = nil
  self.filter_content = nil
  self.compRedPoint = nil
end

function ActivityDecorationGachaBookView:DataDefine()
  self.listGO = {}
  self.filterType = DecorationBookFilterType.All
end

function ActivityDecorationGachaBookView:DataDestroy()
  self.filterType = nil
  self.listGO = nil
  self.param = nil
end

function ActivityDecorationGachaBookView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorateRedPoint, self.OnRefreshCallback)
  self:AddUIListener(EventId.DecorateBookFilter, self.ChangeFilterType)
  self:AddUIListener(EventId.CloseDecorateBookFilter, self.OnCloseFilterContent)
  self:AddUIListener(EventId.BuildDecoNumChange, self.UpdateContent)
end

function ActivityDecorationGachaBookView:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorateRedPoint, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.DecorateBookFilter, self.ChangeFilterType)
  self:RemoveUIListener(EventId.CloseDecorateBookFilter, self.OnCloseFilterContent)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.UpdateContent)
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaBookView:OnOpen()
  self.param = self:GetUserData()
  self.textActivityName:SetLocalText("building_center_pagename2")
  local showToggle = self.param ~= nil and self.param.toggleFilterFunction ~= nil
  self.toggle:SetActive(showToggle)
  if showToggle then
    self.textToggle:SetText(self.param.toggleText)
    self.scrollPanel:SetOffsetMinXY(0, 330)
    self.toggle:SetIsOn(DataCenter.ActivityDecorationGachaManager:IsDecorationBoolFilterOn())
  else
    self.scrollPanel:SetOffsetMinXY(0, 240)
  end
  self:UpdateContent()
  self:RefreshRed()
end

function ActivityDecorationGachaBookView:UpdateContent(needSort)
  local useOldSort = needSort ~= nil and needSort == false
  if self.baseBuildingIdList == nil or not useOldSort then
    self.baseBuildingIdMap = DataCenter.BuildTemplateManager:GetNoBuyDecorateDataListByQuality()
    self.baseBuildingIdList = {}
    table.walk(self.baseBuildingIdMap, function(k, v)
      local toggleCheckOK = true
      if self.param ~= nil and self.param.toggleFilterFunction ~= nil and self.toggle:GetIsOn() and not self.param.toggleFilterFunction(k) then
        toggleCheckOK = false
      end
      if toggleCheckOK then
        local hasBuilding = DataCenter.BuildManager:HasBuilding(k, true)
        if self.filterType == DecorationBookFilterType.All or self.filterType == DecorationBookFilterType.Have and hasBuilding or self.filterType == DecorationBookFilterType.NotHave and not hasBuilding then
          local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(k)
          if desTemplate ~= nil and tonumber(desTemplate.para3) >= 3 then
            table.insert(self.baseBuildingIdList, k)
          end
        end
      end
    end)
    table.sort(self.baseBuildingIdList, function(a, b)
      local hasA = DataCenter.BuildManager:HasBuilding(a, true)
      local hasB = DataCenter.BuildManager:HasBuilding(b, true)
      if hasA ~= hasB then
        return hasA and true or false
      end
      local baseBuildDataA = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(a)
      local baseBuildDataB = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(b)
      if hasA and hasB then
        local buildDataA = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(a, true)
        local buildDataB = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(b, true)
        if buildDataA.state ~= buildDataB.state then
          local function GetStatePriority(state)
            if state == BuildingStateType.FoldUp then
              return 3
            end
            if state == BuildingStateType.Normal then
              return 2
            end
            return 1
          end
          
          return GetStatePriority(buildDataA.state) > GetStatePriority(buildDataB.state)
        end
        local isMaxA = buildDataA.level >= baseBuildDataA.max_level
        local isMaxB = buildDataB.level >= baseBuildDataB.max_level
        local hasCountA, needCountA = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataA.itemId, buildDataA.level, false)
        local hasCountB, needCountB = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataB.itemId, buildDataB.level, false)
        local canUpgradeA = needCountA <= hasCountA and not isMaxA
        local canUpgradeB = needCountB <= hasCountB and not isMaxB
        if canUpgradeA ~= canUpgradeB then
          return canUpgradeA and true or false
        end
        local canFixA = false
        local canFixB = false
        local lvTemplateA = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildDataA.itemId, buildDataA.level)
        if lvTemplateA and lvTemplateA.decoGroupUpgradeBaseId and lvTemplateA.decoGroupUpgradeBaseId > 0 then
          local curProgressA = buildDataA.prodStatus or 0
          local groupIdA = lvTemplateA.decoGroupUpgradeBaseId
          local curProgressInfoA = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdA, buildDataA.level, curProgressA)
          if curProgressInfoA then
            local fixCostA = toInt(curProgressInfoA.cost_item) or 0
            canFixA = hasCountA >= fixCostA and not isMaxA
          end
        end
        local lvTemplateB = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildDataB.itemId, buildDataB.level)
        if lvTemplateB and lvTemplateB.decoGroupUpgradeBaseId and lvTemplateB.decoGroupUpgradeBaseId > 0 then
          local curProgressB = buildDataB.prodStatus or 0
          local groupIdB = lvTemplateB.decoGroupUpgradeBaseId
          local curProgressInfoB = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdB, buildDataB.level, curProgressB)
          if curProgressInfoB then
            local fixCostB = toInt(curProgressInfoB.cost_item) or 0
            canFixB = hasCountB >= fixCostB and not isMaxB
          end
        end
        if canFixA ~= canFixB then
          return canFixA and true or false
        end
        if baseBuildDataA ~= nil and baseBuildDataB ~= nil and baseBuildDataA.para3 ~= baseBuildDataB.para3 then
          return baseBuildDataA.para3 > baseBuildDataB.para3
        end
        local hasCountAGlue, needCountAGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataA.itemId, buildDataA.level, true)
        local hasCountBGlue, needCountBGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataB.itemId, buildDataB.level, true)
        local canUpgradeAGlue = needCountAGlue <= hasCountAGlue and not isMaxA
        local canUpgradeBGlue = needCountBGlue <= hasCountBGlue and not isMaxB
        if canUpgradeAGlue ~= canUpgradeBGlue then
          return canUpgradeAGlue and true or false
        end
        local canFixAGlue = false
        local canFixBGlue = false
        if lvTemplateA and lvTemplateA.decoGroupUpgradeBaseId and lvTemplateA.decoGroupUpgradeBaseId > 0 then
          local curProgressA = buildDataA.prodStatus or 0
          local groupIdA = lvTemplateA.decoGroupUpgradeBaseId
          local curProgressInfoA = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdA, buildDataA.level, curProgressA)
          if curProgressInfoA then
            local fixCostA = toInt(curProgressInfoA.cost_item) or 0
            canFixAGlue = hasCountAGlue >= fixCostA and not isMaxA
          end
        end
        if lvTemplateB and lvTemplateB.decoGroupUpgradeBaseId and lvTemplateB.decoGroupUpgradeBaseId > 0 then
          local curProgressB = buildDataB.prodStatus or 0
          local groupIdB = lvTemplateB.decoGroupUpgradeBaseId
          local curProgressInfoB = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdB, buildDataB.level, curProgressB)
          if curProgressInfoB then
            local fixCostB = toInt(curProgressInfoB.cost_item) or 0
            canFixBGlue = hasCountBGlue >= fixCostB and not isMaxB
          end
        end
        if canFixAGlue ~= canFixBGlue then
          return canFixAGlue and true or false
        end
        if not isMaxA and not isMaxB then
          local lackCountA = needCountA - hasCountA
          local lackCountB = needCountB - hasCountB
          return lackCountA < lackCountB
        end
      end
      return baseBuildDataA.display_order_gallery < baseBuildDataB.display_order_gallery
    end)
  end
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.content:SetItemCount(#self.baseBuildingIdList)
  self.content:ForceUpdate()
end

function ActivityDecorationGachaBookView:RefreshAll()
  local tempIndex = self:RefreshTabs(self.curTabIndex)
  self:ChangeShowType(tempIndex)
end

function ActivityDecorationGachaBookView:OnRefreshCallback()
  self:RefreshRed()
  self:UpdateContent(false)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityDecorationGachaBookView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaBookView:RefreshRed()
  local show = false
  if self.param ~= nil and self.param.activityId ~= nil and DataCenter.ActivityDecorationGachaManager:GetDecorationBookUpgradeRedCount(self.param.activityId) > 0 then
    show = true
  end
  self.compRedPoint:SetActive(show)
end

function ActivityDecorationGachaBookView:ClearItemCell()
  self.scroll_view:RemoveComponents(DecorationBookIllustratedDetailItem)
  self.content:DestroyChildNode()
end

function ActivityDecorationGachaBookView:OnInitScroll(go, index)
  local item = self.scroll_view:AddComponent(DecorationBookIllustratedDetailItem, go)
  self.listGO[go] = item
end

function ActivityDecorationGachaBookView:OnUpdateScroll(go, index)
  if self.baseBuildingIdList ~= nil and self.baseBuildingIdList[index + 1] ~= nil then
    local conf = self.baseBuildingIdList[index + 1]
    go.name = conf
    local cellItem = self.listGO[go]
    if not cellItem then
      return
    end
    cellItem:SetData({
      baseBuildingIdList = self.baseBuildingIdList,
      index = index + 1,
      isShowUpArrowWhenFoldUp = true
    })
  end
end

function ActivityDecorationGachaBookView:OnDestroyScrollItem(go, index)
end

function ActivityDecorationGachaBookView:OnFilterBtnClick()
  self.filter_content:SetActive(true)
end

function ActivityDecorationGachaBookView:OnCloseFilterContent()
  self.filter_content:SetActive(false)
end

function ActivityDecorationGachaBookView:OnToggleValueChanged(tf)
  DataCenter.ActivityDecorationGachaManager:SetDecorationBoolFilter(self.toggle:GetIsOn())
  self:RefreshRed()
  self:UpdateContent()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityDecorationGachaBookView:ChangeFilterType(type)
  if self.filterType == type then
    return
  end
  self.filterType = type
  self:UpdateContent()
end

return ActivityDecorationGachaBookView
