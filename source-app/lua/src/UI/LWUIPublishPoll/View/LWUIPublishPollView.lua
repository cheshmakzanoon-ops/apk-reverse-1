local LWUIPublishPollView = BaseClass("LWUIPublishPollView", UIBaseView)
local UIhSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local UIPublishOptionItem = require("UI.LWUIPublishPoll.Component.UIPublishOptionItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local UIGray = CS.UIGray
local maxCount = 10
local characterLimit = 300
local base = UIBaseView
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local title_input_txt_sample_path = "panel/midContent/ScrollView/Viewport/Content/titleInputTxtSample"
local content_path = "panel/midContent/ScrollView/Viewport/Content"
local voting_option_item_path = "panel/midContent/ScrollView/Viewport/Content/VotingOptionItem"
local options_content_path = "panel/midContent/ScrollView/Viewport/Content/OptionsContent"
local be_select_content_relative_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/RelativeTimeContent/beSelectContentRelative"
local be_select_relative_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/RelativeTimeContent/beSelectContentRelative/beSelectRelative"
local duration_drop_relative_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/RelativeTimeContent/durationDropRelative"
local be_select_content_assign_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/beSelectContentAssign"
local be_select_assign_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/beSelectContentAssign/beSelectAssign"
local assign_select_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/AssignSelect"
local label_assign_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/AssignSelect/LabelAssign"
local time_type_txt_assign_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/timeTypeTxtAssign"
local change_time_type_btn_path = "panel/midContent/ScrollView/Viewport/Content/timeTypeContent/AssignTimeContent/ChangeTimeTypeBtn"
local titleTxtSpace = 12
local titleTxtMinH = 41

function LWUIPublishPollView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:TryinputParamView()
end

function LWUIPublishPollView:OnDestroy()
  self:ClearAllItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPublishPollView:OnEnable()
  base.OnEnable(self)
end

function LWUIPublishPollView:OnDisable()
  base.OnDisable(self)
end

function LWUIPublishPollView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.NoticeVoteTimeSet, self.NoticeVoteTimeSet)
end

function LWUIPublishPollView:OnRemoveListener()
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.NoticeVoteTimeSet, self.NoticeVoteTimeSet)
  base.OnRemoveListener(self)
end

function LWUIPublishPollView:DataDefine()
  self.countdownTypeList = {
    1,
    3,
    6,
    12,
    24,
    48,
    72
  }
  self.selectTimeType = VoteNoticeEndTime.END_TIME_RELATIVE
  self.selectTimeEndTimeType = TimeShowType.Local
  self.selectedCountdown = 0
  self.selectTimeEndTime = DataCenter.AllianceNoticeManager:GetVoteSelectFirstTimeByCurTime()
  for i = 1, #self.countdownTypeList do
    local temp = OptionData()
    temp.text = Localization:GetString("alliance_vote_option_hour", self.countdownTypeList[i])
    self.countdownDrop:Add(temp)
  end
  self.countdownDrop:SetValue(0)
  self:OnCountdownChange(0)
  self.__waiting_for_response = nil
  self.inputParam = nil
  self.preTitleTxtH = 0
  self.preTitleTxtHNeedRefresh = false
end

function LWUIPublishPollView:DataDestroy()
  self.votingOptionDatas = nil
  self.isMore = nil
  self.__waiting_for_response = nil
  self.inputParam = nil
  self.preTitleTxtH = nil
  self.preTitleTxtHNeedRefresh = false
  self.selectTimeType = nil
  self.selectTimeEndTimeType = nil
  self.selectedCountdown = nil
  self.selectTimeEndTime = nil
end

