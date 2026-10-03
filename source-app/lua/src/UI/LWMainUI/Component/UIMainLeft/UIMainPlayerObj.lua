local UIMainPlayerObj = BaseClass("UIMainPlayerObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainBirthdaySetTipBtn = require("UI.LWMainUI.Component.UIMainLeft.UIMainBirthdaySetTipBtn")
local player_btn_path = "PlayerBtn"
local player_bg_path = "PlayerBtn/Image"
local player_head_path = "PlayerBtn/UIPlayerHead"
local player_level_path = "PlayerBtn/LevelBg/LevelText"
local player_redDot_path = "PlayerBtn/RedPoint"
local player_haveApply_path = "PlayerBtn/haveApplyImg"
local player_stamina_path = "Stamina"
local player_stamina_text_path = "Stamina/StaminaBtn/staminaText"
local player_stamina_slider_path = "Stamina/Slider"
local common_red_point_path = "Stamina/StaminaBtn/CommonRedPoint"
local player_stamina_click_btn_path = "Stamina/StaminaBtn"
local updateRefreshTime = 0
local updateRefreshTimeInterval = 5

function UIMainPlayerObj:OnCreate()
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function UIMainPlayerObj:OnDestroy()
  self:TryDestroyBirthdaySetTipBtn()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainPlayerObj:ComponentDefine()
  self.player_btn = self:AddComponent(UIButton, player_btn_path)
  self.player_bg = self:AddComponent(UIImage, player_bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level = self:AddComponent(UIText, player_level_path)
  self.player_redDot_img = self:AddComponent(UIImage, player_redDot_path)
  self.player_haveApply_img = self:AddComponent(UIImage, player_haveApply_path)
  self.stamina_root = self:AddComponent(UIBaseContainer, player_stamina_path)
  self.stamina_num = self:AddComponent(UIText, player_stamina_text_path)
  self.stamina_slider = self:AddComponent(UISlider, player_stamina_slider_path)
  self.stamina_btn = self:AddComponent(UIButton, player_stamina_click_btn_path)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.LevelNormal)
  self.player_btn:SetOnClick(function()
    self.view.ctrl:OnFunctionClick(UIMainFunctionInfo.Info)
  end)
  self.stamina_btn:SetOnClick(function()
    self.commonRedPoint:SetViewed()
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
  end)
end

function UIMainPlayerObj:ComponentDestroy()
  self.player_btn = nil
  self.player_head = nil
  self.player_level = nil
  self.player_redDot_img = nil
  self.player_haveApply_img = nil
  self.stamina_num = nil
  self.stamina_slider = nil
  self.stamina_btn = nil
end

function UIMainPlayerObj:DataDefine()
end

function UIMainPlayerObj:DataDestroy()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UIMainPlayerObj:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainLvUp, self.RefreshPlayerInfo)
  self:AddUIListener(EventId.PlayerStaminaUpdate, self.RefreshStamina)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.RefreshHeroIcon)
  self:AddUIListener(EventId.RefreshClaimFreeStamina, self.RefreshClaimFreeStamina)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedPoint)
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.OnBirthdayDataInfoOpenNeedSetTipStatusChange, self.RefreshBirthdaySetTipBtn)
end

function UIMainPlayerObj:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MainLvUp, self.RefreshPlayerInfo)
  self:RemoveUIListener(EventId.PlayerStaminaUpdate, self.RefreshStamina)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.RefreshHeroIcon)
  self:RemoveUIListener(EventId.RefreshClaimFreeStamina, self.RefreshClaimFreeStamina)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedPoint)
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.OnBirthdayDataInfoOpenNeedSetTipStatusChange, self.RefreshBirthdaySetTipBtn)
end

function UIMainPlayerObj:ReInit()
  self:RefreshPlayerInfo()
  self:RefreshStamina()
  self:RefreshHeroIcon()
  self:RefreshStaminaRedDot()
  self:RefreshCustomerServiceRedPoint()
  self:RefreshOfficialApplyPoint()
  self:TryShowBirthdaySetTipBtn()
