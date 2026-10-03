local base = UIBaseView
local LWSeasonWeather = BaseClass("LWSeasonWeather", base)
local Localization = CS.GameEntry.Localization
local SeasonWeatherItem = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherItem")
local SeasonWeatherNextItem = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherNextItem")
local SeasonWeatherIcon = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherIcon")
local close_path = "PopUpTitle/CloseBtn"
local closePanel_path = "panel"
local info_path = "PopUpTitle/InfoBtn"
local weatherRoot_path = "PopUpTitle/WeatherRoot"
local content_path = "PopUpTitle/Content"
local itemLast_path = "PopUpTitle/Content/SeasonWeatherItemLast"
local itemCur_path = "PopUpTitle/Content/SeasonWeatherItemCur"
local itemNext_path = "PopUpTitle/Content/SeasonWeatherItemNext"
local imgBg_path = "PopUpTitle/Common_bg_orange2"
local timeTipsText_path = "BotTime/TimeTipsText"
local curTimeText_path = "BotTime/CurTimeText"
local timeChangeBtn_path = "BotTime/TimeChangeBtn"
local plot_path = "PopUpTitle/Plot"
local rootSpine_path = "PopUpTitle/Plot/root_spine"
local txtPlot_path = "PopUpTitle/Plot/bg_content/txt_content_n"
local btnNext_path = "PopUpTitle/Plot/btn_next"
local weatherIcon_path = "PopUpTitle/Common_bg_orange2/Eff_ui_S1_weather_01"
local curPlayer_path = "PopUpTitle/Content/SeasonWeatherItemCur/curPlayer"
local head_path = "PopUpTitle/Content/SeasonWeatherItemCur/curPlayer/head"
local fxPlayer_path = "PopUpTitle/Content/SeasonWeatherItemCur/curPlayer/fxPlayer"

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

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonWeatherInfoUpdate, self.Refresh)
  self:AddUIListener(EventId.UserSettingChanged, self.OnRefreshTimeShowModeView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonWeatherInfoUpdate, self.Refresh)
  self:RemoveUIListener(EventId.UserSettingChanged, self.OnRefreshTimeShowModeView)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.close = self:AddComponent(UIButton, close_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.info = self:AddComponent(UIButton, info_path)
  self.weatherRoot = self:AddComponent(UIBaseContainer, weatherRoot_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.itemLast = self:AddComponent(UIBaseContainer, itemLast_path)
  self.itemCur = self:AddComponent(UIBaseContainer, itemCur_path)
  self.itemNext = self:AddComponent(UIBaseContainer, itemNext_path)
  self.imgBg = self:AddComponent(UIRawImage, imgBg_path)
  self.timeTipsText = self:AddComponent(UIText, timeTipsText_path)
  self.curTimeText = self:AddComponent(UIText, curTimeText_path)
  self.timeChangeBtn = self:AddComponent(UIButton, timeChangeBtn_path)
  self.plot = self:AddComponent(UIBaseContainer, plot_path)
  self.rootSpine = self:AddComponent(UIBaseContainer, rootSpine_path)
  self.txtPlot = self:AddComponent(UIText, txtPlot_path)
  self.btnNext = self:AddComponent(UIButton, btnNext_path)
  self.weatherIcon = self:AddComponent(UIBaseContainer, weatherIcon_path)
  self.curPlayer = self:AddComponent(UIBaseContainer, curPlayer_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.fxPlayer = self:AddComponent(UIBaseContainer, fxPlayer_path)
  self.close:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonWeatherDetail, {anim = true})
  end)
  self.theItemLast = self:AddComponent(SeasonWeatherItem, itemLast_path)
  self.theItemCur = self:AddComponent(SeasonWeatherItem, itemCur_path)
  self.theItemNext = self:AddComponent(SeasonWeatherNextItem, itemNext_path)
  self:ShowWeather(WeatherObjectInfo.SeasonWeather)
  self.timeChangeBtn:SetOnClick(BindCallback(self, self.TimeChangeBtnClick))
  self.btnNext:SetOnClick(BindCallback(self, self.OnClickNext))
  self.weatherIcon = self:AddComponent(SeasonWeatherIcon, weatherIcon_path)
end

local function ComponentDestroy(self)
  self:HideWeather()
  self:ClearSpineRes()
  self.close = nil
  self.closePanel = nil
  self.info = nil
  self.weatherRoot = nil
  self.content = nil
  self.itemLast = nil
  self.itemCur = nil
  self.itemNext = nil
  self.imgBg = nil
  self.timeTipsText = nil
  self.curTimeText = nil
  self.timeChangeBtn = nil
  self.plot = nil
  self.rootSpine = nil
  self.txtPlot = nil
  self.btnNext = nil
  self.weatherIcon = nil
  self.curPlayer = nil
  self.head = nil
  self.fxPlayer = nil
end

local function DataDefine(self)
  self.currStep = -1
  self.plot:SetActive(false)
  self:Refresh()
  self.isShowServerTime = DataCenter.LWActivityAlarmClockManager:GetShowServerTimeMode()
  self:RefreshTimeShow()
end

local function DataDestroy(self)
end

function LWSeasonWeather:Refresh()
  local info = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  if not info then
    self.ctrl:CloseSelf()
    return
  end
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(info.weatherId)
  self.imgBg:LoadSpriteAuto(typeInfo.image)
  self:RefreshItems(info)
  self.weatherIcon:ReInit(info.weatherId)
  self.dialog = self:ShowPlayer(info, typeInfo)
  if typeInfo.plot and typeInfo.plot > 0 then
    self:SeasonWeatherPlot(typeInfo.plot)
  end
  UIUtil.CheckEventTrigger(OpMode.ClickBtnWeather, 0, 0.5)
end

function LWSeasonWeather:RefreshItems(info)
  self.info = info
  self.theItemCur:ReInit(info, true)
  local lastInfo = DataCenter.SeasonWeatherManager:GetWeatherLastInfo()
  if lastInfo then
    self.theItemLast:ReInit(lastInfo)
    self.theItemLast:SetActive(true)
  else
    self.theItemLast:SetActive(false)
  end
  self.nextWeather = DataCenter.SeasonWeatherManager:GetNextWeatherConfig()
  if not table.IsNullOrEmpty(self.nextWeather) then
    self.theItemNext:ReInit(self.nextWeather, true)
    self.theItemNext:SetActive(true)
  else
    self.theItemNext:SetActive(false)
  end
end

function LWSeasonWeather:Update1000MS()
  self:RefreshCurTimeShow()
end

function LWSeasonWeather:OnRefreshTimeShowModeView(type)
  if type == UserSettingKey.ActivityAlarmClock then
    self.isShowServerTime = DataCenter.LWActivityAlarmClockManager:GetShowServerTimeMode()
    self:RefreshTimeShow()
  end
end

function LWSeasonWeather:TimeChangeBtnClick()
  local newValue = not self.isShowServerTime
  DataCenter.LWActivityAlarmClockManager:SetShowServerTimeMode(newValue)
end

function LWSeasonWeather:RefreshTimeShow()
  if self.isShowServerTime then
    self.timeTipsText:SetLocalText("s1_weather_ui04")
  else
    self.timeTipsText:SetLocalText("s1_weather_ui05")
  end
  self:RefreshCurTimeShow()
end

function LWSeasonWeather:RefreshCurTimeShow()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isShowServerTime then
    self.curTimeText:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(curTime))
  else
    self.curTimeText:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(curTime))
  end
