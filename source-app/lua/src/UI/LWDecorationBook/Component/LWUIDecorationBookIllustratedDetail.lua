local base = UIBaseView
local LWUIDecorationBookIllustratedDetail = BaseClass("LWUIDecorationBookIllustratedDetail", base)
local DecorationBookIllustratedDetailItem = require("UI.LWDecorationBook.Component.DecorationBookIllustratedDetailItem")
local DecorationBookIllustratedFilterItem = require("UI.LWDecorationBook.Component.DecorationBookIllustratedFilterItem")
local SegmentType = {
  UR = 1,
  SSR = 2,
  SR = 3
}
local SegmentName = {
  [SegmentType.UR] = "UR",
  [SegmentType.SSR] = "SSR",
  [SegmentType.SR] = "SR"
}
local segmentContainer_path = "safeArea/ToggleGroup"
local segment_path = "safeArea/ToggleGroup/Toggle"
local scroll_view_path = "safeArea/panelContainer/ScrollRect"
local content_path = "safeArea/panelContainer/ScrollRect/Content"
local filter_btn_path = "safeArea/FilterBtn"
local filter_content_path = "safeArea/FilterContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.listGO = {}
  self.filterType = DecorationBookFilterType.All
end

local function OnDestroy(self)
  self:ClearItemCell()
  self:ComponentDestroy()
  self.listGO = nil
  self.filterType = nil
  base.OnDestroy(self)
end

function LWUIDecorationBookIllustratedDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorateRedPoint, self.OnDecorateRedPoint)
  self:AddUIListener(EventId.DecorateBookFilter, self.ChangeFilterType)
  self:AddUIListener(EventId.CloseDecorateBookFilter, self.OnCloseFilterContent)
  self:AddUIListener(EventId.BuildDecoNumChange, self.RefreshCurPanel)
  self:AddUIListener(EventId.DecorationBookRecommendOpenChanged, self.OnSwitchRecommendSuccess)
end

function LWUIDecorationBookIllustratedDetail:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DecorateRedPoint, self.OnDecorateRedPoint)
  self:RemoveUIListener(EventId.DecorateBookFilter, self.ChangeFilterType)
  self:RemoveUIListener(EventId.CloseDecorateBookFilter, self.OnCloseFilterContent)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.RefreshCurPanel)
  self:RemoveUIListener(EventId.DecorationBookRecommendOpenChanged, self.OnSwitchRecommendSuccess)
end

local function RefreshCurPanel(self, needSort)
  DataCenter.DecorationRecommendManager:SetCacheDataDirty()
  self:ShowSegPanel(6 - self.curSegment, needSort)
  self:RefreshRed()
  self:RefreshToggleRecommendTag()
end

local function ChangeFilterType(self, type)
  if self.filterType == type then
    return
  end
  self.filterType = type
  self:RefreshCurPanel()
end

local function OnCloseFilterContent(self)
  self.filter_content:SetActive(false)
end

local function ShowPanel(self)
  DataCenter.DecorationRecommendManager:SetCacheDataDirty()
  self:OnClickSegment(1)
  self:RefreshRed()
  self:RefreshToggleRecommendTag()
  EventManager:GetInstance():Broadcast(EventId.GF_open_decoration_bool_detail)
end