end

function UIMainPlayerObj:RefreshClaimFreeStamina()
  self:RefreshStaminaRedDot()
end

function UIMainPlayerObj:RefreshStaminaRedDot()
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.ClaimFreeStamina)
  if not unlock then
    self.commonRedPoint:SetActive(false)
    return
  end
  local time = UIUtil.GetFreeStaminaTime()
  if not time or time == 0 then
    self.commonRedPoint:SetDefaultVisible(true)
  elseif 0 < time then
    self.commonRedPoint:SetActive(false)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshStaminaRedDot()
    end, time + 1)
  end
end

function UIMainPlayerObj:RefreshPlayerInfo()
  self.player_level:SetText(DataCenter.BuildManager.MainLv)
end

function UIMainPlayerObj:RefreshStamina()
  local maxNum = 100
  local curNum = LuaEntry.Player:GetCurStamina()
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    maxNum = config.FormationStaminaMax
  end
  local tempValue = math.min(1, curNum / maxNum)
  self.stamina_slider:SetValue(tempValue)
  self.stamina_num:SetText(string.GetFormattedSeperatorNum(math.floor(curNum)))
end

function UIMainPlayerObj:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime > updateRefreshTime then
    updateRefreshTime = curTime + updateRefreshTimeInterval
    self:RefreshStamina()
  end
end

function UIMainPlayerObj:RefreshHeroIcon()
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.player_head:SetData(uid, pic, picVer, nil, headSkinPath)
end

function UIMainPlayerObj:RefreshCustomerServiceRedPoint()
  local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
  self.player_redDot_img:SetActive(show)
end

function UIMainPlayerObj:RefreshOfficialApplyPoint()
  if DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
    self.player_haveApply_img:SetActive(DataCenter.OfficialApplyManager:HaveApplyRed())
  else
    self.player_haveApply_img:SetActive(false)
  end
end

function UIMainPlayerObj:TryShowBirthdaySetTipBtn()
  local isShow = DataCenter.BirthdayDataManager.isBirthdayDataInfoOpenNeedSetTip
  if isShow == false then
    return
  end
  if self.BirthdaySetTipBtnReq ~= nil then
    return
  end
  self.BirthdaySetTipBtnReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/Birthday/BirthdaySetTipBtn.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.name = "BirthdaySetTipBtn"
    go:SetActive(true)
    go.transform:SetParent(self.player_btn.transform)
    local birthdaySetTipBtn = self.player_btn:AddComponent(UIMainBirthdaySetTipBtn, "BirthdaySetTipBtn")
    birthdaySetTipBtn:SetAsLastSibling()
    birthdaySetTipBtn:SetLocalScaleXYZ(1, 1, 1)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      birthdaySetTipBtn:SetAnchorMinXY(0, 0.5)
      birthdaySetTipBtn:SetAnchorMaxXY(0, 0.5)
      birthdaySetTipBtn:SetPivotXY(1, 0.5)
    else
      birthdaySetTipBtn:SetAnchorMinXY(1, 0.5)
      birthdaySetTipBtn:SetAnchorMaxXY(1, 0.5)
      birthdaySetTipBtn:SetPivotXY(0, 0.5)
    end
    birthdaySetTipBtn:SetAnchoredPositionXY(0, 0)
  end)
end

function UIMainPlayerObj:TryDestroyBirthdaySetTipBtn()
  if self.BirthdaySetTipBtnReq ~= nil then
    self.player_btn:RemoveComponents(UIMainBirthdaySetTipBtn)
    self:GameObjectDestroy(self.BirthdaySetTipBtnReq)
    self.BirthdaySetTipBtnReq = nil
  end
end

function UIMainPlayerObj:RefreshBirthdaySetTipBtn(data)
  if data then
    self:TryShowBirthdaySetTipBtn()
  else
    self:TryDestroyBirthdaySetTipBtn()
  end
end

return UIMainPlayerObj
