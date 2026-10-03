local LeadingQuestItem = BaseClass("LeadingQuestItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")
local title_path = "Txt_Name"
local goal_path = "Txt_Name/Txt_TaskTarget (1)"
local prog_path = "Txt_TaskTarget"
local content_path = "Rect_Reward"
local claimBtn_path = "Btn_Reward"
local claimBtnTxt_path = "Btn_Reward/Txt_Reward"
local claimedTxt_path = "Txt_Completed"
local grayImg_path = "Btn_Reward/gray"
local bg_path = ""

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

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(372133)
  self.goalTxtN = self:AddComponent(UIText, goal_path)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimReward()
  end)
  self.claimBtnImgN = self:AddComponent(UIImage, claimBtn_path)
  self.claimBtnTxtN = self:AddComponent(UIText, claimBtnTxt_path)
  self.claimBtnTxtN:SetLocalText(170004)
  self.claimedTxtN = self:AddComponent(UIText, claimedTxt_path)
  self.claimedTxtN:SetLocalText(170008)
  self.grayImgN = self:AddComponent(UIImage, grayImg_path)
  self.grayMat = self.grayImgN:GetMaterial()
  self.bgN = self:AddComponent(UIImage, bg_path)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.titleN = nil
  self.contentN = nil
  self.claimBtnN = nil
  self.claimBtnTxtN = nil
  self.claimedTxtN = nil
  self.bgN = nil
end

local function DataDefine(self)
  self.taskInfo = nil
  self.taskValue = nil
  self.showList = nil
  self.listenerInited = nil
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.taskValue = nil
  self.showList = nil
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

local function SetItem(self, taskId, bgPath)
  self.taskId = taskId
  self.taskInfo = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
  self.taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
  self.titleN:SetText(self.taskInfo:GetDesc(true))
  local progNum = self.taskValue.num
  local targetNum = self.taskInfo.para2
  progNum = math.min(progNum, targetNum)
  progNum = string.GetFormattedSeperatorNum(progNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  self.goalTxtN:SetText(progNum .. "/" .. targetNum)
  local state = self.taskValue.state
  if state == 2 then
    self.claimedTxtN:SetActive(true)
    self.claimBtnN:SetActive(false)
  elseif state == 1 then
    self.claimedTxtN:SetActive(false)
    self.claimBtnN:SetActive(true)
    UIGray.SetGray(self.claimBtnN.transform, false, true)
  else
    self.claimedTxtN:SetActive(false)
    self.claimBtnN:SetActive(true)
    UIGray.SetGray(self.claimBtnN.transform, true, false)
  end
  if not string.IsNullOrEmpty(bgPath) then
    self.bgN:LoadSprite(bgPath)
  end
  self:RefreshReward(self.taskValue.rewardList)
end

local function RefreshReward(self, list)
  self:SetAllCellDestroy()
  if not table.IsNullOrEmpty(list) then
    self.showList = self.view.ctrl:RewardItemList(list)
  else
    self.showList = {}
  end
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.contentN.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.contentN:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.contentN:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function TryShowClaimEff(self, tempTaskId)
  if self.listenerInited then
    self:RemoveUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = false
  end
  if self.taskId and self.taskValue and self.taskId == tempTaskId then
    local tempType = {}
    for i, v in ipairs(self.taskValue.rewardList) do
      if v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY then
        tempType = {
          ResourceType.Metal,
          ResourceType.Electricity,
          ResourceType.Water
        }
        break
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.taskValue.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showList[i].iconImg
      if pic ~= "" then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
  end
end

local function OnClickClaimReward(self)
  if self.taskValue.state == 1 then
    self:AddUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
    self.listenerInited = true
    self.view.ctrl:GetSevenDayTaskReward(self.taskId)
  end
end

LeadingQuestItem.OnCreate = OnCreate
LeadingQuestItem.OnDestroy = OnDestroy
LeadingQuestItem.ComponentDefine = ComponentDefine
LeadingQuestItem.ComponentDestroy = ComponentDestroy
LeadingQuestItem.DataDefine = DataDefine
LeadingQuestItem.DataDestroy = DataDestroy
LeadingQuestItem.OnAddListener = OnAddListener
LeadingQuestItem.OnRemoveListener = OnRemoveListener
LeadingQuestItem.SetItem = SetItem
LeadingQuestItem.RefreshReward = RefreshReward
LeadingQuestItem.SetAllCellDestroy = SetAllCellDestroy
LeadingQuestItem.TryShowClaimEff = TryShowClaimEff
LeadingQuestItem.OnClickClaimReward = OnClickClaimReward
return LeadingQuestItem
