local BuildTimeTipFarm = BaseClass("BuildTimeTipFarm")
local cost_txt_path = "GameObject/PosGo/AddSpeedBtn/costTxt"
local progress_path = "GameObject/PosGo/Bg/Progress/"
local time_text_path = "GameObject/PosGo/Bg/Progress/TimeText"
local slider_path = "GameObject/PosGo/Bg/Progress/Slider"
local add_speed_btn_path = "GameObject/PosGo/AddSpeedBtn"
local icon_path = "GameObject/PosGo/GameObject/Icon"
local gold_icon_path = "GameObject/PosGo/AddSpeedBtn/goldIcon"
local num_path = "GameObject/PosGo/GameObject/num"
local Localization = CS.GameEntry.Localization
local cost_txt1_path = "GameObject/PosGo_1/AddSpeedBtn_1/costTxt_1"
local progress1_path = "GameObject/PosGo_1/Bg_1/Progress_1"
local time1_text_path = "GameObject/PosGo_1/Bg_1/Progress_1/TimeText_1"
local slider1_path = "GameObject/PosGo_1/Bg_1/Progress_1/Slider_1"
local add_speed_btn1_path = "GameObject/PosGo_1/AddSpeedBtn_1"
local gold_icon1_path = "GameObject/PosGo_1/AddSpeedBtn_1/goldIcon_1"
local pos_path = "GameObject/PosGo"
local pos1_path = "GameObject/PosGo_1"
local SliderLength2 = Vector2.New(1.86, 0.33)
local SliderLength1 = Vector2.New(1.86, 0.33)
local PositionDelta1 = Vector3.New(0.5, 0, 1.8)
local PositionDelta2 = Vector3.New(-0.5, 0, -3.5)
local PositionDelta3 = Vector3.New(-0.5, 0, -1.5)

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
  self.progress = self.transform:Find(progress_path).gameObject
  self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.gold_icon = self.transform:Find(gold_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.add_speed_btn = self.transform:Find(add_speed_btn_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.add_speed_btn.onPointerClick()
    self:OnAddSpeedClick()
  end
  
  self.cost_txt = self.transform:Find(cost_txt_path):GetComponent(typeof(CS.SuperTextMesh))
  self.pos = self.transform:Find(pos_path).gameObject
  self.num = self.transform:Find(num_path):GetComponent(typeof(CS.SuperTextMesh))
  self.pos1 = self.transform:Find(pos1_path).gameObject
  self.time_text_1 = self.transform:Find(time1_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.progress_1 = self.transform:Find(progress1_path).gameObject
  self.slider_1 = self.transform:Find(slider1_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.gold_icon_1 = self.transform:Find(gold_icon1_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.add_speed_btn_1 = self.transform:Find(add_speed_btn1_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.add_speed_btn_1.onPointerClick()
    self:OnAddSpeedClick()
  end
  
  self.cost_txt_1 = self.transform:Find(cost_txt1_path):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.add_speed_btn.onPointerClick = nil
  self.add_speed_btn = nil
  self.add_speed_btn_1.onPointerClick = nil
  self.add_speed_btn_1 = nil
  self.cost_txt = nil
  self.time_text = nil
  self.slider = nil
  self.icon = nil
  self.progress = nil
  self.slider_bg = nil
  self.num = nil
  self:HideWater()
  self:UnSelectAnimal()
  self:UnSelectFarmland()
  self:RemoveCareerEffect()
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
  self.param = param
  self.curSize = Vector2.New(SliderLength2.x, SliderLength2.y)
  self.lastTime = 0
  self.firstConfirm = false
  self.sendMessage = false
  self:CheckIsInGuide()
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
  local item = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.speedItem)
  if self.param.buildTimeType ~= BuildTimeType.BuildTime_Farm then
    self.pos:SetActive(false)
    self.pos1:SetActive(true)
  else
    self.pos:SetActive(true)
    self.pos1:SetActive(false)
    DataCenter.CareerEffectManager:RemoveAll()
    self:SetIconSprite(self.param.iconName)
    DataCenter.CareerEffectManager:RefreshAll()
  end
  if self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  if self.param.endTime ~= nil and self.param.startTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    if self.param.showGold ~= nil and self.param.showGold == true then
      self:CheckGoldNum(changeTime)
    end
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
  self:SelectAnimal()
  self:SelectFarmland()
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
      if self.param.buildTimeType ~= BuildTimeType.BuildTime_Farm then
        self.slider_1:Set_size(self.curSize.x, self.curSize.y)
      else
        self.slider:Set_size(self.curSize.x, self.curSize.y)
      end
    end
  end
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    local worldPos = SceneUtils.TileIndexToWorld(index)
    if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
      local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.param.queueUuid)
      local state = queueData:GetQueueState()
      if state == NewQueueState.Work then
        local canIrrigate = DataCenter.PlayerCareerManager:CheckIfIrrigateAvailable(IrrigationType.Farmland)
        if not canIrrigate or queueData:CheckIfIrrigated() then
          self.precessSize = Vector2.New(SliderLength1.x, SliderLength1.y)
          worldPos = worldPos + PositionDelta1
        else
          self.precessSize = Vector2.New(SliderLength1.x, SliderLength1.y)
          worldPos = worldPos + PositionDelta3
        end
      end
    elseif self.param.buildTimeType == BuildTimeType.BuildTime_pasture then
      self.precessSize = Vector2.New(SliderLength2.x, SliderLength2.y)
      worldPos = worldPos + PositionDelta2
    end
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
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.ceil(self.param.endTime - curTime) / 1000.0
    local gold = LuaEntry.Player.gold
    local cost = CommonUtil.GetTimeDiamondCost(leftTime / 1000)
    if gold < cost then
      GoToUtil.GotoPayTips(cost)
    else
      local buildTimeType = self.param.buildTimeType
      local qUUID = self.param.queueUuid
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
          qUUID = qUUID,
          itemIDs = "",
          isGold = IsGold.UseGold
        })
        if buildTimeType == BuildTimeType.BuildTime_Farm then
          CS.SceneManager.World:QuitFocus(LookAtFocusTime)
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFarmIrrigate)
        end
      end, function()
      end)
    end
  end
