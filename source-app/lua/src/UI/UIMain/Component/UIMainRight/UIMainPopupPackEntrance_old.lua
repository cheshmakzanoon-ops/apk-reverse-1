local UIMainPopupPackEntrance = BaseClass("UIMainPopupPackEntrance", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Timer = CS.GameEntry.Timer
local ResourceManager = CS.GameEntry.Resource
local bg_path = "ImageBg"
local icon_path = "ImageBg/ImageIcon"
local icon2_path = "ImageBg/ImageViewport/ImageContent/ImageIcon2"
local icon3_path = "ImageBg/ImageViewport/ImageContent/ImageIcon3"
local remainTimeBg_path = "TimeBg"
local remainTime_path = "TimeBg/Time"
local btn_path = ""
local countBg_path = "PackCount"
local iconContent_path = "ImageBg/ImageViewport/ImageContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.entranceBgN = self:AddComponent(UIImage, bg_path)
  self.entranceIconN = self:AddComponent(UIImage, icon_path)
  self.remainTimeBgN = self:AddComponent(UIBaseContainer, remainTimeBg_path)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.btnN = self:AddComponent(UIButton, btn_path)
  self.btnN:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.remainTime = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.countBg = self:AddComponent(UIBaseContainer, countBg_path)
  self.countBg:SetActive(false)
  self.active = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self:DeleteTimer(self)
  self:StopAnim()
end

local function OnDestroy(self)
  self:DeleteTimer(self)
  self.entranceBgN = nil
  self.entranceIconN = nil
  self.remainTimeBgN = nil
  self.remainTimeN = nil
  self.btnN = nil
  self.remainTime = nil
  self.timer_action = nil
  self.timer = nil
  self.countBg = nil
  base.OnDestroy(self)
end

local function CheckResartAnim(self, prevRecharges, curPackages)
  if not prevRecharges then
    return true
  end
  return not table.deep_compare(prevRecharges, curPackages)
end

local function StartAnim(self, recharges)
  if not recharges or #recharges == 0 then
    return
  end
  if #recharges == 1 then
    self:SetIcon(DataCenter.RechargeManager:GetLine(recharges[1]).icon)
    return
  end
  self.seq = DOTween.Sequence()
  for i, v in pairs(recharges) do
    local rechargeTemplate = DataCenter.RechargeManager:GetLine(v)
    if rechargeTemplate and not string.IsNullOrEmpty(rechargeTemplate.icon) then
      if i == 1 then
        self.seq:AppendCallback(function()
          self:SetIcon(rechargeTemplate.icon)
          self.rechargeId = v
        end)
        self.seq:Append(self.entranceIconN:DOFade(1, 0.15))
        self.seq:AppendInterval(2)
      elseif i == #recharges then
        self.seq:Append(self.entranceIconN:DOFade(0, 0.35))
        self.seq:AppendCallback(function()
          self:SetIcon(rechargeTemplate.icon)
          self.rechargeId = v
        end)
        self.seq:Append(self.entranceIconN:DOFade(1, 0.15))
        self.seq:AppendInterval(2)
        self.seq:Append(self.entranceIconN:DOFade(0, 0.35))
      else
        self.seq:Append(self.entranceIconN:DOFade(0, 0.35))
        self.seq:AppendCallback(function()
          self:SetIcon(rechargeTemplate.icon)
          self.rechargeId = v
        end)
        self.seq:Append(self.entranceIconN:DOFade(1, 0.15))
        self.seq:AppendInterval(2)
        self.seq:Append(self.entranceIconN:DOFade(0, 0.35))
      end
    end
  end
  self.seq:SetLoops(-1)
  self.seq:Play()
end

local function StopAnim(self)
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
  if self.entranceIconN then
    self.entranceIconN:SetLocalPositionXYZ(0, 0, 0)
    self.entranceIconN:SetAlpha(1)
  end
end

local function SetEntrance(self, recharges)
  local prevRecharges = self.recharges and DeepCopy(self.recharges) or nil
  self.recharges = recharges
  self:RefreshEntrance(prevRecharges)
end

local function RefreshEntrance(self, prevRecharges)
  self:DeleteTimer()
  if not self.recharges or #self.recharges == 0 then
    self:SetActive(false)
    return
  end
  local minTimeLeft, tempPackage = self:GetMinRemainTime()
  self.remainTime = minTimeLeft
  if not tempPackage or not minTimeLeft then
    self:SetActive(false)
  else
    self:SetActive(true)
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(minTimeLeft))
    if self.timer == nil then
      self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, true)
      self.timer:Start()
      if self.remainTime then
        self.remainTime = self.remainTime - 1000
      end
    end
    if self.countBg.activeSelf then
      self:RefreshRechargeCount()
    end
  end
  if CheckResartAnim(self, prevRecharges, self.recharges) then
    self:StopAnim()
    self:StartAnim(self.recharges)
  end
