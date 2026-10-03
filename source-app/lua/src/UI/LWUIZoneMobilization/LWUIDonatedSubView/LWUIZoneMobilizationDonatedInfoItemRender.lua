local base = UIBaseContainer
local LWUIZoneMobilizationDonatedInfoItemRender = BaseClass("LWUIZoneMobilizationDonatedInfoItemRender", base)
local Localization = CS.GameEntry.Localization
local BoxRewardPreviewView = require("UI.LWUIZoneMobilization.LWUIBoxRewardPreview.View.LWUIZoneMobilizationBoxRewardPreviewView")
local boxIdleAniName = "V_ui_LWUIZoneMobilizationDonatedInfoItemRender_box_idle"
local boxCanReceiveRewardAniName = "V_ui_LWUIZoneMobilizationDonatedInfoItemRender_box_loop"
local boxReceivedRewardAniName = "V_ui_LWUIZoneMobilizationDonatedInfoItemRender_box_open"
local donatedInfoBtn_path = "DonatedInfoBtn"
local boxNumText_path = "BoxNumText"
local boxTipsText_path = "BoxTipsText"
local donatedTipsText_path = "DonatedTipsText"
local donatedSlider_path = "ProgressGroup/DonatedSlider"
local donatedNumText_path = "ProgressGroup/DonatedSlider/DonatedNumText"
local boxBtn_path = "BoxBtn"
local boxIcon_path = "BoxBtn/BoxIcon"
local anim_path = ""
local donatedProgressEffect_path = "ProgressGroup/DonatedSlider/Eff_ui_Zone_saoguang_short"
local lockContent_path = "LockContent"
local lockImg_path = "LockContent/LockImg"
local lockTxtBg_path = "LockContent/LockTxtBg"
local lockCountDownTxt_path = "LockContent/LockTxtBg/LockCountDownTxt"
local joinAllianceBtn_path = "LockContent/JoinAllianceBtn"
local joinAllianceBtnTxt_path = "LockContent/JoinAllianceBtn/JoinAllianceBtnText"
local progress_path = "ProgressGroup/SupplyPointRoot/Progress"
local icon1_path = "ProgressGroup/SupplyPointRoot/Icon1"
local icon2_path = "ProgressGroup/SupplyPointRoot/Icon2"
local progress_group_path = "ProgressGroup"
local supply_point_root_path = "ProgressGroup/SupplyPointRoot"
local PERSONAL_ICON1_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/zxl_xiusai_wuziqipao_02_big.png"
local PERSONAL_ICON2_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/zxl_xiusai_wuziqipao_big.png"
local ALLIANCE_ICON1_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/wxy_xiusai_wuziqipao_02_big.png"
local ALLIANCE_ICON2_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/wxy_xiusai_wuziqipao_big.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:StopDonatedProgressSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function RefreshLockState(self)
  if self.donatedInfo == nil then
    return
  end
  self.isShowLockContent = self.boxType == ZoneMobilizationDonatedBoxType.Alliance and (not LuaEntry.Player:IsInAlliance() or DataCenter.LWZoneMobilizationManager:IsDonateLimited() and self.donatedInfo.boxNum <= 0)
  self.lockContent:SetActive(self.isShowLockContent)
  if self.isShowLockContent then
    if LuaEntry.Player:IsInAlliance() then
      self.lockTxtBg:SetActive(true)
      self.joinAllianceBtn:SetActive(false)
      self.donatedTipsText:SetLocalText("zone_mobilization_donated_alliance_lock")
    else
      self.lockTxtBg:SetActive(false)
      self.joinAllianceBtn:SetActive(true)
      self.donatedTipsText:SetText("")
    end
    self.progress_group:SetActive(false)
    self:ClearTweens()
  else
    self.donatedTipsText:SetLocalText(self.boxType == ZoneMobilizationDonatedBoxType.Personal and "zone_mobilization_player_progress" or "zone_mobilization_alliance_progress")
    self.progress_group:SetActive(true)
    self:InitSupplyPoint()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  RefreshLockState(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.donatedInfoBtn = self:AddComponent(UIButton, donatedInfoBtn_path)
  self.boxNumText = self:AddComponent(UIText, boxNumText_path)
  self.boxTipsText = self:AddComponent(UIText, boxTipsText_path)
  self.donatedTipsText = self:AddComponent(UIText, donatedTipsText_path)
  self.donatedSlider = self:AddComponent(UISlider, donatedSlider_path)
  self.donatedNumText = self:AddComponent(UIText, donatedNumText_path)
  self.boxBtn = self:AddComponent(UIButton, boxBtn_path)
  self.boxIcon = self:AddComponent(UIImage, boxIcon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.donatedProgressEffect = self:AddComponent(UIBaseContainer, donatedProgressEffect_path)
  self.lockContent = self:AddComponent(UIBaseContainer, lockContent_path)
  self.lockImg = self:AddComponent(UIImage, lockImg_path)
  self.lockTxtBg = self:AddComponent(UIBaseContainer, lockTxtBg_path)
  self.lockCountDownTxt = self:AddComponent(UIText, lockCountDownTxt_path)
  self.joinAllianceBtn = self:AddComponent(UIButton, joinAllianceBtn_path)
  self.joinAllianceBtnTxt = self:AddComponent(UIText, joinAllianceBtnTxt_path)
  self.donatedInfoBtn:SetOnClick(function()
    self:DonatedInfoBtnClick()
  end)
  self.boxBtn:SetOnClick(function()
    self:BoxBtnClick()
  end)
  self.donatedProgressEffect:SetActive(false)
  self.joinAllianceBtn:SetOnClick(function()
    self:JoinAllianceBtnClick()
  end)
  self.joinAllianceBtnTxt:SetLocalText("456550")
  self.progress = self:AddComponent(UIImage, progress_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.progress_group = self:AddComponent(UIBaseContainer, progress_group_path)
  self.supply_point_root = self:AddComponent(UIBaseContainer, supply_point_root_path)
  self.supply_point_animator = self:AddComponent(UIAnimator, supply_point_root_path)
end

local function ComponentDestroy(self)
  self.donatedInfoBtn = nil
  self.boxNumText = nil
  self.boxTipsText = nil
  self.donatedTipsText = nil
  self.donatedSlider = nil
  self.donatedNumText = nil
  self.boxBtn = nil
  self.boxIcon = nil
  self.anim = nil
  self.donatedProgressEffect = nil
  self.lockContent = nil
  self.lockImg = nil
  self.lockTxtBg = nil
  self.lockCountDownTxt = nil
  self.joinAllianceBtn = nil
  self.joinAllianceBtnTxt = nil
  self.progress = nil
  self.icon1 = nil
  self.icon2 = nil
  self.progress_group = nil
  self.supply_point_root = nil
  self.supply_point_animator = nil
end

local function DataDefine(self)
  self.boxType = nil
  self.donatedInfo = nil
  self.maxProgressValue = 0
  self.donatedProgressSeq = nil
  self.donatedProgressChangedData = nil
  self.personalMaxNum = nil
  self.tween1 = nil
  self.tween2 = nil
end

local function DataDestroy(self)
  self.boxType = nil
  self.donatedInfo = nil
  self.maxProgressValue = nil
  self.donatedProgressSeq = nil
  self.donatedProgressChangedData = nil
  self.personalMaxNum = nil
  self:ClearTweens()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateZoneMobilizationDonatedBoxNumData, self.OnRefreshShowDonatedBoxNumData)
  self:AddUIListener(EventId.ZoneMobilizationPersonalOrAllianceBoxDonatedProgressChanged, self.OnBoxDonatedProgressChanged)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceBaseDataUpdated)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateZoneMobilizationDonatedBoxNumData, self.OnRefreshShowDonatedBoxNumData)
  self:RemoveUIListener(EventId.ZoneMobilizationPersonalOrAllianceBoxDonatedProgressChanged, self.OnBoxDonatedProgressChanged)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceBaseDataUpdated)
  base.OnRemoveListener(self)
