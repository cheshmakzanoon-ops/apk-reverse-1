local UIStageMissionItem = BaseClass("UIStageMissionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickClaimReward(self)
  if self.taskValue.state == 1 then
    self:AddUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = true
    self.view.ctrl:GetSevenDayTaskReward(self.taskId)
  end
end

local function OnClickGotoBtn(self)
  if self.clickGotoAction then
    self.clickGotoAction()
  end
end

local function TryShowClaimEff(self, tempTaskId)
  if self.listenerInited then
    self:RemoveUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = false
  end
  if self.taskId and self.taskValue and self.taskId == tempTaskId then
    local tempType = {}
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.taskValue.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showList[i].iconImg
      if pic ~= "" and not IsNull(img) then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
  end
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, "Bg")
  self.completeMarkImg = self:AddComponent(UIImage, "CompleteMark")
  self.missionNameText = self:AddComponent(UIText, "MissionNameText")
  self.receiveBtn = self:AddComponent(UIButton, "ReceiveBtn")
  self.receiveBtn:SetOnClick(function()
    OnClickClaimReward(self)
  end)
  self.receiveBtnText = self:AddComponent(UIText, "ReceiveBtn/BtnText")
  self.rewardsContainer = self:AddComponent(UIBaseContainer, "Rewards")
  self.gotoBtn = self:AddComponent(UIButton, "GotoBtn")
  self.gotoBtn:SetOnClick(function()
    OnClickGotoBtn(self)
  end)
  self.gotoBtnText = self:AddComponent(UIText, "GotoBtn/GotoBtnText")
end

local function ComponentDestroy(self)
  self.bg = nil
  self.completeMarkImg = nil
  self.missionNameText = nil
  self.receiveBtn = nil
  self.receiveBtnText = nil
  self.rewardsContainer = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
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

local function DataDefine(self)
end

local function DataDestroy(self)
  self.clickGotoAction = nil
end

local function SetAllCellDestroy(self)
  self.rewardsContainer:RemoveComponents(UICommonResItem)
  if self.rewardItems ~= nil then
    for k, v in pairs(self.rewardItems) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardItems = {}
end

local function RefreshReward(self, list)
  SetAllCellDestroy(self)
  if not table.IsNullOrEmpty(list) then
    self.showList = self.view.ctrl:RewardItemList(list)
  else
    self.showList = {}
  end
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.rewardItems[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardsContainer.transform)
        go.transform:Set_localScale(0.77, 0.8, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardsContainer:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
      end)
    end
  end
end

local function SetData(self, taskId, selectStage, curStage, clickGotoAction)
  if not taskId then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.taskId = taskId
  self.taskInfo = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskId)
  if not self.taskInfo then
    return
  end
  self.taskValue = DataCenter.TaskManager:FindTaskInfo(self.taskId)
  if not self.taskValue then
    return
  end
  self.clickGotoAction = clickGotoAction
  local taskNameStr = self.taskInfo:GetDesc(true)
  local progNum = self.taskValue.num
  local targetNum = self.taskInfo.para2
  progNum = math.min(progNum, targetNum)
  progNum = string.GetFormattedStr(progNum)
  targetNum = string.GetFormattedStr(targetNum)
  taskNameStr = string.format("%s (%s/%s)", taskNameStr, progNum, targetNum)
  self.missionNameText:SetText(taskNameStr)
  local taskState = self.taskValue.state
  if taskState == TaskState.Received then
    self.receiveBtn:SetActive(false)
    self.gotoBtn:SetActive(false)
    self.completeMarkImg:SetActive(true)
    self.missionNameText:SetColorRGBA(0.56, 0.61, 0.71, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_yilingqu_kuang.png")
  elseif taskState == TaskState.CanReceive then
    self.receiveBtn:SetActive(true)
    self.gotoBtn:SetActive(false)
    self.receiveBtnText:SetLocalText(2000227)
    self.completeMarkImg:SetActive(false)
    self.missionNameText:SetColorRGBA(0.15, 0.17, 0.2, 1)
    UIGray.SetGray(self.receiveBtn.transform, false, true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/cfm_renwu_tiao_2.png")
  elseif selectStage ~= curStage then
    self.receiveBtn:SetActive(true)
    self.gotoBtn:SetActive(false)
    if selectStage < curStage then
      self.receiveBtnText:SetLocalText(2000228)
    else
      self.receiveBtnText:SetLocalText("activity_commander_tips1")
    end
    self.completeMarkImg:SetActive(false)
    self.missionNameText:SetColorRGBA(0.15, 0.17, 0.2, 1)
    UIGray.SetGray(self.receiveBtn.transform, true, false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/cfm_renwu_tiao_2.png")
  else
    self.receiveBtn:SetActive(false)
    self.gotoBtn:SetActive(true)
    self.completeMarkImg:SetActive(false)
    self.missionNameText:SetColorRGBA(0.15, 0.17, 0.2, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/cfm_renwu_tiao_2.png")
  end
  RefreshReward(self, self.taskValue.rewardList)
end

UIStageMissionItem.OnCreate = OnCreate
UIStageMissionItem.OnDestroy = OnDestroy
UIStageMissionItem.ComponentDefine = ComponentDefine
UIStageMissionItem.ComponentDestroy = ComponentDestroy
UIStageMissionItem.DataDefine = DataDefine
UIStageMissionItem.DataDestroy = DataDestroy
UIStageMissionItem.OnAddListener = OnAddListener
UIStageMissionItem.OnRemoveListener = OnRemoveListener
UIStageMissionItem.TryShowClaimEff = TryShowClaimEff
UIStageMissionItem.SetData = SetData
UIStageMissionItem.SetAllCellDestroy = SetAllCellDestroy
return UIStageMissionItem