end

local function CheckGoldNum(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = math.ceil(self.param.endTime - curTime) / 1000.0
  local costNum = CommonUtil.GetTimeDiamondCost(leftTime, self.param.buildTimeType == BuildTimeType.BuildTime_Farm or self.param.buildTimeType == BuildTimeType.BuildTime_pasture)
  if costNum ~= self.costNum then
    self.costNum = self.isGuide and 0 or costNum
    if self.param.buildTimeType ~= BuildTimeType.BuildTime_Farm then
      self.cost_txt_1.text = self.costNum
    else
      self.cost_txt.text = self.costNum
    end
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
    if self.param.buildTimeType ~= BuildTimeType.BuildTime_Farm then
      self.time_text_1.text = tempTimeValue
    else
      if self.param.queueUuid then
        local queueInfo = DataCenter.QueueDataManager:GetQueueByUuid(self.param.queueUuid)
        if queueInfo and queueInfo:CheckIfIrrigated() then
          self.num.gameObject:SetActive(true)
          self.num.text = "2x"
        else
          self.num.gameObject:SetActive(false)
        end
      end
      self.time_text.text = tempTimeValue
    end
  end
  self:CheckGoldNum()
end

local function RefreshUpdate(self)
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
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, "BuildTimeTip")
end

local function GetGuideObj(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
    return self.add_speed_btn.gameObject
  elseif self.param.buildTimeType == BuildTimeType.BuildTime_pasture then
    return self.add_speed_btn_1.gameObject
  end
end

local function CheckIsInGuide(self)
  self.isGuide = DataCenter.GuideManager:GetSaveGuideValue(FreeSpeed) == nil and DataCenter.GuideManager:InGuide() and CS.SceneManager:IsInCity()
end

local function SelectAnimal(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_pasture then
    local param = {}
    param.bUuid = self.param.bUuid
    param.queueUuid = self.param.queueUuid
    EventManager:GetInstance():Broadcast(EventId.Animal_Select, param)
  end
end

local function UnSelectAnimal(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_pasture then
    EventManager:GetInstance():Broadcast(EventId.Animal_Unselect)
  end
end

local function SelectFarmland(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, tostring(self.param.bUuid))
  end
end

local function UnSelectFarmland(self)
  if self.param.buildTimeType == BuildTimeType.BuildTime_Farm then
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  end
end

local function RefreshActive(self, isActive)
  if self.param.buildTimeType ~= BuildTimeType.BuildTime_Farm then
    self.pos1:SetActive(isActive)
  else
    self.pos:SetActive(isActive)
  end
end

local function RemoveCareerEffect(self)
  DataCenter.CareerEffectManager:RemoveAll()
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

BuildTimeTipFarm.OnCreate = OnCreate
BuildTimeTipFarm.OnDestroy = OnDestroy
BuildTimeTipFarm.ComponentDefine = ComponentDefine
BuildTimeTipFarm.ComponentDestroy = ComponentDestroy
BuildTimeTipFarm.DataDefine = DataDefine
BuildTimeTipFarm.DataDestroy = DataDestroy
BuildTimeTipFarm.ReInit = ReInit
BuildTimeTipFarm.ShowPanel = ShowPanel
BuildTimeTipFarm.RefreshSlider = RefreshSlider
BuildTimeTipFarm.UpdatePosition = UpdatePosition
BuildTimeTipFarm.RefreshSliderInterVal = RefreshSliderInterVal
BuildTimeTipFarm.RefreshTime = RefreshTime
BuildTimeTipFarm.OnAddSpeedClick = OnAddSpeedClick
BuildTimeTipFarm.ShowText = ShowText
BuildTimeTipFarm.ChangeShowTime = ChangeShowTime
BuildTimeTipFarm.RefreshUpdate = RefreshUpdate
BuildTimeTipFarm.SetIconSprite = SetIconSprite
BuildTimeTipFarm.ShowWater = ShowWater
BuildTimeTipFarm.HideWater = HideWater
BuildTimeTipFarm.GetGuideObj = GetGuideObj
BuildTimeTipFarm.CheckGoldNum = CheckGoldNum
BuildTimeTipFarm.CheckIsInGuide = CheckIsInGuide
BuildTimeTipFarm.SelectAnimal = SelectAnimal
BuildTimeTipFarm.UnSelectAnimal = UnSelectAnimal
BuildTimeTipFarm.SelectFarmland = SelectFarmland
BuildTimeTipFarm.UnSelectFarmland = UnSelectFarmland
BuildTimeTipFarm.RefreshActive = RefreshActive
BuildTimeTipFarm.RemoveCareerEffect = RemoveCareerEffect
BuildTimeTipFarm.CheckIfTimeTipExist = CheckIfTimeTipExist
return BuildTimeTipFarm
