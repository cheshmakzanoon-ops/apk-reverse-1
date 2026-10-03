local UIPveActMain = BaseClass("UIPveActMain", UIBaseView)
local base = UIBaseView
local UIPveActTaskItem = require("UI.UIPveAct.UIPveActMain.Component.UIPveActTaskItem")
local UIPveActStageItem = require("UI.UIPveAct.UIPveActMain.Component.UIPveActStageItem")
local UIPveActStageTip = require("UI.UIPveAct.UIPveActMain.Component.UIPveActStageTip")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local close_path = "UICommonPopUpTitle/CloseBtn"
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local scroll_view_path = "ScrollView"
local big_icon_path = "Left/BigIcon"
local time_desc_path = "Left/TimeDesc"
local time_path = "Left/TimeBg/Time"
local slider_path = "Bottom/Slider"
local slider_icon_path = "Bottom/Slider/SliderIcon"
local stage_list_path = "Bottom/Slider/StageList"
local stage_tip_path = "UIPveActStageTip"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panel_btn = self:AddComponent(UIButton, panel_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.big_icon_image = self:AddComponent(UIImage, big_icon_path)
  self.time_desc_text = self:AddComponent(UIText, time_desc_path)
  self.time_desc_text:SetLocalText(100238)
  self.time_text = self:AddComponent(UIText, time_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_icon_image = self:AddComponent(UIImage, slider_icon_path)
  self.stage_list_go = self:AddComponent(UIBaseContainer, stage_list_path)
  self.stage_tip = self:AddComponent(UIPveActStageTip, stage_tip_path)
end

local function ComponentDestroy(self)
  self.panel_btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.scroll_view = nil
  self.big_icon_image = nil
  self.time_desc_text = nil
  self.time_text = nil
  self.slider = nil
  self.slider_icon_image = nil
  self.stage_list_go = nil
  self.stage_tip = nil
end

local function DataDefine(self)
  self.actId = 0
  self.pve = 0
  self.data = nil
  self.actData = nil
  self.taskDataList = {}
  self.inited = false
  self.taskItems = {}
  self.stageItems = {}
  self.timer = nil
  self.sliderTween = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.pve = nil
  self.data = nil
  self.actData = nil
  self.taskDataList = nil
  self.inited = nil
  self.taskItems = nil
  self.stageItems = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.sliderTween then
    self.sliderTween:Kill()
    self.sliderTween = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PveActGetInfo, self.OnGetInfo)
  self:AddUIListener(EventId.PveActTaskReward, self.OnTaskReward)
  self:AddUIListener(EventId.PveActStageReward, self.OnStageReward)
  self:AddUIListener(EventId.PveActTaskUpdate, self.OnTaskUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PveActGetInfo, self.OnGetInfo)
  self:RemoveUIListener(EventId.PveActTaskReward, self.OnTaskReward)
  self:RemoveUIListener(EventId.PveActStageReward, self.OnStageReward)
  self:RemoveUIListener(EventId.PveActTaskUpdate, self.OnTaskUpdate)
  base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
  local taskData = self.taskDataList[index]
  itemObj.name = tostring(taskData.id)
  local item = self.scroll_view:AddComponent(UIPveActTaskItem, itemObj)
  item.view = self
  item:SetData(taskData)
  self.taskItems[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIPveActTaskItem)
  self.taskItems[index] = nil
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.taskDataList)
  if #self.taskDataList > 0 then
    self.scroll_view:SetActive(true)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
end

local function TimerAction(self)
  local _, restTimeStr = DataCenter.PveActManager:GetRestTime(self.actId)
  self.time_text:SetText(restTimeStr)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.time_text.rectTransform)
end

local function ReInit(self)
  self.actId, self.pve = self:GetUserData()
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.actId))
  self.title_text:SetLocalText(self.actData.name)
  local expIcon, bigIcon = DataCenter.PveActManager:GetIcon(self.actId)
  self.big_icon_image:LoadSprite(bigIcon)
  self.slider_icon_image:LoadSprite(expIcon)
  if self.timer then
    self.timer:Stop()
  end
  self:TimerAction()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
  self.stage_tip:SetActive(false)
  self:Refresh()
