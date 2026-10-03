local UIWorldTrendItem = BaseClass("UIWorldTrendItem", UIBaseContainer)
local UIWorldTrendRewardItem = require("UI.UIWorldTrend.Component.UIWorldTrendRewardItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Img_ItemBg = "Img_ItemBg"
local Img_Side = "Img_Side"
local Txt_Title = "Txt_Title"
local Txt_Complete = "Txt_Complete"
local Img_Red = "Rect_Reward/Img_Red"
local Txt_QuestCondition = "Rect_Reward/Txt_QuestCondition"
local Img_RewardBg = "Rect_Reward/Img_RewardBg"
local Txt_QuestState = "Rect_Reward/Txt_QuestState"
local Btn_Reward = "Btn_Reward"
local Txt_Progress = "ProgressSlider/Txt_Progress"
local Txt_Time = "ProgressSlider/Txt_Time"
local ProgressSlider = "ProgressSlider"
local Txt_LvTips = "verticalLayout/Txt_LvTips"
local Txt_RewardState = "verticalLayout/timeLayout/Txt_RewardState"
local Img_ClockTIme = "verticalLayout/timeLayout/Img_ClockTIme"
local timeLayout = "verticalLayout/timeLayout"
local Btn_AcceptReward = "Btn_AcceptReward"
local Txt_AcceptReward = "Btn_AcceptReward/Txt_AcceptReward"
local Btn_FuncBg = "ScrollView/Viewport/Content/Btn_FuncBg"
local Img_FuncUnlock = "ScrollView/Viewport/Content/Btn_FuncBg/Img_FuncUnlock"
local Img_FuncUnlockCopy = "ScrollView/Viewport/Content/Btn_FuncBg/Img_FuncUnlockCopy"
local unlockTxt = "ScrollView/Viewport/Content/Btn_FuncBg/Img_FuncUnlock/unlockTxt"
local Rect_ItemEffect = "ScrollView/Viewport/Rect_ItemEffect"
local Btn_Rank = "Btn_Rank"
local Img_Rank = "Btn_Rank/Img_Rank"
local Img_BgIcon = "Img_ItemBg/bgIcon"
local grayImg_path = "gray"
local anim_newOngoing_path = "Anim_NewOngoing"
local defaultColor = Color32.New(0.8627450980392157, 0.47058823529411764, 0.15294117647058825, 1)

function UIWorldTrendItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._itemBg_img = self:AddComponent(UIImage, Img_ItemBg)
  self._side_img = self:AddComponent(UIImage, Img_Side)
  self._title_txt = self:AddComponent(UIText, Txt_Title)
  self._complete_txt = self:AddComponent(UIText, Txt_Complete)
  self._questState_txt = self:AddComponent(UIText, Txt_QuestState)
  self._rewardBg_img = self:AddComponent(UIImage, Img_RewardBg)
  self._progress_txt = self:AddComponent(UIText, Txt_Progress)
  self._time_txt = self:AddComponent(UIText, Txt_Time)
  self._progress_img = self:AddComponent(UISlider, ProgressSlider)
  self._lvTips_lv = self:AddComponent(UIText, Txt_LvTips)
  self._rewardState_txt = self:AddComponent(UIText, Txt_RewardState)
  self._unlockTxt = self:AddComponent(UIText, unlockTxt)
  self._unlockTxt:SetLocalText(170013)
  self._timeLayout = self:AddComponent(UIBaseContainer, timeLayout)
  self._clockTime_img = self:AddComponent(UIImage, Img_ClockTIme)
  self._acceptReward_btn = self:AddComponent(UIButton, Btn_Reward)
  self._acceptReward_txt = self:AddComponent(UIText, Txt_AcceptReward)
  self._rect_reward = self:AddComponent(UIBaseContainer, Btn_AcceptReward)
  self.rewardList = {}
  local tempItem = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  for i = 1, 3 do
    self.rewardList[i] = tempItem:AddComponent(UIWorldTrendRewardItem, "UIRewardCell" .. i)
    self.rewardList[i]:SetActive(false)
  end
  self._funcBg_btn = self:AddComponent(UIButton, Btn_FuncBg)
  self._funcBg_btn:SetOnClick(function()
    self:OnClickFuncUnlock()
  end)
  self._funcUnlock_img = self:AddComponent(UIImage, Img_FuncUnlock)
  self._funcUnlockCopy_img = self:AddComponent(UIImage, Img_FuncUnlockCopy)
  self._acceptReward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self._rank_img = self:AddComponent(UIImage, Img_Rank)
  self._rank_btn = self:AddComponent(UIButton, Btn_Rank)
  self._rank_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickSendRank()
  end)
  self._bgIcon_img = self:AddComponent(UIImage, Img_BgIcon)
  self.grayImgN = self:AddComponent(UIImage, grayImg_path)
  self.grayMat = self.grayImgN:GetMaterial()
  self.anim_newOngoing = self:AddComponent(UIAnimator, anim_newOngoing_path)
  self._itemEffect_rect = self:AddComponent(UIBaseContainer, Rect_ItemEffect)
