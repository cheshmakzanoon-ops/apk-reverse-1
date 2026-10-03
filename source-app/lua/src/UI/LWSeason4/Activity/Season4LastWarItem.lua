local Season4LastWarItem = BaseClass("Season4LastWarItem", UIBaseContainer)
local base = UIBaseContainer
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

function Season4LastWarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function Season4LastWarItem:ComponentDefine()
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

function Season4LastWarItem:OnDestroy()
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

function Season4LastWarItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EveDecisiveBattleInfo, self.RefreshTask)
  self:AddUIListener(EventId.EveDecisiveBattleReward, self.RefreshTask)
end

function Season4LastWarItem:OnRemoveListener()
  self:RemoveUIListener(EventId.EveDecisiveBattleInfo, self.RefreshTask)
  self:RemoveUIListener(EventId.EveDecisiveBattleReward, self.RefreshTask)
  base.OnRemoveListener(self)
end

function Season4LastWarItem:SetData(view, dataType, data, iconPath)
  self.dataType = dataType
  self.data = data
  self.viewCtrl = view
  self.iconPath = iconPath
  self.activityId = self.viewCtrl.activityId
  if string.IsNullOrEmpty(data) then
    self:SetActive(false)
  else
    self:SetActive(true)
    self:RefreshUI()
  end
end

function Season4LastWarItem:OpenIt()
end

function Season4LastWarItem:RefreshUI()
  self.content:SetActive(true)
  if self.dataType == 3 then
    self.finish:SetActive(false)
    self.normal:SetActive(true)
    self.goto_btn:SetActive(true)
    self.gift_root:SetActive(false)
    self.task_title:SetLocalText("season_s3_cityname_activity_show")
    self.task_desc:SetLocalText("season_s3_citydesc_activity_show")
  elseif self.dataType == 2 then
    local statusData = LocalController:instance():tryGetLine(TableName.StatusTab, toInt(self.data))
    if statusData then
      self.finish:SetActive(false)
      self.normal:SetActive(true)
      self.goto_btn:SetActive(false)
      self.gift_root:SetActive(false)
      self.task_title:SetLocalText(statusData.name)
      self.task_desc:SetLocalText(statusData.description)
      if not string.IsNullOrEmpty(statusData.icon) then
        self.icon_finish:LoadSprite(statusData.icon)
        self.icon_normal:LoadSprite(statusData.icon)
      end
    end
  elseif self.dataType == 1 then
    local taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(toInt(self.data))
    if taskTemplate then
      self.finish:SetActive(true)
      self.normal:SetActive(false)
      self.goto_btn:SetActive(false)
      self.gift_root:SetActive(true)
      self.taskId = taskTemplate.id
      self.taskTemplate = taskTemplate
      self.taskNumMax = toInt(taskTemplate.para2)
      self.task_title:SetLocalText(taskTemplate.name)
      self.task_desc:SetLocalText(taskTemplate.desc, 0 .. "/" .. self.taskNumMax)
      self.icon_finish:LoadSprite(taskTemplate:GetIconPath())
      self.icon_normal:LoadSprite(taskTemplate:GetIconPath())
      self:RefreshTask()
    else
      self.data = nil
      self.viewCtrl = nil
      self.iconPath = nil
      self:SetActive(false)
    end
  end
  if self.iconPath then
    self.icon_finish:LoadSprite(self.iconPath)
    self.icon_normal:LoadSprite(self.iconPath)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

function Season4LastWarItem:GetTaskData()
  local tasks = DataCenter.ActivityListDataManager:GetExtraData(EVE_DECISIVE_BATTLE_TASK)
  if tasks then
    for i, task in pairs(tasks) do
      if toInt(task.id) == self.taskId then
        return task
      end
    end
  end
end

function Season4LastWarItem:RefreshTask()
  if self.dataType ~= 1 then
    return
  end
  local taskInfo = self:GetTaskData()
  if taskInfo then
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
      self.boxLight:SetActive(false)
      self.boxClick:SetActive(false)
    end
    self.taskInfo = taskInfo
    if self.taskTemplate then
      self.task_desc:SetLocalText(self.taskTemplate.desc, toInt(self.taskInfo.num) .. "/" .. self.taskNumMax)
    end
  end
end

function Season4LastWarItem:OnRewardShowClick()
  if ComponentIsValid(self.box) then
    UIUtil.ShowLootRewardList(self.box:GetPosition(), self.taskInfo.reward, 0)
  end
end

return Season4LastWarItem
