local UIBuildQueueView = BaseClass("UIBuildQueueView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  enterType,
  uuid,
  point,
  messageParam,
  buildId
}
local UIBuildQueueCell = require("UI.UIBuildQueue.Component.UIBuildQueueCell")
local UIBuildQueueUnlockCell = require("UI.UIBuildQueue.Component.UIBuildQueueUnlockCell")
local panel_path = "Panel"
local title_text_path = "safearea/TopBar/TextTitle"
local close_btn_path = "safearea/BtnClose"
local contract_text_path = "safearea/UnlimitedMode/contract/contract_text"
local hint_text_path = "safearea/UnlimitedMode/contract/hint_text"
local hint_text2_path = "safearea/UnlimitedMode/contract/hint_text2"
local unlimitedMode_path = "safearea/UnlimitedMode"
local normalMode_path = "safearea/NormalMode"
local scrollViewPath = "safearea/ScrollView"
local content_path = "safearea/ScrollView/Viewport/Content"
local build_queue_buy_unlock_cell_path = "safearea/ScrollView/Viewport/Content/LWUIBuildQueuePanelUnlockCell"
local btnRecommendBuildList_path = "safearea/btnRecommendBuildList"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self.content:RemoveComponents(UIBuildQueueCell)
  for i, v in ipairs(self.loadingRequest) do
    self:GameObjectDestroy(v)
  end
  self.loadingRequest = nil
  for i, v in ipairs(self.loadedRequest) do
    self:GameObjectDestroy(v)
  end
  self.loadedRequest = nil
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.contract_text = self:AddComponent(UIText, contract_text_path)
  self.contract_timer = nil
  self.hint_text = self:AddComponent(UIText, hint_text_path)
  self.hint_text2 = self:AddComponent(UIText, hint_text2_path)
  self.hint_text:SetLocalText(135204)
  self.hint_text2:SetLocalText(135210)
  self.scroll_rect = self:AddComponent(UIScrollRect, scrollViewPath)
  self.unlimitedMode = self:AddComponent(UIBaseContainer, unlimitedMode_path)
  self.normalMode = self:AddComponent(UIBaseContainer, normalMode_path)
  self.btnRecommendBuildList = self:AddComponent(UIButton, btnRecommendBuildList_path)
  self.btnRecommendBuildList:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.RecommendBtnClick2)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRecommendBuildList)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text:SetLocalText(GameDialogDefine.BUILD_QUEUE_TITLE)
end

local function ComponentDestroy(self)
  if self.contract_timer then
    self.contract_timer:Stop()
    self.contract_timer = nil
  end
  self.panel = nil
  self.close_btn = nil
  self.title_text = nil
  self.content = nil
  self.build_queue_buy_unlock_cell = nil
  self.scroll_rect = nil
  self.unlimitedMode = nil
  self.normalMode = nil
end

local function DataDefine(self)
  self.cells = {}
  self.freeCells = {}
  self.hasLoadCount = 0
  self.allNeedCount = 0
  self.param = nil
  self.isInUnlimitedMode = nil
  self.loadingRequest = {}
  self.loadedRequest = {}
end

local function DataDestroy(self)
  self.cells = nil
  self.freeCells = nil
  self.hasLoadCount = nil
  self.allNeedCount = nil
  self.param = nil
  self.isInUnlimitedMode = nil
  self.loadingRequest = nil
  self.loadedRequest = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIBuildQueue, self.RefreshUIBuildQueueSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIBuildQueue, self.RefreshUIBuildQueueSignal)
end

local function Refresh(self)
  local isInUnlimitedMode = DataCenter.BuildQueueManager:IsViewInUnlimitedMode()
  if isInUnlimitedMode then
    self.unlimitedMode:SetActive(true)
    self.normalMode:SetActive(false)
    self.isInUnlimitedMode = true
    self.param = self:GetUserData()
    self.contract_text:SetLocalText(135212)
    if DataCenter.BuildQueueManager:CheckHasContract() then
      if self.contract_timer then
        self.contract_timer:Stop()
      end
      self.contract_timer = nil
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.contract_text:SetLocalText(135213, UITimeManager:GetInstance():SecondToFmtString((DataCenter.BuildQueueManager:GetContractEndTime() - curTime) / 1000))
      self.contract_timer = TimerManager:GetInstance():GetTimer(1, function()
        if not DataCenter.BuildQueueManager:CheckHasContract() then
          self.contract_timer:Stop()
          self.contract_timer = nil
          EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
          return
        end
        local curTime = UITimeManager:GetInstance():GetServerTime()
        self.contract_text:SetLocalText(135213, UITimeManager:GetInstance():SecondToFmtString((DataCenter.BuildQueueManager:GetContractEndTime() - curTime) / 1000))
      end)
      self.contract_timer:Start()
    end
    self.scroll_rect:SetAnchoredPositionXY(0, -100)
    self.scroll_rect:SetSizeDelta(Vector2.New(702, 692))
  else
    self.unlimitedMode:SetActive(false)
    self.normalMode:SetActive(true)
    self.isInUnlimitedMode = false
    if self.contract_timer then
      self.contract_timer:Stop()
    end
    self.contract_timer = nil
    self.scroll_rect:SetAnchoredPositionXY(0, -95)
    self.scroll_rect:SetSizeDelta(Vector2.New(702, 703))
  end
  self:ShowCells()
