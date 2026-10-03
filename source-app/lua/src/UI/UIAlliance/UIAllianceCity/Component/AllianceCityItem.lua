local AllianceCityItem = BaseClass("AllianceCityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local cityLvTxt_path = "icon/level"
local cityNameTxt_path = "cityInfo/cityName"
local cityDescTxt_path = "cityInfo/desc"
local cityHpProg_path = "cityInfo/hp"
local cityPosTxt_path = "icon/position"
local cityPosBtn_path = "icon/position/posBtn"
local jumpBtn_path = "Btns/jumpBtn"
local giveUpBtn_path = "Btns/jumpBtn/giveUpBtn"
local givingUpContainer_path = "givingUp"
local givingUpTxt_path = "givingUp/giveUpTxt"
local givingUpTimeTxt_path = "givingUp/time"
local change_name_btn_path = "cityInfo/Image/changeBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelGivingUpTimer()
  self:DelCityHpTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.cityLvTxtN = self:AddComponent(UIText, cityLvTxt_path)
  self.cityNameTxtN = self:AddComponent(UIText, cityNameTxt_path)
  self.cityDescTxtN = self:AddComponent(UIText, cityDescTxt_path)
  self.cityHpProgN = self:AddComponent(UISlider, cityHpProg_path)
  self.cityPosTxtN = self:AddComponent(UIText, cityPosTxt_path)
  self.cityPosBtnN = self:AddComponent(UIButton, cityPosBtn_path)
  self.cityPosBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.change_btn = self:AddComponent(UIButton, change_name_btn_path)
  self.change_btn:SetOnClick(function()
    self:OnChangeClick()
  end)
  self.giveUpBtnN = self:AddComponent(UIButton, giveUpBtn_path)
  self.giveUpBtnN:SetOnClick(function()
    self:OnClickGiveUpBtn()
  end)
  self.givingUpContainerN = self:AddComponent(UIBaseContainer, givingUpContainer_path)
  self.givingUpTxtN = self:AddComponent(UIText, givingUpTxt_path)
  self.givingUpTxtN:SetLocalText(300722)
  self.givingUpTimeTxtN = self:AddComponent(UIText, givingUpTimeTxt_path)
end

local function ComponentDestroy(self)
  self.cityLvTxtN = nil
  self.cityNameTxtN = nil
  self.cityDescTxtN = nil
  self.cityHpProgN = nil
  self.cityPosTxtN = nil
  self.jumpBtnN = nil
  self.giveUpBtnN = nil
  self.givingUpContainerN = nil
  self.givingUpTxtN = nil
  self.givingUpTimeTxtN = nil
  self.change_btn = nil
end

local function DataDefine(self)
  self.curCityId = nil
  self.maxDurability = nil
  self.cityRecoverSpeed = nil
  self.durability = nil
  self.lastDurabilityTime = nil
  self.givingUpEndTime = nil
  self.isGivingUp = nil
  
  function self.cityHp_timerAction()
    self:CityHpTimerAction()
  end
  
  function self.givingUp_timerAction()
    self:GivingUpTimerAction()
  end
end

local function DataDestroy(self)
  self.curCityId = nil
  self.maxDurability = nil
  self.cityRecoverSpeed = nil
  self.durability = nil
  self.lastDurabilityTime = nil
  self.givingUpEndTime = nil
  self.isGivingUp = nil
end

local function ShowCity(self, cityId)
  self.curCityId = cityId
  local cityData = LocalController:instance():getLine(TableName.WorldCity, self.curCityId)
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
  if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
    self.cityNameTxtN:SetText(cityInfo.cityName)
  else
    self.cityNameTxtN:SetLocalText(cityData.name)
  end
  self.cityLvTxtN:SetText(cityData.level)
  self.cityDescTxtN:SetText(self.view.ctrl:GetAllianceCityBuff(self.curCityId))
  local cityLoc = string.split(cityData.location, "|")
  self.cityPosTxtN:SetLocalText(300015, cityLoc[1], cityLoc[2])
  self.giveUpBtnN:SetActive(DataCenter.AllianceBaseDataManager:IsSelfLeader())
  self:SetCityHp()
  self:SetGivingUp()
end

local function SetCityHp(self)
  self:DelCityHpTimer()
  local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, self.curCityId)
  if cityTemplate then
    self.maxDurability = cityTemplate:getValue("wall")
    self.cityRecoverSpeed = cityTemplate:getValue("wall_recover")
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
    self.lastDurabilityTime = cityInfo.lastDurabilityTime
    self.durability = cityInfo.durability
    if self.durability >= self.maxDurability then
      self.cityHpProgN:SetValue(1)
    else
      self:AddCityHpTimer()
    end
  end
end

local function SetGivingUp(self)
  self:DelGivingUpTimer()
  local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
  if myAlCityInfo.giveUpEndTime and myAlCityInfo.giveUpEndTime > 0 then
    self.givingUpContainerN:SetActive(true)
    self.givingUpEndTime = myAlCityInfo.giveUpEndTime
    self:AddGivingUpTimer()
    self.isGivingUp = true
  else
    self.givingUpContainerN:SetActive(false)
    self.isGivingUp = false
  end
