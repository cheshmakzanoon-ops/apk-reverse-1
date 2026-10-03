local UIPositionAddView = BaseClass("UIPositionAddView", UIBaseView)
local MarkItemTemplate = require("UI.UIPositionAdd.Component.UIPositionMarkItemComponent")
local TimeOrderItemTemplate = require("UI.UIPositionAdd.Component.UITimeOrderItemComponent")
local UIPositionAddToggleBase = require("UI.UIPositionAdd.Component.UIPositionAddToggleBase")
local PREFAB_TOG = "Assets/Main/Prefabs/UI/World/UIPositionAddToggleBase.prefab"
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TIMER_TYPE = {COUNT_DOWN = 0, TIMING = 1}
local MAX_CD_HOUR = 99
local MAX_CD_MIN = 59
local MAX_TIMING_DAY = 6
local MAX_TIMING_HOUR = 23
local MAX_TIMING_MIN = 59

local function IsPersonalMarkType(markType)
  return markType == MarkType.Special or markType == MarkType.Friend or markType == MarkType.Enemy
end

local function IsAllianceMarkType(markType)
  return markType >= MarkType.Alliance_Attack and markType <= MarkType.Alliance_END
end

local function IsCountryMarkType(markType)
  return markType >= MarkType.Country_A and markType <= MarkType.COUNTRY_END
end

function UIPositionAddView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitState()
end

function UIPositionAddView:OnDestroy()
  self:ClearMarksScrollView()
  self.compCDTimeOrderItem:ClearTimeOrderItem()
  self.compCDMinOrderItem:ClearTimeOrderItem()
  self.compTDateOrderItem:ClearTimeOrderItem()
  self.compTTimeOrderItem:ClearTimeOrderItem()
  self.compTMinOrderItem:ClearTimeOrderItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPositionAddView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnOuterPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnOuterPanel:SetOnClick(function()
    self:OnBtnOuterPanelClick()
  end)
  self.toggleAlliance = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.togglePersonal = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.textTabNameAl = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTabNamePer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textPosition = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.inputField = self.viewSkin:AddComponent(self, UIInput, 9)
  self.compAllianceMarkPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compPersonalMarkPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.toggleR4R5Visible = self.viewSkin:AddComponent(self, UIToggle, 12)
  self.textR4R5Visible = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.toggleCountDown = self.viewSkin:AddComponent(self, UIToggle, 14)
  self.toggleTiming = self.viewSkin:AddComponent(self, UIToggle, 15)
  self.textTabNameCountDown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textTabNameTiming = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.compCountDownPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.compTimingPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.compCDTimeOrderItem = self.viewSkin:AddComponent(self, TimeOrderItemTemplate, 20)
  self.compCDMinOrderItem = self.viewSkin:AddComponent(self, TimeOrderItemTemplate, 21)
  self.compTMinOrderItem = self.viewSkin:AddComponent(self, TimeOrderItemTemplate, 22)
  self.compTTimeOrderItem = self.viewSkin:AddComponent(self, TimeOrderItemTemplate, 23)
  self.compTDateOrderItem = self.viewSkin:AddComponent(self, TimeOrderItemTemplate, 24)
  self.textLocalTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.toggleSpecial = self.viewSkin:AddComponent(self, UIToggle, 26)
  self.toggleFrd = self.viewSkin:AddComponent(self, UIToggle, 27)
  self.toggleEnemy = self.viewSkin:AddComponent(self, UIToggle, 28)
  self.MarksScrollViewVertical = self.viewSkin:AddComponent(self, UIScrollView, 29)
  self.compNoMarkPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 30)
  self.textNoMark = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 31)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 32)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.imgSpecialMark = self.viewSkin:AddComponent(self, UIImage, 33)
  self.imgFrdMark = self.viewSkin:AddComponent(self, UIImage, 34)
  self.imgEnemyMark = self.viewSkin:AddComponent(self, UIImage, 35)
  self.textSpecial = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.textFrd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 37)
  self.textEnemy = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 38)
  self.btnDelete = self.viewSkin:AddComponent(self, UIButton, 39)
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.textConfirmBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 40)
  self.textDeleteBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 41)
  self.toggleCountry = self.viewSkin:AddComponent(self, UIToggle, 42)
  self.textTabNameCo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 43)
  self.compAlMarkContent = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 44)
  self.scAlMarkScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 45)
  self.allianceMarksDic = {}
  self.markTypeGroupList = {
    [MarkGroup.Alliance] = {},
    [MarkGroup.WarZone] = {}
  }
  local worldFavoMgr = DataCenter.WorldFavoDataManager
  local curSeason = SeasonUtil.GetSeason()
  for type = MarkType.Alliance_Attack, MarkType.Alliance_END do
    local season = worldFavoMgr:GetBookMarkSeason(type)
    if curSeason >= season then
      table.insert(self.markTypeGroupList[MarkGroup.Alliance], type)
    end
  end
  for type = MarkType.Country_A, MarkType.COUNTRY_END do
    local season = worldFavoMgr:GetBookMarkSeason(type)
    if curSeason >= season then
      table.insert(self.markTypeGroupList[MarkGroup.WarZone], type)
    end
  end
  
  local function SortFunc(a, b)
    local sa = worldFavoMgr:GetBookMarkSort(a)
    local sb = worldFavoMgr:GetBookMarkSort(b)
    if sa ~= sb then
      return sa < sb
    end
    return a < b
  end
  
  table.sort(self.markTypeGroupList[MarkGroup.Alliance], SortFunc)
  table.sort(self.markTypeGroupList[MarkGroup.WarZone], SortFunc)
  local max_count = math.max(#self.markTypeGroupList[MarkGroup.Alliance], #self.markTypeGroupList[MarkGroup.WarZone])
  local valueChangeCb = BindCallback(self, self.OnMarkTogValueChanged)
  for i = 1, max_count do
    local comp = self:LoadComponentAsync(UIPositionAddToggleBase, PREFAB_TOG, self.compAlMarkContent, function()
      self:RefreshScAlMarkScoreView()
    end)
    comp:SetName("Toggle_" .. i)
    comp:SetData(i, valueChangeCb)
    comp:SetIsOn(false)
    comp:SetTipActive(false)
    self.allianceMarksDic[i] = comp
  end
  self.MarksScrollViewVertical:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.inputField:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.toggleAlliance:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkGroup(MarkGroup.Alliance, true)
    end
  end)
  self.toggleCountry:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkGroup(MarkGroup.WarZone, true)
    end
  end)
  self.togglePersonal:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkGroup(MarkGroup.Personal, true)
    end
  end)
  self.toggleSpecial:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkType(MarkType.Special)
    end
  end)
  self.toggleFrd:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkType(MarkType.Friend)
    end
  end)
  self.toggleEnemy:SetOnValueChanged(function(state)
    if state then
      self:SelectMarkType(MarkType.Enemy)
    end
  end)
  self.toggleCountDown:SetOnValueChanged(function(state)
    if state then
      self:SelectTimer(TIMER_TYPE.COUNT_DOWN)
    end
  end)
  self.toggleTiming:SetOnValueChanged(function(state)
    if state then
      self:SelectTimer(TIMER_TYPE.TIMING)
    end
  end)
  self.toggleR4R5Visible:SetOnValueChanged(function(state)
    if state then
      self:SetR4R5Visible(true)
    else
      self:SetR4R5Visible(false)
    end
  end)
