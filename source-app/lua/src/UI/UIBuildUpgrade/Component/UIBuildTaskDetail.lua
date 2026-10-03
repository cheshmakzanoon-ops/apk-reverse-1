local base = UIAsyncContainer
local UIBuildTaskDetail = BaseClass("UIBuildTaskDetail", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local banner_path = "Item/banner"
local bg_path = "Item/Status/bg"
local icon_path = "Item/Status/bg/icon"
local task_title_path = "Item/Status/task_title"
local task_desc_path = "Item/Status/task_desc"
local goto_btn_path = "Item/Status/gotoBtn"
local start_btn_path = "Item/Status/startBtn"
local info_btn_path = "Item/InfoBtn"
local info_text_path = "Item/InfoText"
local btn_des_path = "Item/Status/gotoBtn/BtnDes"
local btn_finish_path = "Item/Status/startBtn/BtnFinish"

function UIBuildTaskDetail:OnCreate()
  base.OnCreate(self)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.bgQuality = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIButton, icon_path)
  self.task_title = self:AddComponent(UITextMeshProUGUIEx, task_title_path)
  self.task_desc = self:AddComponent(UITextMeshProUGUIEx, task_desc_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.start_btn = self:AddComponent(UIButton, start_btn_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_text = self:AddComponent(UITextMeshProUGUIEx, info_text_path)
  self.btn_des = self:AddComponent(UITextMeshProUGUIEx, btn_des_path)
  self.btn_finish = self:AddComponent(UITextMeshProUGUIEx, btn_finish_path)
  self.goto_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.start_btn:SetOnClick(function()
    local meta = self.questTemplate
    if self.taskInfo then
      SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
        id = self.taskInfo.id
      })
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    elseif self.lastState == TaskState.CanReceive then
      if meta then
        local taskId = meta:GetPreQuestId()
        if taskId == nil then
          UIUtil.ShowTipsId("avatar_tips006")
          return
        end
        Logger.Log("pre task id is " .. taskId)
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
        if questTemplate == nil then
          UIUtil.ShowTipsId("avatar_tips006")
          return
        end
        local buildData
        local buildId = toInt(questTemplate.accept2)
        local buildLevel = buildId % 1000
        local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildId - buildLevel)
        if dataList and 0 < #dataList and dataList[1] then
          buildData = dataList[1]
        end
        if buildData ~= nil and buildData.uuid ~= nil then
          Logger.Log("pre build id is " .. buildData.itemId)
          GoToUtil.GotoCityByBuildUuid(buildData.uuid, WorldTileBtnType.City_Upgrade)
        end
      end
    else
      if meta ~= nil then
        GoToUtil.CloseAllWindows()
        GoToUtil.GoToByQuestId(meta)
        return
      end
      UIUtil.ShowTipsId("bingo_task_desc3")
    end
  end)
  self.icon:SetOnClick(function()
    local param = {}
    param.type = "nameDesc"
    param.title = Localization:GetString("season_virus_name")
    param.desc = Localization:GetString("season_activity_story_desc004")
    param.isLocal = true
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.info_btn:SetOnClick(function()
    local taskHowToPlayId = 101003
    local meta = self.questTemplate
    if meta and meta.taskHowToPlayId ~= nil then
      taskHowToPlayId = toInt(meta.taskHowToPlayId)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {taskHowToPlayId}
    })
  end)
end

function UIBuildTaskDetail:OnDestroy()
  self.banner = nil
  self.bgQuality = nil
  self.icon = nil
  self.task_title = nil
  self.task_desc = nil
  self.goto_btn = nil
  self.start_btn = nil
  self.info_btn = nil
  self.info_text = nil
  self.btn_des = nil
  self.btn_finish = nil
  base.OnDestroy(self)
end

