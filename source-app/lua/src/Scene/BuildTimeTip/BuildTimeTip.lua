local BuildTimeTip = BaseClass("BuildTimeTip")
local time_text_path = "GameObject/PosGo/TimeText"
local bg_path = "GameObject/PosGo/Bg"
local slider_path = "GameObject/PosGo/Bg/Slider"
local add_speed_btn_path = "GameObject/PosGo/AddSpeedBtn"
local icon_bg_path = "GameObject/PosGo/IconBg"
local icon_path = "GameObject/PosGo/IconBg/Icon"
local pos_go_path = "GameObject/PosGo"
local SliderLength2 = Vector2.New(2.59, 0.63)
local SliderLength1 = Vector2.New(2.59, 0.63)
local IconBgResetScale = Vector3.New(1, 1, 1)
local BgSpeedPosition = Vector3.New(-0.71, 0.499, 0)
local BgNoSpeedPosition = Vector3.New(-0.22, 0.499, 0)
local TimeSpeedPosition = Vector3.New(-0.71, 0.4, 0)
local TimeNoSpeedPosition = Vector3.New(-0.22, 0.4, 0)
local FarmBgScale = Vector3.New(1.5, 1.5, 1.5)
local NormalBgScale = Vector3.New(1.0, 1.0, 1.0)
local BgFarmPosition = Vector3.New(-1.0, 0.499, 0)
local BgNormalPosition = Vector3.New(-0.55, 0.499, 0)
local TimeFarmPosition = Vector3.New(-1.0, 0.339, 0)
local TimeNormalPosition = Vector3.New(-0.55, 0.339, 0)
local WaitChangeAlphaTime = 5

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.icon_bg = self.transform:Find(icon_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.bg = self.transform:Find(bg_path)
  self.add_speed_btn = self.transform:Find(add_speed_btn_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.add_speed_btn.onPointerClick()
    self:OnAddSpeedClick()
  end
  
  self.pos_go = self.transform:Find(pos_go_path)
end

local function ComponentDestroy(self)
  self.add_speed_btn.onPointerClick = nil
  self.add_speed_btn = nil
  self.time_text = nil
  self.slider = nil
  self.icon_bg = nil
  self.icon = nil
  self.bg = nil
  self.pos_go = nil
  self:HideWater()
end

local function DataDefine(self)
  self.param = nil
  self.lastTime = 0
  self.sliderInterVal = 0
  self.curPosition = nil
  self.index = nil
  self.timeText = nil
  self.sliderSpriteSize = nil
  self.desText = nil
  self.costNum = 0
  self.precessSize = nil
  self.curSize = nil
  self.showIndex = 1
  self.showListType = {}
  self.waitChangeAlpha = 0
  self.iconName = nil
end

local function DataDestroy(self)
  self.param = nil
  self.lastTime = nil
  self.sliderInterVal = nil
  self.sliderSize = nil
  self.curPosition = nil
  self.index = nil
  self.timeText = nil
  self.sliderSpriteSize = nil
  self.desText = nil
  self.request = nil
  self.precessSize = nil
  self.curSize = nil
  self.isShowTime = nil
  self.showIndex = nil
  self.showListType = nil
  self.waitChangeAlpha = nil
  self.iconName = nil
end

local function ReInit(self, paramList)
  local param = paramList[1]
  self:RefreshActive(true)
  self.param = param
  self.curSize = Vector2.New(SliderLength2.x, SliderLength2.y)
  self.lastTime = 0
  self.firstConfirm = false
  self.sendMessage = false
  self.time_text:SetColorAlpha(1)
  self.waitChangeAlpha = 0
  self:ShowPanel()
end

local function ShowPanel(self)
  self.iconName = nil
  self.showListType = {}
  self.showIndex = 1
  table.insert(self.showListType, UIBuildTimeTextShowType.Time)
  if self.param.desName ~= nil and self.param.desName ~= "" then
    table.insert(self.showListType, UIBuildTimeTextShowType.Des)
  end
  if self.param.buildTimeType ~= BuildTimeType.BuildTime_tradingCenter then
    if self.param.showGold ~= nil and self.param.showGold == true then
      self.add_speed_btn.gameObject:SetActive(true)
      if self.param.tileX == BuildTilesSize.One then
        self.bg.transform.localScale = FarmBgScale / 2
        self.bg.transform.localPosition = BgSpeedPosition
        self.time_text.transform.localPosition = TimeSpeedPosition
      elseif self.param.buildTimeType == BuildTimeType.BuildTime_pasture then
        self.bg.transform.localScale = NormalBgScale
        self.bg.transform.localPosition = BgFarmPosition
        self.time_text.transform.localPosition = TimeFarmPosition
      else
        self.bg.transform.localScale = FarmBgScale
        self.bg.transform.localPosition = BgFarmPosition
        self.time_text.transform.localPosition = TimeFarmPosition
      end
    else
      self.add_speed_btn.gameObject:SetActive(false)
      if self.param.tileX == BuildTilesSize.One then
        self.bg.transform.localScale = NormalBgScale / 2
        self.bg.transform.localPosition = BgNoSpeedPosition
        self.time_text.transform.localPosition = TimeNoSpeedPosition
      else
        self.bg.transform.localScale = NormalBgScale
        self.bg.transform.localPosition = BgNormalPosition
        self.time_text.transform.localPosition = TimeNormalPosition
      end
    end
    if self.param.iconBg == nil then
      self.icon_bg.gameObject:SetActive(false)
    else
      self.icon_bg:LoadSprite(self.param.iconBg)
      Logger.Log("time icon", self.param.iconBg)
      if self.param.iconBgScale == nil then
        self.icon_bg.transform.localScale = IconBgResetScale
      elseif self.param.tileX == BuildTilesSize.One then
        self.icon_bg.transform.localScale = self.param.iconBgScale / 2
      else
        self.icon_bg.transform.localScale = self.param.iconBgScale
      end
      self.icon_bg.gameObject:SetActive(true)
    end
    if self.param.iconName == nil then
      self.icon.gameObject:SetActive(false)
    else
      self:SetIconSprite(self.param.iconName)
      if self.param.iconScale == nil then
        self.icon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      else
        self.icon.transform.localScale = self.param.iconScale
      end
      self.icon.gameObject:SetActive(true)
    end
  end
  if self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  if self.param.endTime ~= nil and self.param.startTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    local maxTime = self.param.endTime - self.param.startTime
    self:RefreshSliderInterVal()
    local tempValue = 1 - changeTime / maxTime
    self:RefreshSlider(tempValue)
    local tempTimeSec = math.ceil(changeTime / 1000)
    if tempTimeSec ~= self.lastTime then
      self.lastTime = tempTimeSec
      self:ShowText()
    end
  end
  self:ShowWater()
end

local function RefreshSliderInterVal(self)
  if self.param.endTime ~= nil and self.param.startTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    local temp = changeTime / (SliderLength2.x * 2)
    temp = math.modf(temp / 10)
    temp = temp - temp % 5
    self.sliderInterVal = temp * 10
  end
end

local function RefreshSlider(self, value)
  if 0 <= value and value <= 1 then
    local newSize_x = self.precessSize.x * value
    if not float_equal(newSize_x, self.curSize.x) then
      self.curSize.x = newSize_x
      self.slider:Set_size(self.curSize.x, self.curSize.y)
    end
  end
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    if self.param.tileX == BuildTilesSize.One then
      self.precessSize = Vector2.New(SliderLength1.x, SliderLength1.y)
    elseif self.param.tileX == BuildTilesSize.Two then
      self.precessSize = Vector2.New(SliderLength2.x, SliderLength2.y)
    elseif self.param.tileX == BuildTilesSize.Three then
      self.precessSize = Vector2.New(SliderLength2.x, SliderLength2.y)
    else
      self.precessSize = Vector2.New(SliderLength2.x, SliderLength2.y)
    end
    local worldPos = BuildingUtils.GetBuildModelDownVec(index, 0, self.param.tileY)
    self.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
  end
end

local function RefreshTime(self, value)
  if self.lastTime ~= value then
    self.lastTime = value
    self:ShowText()
  end
end

local function OnAddSpeedClick(self)
  if self.param.queueUuid ~= nil then
    local guideParam = {}
    guideParam.buildTimeType = self.param.buildTimeType
    DataCenter.GuideManager:SetCompleteNeedParam(guideParam)
    DataCenter.GuideManager:CheckGuideComplete()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeedUpConfirm, self.param.endTime, self.param.iconName, MsgDefines.QueueCcdMNew, self.param.queueUuid, self.param.speedItem)
  end
end

local function ChangeShowTime(self)
  self.showIndex = self.showIndex + 1
  if table.count(self.showListType) < self.showIndex then
    self.showIndex = 1
  end
end

local function ShowText(self)
  if self.showListType[self.showIndex] == UIBuildTimeTextShowType.Time then
    local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(self.lastTime * 1000)
    if self.param.buildTimeType == BuildTimeType.BuildTime_tradingCenter then
      if self.lastTime <= 0 then
        self:SetIconSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.NoGetResource))
        if self.param.buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
          EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
          return
        end
      else
        self:SetIconSprite(string.format(LoadPath.CommonNewPath, BuildBubbleIconName.EarthOrderClock))
      end
    end
    self.time_text.text = tempTimeValue
  elseif self.showListType[self.showIndex] == UIBuildTimeTextShowType.Des then
    self.time_text.text = self.param.desName
  end
