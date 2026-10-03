local ActSlotMachineTaskContent = BaseClass("ActSlotMachineTaskContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local special_task_content_path = ""
local tip_path = "bg/normalType/tip"
local task_progressbg_path = "bg/normalType/taskProgressbg"
local task_progress_img_path = "bg/normalType/taskProgressbg/taskProgressImg"
local task_progress_num_path = "bg/normalType/taskProgressbg/taskProgressNum"
local icon_path = "bg/normalType/icon"
local u_i_common_res_item_path = "bg/normalType/UICommonResItem"
local normal_type_task_can_get_path = "bg/normalType/normalTypeTaskCanGet"
local eff_ui_data_glowmask_path = "bg/normalType/taskProgressbg/taskProgressImg/Eff_ui_data_glowmask"
local eff_ui_special_task_content_full_glow_path = "bg/normalType/taskProgressbg/Eff_ui_SpecialTaskContentFullGlow"
local eff_ui_duobao_jiangli_faguang_path = "bg/normalType/Eff_ui_duobao_jiangli_faguang"
local normal_type_path = "bg/normalType"
local special_type1_path = "bg/specialType1"
local tip1_1_path = "bg/specialType1/tip1_1"
local tip1_2_path = "bg/specialType1/tip1_2"
local special_type2_path = "bg/specialType2"
local tip2_1_path = "bg/specialType2/tip2_1"
local task_progressbg_s1_path = "bg/specialType1/taskProgressbgS1"
local task_progress_img_s1_path = "bg/specialType1/taskProgressbgS1/taskProgressImgS1"
local task_progress_num_s1_path = "bg/specialType1/taskProgressbgS1/taskProgressNumS1"
local task_progressbg_s2_path = "bg/specialType2/taskProgressbgS2"
local task_progress_img_s2_path = "bg/specialType2/taskProgressbgS2/taskProgressImgS2"
local task_progress_num_s2_path = "bg/specialType2/taskProgressbgS2/taskProgressNumS2"
local icon1_path = "bg/specialType1/icon1"
local icon2_path = "bg/specialType2/icon2"
local bg_path = "bg"
local haveSendPassDayMsg = false
local recordTaskProgressNum = 0
local nextCanSendTime = 0
local nextCanSendTimeInterval = 5000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.special_task_content = self:AddComponent(UIButton, special_task_content_path)
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.task_progressbg = self:AddComponent(UIImage, task_progressbg_path)
  self.task_progress_img = self:AddComponent(UIImage, task_progress_img_path)
  self.task_progress_num = self:AddComponent(UITextMeshProUGUIEx, task_progress_num_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.normal_type_task_can_get = self:AddComponent(UIImage, normal_type_task_can_get_path)
  self.special_task_content:SetOnClick(function()
    self:OnTaskBtnClick()
  end)
  self.normal_type = self:AddComponent(UIBaseContainer, normal_type_path)
  self.special_type1 = self:AddComponent(UIBaseContainer, special_type1_path)
  self.tip1_1 = self:AddComponent(UITextMeshProUGUIEx, tip1_1_path)
  self.tip1_2 = self:AddComponent(UITextMeshProUGUIEx, tip1_2_path)
  self.special_type2 = self:AddComponent(UIBaseContainer, special_type2_path)
  self.tip2_1 = self:AddComponent(UITextMeshProUGUIEx, tip2_1_path)
  self.eff_ui_data_glowmask = self:AddComponent(UIImage, eff_ui_data_glowmask_path)
  self.eff_ui_special_task_content_full_glow = self:AddComponent(UIBaseContainer, eff_ui_special_task_content_full_glow_path)
  self.eff_ui_duobao_jiangli_faguang = self:AddComponent(UIBaseContainer, eff_ui_duobao_jiangli_faguang_path)
  self.eff_ui_data_glowmask:SetActive(false)
  self.bg = self:AddComponent(UIAnimator, bg_path)
  self.task_progressbg_s1 = self:AddComponent(UIImage, task_progressbg_s1_path)
  self.task_progress_img_s1 = self:AddComponent(UIImage, task_progress_img_s1_path)
  self.task_progress_num_s1 = self:AddComponent(UITextMeshProUGUIEx, task_progress_num_s1_path)
  self.task_progressbg_s2 = self:AddComponent(UIImage, task_progressbg_s2_path)
  self.task_progress_img_s2 = self:AddComponent(UIImage, task_progress_img_s2_path)
  self.task_progress_num_s2 = self:AddComponent(UITextMeshProUGUIEx, task_progress_num_s2_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.showData = nil
  self.targetTaskData = nil
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotTaskDataUpdate, self.OnGetTaskDataChangeMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotTaskDataUpdate, self.OnGetTaskDataChangeMsg)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  nextCanSendTime = 0
  self.eff_ui_data_glowmask:SetActive(false)
  self:RefreshView()
end

local function RefreshView(self)
  nextCanSendTime = 0
  self:RefreshTaskView()
end

local function RefreshTaskView(self)
  self.showData = self.activityDetailData.taskArrData
  self.targetTaskData = nil
  for i, v in ipairs(self.showData) do
    if v.data.state ~= TaskState.Received then
      self.targetTaskData = v
      break
    end
  end
  if self.targetTaskData == nil then
    self.targetTaskData = self.showData[#self.showData]
  end
  if self.targetTaskData.data.state ~= TaskState.Received then
    self.normal_type:SetActive(true)
    self.special_type1:SetActive(false)
    self.special_type2:SetActive(false)
    local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
    local targetNum = self.targetTaskData.temp:GetTargetNum()
    self.tip:SetLocalText(self.targetTaskData.temp.name)
    local process = curNum .. "/" .. targetNum
    local progressRate = 0
    if 0 < targetNum then
      progressRate = curNum / targetNum
      progressRate = math.min(progressRate, 1)
    end
    self.task_progress_num:SetText(process)
    local bgSizeDelta = self.task_progressbg:GetSizeDelta()
    self.task_progress_img:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
    local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
    self.icon:LoadSprite(imgPath)
    local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.targetTaskData.data.reward)
    if showList and 0 < #showList then
      self.u_i_common_res_item:ReInit(showList[1])
    end
    local canGet = self.targetTaskData.data.state == TaskState.CanReceive
    self.eff_ui_duobao_jiangli_faguang:SetActive(canGet)
    self.eff_ui_special_task_content_full_glow:SetActive(canGet)
    self.normal_type_task_can_get:SetActive(canGet)
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local actEndTime = self.activityInfo.endTime
    local isLastTime = false
    if curTime >= actEndTime - 86400000 then
      isLastTime = true
    end
    if not isLastTime then
      self.normal_type:SetActive(false)
      self.special_type1:SetActive(true)
      self.special_type2:SetActive(false)
      local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
      local targetNum = self.targetTaskData.temp:GetTargetNum()
      local process = curNum
      local progressRate = 1
      self.task_progress_num_s1:SetText(process .. "/" .. targetNum)
      local bgSizeDelta = self.task_progressbg_s1:GetSizeDelta()
      self.task_progress_img_s1:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
      local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
      self.icon1:LoadSprite(imgPath)
    else
      self.normal_type:SetActive(false)
      self.special_type1:SetActive(false)
      self.special_type2:SetActive(true)
      local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
      local targetNum = self.targetTaskData.temp:GetTargetNum()
      local process = curNum
      local progressRate = 1
      self.task_progress_num_s2:SetText(process)
      local bgSizeDelta = self.task_progressbg_s2:GetSizeDelta()
      self.task_progress_img_s2:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
      local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
      self.icon2:LoadSprite(imgPath)
    end
  end
  self:Update1000MS()
end

local function OnTaskBtnClick(self)
  if self.mainView == nil then
    return
  end
  if self.targetTaskData and self.targetTaskData.data and self.targetTaskData.data.state == TaskState.CanReceive then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= nextCanSendTime then
      nextCanSendTime = curTime + nextCanSendTimeInterval
      SFSNetwork.SendMessage(MsgDefines.SlotsTaskReward, tonumber(self.activityId), tostring(self.targetTaskData.data.taskId))
    end
    return
  end
  self.mainView:OpenTaskView()
end

local function Update1000MS(self)
  if self.targetTaskData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = UITimeManager:GetInstance():GetResSecondsTo24() * 1000
  local isShowTime = false
  local txtTime = 35000
  local timeShow = 5000
  if timeShow > remainTime % txtTime then
    isShowTime = true
  end
  local showText = ""
  if isShowTime then
    showText = UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000)
  else
    local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
    local targetNum = self.targetTaskData.temp:GetTargetNum()
    local process = curNum .. "/" .. targetNum
    showText = process
  end
  self.task_progress_num:SetText(showText)
  self.tip1_2:SetLocalText("activity_sports_uitips_028", UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
end

local function RecordCurTaskProgress(self)
  recordTaskProgressNum = 0
  if self.targetTaskData == nil then
    return
  end
  recordTaskProgressNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
end

local function GetCurTaskProgressAddNum(self)
  if self.showData == nil then
    return 0
  end
  self.targetTaskData = nil
  for i, v in ipairs(self.showData) do
    if v.data.state ~= TaskState.Received then
      self.targetTaskData = v
      break
    end
  end
  if self.targetTaskData == nil then
    self.targetTaskData = self.showData[#self.showData]
  end
  local addNum = 0
  if self.targetActData == nil then
    return addNum
  end
  local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
  addNum = curNum - recordTaskProgressNum
  if addNum < 0 then
    addNum = 0
  end
  return addNum
end

local function TryPlayTaskEffect(self)
  local addNum = self:GetCurTaskProgressAddNum()
  if 0 < addNum then
    local oldNum = recordTaskProgressNum
    local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
    local targetNum = self.targetTaskData.temp:GetTargetNum()
    if oldNum < targetNum and curNum < targetNum then
      self.eff_ui_data_glowmask:SetActive(false)
      self.eff_ui_data_glowmask:SetActive(true)
    elseif oldNum < targetNum and curNum >= targetNum then
      self.bg:Play("Eff_specialtaskcontent")
    end
  end
end

local function OnGetTaskDataChangeMsg(self)
  self:RefreshTaskView()
end

ActSlotMachineTaskContent.OnCreate = OnCreate
ActSlotMachineTaskContent.OnDestroy = OnDestroy
ActSlotMachineTaskContent.ComponentDefine = ComponentDefine
ActSlotMachineTaskContent.ComponentDestroy = ComponentDestroy
ActSlotMachineTaskContent.DataDefine = DataDefine
ActSlotMachineTaskContent.DataDestroy = DataDestroy
ActSlotMachineTaskContent.SetData = SetData
ActSlotMachineTaskContent.RefreshView = RefreshView
ActSlotMachineTaskContent.RefreshTaskView = RefreshTaskView
ActSlotMachineTaskContent.OnTaskBtnClick = OnTaskBtnClick
ActSlotMachineTaskContent.Update1000MS = Update1000MS
ActSlotMachineTaskContent.RecordCurTaskProgress = RecordCurTaskProgress
ActSlotMachineTaskContent.GetCurTaskProgressAddNum = GetCurTaskProgressAddNum
ActSlotMachineTaskContent.TryPlayTaskEffect = TryPlayTaskEffect
ActSlotMachineTaskContent.OnRemoveListener = OnRemoveListener
ActSlotMachineTaskContent.OnAddListener = OnAddListener
ActSlotMachineTaskContent.OnGetTaskDataChangeMsg = OnGetTaskDataChangeMsg
return ActSlotMachineTaskContent
