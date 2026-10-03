local Season3LastWarItem = BaseClass("Season3LastWarItem", UIBaseContainer)
local base = UIBaseContainer
local lastTaskData
local finish_path = "main/finish"
local icon_finish_path = "main/finish/bg/icon_finish"
local normal_path = "main/normal"
local icon_normal_path = "main/normal/bg/icon_normal"
local content_path = "main/content"
local task_title_path = "main/content/info/task_title"
local task_desc_path = "main/content/info/task_desc"
local goto_btn_path = "main/content/gotoBtn"
local gift_root_path = "main/content/giftBtn"
local box_open_path = "main/content/giftBtn/boxOpen"
local flow_open_path = "main/content/giftBtn/flowOpen"
local active_path = "main/content/giftBtn/active"
local box_path = "main/content/giftBtn/box"
local lock_path = "main/lock"

function Season3LastWarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function Season3LastWarItem:ComponentDefine()
  self.finish = self:AddComponent(UIImage, finish_path)
  self.icon_finish = self:AddComponent(UIImage, icon_finish_path)
  self.normal = self:AddComponent(UIImage, normal_path)
  self.icon_normal = self:AddComponent(UIImage, icon_normal_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.task_title = self:AddComponent(UITextMeshProUGUIEx, task_title_path)
  self.task_desc = self:AddComponent(UITextMeshProUGUIEx, task_desc_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.gift_root = self:AddComponent(UIBaseContainer, gift_root_path)
  self.box_open = self:AddComponent(UIImage, box_open_path)
  self.boxClick = self:AddComponent(UIBaseContainer, flow_open_path)
  self.boxLight = self:AddComponent(UIBaseContainer, active_path)
  self.box = self:AddComponent(UIButton, box_path)
  self.goto_btn:SetOnClick(function()
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local enemyServer = DataCenter.ZoneWarManager:GetMyEnemyServerNow(myServerId)
    if myServerId == 112 and CS.CommonUtils.IsDebug() then
      enemyServer = myServerId
    end
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(601, enemyServer)
    if cityTemplate ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = cityTemplate:GetPointId(),
        server = enemyServer,
        worldId = 0
      })
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
  self.box:SetOnClick(function()
    if self.taskInfo then
      if self.taskInfo.state == TaskState.NoComplete then
        self:OnRewardShowClick()
      elseif self.taskInfo.state == TaskState.CanReceive and self.taskId and self.activityId then
        self.boxClick:SetActive(true)
        SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityReward, self.activityId, self.taskId)
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
      elseif self.taskInfo.state == TaskState.Received then
      else
        UIUtil.ShowTipsId("avatar_tips006")
      end
    end
  end)
  self.boxLight:SetActive(false)
  self.boxClick:SetActive(false)
end

function Season3LastWarItem:OnDestroy()
  self.finish = nil
  self.icon_finish = nil
  self.normal = nil
  self.icon_normal = nil
  self.content = nil
  self.task_title = nil
  self.task_desc = nil
  self.goto_btn = nil
  self.gift_root = nil
  self.box_open = nil
  self.boxClick = nil
  self.boxLight = nil
  self.box = nil
  self.lockCanvas = nil
  base.OnDestroy(self)
end

function Season3LastWarItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EveDecisiveBattleInfo, self.OnReceiveQuestInfo)
  self:AddUIListener(EventId.EveDecisiveBattleReward, self.OnReceiveQuestReward)
end

function Season3LastWarItem:OnRemoveListener()
  self:RemoveUIListener(EventId.EveDecisiveBattleInfo, self.OnReceiveQuestInfo)
  self:RemoveUIListener(EventId.EveDecisiveBattleReward, self.OnReceiveQuestReward)
  base.OnRemoveListener(self)
end

function Season3LastWarItem:SetData(view, data, iconPath)
  self.data = data
  self.viewCtrl = view
  self.iconPath = iconPath
  self.activityId = self.viewCtrl.activityId
  if string.IsNullOrEmpty(data) then
    self:SetActive(false)
  else
    self:SetActive(true)
    self:RefreshUI(data, iconPath)
  end