end

local function RefreshUpdate(self, isAddAlpha, alphaValue)
  if table.count(self.showListType) > 1 then
    if self.isAddAlpha ~= isAddAlpha then
      self.isAddAlpha = isAddAlpha
      if self.isAddAlpha then
        self:ChangeShowTime()
        self:ShowText()
      end
    end
    self.waitChangeAlpha = self.waitChangeAlpha + 1
    if self.waitChangeAlpha > WaitChangeAlphaTime then
      self.waitChangeAlpha = 0
      self.time_text:SetColorAlpha(alphaValue)
    end
  end
end

local function SetIconSprite(self, iconName)
  if self.iconName ~= iconName then
    self.iconName = iconName
    self.icon:LoadSprite(iconName)
  end
end

local function ShowWater(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
    local param = {}
    param.list = {
      ResourceType.Water
    }
    param.uiName = "BuildTimeTip"
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  end
end

local function HideWater(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
    EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, "BuildTimeTip")
  end
end

local function GetGuideObj(self)
  return self.add_speed_btn.gameObject
end

local function RefreshActive(self, isActive)
  self.pos_go.gameObject:SetActive(isActive)
end

local function CheckIfTimeTipExist(self, paramList)
  if paramList and 0 < #paramList then
    local tempParam = paramList[1]
    if self.param.model == tempParam.model then
      return true
    end
  end
  return false
end

BuildTimeTip.OnCreate = OnCreate
BuildTimeTip.OnDestroy = OnDestroy
BuildTimeTip.ComponentDefine = ComponentDefine
BuildTimeTip.ComponentDestroy = ComponentDestroy
BuildTimeTip.DataDefine = DataDefine
BuildTimeTip.DataDestroy = DataDestroy
BuildTimeTip.ReInit = ReInit
BuildTimeTip.ShowPanel = ShowPanel
BuildTimeTip.RefreshSlider = RefreshSlider
BuildTimeTip.UpdatePosition = UpdatePosition
BuildTimeTip.RefreshSliderInterVal = RefreshSliderInterVal
BuildTimeTip.RefreshTime = RefreshTime
BuildTimeTip.OnAddSpeedClick = OnAddSpeedClick
BuildTimeTip.ShowText = ShowText
BuildTimeTip.ChangeShowTime = ChangeShowTime
BuildTimeTip.RefreshUpdate = RefreshUpdate
BuildTimeTip.SetIconSprite = SetIconSprite
BuildTimeTip.ShowWater = ShowWater
BuildTimeTip.HideWater = HideWater
BuildTimeTip.GetGuideObj = GetGuideObj
BuildTimeTip.RefreshActive = RefreshActive
BuildTimeTip.CheckIfTimeTipExist = CheckIfTimeTipExist
return BuildTimeTip
