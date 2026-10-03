local base = UIBaseContainer
local LWUIZoneMobilizationDailyTaskItemRender = BaseClass("LWUIZoneMobilizationDailyTaskItemRender", base)
local nameText_path = "NameText"
local desText_path = "DesText"
local gotoBtn_path = "GoToBtn"
local gotoBtnText_path = "GoToBtn/GoToBtnText"
local receiveRewardBtn_path = "ReceiveRewardBtn"
local receiveRewardBtnText_path = "ReceiveRewardBtn/ReceiveRewardBtnText"
local finishState_path = "FinishState"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.receiveRewardBtn = self:AddComponent(UIButton, receiveRewardBtn_path)
  self.receiveRewardBtnText = self:AddComponent(UIText, receiveRewardBtnText_path)
  self.finishState = self:AddComponent(UIBaseContainer, finishState_path)
  self.gotoBtnText:SetLocalText("zone_mobilization_stage_go_btn")
  self.receiveRewardBtnText:SetLocalText("zone_mobilization_task_accept_btn")
  self.gotoBtn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.receiveRewardBtn:SetOnClick(function()
    self:ReceiveRewardBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.desText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.receiveRewardBtn = nil
  self.receiveRewardBtnText = nil
  self.finishState = nil
end

local function DataDefine(self)
  self.taskInfo = nil
  self.taskTemplate = nil
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.taskTemplate = nil
end

local function InitData(self, data)
  self.taskInfo = data
  self.taskTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(data.taskId)
  if self.taskTemplate then
    self.nameText:SetLocalText(self.taskTemplate.name)
    if table.count(self.taskInfo.reward) > 0 then
      local rewardData = self.taskInfo.reward[1]
      local rewardCount = rewardData.count or 0
      local taskDes = self.taskTemplate:GetDesc(true)
      local tag = "<size=180%><sprite=0></size></size>"
      local desStr = "<color=#736863>" .. taskDes .. "</color>" .. "<color=#099b4a>" .. " +" .. tostring(rewardCount) .. "</color>" .. tag
      self.desText:SetText(desStr)
    else
      self.desText:SetText(self.taskTemplate:GetDesc(true))
    end
  end
  self.gotoBtn:SetActive(self.taskInfo.state == TaskState.NoComplete)
  self.receiveRewardBtn:SetActive(self.taskInfo.state == TaskState.CanReceive)
  self.finishState:SetActive(self.taskInfo.state == TaskState.Received)
end

local function GoToBtnClick(self)
  if self.taskTemplate then
    local goType = tonumber(self.taskTemplate.gotype2)
    local goPara = self.taskTemplate.gopara
    if tonumber(goPara[1]) == BuildingTypes.LW_BUILD_DISPATCH_TASK and not DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
      UIUtil.ShowTipsId("zone_mobilization_paiqian_not_open")
    else
      GoToUtil.GoToByTypeAndParam(goType, goPara, self.taskTemplate)
    end
  end
end

local function ReceiveRewardBtnClick(self)
  if self.taskInfo then
    SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
      id = self.taskInfo.taskId
    })
  end
end

LWUIZoneMobilizationDailyTaskItemRender.OnCreate = OnCreate
LWUIZoneMobilizationDailyTaskItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationDailyTaskItemRender.OnEnable = OnEnable
LWUIZoneMobilizationDailyTaskItemRender.OnDisable = OnDisable
LWUIZoneMobilizationDailyTaskItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDailyTaskItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDailyTaskItemRender.DataDefine = DataDefine
LWUIZoneMobilizationDailyTaskItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationDailyTaskItemRender.InitData = InitData
LWUIZoneMobilizationDailyTaskItemRender.GoToBtnClick = GoToBtnClick
LWUIZoneMobilizationDailyTaskItemRender.ReceiveRewardBtnClick = ReceiveRewardBtnClick
return LWUIZoneMobilizationDailyTaskItemRender