end

function Season3LastWarItem:OpenIt()
end

function Season3LastWarItem:RefreshUI(data, iconPath)
  self.content:SetActive(true)
  if iconPath then
    self.icon_finish:LoadSprite(iconPath)
    self.icon_normal:LoadSprite(iconPath)
  end
  if data == "Jump" then
    self.finish:SetActive(false)
    self.normal:SetActive(true)
    self.goto_btn:SetActive(true)
    self.gift_root:SetActive(false)
    self.task_title:SetLocalText("season_s3_cityname_activity_show")
    self.task_desc:SetLocalText("season_s3_citydesc_activity_show")
  else
    local intData = toInt(data)
    local statusData = LocalController:instance():tryGetLine(TableName.StatusTab, intData)
    if statusData then
      self.finish:SetActive(false)
      self.normal:SetActive(true)
      self.goto_btn:SetActive(false)
      self.gift_root:SetActive(false)
      self.task_title:SetLocalText(statusData.name)
      self.task_desc:SetLocalText(statusData.description)
    else
      local task_type = self.viewCtrl.activityData.task_type
      local taskList = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplateByType(task_type)
      if table.count(taskList) > 0 then
        local taskData = taskList[1]
        self.finish:SetActive(true)
        self.normal:SetActive(false)
        self.goto_btn:SetActive(false)
        self.gift_root:SetActive(true)
        self.taskId = taskData.id
        self.taskData = taskData
        self.taskNumMax = toInt(taskData.para2)
        self.task_title:SetLocalText(taskData.name)
        self.task_desc:SetLocalText(taskData.desc, 0 .. "/" .. self.taskNumMax)
        self:OnUpdateTask()
        SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
      else
        self.data = nil
        self.viewCtrl = nil
        self.iconPath = nil
        self:SetActive(false)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

function Season3LastWarItem:OnUpdateTask()
  local taskInfo = lastTaskData
  if taskInfo ~= nil then
    if taskInfo.state == TaskState.NoComplete then
      self.box:SetActive(true)
      self.box_open:SetActive(false)
      self.boxLight:SetActive(false)
      self.boxClick:SetActive(false)
    elseif taskInfo.state == TaskState.CanReceive then
      self.box:SetActive(true)
      self.box_open:SetActive(false)
      self.boxLight:SetActive(true)
      self.boxClick:SetActive(false)
    elseif taskInfo.state == TaskState.Received then
      self.box:SetActive(false)
      self.box_open:SetActive(true)
    end
    self.lastState = taskInfo.state
    self.taskInfo = taskInfo
    if self.taskData then
      self.task_desc:SetLocalText(self.taskData.desc, toInt(self.taskInfo.num) .. "/" .. self.taskNumMax)
    end
  end
end

function Season3LastWarItem:OnReceiveQuestInfo(taskInfo)
  lastTaskData = taskInfo
  if self.taskInfo ~= nil and self.lastState ~= nil and taskInfo and self.lastState ~= taskInfo.state and taskInfo.state == TaskState.Received then
    self.taskInfo = taskInfo
    self:OnReceiveQuestReward()
  else
    self:OnUpdateTask()
  end
end

function Season3LastWarItem:OnReceiveQuestReward()
  if self.taskInfo and self.taskInfo.state == TaskState.Received and self.lastState ~= self.taskInfo.state then
    self.box:SetActive(false)
    self.box_open:SetActive(true)
    self.boxLight:SetActive(false)
    self.boxClick:SetActive(false)
    self.lastState = self.taskInfo.state
    if self.taskData then
      self.task_desc:SetLocalText(self.taskData.desc, toInt(self.taskInfo.num) .. "/" .. self.taskNumMax)
    end
  end
end

function Season3LastWarItem:OnRewardShowClick()
  if ComponentIsValid(self.box) then
    UIUtil.ShowLootRewardList(self.box:GetPosition(), self.taskInfo.reward, 0)
  end
end

return Season3LastWarItem
