local UIMainQuestItem = BaseClass("UIMainQuestItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local this_path = ""
local entry_root = "entry"
local icon_root = "icon"
local top_root = "icon/top"
local bg_path = "entry/questBg"
local finish_bg_path = "entry/questFinishBg"
local finish_img_path = "icon/top/questFinish"
local mask_path = "entry/questMask"
local desc_txt_path = "entry/questMask/questDesc"
local click_btn_path = "entry"
local click_icon_btn_path = "icon"
local entry_vfx = "entryvfx"
local can_reward_vfx = "entry/EffectParent/Eff_ui_renwutiao_glow_loop"
local vfx_parent = "entry/EffectParent"
local common_red_point_path = "icon/CommonRedPoint"
local scale_path = "entry/EffectParent/Eff_ui_renwutiao_glow_loop/scale"
local book_path = "entry/EffectParent/Eff_ui_renwutiao_glow_loop/Book"
local quest_icon_path = "icon/questIcon"
local quest_icon_s1_path = "icon/questIcon_s1"
local QUEST_ENTRY_WIDTH_LIMIT = 510
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3
local QUEST_EFFECT_WIDTH_RATIO = 240

function UIMainQuestItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainQuestItem:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainQuestItem:ComponentDefine()
  self.thisGo = self:AddComponent(UIBaseContainer, this_path)
  self.entryRoot = self:AddComponent(UIBaseContainer, entry_root)
  self.iconRoot = self:AddComponent(UIBaseContainer, icon_root)
  self.topRoot = self:AddComponent(UIBaseContainer, top_root)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_QuestEntry, self.entryRoot.gameObject)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_QuestIcon, self.iconRoot.gameObject)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_QuestEntry, self.topRoot.gameObject)
  self.bgGo = self:AddComponent(UIBaseContainer, bg_path)
  self.finishBgGo = self:AddComponent(UIBaseContainer, finish_bg_path)
  self.finishImgGo = self:AddComponent(UIBaseContainer, finish_img_path)
  self.descMask = self:AddComponent(UIBaseContainer, mask_path)
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.clickIconBtn = self:AddComponent(UIButton, click_icon_btn_path)
  self.clickIconBtn:SetOnClick(function()
    self:OnIconClick()
  end)
  self.entryVfxRoot = self:AddComponent(UIBaseContainer, entry_vfx)
  self.canRewardVfx = self:AddComponent(UIBaseContainer, can_reward_vfx)
  self.VfxParent = self:AddComponent(UIBaseContainer, vfx_parent)
  self.VfxParent:SetLocalScaleXYZ(CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1, 1, 1)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.scale = self:AddComponent(UIBaseContainer, scale_path)
  self.book = self:AddComponent(UIBaseContainer, book_path)
  self.quest_icon = self:AddComponent(UIBaseContainer, quest_icon_path)
  self.quest_icon_s1 = self:AddComponent(UIBaseContainer, quest_icon_s1_path)
  self.entryVfxRoot.gameObject.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
end

function UIMainQuestItem:ComponentDestroy()
  self.thisGo = nil
  self.bgGo = nil
  self.finishBgGo = nil
  self.finishImgGo = nil
  self.descMask = nil
  self.descText = nil
  self.clickBtn = nil
  self.clickIconBtn = nil
  self.commonRedPoint = nil
  self.scale = nil
  self.book = nil
  self.quest_icon = nil
  self.quest_icon_s1 = nil
  DataCenter.ArrowManager:RemoveWorldFingerArrow()
end

function UIMainQuestItem:DataDefine()
  self.infos = {}
  self.state = 0
end

function UIMainQuestItem:DataDestroy()
  self.infos = nil
  self.state = nil
end

function UIMainQuestItem:OnEnable()
  base.OnEnable(self)
end

function UIMainQuestItem:OnDisable()
  base.OnDisable(self)
end

function UIMainQuestItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DailyQuestSuccess, self.RefreshRedPoint)
  self:AddUIListener(EventId.DailyQuestLs, self.RefreshRedPoint)
  self:AddUIListener(EventId.DailyQuestReward, self.RefreshRedPoint)
end

function UIMainQuestItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

function UIMainQuestItem:AdjustBg()
  local rawWidth = self.descText:GetWidth() + 30
  local width = math.min(QUEST_ENTRY_WIDTH_LIMIT, rawWidth)
  local sizeDelta = Vector2.New(width, self.finishBgGo:GetSizeDelta().y)
  self.finishBgGo:SetSizeDelta(sizeDelta + Vector2.New(15, 0))
  self.bgGo:SetSizeDelta(sizeDelta + Vector2.New(15, 0))
  self.descMask:SetSizeDelta(sizeDelta)
  local sizeDeltaBtn = Vector2.New(width + 5, self.clickBtn:GetSizeDelta().y)
  self.clickBtn:SetSizeDelta(sizeDeltaBtn)
  local scaleX = (width + 5) / QUEST_EFFECT_WIDTH_RATIO
  self.scale:SetLocalScaleXYZ(scaleX, 1, 1)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.descText:SetAnchoredPositionXY(10, 2)
  if rawWidth > width then
    self.tweenSeq = DOTween.Sequence()
    self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_DELAY)
    self.tweenSeq:Append(self.descText.transform:DOAnchorPosX(CommonUtil.ArabicAutoMirrorFactor() * (width - rawWidth), (rawWidth - width) / QUEST_ENTRY_ROLLING_SPD):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_HOLD)
    self.tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  end
