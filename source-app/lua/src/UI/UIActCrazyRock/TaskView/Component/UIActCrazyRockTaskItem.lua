local base = UIBaseContainer
local UIActCrazyRockTaskItem = BaseClass("UIActCrazyRockTaskItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockTaskItem
local task_desc_text_path = "TaskDesc/TaskDescText"
local task_complete_text_path = "TaskDesc/TaskCompleteText"
local go_to_btn_path = "BtnNode/GoToBtn"
local go_to_btn_text_path = "BtnNode/GoToBtn/LW_Btn_Common_New_Base/GoToBtnText"
local receive_btn_path = "BtnNode/ReceiveBtn"
local receive_btn_text_path = "BtnNode/ReceiveBtn/LW_Btn_Common_New_Base/ReceiveBtnText"
local reward_scroll_path = "RewardScroll"
local content_path = "RewardScroll/Viewport/Content"
local bg_path = "Bg"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.task_desc_text = self:AddComponent(UITextMeshProUGUIEx, task_desc_text_path)
  self.task_complete_text = self:AddComponent(UITextMeshProUGUIEx, task_complete_text_path)
  self.go_to_btn = self:AddComponent(UIButton, go_to_btn_path)
  self.go_to_btn:SetOnClick(function()
    self:OnClickGoToBtn()
  end)
  self.go_to_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_to_btn_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn_text = self:AddComponent(UITextMeshProUGUIEx, receive_btn_text_path)
  self.receive_btn:SetOnClick(function()
    self:OnClickReceiveBtn()
  end)
  self.resItem = self.transform:Find("UICommonResItem").gameObject
  self.resItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.completedIcon = self:AddComponent(UIImage, "CompleteIcon")
  self.go_to_btn_text:SetLocalText("110003")
  self.receive_btn_text:SetLocalText("170004")
  self.bg = self:AddComponent(UIImage, bg_path)
end

function M:ComponentDestroy()
  self.task_desc_text = nil
  self.task_complete_text = nil
  self.go_to_btn = nil
  self.go_to_btn_text = nil
  self.receive_btn = nil
  self.receive_btn_text = nil
  self.reward_scroll = nil
  self.content = nil
  self.completedIcon = nil
  self.bg = nil
end

function M:DataDefine()
  self.rankData = {}
  self.activityId = 0
  self.showConfig = {}
end

function M:DataDestroy()
  self.rankData = nil
  self.activityId = nil
  self.showConfig = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(taskData, activityId, showConfig)
  self.taskData = taskData
  self.activityId = activityId
  self.showConfig = showConfig
  self:SetItem()
end

function M:SetItem()
  self.taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskData.taskId)
  self.rewardList = self.taskData.rewardList
  self:RefreshReward()
  local taskDesc = Localization:GetString(self.taskTemplate.desc, self.taskTemplate.para2)
  local process = ""
  local curNum = self.taskData.num and self.taskData.num or 0
  local targetNum = self.taskTemplate.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = " (" .. curNum .. "/" .. targetNum .. ")"
  self.task_desc_text:SetText(taskDesc)
  self.task_complete_text:SetText(process)
  local state = self.taskData.state
  if state == TaskState.Received then
    self.completedIcon:SetActive(true)
    self.receive_btn:SetActive(false)
    self.go_to_btn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.completedIcon:SetActive(false)
    self.receive_btn:SetActive(true)
    self.go_to_btn:SetActive(false)
  else
    self.completedIcon:SetActive(false)
    self.receive_btn:SetActive(false)
    self.go_to_btn:SetActive(true)
  end
  if self.showConfig and self.showConfig.board_list_di then
    local imageList = string.split(self.showConfig.board_list_di, "|")
    local imagePath = imageList[1]
    local colorArr = imageList[2]
    local colorList = string.split(colorArr, ",")
    if self.bg then
      self.bg:LoadSpriteAsync(imagePath)
      self.bg:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
    end
  end
end

function M:RefreshReward()
  if not self.rewardList then
    Logger.LogError("rewardList is nil")
    return
  end
  self:ClearScroll()
  self.model = {}
  for i = 1, table.length(self.rewardList) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_sizeDelta(118, 118)
      go.transform:Set_localScale(0.74, 0.74, 1)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ParseInfo(self.rewardList[i])
    end)
  end
end

function M:OnClickGoToBtn()
  if self.taskTemplate then
    GoToUtil.GoToByQuestId(self.taskTemplate)
  end
end

function M:OnClickReceiveBtn()
  DataCenter.ActCrazyRockTaskManager:RequestReceiveTaskReward(self.activityId, self.taskData.taskId)
end

function M:ClearScroll()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return M