end

local function OnRefreshShowDonatedBoxNumData(self, boxType)
  if self.boxType and self.boxType == boxType then
    if self.donatedInfo then
      self.boxNumText:SetText(self.donatedInfo.boxNum)
    end
    self:RefreshPlayBoxAniState()
    RefreshLockState(self)
  end
end

local function InitData(self, boxType)
  self.boxType = boxType
  if self.progress_group:GetActive() then
    self:InitSupplyPoint()
  end
end

local function RefreshData(self, donatedInfo, integralNum)
  self.donatedInfo = donatedInfo
  self.maxProgressValue = integralNum
  if donatedInfo then
    self.boxNumText:SetText(self.donatedInfo.boxNum)
  end
  local iconName = "ljq_youling_baoxiang_01"
  local boxTips = ""
  local donatedTips = ""
  if self.boxType == ZoneMobilizationDonatedBoxType.Personal then
    iconName = "geren_jindu_zhanqudongyuan"
    boxTips = "zone_mobilization_player_reward"
    donatedTips = "zone_mobilization_player_progress"
  elseif self.boxType == ZoneMobilizationDonatedBoxType.Alliance then
    iconName = "lianmeng_jindu_zhanqudongyuan"
    boxTips = "zone_mobilization_alliance_reward"
    donatedTips = "zone_mobilization_alliance_progress"
  end
  self.boxIcon:LoadSprite(string.format(LoadPath.LWUIZoneMobilizationSpritePath, iconName))
  self.boxTipsText:SetLocalText(boxTips)
  self.donatedTipsText:SetLocalText(donatedTips)
  self:RefreshPlayBoxAniState()
  if self.donatedProgressChangedData then
    self:DoDonatedProgressSeq()
  else
    self:RefreshDonatedProgressView()
  end
  self:RefreshSupplyPointProgress()
  RefreshLockState(self)