end

function UIMainQuestItem:RefreshState()
  if DataCenter.ChapterTaskManager:IsCompleteAllChapter() then
    self.infos = DataCenter.TaskManager:GetOneMainTaskForMainUI()
  else
    self.infos = DataCenter.ChapterTaskManager:GetFirstChapterTask()
  end
  self.state = 0
  self.canRewardVfx:SetActive(false)
  self.thisGo:SetActive(false)
  if self.infos then
    local isChapter = self.infos.isChapter
    if isChapter then
      local taskState = self.infos.state
      local allNum = DataCenter.ChapterTaskManager:GetAllNum()
      local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
      if allNum <= completeNum and taskState == "0" then
        self.descText:SetLocalText(170459)
        self.finishBgGo:SetActive(true)
        self.finishImgGo:SetActive(true)
        self.state = 3
        self:AdjustBg()
        self.thisGo:SetActive(true)
      end
    else
      local taskinfos = DataCenter.ChapterTaskManager:GetTaskInfos(self.infos)
      self.descText:SetText(taskinfos.strDesc)
      local is_finish = taskinfos.is_finish
      self.state = is_finish and 2 or 1
      self.finishBgGo:SetActive(is_finish)
      self.finishImgGo:SetActive(is_finish)
      self.canRewardVfx:SetActive(is_finish)
      self:AdjustBg()
      self.thisGo:SetActive(true)
    end
  else
    self.descText:SetLocalText(170017)
    self.finishBgGo:SetActive(false)
    self.finishImgGo:SetActive(false)
    self:AdjustBg()
    self.thisGo:SetActive(true)
  end
  if self.state == 2 or self.state == 11 then
    self:PlayEntryVFX()
  end
  self:RefreshTaskEntryIcon()
end

function UIMainQuestItem:RefreshTaskEntryIcon()
  local isInS1AndHasSeasonMainTaskNotReceive = self:IsInS1AndHasSeasonMainTaskNotReceive()
  self.quest_icon_s1:SetActive(isInS1AndHasSeasonMainTaskNotReceive)
  self.book:SetActive(not isInS1AndHasSeasonMainTaskNotReceive)
  self.quest_icon:SetActive(not isInS1AndHasSeasonMainTaskNotReceive)
end

function UIMainQuestItem:IsInS1AndHasSeasonMainTaskNotReceive()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.CityStronghold and SeasonUtil.SeasonTaskShowCondition() and DataCenter.TaskManager:IsInS1AndHasSeasonMainTaskNotReceive() then
    return true
  end
  return false
end

function UIMainQuestItem:OnClick()
  self.commonRedPoint:SetViewed()
  if self.state == 1 then
    if self.infos then
      DataCenter.ChapterTaskManager:QuestGoto(self.infos)
    end
  elseif self.state == 2 then
    if self.infos then
      local rewardPos = self.clickIconBtn.transform.position
      DataCenter.ChapterTaskManager:QuestGetReward(self.infos, rewardPos)
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    end
  elseif self.state == 3 then
    DataCenter.ChapterTaskManager:ChapterGetReward()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
  elseif self.state == 10 + TaskState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
      id = self.infos.id
    })
  elseif self.state == 10 + TaskState.NoComplete then
    local conf = DataCenter.QuestTemplateManager:GetQuestTemplate(self.infos.id)
    DataCenter.ChapterTaskManager:QuestGoto(conf)
  elseif self.state == 0 then
    UIUtil.ShowTipsId("quest_allclear_tips")
  end
end

function UIMainQuestItem:PlayEntryVFX()
  if not self.entryRoot.gameObject.activeInHierarchy then
    return
  end
  local vfxHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_ui_renwutiao_glow.prefab")
  vfxHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.entryVfxRoot.transform, false)
    transform.localPosition = Vector3.zero
    transform.localRotation = Quaternion.identity
    transform.localScale = Vector3.one
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(handle) then
        handle:Destroy()
      end
    end, 2)
  end)
end

function UIMainQuestItem:OnIconClick()
  if self.state == 1 or self.state == 2 or self.state == 3 then
    if SeasonUtil.SeasonTaskShowCondition() and DataCenter.TaskManager:CheckIsSeasonTaskCanReceive() then
      GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Season)
    elseif self.dailyQuestRedNum > 0 then
      GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
    elseif SeasonUtil.IsInSeason() then
      GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Season)
    else
      GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList)
    end
  else
    GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
  end
end

function UIMainQuestItem:ShowSelfArrow()
end

function UIMainQuestItem:ShowArrow()
end

function UIMainQuestItem:RefreshRedPoint()
  self.totalRedNum = 0
  self.dailyQuestRedNum = DataCenter.DailyTaskManager:GetRedNum()
  self.totalRedNum = self.totalRedNum + self.dailyQuestRedNum
  self.commonRedPoint:SetNum(self.totalRedNum)
end

return UIMainQuestItem