function UIBuildTaskDetail:OnBtnClick()
  local meta = self.questTemplate
  if self.taskInfo then
    local task_state = self.taskInfo.state
    if task_state == TaskState.CanReceive then
      SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
        id = self.taskInfo.id
      })
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
      return
    end
    if task_state == TaskState.Received then
      UIUtil.ShowTipsId("season_s2_ice_supplies_23")
      self:SetActive(false)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, self.buildUuid)
      return
    end
    if meta ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.GoToByQuestId(meta)
      return
    end
    DataCenter.ChapterTaskManager:QuestGoto(self.taskInfo)
    return
  else
    UIUtil.ShowTipsId("2000012")
    return
  end
  if meta ~= nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByQuestId(meta)
    return
  end
  UIUtil.ShowTipsId("bingo_task_desc3")
end

function UIBuildTaskDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAchievementInfo, self.OnAchievementInfo)
  self:AddUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:AddUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
end

function UIBuildTaskDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.GetAchievementInfo, self.OnAchievementInfo)
  self:RemoveUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
  base.OnRemoveListener(self)
end

function UIBuildTaskDetail:OnAchievementInfo()
  local dataList = DataCenter.SeasonDataManager.theUserAchievementInfo
  if dataList then
    for _, v in pairs(dataList) do
      if v.type == 29 then
        self.InfectedVirus = toInt(v.num)
        self:UpdateData()
        return
      end
    end
  end
  self:UpdateData()
end

function UIBuildTaskDetail:SetData(buildId, buildUuid, taskInfo, questTemplate)
  if buildId == nil or buildId == 0 or buildId == "" then
    return
  end
  self.InfectedVirus = 100
  self.buildId = buildId
  self.buildUuid = buildUuid
  self.taskInfo = taskInfo
  if taskInfo ~= nil then
    self.lastState = taskInfo.state
  else
    self.questTemplate = questTemplate
    self.lastState = nil
  end
  self:UpdateData()
end

function UIBuildTaskDetail:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local seasonType = SeasonUtil.GetSeasonType()
  local meta = self.questTemplate
  local taskInfo = self.taskInfo
  self.btn_des:SetLocalText("110003")
  self.btn_finish:SetLocalText("s1_building_quest_btn01")
  if self.buildId and taskInfo ~= nil then
    local need, max, meta2 = taskInfo:GetTaskProgress()
    meta = meta2
    if need and max then
      if self.lastState == TaskState.NoComplete then
        self.strTips = Localization:GetString(meta.desc, string.format("<color=#F97077>%s</color>/%s", need, max))
      else
        self.strTips = Localization:GetString(meta.desc, string.format("<color=#00A62E>%s</color>/%s", need, max))
      end
    end
    self.questTemplate = meta
    self.taskMeta = meta
    self.lastState = self.taskInfo.state
  elseif taskInfo == nil and self.questTemplate ~= nil then
    local max = toInt(meta.para2)
    local need = 0
    self.strTips = Localization:GetString(meta.desc, string.format("<color=#F97077>%s</color>/%s", need, max))
    self.lastState = TaskState.NoComplete
    UIGray.SetGray(self.goto_btn.transform, true, true)
  end
  if meta then
    Logger.Log("task id is " .. meta.id)
    self.task_desc:SetText(self.strTips or "")
    self.goto_btn:SetActive(self.lastState == TaskState.NoComplete)
    self.start_btn:SetActive(self.lastState == TaskState.CanReceive)
    self.task_title:SetLocalText(meta.name)
    self.info_text:SetText("")
    self.info_btn:SetActive(seasonType == SeasonMapType.CityStronghold or toInt(meta.taskHowToPlayId) ~= 0)
    if self.lastState == TaskState.CanReceive and meta.taskFinishBtnTxt ~= nil and meta.taskFinishBtnTxt ~= "" then
      self.btn_finish:SetLocalText(meta.taskFinishBtnTxt)
    end
    if not string.IsNullOrEmpty(meta.banner) then
      self.banner:LoadSprite(meta.banner)
    end
    if not string.IsNullOrEmpty(meta.icon) then
      self.icon:LoadSprite(meta.icon)
    end
  end
end

function UIBuildTaskDetail:OnReceiveQuestReward()
  if self.taskInfo and self.taskInfo.state == TaskState.Received then
    self.lastState = self.taskInfo.state
    self:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, self.buildUuid)
  end
end

return UIBuildTaskDetail
