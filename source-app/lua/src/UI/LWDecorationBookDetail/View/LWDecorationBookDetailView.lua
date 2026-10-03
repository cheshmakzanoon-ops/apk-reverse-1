local DecorationBookDetailItem = require("UI.LWDecorationBookDetail.Component.DecorationBookDetailItem")
local LWDecorationBookDetailView = BaseClass("LWDecorationBookDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local return_btn_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/Common_bg_orange2/Scroll View/Content"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/Scroll View"
local name_path = "PopUpTitle/Common_bg_orange2/Title/Content/name"
local value_path = "PopUpTitle/Common_bg_orange2/Title/Content/value"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.isFirst = true
  self.listGO = {}
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self.isFirst = nil
  self.listGO = nil
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.title_name = self:AddComponent(UIText, name_path)
  self.title_value = self:AddComponent(UIText, value_path)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.content = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnRefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnRefreshView)
end

local function ReInit(self)
  self.data = self:GetUserData()
  self.effectId = self.data.effectId
  self.totalValue = self.data.totalValue
  self.buildingIdList = DataCenter.BuildTemplateManager:GetDecorationListByEffectId(self.effectId)
  if self.effectId == 75949 then
    local list = DataCenter.BuildTemplateManager:GetDecorationListByEffectId(75950)
    for i, v in ipairs(list) do
      table.insert(self.buildingIdList, v)
    end
  end
  table.sort(self.buildingIdList, function(a, b)
    local hasA = DataCenter.BuildManager:HasBuilding(a, true)
    local hasB = DataCenter.BuildManager:HasBuilding(b, true)
    if hasA ~= hasB then
      return hasA and true or false
    end
    if hasA and hasB then
      local haveBuildDataA = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(a, true)
      local haveBuildDataB = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(b, true)
      if haveBuildDataA.state ~= haveBuildDataB.state then
        return haveBuildDataA.state == BuildingStateType.Normal and true or false
      end
      local buildTemplateDataA = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(haveBuildDataA.itemId, haveBuildDataA.level)
      local buildTemplateDataB = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(haveBuildDataB.itemId, haveBuildDataB.level)
      local effectValueA, effectValueB
      if self.effectId == 75949 or self.effectId == 75950 then
        effectValueA = (buildTemplateDataA.building_effect_last[75949] or 0) + (buildTemplateDataA.building_effect_last[75950] or 0)
        effectValueB = (buildTemplateDataB.building_effect_last[75949] or 0) + (buildTemplateDataB.building_effect_last[75950] or 0)
      else
        effectValueA = buildTemplateDataA.building_effect_last[self.effectId] or 0
        effectValueB = buildTemplateDataB.building_effect_last[self.effectId] or 0
      end
      if effectValueA ~= effectValueB then
        return effectValueA > effectValueB
      end
    end
    local buildingA = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(a)
    local buildingB = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(b)
    return buildingA.display_order_gallery < buildingB.display_order_gallery
  end)
  self:OnRefreshView()
end

local function OnRefreshView(self)
  local desc, value = WorkerUtil.GetEffectText(self.effectId, self.totalValue, true)
  self.title_name:SetText(desc)
  self.title_value:SetText(value)
  self:RefreshList()
end

local function DoClosePanel(self)
  local k, v, startPt = self:GetUserData()
  if startPt ~= nil then
    local time = 0.3
    local closeTime = 0.31
    self.root.transform:DOMove(startPt, time)
    self.root.transform:DOScale(Vector3.New(0.1, 0.1, 0.1), time)
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.ctrl:CloseSelf(false)
    end, closeTime)
  else
    self.ctrl:CloseSelf(true)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.scroll_view:AddComponent(DecorationBookDetailItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.buildingIdList[index + 1]
  go.name = conf
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetData({
    baseBuildingId = conf,
    effectId = self.effectId
  })
end

local function OnDestroyScrollItem(self, go, index)
end

local function RefreshList(self)
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.content:SetItemCount(#self.buildingIdList)
  self.content:ForceUpdate()
end

local function ClearItemCell(self)
  self.scroll_view:RemoveComponents(DecorationBookDetailItem)
  self.content:DestroyChildNode()
end

LWDecorationBookDetailView.OnCreate = OnCreate
LWDecorationBookDetailView.OnDestroy = OnDestroy
LWDecorationBookDetailView.OnEnable = OnEnable
LWDecorationBookDetailView.OnDisable = OnDisable
LWDecorationBookDetailView.ComponentDefine = ComponentDefine
LWDecorationBookDetailView.ComponentDestroy = ComponentDestroy
LWDecorationBookDetailView.OnAddListener = OnAddListener
LWDecorationBookDetailView.OnRemoveListener = OnRemoveListener
LWDecorationBookDetailView.ReInit = ReInit
LWDecorationBookDetailView.OnRefreshView = OnRefreshView
LWDecorationBookDetailView.DoClosePanel = DoClosePanel
LWDecorationBookDetailView.OnInitScroll = OnInitScroll
LWDecorationBookDetailView.OnUpdateScroll = OnUpdateScroll
LWDecorationBookDetailView.OnDestroyScrollItem = OnDestroyScrollItem
LWDecorationBookDetailView.RefreshList = RefreshList
LWDecorationBookDetailView.ClearItemCell = ClearItemCell
return LWDecorationBookDetailView