function LWUIPublishPollView:ComponentDefine()
  self.titleInput = self:AddComponent(UIInput, "panel/midContent/ScrollView/Viewport/Content/titleInputContent/titleInput")
  self.titleInputLayout = self:AddComponent(UILayoutElement, "panel/midContent/ScrollView/Viewport/Content/titleInputContent")
  self.titleInputText = self:AddComponent(UITextMeshProUGUIEx, "panel/midContent/ScrollView/Viewport/Content/titleInputContent/titleInput/Text Area/Text")
  self.sendBtn = self:AddComponent(UIButton, "panel/bottomContent/sendBtn")
  self.multipleSlider = self:AddComponent(UIhSettingsSlider, "panel/midContent/ScrollView/Viewport/Content/layout/itemMultiple/multipleSlider")
  self.cryptonymSlider = self:AddComponent(UIhSettingsSlider, "panel/midContent/ScrollView/Viewport/Content/layout/itemCryptonym/cryptonymSlider")
  self.onlyR4R5Slider = self:AddComponent(UIhSettingsSlider, "panel/midContent/ScrollView/Viewport/Content/layout/itemOnlyR4R5/OnlyR4R5Slider")
  self.closeBtn = self:AddComponent(UIButton, "panel/topContent/btnClose")
  self.panelBtn = self:AddComponent(UIButton, "curtain")
  self.introBtn = self:AddComponent(UIButton, "panel/topContent/Intro")
  self.sendBtn:SetOnClick(function()
    self:OnSendClick()
  end)
  self.introBtn:SetOnClick(function()
    self:OnIntroBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  
  function self.multipleSlider.onSwitch(isOn)
    self.isMore = isOn
  end
  
  function self.cryptonymSlider.onSwitch(isOn)
    self.isCryptonym = isOn
  end
  
  function self.onlyR4R5Slider.onSwitch(isOn)
    self.isOnlyR4R5Slider = isOn and 1 or 0
  end
  
  ChatInterface.SetEmojiTextProperty(self.titleInputText)
  self.titleInput:SetText("")
  self.titleInput:SetOnValueChange(function(text)
    self:OnTitleInputValueChange(text)
  end)
  self.countdownDrop = self:AddComponent(UIDropdown, duration_drop_relative_path)
  self.countdownDrop:Clear()
  self.countdownDrop:SetOnValueChanged(function(index)
    self:OnCountdownChange(index)
  end)
  self.title_input_txt_sample = self:AddComponent(UITextMeshProUGUIEx, title_input_txt_sample_path)
  ChatInterface.SetEmojiTextProperty(self.title_input_txt_sample)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.voting_option_item = self:AddComponent(UIBaseContainer, voting_option_item_path)
  self.options_content = self:AddComponent(UIBaseContainer, options_content_path)
  self.optionItems = {}
  self.voting_option_item:SetActive(false)
  self.voting_option_item.gameObject:GameObjectCreatePool()
  self.be_select_content_relative = self:AddComponent(UIButton, be_select_content_relative_path)
  self.be_select_relative = self:AddComponent(UIImage, be_select_relative_path)
  self.be_select_content_assign = self:AddComponent(UIButton, be_select_content_assign_path)
  self.be_select_assign = self:AddComponent(UIImage, be_select_assign_path)
  self.assign_select = self:AddComponent(UIButton, assign_select_path)
  self.label_assign = self:AddComponent(UITextMeshProUGUIEx, label_assign_path)
  self.time_type_txt_assign = self:AddComponent(UITextMeshProUGUIEx, time_type_txt_assign_path)
  self.change_time_type_btn = self:AddComponent(UIButton, change_time_type_btn_path)
  self.be_select_content_relative:SetOnClick(function()
    self:OnTimeTypeChange(VoteNoticeEndTime.END_TIME_RELATIVE)
  end)
  self.be_select_content_assign:SetOnClick(function()
    self:OnTimeTypeChange(VoteNoticeEndTime.END_TIME_ASSIGN)
  end)
  self.change_time_type_btn:SetOnClick(function()
    self:OnEndTimeTypeChange()
  end)
  self.assign_select:SetOnClick(function()
    local data = {
      time = self.selectTimeEndTime,
      type = self.selectTimeEndTimeType
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeDatePicker, {anim = true}, data)
  end)
end

function LWUIPublishPollView:ComponentDestroy()
  self.votingOption = nil
  self.titleInput = nil
  self.sendBtn = nil
  self.closeBtn = nil
  self.panelBtn = nil
  self.title_input_txt_sample = nil
  self.content = nil
  self.voting_option_item = nil
  self.options_content = nil
  self.be_select_content_relative = nil
  self.be_select_relative = nil
  self.duration_drop_relative = nil
  self.be_select_content_assign = nil
  self.be_select_assign = nil
  self.assign_select = nil
  self.label_assign = nil
  self.time_type_txt_assign = nil
  self.change_time_type_btn = nil
end

function LWUIPublishPollView:ClearAllItems()
  self.options_content:RemoveComponents(UIPublishOptionItem)
  self.voting_option_item.gameObject:GameObjectRecycleAll()
  self.optionItems = {}
end

function LWUIPublishPollView:OnSliderSwitched(isOn)
end

function LWUIPublishPollView:OnTitleInputValueChange(text)
  if string.len(text) > characterLimit then
    self.titleInput:SetText(string.SubStr(text, 0, characterLimit))
  end
  self:RefreshViewBtnState()
  self:SetRefreshTitleInputHeightPoint()
end

function LWUIPublishPollView:SetRefreshTitleInputHeightPoint()
  local curTxt = self.titleInput:GetText()
  self.title_input_txt_sample:SetText(curTxt)
  local txtSize = self.title_input_txt_sample:GetSizeDelta()
  local curHeight = self.title_input_txt_sample.unity_tmpro:GetPreferredValues(txtSize.x, 0).y
  curHeight = math.max(curHeight, titleTxtMinH)
  self.title_input_txt_sample:SetSizeDeltaY(curHeight)
  if math.abs(curHeight - self.preTitleTxtH) > 1 then
    self.preTitleTxtH = curHeight
    local inputHeight = curHeight + titleTxtSpace * 2
    self.titleInputLayout:SetMinHeight(inputHeight)
    self.titleInputLayout:SetPreferredHeight(inputHeight)
    self.preTitleTxtHNeedRefresh = true
  end
end

function LWUIPublishPollView:RefreshTimeContent()
  if self.selectTimeType == VoteNoticeEndTime.END_TIME_RELATIVE then
    UIGray.SetGray(self.countdownDrop.transform, false, true)
    UIGray.SetGray(self.assign_select.transform, true, false)
    self.countdownDrop:SetInteractable(true)
  elseif self.selectTimeType == VoteNoticeEndTime.END_TIME_ASSIGN then
    UIGray.SetGray(self.assign_select.transform, false, true)
    UIGray.SetGray(self.countdownDrop.transform, true, false)
    self.countdownDrop:SetInteractable(false)
  end
  self.be_select_relative:SetActive(self.selectTimeType == VoteNoticeEndTime.END_TIME_RELATIVE)
  self.be_select_assign:SetActive(self.selectTimeType == VoteNoticeEndTime.END_TIME_ASSIGN)
  local timeStr = ""
  if self.selectTimeEndTimeType == TimeShowType.Local then
    self.time_type_txt_assign:SetLocalText("Desert_strom_tips1001")
    if self.selectTimeEndTime > 0 then
      timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.selectTimeEndTime, false, true)
    end
  elseif self.selectTimeEndTimeType == TimeShowType.Server then
    self.time_type_txt_assign:SetLocalText("Desert_strom_tips1002")
    if self.selectTimeEndTime > 0 then
      timeStr = UITimeManager:GetInstance():GetServerTimeByUTC(self.selectTimeEndTime, false, true)
    end
  end
  self.label_assign:SetText(timeStr)