end

function UIPositionAddView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.btnOuterPanel = nil
  self.toggleAlliance = nil
  self.togglePersonal = nil
  self.textTabNameAl = nil
  self.textTabNamePer = nil
  self.textPosition = nil
  self.inputField = nil
  self.compAllianceMarkPanel = nil
  self.compPersonalMarkPanel = nil
  self.toggleR4R5Visible = nil
  self.textR4R5Visible = nil
  self.toggleCountDown = nil
  self.toggleTiming = nil
  self.textTabNameCountDown = nil
  self.textTabNameTiming = nil
  self.compCountDownPanel = nil
  self.compTimingPanel = nil
  self.compCDTimeOrderItem = nil
  self.compCDMinOrderItem = nil
  self.compTMinOrderItem = nil
  self.compTTimeOrderItem = nil
  self.compTDateOrderItem = nil
  self.textLocalTime = nil
  self.toggleSpecial = nil
  self.toggleFrd = nil
  self.toggleEnemy = nil
  self.MarksScrollViewVertical = nil
  self.compNoMarkPanel = nil
  self.textNoMark = nil
  self.btnConfirm = nil
  self.imgSpecialMark = nil
  self.imgFrdMark = nil
  self.imgEnemyMark = nil
  self.textSpecial = nil
  self.textFrd = nil
  self.textEnemy = nil
  self.btnDelete = nil
  self.textConfirmBtn = nil
  self.textDeleteBtn = nil
  self.toggleCountry = nil
  self.textTabNameCo = nil
  self.compAlMarkContent = nil
  self.scAlMarkScrollView = nil
end

function UIPositionAddView:DataDefine()
  local share_param = self:GetUserData()
  if share_param.x == nil and share_param.y == nil and share_param.pos ~= nil then
    local point = (share_param.pos - share_param.pos % 10) / 10
    local pos = SceneUtils.IndexToTilePos(point)
    share_param.x = pos.x
    share_param.y = pos.y
  end
  self.chat_data_param = share_param
  self.allianceMarkData = DeepCopy(share_param)
  self.countryMarkData = DeepCopy(share_param)
  self.personalMarkData = DeepCopy(share_param)
  self.allianceMarkData.type = nil
  self.countryMarkData.type = nil
  self.personalMarkData.type = nil
  self.toggleImgTab = {
    [MarkType.Special] = self.imgSpecialMark,
    [MarkType.Friend] = self.imgFrdMark,
    [MarkType.Enemy] = self.imgEnemyMark
  }
  self.curMarkGroup = -1
  self.selectType = -1
  self.cdHourTextList, self.cdMinTextList = self.ctrl:GetCDTimeTextList(MAX_CD_HOUR, MAX_CD_MIN)
  self.tDataTextList, self.tHourTextList, self.tMinTextList = self.ctrl:GetTimingTimeTextList(MAX_TIMING_DAY, MAX_TIMING_HOUR, MAX_TIMING_MIN)
  self.curSelectedTimeType = -1
  self.curSelectedCDTime = {hour = 0, min = 0}
  self.curSelectedTTime = {
    date = 0,
    hour = 0,
    min = 0
  }
  self.zeroStamp = UITimeManager:GetInstance():GetTodayZero()
  self.personalMarkItemIndex = 1
  self.curPersonalMarkList = {}
  self.curPersonalMarkItemList = {}