end

local function Refresh(self)
  self.data = DataCenter.PveActManager:GetData(self.actId)
  self.taskDataList = self:GetTaskDataListInternal()
  self:ShowScroll()
  if not self.inited then
    self:ShowStageItems(function()
      self:RefreshSlider(true)
    end)
    self.inited = true
  else
    self:RefreshSlider(false)
  end
end

local function RefreshSlider(self, isInit)
  if #self.data.stages == 0 then
    return
  end
  local each = 1 / #self.data.stages
  local val = 0
  for _, stageData in ipairs(self.data.stages) do
    local lastStageData = self.data.stages[stageData.stage - 1]
    if self.data.exp >= stageData.exp then
      val = val + each
    else
      if lastStageData then
        val = val + (self.data.exp - lastStageData.exp) / (stageData.exp - lastStageData.exp) * each
        break
      end
      val = val + self.data.exp / stageData.exp * each
      break
    end
  end
  if isInit then
    self.slider:SetValue(val)
  else
    if self.sliderTween then
      self.sliderTween:Kill()
    end
    self.sliderTween = self.slider:DOValue(val, 1.5, function()
      self.sliderTween = nil
    end)
  end
  for _, stageData in ipairs(self.data.stages) do
    local lastStageData = self.data.stages[stageData.stage - 1]
    local item = self.stageItems[stageData.stage]
    local param = {}
    param.isInit = isInit
    param.curExp = self.data.exp
    param.lastExp = lastStageData and lastStageData.exp or 0
    param.isLast = stageData.stage == #self.data.stages
    item:SetData(stageData, param)
    if self.data.exp < stageData.exp and (lastStageData == nil or self.data.exp >= lastStageData.exp) then
      item:ShowCurExp(true)
    else
      item:ShowCurExp(false)
    end
  end
end

local function ShowStageItems(self, callback)
  if #self.data.stages == 0 then
    return
  end
  local space = self.stage_list_go.rectTransform.rect.width // #self.data.stages
  local count = 0
  for _, stageData in ipairs(self.data.stages) do
    self:GameObjectInstantiateAsync(UIAssets.UIPveActStageItem, function(req)
      if req.isError or self.stage_list_go == nil then
        return
      end
      local go = req.gameObject
      go:SetActive(true)
      go.name = tostring(stageData.stage)
      go.transform:SetParent(self.stage_list_go.transform)
      local item = self.stage_list_go:AddComponent(UIPveActStageItem, go.name)
      item.view = self
      self.stageItems[stageData.stage] = item
      local rtf = item.rectTransform
      rtf:Set_anchoredPosition(stageData.stage * space, 0)
      count = count + 1
      if count == #self.data.stages and callback then
        callback()
      end
    end)
  end
end

local function GetMaxExp(self)
  if #self.data.stages == 0 then
    return 0
  end
  return self.data.stages[#self.data.stages].exp or 1
end

local function GetTaskDataListInternal(self)
  local function GetStateOrder(state)
    if state == TaskState.CanReceive then
      return 1
    elseif state == TaskState.NoComplete then
      return 2
    else
      return 3
    end
  end
  
  local list = {}
  for _, task in ipairs(self.data.tasks) do
    if task.exp > 0 then
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(task.id)
      if template then
        table.insert(list, task)
      end
    end
  end
  table.sort(list, function(a, b)
    if a.state ~= b.state then
      return GetStateOrder(a.state) < GetStateOrder(b.state)
    else
      local templateA = DataCenter.QuestTemplateManager:GetQuestTemplate(a.id)
      local templateB = DataCenter.QuestTemplateManager:GetQuestTemplate(b.id)
      if templateA.order ~= templateB.order then
        return templateA.order < templateB.order
      else
        return a.id < b.id
      end
    end
  end)
  return list
end

local function OnTaskItemClick(self, item)
  if item.data.state == 0 then
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(item.data.id)
    local pve = tonumber(template.para3)
    if self.pve == pve then
      GoToUtil.GoToByQuestId(template)
      self.ctrl:CloseSelf()
    else
      local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pve)
      if pveTemplate then
        UIUtil.ShowTips(Localization:GetString("302306", Localization:GetString(tostring(pveTemplate.name))))
      end
    end
  elseif item.data.state == 1 then
    DataCenter.PveActManager:SendTaskReward(self.actId, self.pve, item.data.id)
  end