end

function LWUIPublishPollView:OnTimeDataChangeRefresh()
  self:RefreshTimeContent()
  self:RefreshViewBtnState()
end

function LWUIPublishPollView:OnTimeTypeChange(type)
  if self.selectTimeType == type then
    return
  end
  self.selectTimeType = type
  self:OnTimeDataChangeRefresh()
end

function LWUIPublishPollView:OnEndTimeTypeChange()
  if self.selectTimeEndTimeType == TimeShowType.Server then
    self.selectTimeEndTimeType = TimeShowType.Local
  elseif self.selectTimeEndTimeType == TimeShowType.Local then
    self.selectTimeEndTimeType = TimeShowType.Server
  end
  self:OnTimeDataChangeRefresh()
end

function LWUIPublishPollView:Update()
  if self.preTitleTxtHNeedRefresh then
    self.preTitleTxtHNeedRefresh = false
    self.titleInputText:SetAnchoredPositionXY(0, 0)
    self.titleInput.unity_tmpinput:ForceAssignPositioningIfNeeded()
  end
end

function LWUIPublishPollView:OnSendClick()
  if self.__waiting_for_response then
    return
  end
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not isR4orR5 then
    UIUtil.ShowTipsId("alliance_announcement_r4r5_tips")
    return
  end
  local checkTimecfg = LuaEntry.DataConfig:TryGetNum("alliance_announcement_edit", "k2")
  if checkTimecfg and 0 < checkTimecfg and self.selectTimeType == VoteNoticeEndTime.END_TIME_ASSIGN then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.selectTimeEndTime - curTime < checkTimecfg * 60 * 1000 then
      UIUtil.ShowTips(Localization:GetString("alliancenotice_sendcd_tips1", checkTimecfg))
      return
    end
  end
  local datas = {}
  for i = 1, #self.votingOptionDatas - 1 do
    table.insert(datas, {
      itemId = i,
      item = self.votingOptionDatas[i].info
    })
  end
  self.__waiting_for_response = true
  local titleText = self.titleInput:GetText()
  local param = {
    title = titleText,
    options = datas,
    type = self.isMore and VoteType.More or VoteType.radio,
    noticeType = ChatNoticeType.ALLIANCE_VOTE,
    isCryptonym = self.isCryptonym,
    timeHour = self.selectedCountdown,
    isR4R5 = self.isOnlyR4R5Slider,
    timeType = self.selectTimeType,
    endTime = self.selectTimeEndTime
  }
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
  AlPostEventLog.PostEventLog_Notice_Send(AlPostEventLog.NoticeSendType.New, AlPostEventLog.NoticeContentType.Vote, titleText, false)