end

function UIPositionAddView:DataDestroy()
  if self.togGroupRefreshDelay ~= nil then
    self.togGroupRefreshDelay:Stop()
    self.togGroupRefreshDelay = nil
  end
  self.chat_data_param = nil
  self.markTypeGroupList = nil
  self.allianceMarksDic = nil
  self.allianceMarkData = nil
  self.countryMarkData = nil
  self.personalMarkData = nil
  self.toggleImgTab = nil
  self.defaultName = nil
  self.name = nil
  self.selectType = nil
  self.curMarkGroup = nil
  self.cdHourTextList = nil
  self.cdMinTextList = nil
  self.tDataTextList = nil
  self.tHourTextList = nil
  self.tMinTextList = nil
  self.curSelectedTimeType = nil
  self.curSelectedCDTime = nil
  self.curSelectedTTime = nil
  self.zeroStamp = nil
  self.personalMarkItemIndex = nil
  self.curPersonalMarkList = nil
  self.curPersonalMarkItemList = nil
end

function UIPositionAddView:ClearMarksScrollView()
  self.MarksScrollViewVertical:ClearCells()
  self.MarksScrollViewVertical:RemoveComponents(MarkItemTemplate)
  self.curPersonalMarkItemList = {}
  self.personalMarkItemIndex = 1
end

function UIPositionAddView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

function UIPositionAddView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  base.OnRemoveListener(self)
end

function UIPositionAddView:RefreshMarkList()
  self:RefreshDelBtn()
  self:SetDefaultContent(self.selectType)
  if self.curMarkGroup == MarkGroup.Personal and IsPersonalMarkType(self.selectType) then
    self:ClearMarksScrollView()
    self:RefreshPersonalMark(self.selectType)
  end
  if self.curMarkGroup == MarkGroup.Alliance or self.curMarkGroup == MarkGroup.WarZone then
    self:RefreshGroupMarkToggles()
  end
end

