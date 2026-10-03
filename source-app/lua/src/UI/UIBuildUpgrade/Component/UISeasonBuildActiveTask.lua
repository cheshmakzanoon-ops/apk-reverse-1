local base = UIAsyncContainer
local UISeasonBuildActiveTask = BaseClass("UISeasonBuildActiveTask", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Item/Status/bg"
local icon_path = "Item/Status/bg/icon"
local task_title_path = "Item/Status/task_title"
local task_desc_path = "Item/Status/task_desc"
local task_num_path = "Item/Status/task_desc/task_num"
local goto_btn_path = "Item/Status/gotoBtn"
local start_btn_path = "Item/Status/startBtn"
local task_finish_path = "Item/Status/task_finish"
local info_btn_path = "Item/InfoBtn"
local info_text_path = "Item/InfoText"
local eff_ui_build_task_fx01_path = "Item/Eff_ui_BuildTask_fx01"
local eff_ui_build_task_fx02_path = "Eff_ui_BuildTask_fx02"

function UISeasonBuildActiveTask:OnCreate()
  base.OnCreate(self)
  self.eff_ui_build_task_fx01 = self:AddComponent(UIBaseContainer, eff_ui_build_task_fx01_path)
  self.eff_ui_build_task_fx02 = self:AddComponent(UIBaseContainer, eff_ui_build_task_fx02_path)
  self.bgQuality = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIButton, icon_path)
  self.task_title = self:AddComponent(UITextMeshProUGUIEx, task_title_path)
  self.task_desc = self:AddComponent(UITextMeshProUGUIEx, task_desc_path)
  self.task_num = self:AddComponent(UITextMeshProUGUIEx, task_num_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.start_btn = self:AddComponent(UIButton, start_btn_path)
  self.task_finish = self:AddComponent(UITextMeshProUGUIEx, task_finish_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_text = self:AddComponent(UITextMeshProUGUIEx, info_text_path)
  self.goto_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.start_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.icon:SetOnClick(function()
    local param = {}
    param.type = "nameDesc"
    param.title = Localization:GetString("season_s4_building_ui_info25")
    param.desc = Localization:GetString("season_s4_building_ui_info26")
    param.isLocal = true
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.info_btn:SetOnClick(function()
    local title = "season_s4_building_ui_info25"
    local msg = Localization:GetString("season_s4_catch_zombie_info")
    UIUtil.ShowDetail(msg, title, nil, true, true)
  end)
end

function UISeasonBuildActiveTask:OnDestroy()
  self.bgQuality = nil
  self.icon = nil
  self.task_title = nil
  self.task_desc = nil
  self.task_num = nil
  self.goto_btn = nil
  self.start_btn = nil
  self.task_finish = nil
  self.info_btn = nil
  self.info_text = nil
  self.eff_ui_build_task_fx01 = nil
  self.eff_ui_build_task_fx02 = nil
  base.OnDestroy(self)
end

function UISeasonBuildActiveTask:OnBtnClick()
  if self.taskInfo then
    local task_state = self.taskInfo.state
    if task_state == TaskState.CanReceive then
      SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
        id = self.taskInfo.id
      })
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
      return
    elseif task_state == TaskState.Received then
      UIUtil.ShowTipsId("season_s2_ice_supplies_23")
      self:UpdateData()
      return
    end
    DataCenter.ChapterTaskManager:QuestGoto(self.taskInfo)
    return
  end
  UIUtil.ShowTipsId("bingo_task_desc3")
end

function UISeasonBuildActiveTask:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:AddUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
end

function UISeasonBuildActiveTask:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
  base.OnRemoveListener(self)
end

function UISeasonBuildActiveTask:SetData(buildId, buildUuid)
  if buildId == nil or buildId == 0 or buildId == "" then
    return
  end
  self.buildId = buildId
  self.buildUuid = buildUuid
  self.lastState = nil
  self:UpdateData()
end

function UISeasonBuildActiveTask:UpdateData()
  if self.buildId and IsNotNull(self.gameObject) then
    local dataList = DataCenter.SeasonPowerWorkerManager:GetPowerBuildInfo()
    local data = dataList[self.buildId]
    local taskInfo = self.taskInfo
    if taskInfo == nil then
      taskInfo = data.taskInfo
      self.taskInfo = taskInfo
    end
    if taskInfo ~= nil then
      self.lastState = self.taskInfo.state
    end
    if taskInfo == nil or self.lastState == TaskState.Received then
      if self.lastState == TaskState.Received or data.formation ~= nil or data.worker ~= nil then
        self.info_text:SetLocalText("season_s4_building_ui_info31")
        self.task_finish:SetLocalText("season_s4_building_ui_info29")
        self.eff_ui_build_task_fx01:SetActive(true)
        self.eff_ui_build_task_fx02:SetActive(true)
      else
        self.info_text:SetLocalText("season_s4_catch_zombie01")
        if self.buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 then
          self.task_finish:SetLocalText("season_s4_building_ui_info26")
        else
          self.task_finish:SetLocalText("season_s4_catch_zombie02")
        end
        self.eff_ui_build_task_fx01:SetActive(false)
        self.eff_ui_build_task_fx02:SetActive(false)
      end
      self.task_title:SetActive(false)
      self.task_desc:SetActive(false)
      self.goto_btn:SetActive(false)
      self.start_btn:SetActive(false)
      self.task_finish:SetActive(true)
    else
      local need, max, meta = taskInfo:GetTaskProgress()
      if need and max then
        if self.lastState == TaskState.NoComplete then
          self.task_num:SetText(string.format("<color=#F97077>%s</color>/%s", need, max))
        else
          self.task_num:SetText(string.format("<color=#5fef87>%s</color>/%s", need, max))
        end
      end
      self.task_title:SetActive(true)
      self.task_desc:SetActive(true)
      self.goto_btn:SetActive(self.lastState == TaskState.NoComplete)
      self.start_btn:SetActive(self.lastState == TaskState.CanReceive)
      self.task_finish:SetActive(false)
      self.task_title:SetLocalText("season_s4_building_ui_info25")
      self.info_text:SetLocalText("season_s4_building_ui_info30")
      self.eff_ui_build_task_fx01:SetActive(false)
      self.eff_ui_build_task_fx02:SetActive(false)
    end
  end
end

function UISeasonBuildActiveTask:OnReceiveQuestReward()
  if self.taskInfo and self.taskInfo.state == TaskState.Received and self.lastState ~= self.taskInfo.state then
    self.lastState = self.taskInfo.state
    self:UpdateData()
    if self.buildUuid ~= nil then
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, self.buildUuid)
    end
  end
end

return UISeasonBuildActiveTask