end

local function AddCityHpTimer(self)
  if self.cityHpTimer == nil then
    self.cityHpTimer = TimerManager:GetInstance():GetTimer(1, self.cityHp_timerAction, self, false, false, false)
  end
  self:CityHpTimerAction()
  self.cityHpTimer:Start()
end

local function CityHpTimerAction(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local addNum = (curTime - self.lastDurabilityTime / 1000) * tonumber(self.cityRecoverSpeed)
  local realDurabilityNum = self.durability + math.max(addNum, 0)
  local curNum = math.min(realDurabilityNum, self.maxDurability)
  local percent = curNum / self.maxDurability
  self.cityHpProgN:SetValue(percent)
end

local function DelCityHpTimer(self)
  if self.cityHpTimer ~= nil then
    self.cityHpTimer:Stop()
    self.cityHpTimer = nil
  end
end

local function AddGivingUpTimer(self)
  if self.givingUpTimer == nil then
    self.givingUpTimer = TimerManager:GetInstance():GetTimer(1, self.givingUp_timerAction, self, false, false, false)
  end
  self.givingUpTimer:Start()
  self:GivingUpTimerAction()
end

local function GivingUpTimerAction(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local remainTimeMs = self.givingUpEndTime - serverTime
  if 0 < remainTimeMs then
    local strT = UITimeManager:GetInstance():MilliSecondToFmtString(remainTimeMs)
    self.givingUpTimeTxtN:SetText(strT)
  else
    self.givingUpTimeTxtN:SetText("")
    self:DelGivingUpTimer()
  end
end

local function DelGivingUpTimer(self)
  if self.givingUpTimer ~= nil then
    self.givingUpTimer:Stop()
    self.givingUpTimer = nil
  end
end

local function OnClickJumpBtn(self)
  local cityData = LocalController:instance():getLine(TableName.WorldCity, self.curCityId)
  local cityLoc = string.split(cityData.location, "|")
  local v2 = CS.UnityEngine.Vector2Int(tonumber(cityLoc[1]), tonumber(cityLoc[2]))
  local posIndex = SceneUtils.TilePosToIndex(v2, ForceChangeScene.World)
  local worldPosition = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World)
  self.view.ctrl:JumpToTargetPoint(worldPosition)
end

local function OnClickGiveUpBtn(self)
  if self.isGivingUp then
    self.view.ctrl:RequestGiveUpAlCity(self.curCityId, true)
  else
    local strName = ""
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
    if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      strName = cityInfo.cityName
    else
      local name = GetTableData(TableName.WorldCity, self.curCityId, "name")
      strName = Localization:GetString(name)
    end
    local lv = GetTableData(TableName.WorldCity, self.curCityId, "level")
    UIUtil.ShowMessage(Localization:GetString("300723", lv, strName), 2, nil, nil, function()
      self.view.ctrl:RequestGiveUpAlCity(self.curCityId, false)
    end, nil, nil)
  end
end

local function OnChangeName(self, data)
  local cityId = data
  if self.curCityId == cityId then
    local cityData = LocalController:instance():getLine(TableName.WorldCity, self.curCityId)
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
    if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      self.cityNameTxtN:SetText(cityInfo.cityName)
    else
      self.cityNameTxtN:SetLocalText(cityData.name)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCityNameChange, self.OnChangeName)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceCityNameChange, self.OnChangeName)
  base.OnRemoveListener(self)
end

local function OnChangeClick(self)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.curCityId)
    if cityInfo ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChangeAllianceCityName, self.curCityId, cityInfo.changeNameTime, cityInfo.cityName)
    end
  else
    UIUtil.ShowTipsId(120173)
  end
end

AllianceCityItem.OnCreate = OnCreate
AllianceCityItem.OnDestroy = OnDestroy
AllianceCityItem.ComponentDefine = ComponentDefine
AllianceCityItem.ComponentDestroy = ComponentDestroy
AllianceCityItem.DataDefine = DataDefine
AllianceCityItem.DataDestroy = DataDestroy
AllianceCityItem.ShowCity = ShowCity
AllianceCityItem.SetCityHp = SetCityHp
AllianceCityItem.AddCityHpTimer = AddCityHpTimer
AllianceCityItem.CityHpTimerAction = CityHpTimerAction
AllianceCityItem.DelCityHpTimer = DelCityHpTimer
AllianceCityItem.AddGivingUpTimer = AddGivingUpTimer
AllianceCityItem.GivingUpTimerAction = GivingUpTimerAction
AllianceCityItem.DelGivingUpTimer = DelGivingUpTimer
AllianceCityItem.SetGivingUp = SetGivingUp
AllianceCityItem.OnAddListener = OnAddListener
AllianceCityItem.OnRemoveListener = OnRemoveListener
AllianceCityItem.OnClickJumpBtn = OnClickJumpBtn
AllianceCityItem.OnClickGiveUpBtn = OnClickGiveUpBtn
AllianceCityItem.OnChangeName = OnChangeName
AllianceCityItem.OnChangeClick = OnChangeClick
return AllianceCityItem
