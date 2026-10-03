local UIMainVipBtn = BaseClass("UIMainVipBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local vip_btn_path = "PlayerVIpBtn"
local common_red_point_path = "CommonRedPoint"
local vip_tip_path = "VipTip"
local active_player_vip_level_text_path = "PlayerVIpBtn/ActivePlayerVIPLevelText"
local in_active_player_vip_level_text_path = "PlayerVIpBtn/InActivePlayerVIPLevelText"
local vip_tip_text_path = "VipTip/Container/bg/tipTxt"
local vip_bg_path = "PlayerVIpBtn/Bg"

function UIMainVipBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainVipBtn:OnDestroy()
  if self.delayRefreshVip then
    self.delayRefreshVip:Stop()
    self.delayRefreshVip = nil
  end
  if self.delayHideVipTip then
    self.delayHideVipTip:Stop()
    self.delayHideVipTip = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainVipBtn:ComponentDefine()
  self.vip_btn = self:AddComponent(UIButton, vip_btn_path)
  self.vip_btn:SetOnClick(function()
    self.commonRedPoint:SetViewed()
    self.view.ctrl:OnFunctionClick(UIMainFunctionInfo.VIP)
    CommonUtil.FeatureExplorationTrack(FeatureExplorationType.VIP)
  end)
  self.active_player_vip_level_text = self:AddComponent(UIText, active_player_vip_level_text_path)
  self.inactive_player_vip_level_text = self:AddComponent(UIText, in_active_player_vip_level_text_path)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.commonRedPoint:SetActive(false)
  self.vip_tip = self:AddComponent(UIText, vip_tip_path)
  self.vip_tip:SetActive(false)
  self.vip_tipText = self:AddComponent(UIText, vip_tip_text_path)
  self.vip_bg = self:AddComponent(UIImage, vip_bg_path)
end

function UIMainVipBtn:RefresVIPTip()
  if self.delayHideVipTip then
    self.delayHideVipTip:Stop()
    self.delayHideVipTip = nil
  end
  if not self:GetActiveInHierarchy() then
    self.vip_tip:SetActive(false)
    DataCenter.VIPManager:ClearDisplayingTipType()
    return
  end
  local record = DataCenter.VIPManager:GetVipTipRecord(VipTipType.Expired)
  local vipData = DataCenter.VIPManager:GetVipData()
  if record == nil and vipData.endTime ~= nil and not vipData:IsVIPActive() then
    self.vip_tipText:SetLocalText(390843)
    self.vip_tip:SetActive(true)
    DataCenter.VIPManager:SetDisplayingTipType(VipTipType.Expired)
    self.delayHideVipTip = TimerManager:GetInstance():DelayInvoke(function()
      self.vip_tip:SetActive(false)
      EventManager:GetInstance():Broadcast(EventId.OnEnterVipPanel)
    end, 3)
    return
  end
  record = DataCenter.VIPManager:GetVipTipRecord(VipTipType.ExpireSoon)
  if record == nil and vipData:IsVIPActive() then
    local remainTime = vipData.endTime - UITimeManager:GetInstance():GetServerSeconds()
    local k1 = LuaEntry.DataConfig:TryGetStr("vip_alert_config", "k1", 10)
    if remainTime < k1 * 60 then
      self.vip_tipText:SetLocalText(391116)
      self.vip_tip:SetActive(true)
      DataCenter.VIPManager:SetDisplayingTipType(VipTipType.ExpireSoon)
      self.delayHideVipTip = TimerManager:GetInstance():DelayInvoke(function()
        self.vip_tip:SetActive(false)
        EventManager:GetInstance():Broadcast(EventId.OnEnterVipPanel)
      end, 3)
      return
    end
  end
  local lastShowShopRefreshTime = CS.GameEntry.Setting:GetString(SettingKeys.LAST_TIME_SHOW_VIP_SHOP_REFRESH, "")
  local showShopRefresh = false
  if string.IsNullOrEmpty(lastShowShopRefreshTime) then
    showShopRefresh = true
  else
    local lastShowShopRefreshTime = tonumber(lastShowShopRefreshTime)
    local isSameWeek = UITimeManager:GetInstance():CheckIfIsSameWeek(lastShowShopRefreshTime * 1000)
    if not isSameWeek then
      showShopRefresh = true
    end
  end
  if showShopRefresh then
    self.vip_tipText:SetLocalText(391117)
    self.vip_tip:SetActive(true)
    DataCenter.VIPManager:SetDisplayingTipType(VipTipType.ShopRefreshed)
    self.delayHideVipTip = TimerManager:GetInstance():DelayInvoke(function()
      self.vip_tip:SetActive(false)
      EventManager:GetInstance():Broadcast(EventId.OnEnterVipShopPanel)
    end, 3)
    return
  end
  self.vip_tip:SetActive(false)
  DataCenter.VIPManager:ClearDisplayingTipType()
end

local VIP_INACTIVE_ICON = "Assets/Main/Sprites/UI/UIMain/LWMainUI/Mjc_zhujiemian_vip_01.png"
local VIP_ACTIVE_ICON = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/Mjc_zhujiemian_vip_02.png"
local VIP_ACTIVE_TEXT_COLOR = Color.New(0.431, 0.098, 0.058, 1)
local VIP_INACTIVE_TEXT_COLOR = Color.New(0.235, 0.235, 0.235, 1)

function UIMainVipBtn:RefreshShowState(activeState)
  if activeState and activeState == true then
    self.vip_bg:LoadSprite(VIP_ACTIVE_ICON)
    self.active_player_vip_level_text:SetActive(true)
    self.inactive_player_vip_level_text:SetActive(false)
  else
    self.vip_bg:LoadSprite(VIP_INACTIVE_ICON)
    self.active_player_vip_level_text:SetActive(false)
    self.inactive_player_vip_level_text:SetActive(true)
  end
end

function UIMainVipBtn:RefreshVIP()
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  if not unlock or SceneUtils.GetIsInWorld() then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  local vipData = DataCenter.VIPManager:GetVipData()
  if self.delayRefreshVip then
    self.delayRefreshVip:Stop()
    self.delayRefreshVip = nil
  end
  if vipData then
    self.active_player_vip_level_text:SetText(string.format("VIP %d", vipData.level))
    self.inactive_player_vip_level_text:SetText(string.format("VIP %d", vipData.level))
    local _, rewardNum, tipNum = DataCenter.VIPManager:GetRedNum()
    if 0 < rewardNum then
      self.commonRedPoint:SetNum(rewardNum)
    else
      self.commonRedPoint:SetDefaultVisible(0 < tipNum)
    end
    local vipIsActive = vipData:IsVIPActive()
    self:RefreshShowState(vipIsActive)
    if vipIsActive then
      local endTime = vipData.endTime
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      self.delayRefreshVip = TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshVIP()
      end, endTime - curTime + 2)
    end
  else
    self.active_player_vip_level_text:SetText(0)
    self.inactive_player_vip_level_text:SetText(0)
    self:RefreshShowState(false)
  end
  self:RefresVIPTip()