end

local function GetFlyResourcePointsStartPos(self)
  return self.boxBtn.transform.position
end

local function DonatedInfoBtnClick(self)
  local param = {}
  local content = ""
  if self.boxType == ZoneMobilizationDonatedBoxType.Personal then
    content = Localization:GetString("zone_mobilization_player_reward_desc")
    param.isModify = true
  elseif self.boxType == ZoneMobilizationDonatedBoxType.Alliance then
    local prob1, prob2 = DataCenter.LWZoneMobilizationManager:GetProbWhenOpenBoxItemData()
    content = Localization:GetString("zone_mobilization_alliance_reward_desc", prob1, prob2, DataCenter.LWZoneMobilizationManager:GetDonateLimitHoursItemData())
    param.isModify = {txtDescWidth = 450, rootWidth = 500}
  end
  param.type = "desc"
  param.title = ""
  param.desc = content
  param.isLocal = true
  param.alignObject = self.donatedInfoBtn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function BoxBtnClick(self)
  if self.donatedInfo then
    if self.donatedInfo.boxNum > 0 then
      if self.anim then
        self.anim:Play(boxReceivedRewardAniName)
      end
      SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationDonateBoxReward, self.boxType)
    else
      local param = BoxRewardPreviewView.ParamDataClass.New()
      param.position = self.boxBtn.transform.position
      param.arrowDeltaY = 50
      param.showRewardList = self.donatedInfo.rewardPreview
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationBoxRewardPreview, {anim = false}, param)
    end
  end
end

local function RefreshPlayBoxAniState(self)
  if self.donatedInfo and self.donatedInfo.boxNum > 0 then
    self.anim:Play(boxCanReceiveRewardAniName)
  else
    self.anim:Play(boxIdleAniName)
  end
end

local function OnBoxDonatedProgressChanged(self, param)
  if param and param.boxType == self.boxType then
    self.donatedProgressChangedData = param
  end
end

local function OnAllianceBaseDataUpdated(self)
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Donated)
end

local function DoDonatedProgressSeq(self)
  self:StopDonatedProgressSeq()
  self.donatedProgressEffect:SetActive(true)
  local progress = self.donatedInfo and self.donatedInfo.progress or 0
  local startValue = progress - self.donatedProgressChangedData.addValue
  self.donatedProgressSeq = DOTween.Sequence()
  self.donatedProgressSeq:Append(DOTween.To(function(x)
    self.donatedNumText:SetText(string.format("%d/%d", math.floor(x), self.maxProgressValue))
  end, startValue, self.donatedInfo.progress, 1))
  self.donatedProgressSeq:Insert(0, self.donatedSlider:DOValue(Mathf.Clamp01(self.donatedInfo.progress / self.maxProgressValue), 1))
  self.donatedProgressSeq:AppendCallback(function()
    self.donatedProgressChangedData = nil
    self:RefreshDonatedProgressView()
  end)