function UIPositionAddView:InitState()
  self.textTabNameAl:SetLocalText(393081)
  self.textTabNamePer:SetLocalText(393080)
  self.textTabNameCo:SetLocalText(800941)
  self.textR4R5Visible:SetLocalText("alliance_mark_desc_r4r5only")
  self.textTabNameCountDown:SetLocalText("alliance_mark_tap_couter")
  self.textTabNameTiming:SetLocalText("alliance_mark_tap_clock")
  self.textSpecial:SetLocalText(GameDialogDefine.BOOKMARK_SPECIAL)
  self.textFrd:SetLocalText(GameDialogDefine.BOOKMARK_FRIEND)
  self.textEnemy:SetLocalText(GameDialogDefine.BOOKMARK_ENEMY)
  self.textConfirmBtn:SetLocalText(110006)
  self.textDeleteBtn:SetLocalText(100190)
  self.textNoMark:SetLocalText(128007)
  self.compCDTimeOrderItem:SetTitle(Localization:GetString("2010343"))
  self.compCDTimeOrderItem:RefreshItems(self.cdHourTextList, 1)
  self.compCDTimeOrderItem:SetOnChangedUpdate(function(cur_index)
    self:OnTimeOrderSelectChange(cur_index, TIMER_TYPE.COUNT_DOWN, 1)
  end)
  self.compCDMinOrderItem:SetTitle(Localization:GetString("2010340"))
  self.compCDMinOrderItem:RefreshItems(self.cdMinTextList, 1)
  self.compCDMinOrderItem:SetOnChangedUpdate(function(cur_index)
    self:OnTimeOrderSelectChange(cur_index, TIMER_TYPE.COUNT_DOWN, 2)
  end)
  self.compTDateOrderItem:SetTitle(Localization:GetString("2010341"))
  self.compTDateOrderItem:RefreshItems(self.tDataTextList, 1)
  self.compTDateOrderItem:SetOnChangedUpdate(function(cur_index)
    self:OnTimeOrderSelectChange(cur_index, TIMER_TYPE.TIMING, 1)
  end)
  self.compTTimeOrderItem:SetTitle(Localization:GetString("2010343"))
  self.compTTimeOrderItem:RefreshItems(self.tHourTextList, 1)
  self.compTTimeOrderItem:SetOnChangedUpdate(function(cur_index)
    self:OnTimeOrderSelectChange(cur_index, TIMER_TYPE.TIMING, 2)
  end)
  self.compTMinOrderItem:SetTitle(Localization:GetString("2010340"))
  self.compTMinOrderItem:RefreshItems(self.tMinTextList, 1)
  self.compTMinOrderItem:SetOnChangedUpdate(function(cur_index)
    self:OnTimeOrderSelectChange(cur_index, TIMER_TYPE.TIMING, 3)
  end)
  local t = self.chat_data_param
  local tempType, tempGroup
  local showCnt = 1
  local canShowCountry = self.ctrl:CheckIfCanShowCountryMark()
  local canAddAl = self.ctrl:CheckIfCanAddAllianceMark()
  self.toggleCountry:SetActive(canShowCountry)
  self.toggleAlliance:SetActive(canAddAl)
  if canShowCountry then
    showCnt = showCnt + 1
  end
  if canAddAl then
    showCnt = showCnt + 1
  end
  local togW = 2 < showCnt and 246 or 365
  if canShowCountry then
    self.toggleCountry:SetSizeDeltaX(togW)
  end
  if canAddAl then
    self.toggleAlliance:SetSizeDeltaX(togW)
  end
  self.togglePersonal:SetSizeDeltaX(togW)
  local panelType = t.panelType
  if canShowCountry and panelType == MarkGroup.WarZone then
    tempGroup = panelType
    tempType = self:GetDefaultSelectType(tempGroup)
  elseif canAddAl and panelType ~= MarkGroup.Personal then
    tempGroup = MarkGroup.Alliance
    tempType = self:GetDefaultSelectType(tempGroup)
  else
    tempGroup = MarkGroup.Personal
    tempType = MarkType.Special
  end
  self.defaultName = self:InitDefaultContent(t)
  local alliance_mark_data = DataCenter.WorldFavoDataManager:GetAllianceBookmark(t.pos, t.sid)
  local country_mark_data = DataCenter.WorldFavoDataManager:GetCountryBookmark(t.pos, t.sid)
  local personal_mark_data = DataCenter.WorldFavoDataManager:GetBookmark(t.pos, t.sid, true)
  local name = self.defaultName
  if alliance_mark_data ~= nil then
    self.allianceMarkData.type = alliance_mark_data.type
    self.allianceMarkData.startTime = alliance_mark_data.startTime
    self.allianceMarkData.viewRank = alliance_mark_data.viewRank or 0
    self.allianceMarkData.operateType = alliance_mark_data.operateType or TIMER_TYPE.COUNT_DOWN
    if tempGroup == MarkGroup.Alliance then
      name = alliance_mark_data.name
    end
  end
  if country_mark_data ~= nil then
    self.countryMarkData.type = country_mark_data.type
    self.countryMarkData.startTime = country_mark_data.startTime
    self.countryMarkData.operateType = country_mark_data.operateType or TIMER_TYPE.COUNT_DOWN
    if tempGroup == MarkGroup.WarZone then
      name = country_mark_data.name
    end
  end
  if personal_mark_data ~= nil then
    self.personalMarkData.type = personal_mark_data.type
    if tempGroup == MarkGroup.Personal then
      name = personal_mark_data.name
      self.toggleSpecial:SetIsOn(personal_mark_data.type == 0)
      self.toggleFrd:SetIsOn(personal_mark_data.type == 1)
      self.toggleEnemy:SetIsOn(personal_mark_data.type == 2)
    end
  end
  self.name = name
  self.inputField:SetText(self.name)
  self.textPosition:SetLocalText(GameDialogDefine.POSITION_COORDINATE_CROSS, t.sid, t.x, t.y)
  self:SelectMarkGroup(tempGroup, false)
  self:SelectMarkType(tempType)
  if tempGroup == MarkGroup.Alliance and self.allianceMarkData.viewRank ~= nil then
    self:SetR4R5Visible(self.allianceMarkData.viewRank >= 4)
  else
    self:SetR4R5Visible(false)
  end
  if tempGroup == MarkGroup.WarZone then
    self:SetTimer(self.countryMarkData.startTime or 0)
  else
    self:SetTimer(self.allianceMarkData.startTime or 0)
  end
end

function UIPositionAddView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIPositionAddView:OnBtnOuterPanelClick()
  self.ctrl:CloseSelf()
end

