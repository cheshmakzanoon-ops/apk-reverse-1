local ActZoneMobilizationItem = BaseClass("ActZoneMobilizationItem", UIBaseContainer)
local base = UIBaseContainer
local UITimeManager = _ENV.UITimeManager
local UIMainCommonTips = require("UI.LWMainUI.Component.UIMainTop.UIMainCommonTips")
local click_path = "Click"
local count_down_text_path = "Click/TimeBg/CountDownText"
local common_t_ips_clone_path = "CommonTIps"
local redDot_path = "Click/RedPoint"
local icon_path = "Click/Icon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.zone_mobilization_btn = self:AddComponent(UIButton, "")
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.count_down_text = self:AddComponent(UITextMeshProUGUIEx, count_down_text_path)
  self.common_t_ips = self:AddComponent(UIMainCommonTips, common_t_ips_clone_path)
  self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.zone_mobilization_btn = nil
  self.click = nil
  self.count_down_text = nil
  self.common_t_ips = nil
  self.redDot = nil
  self.icon = nil
end

local function DataDefine(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.OnGovernmentPresidentRefresh)
  self:AddUIListener(EventId.OnZoneMobilizationRedPointChanged, self.OnRedPointRefresh)
  self.isActivityOpen = nil
  self.endTime = nil
end

local function DataDestroy(self)
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.OnGovernmentPresidentRefresh)
  self:RemoveUIListener(EventId.OnZoneMobilizationRedPointChanged, self.OnRedPointRefresh)
  self.isActivityOpen = nil
  self.endTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  local isActivityOpen = DataCenter.LWZoneMobilizationManager:IsActivityOpen()
  local level = DataCenter.LWZoneMobilizationManager:GetLimitLevel()
  if level > DataCenter.BuildManager:GetMainLevel() then
    self.zone_mobilization_btn:SetActive(false)
    return
  end
  self.zone_mobilization_btn:SetActive(isActivityOpen)
  if not isActivityOpen then
    return
  end
  self.isActivityOpen = isActivityOpen
  local showTips = DataCenter.LWZoneMobilizationManager:CheckShowPlaceRemind()
  if showTips then
    local param = {
      tips = "zone_mobilization_tips_unbuilt_short",
      btn_name = "zone_mobilization_stage_go_btn",
      condition = MainUITipCondition.ZoneMobilization
    }
    self.common_t_ips:Refresh(param)
  end
  self.common_t_ips:SetActive(showTips)
  local endTime = DataCenter.LWZoneMobilizationManager.endTime
  self.endTime = endTime
  self.icon:LoadSpriteAsync(string.format(LoadPath.LWUIZoneMobilizationSpritePath, "lrb_zhanqvdongyuan_rukou"))
  self:RefreshView(endTime)
end

local function RefreshView(self, endTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  endTime = endTime or 0
  local remainTime = endTime - curTime
  self.isActivityOpen = self.isActivityOpen and 0 < remainTime
  self.endTime = endTime
  self.count_down_text:SetActive(self.isActivityOpen)
  self.redDot:SetActive(DataCenter.LWZoneMobilizationManager:ShowRedPoint())
end

local function Update100MS(self)
  if self.isActivityOpen then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.count_down_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.count_down_text:SetActive(false)
      self.isActivityOpen = false
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
    end
  end
end

local function OnBtnClick(self)
  if self.isActivityOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationMain)
  end
end

function ActZoneMobilizationItem:OnGovernmentPresidentRefresh()
  self:ReInit()
end

function ActZoneMobilizationItem:OnRedPointRefresh()
  self.redDot:SetActive(DataCenter.LWZoneMobilizationManager:ShowRedPoint())
end

ActZoneMobilizationItem.OnCreate = OnCreate
ActZoneMobilizationItem.OnDestroy = OnDestroy
ActZoneMobilizationItem.OnEnable = OnEnable
ActZoneMobilizationItem.OnDisable = OnDisable
ActZoneMobilizationItem.ComponentDefine = ComponentDefine
ActZoneMobilizationItem.ComponentDestroy = ComponentDestroy
ActZoneMobilizationItem.DataDefine = DataDefine
ActZoneMobilizationItem.DataDestroy = DataDestroy
ActZoneMobilizationItem.Update100MS = Update100MS
ActZoneMobilizationItem.ReInit = ReInit
ActZoneMobilizationItem.RefreshView = RefreshView
ActZoneMobilizationItem.OnBtnClick = OnBtnClick
return ActZoneMobilizationItem