end

function UIWorldTrendItem:DataDefine()
  self.isReceiveReward = false
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

function UIWorldTrendItem:OnDestroy()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if self.delayTime1 then
    self.delayTime1:Stop()
    self.delayTime1 = nil
  end
  self._itemBg_img = nil
  self._side_img = nil
  self._title_txt = nil
  self._complete_txt = nil
  self._rewardBg_img = nil
  self._questState_txt = nil
  self._progress_txt = nil
  self._time_txt = nil
  self._progress_img = nil
  self._rewardState_txt = nil
  self._clockTime_img = nil
  self._acceptReward_btn = nil
  self._acceptReward_txt = nil
  self.rewardList = nil
  self._funcBg_btn = nil
  self._funcUnlock_img = nil
  self._rank_btn = nil
  self:DeleteTimer()
  self.timer_action = nil
  self.isReceiveReward = nil
  self._bgIcon_img = nil
  self._rank_img = nil
  base.OnDestroy(self)
end

function UIWorldTrendItem:OnEnable()
  base.OnEnable(self)
end

function UIWorldTrendItem:OnDisable()
  base.OnDisable(self)
end

function UIWorldTrendItem:RefreshData(data)
  self.param = data
  local template = DataCenter.WorldTrendTemplateManager:GetTemplateById(self.param.id)
  self._bgIcon_img:LoadSpriteAuto(template:GetIcon())
  self._title_txt:SetLocalText(template.name)
  self._complete_txt:SetText(template:GetDesc())
  self._rank_btn:SetActive(template:QuestIsAlliance())
  self._funcBg_btn:SetActive(false)
  self.isRefresh = true
  self.anim_newOngoing:SetActive(false)
  if DataCenter.WorldTrendManager.NewOngoing == data.id then
    local id = Setting:GetPrivateInt(SettingKeys.LAST_WORLD_TREDN, 0)
    if id ~= tonumber(data.id) then
      self.isRefresh = false
      self._rewardBg_img:SetMaterial(self.grayMat)
      self._itemBg_img:SetMaterial(self.grayMat)
      self._side_img:SetMaterial(self.grayMat)
      self._rank_img:SetMaterial(self.grayMat)
      self._title_txt:SetColor(Const_Color_Gray)
      Setting:SetPrivateInt(SettingKeys.LAST_WORLD_TREDN, tonumber(data.id))
      self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
        self.anim_newOngoing:SetActive(true)
        self.delayTime1 = TimerManager:GetInstance():DelayInvoke(function()
          self._itemBg_img:SetMaterial(nil)
          self._side_img:SetMaterial(nil)
          self._rewardBg_img:SetMaterial(nil)
          self._title_txt:SetColor(defaultColor)
          self._rank_img:SetMaterial(nil)
        end, 0.4)
      end, 1)
    end
  end
  self:SetItemState()
end