function UIPositionAddView:OnBtnConfirmClick()
  if string.IsNullOrEmpty(self.name) then
    UIUtil.ShowTipsId(GameDialogDefine.PLEASE_INPUT_NUM)
    return
  end
  if self.curMarkGroup == MarkGroup.Alliance then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390820)
      return
    elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local isInUse = DataCenter.WorldFavoDataManager:CheckIfPointInUse(self.allianceMarkData.pos)
      if isInUse then
        UIUtil.ShowTipsId(390823)
      else
        UIUtil.ShowTipsId(390821)
      end
      return
    end
    local planTimeStamp = 0
    local cur_server_time = UITimeManager:GetInstance():GetServerTime()
    if self.curSelectedTimeType == TIMER_TYPE.COUNT_DOWN then
      local delay_time = self.curSelectedCDTime.hour * 3600 + self.curSelectedCDTime.min * 60
      if 0 < delay_time then
        planTimeStamp = cur_server_time + delay_time * 1000
      end
    else
      local selectServerTime = self.ctrl:CalcTimeStampByDate(self.curSelectedTTime.date, self.curSelectedTTime.hour, self.curSelectedTTime.min, self.zeroStamp)
      if cur_server_time > selectServerTime then
        UIUtil.ShowTipsId("alliance_mark_tips_timeError")
        return
      end
      planTimeStamp = selectServerTime
    end
    if self.toggleR4R5Visible:GetIsOn() then
      self.allianceMarkData.viewRank = 4
    else
      self.allianceMarkData.viewRank = 0
    end
    self.allianceMarkData.operateType = self.curSelectedTimeType or TIMER_TYPE.COUNT_DOWN
    self.ctrl:AddAllianceMark(self.allianceMarkData.pos, self.allianceMarkData.sid, self.name, self.selectType, planTimeStamp, true, self.allianceMarkData)
  elseif self.curMarkGroup == MarkGroup.WarZone then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    if not self.ctrl:CheckIfCanAddCountryMark() then
      UIUtil.ShowTipsId(390821)
      return
    end
    local planTimeStamp = 0
    local cur_server_time = UITimeManager:GetInstance():GetServerTime()
    if self.curSelectedTimeType == TIMER_TYPE.COUNT_DOWN then
      local delay_time = self.curSelectedCDTime.hour * 3600 + self.curSelectedCDTime.min * 60
      if 0 < delay_time then
        planTimeStamp = cur_server_time + delay_time * 1000
      end
    else
      local selectServerTime = self.ctrl:CalcTimeStampByDate(self.curSelectedTTime.date, self.curSelectedTTime.hour, self.curSelectedTTime.min, self.zeroStamp)
      if cur_server_time > selectServerTime then
        UIUtil.ShowTipsId("alliance_mark_tips_timeError")
        return
      end
      planTimeStamp = selectServerTime
    end
    self.countryMarkData.operateType = self.curSelectedTimeType or TIMER_TYPE.COUNT_DOWN
    self.ctrl:AddCountryMark(self.selectType, self.countryMarkData.pos, LuaEntry.Player:GetCurWorldId(), self.countryMarkData.sid, self.name, planTimeStamp, true)
  else
    UIUtil.DoFly(RewardType.FAVOR, 1, string.format(LoadPath.CommonNewPath, self.toggleImgTab[self.selectType]:GetImage().name), self.toggleImgTab[self.selectType].transform.position, Vector3.New(0, 0, 0))
    self.ctrl:AddBookMark(self.personalMarkData.pos, self.personalMarkData.sid, self.name, self.selectType, 0, self.personalMarkData)
  end
end

function UIPositionAddView:OnBtnDeleteClick()
  if self.curMarkGroup == MarkGroup.Alliance then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390820)
      return
    elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(390822)
      return
    end
    local data = DataCenter.WorldFavoDataManager:GetAllianceBookmarkByType(self.selectType, self.allianceMarkData.sid)
    if data then
      self.ctrl:DelAllianceMark(data.type)
    end
  elseif self.curMarkGroup == MarkGroup.WarZone then
    if not self.ctrl:CheckIfCanAddCountryMark() then
      UIUtil.ShowTipsId(390822)
      return
    end
    local data = DataCenter.WorldFavoDataManager:GetCountryBookmarkByType(self.selectType, self.countryMarkData.sid)
    if data then
      self.ctrl:DelCountryMark(data.type)
    end
  else
    local fav = DataCenter.WorldFavoDataManager:GetBookmark(self.personalMarkData.pos, self.personalMarkData.sid, true)
    if fav then
      self.ctrl:DelBookMark(fav)
    end
    self.ctrl:CloseSelf()
  end
end

function UIPositionAddView:IptOnValueChange(value)
  self.name = value
end

function UIPositionAddView:OnTimeOrderSelectChange(cur_index, timerType, index)
  if timerType == TIMER_TYPE.COUNT_DOWN then
    if index == 1 then
      self.curSelectedCDTime.hour = cur_index - 1
    elseif index == 2 then
      self.curSelectedCDTime.min = cur_index - 1
    end
  elseif timerType == TIMER_TYPE.TIMING then
    if index == 1 then
      self.curSelectedTTime.date = cur_index - 1
    elseif index == 2 then
      self.curSelectedTTime.hour = cur_index - 1
    elseif index == 3 then
      self.curSelectedTTime.min = cur_index - 1
    end
    self:SetLocalTime()
  end
end

function UIPositionAddView:SetLocalTime()
  if self.curSelectedTimeType == TIMER_TYPE.COUNT_DOWN then
    self.textLocalTime:SetActive(false)
    return
  end
  self.textLocalTime:SetActive(true)
  local selectServerTime = self.ctrl:CalcTimeStampByDate(self.curSelectedTTime.date, self.curSelectedTTime.hour, self.curSelectedTTime.min, self.zeroStamp)
  local selectLocalTime = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(selectServerTime, false, true)
  self.textLocalTime:SetLocalText("zombierush_plan_title5", selectLocalTime or "")
end

