local UIMainPopupPackEntrance = BaseClass("UIMainPopupPackEntrance", UIBaseContainer)
local UIMainPopupPackEntranceAniItem = require("UI.UIMain.Component.UIMainRight.UIMainPopupPackEntranceAniItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Timer = CS.GameEntry.Timer
local ResourceManager = CS.GameEntry.Resource
local aniBgImg = "lrb_pailianrukou_yingxiongsuipian_bg"
local idleTime = 1.5
local packShowTime = 0.15
local packHideTime = 0.35
local bg_path = "ImageBg"
local icon_path = "ImageBg/ImageIcon"
local remainTimeBg_path = "TimeBg"
local remainTime_path = "TimeBg/Time"
local btn_path = ""
local countBg_path = "PackCount"
local package_content_path = "ImageBg/ImageIcon/packageContent"
local AniStateType = {
  None = 0,
  WaitAniPrefabLoad = 1,
  RechargeShow = 2,
  RechargeHide = 3,
  RechargeIconStay = 4,
  RechargeIconChange = 5
}

local function OnCreate(self)
  base.OnCreate(self)
  self.entranceBgN = self:AddComponent(UIImage, bg_path)
  self.entranceIconN = self:AddComponent(UIImage, icon_path)
  self.entranceIconNCanvasGroup = self:AddComponent(UICanvasGroup, icon_path)
  self.remainTimeBgN = self:AddComponent(UIBaseContainer, remainTimeBg_path)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.btnN = self:AddComponent(UIButton, btn_path)
  self.btnN:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.remainTime = nil
  self.countDownHaveTime = nil
  self.countDownStartTime = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.countBg = self:AddComponent(UIBaseContainer, countBg_path)
  self.countBg:SetActive(false)
  self.package_content = self:AddComponent(UIBaseContainer, package_content_path)
  self.active = nil
  self.seq = nil
  self.allAniData = {}
  self.curAniIndex = 1
  self.curAniState = AniStateType.None
  self.curAniStateExpireTime = 0
  self.aniReqDict = {}
  self.aniItemDict = {}
end

local function OnDestroy(self)
  self:DeleteTimer(self)
  self.entranceBgN = nil
  self.entranceIconN = nil
  self.remainTimeBgN = nil
  self.remainTimeN = nil
  self.btnN = nil
  self.remainTime = nil
  self.countDownHaveTime = nil
  self.countDownStartTime = nil
  self.timer_action = nil
  self.timer = nil
  self.countBg = nil
  self.package_content = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:StopAnim()
  self:StartAnim(self.recharges)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self:DeleteTimer(self)
  self:StopAnim()
end

local function CheckResartAnim(self, prevRecharges, curPackages)
  if not prevRecharges then
    return true
  end
  return not table.deep_compare(prevRecharges, curPackages)
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
  self.countDownHaveTime = minTimeLeft
  self.countDownStartTime = UITimeManager:GetInstance():GetServerTime()
  if not tempPackage or not minTimeLeft then
    self:SetActive(false)
  else
    self:SetActive(true)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local countDownLeftTime = self.countDownHaveTime - (curTime - self.countDownStartTime)
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(countDownLeftTime))
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
    self.countDownHaveTime = self.remainTime
    self.countDownStartTime = UITimeManager:GetInstance():GetServerTime()
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local countDownLeftTime = self.countDownHaveTime - (curTime - self.countDownStartTime)
  self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(countDownLeftTime))
  self.remainTime = self.remainTime - 1000
  if countDownLeftTime < 1500 then
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
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local aniData = self.allAniData[curAniIndex]
  if aniData then
    self.rechargeId = aniData.rechargeId
  end
  local showPackages = WelfareController.GetPopupPackages(RechargeEntryType.MainUIPop)
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

local function CreateAniData(self)
  local recharges = self.recharges
  self.allAniData = {}
  for _, rechargeId in pairs(recharges) do
    local line = DataCenter.RechargeManager:GetLine(rechargeId)
    if line then
      local icon = line.icon
      local icon_ani = line.icon_ani
      if string.IsNullOrEmpty(icon_ani) then
        local aniData = {
          rechargeId = rechargeId,
          icon = icon,
          aniPrefab = nil,
          aniImgName = nil
        }
        table.insert(self.allAniData, aniData)
      else
        local data = string.split(icon_ani, "|")
        if #data == 2 then
          local aniPrefab = data[1]
          local aniImgNames = data[2]
          local aniImgNameList = string.split(aniImgNames, ",")
          for _, aniImgName in pairs(aniImgNameList) do
            local aniData = {
              rechargeId = rechargeId,
              icon = aniBgImg,
              aniPrefab = aniPrefab,
              aniImgName = aniImgName
            }
            table.insert(self.allAniData, aniData)
          end
        end
      end
    end
  end
end

local function ResetAniParams(self)
  self.seq = nil
  self.allAniData = {}
  self.curAniIndex = 1
  self.curAniState = AniStateType.None
  self.curAniStateExpireTime = 0
  self.aniReqDict = {}
  self.aniItemDict = {}