end

local function StopDonatedProgressSeq(self)
  if self.donatedProgressSeq ~= nil then
    self.donatedProgressSeq:Kill()
    self.donatedProgressSeq = nil
  end
end

local function RefreshDonatedProgressView(self)
  if self.donatedInfo then
    local progressValue = Mathf.Clamp01(self.donatedInfo.progress / self.maxProgressValue)
    self.donatedSlider:SetValue(progressValue)
    self.donatedNumText:SetText(string.format("%d/%d", self.donatedInfo.progress, self.maxProgressValue))
  end
  if self.donatedProgressEffect.activeSelf then
    self.donatedProgressEffect:SetActive(false)
  end
end

local function Update1000MS(self)
  if self.boxType == ZoneMobilizationDonatedBoxType.Alliance and DataCenter.LWZoneMobilizationManager:IsDonateLimited() then
    self.lockCountDownTxt:SetText(DataCenter.LWZoneMobilizationManager:GetDonateUnlockCountDown())
    if DataCenter.LWZoneMobilizationManager:GetDonateUnlockCountDown() == "" and self.lockContent.activeSelf then
      RefreshLockState(self)
    end
  end
end

local function JoinAllianceBtnClick(self)
  UIUtil.OnJoinAllianceBtnClick()
end

local function InitSupplyPoint(self)
  if not self:GetShowIcon() then
    self.supply_point_root:SetActive(false)
    return
  end
  self.supply_point_root:SetActive(true)
  if self.boxType == ZoneMobilizationDonatedBoxType.Personal then
    self.icon1:LoadSprite(PERSONAL_ICON1_PATH)
    self.icon2:LoadSprite(PERSONAL_ICON2_PATH)
  elseif self.boxType == ZoneMobilizationDonatedBoxType.Alliance then
    self.icon1:LoadSprite(ALLIANCE_ICON1_PATH)
    self.icon2:LoadSprite(ALLIANCE_ICON2_PATH)
  end
  self.icon1:SetAlpha(1)
  self.icon2:SetAlpha(0)
  if self.tween1 == nil then
    self.tween1 = self:PlayIconTween(self.icon1, 0, 1)
  end
  if self.tween2 == nil then
    self.tween2 = self:PlayIconTween(self.icon2, 1, 0)
  end
end

local function RefreshSupplyPointProgress(self)
  if not self:GetShowIcon() then
    return
  end
  local donateInfo = DataCenter.LWZoneMobilizationManager.zoneMobilizationDonateInfo
  local progressValue = 0
  if self.boxType == ZoneMobilizationDonatedBoxType.Personal then
    local curValue = donateInfo.surpriseGuaranteeNum or 0
    progressValue = Mathf.Clamp01(curValue / self.personalMaxNum)
  elseif self.boxType == ZoneMobilizationDonatedBoxType.Alliance then
    progressValue = 0
  end
  self.supply_point_progress = progressValue
  self.progress:SetFillAmount(progressValue)
end

local function GetPersonalMaxNum(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k3")
  local max = tonumber(str)
  self.personalMaxNum = max
  return self.personalMaxNum
end

local function PlayIconTween(self, img, minAlpha, maxAlpha)
  if img == nil then
    return
  end
  minAlpha = minAlpha or 0
  maxAlpha = maxAlpha or 1
  local fadeTime = 1
  local stayTime = 2
  img:SetAlpha(maxAlpha)
  local sequence = DOTween.Sequence()
  sequence:Append(img:DOFade(minAlpha, fadeTime))
  sequence:AppendInterval(stayTime)
  sequence:Append(img:DOFade(maxAlpha, fadeTime))
  sequence:AppendInterval(stayTime)
  sequence:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  return sequence
end

local function ClearTweens(self)
  if self.tween1 then
    self.tween1:Kill()
    self.tween1 = nil
  end
  if self.tween2 then
    self.tween2:Kill()
    self.tween2 = nil
  end
end

local function GetShowIcon(self)
  return DataCenter.LWZoneMobilizationManager:GetIsNewFunc() or self.boxType == ZoneMobilizationDonatedBoxType.Alliance
end

local function PlayProgressTween(self)
  if self.progress_seq then
    self.progress_seq:Kill()
    self.progress_seq = nil
  end
  self.progress_seq = DOTween.Sequence()
  self.progress:SetFillAmount(1)
  self.progress_seq:Append(self.progress.unity_image:DOFillAmount(self.supply_point_progress, 0.8))
end

local function DoSupplyPointDisplay(self)
  if self.timer == nil then
    if self.supply_point_animator then
      local anim = "V_ui_LWUIZoneMobilizationDonatedInfoItemRender_fly"
      if CommonUtil.IsArabicAutoMirrorOpen() then
        anim = "V_ui_LWUIZoneMobilizationDonatedInfoItemRender_fly_mirror"
      end
      self.supply_point_animator:Play(anim)
    end
    if self.boxType == ZoneMobilizationDonatedBoxType.Alliance then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayProgressTween()
        if self.timer then
          self.timer:Stop()
          self.timer = nil
        end
      end, 1.2)
    end
  end
