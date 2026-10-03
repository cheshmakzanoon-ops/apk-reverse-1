local base = UIBaseContainer
local LWMainCityFightAlarmObj = BaseClass("LWMainCityFightAlarmObj", base)
local Localization = CS.GameEntry.Localization
local closeY = 30
local icon_path = "bg/Icon"
local closeBtn_path = "CloseBtn"
local desText_path = "DesText"
local subIcon_path = "SubIcon"
local jumpToBtn_path = "JumpToBtn"
local simpleAnim_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.subIcon = self:AddComponent(UIImage, subIcon_path)
  self.jumpToBtn = self:AddComponent(UIEventTrigger, jumpToBtn_path)
  self.simpleAnim = self:AddComponent(UISimpleAnimation, simpleAnim_path)
  self.closeBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.jumpToBtn:OnPointerClick(function(eventData)
    self:JumpToBtnClick(eventData)
  end)
  self.jumpToBtn:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.jumpToBtn:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.jumpToBtn:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.closeBtn = nil
  self.desText = nil
  self.subIcon = nil
  self.jumpToBtn = nil
  self.simpleAnim = nil
end

local function DataDefine(self)
  self.cityConfig = nil
  self.isUpdate = false
  self.isShow = false
  self.name = ""
  self.dragPosY = nil
  self.inAnimTimer = nil
  self.outAnimTimer = nil
  self.intAnimFinshReInit = false
end

local function DataDestroy(self)
  self.cityConfig = nil
  self.protectTime = 0
  self.isUpdate = nil
  self.isShow = nil
  self.name = nil
  self.dragPosY = nil
  self.inAnimTimer = nil
  self.outAnimTimer = nil
  self.intAnimFinshReInit = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
  base.OnRemoveListener(self)
end

local function OnAllianceQuitSuccess(self)
  self.isUpdate = false
  self:SetActiveState(false)
end

local function Update1000MS(self)
  if not self.isUpdate then
    return
  end
  self:RefreshTimeView()
end

local function ReInit(self, cityId)
  self.curDeclareCityId = cityId
  self.cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  self.protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(cityId))
  self.isUpdate = true
  self.dragPosY = nil
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.protectTime then
    self:ShowView()
  else
    self:SetActiveState(false)
  end
end

local function ShowView(self)
  if not self.isShow then
    self:SetActiveState(true)
    self:ShowCityView()
    if not self.inAnimTimer or not not self.inAnimTimer:IsOver() then
      local _, inTime = self.simpleAnim:PlayAnimationReturnTime("in")
      self.inAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      end, inTime)
    end
  end
  self:RefreshTimeView()
end

local function SetActiveState(self, isShow)
  self.isShow = isShow
  self.gameObject:SetActive(isShow)
end

local function ShowCityView(self)
  if not self.cityConfig then
    return
  end
  self.name = self.cityConfig:GetName()
  local iconPath = self.cityConfig:GetIconPath()
  self.icon:LoadSprite(iconPath)
  self.icon:SetNativeSize()
  self:RefreshTimeView()
end

local function RefreshTimeView(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.protectTime - curTime
  if surplusTime <= 0 then
    self:CloseBtnClick()
  else
    self.desText:SetLocalText("city_event_desc76", self.name, UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
  end
end

local function InnerClose(self)
  self.isUpdate = false
  self:SetActiveState(false)
  self.dragPosY = nil
end

local function CloseBtnClick(self)
  if not self.outAnimTimer or not not self.outAnimTimer:IsOver() then
    local _, outTime = self.simpleAnim:PlayAnimationReturnTime("out")
    self.outAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      InnerClose(self)
    end, outTime)
  end
end

local function JumpToBtnClick(self)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate and self.dragPosY == nil then
    local decalreBuildInfo = DataCenter.AllianceMineManager:GetAllianceS0CityFightDecalreMineInfo()
    local pos
    if decalreBuildInfo then
      pos = SceneUtils.IndexToTilePos(decalreBuildInfo.pointId, ForceChangeScene.World)
    end
    if pos then
      local v3 = SceneUtils.TileToWorld(pos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
    else
      UIUtil.ShowTipsId("city_event_desc74")
    end
  end
end

local function OnBeginDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate then
    self.dragPosY = eventData.position.y
  end
end

local function OnEndDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  self.dragPosY = nil
end

local function OnDrag(self, eventData)
  if self:IsPlayAnim() then
    return
  end
  if self.isUpdate and self.dragPosY and eventData.position.y - self.dragPosY >= closeY then
    self:CloseBtnClick()
  end
end

local function IsPlayAnim(self)
  local isPlay = false
  if not (not self.inAnimTimer or self.inAnimTimer:IsOver()) or self.outAnimTimer and not self.outAnimTimer:IsOver() then
    isPlay = true
  end
  return isPlay
end

LWMainCityFightAlarmObj.OnCreate = OnCreate
LWMainCityFightAlarmObj.OnDestroy = OnDestroy
LWMainCityFightAlarmObj.OnEnable = OnEnable
LWMainCityFightAlarmObj.OnDisable = OnDisable
LWMainCityFightAlarmObj.ComponentDefine = ComponentDefine
LWMainCityFightAlarmObj.ComponentDestroy = ComponentDestroy
LWMainCityFightAlarmObj.DataDefine = DataDefine
LWMainCityFightAlarmObj.DataDestroy = DataDestroy
LWMainCityFightAlarmObj.OnAddListener = OnAddListener
LWMainCityFightAlarmObj.OnRemoveListener = OnRemoveListener
LWMainCityFightAlarmObj.OnAllianceQuitSuccess = OnAllianceQuitSuccess
LWMainCityFightAlarmObj.Update1000MS = Update1000MS
LWMainCityFightAlarmObj.ReInit = ReInit
LWMainCityFightAlarmObj.ShowView = ShowView
LWMainCityFightAlarmObj.SetActiveState = SetActiveState
LWMainCityFightAlarmObj.ShowCityView = ShowCityView
LWMainCityFightAlarmObj.RefreshTimeView = RefreshTimeView
LWMainCityFightAlarmObj.CloseBtnClick = CloseBtnClick
LWMainCityFightAlarmObj.JumpToBtnClick = JumpToBtnClick
LWMainCityFightAlarmObj.OnBeginDrag = OnBeginDrag
LWMainCityFightAlarmObj.OnEndDrag = OnEndDrag
LWMainCityFightAlarmObj.OnDrag = OnDrag
LWMainCityFightAlarmObj.IsPlayAnim = IsPlayAnim
return LWMainCityFightAlarmObj