end

local function StartAnim(self, recharges)
  if not recharges or #recharges == 0 then
    return
  end
  self:ResetAniParams()
  self:CreateAniData()
  self:TryPlayAniData()
end

local function StopSeq(self)
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

local function StopAnim(self)
  self:StopSeq()
  self.allAniData = nil
  self.curAniIndex = nil
  self.curAniState = nil
  self.curAniStateExpireTime = nil
  self.aniItemDict = nil
  self.package_content:RemoveComponents(UIMainPopupPackEntranceAniItem)
  if table.count(self.aniReqDict) then
    for _, req in pairs(self.aniReqDict) do
      req:Destroy()
    end
    self.aniReqDict = {}
  end
end

local function TryPlayAniData(self)
  local aniData = self.allAniData[1]
  if aniData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.curAniState = AniStateType.RechargeIconStay
  self.curAniStateExpireTime = curTime + idleTime * 1000
  if #self.allAniData <= 1 then
    self.curAniStateExpireTime = 0
  end
  if aniData.aniPrefab then
    if self.aniItemDict[aniData.aniPrefab] then
      self.entranceIconNCanvasGroup:SetAlpha(1)
      self:TryPlayAniDataIdelType(aniData)
    else
      self.entranceIconNCanvasGroup:SetAlpha(0)
      self.curAniState = AniStateType.WaitAniPrefabLoad
      self.curAniStateExpireTime = 0
      if not self.aniReqDict[aniData.aniPrefab] then
        local prefabName = aniData.aniPrefab
        local prefabPath = string.format("Assets/Main/Prefabs/UI/LWMainUI/LWMainUIPopupPackageItem/%s.prefab", prefabName)
        self.aniReqDict[prefabName] = self:GameObjectInstantiateAsync(prefabPath, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = prefabName
          item.transform:SetParent(self.package_content.transform)
          item.transform:Set_localScale(1, 1, 1)
          local cell = self.package_content:AddComponent(UIMainPopupPackEntranceAniItem, item.name)
          self.aniItemDict[prefabName] = cell
          cell:SetAnchoredPositionXY(0, 0)
          cell:SetData(prefabName)
          cell:SetActive(false)
          self:TryTriggerNextAniState()
        end)
      end
    end
  else
    self.entranceIconNCanvasGroup:SetAlpha(1)
    self:TryPlayAniDataIdelType(aniData)
  end
end

local function Update100MS(self)
  if self.curAniStateExpireTime == nil or self.curAniStateExpireTime <= 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.curAniStateExpireTime then
    self:TryTriggerNextAniState()
  end
end

local function TryTriggerNextAniState(self)
  if self.curAniState == AniStateType.WaitAniPrefabLoad then
    self:TryTriggerWaitAniPrefabLoadStateNext()
  elseif self.curAniState == AniStateType.RechargeShow then
    self:TryTriggerRechargeShowStateNext()
  elseif self.curAniState == AniStateType.RechargeHide then
    self:TryTriggerRechargeHideStateNext()
  elseif self.curAniState == AniStateType.RechargeIconStay then
    self:TryTriggerRechargeIconStayStateNext()
  elseif self.curAniState == AniStateType.RechargeIconChange then
    self:TryTriggerRechargeIconChangeStateNext()
  end
end

local function TryPlayAniDataIdelType(self, aniData)
  self.entranceIconN:LoadSprite(UIUtil.GetFullPath(LoadPath.LWMainUINew, aniData.icon))
  self.entranceIconN:SetNativeSize()
  if aniData.aniPrefab then
    if self.aniItemDict[aniData.aniPrefab] then
      self.aniItemDict[aniData.aniPrefab]:SetActive(true)
      self.aniItemDict[aniData.aniPrefab]:PlayIdleAni(aniData.aniImgName)
    end
  else
    for _, v in pairs(self.aniItemDict) do
      v:SetActive(false)
    end
  end
end

local function TryTriggerWaitAniPrefabLoadStateNext(self)
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local aniData = self.allAniData[curAniIndex]
  local canNext = false
  if aniData.aniPrefab then
    if self.aniItemDict[aniData.aniPrefab] then
      canNext = true
    end
  else
    canNext = true
  end
  if canNext then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = AniStateType.RechargeShow
    self.curAniStateExpireTime = curTime + packShowTime * 1000
    self:TryPlayAniDataIdelType(aniData)
    self:StopSeq()
    self.entranceIconNCanvasGroup:SetAlpha(0)
    self.seq = DOTween.Sequence()
    self.seq:Append(self.entranceIconNCanvasGroup:FadeIn(packShowTime))
    self.seq:Play()
  end
end