function UIPositionAddView:SelectTimer(timerType)
  if self.curSelectedTimeType == timerType then
    return
  end
  self.curSelectedTimeType = timerType
  self.toggleCountDown:SetIsOn(timerType == TIMER_TYPE.COUNT_DOWN)
  self.toggleTiming:SetIsOn(timerType == TIMER_TYPE.TIMING)
  self.compCountDownPanel:SetActive(timerType == TIMER_TYPE.COUNT_DOWN)
  self.compTimingPanel:SetActive(timerType == TIMER_TYPE.TIMING)
  self.textLocalTime:SetActive(timerType == TIMER_TYPE.TIMING)
  if timerType == TIMER_TYPE.COUNT_DOWN then
    self.compCDTimeOrderItem:MoveToTargetIndex(self.curSelectedCDTime.hour + 1)
    self.compCDMinOrderItem:MoveToTargetIndex(self.curSelectedCDTime.min + 1)
    self.compCDTimeOrderItem:RefreshSelectItem()
    self.compCDMinOrderItem:RefreshSelectItem()
  elseif timerType == TIMER_TYPE.TIMING then
    self.compTDateOrderItem:MoveToTargetIndex(self.curSelectedTTime.date + 1)
    self.compTTimeOrderItem:MoveToTargetIndex(self.curSelectedTTime.hour + 1)
    self.compTMinOrderItem:MoveToTargetIndex(self.curSelectedTTime.min + 1)
    self.compTDateOrderItem:RefreshSelectItem()
    self.compTTimeOrderItem:RefreshSelectItem()
    self.compTMinOrderItem:RefreshSelectItem()
    self:SetLocalTime()
  end
end

function UIPositionAddView:SetR4R5Visible(isVisible)
  self.toggleR4R5Visible:SetIsOn(isVisible)
end

function UIPositionAddView:SetTimer(startTime)
  local now_time = UITimeManager:GetInstance():GetServerTime()
  if startTime and 0 < startTime and startTime > now_time then
    local isCountry = self.curMarkGroup == MarkGroup.WarZone
    local select_type_record
    if isCountry then
      select_type_record = self.countryMarkData.operateType
    else
      select_type_record = self.allianceMarkData.operateType
    end
    if not select_type_record or select_type_record < 0 or 1 < select_type_record then
      select_type_record = UITimeManager:GetInstance():IsIntPointTime(startTime, 1) and TIMER_TYPE.TIMING or TIMER_TYPE.COUNT_DOWN
    end
    if select_type_record == TIMER_TYPE.TIMING then
      self:SelectTimer(TIMER_TYPE.TIMING)
      self:SetTTimer(startTime)
    else
      self:SelectTimer(TIMER_TYPE.COUNT_DOWN)
      self:SetCDTimer(startTime - now_time)
    end
  else
    self:SelectTimer(TIMER_TYPE.COUNT_DOWN)
  end
end

function UIPositionAddView:SetTTimer(startTime)
  local day_offset = UITimeManager:GetInstance():GetBetweenDaysForServerTime(self.zeroStamp / 1000, startTime / 1000)
  local time_format = UITimeManager:GetInstance():TimeStampToServerDate(startTime)
  self.curSelectedTTime.date = day_offset
  self.curSelectedTTime.hour = time_format.hour
  self.curSelectedTTime.min = time_format.min
  self.compTDateOrderItem:MoveToTargetIndex(day_offset + 1)
  self.compTTimeOrderItem:MoveToTargetIndex(time_format.hour + 1)
  self.compTMinOrderItem:MoveToTargetIndex(time_format.min + 1)
end

function UIPositionAddView:SetCDTimer(leftTime)
  local day, hour, min = UITimeManager:GetInstance():MilliSecondToFmtFormat(leftTime)
  self.curSelectedCDTime.hour = day * 24 + hour
  self.curSelectedCDTime.min = min
  if self.curSelectedCDTime.hour <= MAX_CD_HOUR then
    self.compCDTimeOrderItem:MoveToTargetIndex(self.curSelectedCDTime.hour + 1)
    self.compCDMinOrderItem:MoveToTargetIndex(self.curSelectedCDTime.min + 1)
  else
    self:SelectTimer(TIMER_TYPE.TIMING)
    self:SetTTimer(leftTime + UITimeManager:GetInstance():GetServerTime())
  end
end

function UIPositionAddView:RefreshGroupMarkToggles(initPos)
  if self.curMarkGroup ~= MarkGroup.WarZone and self.curMarkGroup ~= MarkGroup.Alliance then
    return
  end
  if self.curMarkGroup == MarkGroup.WarZone then
    self.scAlMarkScrollView:SetSizeDeltaY(316)
  elseif self.curMarkGroup == MarkGroup.Alliance then
    self.scAlMarkScrollView:SetSizeDeltaY(256)
  end
  local type_list = self.markTypeGroupList[self.curMarkGroup] or {}
  for index, toggle in pairs(self.allianceMarksDic) do
    local mark_type = type_list[index]
    local active = mark_type ~= nil
    toggle:SetActive(active)
    if active then
      local icon_name = DataCenter.WorldFavoDataManager:GetBookMapMarkIconName(mark_type)
      toggle:SetIconSprite(string.format(LoadPath.AllianceMark, icon_name))
      local is_in_use
      if self.curMarkGroup == MarkGroup.WarZone then
        is_in_use = DataCenter.WorldFavoDataManager:CheckIfCountryMarkInUse(mark_type)
      else
        is_in_use = DataCenter.WorldFavoDataManager:CheckIfAllianceMarkInUse(mark_type)
      end
      toggle:SetTipActive(is_in_use ~= nil)
    end
  end
  if initPos then
    self:RefreshScAlMarkScoreView()
  end
