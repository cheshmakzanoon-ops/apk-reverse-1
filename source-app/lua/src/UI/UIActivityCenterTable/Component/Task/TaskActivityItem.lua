local TaskActivityItem = BaseClass("TaskActivityItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local go_bg_path = "GoBg"
local got_bg_path = "GotBg"
local icon_bg_path = "IconBg"
local icon_path = "Icon"
local star_path = "star"
local desc_path = "Desc"
local name_txt_path = "Layout/Txt_Name"
local target_txt_path = "Layout/Txt_TaskTarget"
local reward_content_path = "RewardContent"
local go_btn_path = "GoBtn"
local go_btn_text_path = "GoBtn/GoBtnText"
local receive_btn_path = "ReceiveBtn"
local receive_btn_txt_path = "ReceiveBtn/ReceiveBtnText"
local cd_text_path = "cdText"
local duigou_img_path = "duigouImg"
local perpect_text_path = "perpectText"

function TaskActivityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TaskActivityItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TaskActivityItem:ComponentDefine()
  self.got_bg = self:AddComponent(UIImage, got_bg_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.targetText = self:AddComponent(UIText, target_txt_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_btn_text = self:AddComponent(UIText, go_btn_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.receive_btn_txt = self:AddComponent(UIText, receive_btn_txt_path)
  self.duigou_img = self:AddComponent(UIImage, duigou_img_path)
end

function TaskActivityItem:ComponentDestroy()
  self.got_bg = nil
  self.nameText = nil
  self.targetText = nil
  self.reward_content = nil
  self.go_btn = nil
  self.receive_btn = nil
  self.duigou_img = nil
  self.go_btn_text = nil
  self.receive_btn_txt = nil
end

function TaskActivityItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
end

function TaskActivityItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
end

function TaskActivityItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.reward_content:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function TaskActivityItem:RefreshReward(rewardList)
  self:ClearContent()
  local prefabPath = "Assets/Main/Prefabs/UI/LWQuest/ChapterTaskRewardItem.prefab"
  for i, data in ipairs(rewardList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(prefabPath, function(req)
      if req.isError then
        return
      end
      local item = req.gameObject
      item.name = "reward_item" .. i
      item:SetActive(true)
      item.transform:GetChild(0).gameObject.name = "obj" .. i
      item.transform:GetChild(0).gameObject:SetActive(true)
      item.transform:SetParent(self.reward_content.transform)
      item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local cell = self.reward_content:AddComponent(UICommonResItem, item.name .. "/obj" .. i)
      cell:ReInit(data)
      self.itemList[i] = cell
    end)
  end
end

function TaskActivityItem:SetData(taskId)
  self.taskId = taskId
  if self.taskId then
    self.taskInfo = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
    self.taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
    self:RefreshShow()
  end
end

function TaskActivityItem:RefreshShow()
  if not self.taskInfo or not self.taskValue then
    return
  end
  local process = ""
  local curNum = self.taskValue.num and self.taskValue.num or 0
  local targetNum = self.taskInfo.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = " (" .. curNum .. "/" .. targetNum .. ")"
  self.nameText:SetText(self.taskInfo:GetDesc(true))
  self.targetText:SetText(process)
  local state = self.taskValue.state
  if state == TaskState.Received then
    self.got_bg:SetActive(true)
    self.duigou_img:SetActive(true)
    self.receive_btn:SetActive(false)
    self.go_btn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.got_bg:SetActive(false)
    self.duigou_img:SetActive(false)
    self.receive_btn:SetActive(true)
    self.go_btn:SetActive(false)
  else
    self.got_bg:SetActive(false)
    self.duigou_img:SetActive(false)
    self.receive_btn:SetActive(false)
    self.go_btn:SetActive(true)
  end
  if self.taskValue.rewardList then
    local rewardList = self.taskValue:GetFinalReward()
    self:RefreshReward(rewardList)
  else
    self:RefreshReward({})
  end
end

function TaskActivityItem:OnBgClick()
end

function TaskActivityItem:OnGoClick()
  if self.taskId and self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

function TaskActivityItem:OnReceiveClick()
  if self.taskId and self.taskValue and self.taskValue.state == TaskState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
      id = self.taskId
    })
  end
end

return TaskActivityItem
