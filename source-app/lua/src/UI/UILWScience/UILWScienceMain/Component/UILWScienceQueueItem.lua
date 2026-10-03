local UILWScienceQueueItem = BaseClass("UILWScienceQueueItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ScienceManager = DataCenter.ScienceManager
local icon_bg_path = "QueueInfo/Science/IconBg"
local researching_frame_path = "QueueInfo/Science/ResearchingFrame"
local icon2_path = "QueueInfo/Science/Icon2"
local lv_bg_path = "QueueInfo/Science/LvBg"
local lv_txt2_path = "QueueInfo/Science/LvTxt2"
local slider_path = "QueueInfo/Slider"
local slider_text2_path = "QueueInfo/Slider/SliderText2"
local queue_text_path = "QueueBg/QueueText"
local acc_btn_path = "QueueInfo/AccBtn"
local unlock_btn_path = "QueueInfo/UnlockBtn"
local free_text_path = "QueueInfo/FreeText"
local help_btn_path = "QueueInfo/HelpBtn"
local unlock_tip_text_path = "QueueInfo/UnlockTipText"
local queue_bg_path = "QueueBg"
local finish_btn_path = "QueueInfo/FinishBtn"
local queue_info_path = "QueueInfo"

function UILWScienceQueueItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWScienceQueueItem:OnDestroy()
  self:RemoveTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceQueueItem:ComponentDefine()
  self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
  self.researching_frame = self:AddComponent(UIBaseContainer, researching_frame_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.lv_bg = self:AddComponent(UIImage, lv_bg_path)
  self.lv_txt2 = self:AddComponent(UIText, lv_txt2_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text2 = self:AddComponent(UIText, slider_text2_path)
  self.acc_btn = self:AddComponent(UIButton, acc_btn_path)
  self.acc_btn:SetOnClick(function()
    self:OnResearchingBtnClick()
  end)
  self.unlock_btn = self:AddComponent(UIButton, unlock_btn_path)
  self.unlock_btn:SetOnClick(function()
    ScienceManager:OpenScienceGiftView()
    local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
    if data then
      GoToUtil.GotoPos(data:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime)
    end
    self.view.ctrl:CloseSelf()
  end)
  self.queue_text = self:AddComponent(UIText, queue_text_path)
  self.free_text = self:AddComponent(UIText, free_text_path)
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.help_btn:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
      SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.queue.uuid, AllianceHelpType.Queue, NewQueueType.Science, self.queue.itemId)
    end
  end)
  self.unlock_tip_text = self:AddComponent(UIText, unlock_tip_text_path)
  self.queue_bg = self:AddComponent(UIImage, queue_bg_path)
  self.finish_btn = self:AddComponent(UIButton, finish_btn_path)
  self.finish_btn:SetOnClick(BindCallback(self, self.OnFinishBtnClick))
  self.queue_info = self:AddComponent(UIBaseContainer, queue_info_path)
end

function UILWScienceQueueItem:ComponentDestroy()
  self.icon_bg = nil
  self.researching_frame = nil
  self.icon2 = nil
  self.lv_bg = nil
  self.lv_txt2 = nil
  self.slider = nil
  self.slider_text2 = nil
  self.acc_btn = nil
  self.unlock_btn = nil
  self.queue_text = nil
  self.free_text = nil
  self.help_btn = nil
  self.unlock_tip_text = nil
  self.queue_bg = nil
  self.finish_btn = nil
  self.queue_info = nil
end

function UILWScienceQueueItem:DataDefine()
  self.lastChangeTime = 0
end

function UILWScienceQueueItem:DataDestroy()
  self.timer_action = nil
  self.lastChangeTime = nil
end

function UILWScienceQueueItem:OnEnable()
  base.OnEnable(self)
end

function UILWScienceQueueItem:OnDisable()
  base.OnDisable(self)
end

function UILWScienceQueueItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWScienceQueueItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWScienceQueueItem:RefreshQueueShowState(fromRefreshTime)
  if not self.queue then
    local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
    if data then
      self:SetActive(true)
    else
      self:SetActive(false)
      return
    end
    self.researching_frame:SetActive(false)
    self.icon2:SetActive(false)
    self.lv_bg:SetActive(false)
    self.lv_txt2:SetActive(false)
    self.slider:SetActive(false)
    self.acc_btn:SetActive(false)
    self.unlock_btn:SetActive(true)
    self.icon_bg:SetActive(false)
    self.free_text:SetActive(false)
    self.help_btn:SetActive(false)
    self.unlock_tip_text:SetActive(true)
    self.queue_bg:SetActive(false)
    self.finish_btn:SetActive(false)
    self:RemoveTimer()
    return
  end
  self:SetActive(true)
  self.unlock_tip_text:SetActive(false)
  self.unlock_btn:SetActive(false)
  self.icon_bg:SetActive(true)
  self.queue_bg:SetActive(true)
  if self.queue:GetQueueState() == NewQueueState.Free then
    self.researching_frame:SetActive(false)
    self.icon2:SetActive(false)
    self.lv_bg:SetActive(false)
    self.lv_txt2:SetActive(false)
    self.slider:SetActive(false)
    self.acc_btn:SetActive(false)
    self.free_text:SetActive(true)
    self.help_btn:SetActive(false)
    self.finish_btn:SetActive(false)
    self:RemoveTimer()
  elseif self.queue:GetQueueState() == NewQueueState.Finish then
    self.researching_frame:SetActive(false)
    self.icon2:SetActive(true)
    self.lv_bg:SetActive(true)
    self.lv_txt2:SetActive(true)
    self.slider:SetActive(false)
    self.acc_btn:SetActive(false)
    self.free_text:SetActive(false)
    self.help_btn:SetActive(false)
    self.finish_btn:SetActive(true)
    self:RemoveTimer()
    if self.queue.itemId ~= nil and self.queue.itemId ~= "" then
      local scienceId = tonumber(self.queue.itemId)
      local template = ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        local curLevel = ScienceManager:GetScienceLevel(scienceId)
        local maxLevel = ScienceManager:GetScienceMaxLevel(scienceId)
        if curLevel < maxLevel then
          self.icon2:LoadSprite(string.format(LoadPath.UILWScience, template.icon))
          self.lv_txt2:SetText(curLevel .. "/" .. maxLevel)
        end
      end
    end
  else
    self.researching_frame:SetActive(true)
    self.icon2:SetActive(true)
    self.lv_bg:SetActive(true)
    self.lv_txt2:SetActive(true)
    self.slider:SetActive(true)
    self.free_text:SetActive(false)
    self.finish_btn:SetActive(false)
    if self.queue.itemId ~= nil and self.queue.itemId ~= "" then
      local scienceId = tonumber(self.queue.itemId)
      local template = ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        local curLevel = ScienceManager:GetScienceLevel(scienceId)
        local maxLevel = ScienceManager:GetScienceMaxLevel(scienceId)
        if curLevel < maxLevel then
          self.icon2:LoadSprite(string.format(LoadPath.UILWScience, template.icon))
          self.lv_txt2:SetText(curLevel .. "/" .. maxLevel)
        end
      end
    end
    if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
      self.help_btn:SetActive(true)
      self.acc_btn:SetActive(false)
    else
      self.help_btn:SetActive(false)
      self.acc_btn:SetActive(true)
    end
    if self.queue:GetQueueState() == NewQueueState.Work then
      if not fromRefreshTime then
        self:RefreshTime()
      end
      self:AddTimer()
    end
  end
end

function UILWScienceQueueItem:SetData(queueId)
  local buildItemId = BuildingTypes.FUN_BUILD_SCIENE
  if queueId == 2 then
    buildItemId = BuildingTypes.LW_BUILE_SCIENCE_TWO
  elseif queueId == 3 then
    buildItemId = BuildingTypes.LW_BUILE_SCIENCE_THREE
  end
  self.queue_text:SetText(tostring(queueId))
  self.queue = DataCenter.QueueDataManager:GetQueueByBuildItemIdForScience(buildItemId)
  self:RefreshQueueShowState()
end

function UILWScienceQueueItem:IsUseHeroFreeAddTime()
  if not self.queue then
    return false
  end
  local isUseFreeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(ItemSpdMenu.ItemSpdMenu_Science)
  local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
  if isUseFreeTime or 0 < freeTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.queue.endTime - curTime <= freeTime * SecToMilSec then
      return true
    end
  end
  return false
end

function UILWScienceQueueItem:OnResearchingBtnClick()
  if not self.queue then
    return
  end
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.queue.uuid, AllianceHelpType.Queue, NewQueueType.Science, self.queue.itemId)
  elseif self:IsUseHeroFreeAddTime() then
    SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
      qUUID = self.queue.uuid,
      itemIDs = "",
      isGold = IsGold.NoUseGold
    })
    return
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
  end
end

function UILWScienceQueueItem:RefreshTime()
  if self.queue ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.queue.endTime - curTime
    local maxTime = self.queue.endTime - self.queue.startTime
    if changeTime < maxTime and 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.slider_text2:SetText(tempTimeValue)
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        self.slider:SetValue(tempValue)
      end
    else
      self.laseTime = 0
      self.slider:SetValue(0)
      self.slider_text2:SetText("")
      self:RefreshQueueShowState(true)
      return
    end
  end
end

function UILWScienceQueueItem:AddTimer()
  if self.timer_action == nil then
    self.timer_action = BindCallback(self, self.RefreshTime)
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function UILWScienceQueueItem:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnFinishBtnClick(self)
  if self.queue then
    ScienceManager:CheckResearchFinishByBuildUuid(tonumber(self.queue.funcUuid))
  end
end

function UILWScienceQueueItem:SetQueueScale(scale)
  if not self.queue_info then
    return
  end
  self.queue_info:SetLocalScaleXYZ(scale, scale, scale)
end

UILWScienceQueueItem.OnFinishBtnClick = OnFinishBtnClick
return UILWScienceQueueItem
