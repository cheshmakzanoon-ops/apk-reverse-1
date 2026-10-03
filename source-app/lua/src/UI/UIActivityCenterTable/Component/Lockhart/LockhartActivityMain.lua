local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LockhartActivityMain = BaseClass("LockhartActivityMain", base)
local Localization = CS.GameEntry.Localization
local taskId = "2400000"

function LockhartActivityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LockhartActivityMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local bg_rawImage_path = "Root/Node_bg/Mask/Banner"
local icon_rawImage_path = "Root/Node_bg/img_hero_show"
local title_path = "Root/Node_top/top_title/TitleGroup/TitleText"
local info_btn_path = "Root/Node_top/top_title/TitleGroup/IntroBtn"
local remain_time_path = "Root/Node_top/top_title/TimeGroup/TimeBG/TimeText"
local sub_title_path = "Root/Node_top/top_title/DescText"
local gift_btn_path = "Root/Node_top/btn_right_funtion/btn_gift"
local hero_btn_path = "Root/Node_top/btn_right_funtion/btn_playepreview"
local toggle_root_path = "Root/Node_task/Toggle_show_info"
local show_toggle_path = "Root/Node_task/Toggle_show_info/Toggle"
local toggle_text_path = "Root/Node_task/Toggle_show_info/txt_info"
local task_desc_path = "Root/Node_task/task/txt_task"
local btn_one_get_path = "Root/Node_task/task/btn_claim"
local txt_one_get_path = "Root/Node_task/task/btn_claim/txt_claim"
local red_point_path = "Root/Node_task/task/btn_claim/RedPoint"
local received_reward_path = "Root/Node_task/task/txt_received_tip"
local reward_scroll_path = "Root/Node_task/task/RewardScrollView"
local reward_content_path = "Root/Node_task/task/RewardScrollView/Viewport/Content"
local btn_go_path = "Root/Node_btn/btn_go"
local go_text_path = "Root/Node_btn/btn_go/Content/txt_btn_go"

