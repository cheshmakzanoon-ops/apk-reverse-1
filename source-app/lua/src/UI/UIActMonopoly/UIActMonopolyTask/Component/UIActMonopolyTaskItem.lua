local UIActMonopolyTaskItem = BaseClass("UIActMonopolyTaskItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local desc_txt_path = "Ani/Desc"
local go_btn_path = "Ani/GoBtn"
local receive_btn_path = "Ani/ReceiveBtn"
local reward_content_path = "Ani/RewardScroll/Content"
local completedIconPath = "Ani/CompletedContent"

function UIActMonopolyTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyTaskItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyTaskItem:ComponentDefine()
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.goBtn = self:AddComponent(UIButton, go_btn_path)
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receiveBtn = self:AddComponent(UIButton, receive_btn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.completedIcon = self:AddComponent(UIImage, completedIconPath)
end

function UIActMonopolyTaskItem:ComponentDestroy()
  self.descText = nil
  self.goBtn = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.completedIcon = nil
end

function UIActMonopolyTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
end

function UIActMonopolyTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
end

function UIActMonopolyTaskItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UIActMonopolyTaskItem:RefreshReward(rewardList)
  self:ClearContent()
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.rewardContent.transform)
        item.transform:Set_localScale(0.75, 0.8, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function UIActMonopolyTaskItem:SetData(activityId, taskData)
  self.activityId = activityId
  self.taskData = taskData
  self.taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskData.taskId)
  local taskDesc = self.taskInfo:GetDesc(true)
  local process = ""
  local curNum = self.taskData.num and self.taskData.num or 0
  local targetNum = self.taskInfo.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = " (" .. curNum .. "/" .. targetNum .. ")"
  self.descText:SetText(taskDesc .. process)
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskData.reward)
  self:RefreshReward(showList)
  local state = self.taskData.state
  if state == TaskState.Received then
    self.completedIcon:SetActive(true)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(true)
    self.goBtn:SetActive(false)
  else
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(true)
  end
end

function UIActMonopolyTaskItem:OnGoClick()
  if self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

function UIActMonopolyTaskItem:OnReceiveClick()
  SFSNetwork.SendMessage(MsgDefines.ActivityTaskReward, tonumber(self.activityId), tostring(self.taskData.taskId))
end

return UIActMonopolyTaskItem
