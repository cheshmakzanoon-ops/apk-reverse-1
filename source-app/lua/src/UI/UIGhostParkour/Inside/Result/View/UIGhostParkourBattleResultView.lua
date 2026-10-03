local UIGhostParkourBattleResultView = BaseClass("UIGhostParkourBattleResultView", UIBaseView)
local base = UIBaseView
local UIGhostParkourMatchPlayerItem = require("UI.UIGhostParkour.Inside.Result.Component.UIGhostParkourMatchPlayerItem")
local UIGhostParkourSettleTopItem = require("UI.UIGhostParkour.Inside.Result.Component.UIGhostParkourSettleTopItem")
local top_root_path = "SafeArea/TopRoot"
local tier_slider_path = "SafeArea/CenterRoot/RankRoot/TierSlider"
local icon_path = "SafeArea/CenterRoot/RankRoot/Icon"
local tier_progress_text_path = "SafeArea/CenterRoot/RankRoot/TierProgressText"
local again_btn_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn"
local again_btn_text_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn/LW_Btn_Common_New_Base/AgainBtnText"
local back_btn_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn"
local back_btn_text_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn/LW_Btn_Common_New_Base/BackBtnText"
local share_btn_path = "SafeArea/ShareBtn"
local tip_text_path = "SafeArea/BottomGroup/TipText"
local remain_times_path = "SafeArea/BottomGroup/AgainBtnRoot/RemainTimes"
local first_item_path = "SafeArea/CenterRoot/PlayerRoot/Container/FirstItem"
local second_item_path = "SafeArea/CenterRoot/PlayerRoot/Container/SecondItem"
local third_item_path = "SafeArea/CenterRoot/PlayerRoot/Container/ThirdItem"
local before_tier_bg_path = "SafeArea/CenterRoot/BeforeTierBg"
local after_tier_bg_path = "SafeArea/CenterRoot/AfterTierBg"
local safe_area_path = "SafeArea"

function UIGhostParkourBattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIGhostParkourBattleResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourBattleResultView:ComponentDefine()
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.top_root = self:AddComponent(UIGhostParkourSettleTopItem, top_root_path)
  self.tier_slider = self:AddComponent(UISlider, tier_slider_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.tier_progress_text = self:AddComponent(UITextMeshProUGUIEx, tier_progress_text_path)
  self.again_btn = self:AddComponent(UIButton, again_btn_path)
  self.again_btn:SetOnClick(function()
    self:OnAgainBtnClick()
  end)
  self.again_btn_text = self:AddComponent(UITextMeshProUGUIEx, again_btn_text_path)
  self.again_btn_text:SetLocalText("ghost_parkour_again_btn")
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.back_btn_text:SetLocalText("ghost_parkour_back_btn")
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(BindCallback(self, self.OnShareBtnClick))
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  local tipKey = DataCenter.LWGhostParkourDataManager:GetResultTipKey()
  if not string.IsNullOrEmpty(tipKey) then
    self.tip_text:SetLocalText(tipKey)
  end
  self.remain_times = self:AddComponent(UITextMeshProUGUIEx, remain_times_path)
  self.first_item = self:AddComponent(UIGhostParkourMatchPlayerItem, first_item_path)
  self.second_item = self:AddComponent(UIGhostParkourMatchPlayerItem, second_item_path)
  self.third_item = self:AddComponent(UIGhostParkourMatchPlayerItem, third_item_path)
  self.itemList = {
    self.first_item,
    self.second_item,
    self.third_item
  }
  self.before_tier_bg = self:AddComponent(UIRawImage, before_tier_bg_path)
  self.after_tier_bg = self:AddComponent(UIRawImage, after_tier_bg_path)
  self.safe_area = self:AddComponent(UIBaseContainer, safe_area_path)
  self.safe_area:SetActive(false)
end

function UIGhostParkourBattleResultView:ComponentDestroy()
  if self.topRootTimer ~= nil then
    self.topRootTimer:Stop()
    self.topRootTimer = nil
  end
  if self.upSoundTimer ~= nil then
    self.upSoundTimer:Stop()
    self.upSoundTimer = nil
  end
  self.rootAnim = nil
  self.top_root = nil
  self.tier_slider = nil
  self.icon = nil
  self.tier_progress_text = nil
  self.again_btn = nil
  self.again_btn_text = nil
  self.back_btn = nil
  self.back_btn_text = nil
  self.share_btn = nil
  self.tip_text = nil
  self.first_item = nil
  self.second_item = nil
  self.third_item = nil
  self.itemList = nil
  self.before_tier_bg = nil
  self.after_tier_bg = nil
  self.safe_area = nil
end

function UIGhostParkourBattleResultView:DataDefine()
  self.topRootTimer = nil
  self.logic = nil
  self.message = nil
end

function UIGhostParkourBattleResultView:DataDestroy()
  self.logic = nil
  self.message = nil
end

function UIGhostParkourBattleResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourOnEndAnimFinished, self.ShowPanel)
end

function UIGhostParkourBattleResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourOnEndAnimFinished, self.ShowPanel)
  base.OnRemoveListener(self)
end

function UIGhostParkourBattleResultView:InitView()
  local message = self:GetUserData()
  if message == nil or message.errorCode ~= nil then
    return
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic == nil or message.uuid ~= logic:GetUuid() then
    return
  end
  self.message = message
  self.logic = logic
  self:InitMatchPanel(message)
  if logic.showEndPanel then
    self:ShowPanel()
  end