local function ShowSegPanel(self, quality, needSort)
  local useOldSort = needSort ~= nil and needSort == false
  if self.baseBuildingIdList == nil or not useOldSort then
    self.baseBuildingIdMap = DataCenter.BuildTemplateManager:GetNoBuyDecorateDataListByQuality(quality)
    self.baseBuildingIdList = {}
    table.walk(self.baseBuildingIdMap, function(k, v)
      local hasBuilding = DataCenter.BuildManager:HasBuilding(k, true)
      if self.filterType == DecorationBookFilterType.All or self.filterType == DecorationBookFilterType.Have and hasBuilding or self.filterType == DecorationBookFilterType.NotHave and not hasBuilding then
        table.insert(self.baseBuildingIdList, k)
      end
    end)
    local isDecorationRecommendOn = DataCenter.DecorationRecommendManager:IsFunctionOn() and DataCenter.DecorationRecommendManager:GetIsOn() and self.filterType ~= DecorationBookFilterType.NotHave
    table.sort(self.baseBuildingIdList, function(a, b)
      local hasA = DataCenter.BuildManager:HasBuilding(a, true)
      local hasB = DataCenter.BuildManager:HasBuilding(b, true)
      if hasA ~= hasB then
        return hasA and true or false
      end
      local baseBuildDataA = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(a)
      local baseBuildDataB = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(b)
      if hasA and hasB then
        if isDecorationRecommendOn then
          local recommendBuildBaseId = DataCenter.DecorationRecommendManager:GetRecommendBuildBaseId()
          local isARecommend = recommendBuildBaseId ~= nil and a == recommendBuildBaseId
          local isBRecommend = recommendBuildBaseId ~= nil and b == recommendBuildBaseId
          if isARecommend ~= isBRecommend then
            return isARecommend and true or false
          end
        end
        local buildDataA = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(a, true)
        local buildDataB = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(b, true)
        local pIdA = buildDataA and buildDataA.pointId or 0
        local pIdB = buildDataB and buildDataB.pointId or 0
        local unplacedA = pIdA == 0
        local unplacedB = pIdB == 0
        if unplacedA ~= unplacedB then
          return unplacedA
        end
        if buildDataA.state ~= buildDataB.state then
          return buildDataA.state == BuildingStateType.Normal and true or false
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
        if lvTemplateA and lvTemplateA.decoGroupUpgradeBaseId and 0 < lvTemplateA.decoGroupUpgradeBaseId then
          local curProgressA = buildDataA.prodStatus or 0
          local groupIdA = lvTemplateA.decoGroupUpgradeBaseId
          local curProgressInfoA = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdA, buildDataA.level, curProgressA)
          if curProgressInfoA then
            local fixCostA = toInt(curProgressInfoA.cost_item) or 0
            canFixA = hasCountA >= fixCostA and not isMaxA
          end
        end
        local lvTemplateB = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildDataB.itemId, buildDataB.level)
        if lvTemplateB and lvTemplateB.decoGroupUpgradeBaseId and 0 < lvTemplateB.decoGroupUpgradeBaseId then
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
        local hasCountAGlue, needCountAGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataA.itemId, buildDataA.level, true)
        local hasCountBGlue, needCountBGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataB.itemId, buildDataB.level, true)
        local canUpgradeAGlue = needCountAGlue <= hasCountAGlue and not isMaxA
        local canUpgradeBGlue = needCountBGlue <= hasCountBGlue and not isMaxB
        if canUpgradeAGlue ~= canUpgradeBGlue then
          return canUpgradeAGlue and true or false
        end
        local canFixAGlue = false
        local canFixBGlue = false
        if lvTemplateA and lvTemplateA.decoGroupUpgradeBaseId and 0 < lvTemplateA.decoGroupUpgradeBaseId then
          local curProgressA = buildDataA.prodStatus or 0
          local groupIdA = lvTemplateA.decoGroupUpgradeBaseId
          local curProgressInfoA = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupIdA, buildDataA.level, curProgressA)
          if curProgressInfoA then
            local fixCostA = toInt(curProgressInfoA.cost_item) or 0
            canFixAGlue = hasCountAGlue >= fixCostA and not isMaxA
          end
        end
        if lvTemplateB and lvTemplateB.decoGroupUpgradeBaseId and 0 < lvTemplateB.decoGroupUpgradeBaseId then
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
  local isRecommendFunctionOn = DataCenter.DecorationRecommendManager:IsFunctionOn()
  self.recommend_btn:SetActive(isRecommendFunctionOn)
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.segmentN = self:AddComponent(UIBaseContainer, segmentContainer_path)
  self.segmentTbN = {}
  for i = 1, 3 do
    local segment = self:AddComponent(UIBaseContainer, segment_path .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetText(SegmentName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetText(SegmentName[i])
    local red = segment:AddComponent(UIBaseContainer, "RedDot1")
    local recommendTag = segment:AddComponent(UIBaseContainer, "RecommendTag")
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      btnN = btn,
      recommendTag = recommendTag
    }
    table.insert(self.segmentTbN, newSeg)
  end
  self.filter_btn = self:AddComponent(UIButton, filter_btn_path)
  self.filter_btn:SetOnClick(function()
    self:OnFilterBtnClick()
  end)
  self.filter_content = self:AddComponent(DecorationBookIllustratedFilterItem, filter_content_path)
  self.filter_content:SetActive(false)
  self.recommend_btn = self:AddComponent(UIButton, "safeArea/RecommendBtn")
  self.recommend_btn:SetOnClick(function()
    self:OnRecommendBtnClick()
  end)
end

local function OnClickSegment(self, seg)
  if self.curSegment == seg then
    return
  end
  self.curSegment = seg
  for i, v in ipairs(self.segmentTbN) do
    if i == seg then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  self:ShowSegPanel(6 - seg)
end

local function OnInitScroll(self, go, index)
  local item = self.scroll_view:AddComponent(DecorationBookIllustratedDetailItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.baseBuildingIdList[index + 1]
  go.name = conf
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetData({
    baseBuildingIdList = self.baseBuildingIdList,
    index = index + 1
  })
end

local function OnDestroyScrollItem(self, go, index)
end

local function ComponentDestroy(self)
end

local function ClearItemCell(self)
  self.scroll_view:RemoveComponents(DecorationBookIllustratedDetailItem)
  self.content:DestroyChildNode()
end

local function RefreshRed(self)
  for i, v in ipairs(self.segmentTbN) do
    local redCount = self:GetRedCountByType(i)
    if redCount and 0 < redCount then
      v.redN:SetActive(true)
    else
      v.redN:SetActive(false)
    end
  end
end

local function GetRedCountByType(self, seg)
  local redCount = DataCenter.BuildManager:IsDecoratorHasRedDot(6 - seg) and 1 or 0
  return redCount
end

local function OnFilterBtnClick(self)
  self.filter_content:SetActive(true)
end

function LWUIDecorationBookIllustratedDetail:OnDecorateRedPoint()
  self:RefreshCurPanel(false)
end

function LWUIDecorationBookIllustratedDetail:OnRecommendBtnClick()
  local param = {}
  param.alignObject = self.recommend_btn.transform
  param.yPosFix = 30
  param.showArrow = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationRecommendTip, {anim = true}, param)
end

function LWUIDecorationBookIllustratedDetail:RefreshToggleRecommendTag()
  local isOn = DataCenter.DecorationRecommendManager:IsFunctionOn() and DataCenter.DecorationRecommendManager:GetIsOn()
  if not isOn then
    for i, v in ipairs(self.segmentTbN) do
      v.recommendTag:SetActive(false)
    end
    return
  end
  local recommendQuality
  local recommendBuildBaseId = DataCenter.DecorationRecommendManager:GetRecommendBuildBaseId()
  if recommendBuildBaseId then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(recommendBuildBaseId)
    if buildTemplate ~= nil then
      recommendQuality = tonumber(buildTemplate.para3)
    end
  end
  for i, v in ipairs(self.segmentTbN) do
    local isShowRecommendTag = self.filterType ~= DecorationBookFilterType.NotHave and recommendQuality ~= nil and recommendQuality == 6 - i
    v.recommendTag:SetActive(isShowRecommendTag)
  end
end

function LWUIDecorationBookIllustratedDetail:OnSwitchRecommendSuccess()
  self:RefreshCurPanel()
end

LWUIDecorationBookIllustratedDetail.OnCreate = OnCreate
LWUIDecorationBookIllustratedDetail.OnDestroy = OnDestroy
LWUIDecorationBookIllustratedDetail.OnCreate = OnCreate
LWUIDecorationBookIllustratedDetail.ComponentDefine = ComponentDefine
LWUIDecorationBookIllustratedDetail.ComponentDestroy = ComponentDestroy
LWUIDecorationBookIllustratedDetail.OnClickSegment = OnClickSegment
LWUIDecorationBookIllustratedDetail.ShowPanel = ShowPanel
LWUIDecorationBookIllustratedDetail.OnInitScroll = OnInitScroll
LWUIDecorationBookIllustratedDetail.OnUpdateScroll = OnUpdateScroll
LWUIDecorationBookIllustratedDetail.OnDestroyScrollItem = OnDestroyScrollItem
LWUIDecorationBookIllustratedDetail.ShowSegPanel = ShowSegPanel
LWUIDecorationBookIllustratedDetail.ClearItemCell = ClearItemCell
LWUIDecorationBookIllustratedDetail.RefreshCurPanel = RefreshCurPanel
LWUIDecorationBookIllustratedDetail.RefreshRed = RefreshRed
LWUIDecorationBookIllustratedDetail.GetRedCountByType = GetRedCountByType
LWUIDecorationBookIllustratedDetail.ChangeFilterType = ChangeFilterType
LWUIDecorationBookIllustratedDetail.OnFilterBtnClick = OnFilterBtnClick
LWUIDecorationBookIllustratedDetail.OnCloseFilterContent = OnCloseFilterContent
return LWUIDecorationBookIllustratedDetail