end

function UIPositionAddView:RefreshScAlMarkScoreView()
  if self.togGroupRefreshDelay ~= nil then
    self.togGroupRefreshDelay:Stop()
  end
  self.togGroupRefreshDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.togGroupRefreshDelay = nil
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compAlMarkContent.rectTransform)
    self.scAlMarkScrollView:AnimVerticalNormalizedPos(1, 0.1)
  end, 0.1)
end

function UIPositionAddView:SelectMarkGroup(markGroup, needCheckType)
  if self.curMarkGroup == markGroup then
    return
  end
  self.curMarkGroup = markGroup
  local isAlliance = self.curMarkGroup == MarkGroup.Alliance
  local isCountry = self.curMarkGroup == MarkGroup.WarZone
  local isPersonal = self.curMarkGroup == MarkGroup.Personal
  self.togglePersonal:SetIsOn(isPersonal)
  self.toggleAlliance:SetIsOn(isAlliance)
  self.toggleCountry:SetIsOn(isCountry)
  self.compPersonalMarkPanel:SetActive(isPersonal)
  self.compAllianceMarkPanel:SetActive(not isPersonal)
  self.toggleR4R5Visible:SetActive(isAlliance)
  self.textR4R5Visible:SetActive(isAlliance)
  self.textTitle:SetLocalText(isPersonal and 300033 or 390847)
  self:RefreshGroupMarkToggles(true)
  if needCheckType then
    if isAlliance then
      self:SelectMarkType(self:GetDefaultSelectType())
      self:SetR4R5Visible((self.allianceMarkData.viewRank or 0) >= 4)
      self:SetTimer(self.allianceMarkData.startTime or 0)
    elseif isCountry then
      self:SelectMarkType(self:GetDefaultSelectType())
      self:SetR4R5Visible(false)
      self:SetTimer(self.countryMarkData.startTime or 0)
    else
      local cur_exist_mark_type = self.personalMarkData.type or -1
      if IsPersonalMarkType(cur_exist_mark_type) then
        self:SelectMarkType(cur_exist_mark_type)
      else
        self:SelectMarkType(MarkType.Special)
      end
    end
  end
end

function UIPositionAddView:OnMarkTogValueChanged(index)
  local type_list = self.markTypeGroupList[self.curMarkGroup] or self.markTypeGroupList[MarkGroup.Alliance]
  local mark_type = type_list[index]
  if mark_type ~= nil then
    self:SelectMarkType(mark_type)
  end
end

function UIPositionAddView:SelectMarkType(markType)
  if self.selectType == markType then
    return
  end
  if markType < MarkType.Special or markType > MarkType.COUNTRY_END then
    markType = self.curMarkGroup == MarkGroup.Personal and MarkType.Special or self:GetDefaultSelectType()
  end
  if self.curMarkGroup == MarkGroup.Alliance and not IsAllianceMarkType(markType) then
    self:SelectMarkGroup(IsPersonalMarkType(markType) and MarkGroup.Personal or MarkGroup.WarZone, false)
    self:SelectMarkType(markType)
    return
  end
  if self.curMarkGroup == MarkGroup.WarZone and not IsCountryMarkType(markType) then
    self:SelectMarkGroup(IsPersonalMarkType(markType) and MarkGroup.Personal or MarkGroup.Alliance, false)
    self:SelectMarkType(markType)
    return
  end
  if self.curMarkGroup == MarkGroup.Personal and not IsPersonalMarkType(markType) then
    self:SelectMarkGroup(IsCountryMarkType(markType) and MarkGroup.WarZone or MarkGroup.Alliance, false)
    self:SetR4R5Visible(self.curMarkGroup == MarkGroup.Alliance and self.allianceMarkData.viewRank >= 4)
    self:SelectMarkType(markType)
    return
  end
  self.selectType = markType
  if self.curMarkGroup == MarkGroup.Alliance or self.curMarkGroup == MarkGroup.WarZone then
    self:RefreshGroupMarkToggles()
    local type_list = self.markTypeGroupList[self.curMarkGroup] or {}
    for index, type_value in ipairs(type_list) do
      self.allianceMarksDic[index]:SetIsOn(type_value == self.selectType)
    end
  else
    self.toggleSpecial:SetIsOn(markType == MarkType.Special)
    self.toggleFrd:SetIsOn(markType == MarkType.Friend)
    self.toggleEnemy:SetIsOn(markType == MarkType.Enemy)
    self:RefreshPersonalMark(markType)
  end
  self:RefreshDelBtn()
  self:SetDefaultContent(self.selectType)
end

