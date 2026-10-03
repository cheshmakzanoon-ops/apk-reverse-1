local UICityAttackS0CityToggleItem = BaseClass("UICityAttackS0CityToggleItem", UIBaseContainer)
local base = UIBaseContainer
local Toggle_path = ""
local UnLockNormal_path = "Background/UnLockNormal"
local DayNumText1_path = UnLockNormal_path .. "/DayNumText1"
local DayText1_path = UnLockNormal_path .. "/DayText1"
local UnLockSelect_path = "Background/UnLockSelect"
local DayNumText2_path = UnLockSelect_path .. "/DayNumText2"
local DayText2_path = UnLockSelect_path .. "/DayText2"
local LockNormal_path = "Background/LockNormal"
local DayText3_path = LockNormal_path .. "/DayText3"
local LockImg1_path = LockNormal_path .. "/LockImg1"
local LockSelect_path = "Background/LockSelect"
local DayText4_path = LockSelect_path .. "/DayText4"
local LockImg2_path = LockSelect_path .. "/LockImg2"
local Red_path = "Red"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.toggle = self:AddComponent(UIToggle, Toggle_path)
  self.redPoint = self:AddComponent(UIImage, Red_path)
  self.unLockNormal = self:AddComponent(UIBaseContainer, UnLockNormal_path)
  self.unLockSelect = self:AddComponent(UIBaseContainer, UnLockSelect_path)
  self.lockNormal = self:AddComponent(UIBaseContainer, LockNormal_path)
  self.lockSelect = self:AddComponent(UIBaseContainer, LockSelect_path)
  self.dayText1 = self:AddComponent(UITextMeshProUGUIEx, DayText1_path)
  self.dayText2 = self:AddComponent(UITextMeshProUGUIEx, DayText2_path)
  self.dayText3 = self:AddComponent(UITextMeshProUGUIEx, DayText3_path)
  self.dayText4 = self:AddComponent(UITextMeshProUGUIEx, DayText4_path)
  self.dayNumText1 = self:AddComponent(UITextMeshProUGUIEx, DayNumText1_path)
  self.dayNumText2 = self:AddComponent(UITextMeshProUGUIEx, DayNumText2_path)
  self.lockImg1 = self:AddComponent(UIImage, LockImg1_path)
  self.lockImg2 = self:AddComponent(UIImage, LockImg2_path)
  self.toggle:SetOnValueChanged(function(tf)
    if tf then
      self.toggleCallback()
    end
  end)
  self.dayText1:SetLocalText("city_war_battle_pass_10")
  self.dayText2:SetLocalText("city_war_battle_pass_10")
  self.dayText3:SetLocalText("city_war_battle_pass_10")
  self.dayText4:SetLocalText("city_war_battle_pass_10")
end

local function DataDefine(self)
  self.isShowRed = false
  self.isSelect = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.toggle = nil
  self.LockImg = nil
  self.DayNumText1 = nil
  self.DayText1 = nil
  self.DayNumText2 = nil
  self.DayText2 = nil
  self.DayText1Color = nil
  self.DayText2Color = nil
end

local function DataDestroy(self)
  self.index = nil
  self.toggleCallback = nil
  self.isLock = nil
  self.isShowRed = nil
  self.isSelect = nil
  self.countDown = nil
  self.curMaxCityLevel = nil
  self.nextStateTime = nil
end

local function OnDestroy(self)
  self:RemoveUpdateTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, index, toggleCallback)
  self.index = index
  self.toggleCallback = toggleCallback
  self.dayNumText1:SetLocalText("city_war_battle_pass_11", self.index)
  self.dayNumText2:SetLocalText("city_war_battle_pass_11", self.index)
end

local function ReInit(self, isLock, index)
  self.curMaxCityLevel = DataCenter.AttackCityS0DataManager:GetMaxCityLevel() + 1
  if index and index - 1 == self.curMaxCityLevel then
    self.countDown = true
    self.cityLevel, self.nextStateTime = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
    if self.updateTimer == nil then
      function self.updateTimer()
        self:TimeCountDown()
      end
      
      UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
  end
  self.isLock = isLock
  self.isSelect = false
  self:OnSelect(false)
  self.isShowRed = DataCenter.AttackCityS0DataManager:GetBattlePassCityRedPoint(self.index)
  self.redPoint:SetActive(self.isShowRed and not self.isSelect)
end

local function OnSelect(self, isSelect)
  self.isSelect = isSelect
  self.toggle:SetIsOn(isSelect)
  self.unLockNormal:SetActive(not self.isLock and not isSelect)
  self.unLockSelect:SetActive(not self.isLock and isSelect)
  self.lockNormal:SetActive(self.isLock and not isSelect)
  self.lockSelect:SetActive(self.isLock and isSelect)
  self.redPoint:SetActive(self.isShowRed and not self.isSelect)
end

local function ShowRed(self, isShow)
  self.isShowRed = isShow
  self.redPoint:SetActive(isShow and not self.isSelect)
end

local function UpdateRed(self)
  self.isShowRed = DataCenter.AttackCityS0DataManager:GetBattlePassCityRedPoint(self.index)
  self.redPoint:SetActive(self.isShowRed and not self.isSelect)
end

function UICityAttackS0CityToggleItem:TimeCountDown()
  if self.countDown then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.nextStateTime - curTime
    if leftTime < 0 then
      leftTime = 0
      self.countDown = false
      self.isLock = false
      self:OnSelect(self.isSelect)
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.dayText3:SetText(countDownTimeStr)
  end
end

local function RemoveUpdateTimer(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

UICityAttackS0CityToggleItem.OnCreate = OnCreate
UICityAttackS0CityToggleItem.OnEnable = OnEnable
UICityAttackS0CityToggleItem.OnAddListener = OnAddListener
UICityAttackS0CityToggleItem.OnRemoveListener = OnRemoveListener
UICityAttackS0CityToggleItem.OnDisable = OnDisable
UICityAttackS0CityToggleItem.ComponentDefine = ComponentDefine
UICityAttackS0CityToggleItem.ComponentDestroy = ComponentDestroy
UICityAttackS0CityToggleItem.DataDefine = DataDefine
UICityAttackS0CityToggleItem.DataDestroy = DataDestroy
UICityAttackS0CityToggleItem.OnDestroy = OnDestroy
UICityAttackS0CityToggleItem.SetData = SetData
UICityAttackS0CityToggleItem.ReInit = ReInit
UICityAttackS0CityToggleItem.OnSelect = OnSelect
UICityAttackS0CityToggleItem.ShowRed = ShowRed
UICityAttackS0CityToggleItem.UpdateRed = UpdateRed
UICityAttackS0CityToggleItem.RemoveUpdateTimer = RemoveUpdateTimer
return UICityAttackS0CityToggleItem