end

function UIMainVipBtn:ComponentDestroy()
  self.vip_btn = nil
  self.vip_bg = nil
  self.active_player_vip_level_text = nil
  self.inactive_player_vip_level_text = nil
  self.commonRedPoint = nil
  self.vip_tip = nil
  self.vip_tipText = nil
end

function UIMainVipBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipDataRefresh, self.RefreshVIP)
  self:AddUIListener(EventId.VipExtendDesignRefresh, self.RefreshVIP)
  self:AddUIListener(EventId.VipExtendDesignRedPoint, self.RefreshVIP)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshVIP)
  self:AddUIListener(EventId.VipRefreshFree, self.RefreshVIP)
  self:AddUIListener(EventId.RefreshVipTip, self.RefresVIPTip)
  self:AddUIListener(EventId.BuildLevelUp, self.RefreshVIP)
end

function UIMainVipBtn:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipDataRefresh, self.RefreshVIP)
  self:RemoveUIListener(EventId.VipExtendDesignRefresh, self.RefreshVIP)
  self:RemoveUIListener(EventId.VipExtendDesignRedPoint, self.RefreshVIP)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshVIP)
  self:RemoveUIListener(EventId.VipRefreshFree, self.RefreshVIP)
  self:RemoveUIListener(EventId.RefreshVipTip, self.RefresVIPTip)
  self:RemoveUIListener(EventId.BuildLevelUp, self.RefreshVIP)
end

return UIMainVipBtn