function LockhartActivityMain:ComponentDefine()
  self.bg_rawImage = self:AddComponent(UIRawImage, bg_rawImage_path)
  self.icon_rawImage = self:AddComponent(UIRawImage, icon_rawImage_path)
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.hero_btn = self:AddComponent(UIButton, hero_btn_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.toggle_content = self:AddComponent(UIBaseComponent, toggle_root_path)
  self.toggle_show_entry = self:AddComponent(UIToggle, show_toggle_path)
  self.text_toggle_show = self:AddComponent(UIText, toggle_text_path)
  self.task_desc = self:AddComponent(UIText, task_desc_path)
  self.btn_one_get = self:AddComponent(UIButton, btn_one_get_path)
  self.txt_one_get = self:AddComponent(UIText, txt_one_get_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.text_received_reward = self:AddComponent(UIText, received_reward_path)
  self.reward_scrollView = self:AddComponent(UIScrollView, reward_scroll_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.hero_btn:SetOnClick(function()
    self:OnHeroBtnClick()
  end)
  self.info_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.btn_one_get:SetOnClick(function()
    self:OnTaskBtnClick()
  end)
  self.gift_btn:SetOnClick(function()
    self:OnShowGiftBtnClick()
  end)
  self.btn_go:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.toggle_show_entry:SetOnValueChanged(function(state)
    self:OnSelectShowEntryToggle()
  end)
  self.itemDic = {}
  self.reward_scrollView:SetOnItemMoveIn(function(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.reward_scrollView:AddComponent(UICommonResItem, itemObj)
    local cfg = self.rewardList[index]
    if cellItem and cfg then
      cellItem:SetActive(true)
      cellItem:ReInit({
        count = cfg.count,
        rewardType = RewardType.GOODS,
        itemId = cfg.itemId
      })
      local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
      if taskInfo and taskInfo.state == TaskState.Received then
        cellItem:SetReceflagActive(true)
      else
        cellItem:SetReceflagActive(false)
      end
      self.itemDic[index] = cellItem
    else
      cellItem:SetActive(false)
    end
  end)
  self.reward_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self.reward_scrollView:RemoveComponent(itemObj.name, UICommonResItem)
    self.itemDic[index] = nil
  end)
end

function LockhartActivityMain:ComponentDestroy()
  self.bg_rawImage = nil
  self.icon_rawImage = nil
  self.title = nil
  self.sub_title = nil
  self.info_btn = nil
  self.hero_btn = nil
  self.remain_time = nil
  self.toggle_show_entry = nil
  self.text_toggle_show = nil
  self.task_desc = nil
  self.btn_one_get = nil
  self.txt_one_get = nil
  self.red_point = nil
  self.reward_scrollView = nil
  self.reward_content = nil
  self.gift_btn = nil
  self.btn_go = nil
  self.go_text = nil
end

function LockhartActivityMain:ClearScroll()
  self.reward_scrollView:ClearCells()
  self.reward_scrollView:RemoveComponents(UICommonResItem)
  self.itemDic = {}
end

function LockhartActivityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.OnUpdateTask)
end

function LockhartActivityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskSuccess, self.OnUpdateTask)
  base.OnRemoveListener(self)
end

function LockhartActivityMain:OnUpdateTask()
  self:RefreshUI()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LockhartActivityMain:OnSelectShowEntryToggle()
  local curSelect = DataCenter.LWActivityLockhartManager:IsShowLockHartEntry()
  CommonUtil.PlayerPrefsSetBool("LockhartActivity_ShowEntry", not curSelect)
  CommonUtil.PlayerPrefsSetLong("LockhartActivity_ShowEntryTime", self.activityData.endTime)
  self.toggle_show_entry:SetIsOnWithoutNotify(not curSelect)
  EventManager:GetInstance():Broadcast(EventId.Al_LockHartActivityTip)
end

function LockhartActivityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.bannerTittle)
  self.sub_title:SetLocalText(self.activityData.desc_info)
  self.go_text:SetLocalText(self.activityData.para_2)
  self.text_toggle_show:SetLocalText("activity_luoha_desc_shortcut")
  self.text_received_reward:SetLocalText(170003)
  if not string.IsNullOrEmpty(self.activityData.activity_pic_full) then
    self.bg_rawImage:LoadSpriteAuto(self.activityData.activity_pic_full)
  elseif not string.IsNullOrEmpty(self.activityData.activity_pic) then
    local picPath = string.format(UIAssets.UILockhartTexturePath, self.activityData.activity_pic)
    self.bg_rawImage:LoadSpriteAuto(picPath)
  end
  if not string.IsNullOrEmpty(self.activityData.para_4) then
    local function callback()
      if self.icon_rawImage then
        self.icon_rawImage:SetNativeSize()
      end
    end
    
    self.icon_rawImage:LoadSpriteAuto(self.activityData.para_4, callback)
  end
  self:RefreshUI()
  CS.GameEntry.Setting:SetBool("OpenedLockhartActivity_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LockhartActivityMain:RefreshUI()
  self.red_point:SetActive(false)
  local mgr = DataCenter.ActivityListDataManager
  if self.activityData.tableInfo == TableName.Activity_Stage then
    local stageTemplate = DataCenter.ActivityStageTemplateManager:GetTemplateByStageType(self.activityData.subType)
    if stageTemplate then
      local quests = stageTemplate:GetQuests()
      if not table.IsNullOrEmpty(quests) then
        taskId = quests[1]
      end
    end
  end
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
  if taskInfo ~= nil then
    local metaQuest = DataCenter.QuestTemplateManager:GetQuestTemplate(taskInfo.id)
    local maxCount = metaQuest.para2 or 20
    local desc = metaQuest.desc or "2010113"
    self.rewardList = taskInfo.rewardList
    if self.rewardList ~= nil and #self.rewardList > 0 then
      self.reward_scrollView:SetActive(true)
      self.reward_scrollView:SetTotalCount(#self.rewardList)
      self.reward_scrollView:RefillCells()
    else
      self.reward_scrollView:SetActive(false)
    end
    self.taskData = taskInfo
    if taskInfo.state == TaskState.NoComplete then
      self.toggle_content:SetActive(false)
      self.txt_one_get:SetLocalText("170004")
      CS.UIGray.SetGray(self.btn_one_get.transform, true, false)
      self.btn_one_get:SetActive(true)
      self.text_received_reward:SetActive(false)
      if CommonUtil.IsArabic() then
        self.task_desc:SetLocalText(desc, "<color=#f53c3d>" .. taskInfo.num, maxCount .. "</color>")
      else
        self.task_desc:SetLocalText(desc, "<color=#f53c3d>" .. taskInfo.num .. "</color>", maxCount)
      end
    elseif taskInfo.state == TaskState.CanReceive then
      self.toggle_content:SetActive(false)
      self.txt_one_get:SetLocalText("170004")
      CS.UIGray.SetGray(self.btn_one_get.transform, false, true)
      self.btn_one_get:SetActive(true)
      self.text_received_reward:SetActive(false)
      if CommonUtil.IsArabic() then
        self.task_desc:SetLocalText(desc, "<color=#5fef87>" .. taskInfo.num, maxCount .. "</color>")
      else
        self.task_desc:SetLocalText(desc, "<color=#5fef87>" .. taskInfo.num .. "</color>", maxCount)
      end
      self.red_point:SetActive(true)
    elseif taskInfo.state == TaskState.Received then
      self.toggle_content:SetActive(true)
      self.txt_one_get:SetLocalText("170003")
      self.btn_one_get:SetActive(false)
      self.text_received_reward:SetActive(true)
      if CommonUtil.IsArabic() then
        self.task_desc:SetLocalText(desc, "<color=#5fef87>" .. taskInfo.num, maxCount .. "</color>")
      else
        self.task_desc:SetLocalText(desc, "<color=#5fef87>" .. taskInfo.num .. "</color>", maxCount)
      end
      for _, cellItem in ipairs(self.itemDic) do
        cellItem:SetReceflagActive(true)
      end
    end
  else
    self.toggle_content:SetActive(false)
    CS.UIGray.SetGray(self.btn_one_get.transform, true, false)
    self.txt_one_get:SetLocalText("170004")
    print("Error, Not Found Config")
    if CommonUtil.IsArabic() then
      self.task_desc:SetLocalText("2010113", "<color=#f53c3d>" .. mgr:GetExtraData(KILL_LOCK_HART_BOSS_LEADER, 0), 20 .. "</color>")
    else
      self.task_desc:SetLocalText("2010113", "<color=#f53c3d>" .. mgr:GetExtraData(KILL_LOCK_HART_BOSS_LEADER, 0) .. "</color>", 20)
    end
  end
  self:RefreshEntryToggle()
  self:Update1000MS()
end

function LockhartActivityMain:RefreshEntryToggle()
  local curSelect = DataCenter.LWActivityLockhartManager:IsShowLockHartEntry()
  self.toggle_show_entry:SetIsOnWithoutNotify(curSelect)
end

function LockhartActivityMain:Update1000MS()
  if self.activityData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.remain_time:SetText("00:00:00")
    end
  end
end

function LockhartActivityMain:OnTaskBtnClick()
  SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {id = taskId})
end

function LockhartActivityMain:OnShowGiftBtnClick()
  if self.activityData ~= nil then
    local param = {}
    param.activityData = self.activityData
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityLockhartDetailPopup, {anim = true}, param)
  end
end

function LockhartActivityMain:OnBtnGoClick()
  SFSNetwork.SendMessage(MsgDefines.SummonLockhartBoss, 0, false)
end

function LockhartActivityMain:OnHelpBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LockhartActivityMain:OnHeroBtnClick()
  local heroId = 0
  if not string.IsNullOrEmpty(self.activityData.para_3) then
    local heroIdArr = string.split(self.activityData.para_3, ";")
    for i = 1, #heroIdArr do
      heroId = tonumber(heroIdArr[i])
      local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
      if hero_data ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, hero_data.uuid, {
          hero_data.uuid
        })
        return
      end
    end
  end
  if heroId ~= 0 then
    local meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    if meta ~= nil and 0 < meta.fragId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, meta.fragId, {
        meta.fragId
      })
    end
  end
end

function LockhartActivityMain.GetEventCanRewardCount()
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
  if taskInfo ~= nil and taskInfo.state == TaskState.CanReceive then
    return 1
  end
  return 0
end

return LockhartActivityMain
