local UILWGrowFoundationTargetItem = BaseClass("UILWGrowFoundationTargetItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local targetNameText_path = "TargetNameText"
local targetRewardText_path = "TargetRewardText"
local rewardBtn_path = "RewardBtn"
local rewardBtnText_path = "RewardBtn/BtnText"
local icon_path = "Icon"
local lockedIcon_path = "LockedIcon"

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
  self.targetNameText = self:AddComponent(UIText, targetNameText_path)
  self.targetRewardText = self:AddComponent(UIText, targetRewardText_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtn:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnText_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.lockedIcon = self:AddComponent(UIImage, lockedIcon_path)
end

local function ComponentDestroy(self)
  self.targetNameText = nil
  self.targetRewardText = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.icon = nil
  self.lockedIcon = nil
end

local function DataDefine(self)
  self.taskId = 0
  self.listenerInited = nil
end

local function DataDestroy(self)
  self.taskId = nil
  self.listenerInited = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  if self.listenerInited then
    self:RemoveUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = false
  end
  base.OnRemoveListener(self)
end

local function SetItem(self, taskId, buyState, actId)
  self.taskId = taskId
  self.buyState = buyState
  self.actId = actId
  if self.taskId then
    self.taskInfo = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
    self.taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
    self:RefreshAll()
  end
end

local function RefreshAll(self)
  if not self.taskInfo or not self.taskValue then
    return
  end
  self.targetNameText:SetText(self.taskInfo:GetDesc(true))
  self.icon:LoadSprite(string.format(LoadPath.UIGrowFoundation, self.taskInfo.icon))
  local state = self.taskValue.state
  if state == TaskState.Received then
    self.rewardBtn:SetActive(true)
    UIGray.SetGray(self.rewardBtn.transform, true, false)
    self.lockedIcon:SetActive(false)
    self.rewardBtnText:SetLocalText(2000502)
  elseif state == TaskState.CanReceive then
    self.rewardBtn:SetActive(true)
    UIGray.SetGray(self.rewardBtn.transform, false, true)
    self.lockedIcon:SetActive(false)
    self.rewardBtnText:SetLocalText(2000501)
  else
    self.rewardBtn:SetActive(false)
    self.lockedIcon:SetActive(true)
  end
  if not table.IsNullOrEmpty(self.taskValue.rewardList) then
    local rewardList = DataCenter.RewardManager:RewardItemList(self.taskValue.rewardList)
    local diamondRewardCount = 0
    for i, v in pairs(rewardList) do
      if v.rewardType == RewardType.GOLD then
        diamondRewardCount = diamondRewardCount + v.count
      end
    end
    self.targetRewardText:SetLocalText(2000503, " " .. diamondRewardCount)
  else
    self.targetRewardText:SetText("")
  end
end

local function TryShowClaimEff(self, tempTaskId)
  if self.listenerInited then
    self:RemoveUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = false
  end
  if self.taskId and self.taskValue and self.taskId == tempTaskId then
    for i, v in pairs(self.taskValue.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = DataCenter.RewardManager:GetPicByType(v.rewardType, itemId)
      if pic ~= "" then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, self.rewardBtn.transform.position, Vector3.New(0, 0, 0))
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
  end
end

local function OnClickClaimBtn(self)
  if self.buyState and self.taskValue.state == 1 then
    self:AddUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = true
    SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
      id = self.taskId
    })
  elseif not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWGrowFoundationBuy) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGrowFoundationBuy, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.actId)
  end
end

UILWGrowFoundationTargetItem.OnCreate = OnCreate
UILWGrowFoundationTargetItem.OnDestroy = OnDestroy
UILWGrowFoundationTargetItem.ComponentDefine = ComponentDefine
UILWGrowFoundationTargetItem.ComponentDestroy = ComponentDestroy
UILWGrowFoundationTargetItem.DataDefine = DataDefine
UILWGrowFoundationTargetItem.DataDestroy = DataDestroy
UILWGrowFoundationTargetItem.OnAddListener = OnAddListener
UILWGrowFoundationTargetItem.OnRemoveListener = OnRemoveListener
UILWGrowFoundationTargetItem.SetItem = SetItem
UILWGrowFoundationTargetItem.RefreshAll = RefreshAll
UILWGrowFoundationTargetItem.OnClickClaimBtn = OnClickClaimBtn
UILWGrowFoundationTargetItem.TryShowClaimEff = TryShowClaimEff
return UILWGrowFoundationTargetItem
