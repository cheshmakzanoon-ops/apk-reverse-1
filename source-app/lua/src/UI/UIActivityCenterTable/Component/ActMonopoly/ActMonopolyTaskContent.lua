local ActMonopolyTaskContent = BaseClass("ActMonopolyTaskContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local special_task_content_path = "ActivityTopGo/SpecialTaskContent"
local tip_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/tip"
local task_progressbg_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/taskProgressbg"
local task_progress_img_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/taskProgressbg/taskProgressImg"
local task_progress_num_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/taskProgressbg/taskProgressNum"
local icon_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/icon"
local u_i_common_res_item_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/UICommonResItem"
local btn_task_path = "ActivityTopGo/BtnTask"
local task_btn_red_point_path = "ActivityTopGo/BtnTask/taskBtnRedPoint"
local eff_ui_data_glowmask_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/taskProgressbg/taskProgressImg/Eff_ui_data_glowmask"
local eff_ui_special_task_content_full_glow_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/taskProgressbg/Eff_ui_SpecialTaskContentFullGlow"
local eff_ui_duobao_jiangli_faguang_path = "ActivityTopGo/SpecialTaskContent/bg/normalType/Eff_ui_duobao_jiangli_faguang"
local normal_type_path = "ActivityTopGo/SpecialTaskContent/bg/normalType"
local special_type1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1"
local tip1_1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/tip1_1"
local tip1_2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/tip1_2"
local special_type2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2"
local tip2_1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2/tip2_1"
local task_progressbg_s1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/taskProgressbgS1"
local task_progress_img_s1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/taskProgressbgS1/taskProgressImgS1"
local task_progress_num_s1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/taskProgressbgS1/taskProgressNumS1"
local task_progressbg_s2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2/taskProgressbgS2"
local task_progress_img_s2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2/taskProgressbgS2/taskProgressImgS2"
local task_progress_num_s2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2/taskProgressbgS2/taskProgressNumS2"
local icon1_path = "ActivityTopGo/SpecialTaskContent/bg/specialType1/icon1"
local icon2_path = "ActivityTopGo/SpecialTaskContent/bg/specialType2/icon2"
local haveSendPassDayMsg = false
local recordLoopTaskProgressNum = 0
local bg_path = "ActivityTopGo/SpecialTaskContent/bg"
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
  self.btn_task = self:AddComponent(UIButton, btn_task_path)
  self.task_btn_red_point = self:AddComponent(UIImage, task_btn_red_point_path)
  self.special_task_content:SetOnClick(function()
    self:OnLoopTaskBtnClick()
  end)
  self.btn_task:SetOnClick(function()
    self:OnNormalTaskBtnClick()
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
  self.bgImg = self:AddComponent(UIImage, bg_path)
  self.bg1Img = self:AddComponent(UIImage, "ActivityTopGo/SpecialTaskContent/bg/bg1")
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
  self.bg1Img = nil
end

local function DataDefine(self)
  self.targetActId = nil
  self.targetActData = nil
  self.isLoopTask = false
  self.isDailyTask = false
  self.showData = nil
  self.targetTaskData = nil
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self.targetActId = tonumber(self.activityDetailData.achieveActivityId)
  self.targetActData = nil
  self.isLoopTask = false
  self.isDailyTask = false
  nextCanSendTime = 0
  self.eff_ui_data_glowmask:SetActive(false)
  haveSendPassDayMsg = false
  self:SetConfigView()
  self:RefreshView()
end

local function RefreshView(self)
  if self.targetActId and self.targetActId > 0 then
    self.targetActData = DataCenter.ActTaskManager:GetActData(self.targetActId)
    self.isLoopTask = DataCenter.ActTaskManager:IsLoopTask(self.targetActId)
    self.isDailyTask = DataCenter.ActTaskManager:IsDailyTask(self.targetActId)
  end
  if self.targetActData == nil then
    self.special_task_content:SetActive(false)
    self.btn_task:SetActive(false)
    return
  end
  nextCanSendTime = 0
  if self.isLoopTask then
    self.special_task_content:SetActive(true)
    self.btn_task:SetActive(false)
    self:RefreshLoopTaskView()
  else
    self.special_task_content:SetActive(false)
    self.btn_task:SetActive(true)
    self:RefreshNormalTaskView()
  end
end

local function RefreshLoopTaskView(self)
  self.showData = DataCenter.ActTaskManager:GetLoopTaskShowData(self.targetActId)
  self.targetTaskData = nil
  for i, v in ipairs(self.showData.taskList) do
    if v.data.state ~= TaskState.Received then
      self.targetTaskData = v
      break
    end
  end
  if self.targetTaskData == nil then
    self.targetTaskData = self.showData.taskList[#self.showData.taskList]
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
    local imgPath = string.format(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
    self.icon:LoadSprite(imgPath)
    local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.targetTaskData.data.reward)
    if showList and 0 < #showList then
      self.u_i_common_res_item:ReInit(showList[1])
    end
    local canGet = self.targetTaskData.data.state == TaskState.CanReceive
    self.eff_ui_duobao_jiangli_faguang:SetActive(canGet)
    self.eff_ui_special_task_content_full_glow:SetActive(canGet)
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
      self.task_progress_num_s1:SetText(process)
      local bgSizeDelta = self.task_progressbg_s1:GetSizeDelta()
      self.task_progress_img_s1:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
      local imgPath = string.format(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
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
      local imgPath = string.format(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
      self.icon2:LoadSprite(imgPath)
    end
  end
  self:Update1000MS()
end

local function RefreshNormalTaskView(self)
end

local function OnLoopTaskBtnClick(self)
  if self.targetActData == nil then
    return
  end
  if not self.isLoopTask then
    return
  end
  if self.targetTaskData == nil then
    return
  end
  if self.targetTaskData.data.state == TaskState.CanReceive then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > nextCanSendTime then
      nextCanSendTime = curTime + nextCanSendTimeInterval
      SFSNetwork.SendMessage(MsgDefines.ActivityTaskReward, tonumber(self.targetActId), tostring(self.targetTaskData.data.taskId))
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyLoopTask, {anim = true}, self.targetActId, self.activityId)
  end
end

local function OnNormalTaskBtnClick(self)
  if self.targetActData == nil then
    return
  end
  if self.isLoopTask then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyTask, {anim = true}, self.targetActId)
end

local function Update1000MS(self)
  if self.targetActData == nil then
    return
  end
  if not self.isLoopTask then
    return
  end
  if not self.isDailyTask then
    return
  end
  if self.targetTaskData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curTaskEndTime = DataCenter.ActTaskManager:GetTaskEndTine(self.targetActId)
  if curTaskEndTime <= 0 then
    return
  end
  if curTime >= curTaskEndTime then
    if not haveSendPassDayMsg then
      haveSendPassDayMsg = true
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.targetActId))
    end
  else
    local remainTime = curTaskEndTime - curTime
    local isShowTime = false
    local txtLoopTime = 35000
    local timeShow = 5000
    if timeShow > remainTime % txtLoopTime then
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
end

local function RecordCurLoopTaskProgress(self)
  recordLoopTaskProgressNum = 0
  if self.targetActData == nil then
    return
  end
  if not self.isLoopTask then
    return
  end
  recordLoopTaskProgressNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
end

local function GetCurLoopTaskProgressAddNum(self)
  if self.showData == nil then
    return 0
  end
  self.targetTaskData = nil
  for i, v in ipairs(self.showData.taskList) do
    if v.data.state ~= TaskState.Received then
      self.targetTaskData = v
      break
    end
  end
  if self.targetTaskData == nil then
    self.targetTaskData = self.showData.taskList[#self.showData.taskList]
  end
  local addNum = 0
  if self.targetActData == nil then
    return addNum
  end
  if not self.isLoopTask then
    return addNum
  end
  local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
  addNum = curNum - recordLoopTaskProgressNum
  if addNum < 0 then
    addNum = 0
  end
  return addNum
end

local function TryPlayTaskEffect(self)
  local addNum = self:GetCurLoopTaskProgressAddNum()
  if 0 < addNum then
    local oldNum = recordLoopTaskProgressNum
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

local function SetConfigView(self)
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec3) then
    local splitStr = string.split(showTemp.pic_spec3, "|")
    if #splitStr == 1 then
      local path = string.format(UIAssets.UIActMonopolySpritePath, showTemp.pic_spec3)
      self.bgImg:LoadSprite(path)
      self.bg1Img:SetActive(false)
    elseif #splitStr == 2 then
      local path1 = string.format(UIAssets.UIActMonopolySpritePath, splitStr[1])
      local path2 = string.format(UIAssets.UIActMonopolySpritePath, splitStr[2])
      self.bgImg:LoadSprite(path1)
      self.bg1Img:SetActive(true)
      self.bg1Img:LoadSprite(path2)
    end
  end
end

ActMonopolyTaskContent.OnCreate = OnCreate
ActMonopolyTaskContent.OnDestroy = OnDestroy
ActMonopolyTaskContent.ComponentDefine = ComponentDefine
ActMonopolyTaskContent.ComponentDestroy = ComponentDestroy
ActMonopolyTaskContent.DataDefine = DataDefine
ActMonopolyTaskContent.DataDestroy = DataDestroy
ActMonopolyTaskContent.SetData = SetData
ActMonopolyTaskContent.RefreshView = RefreshView
ActMonopolyTaskContent.RefreshLoopTaskView = RefreshLoopTaskView
ActMonopolyTaskContent.RefreshNormalTaskView = RefreshNormalTaskView
ActMonopolyTaskContent.OnLoopTaskBtnClick = OnLoopTaskBtnClick
ActMonopolyTaskContent.OnNormalTaskBtnClick = OnNormalTaskBtnClick
ActMonopolyTaskContent.Update1000MS = Update1000MS
ActMonopolyTaskContent.RecordCurLoopTaskProgress = RecordCurLoopTaskProgress
ActMonopolyTaskContent.GetCurLoopTaskProgressAddNum = GetCurLoopTaskProgressAddNum
ActMonopolyTaskContent.TryPlayTaskEffect = TryPlayTaskEffect
ActMonopolyTaskContent.SetConfigView = SetConfigView
return ActMonopolyTaskContent