function UIWorldTrendItem:SetItemState()
  self._progress_img:SetActive(false)
  self._acceptReward_btn:SetActive(false)
  self._timeLayout:SetActive(false)
  self._clockTime_img:SetActive(false)
  self._questState_txt:SetActive(false)
  self._rewardBg_img:LoadSprite(string.format(LoadPath.UIWorldTrend, "UIWorldTrend_bg_board"))
  self._itemBg_img:LoadSprite(string.format(LoadPath.UIWorldTrend, "UIWorldTrend_icon_board"))
  self._progress_img:SetValue(0)
  self._lvTips_lv:SetActive(false)
  self._lvTips_lv:SetLocalText(302235, self.param.levelLimit)
  self._acceptReward_txt:SetLocalText(170008)
  self:SetRewardState(false)
  self:SetReceiveState(false)
  self._itemEffect_rect:SetActive(false)
  self._rect_reward:SetActive(false)
  if self.isRefresh then
    self._itemBg_img:SetMaterial(nil)
    self._side_img:SetMaterial(nil)
    self._rewardBg_img:SetMaterial(nil)
    self._title_txt:SetColor(defaultColor)
    self._rank_img:SetMaterial(nil)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.param.status == DataCenter.WorldTrendManager.ServerTrendsStatus.Prepare then
    self:SetReward(true)
    self._timeLayout:SetActive(true)
    local isAboutToOpen = 0 < self.param.startTime and curTime < self.param.startTime
    if isAboutToOpen then
      self._rewardState_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.startTime - curTime))
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._rewardState_txt.rectTransform)
      self._clockTime_img:SetActive(true)
      self._rewardBg_img:SetMaterial(self.grayMat)
      self._itemBg_img:SetMaterial(self.grayMat)
      self._side_img:SetMaterial(self.grayMat)
      self._rank_img:SetMaterial(self.grayMat)
      self._title_txt:SetColor(Const_Color_Gray)
      self:AddTimer()
    else
      self._rewardState_txt:SetLocalText(120018)
    end
  elseif self.param.status == DataCenter.WorldTrendManager.ServerTrendsStatus.Ongoing then
    self:SetReward(false)
    if self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Received then
      self:InitFinishAcceptReward()
      self._rect_reward:SetActive(true)
    elseif self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Unreceived then
      self._rect_reward:SetActive(true)
      self._acceptReward_btn:SetActive(true)
      if self.param.levelLimit > DataCenter.BuildManager.MainLv then
        self.isReceiveReward = false
        self._lvTips_lv:SetActive(true)
      else
        self.isReceiveReward = true
      end
      if self.isReceiveReward then
      end
      self:SetReceiveState(self.isReceiveReward)
      self._itemEffect_rect:SetActive(self.isReceiveReward)
      self._timeLayout:SetActive(true)
      self._rewardState_txt:SetText(Localization:GetString("390979", UITimeManager:GetInstance():TimeStampToDayForLocal(self.param.finishTime)))
    elseif self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.NotSuccess then
      self._progress_txt:SetLocalText(GameDialogDefine.SPLIT, self.param.taskNum, self.param.taskNeedNum)
      if self.param.endTime == 0 then
        self._time_txt:SetText("")
      else
        self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime))
        self:RefreshTime()
        self:AddTimer()
      end
      self._progress_img:SetActive(true)
      self._progress_img:SetValue(self.param.taskNum / self.param.taskNeedNum)
    end
  elseif self.param.status == DataCenter.WorldTrendManager.ServerTrendsStatus.Fail then
    self:SetReward(false)
    local template = DataCenter.WorldTrendTemplateManager:GetTemplateById(self.param.id)
    self._timeLayout:SetActive(true)
    self._rewardState_txt:SetText(template:GetQuestTypeContent())
  elseif self.param.status == DataCenter.WorldTrendManager.ServerTrendsStatus.Finish then
    self._rect_reward:SetActive(true)
    self:SetReward(false)
    if self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.NotJoin then
      self:InitFinishAcceptReward()
    elseif self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Unreceived then
      if self.param.levelLimit > DataCenter.BuildManager.MainLv then
        self.isReceiveReward = false
        self._lvTips_lv:SetActive(true)
      else
        self._acceptReward_btn:SetActive(true)
        self.isReceiveReward = true
      end
      if self.isReceiveReward then
      end
      self:SetReceiveState(self.isReceiveReward)
      self._itemEffect_rect:SetActive(self.isReceiveReward)
      self._timeLayout:SetActive(true)
      self._rewardState_txt:SetText(Localization:GetString("390979", UITimeManager:GetInstance():TimeStampToDayForLocal(self.param.finishTime)))
    elseif self.param.rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Received then
      self:InitFinishAcceptReward()
    end
  end
