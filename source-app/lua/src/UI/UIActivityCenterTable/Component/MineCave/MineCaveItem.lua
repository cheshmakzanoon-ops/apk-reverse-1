local MineCaveItem = BaseClass("MineCaveItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local ownerContainer_path = "ownerBg"
local owner_path = "ownerBg/owner"
local mineName_path = "nameBg/mineName"
local mineLv_path = "nameBg/mineLv"
local bg_path = "bg"
local time_path = "timeBg"
local timeCd_path = "timeBg/time"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgBtnN = self:AddComponent(UIButton, bg_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickMineCave()
  end)
  self.iconN = self:AddComponent(UIImage, icon_path)
  self.ownerContainerN = self:AddComponent(UIBaseContainer, ownerContainer_path)
  self.ownerN = self:AddComponent(UIText, owner_path)
  self.mineNameN = self:AddComponent(UIText, mineName_path)
  self.mineLvN = self:AddComponent(UIText, mineLv_path)
  self.timeN = self:AddComponent(UIBaseContainer, time_path)
  self.timeCdN = self:AddComponent(UIText, timeCd_path)
end

local function ComponentDestroy(self)
  self.bgBtnN = nil
  self.iconN = nil
  self.ownerN = nil
  self.mineNameN = nil
  self.mineLvN = nil
end

local function DataDefine(self)
  self.mineInfo = nil
end

local function DataDestroy(self)
  self.mineInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, mineInfo)
  self.mineInfo = mineInfo
  self.mineIndex = mineInfo.index
  self:RefreshAll()
end

local function RefreshAll(self)
  if not self.mineInfo then
    return
  end
  local conf = DataCenter.MineCaveManager:GetMineConf(self.mineInfo.mineId)
  self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", conf.picture))
  if string.IsNullOrEmpty(self.mineInfo.ownerUid) then
    self:DelCountDownTimer()
    self.ownerContainerN:SetActive(false)
  else
    self.ownerContainerN:SetActive(true)
    if string.IsNullOrEmpty(self.mineInfo.allianceAbbr) then
      self.ownerN:SetText(self.mineInfo.ownerName)
    else
      self.ownerN:SetText("[" .. self.mineInfo.allianceAbbr .. "]" .. self.mineInfo.ownerName)
    end
    if self.mineInfo.ownerUid == LuaEntry.Player.uid then
      self.ownerN:SetColor(Color.New(0.5333333333333333, 0.8941176470588236, 0.21568627450980393, 1))
    elseif self.mineInfo.allianceId == LuaEntry.Player.allianceId then
      self.ownerN:SetColor(Color.New(0.27450980392156865, 0.8549019607843137, 1.0, 1))
    else
      self.ownerN:SetColor(Color.New(1.0, 0.4823529411764706, 0.42745098039215684, 1))
    end
    self:AddCountDownTimer()
    self:RefreshRemainTime()
  end
  self.mineLvN:SetText(conf.level)
  self.mineNameN:SetText(Localization:GetString(conf.name))
  if not string.IsNullOrEmpty(self.mineInfo.ownerUid) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local delayTimeS = math.ceil((self.mineInfo.endTime - curTime) / 1000)
    if delayTimeS <= 0 then
      self.mineInfo.ownerUid = nil
      EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo)
    else
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.mineInfo.ownerUid = nil
        EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo)
      end, delayTimeS)
    end
  end
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.timeN:SetActive(true)
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  if not self.mineInfo then
    self:DelCountDownTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.mineInfo.endTime - curTime
  if 0 < remainTime then
    self.timeCdN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.timeCdN:SetText("")
    self:RefreshAll()
    self:DelCountDownTimer()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
  self.timeN:SetActive(false)
end

local function OnClickMineCave(self)
  local conf = DataCenter.MineCaveManager:GetMineConf(self.mineInfo.mineId)
  DataCenter.MineCaveManager:SetAttackMineIndex(self.mineIndex, conf.monsterId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveTips, {anim = true}, 2, self.mineIndex, self.iconN)
end

MineCaveItem.OnCreate = OnCreate
MineCaveItem.OnDestroy = OnDestroy
MineCaveItem.ComponentDefine = ComponentDefine
MineCaveItem.ComponentDestroy = ComponentDestroy
MineCaveItem.DataDefine = DataDefine
MineCaveItem.DataDestroy = DataDestroy
MineCaveItem.OnAddListener = OnAddListener
MineCaveItem.OnRemoveListener = OnRemoveListener
MineCaveItem.SetItem = SetItem
MineCaveItem.RefreshAll = RefreshAll
MineCaveItem.AddCountDownTimer = AddCountDownTimer
MineCaveItem.RefreshRemainTime = RefreshRemainTime
MineCaveItem.DelCountDownTimer = DelCountDownTimer
MineCaveItem.OnClickMineCave = OnClickMineCave
return MineCaveItem