end

function LWSeasonWeather:ShowWeather(objectInfo)
  if self.weatherObj then
    if self.weatherObj.objectType == objectInfo.type then
      self.weatherObj:Refresh()
      return
    else
      self:HideWeather()
    end
  end
  if not self.weatherObjReq then
    self.weatherObjReq = self:GameObjectInstantiateAsync(objectInfo.path, function(req)
      local gameObject = req.gameObject
      if IsNull(gameObject) then
        return
      end
      local transform = gameObject.transform
      gameObject:SetActive(true)
      transform:SetParent(self.weatherRoot.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_localPosition(0, 0, 0)
      transform:SetSiblingIndex(0)
      local name = gameObject.name
      self.weatherObj = self.weatherRoot:AddComponent(require(objectInfo.script), name)
      self.weatherObj.objectType = objectInfo.type
      self.weatherObj:Refresh()
    end)
  end
end

function LWSeasonWeather:HideWeather()
  if self.weatherObj then
    local objInfo = WeatherObjectInfo[self.weatherObj.objectType]
    if objInfo then
      self.weatherRoot:RemoveComponents(require(objInfo.script))
    end
    self.weatherObj = nil
  end
  if self.weatherObjReq then
    self.weatherObjReq:Destroy()
    self.weatherObjReq = nil
  end
end

function LWSeasonWeather:SeasonWeatherPlot(plotGroup)
  self.plot:SetActive(true)
  self.groupRandomIndex = -1
  self.groupRandom = false
  self:PrepareData(plotGroup)
  self.currPlot = nil
  self.currStep = 0
  self.dubHandle = nil
  self.nextTipTween = nil
  self.currAnimName = nil
  self.done = false
  if self.groupRandom and self.groupRandomIndex ~= -1 then
    self.currStep = self.groupRandomIndex - 1
  end
  self.btnNext:SetActive(true)
  self:NextStep()
end

function LWSeasonWeather:OnClickNext()
  self.dialog = nil
  if self.clickEnabled and self.currStep >= 0 then
    self:NextStep()
  end
  if self.done and self.nextWeather then
    local plot, plot_pre = self.nextWeather:GetPlot(self.info.weatherId)
    if not self.showPre and plot_pre and 0 < plot_pre then
      self.showPre = true
      self:SeasonWeatherPlot(plot_pre)
    else
      self.showPre = false
      if plot and 0 < plot then
        self:SeasonWeatherPlot(plot)
      end
    end
  end
end

function LWSeasonWeather:ClearSpineRes()
  if self.spineResHandle ~= nil then
    self.spineResHandle:Destroy()
    self.spineResHandle = nil
  end
end

function LWSeasonWeather:PrepareData(plotGroup)
  local id = plotGroup
  self.plotGroup = {
    id = id,
    plots = {}
  }
  local miss = false
  local plotId = self.plotGroup.id * 100 + 1
  local plot = LocalController.instance():getLine(TableName.LW_Plot, plotId)
  if plot and (plot.random_dialogue == "1" or plot.style == 5) then
    self.groupRandom = true
  end
  while not miss do
    local plotNext = LocalController.instance():getLine(TableName.LW_Plot, plotId)
    if plotNext == nil then
      miss = true
    else
      table.insert(self.plotGroup.plots, plotNext)
    end
    plotId = plotId + 1
  end
  if self.groupRandom then
    local key = table.randomKey(self.plotGroup.plots)
    if key ~= nil then
      local index = toInt(key)
      if 0 < index then
        self.groupRandomIndex = index
      end
    end
  end
end

function LWSeasonWeather:NextStep()
  if self.dubHandle ~= nil then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.dubHandle, 0.1)
    self.dubHandle = nil
  end
  self.currStep = self.currStep + 1
  if self.currStep > #self.plotGroup.plots then
    self:Done()
    return
  end
  if self.groupRandom and self.groupRandomIndex ~= self.currStep then
    self:Done()
    return
  end
  self:ClearSpineRes()
  self.currPlot = self.plotGroup.plots[self.currStep]
  if self.currPlot == nil then
    Logger.LogError("can't find plot with id " .. self.plotGroup.plots[self.currStep])
    self:NextStep()
  else
    self:RenderContent()
    if not string.IsNullOrEmpty(self.currPlot.dub) then
      self.dubHandle = DataCenter.LWSoundManager:PlayDub(self.currPlot.dub)
    end
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
    end
    self.clickEnabled = false
    if self.currPlot.noClick <= 0 then
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.clickEnabled = true
      end, 0.5)
    end
    if self.autoNextTimer ~= nil then
      self.autoNextTimer:Stop()
    end
    if 0 < self.currPlot.duration then
      self.autoNextTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:NextStep()
      end, self.currPlot.duration)
    end
  end