end

function UIGhostParkourBattleResultView:InitMatchPanel(message)
  local goodsId = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k3") or 0
  local itemTemplate = DataCenter.ItemTemplateManager:TryGetItemTemplate(goodsId)
  if itemTemplate then
    local iconUrl = string.format(LoadPath.ItemPath, itemTemplate.icon)
    self.icon:LoadSpriteAuto(iconUrl)
  end
  local addTierExp = message.addTierExp
  local rank = self:InitPlayerList(message.rankList, addTierExp, goodsId)
  self.top_root:InitView(message, rank)
  local beforeTier = message.beforeTier or 0
  local beforeTierExp = message.beforeTierExp or 0
  local afterTier = message.afterTier or 0
  local afterTierExp = message.afterTierExp or 0
  local change = false
  if beforeTier ~= afterTier then
    change = true
    local tierMeta = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(beforeTier)
    if tierMeta then
      self.before_tier_bg:LoadSpriteAuto(tierMeta.big_icon_bg)
    end
  end
  self.tierChange = change
  local tierMeta = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(afterTier)
  if tierMeta then
    local tierMax = tierMeta.exp
    self.tier_slider:SetValue(Mathf.Clamp(afterTierExp / tierMax, 0, 1))
    if afterTierExp >= tierMax then
      self.tier_progress_text:SetLocalText("ghost_parkour_exp_full")
    else
      self.tier_progress_text:SetText(afterTierExp .. "/" .. tierMax)
    end
    self.after_tier_bg:LoadSpriteAuto(tierMeta.big_icon_bg)
  end
  local isNewRecord = message.isNewRecord
  if isNewRecord then
    self.share_btn:SetActive(true)
    if self.logic then
      self.logic:SaveLog(function(uuid, succeed)
        DataCenter.LWGhostParkourDataManager:ReqSyncChallengeInfo(uuid, succeed)
      end)
    end
  else
    self.share_btn:SetActive(false)
    if self.logic then
      self.logic:ExitDelFile()
    end
  end
  local remainTimes = DataCenter.LWGhostParkourDataManager:GetRemainTimes()
  self.remain_times:SetLocalText("parkour_challenge_num", remainTimes)
end

function UIGhostParkourBattleResultView:InitPlayerList(rankList, afterTierExp, goodsId)
  if rankList then
    local selfRank = 1
    local selfUid = LuaEntry.Player:GetUid()
    local count = #rankList
    for i, v in ipairs(self.itemList) do
      if i <= count then
        local data = rankList[i]
        if data.uid == selfUid then
          selfRank = i
          v:ReInit(i, data, afterTierExp, goodsId)
        else
          v:ReInit(i, data)
        end
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
    return selfRank
  end
end

function UIGhostParkourBattleResultView:OnAgainBtnClick()
  local remainTimes = DataCenter.LWGhostParkourDataManager:GetRemainTimes()
  if remainTimes and 0 < remainTimes then
    DataCenter.LWGhostParkourDataManager:ReqFightMatch(true)
  else
    DataCenter.LWBattleManager:ShowTipsId("parkour_challenge_finish")
  end
end

function UIGhostParkourBattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
end

function UIGhostParkourBattleResultView:OnShareBtnClick()
  self.share_btn:SetActive(false)
  if self.message == nil then
    return
  end
  local message = self.message
  local bestType = message.best or 0
  local contextId
  if bestType == 1 then
    contextId = "ghost_parkour_today_score_record"
  elseif bestType == 2 then
    contextId = "ghost_parkour_max_score_record"
  end
  local totalRunTime = message.totalRunTime
  local time = DataCenter.LWGhostParkourDataManager:GetTimeFormat(totalRunTime * 1000)
  local activityId = DataCenter.LWGhostParkourDataManager:GetActivityId()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local endTs = activityInfo and activityInfo.endTime
  local shareParam = {}
  shareParam.post = PostType.GhostBattleResultShare
  shareParam.param = {}
  shareParam.param.endTs = endTs
  shareParam.param.contextId = contextId
  shareParam.param.para = time .. ""
  shareParam.param.activityId = activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIGhostParkourBattleResultView:ShowPanel()
  self.safe_area:SetActive(true)
  self.rootAnim:Play("V_ui_UIGhostParkourBattleResult_in", 0, 0)
  DataCenter.LWSoundManager:PlaySound(11039, false)
  local ret, duration = self.top_root:PlayPanelAnim()
  if ret then
    self.topRootTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.topRootTimer ~= nil then
        self.topRootTimer:Stop()
        self.topRootTimer = nil
      end
      if self.tierChange then
        self.rootAnim:Play("V_ui_UIGhostParkourBattleResult_RankUp", 0, 0)
        DataCenter.LWSoundManager:PlaySound(11049, false)
        if self.upSoundTimer then
          self.upSoundTimer:Stop()
        end
        self.upSoundTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.upSoundTimer ~= nil then
            self.upSoundTimer:Stop()
            self.upSoundTimer = nil
          end
          DataCenter.LWSoundManager:PlaySound(11050, false)
        end, 1.05)
      else
        self.rootAnim:Play("V_ui_UIGhostParkourBattleResult_Rank", 0, 0)
        DataCenter.LWSoundManager:PlaySound(11049, false)
      end
    end, duration + 0.5)
  end
end

return UIGhostParkourBattleResultView
