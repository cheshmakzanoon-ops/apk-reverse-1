local UIBuildQueueView = BaseClass("UIBuildQueueView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local UILWScienceQueueCell = require("UI.UILWScienceQueue.Component.UILWScienceQueueCell")
local panel_path = "Panel"
local title_text_path = "safearea/TopBar/TextTitle"
local close_btn_path = "safearea/BtnClose"
local scrollViewPath = "safearea/ScrollView"
local content_path = "safearea/ScrollView/Viewport/Content"
local safearea_path = "safearea"
local NORMAL_CONTENT_HEIGH = 500
local MULTI_ITEM_CONTENT_HEIGH = 680

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function ClearScroll(self)
  if self.content then
    self.content:RemoveComponents(UILWScienceQueueCell)
  end
  for i, v in ipairs(self.loadRequest) do
    self:GameObjectDestroy(v)
  end
  self.loadRequest = {}
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_rect = self:AddComponent(UIScrollRect, scrollViewPath)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.contentArea = self:AddComponent(UIBaseContainer, safearea_path)
end

local function ComponentDestroy(self)
  self.panel = nil
  self.close_btn = nil
  self.title_text = nil
  self.content = nil
  self.scroll_rect = nil
  self.contentArea = nil
end

local function DataDefine(self)
  self.cells = {}
  self.param = nil
  self.loadRequest = {}
end

local function DataDestroy(self)
  self.cells = nil
  self.param = nil
  self.loadRequest = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.RefreshCurrentQueues)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.RefreshCurrentQueues)
  self:AddUIListener(EventId.AddSpeedSuccess, self.RefreshCurrentQueues)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.RefreshCurrentQueues)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.RefreshCurrentQueues)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.RefreshCurrentQueues)
  base.OnRemoveListener(self)
end

local function RefreshCurrentQueues(self)
  for index, v in pairs(self.cells) do
    if v ~= nil and v.param.uuid ~= nil then
      local param = UILWScienceQueueCell.Param.New()
      param.uuid = self.queueDataList[index].uuid
      param.index = index
      v:ReInit(param)
      v:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
    end
  end
end

local function Refresh(self)
  self:ShowCells()
end

local function ShowCells(self)
  ClearScroll(self)
  self.cells = {}
  self.queueDataList = self.ctrl:GetQueueDataList()
  local count = #self.queueDataList
  if 0 < count then
    for i = 1, count do
      self:AddOneCells(i)
    end
  end
  self:CalContentHeightByItemCount(count)
end

local function CalContentHeightByItemCount(self, cellCount)
  local targetHeight = NORMAL_CONTENT_HEIGH
  if cellCount and 2 < cellCount then
    targetHeight = MULTI_ITEM_CONTENT_HEIGH
  end
  if self.contentArea.rectTransform then
    local width, height = self.contentArea.rectTransform:Get_sizeDelta()
    self.contentArea.rectTransform:Set_sizeDelta(width, targetHeight)
  end
end

local function AddOneCells(self, index)
  self.loadRequest[index] = self:GameObjectInstantiateAsync(UIAssets.UILWScienceQueuePanelCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    NameCount = NameCount + 1
    go.name = nameStr
    self.cells[index] = self.content:AddComponent(UILWScienceQueueCell, nameStr)
    local param = UILWScienceQueueCell.Param.New()
    param.uuid = self.queueDataList[index].uuid
    param.index = index
    if self.queueDataList[index].isBuy then
      param = self.queueDataList[index]
    end
    self.cells[index]:ReInit(param)
  end)
end

local function Update(self)
  if not self.cells then
    return
  end
  for k, v in pairs(self.cells) do
    if v ~= nil and v.param.uuid ~= nil then
      v:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
    end
  end
end

local function ReInit(self)
  self:Refresh()
end

UIBuildQueueView.OnCreate = OnCreate
UIBuildQueueView.OnDestroy = OnDestroy
UIBuildQueueView.OnEnable = OnEnable
UIBuildQueueView.OnDisable = OnDisable
UIBuildQueueView.ComponentDefine = ComponentDefine
UIBuildQueueView.ComponentDestroy = ComponentDestroy
UIBuildQueueView.DataDefine = DataDefine
UIBuildQueueView.DataDestroy = DataDestroy
UIBuildQueueView.OnAddListener = OnAddListener
UIBuildQueueView.OnRemoveListener = OnRemoveListener
UIBuildQueueView.ReInit = ReInit
UIBuildQueueView.ShowCells = ShowCells
UIBuildQueueView.AddOneCells = AddOneCells
UIBuildQueueView.Update = Update
UIBuildQueueView.Refresh = Refresh
UIBuildQueueView.RefreshCurrentQueues = RefreshCurrentQueues
UIBuildQueueView.CalContentHeightByItemCount = CalContentHeightByItemCount
return UIBuildQueueView