function UIPositionAddView:RefreshPersonalMark(markType)
  self.curPersonalMarkList = {}
  local mark_data_by_type = DataCenter.WorldFavoDataManager:GetBookListByType(markType)
  for _, v in pairs(mark_data_by_type) do
    table.insert(self.curPersonalMarkList, v)
  end
  if self.personalMarkData.type == self.selectType then
    local cur_pos = self.personalMarkData.pos
    local cur_sid = self.personalMarkData.sid
    for i, v in ipairs(self.curPersonalMarkList) do
      if v.pos == cur_pos and v.server == cur_sid then
        table.remove(self.curPersonalMarkList, i)
        table.insert(self.curPersonalMarkList, 1, v)
        break
      end
    end
  end
  self.compNoMarkPanel:SetActive(#self.curPersonalMarkList == 0)
  self.MarksScrollViewVertical:SetTotalCount(#self.curPersonalMarkList)
  self.MarksScrollViewVertical:RefillCells()
end

function UIPositionAddView:OnItemMoveIn(itemObj, index)
  local item = self.curPersonalMarkItemList[itemObj.name]
  if not item then
    local name = tostring(self.personalMarkItemIndex)
    itemObj.name = name
    item = self.MarksScrollViewVertical:AddComponent(MarkItemTemplate, itemObj)
    self.curPersonalMarkItemList[name] = item
    self.personalMarkItemIndex = self.personalMarkItemIndex + 1
  end
  item:SetData(self.curPersonalMarkList[index])
end

function UIPositionAddView:RefreshDelBtn()
  if self.btnDelete == nil then
    return
  end
  if IsPersonalMarkType(self.selectType) then
    local fav = DataCenter.WorldFavoDataManager:GetBookmark(self.personalMarkData.pos, self.personalMarkData.sid, true)
    self.btnDelete:SetActive(fav ~= nil)
  elseif IsAllianceMarkType(self.selectType) then
    local isInUse = DataCenter.WorldFavoDataManager:CheckIfAllianceMarkInUse(self.selectType)
    self.btnDelete:SetActive(isInUse)
  elseif IsCountryMarkType(self.selectType) then
    local isInUse = DataCenter.WorldFavoDataManager:CheckIfCountryMarkInUse(self.selectType)
    self.btnDelete:SetActive(isInUse)
  end
end

function UIPositionAddView:GetDefaultSelectType(markGroup)
  markGroup = markGroup or self.curMarkGroup
  local markType
  if markGroup == MarkGroup.WarZone then
    if self.countryMarkData and next(self.countryMarkData) ~= nil then
      local countryMark = DataCenter.WorldFavoDataManager:GetCountryBookmark(self.countryMarkData.pos, self.countryMarkData.sid)
      markType = countryMark and countryMark.type
    end
    markType = markType or DataCenter.WorldFavoDataManager:GetCountryBookmarkUnusedType()
    return markType
  end
  if self.allianceMarkData and next(self.allianceMarkData) ~= nil then
    local allianceMark = DataCenter.WorldFavoDataManager:GetAllianceBookmark(self.allianceMarkData.pos, self.allianceMarkData.sid)
    markType = allianceMark and allianceMark.type
  end
  markType = markType or DataCenter.WorldFavoDataManager:GetAllianceBookmarkUnusedType()
  return markType
end

function UIPositionAddView:InitDefaultContent(t)
  local uname, oname, name
  if not string.IsNullOrEmpty(t.uname) then
    if string.IsNullOrEmpty(t.abbr) then
      uname = t.uname
    else
      uname = "[" .. t.abbr .. "]" .. t.uname
    end
  end
  if not string.IsNullOrEmpty(t.oname) then
    if Localization:HasKey(t.oname) then
      oname = Localization:GetString(t.oname)
    else
      oname = t.oname
    end
    if t.olv then
      oname = Localization:GetString("science_condition", t.olv, oname)
    end
  end
  if uname ~= nil and oname ~= nil then
    name = Localization:GetString(GameDialogDefine.POSITION_DESC, uname, oname)
  else
    if uname ~= nil then
      name = uname
    end
    if oname ~= nil then
      name = oname
    end
  end
  return name
end

function UIPositionAddView:SetDefaultContent(selectType)
  if self.chat_data_param then
    local data = DataCenter.WorldFavoDataManager:GetBookmark(self.chat_data_param.pos, self.chat_data_param.sid)
    if data and data.name and data.type then
      local dataGroupType
      if IsPersonalMarkType(data.type) then
        dataGroupType = MarkGroup.Personal
      elseif IsCountryMarkType(data.type) then
        dataGroupType = MarkGroup.WarZone
      else
        dataGroupType = MarkGroup.Alliance
      end
      if dataGroupType == self.curMarkGroup then
        self.inputField:SetText(data.name)
        return
      end
    end
  end
  local content = selectType and DataCenter.WorldFavoDataManager:GetBookMarkDefaultName(selectType)
  if content then
    self.inputField:SetText(Localization:GetString(content))
    return
  end
  if self.defaultName then
    self.inputField:SetText(self.defaultName)
  end
end

return UIPositionAddView
