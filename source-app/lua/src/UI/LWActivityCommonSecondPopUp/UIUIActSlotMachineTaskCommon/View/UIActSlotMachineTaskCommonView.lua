local UIActSlotMachineTaskCommonView = BaseClass("UIActSlotMachineTaskCommonView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActSlotTaskItem = require("UI.UIActSlotMachine.UIActSlotMachineTask.Component.UIActSlotTaskItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local colsebg_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "contentView/ScrollView"
local task_content_path = "contentView/ScrollView/Viewport/taskContent"
local u_i_act_slot_task_item_path = "contentView/UIActSlotTaskItem"
local task_item_content_path = "contentView/ScrollView/Viewport/taskContent/taskItemContent"
local progress_bg_path = "contentView/ScrollView/Viewport/taskContent/progressBg"
local progress_img_path = "contentView/ScrollView/Viewport/taskContent/progressBg/progressImg"
local time_txt_path = "contentView/timeTxt"
local confirm_btn_path = "contentView/confirmBtn"

function UIActSlotMachineTaskCommonView:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(self.activityId)
  self:ComponentDefine()
  self:RefreshView()
  self:Update1000MS()
  self:OnOpenJumpPos()
  self:RefreshViewPacking()
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineTaskOpen, {})
end

function UIActSlotMachineTaskCommonView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineTaskCommonView:ComponentDefine()
  self.colsebg = self:AddComponent(UIButton, colsebg_path)
  self.colsebg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.u_i_act_slot_task_item = self:AddComponent(UIBaseContainer, u_i_act_slot_task_item_path)
  self.task_content = self:AddComponent(UIBaseContainer, task_content_path)
  self.task_content:SetAnchoredPositionXY(0, 0)
  self.task_item_content = self:AddComponent(UIBaseContainer, task_item_content_path)
  self.taskItemList = {}
  self.u_i_act_slot_task_item:SetActive(false)
  self.u_i_act_slot_task_item.gameObject:GameObjectCreatePool()
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "UICommonPopUpTitle/CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetTitle("activity_slots_tips003")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIActSlotMachineTaskCommonView:ComponentDestroy()
  self:ClearAllItem()
  base.OnDestroy(self)
end

function UIActSlotMachineTaskCommonView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotTaskDataUpdate, self.OnGetTaskDataChangeMsg)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIActSlotMachineTaskCommonView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotTaskDataUpdate, self.OnGetTaskDataChangeMsg)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIActSlotMachineTaskCommonView:ClearAllItem()
  self.u_i_act_slot_task_item.gameObject:GameObjectRecycleAll()
  self.taskItemList = {}
end

function UIActSlotMachineTaskCommonView:RefreshView()
  self.taskShowData = self.activityDetailData.taskArrData
  local count = #self.taskShowData
  if #self.taskItemList ~= count then
    self:ClearAllItem()
    if 0 < count then
      for i = 1, count do
        local showData = self.taskShowData[i]
        local item = self.u_i_act_slot_task_item.gameObject:GameObjectSpawn(self.task_item_content.transform)
        item.name = i
        local obj = self.task_item_content:AddComponent(UIActSlotTaskItem, item.name)
        obj:SetActive(true)
        self.taskItemList[i] = obj
      end
    end
  end
  local curIndex = -1
  for i = 1, count do
    if self.taskShowData[i].data.state ~= TaskState.Received then
      curIndex = i
      break
    end
  end
  if curIndex < 0 then
    curIndex = count
  end
  for i = 1, count do
    self.taskItemList[i]:SetData(self.activityId, self.taskShowData[i], i, curIndex)
  end
  self.progress_bg:SetAnchoredPositionXY(37.6, -80)
  self.progress_bg:SetSizeDeltaXY(37, 172 * (count - 1))
  self.progress_img:SetSizeDeltaXY(37, 172 * (curIndex - 1))
end

function UIActSlotMachineTaskCommonView:OnGetTaskDataChangeMsg()
  self:RefreshView()
end

function UIActSlotMachineTaskCommonView:OnOpenJumpPos()
  local count = #self.taskShowData
  local itemH = 172
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
  local scrollH = self.scroll_view.rectTransform.rect.height
  local contentH = count * itemH
  local curIndex = -1
  for i = 1, count do
    if self.taskShowData[i].data.state ~= TaskState.Received then
      curIndex = i
      break
    end
  end
  if curIndex < 0 then
    curIndex = count
  end
  local jumpPosY = (curIndex - 1) * itemH
  local maxJump = math.max(0, contentH - scrollH)
  if jumpPosY > maxJump then
    jumpPosY = maxJump
  end
  self.task_content:SetAnchoredPositionXY(0, jumpPosY)
end

function UIActSlotMachineTaskCommonView:Update1000MS()
  if self.time_txt ~= nil then
    local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
    self.time_txt:SetLocalText("104209", UITimeManager:GetInstance():SecondToFmtString(remainTime))
  end
end

function UIActSlotMachineTaskCommonView:OnPassDay()
  if self.activityId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if not actData or not actData:IsValid() then
      self.ctrl:CloseSelf()
      return
    end
  end
end

function UIActSlotMachineTaskCommonView:RefreshViewPacking()
  if self.activityId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.activityId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.activityId)
      return nil
    end
    if not lineData.festival_interface_config or not tonumber(lineData.festival_interface_config) then
      Logger.LogError("Activity GetTemplate lineData.festival_interface_config is nil or not a number id:" .. self.activityId)
      return
    end
    self:ModifyPanelPacking(tonumber(lineData.festival_interface_config))
  end
end

function UIActSlotMachineTaskCommonView:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData)
end

return UIActSlotMachineTaskCommonView