end

local function FilterQueueData(self)
  local dataList = {}
  if self.isInUnlimitedMode then
    local allQueue = DataCenter.BuildQueueManager:GetAllQueue()
    for i, v in pairs(allQueue) do
      if v and v:IsOwned() then
        if v:IsSpecialQueue() and v:IsConstructing() and not v:IsFinish() then
          table.insert(dataList, v)
        elseif not v:IsSpecialQueue() then
          table.insert(dataList, v)
        end
      end
    end
    table.sort(dataList, function(a, b)
      if a.type ~= b.type then
        return a.type < b.type
      end
      if a.id ~= b.id then
        return a.id < b.id
      end
      return a.uuid < b.uuid
    end)
  else
    local allQueue = DataCenter.BuildQueueManager:GetAllQueue()
    for i, v in pairs(allQueue) do
      if v and not v:IsSpecialQueue() then
        table.insert(dataList, v)
      end
    end
    table.sort(dataList, function(a, b)
      if a.type ~= b.type then
        return a.type < b.type
      end
      if a.order ~= b.order then
        return a.order < b.order
      end
      return a.uuid < b.uuid
    end)
  end
  return dataList
end

local function ShowCells(self)
  for k, v in pairs(self.cells) do
    v:SetActive(false)
    table.insert(self.freeCells, v)
  end
  for k, request in pairs(self.loadingRequest) do
    self:GameObjectDestroy(request)
  end
  self.loadingRequest = {}
  self.cells = {}
  self.hasLoadCount = 0
  self.queueDataList = FilterQueueData(self)
  self.allNeedCount = #self.queueDataList
  self.scroll_rect.unity_uiscrollRect.enabled = self.allNeedCount > 2
  if 0 < self.allNeedCount then
    for i = 1, self.allNeedCount do
      self:AddOneCells(i)
    end
  end
end

local function AddOneCells(self, index)
  if #self.freeCells > 0 then
    local num = #self.freeCells
    for k, item in pairs(self.freeCells) do
      if item.param.uuid == self.queueDataList[index].uuid then
        num = k
        break
      end
    end
    local temp = table.remove(self.freeCells, num)
    if temp ~= nil then
      local param = UIBuildQueueCell.Param.New()
      param.uuid = self.queueDataList[index].uuid
      param.index = index
      param.enterParam = self.param
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.content.transform)
      temp.transform:SetAsLastSibling()
      self.cells[index] = temp
      self.hasLoadCount = self.hasLoadCount + 1
    end
  else
    self.loadingRequest[index] = self:GameObjectInstantiateAsync(UIAssets.UIBuildQueuePanelCell, function(request)
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
      self.cells[index] = self.content:AddComponent(UIBuildQueueCell, nameStr)
      local param = UIBuildQueueCell.Param.New()
      param.uuid = self.queueDataList[index].uuid
      param.index = index
      param.enterParam = self.param
      self.cells[index]:ReInit(param)
      self.hasLoadCount = self.hasLoadCount + 1
      self.loadingRequest[index] = nil
      self.loadedRequest[index] = request
    end)
  end
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

local function RefreshUIBuildQueueSignal(self)
  self:ReInit()
end

local function ReInit(self)
  self:Refresh()
  self:UpDateBuildListBtnState()
end

function UIBuildQueueView:UpDateBuildListBtnState()
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
UIBuildQueueView.RefreshUIBuildQueueSignal = RefreshUIBuildQueueSignal
UIBuildQueueView.FilterQueueData = FilterQueueData
UIBuildQueueView.Refresh = Refresh
return UIBuildQueueView
