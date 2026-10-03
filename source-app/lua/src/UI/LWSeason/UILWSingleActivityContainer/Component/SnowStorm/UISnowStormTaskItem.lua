local base = UIBaseContainer
local UISnowStormTaskItem = BaseClass("UISnowStormTaskItem", base)
local goBg_path = "GoBg"
local ReceiveBg_path = "ReceiveBg"
local desc_path = "Desc"
local progress_path = "Progress"
local rewardContent_path = "RewardContent"
local goBtn_path = "GoBtn"
local receiveBtn_path = "ReceiveBtn"
local rewardPrefab_path = "UICommonResItem"
local gotoBtnText_path = "GoBtn/GoBtnText"
local receiveBtnText_path = "ReceiveBtn/ReceiveBtnText"

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
  self.goBg = self:AddComponent(UIBaseContainer, goBg_path)
  self.ReceiveBg = self:AddComponent(UIBaseContainer, ReceiveBg_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.progress = self:AddComponent(UIText, progress_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.goBtn = self:AddComponent(UIButton, goBtn_path)
  self.receiveBtn = self:AddComponent(UIButton, receiveBtn_path)
  self.rewardPrefab = self:AddComponent(UIBaseContainer, rewardPrefab_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.receiveBtnText = self:AddComponent(UIText, receiveBtnText_path)
  self.gotoBtnText:SetLocalText("110003")
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
end

local function ComponentDestroy(self)
  self.goBg = nil
  self.ReceiveBg = nil
  self.desc = nil
  self.progress = nil
  self.rewardContent = nil
  self.goBtn = nil
  self.receiveBtn = nil
  self.rewardPrefab = nil
  self.gotoBtnText = nil
  self.receiveBtnText = nil
end

local function DataDefine(self)
  self.commonRewardItem = self.rewardPrefab.gameObject
  self.commonRewardItem:GameObjectCreatePool()
end

local function DataDestroy(self)
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.commonRewardItem then
    self.commonRewardItem:GameObjectRecycleAll()
  end
  self.commonRewardItem = nil
end

function UISnowStormTaskItem:SetData(info)
  self.info = info
  self.receiveBtnText:SetLocalText("170004")
  self.taskData = DataCenter.TaskManager:FindTaskInfo(self.info.taskId)
  if self.taskData then
    self.taskInfos = DataCenter.ChapterTaskManager:GetTaskInfos(self.taskData)
    self.desc:SetText(self.taskInfos.strDesc)
    local reward = self.taskInfos.rewardList
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.commonRewardItem:GameObjectRecycleAll()
    if reward then
      for index, value in ipairs(reward) do
        local go = self.commonRewardItem:GameObjectSpawn(self.rewardContent.transform)
        go.gameObject:SetActive(true)
        go.transform:Set_localScale(0.76, 0.76, 0.76)
        go.name = "item" .. tostring(index)
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(value)
      end
    end
    if self.taskData.state then
      if self.taskData.state == TaskState.CanReceive then
        self.goBtn:SetActive(false)
        self.receiveBtn:SetActive(true)
        self.ReceiveBg:SetActive(true)
        CS.UIGray.SetGray(self.receiveBtn.transform, false, true)
      elseif self.taskData.state == TaskState.Received then
        self.goBtn:SetActive(false)
        self.receiveBtn:SetActive(true)
        self.ReceiveBg:SetActive(false)
        self.receiveBtnText:SetLocalText("170003")
        CS.UIGray.SetGray(self.receiveBtn.transform, true)
      else
        self.goBtn:SetActive(true)
        self.receiveBtn:SetActive(false)
        self.ReceiveBg:SetActive(false)
      end
    else
      self.goBtn:SetActive(true)
      self.receiveBtn:SetActive(false)
      self.ReceiveBg:SetActive(false)
    end
  else
    self.goBtn:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.ReceiveBg:SetActive(false)
    if CS.CommonUtils.IsDebug() then
      self.desc:SetText(self.info.taskId)
    else
      self.desc:SetText("")
    end
    Logger.LogError("FindTaskInfo not find taskInfo  id: " .. tostring(self.info.taskId))
  end
end

function UISnowStormTaskItem:OnGoClick()
  DataCenter.ChapterTaskManager:QuestGoto(self.taskData)
end

function UISnowStormTaskItem:OnReceiveClick()
  if self.taskData.state == TaskState.CanReceive then
    local data = {}
    data.id = self.taskData.id
    DataCenter.ChapterTaskManager:QuestGetReward(data, nil)
  end
end

UISnowStormTaskItem.OnCreate = OnCreate
UISnowStormTaskItem.OnDestroy = OnDestroy
UISnowStormTaskItem.OnEnable = OnEnable
UISnowStormTaskItem.OnDisable = OnDisable
UISnowStormTaskItem.ComponentDefine = ComponentDefine
UISnowStormTaskItem.ComponentDestroy = ComponentDestroy
UISnowStormTaskItem.DataDefine = DataDefine
UISnowStormTaskItem.DataDestroy = DataDestroy
return UISnowStormTaskItem