end

function LWUIPublishPollView:OnCountdownChange(index)
  self.selectedCountdown = self.countdownTypeList[index + 1]
end

function LWUIPublishPollView:ShowScroll()
  local count = #self.votingOptionDatas
  if self.optionItems == nil then
    self.optionItems = {}
  end
  for i = 1, count do
    local data = self.votingOptionDatas[i]
    if self.optionItems[i] then
      self.optionItems[i]:SetActive(true)
    else
      local item = self.voting_option_item.gameObject:GameObjectSpawn(self.options_content.transform)
      item.name = i
      local obj = self.options_content:AddComponent(UIPublishOptionItem, item.name)
      obj:SetActive(true)
      self.optionItems[i] = obj
    end
    local item = self.optionItems[i]
    item:ReInit(self.votingOptionDatas[i], i, function(i, text)
      self:OnOptionValueChange(i, text)
    end)
  end
  for i = count + 1, #self.optionItems do
    self.optionItems[i]:SetActive(false)
  end
end

function LWUIPublishPollView:DeleteOption(index)
  if #self.votingOptionDatas - 1 <= 2 then
    return
  end
  table.remove(self.votingOptionDatas, index)
  self:RefreshViewBtnState()
  self:ShowScroll()
end

function LWUIPublishPollView:OnIntroBtnClick()
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("alliance_post_poll_explain")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 180
  param.pivot = 0.5
  param.position = self.introBtn.transform.position + Vector3.New(35, 0, 0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function LWUIPublishPollView:RefreshViewBtnState(index, text)
  if index and text then
    self:UpdateOptionData(index, text)
  end
  local textContainNil = self.ctrl:GetOptionsTextIsNil(self.votingOptionDatas)
  local state = 1
  if #self.votingOptionDatas - 1 == 2 then
    state = 1
  else
    state = 2
  end
  for i = 1, #self.votingOptionDatas - 1 do
    self.votingOptionDatas[i].bgIndex = state
  end
  if #self.votingOptionDatas - 1 < maxCount and not textContainNil then
    self.votingOptionDatas[#self.votingOptionDatas].bgIndex = 4
  else
    self.votingOptionDatas[#self.votingOptionDatas].bgIndex = 3
  end
  self:UpdateSendBtnState()
end

function LWUIPublishPollView:AddOption()
  local lastIndex = #self.votingOptionDatas - 1
  if self.votingOptionDatas and self.votingOptionDatas[lastIndex] then
    self.votingOptionDatas[lastIndex].setFocus = false
  end
  table.insert(self.votingOptionDatas, #self.votingOptionDatas, {
    btnType = 1,
    bgIndex = 1,
    info = "",
    setFocus = true
  })
  self:RefreshViewBtnState()
  self:ShowScroll()
end

function LWUIPublishPollView:UpdateSendBtnState()
  local textContainNil = self.ctrl:GetOptionsTextIsNil(self.votingOptionDatas)
  local isTimeSetPass = self:CheckTimeSetPass()
  if not textContainNil and not string.IsNullOrEmpty(self.titleInput:GetText()) and isTimeSetPass then
    UIGray.SetGray(self.sendBtn.transform, false, true)
  else
    UIGray.SetGray(self.sendBtn.transform, true, false)
  end
end

function LWUIPublishPollView:CheckTimeSetPass()
  local isPass = false
  if self.selectTimeType == VoteNoticeEndTime.END_TIME_RELATIVE then
    isPass = true
  elseif self.selectTimeType == VoteNoticeEndTime.END_TIME_ASSIGN and self.selectTimeEndTime > 0 then
    isPass = true
  end
  return isPass
end

function LWUIPublishPollView:UpdateOptionData(index, info)
  if self.votingOptionDatas[index] then
    if not self.votingOptionDatas[index].info then
      self.votingOptionDatas[index].info = {}
    end
    self.votingOptionDatas[index].info = info
  end
end

function LWUIPublishPollView:OnOptionValueChange(index, text)
  self:RefreshViewBtnState(index, text)
  if self.votingOptionDatas then
    local count = math.min(#self.votingOptionDatas, #self.optionItems)
    for i = 1, count do
      self.optionItems[i]:UpdateIconBg(self.votingOptionDatas[i].bgIndex)
    end
  end
end

function LWUIPublishPollView:ReInit()
  self.inputParam = self:GetUserData()
  self.content:SetAnchoredPositionXY(0, 0)
  self.votingOptionDatas = self.ctrl:GetInitOptionDatas()
  self:ShowScroll()
  self:UpdateSendBtnState()
  self.multipleSlider:Switch(false)
  self.cryptonymSlider:Switch(false)
  self.onlyR4R5Slider:Switch(false)
  self:SetRefreshTitleInputHeightPoint()
  self:RefreshTimeContent()
end

function LWUIPublishPollView:TryinputParamView()
  if self.inputParam == nil then
    return
  end
  if self.inputParam.voteData == nil then
    return
  end
  local titleText, options, type, isCryptonym, isR4R5, timeType, timeHour, endTime
  titleText = self.inputParam.voteData.voteInfo.title
  options = self.inputParam.voteData.voteInfo.options
  type = self.inputParam.voteData.voteInfo.type
  isCryptonym = self.inputParam.voteData.voteInfo.isCryptonym
  isR4R5 = self.inputParam.isR4R5 == 1
  timeType = self.inputParam.voteData.voteInfo.timeType
  timeHour = self.inputParam.voteData.voteInfo.timeHour
  endTime = self.inputParam.voteData.endTime
  if titleText then
    self.titleInput:SetText(titleText)
  end
  if options and 0 < #options then
    self.votingOptionDatas = {}
    for i = 1, #options do
      local optionsData = options[i]
      local data = {
        btnType = 1,
        bgIndex = 1,
        info = optionsData.item
      }
      table.insert(self.votingOptionDatas, data)
    end
    local data = {
      btnType = 2,
      bgIndex = 1,
      info = ""
    }
    table.insert(self.votingOptionDatas, data)
  end
  if type then
    if type == VoteType.radio then
      self.multipleSlider:Switch(false)
    else
      self.multipleSlider:Switch(true)
    end
  end
  if isCryptonym then
    self.cryptonymSlider:Switch(true)
  else
    self.cryptonymSlider:Switch(false)
  end
  if isR4R5 then
    self.onlyR4R5Slider:Switch(true)
  else
    self.onlyR4R5Slider:Switch(false)
  end
  if timeType then
    self.selectTimeType = timeType
  end
  if timeHour then
    self.selectedCountdown = timeHour
    local setVal = 0
    for i = 1, #self.countdownTypeList do
      if self.countdownTypeList[i] == timeHour then
        setVal = i - 1
        break
      end
    end
    self.countdownDrop:SetValue(setVal)
  end
  if endTime and timeType and timeType == VoteNoticeEndTime.END_TIME_ASSIGN then
    self.selectTimeEndTime = endTime
    self.selectTimeEndTimeType = TimeShowType.Local
  end
  self:RefreshViewBtnState()
  self:ShowScroll()
  self:SetRefreshTitleInputHeightPoint()
  self:RefreshTimeContent()
end

function LWUIPublishPollView:OnServerError(msgName)
  if msgName == MsgDefines.AllianceChangeNotice then
    self.__waiting_for_response = nil
  end
end

function LWUIPublishPollView:NoticeVoteTimeSet(data)
  if data == nil then
    return
  end
  self.selectTimeEndTimeType = data.type
  self.selectTimeEndTime = data.time
  self:OnTimeDataChangeRefresh()
end

return LWUIPublishPollView