end

function UIWorldTrendItem:InitFinishAcceptReward()
  self._timeLayout:SetActive(true)
  self._questState_txt:SetActive(false)
  self:SetRewardState(true)
  self._rewardState_txt:SetText(Localization:GetString("390979", UITimeManager:GetInstance():TimeStampToDayForLocal(self.param.finishTime)))
end

function UIWorldTrendItem:SetReward(isGary, isReceive)
  if self.param.rewardList then
    for i = 1, #self.param.rewardList do
      if self.rewardList[i] then
        self.rewardList[i]:SetActive(true)
        self.rewardList[i]:RefreshData(self.param.rewardList[i])
        self.rewardList[i]:SetQuestState(isGary)
      end
    end
    if self.param.functionIds ~= 0 then
      self._funcBg_btn:SetActive(true)
      local template = DataCenter.WorldTrendTemplateManager:GetFuncInfoById(self.param.functionIds)
      self._funcUnlock_img:LoadSpriteAuto(template:GetIcon())
      self._funcUnlockCopy_img:LoadSpriteAuto(template:GetIcon())
      self._funcUnlockCopy_img:SetActive(isGary)
      self._unlockTxt:SetActive(not isGary)
    end
  end
end

function UIWorldTrendItem:SetRewardState(isReceive)
  if self.param.rewardList then
    for i = 1, #self.param.rewardList do
      if self.rewardList[i] then
        self.rewardList[i]:SetRewardState(isReceive)
      end
    end
  end
end

function UIWorldTrendItem:SetReceiveState(isReceive)
  if self.param.rewardList then
    for i = 1, #self.param.rewardList do
      if self.rewardList[i] then
        self.rewardList[i]:SetReceiveState(isReceive)
      end
    end
  end
  self._itemEffect_rect:SetActive(isReceive)
end

function UIWorldTrendItem:AddTimer()
  if self.param.endTime == 0 then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function UIWorldTrendItem:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIWorldTrendItem:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.param.startTime then
    self._rewardState_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.startTime - curTime))
  elseif self.param.startTime - curTime <= 0 or curTime < self.param.endTime then
    self._questState_txt:SetActive(false)
    self._timeLayout:SetActive(false)
    self._progress_img:SetActive(true)
    self:SetReward(false)
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime))
  elseif 0 >= self.param.endTime - curTime then
    self:DeleteTimer()
    self:SetItemState()
  end
end

function UIWorldTrendItem:OnBtnClick()
  if self.isReceiveReward then
    self.view.ctrl:SendServerTrendsReward(self.param.id)
  else
    UIUtil.ShowTips(Localization:GetString("302235", self.param.levelLimit))
  end
end

function UIWorldTrendItem:OnClickFuncUnlock()
  if self.param.functionIds ~= 0 then
    local template = DataCenter.WorldTrendTemplateManager:GetFuncInfoById(self.param.functionIds)
    local param = {}
    param.title = template:GetName()
    param.desc = template:GetDesc()
    param.alignObject = self._funcUnlock_img
    param.type = "desc"
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UIWorldTrendItem:OnClickSendRank()
  DataCenter.WorldTrendManager:SetParam(self.param)
  self.view.ctrl:SendServerTrendsRank(self.param.id)
end

return UIWorldTrendItem