end

local function OnStageItemClick(self, item)
  if item.data.state == 0 and self.data.exp >= item.data.exp then
    DataCenter.PveActManager:SendStageReward(self.actId, self.pve, item.data.stage)
  else
    local rewards = DataCenter.RewardManager:ReturnRewardParamForView(item.data.reward)
    self.stage_tip:SetData(rewards)
    self.stage_tip:SetPosX(item.transform.position.x)
    self.stage_tip:Show()
  end
end

local function OnGetInfo(self, actId)
  if self.actId ~= actId then
    return
  end
  self:Refresh()
end

local function OnTaskReward(self, param)
  if self.actId ~= param.actId then
    return
  end
  self.data = DataCenter.PveActManager:GetData(self.actId)
  self.taskDataList = self:GetTaskDataListInternal()
  local srcPos
  for _, item in pairs(self.taskItems) do
    if item.data.id == param.taskId then
      srcPos = item.reward_icon_image.transform.position
      break
    end
  end
  if srcPos ~= nil then
    local icon = DataCenter.PveActManager:GetIcon(self.actId)
    local destPos = self.slider_icon_image.transform.position
    UIUtil.DoFlyCustom(icon, nil, 5, srcPos, destPos, nil, nil, function()
      self:RefreshSlider(false)
    end)
  else
    self:RefreshSlider(false)
  end
  self:ShowScroll()
end

local function OnStageReward(self, param)
  if self.actId ~= param.actId then
    return
  end
  self.data = DataCenter.PveActManager:GetData(self.actId)
  self:RefreshSlider()
end

local function OnTaskUpdate(self, actId)
  if self.actId ~= actId then
    return
  end
  self.data = DataCenter.PveActManager:GetData(self.actId)
  self.taskDataList = self:GetTaskDataListInternal()
  self:ShowScroll()
end

UIPveActMain.OnCreate = OnCreate
UIPveActMain.OnDestroy = OnDestroy
UIPveActMain.OnEnable = OnEnable
UIPveActMain.OnDisable = OnDisable
UIPveActMain.ComponentDefine = ComponentDefine
UIPveActMain.ComponentDestroy = ComponentDestroy
UIPveActMain.DataDefine = DataDefine
UIPveActMain.DataDestroy = DataDestroy
UIPveActMain.OnAddListener = OnAddListener
UIPveActMain.OnRemoveListener = OnRemoveListener
UIPveActMain.OnCreateCell = OnCreateCell
UIPveActMain.OnDeleteCell = OnDeleteCell
UIPveActMain.ShowScroll = ShowScroll
UIPveActMain.TimerAction = TimerAction
UIPveActMain.ReInit = ReInit
UIPveActMain.Refresh = Refresh
UIPveActMain.RefreshSlider = RefreshSlider
UIPveActMain.ShowStageItems = ShowStageItems
UIPveActMain.GetMaxExp = GetMaxExp
UIPveActMain.GetTaskDataListInternal = GetTaskDataListInternal
UIPveActMain.OnInfoClick = OnInfoClick
UIPveActMain.OnTaskItemClick = OnTaskItemClick
UIPveActMain.OnStageItemClick = OnStageItemClick
UIPveActMain.OnGetInfo = OnGetInfo
UIPveActMain.OnTaskReward = OnTaskReward
UIPveActMain.OnStageReward = OnStageReward
UIPveActMain.OnTaskUpdate = OnTaskUpdate
return UIPveActMain