local function TryTriggerRechargeShowStateNext(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.curAniStateExpireTime then
    return
  end
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local aniData = self.allAniData[curAniIndex]
  self.curAniState = AniStateType.RechargeIconStay
  self.curAniStateExpireTime = curTime + idleTime * 1000
  self:TryPlayAniDataIdelType(aniData)
  self:StopSeq()
  self.entranceIconNCanvasGroup:SetAlpha(1)
end

local function TryTriggerRechargeIconStayStateNext(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.curAniStateExpireTime then
    return
  end
  if #self.allAniData <= 1 then
    self.curAniStateExpireTime = 0
    return
  end
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local curAniData = self.allAniData[curAniIndex]
  local nextAniIndex = self.curAniIndex % #self.allAniData + 1
  local nextAniData = self.allAniData[nextAniIndex]
  if curAniData.rechargeId == nextAniData.rechargeId then
    local prefabItem = self.aniItemDict[curAniData.aniPrefab]
    if prefabItem then
      local aniTime = prefabItem:PlaySwitchAni(nextAniData.aniImgName, curAniData.aniImgName)
      self.curAniState = AniStateType.RechargeIconChange
      self.curAniStateExpireTime = curTime + aniTime * 1000
      self.curAniIndex = self.curAniIndex + 1
    end
  else
    self.curAniState = AniStateType.RechargeHide
    self.curAniStateExpireTime = curTime + packHideTime * 1000
    self:TryPlayAniDataIdelType(curAniData)
    self:StopSeq()
    self.entranceIconNCanvasGroup:SetAlpha(1)
    self.seq = DOTween.Sequence()
    self.seq:Append(self.entranceIconNCanvasGroup:FadeOut(packHideTime))
    self.seq:Play()
  end
end

local function TryTriggerRechargeHideStateNext(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.curAniStateExpireTime then
    return
  end
  self.curAniIndex = self.curAniIndex + 1
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local aniData = self.allAniData[curAniIndex]
  local canNext = false
  if aniData.aniPrefab then
    if self.aniItemDict[aniData.aniPrefab] then
      canNext = true
    end
  else
    canNext = true
  end
  if canNext then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = AniStateType.RechargeShow
    self.curAniStateExpireTime = curTime + packShowTime * 1000
    self:TryPlayAniDataIdelType(aniData)
    self:StopSeq()
    self.entranceIconNCanvasGroup:SetAlpha(0)
    self.seq = DOTween.Sequence()
    self.seq:Append(self.entranceIconNCanvasGroup:FadeIn(packShowTime))
    self.seq:Play()
  else
    self.entranceIconNCanvasGroup:SetAlpha(0)
    self.curAniState = AniStateType.WaitAniPrefabLoad
    self.curAniStateExpireTime = 0
    if not self.aniReqDict[aniData.aniPrefab] then
      local prefabName = aniData.aniPrefab
      local prefabPath = string.format("Assets/Main/Prefabs/UI/LWMainUI/LWMainUIPopupPackageItem/%s.prefab", prefabName)
      self.aniReqDict[prefabName] = self:GameObjectInstantiateAsync(prefabPath, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = prefabName
        item.transform:SetParent(self.package_content.transform)
        item.transform:Set_localScale(1, 1, 1)
        local cell = self.package_content:AddComponent(UIMainPopupPackEntranceAniItem, item.name)
        self.aniItemDict[prefabName] = cell
        cell:SetAnchoredPositionXY(0, 0)
        cell:SetData(prefabName)
        cell:SetActive(false)
        self:TryTriggerNextAniState()
      end)
    end
  end
end

local function TryTriggerRechargeIconChangeStateNext(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.curAniStateExpireTime then
    return
  end
  local curAniIndex = (self.curAniIndex - 1) % #self.allAniData + 1
  local aniData = self.allAniData[curAniIndex]
  self.curAniState = AniStateType.RechargeIconStay
  self.curAniStateExpireTime = curTime + idleTime * 1000
  self:TryPlayAniDataIdelType(aniData)
  self:StopSeq()
  self.entranceIconNCanvasGroup:SetAlpha(1)
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
UIMainPopupPackEntrance.CreateAniData = CreateAniData
UIMainPopupPackEntrance.ResetAniParams = ResetAniParams
UIMainPopupPackEntrance.TryPlayAniData = TryPlayAniData
UIMainPopupPackEntrance.StartAnim = StartAnim
UIMainPopupPackEntrance.StopAnim = StopAnim
UIMainPopupPackEntrance.TryTriggerNextAniState = TryTriggerNextAniState
UIMainPopupPackEntrance.Update100MS = Update100MS
UIMainPopupPackEntrance.StopSeq = StopSeq
UIMainPopupPackEntrance.TryPlayAniDataIdelType = TryPlayAniDataIdelType
UIMainPopupPackEntrance.TryTriggerWaitAniPrefabLoadStateNext = TryTriggerWaitAniPrefabLoadStateNext
UIMainPopupPackEntrance.TryTriggerRechargeShowStateNext = TryTriggerRechargeShowStateNext
UIMainPopupPackEntrance.TryTriggerRechargeIconStayStateNext = TryTriggerRechargeIconStayStateNext
UIMainPopupPackEntrance.TryTriggerRechargeHideStateNext = TryTriggerRechargeHideStateNext
UIMainPopupPackEntrance.TryTriggerRechargeIconChangeStateNext = TryTriggerRechargeIconChangeStateNext
return UIMainPopupPackEntrance