end

local function SetIcon(self, iconPath)
  self.entranceIconN:LoadSprite(UIUtil.GetFullPath(LoadPath.LWMainUINew, iconPath))
  self.entranceIconN:SetNativeSize()
end

local function GetMinRemainTime(self)
  if self.recharges then
    local function GetMinRemainTimeByRechargeId(rechargeId)
      local packagesArr = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeId)
      
      local minTime, packInfo
      if packagesArr then
        minTime = LongMaxValue
        for i, v in ipairs(packagesArr) do
          local tempPackage = v
          if not tempPackage:isBought() then
            local leftTime = tempPackage:getCountdown()
            if 1500 <= leftTime and minTime > leftTime then
              minTime = leftTime
              packInfo = tempPackage
            end
          end
        end
      end
      return minTime, packInfo
    end
    
    local minTime, packInfo
    for i, v in pairs(self.recharges) do
      local rechargeTemplate = DataCenter.RechargeManager:GetLine(v)
      if rechargeTemplate then
        local _minTime, _tempPackage = GetMinRemainTimeByRechargeId(v)
        if _minTime and (minTime == nil or minTime > _minTime) then
          minTime = _minTime
          packInfo = _tempPackage
        end
      end
    end
    return minTime, packInfo
  else
    return nil, nil
  end
end

local function TimerAction(self)
  if not self.remainTime then
    self.remainTime = self:GetMinRemainTime()
  end
  self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.remainTime))
  self.remainTime = self.remainTime - 1000
  if self.remainTime < 1500 then
    self:RefreshEntrance()
    self.view:RefreshPopupPackageEntrances()
  end
end

local function DeleteTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnBtnClick(self)
  local showPackages = WelfareController.GetPopupPackages()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevelPackage, {anim = true}, self.rechargeId, showPackages)
  self.countBg:SetActive(false)
  UIUtil.GetTodayActiveCount(ActiveShowType.PopupPackage, true)
end

local function RefreshRechargeCount(self)
  local activeCount = UIUtil.GetTodayActiveCount(ActiveShowType.PopupPackage, false)
  if activeCount <= 0 then
    self.countBg:SetActive(false)
    return
  end
  local lastLoginTime = Setting:GetString(SettingKeys.Last_LOGIN_TIME, UITimeManager:GetInstance():GetServerSeconds(), "")
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if string.IsNullOrEmpty(lastLoginTime) then
    self.countBg:SetActive(UIUtil.GetTodayActiveCount(ActiveShowType.PopupPackage, false) <= 0)
  elseif not UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastLoginTime), tonumber(now)) then
    self.countBg:SetActive(UIUtil.GetTodayActiveCount(ActiveShowType.PopupPackage, false) <= 0)
  else
    self.countBg:SetActive(false)
  end
end

UIMainPopupPackEntrance.OnCreate = OnCreate
UIMainPopupPackEntrance.OnEnable = OnEnable
UIMainPopupPackEntrance.OnDisable = OnDisable
UIMainPopupPackEntrance.OnDestroy = OnDestroy
UIMainPopupPackEntrance.SetEntrance = SetEntrance
UIMainPopupPackEntrance.RefreshEntrance = RefreshEntrance
UIMainPopupPackEntrance.GetMinRemainTime = GetMinRemainTime
UIMainPopupPackEntrance.TimerAction = TimerAction
UIMainPopupPackEntrance.DeleteTimer = DeleteTimer
UIMainPopupPackEntrance.SetIcon = SetIcon
UIMainPopupPackEntrance.OnBtnClick = OnBtnClick
UIMainPopupPackEntrance.RefreshRechargeCount = RefreshRechargeCount
UIMainPopupPackEntrance.CheckResartAnim = CheckResartAnim
UIMainPopupPackEntrance.StartAnim = StartAnim
UIMainPopupPackEntrance.StopAnim = StopAnim
return UIMainPopupPackEntrance
