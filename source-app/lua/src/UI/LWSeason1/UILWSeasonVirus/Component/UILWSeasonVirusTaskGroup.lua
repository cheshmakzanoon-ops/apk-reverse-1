local UILWSeasonVirusTaskGroup = BaseClass("UILWSeasonVirusTaskGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWSeasonVirusTaskItem = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusTaskItem")
local content_path = "ScrollView/Viewport/Content"
local task_path = "ScrollView/Viewport/Content/task"
local no_main_task_text_path = "ScrollView/Viewport/Content/noMainTaskText"
local rank_root_path = "RankRoot"
local btn_rank_path = "RankRoot/BtnRank"
local achievement29_path = "ScrollView/Viewport/Content/Achievement29"
local title29_path = "ScrollView/Viewport/Content/Achievement29/title29"
local desc29_path = "ScrollView/Viewport/Content/Achievement29/desc29"
local achievement30_path = "ScrollView/Viewport/Content/Achievement30"
local title30_path = "ScrollView/Viewport/Content/Achievement30/title30"
local desc30_path = "ScrollView/Viewport/Content/Achievement30/desc30"
local achievement31_path = "ScrollView/Viewport/Content/Achievement31"
local title31_path = "ScrollView/Viewport/Content/Achievement31/title31"
local desc31_path = "ScrollView/Viewport/Content/Achievement31/desc31"

function UILWSeasonVirusTaskGroup:OnCreate()
  base.OnCreate(self)
  self.taskList = nil
  self.rank_root = self:AddComponent(UIBaseContainer, rank_root_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.no_main_task_text = self:AddComponent(UIText, no_main_task_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(task_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.achievement29 = self:AddComponent(UIImage, achievement29_path)
  self.title29 = self:AddComponent(UITextMeshProUGUIEx, title29_path)
  self.desc29 = self:AddComponent(UITextMeshProUGUIEx, desc29_path)
  self.achievement30 = self:AddComponent(UIImage, achievement30_path)
  self.title30 = self:AddComponent(UITextMeshProUGUIEx, title30_path)
  self.desc30 = self:AddComponent(UITextMeshProUGUIEx, desc30_path)
  self.achievement31 = self:AddComponent(UIImage, achievement31_path)
  self.title31 = self:AddComponent(UITextMeshProUGUIEx, title31_path)
  self.desc31 = self:AddComponent(UITextMeshProUGUIEx, desc31_path)
  local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
  if 1 <= seasonVersion then
    self.rank_root:SetActive(true)
    self.btn_rank:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonVirusRank)
    end)
    self.rank_root:SetActive(true)
  else
    self.rank_root:SetActive(false)
  end
  self.achievement29:SetActive(false)
  self.achievement30:SetActive(false)
  self.achievement31:SetActive(false)
  self.seasonVersion = seasonVersion
end

function UILWSeasonVirusTaskGroup:OnDestroy()
  self.achievement29 = nil
  self.title29 = nil
  self.desc29 = nil
  self.achievement30 = nil
  self.title30 = nil
  self.desc30 = nil
  self.achievement31 = nil
  self.title31 = nil
  self.desc31 = nil
  self.rank_root = nil
  self.btn_rank = nil
  self.no_main_task_text = nil
  self.content:RemoveComponents(UILWSeasonVirusTaskItem)
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UILWSeasonVirusTaskGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAchievementInfo, self.UpdateAchievementData)
end

function UILWSeasonVirusTaskGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.GetAchievementInfo, self.UpdateAchievementData)
  base.OnRemoveListener(self)
end

function UILWSeasonVirusTaskGroup:UpdateAchievementData(dataList)
  if dataList then
    local InfectedVirus = 29
    local HelpAlliesDetoxify = 30
    local SpreadVirus = 31
    for _, v in pairs(dataList) do
      if v.type == InfectedVirus then
        self.Achievement_InfectedVirus = v
      elseif v.type == HelpAlliesDetoxify then
        self.Achievement_HelpAlliesDetoxify = v
      elseif v.type == SpreadVirus then
        self.Achievement_SpreadVirus = v
      end
    end
  end
  self:UpdateTasks()
end

function UILWSeasonVirusTaskGroup:DoRefresh()
  self:UpdateTasks()
end