end

LWUIZoneMobilizationDonatedInfoItemRender.OnCreate = OnCreate
LWUIZoneMobilizationDonatedInfoItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationDonatedInfoItemRender.OnEnable = OnEnable
LWUIZoneMobilizationDonatedInfoItemRender.OnDisable = OnDisable
LWUIZoneMobilizationDonatedInfoItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDonatedInfoItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDonatedInfoItemRender.DataDefine = DataDefine
LWUIZoneMobilizationDonatedInfoItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationDonatedInfoItemRender.OnAddListener = OnAddListener
LWUIZoneMobilizationDonatedInfoItemRender.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationDonatedInfoItemRender.OnRefreshShowDonatedBoxNumData = OnRefreshShowDonatedBoxNumData
LWUIZoneMobilizationDonatedInfoItemRender.InitData = InitData
LWUIZoneMobilizationDonatedInfoItemRender.RefreshData = RefreshData
LWUIZoneMobilizationDonatedInfoItemRender.DonatedInfoBtnClick = DonatedInfoBtnClick
LWUIZoneMobilizationDonatedInfoItemRender.BoxBtnClick = BoxBtnClick
LWUIZoneMobilizationDonatedInfoItemRender.GetFlyResourcePointsStartPos = GetFlyResourcePointsStartPos
LWUIZoneMobilizationDonatedInfoItemRender.RefreshPlayBoxAniState = RefreshPlayBoxAniState
LWUIZoneMobilizationDonatedInfoItemRender.OnBoxDonatedProgressChanged = OnBoxDonatedProgressChanged
LWUIZoneMobilizationDonatedInfoItemRender.DoDonatedProgressSeq = DoDonatedProgressSeq
LWUIZoneMobilizationDonatedInfoItemRender.StopDonatedProgressSeq = StopDonatedProgressSeq
LWUIZoneMobilizationDonatedInfoItemRender.RefreshDonatedProgressView = RefreshDonatedProgressView
LWUIZoneMobilizationDonatedInfoItemRender.Update1000MS = Update1000MS
LWUIZoneMobilizationDonatedInfoItemRender.JoinAllianceBtnClick = JoinAllianceBtnClick
LWUIZoneMobilizationDonatedInfoItemRender.OnAllianceBaseDataUpdated = OnAllianceBaseDataUpdated
LWUIZoneMobilizationDonatedInfoItemRender.InitSupplyPoint = InitSupplyPoint
LWUIZoneMobilizationDonatedInfoItemRender.getters.personalMaxNum = GetPersonalMaxNum
LWUIZoneMobilizationDonatedInfoItemRender.RefreshSupplyPointProgress = RefreshSupplyPointProgress
LWUIZoneMobilizationDonatedInfoItemRender.PlayIconTween = PlayIconTween
LWUIZoneMobilizationDonatedInfoItemRender.ClearTweens = ClearTweens
LWUIZoneMobilizationDonatedInfoItemRender.GetShowIcon = GetShowIcon
LWUIZoneMobilizationDonatedInfoItemRender.PlayProgressTween = PlayProgressTween
LWUIZoneMobilizationDonatedInfoItemRender.DoSupplyPointDisplay = DoSupplyPointDisplay
return LWUIZoneMobilizationDonatedInfoItemRender