end

function LWSeasonWeather:Done()
  self.done = true
  self.currStep = -1
  self.btnNext:SetActive(false)
end

function LWSeasonWeather:RenderContent()
  local content = self.dialog or CS.GameEntry.Localization:GetString(self.currPlot.content)
  self.txtPlot:SetText(content)
  self.txtPlot:ForceUpdate()
  self.txtPlot:DOText(content, 1)
  self:ClearSpineRes()
  local appearance = self.currPlot.appearance
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearance)
  if newAppearanceId <= 0 then
    return
  end
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  local request = CS.GameEntry.Resource:InstantiateAsync(spinePath)
  self.spineResHandle = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.spineResHandle = nil
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      local spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_scale")
      local spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_pos")
      rectTransform:SetParent(self.rootSpine.transform, false)
      rectTransform:Set_localScale(spineScale, spineScale, spineScale)
      rectTransform:Set_anchoredPosition(CommonUtil.IsArabicAutoMirrorOpen() and -(spinePos[1] / spineScale) or spinePos[1] / spineScale, spinePos[2] / spineScale, 0)
    end
  end)
end

function LWSeasonWeather:ShowPlayer(data, typeInfo)
  local player = data and data.summonUserInfo
  if table.IsNullOrEmpty(player) then
    if self.curPlayer then
      self.curPlayer:SetActive(false)
    end
    return
  end
  local lastTypeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(data.lastWeatherId)
  local lastName = Localization:GetString(lastTypeInfo and lastTypeInfo.name or "")
  local curName = Localization:GetString(typeInfo and typeInfo.name or "")
  local playerName = player.name or ""
  if string.IsNullOrEmpty(player.abbr) then
    playerName = string.format("#%s %s", player.serverId, playerName)
  else
    playerName = string.format("#%s [%s]%s", player.serverId, player.abbr, playerName)
  end
  local dialog = Localization:GetString("s1_title_skill_tips06", playerName, lastName, curName, curName)
  if not self.fxCaiDai then
    self.fxCaiDai = self:AddComponent(UIVfx, fxPlayer_path, VfxAssets.EffectCaiDai)
  end
  if self.fxCaiDai then
    self.fxCaiDai:Replay()
  end
  self.curPlayer:SetActive(true)
  if self.headCell then
    self.headCell:ParseHeadInfo(player)
    self.headCell:SetEnableClickShowInfo(true, true)
    return dialog
  end
  if not self.headReq then
    self.headReq = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local trans = obj.transform
      trans:SetParent(self.head.transform)
      trans.localScale = Vector3.one
      trans.localPosition = Vector3.zero
      trans:Set_pivot(0.5, 0.5)
      trans:Set_sizeDelta(150, 150)
      obj.name = "headCell"
      local headCell = self.head:AddComponent(UICommonHead, obj.name)
      headCell:ParseHeadInfo(player)
      headCell:SetEnableClickShowInfo(true, true)
      self.headCell = headCell
    end)
  end
  return dialog
end

LWSeasonWeather.OnCreate = OnCreate
LWSeasonWeather.OnDestroy = OnDestroy
LWSeasonWeather.OnEnable = OnEnable
LWSeasonWeather.OnDisable = OnDisable
LWSeasonWeather.ComponentDefine = ComponentDefine
LWSeasonWeather.ComponentDestroy = ComponentDestroy
LWSeasonWeather.DataDefine = DataDefine
LWSeasonWeather.DataDestroy = DataDestroy
LWSeasonWeather.OnAddListener = OnAddListener
LWSeasonWeather.OnRemoveListener = OnRemoveListener
return LWSeasonWeather