function UILWSeasonVirusTaskGroup:ShowEmpty()
  if self.seasonVersion <= 0 then
    self.no_main_task_text:SetActive(true)
    self.achievement29:SetActive(false)
    self.achievement30:SetActive(false)
    self.achievement31:SetActive(false)
    self.rank_root:SetActive(false)
  else
    self:ShowAchievement()
  end
end

function UILWSeasonVirusTaskGroup:ShowAchievement(node1, node2, node3)
  if self.seasonVersion > 0 then
    self.achievement29:SetActive(node1 == nil and self.Achievement_InfectedVirus ~= nil)
    self.achievement30:SetActive(node2 == nil and self.Achievement_HelpAlliesDetoxify ~= nil)
    self.achievement31:SetActive(node3 == nil and self.Achievement_SpreadVirus ~= nil)
    if node1 == nil and self.Achievement_InfectedVirus ~= nil then
      self.title29:SetLocalText("season_quest_desc_601020", toInt(self.Achievement_InfectedVirus.num))
      self.achievement29:SetAsLastSibling()
    elseif node1 ~= nil then
      node1:SetAsLastSibling()
    end
    if node2 == nil and self.Achievement_HelpAlliesDetoxify ~= nil then
      self.title30:SetLocalText("season_quest_desc_601021", toInt(self.Achievement_HelpAlliesDetoxify.num))
      self.achievement30:SetAsLastSibling()
    elseif node2 ~= nil then
      node2:SetAsLastSibling()
    end
    if node3 == nil and self.Achievement_SpreadVirus ~= nil then
      self.title31:SetLocalText("season_quest_desc_601022", toInt(self.Achievement_SpreadVirus.num))
      self.achievement31:SetAsLastSibling()
    elseif node3 ~= nil then
      node3:SetAsLastSibling()
    end
  else
    self.achievement29:SetActive(false)
    self.achievement30:SetActive(false)
    self.achievement31:SetActive(false)
  end
end

function UILWSeasonVirusTaskGroup:UpdateTasks()
  local list = DataCenter.TaskManager:GetSeasonVirusTask()
  if list == nil then
    self:ShowEmpty()
    return
  end
  if #list == 0 then
    self:ShowEmpty()
    return
  end
  table.sort(list, function(a, b)
    return a.list < b.list
  end)
  self.content:RemoveComponents(UILWSeasonVirusTaskItem)
  self.theItem:GameObjectRecycleAll()
  self.no_main_task_text:SetActive(false)
  local goItem, theItem
  local taskList = {}
  local node1, node2, node3
  for i, task in ipairs(list) do
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "task_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
    theItem = self.content:AddComponent(UILWSeasonVirusTaskItem, goItem.name)
    theItem:ReInit(task, self.seasonVersion)
    table.insert(taskList, theItem)
    if task.list == 1020 then
      node1 = theItem
    elseif task.list == 1021 then
      node2 = theItem
    elseif task.list == 1022 then
      node3 = theItem
    end
  end
  self.taskList = taskList
  self:ShowAchievement(node1, node2, node3)
end

function UILWSeasonVirusTaskGroup:OnReceiveQuestReward()
  if self.taskList then
    local clickPosData = {}
    for _, task in ipairs(self.taskList) do
      if task then
        local result = task:OnReceiveQuestReward()
        if result ~= true and result ~= nil then
          for k, v in pairs(result) do
            clickPosData[k] = v
          end
        end
      end
    end
    for k, data in pairs(clickPosData) do
      if data and data.lastState == TaskState.CanReceive and data.taskInfo and data.rewardPos and data.taskInfo.rewardList then
        data.lastState = TaskState.Received
        local rewardPos = data.rewardPos
        for i, v in ipairs(data.taskInfo.rewardList) do
          local rewardType = v.rewardType
          local itemId = v.itemId
          local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
          if not string.IsNullOrEmpty(pic) then
            local endPos = Vector3.New(0, 0, 0)
            local resourceType = RewardToResType[rewardType]
            if resourceType then
              endPos = UIUtil.GetResourcePos(resourceType)
            end
            UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, endPos, nil, nil, nil, nil, 1)
          end
        end
      end
    end
  end
  self:UpdateTasks()
end

return UILWSeasonVirusTaskGroup
