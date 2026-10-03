local UIMainItemProgress = BaseClass("UIMainItemProgress", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local this_path = ""
local resource_icon_path = "root/resourceIcon"
local resource_num_path = "root/resourceNum"
local CountNumJumpTimes = 10
local ChangePerTime = 100
local DelayTime = 0.5

function UIMainItemProgress:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainItemProgress:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainItemProgress:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.resource_num = self:AddComponent(UIText, resource_num_path)
  self.btn:SetOnClick(function()
    if self.param.itemId ~= nil then
      self.view.ctrl:OnClickItemBtn(self.param.itemId)
    elseif self.param.resourceItemId ~= nil then
      self.view.ctrl:OnClickResourceItemBtn(self.param.resourceItemId)
    elseif self.param.aItemType == RewardType.ALLIANCE_DONATE then
      self:OnClickInfoBtn()
    end
  end)
end

function UIMainItemProgress:ComponentDestroy()
  self.btn = nil
  self.resource_icon = nil
  self.resource_num = nil
end

function UIMainItemProgress:DataDefine()
  self.param = {}
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  
  function self.delay_timer_action()
    self:DelayRefreshTimerBallBack()
  end
  
  self.delayTimer = nil
end

function UIMainItemProgress:DataDestroy()
  self:DeleteDelayRefreshTimer()
  self.param = {}
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  self.delay_timer_action = nil
  self.delayTimer = nil
end

function UIMainItemProgress:ReInit(param)
  self:DeleteDelayRefreshTimer()
  self.param = param
  self._resNumShow = self:GetCurNum()
  self._resNumTarget = self._resNumShow
  self.resource_icon:LoadSprite(self:GetIconName())
  self.resource_num:SetText(string.GetFormattedStr(self._resNumShow))
end

function UIMainItemProgress:Refresh()
  self:DoResNumChange()
end

function UIMainItemProgress:OnEnable()
  base.OnEnable(self)
end

function UIMainItemProgress:OnDisable()
  base.OnDisable(self)
end

function UIMainItemProgress:DoResNumChange()
  self._resNumTarget = self:GetCurNum()
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    self.resource_num:SetText(string.GetFormattedStr(self._resNumTarget))
  end
end

function UIMainItemProgress:GetCurNum()
  if self.param.itemId ~= nil then
    return DataCenter.ItemData:GetItemCount(self.param.itemId)
  elseif self.param.resourceItemId ~= nil then
    return DataCenter.ResourceItemDataManager:GetCountByItemId(self.param.resourceItemId)
  elseif self.param.aItemType ~= nil then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData ~= nil then
      if self.param.aItemType == RewardType.ALLIANCE_POINT then
        return baseData.alliancePoint
      elseif self.param.aItemType == RewardType.ALLIANCE_DONATE then
        return baseData.accPoint
      end
    end
  end
  return 0
end

function UIMainItemProgress:GetIconName()
  local iconPath = ""
  if self.param.itemId ~= nil then
    iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.param.itemId)
  elseif self.param.resourceItemId ~= nil then
    iconPath = DataCenter.ResourceItemDataManager:GetIconPath(self.param.resourceItemId)
  elseif self.param.aItemType ~= nil then
    iconPath = DataCenter.ResourceManager:GetResourceIconByType(self.param.aItemType, nil, nil, true)
    if string.IsNullOrEmpty(iconPath) then
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if baseData ~= nil then
        iconPath = DataCenter.ItemTemplateManager:GetAllianceItemIconPath(self.param.aItemType)
      end
    end
  end
  return iconPath
end

function UIMainItemProgress:Update()
  if self._resNumShow ~= self._resNumTarget then
    local tempT = UITimeManager:GetInstance():GetServerTime()
    local time = ChangePerTime
    if self.param and self.param.itemId == 200034 then
      time = ChangePerTime * 0.3
    end
    if time <= tempT - self._lastSetTime then
      self._lastSetTime = tempT
      self._resNumShow = self._resNumShow + self._resNumDelta
      if self._resNumDelta > 0 and self._resNumShow > self._resNumTarget then
        self._resNumShow = self._resNumTarget
      elseif self._resNumDelta < 0 and self._resNumShow < self._resNumTarget then
        self._resNumShow = self._resNumTarget
      end
      self.resource_num:SetText(string.GetFormattedSeperatorNum(self._resNumShow))
      if self._resNumShow == self._resNumTarget then
        self:AddDelayRefreshTimer()
      end
    end
  end
end

function UIMainItemProgress:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIMainItemProgress:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  self.resource_num:SetText(string.GetFormattedStr(self:GetCurNum()))
end

function UIMainItemProgress:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIMainItemProgress:GetResourcePos()
  return self.resource_icon.transform.position
end

function UIMainItemProgress:ChangeParam(param)
  self.param = param
  self:Refresh()
end

function UIMainItemProgress:OnClickInfoBtn()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.resource_icon.transform.position + Vector3.New(-5, -20, 0) * scaleFactor
  local strTitle, strContent
  if self.param.aItemType == RewardType.ALLIANCE_DONATE then
    strContent = Localization:GetString("391084")
  end
  local param = UIHeroTipView.Param.New()
  param.title = strTitle
  param.content = strContent
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

return UIMainItemProgress
