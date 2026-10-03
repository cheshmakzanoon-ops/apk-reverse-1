local AllianceMain = BaseClass("AllianceMain", UIBaseContainer)
local base = UIBaseContainer
local AllianceFunItem = require("UI.UIAlliance.UIAllianceMainTable.Component.AllianceFunItem")
local AllianceLogGrid = require("UI.UIAlliance.UIAllianceMainTable.Component.AllianceLogGrid")
local AllianceLogCell = require("UI.UIAlliance.UIAllianceMainTable.Component.AllianceLogCell")
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local Localization = CS.GameEntry.Localization
local name_path = "TopInfo/name"
local flag_path = "TopInfo/icon/AllianceFlag"
local power_txt_path = "TopInfo/power/powerTxt"
local leader_path = "TopInfo/leader"
local leader_txt_path = "TopInfo/leader/leaderTxt"
local leader_chat_btn_path = "TopInfo/leader/leaderTxt/leaderChatBtn"
local language_path = "TopInfo/language"
local language_txt_path = "TopInfo/language/languageTxt"
local countryFlag_path = "TopInfo/language/languageTxt/countryFlag"
local gift_path = "TopInfo/gift"
local gift_txt_path = "TopInfo/gift/giftTxt"
local people_path = "TopInfo/people"
local people_txt_path = "TopInfo/people/peopleTxt"
local mail_btn_path = "TopInfo/people/peopleTxt/mailButton"
local des_txt_path = "Align/ScrollView/Viewport/Content/desTxt"
local des_default_txt_path = "Align/ScrollView/Viewport/desDefaultTxt"
local set_announce_btn_path = "Align/setAnnounce"
local content_path = "Align/ItemScrollView/Viewport/Content"
local rect_alliancelog_path = "Align/Rect_AllianceLog"
local rect_logloop_path = "Align/Rect_AllianceLog/Rect_LogLoop"
local txt_logloop1_path = "Align/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop1"
local txt_logloop2_path = "Align/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop2"
local btn_showlog_path = "Align/Rect_AllianceLog/Btn_ShowLog"
local btn_hidelog_path = "Align/Rect_AllianceLog/Btn_HideLog"
local img_logSign1_path = "Align/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop1/Img_LogSign1"
local img_logSign2_path = "Align/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop2/Img_LogSign2"
local _cp_scrollView = "Align/Rect_AllianceLog/Scroll_AllianceLog"
local _cp_scrollViewContent = "Align/Rect_AllianceLog/Scroll_AllianceLog/Rect_ContentLog"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.name = self:AddComponent(UIText, name_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.leader = self:AddComponent(UIText, leader_path)
  self.leader_txt = self:AddComponent(UIText, leader_txt_path)
  self.leaderChatBtn = self:AddComponent(UIButton, leader_chat_btn_path)
  self.leaderChatBtn:SetOnClick(function()
    self:OnClickLeaderChatBtn()
  end)
  self.land = self:AddComponent(UIText, language_path)
  self.land_txt = self:AddComponent(UIText, language_txt_path)
  self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
  self.gift = self:AddComponent(UIText, gift_path)
  self.gift_txt = self:AddComponent(UIText, gift_txt_path)
  self.people = self:AddComponent(UIText, people_path)
  self.people_txt = self:AddComponent(UIText, people_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_default_txt = self:AddComponent(UIText, des_default_txt_path)
  self.set_announce_btn = self:AddComponent(UIButton, set_announce_btn_path)
  self.set_announce_btn:SetOnClick(function()
    self.view.ctrl:OnSetAnnounceClick(self.announce)
  end)
  self.set_announce_btn:SetActive(DataCenter.AllianceBaseDataManager:IsR4orR5())
  self.allianceFlag = self:AddComponent(AllianceFlagItem, flag_path)
  self.leader:SetLocalText(390006)
  self.land:SetLocalText(100101)
  self.gift:SetLocalText(390445)
  self.people:SetLocalText(390098)
  self.mail_btn = self:AddComponent(UIButton, mail_btn_path)
  self.mail_btn:SetActive(true)
  self.mail_btn:SetOnClick(function()
    self:OnClickMailBtn()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self._allianceLog_rect = self:AddComponent(UIBaseContainer, rect_alliancelog_path)
  self._logLoop_rect = self:AddComponent(UIBaseContainer, rect_logloop_path)
  self._logLoop1_txt = self:AddComponent(UIText, txt_logloop1_path)
  self._logLoop2_txt = self:AddComponent(UIText, txt_logloop2_path)
  self._logSign1_img = self:AddComponent(UIImage, img_logSign1_path)
  self._logSign2_img = self:AddComponent(UIImage, img_logSign2_path)
  self._logLoop1_txt:SetText(Localization:GetString("141096"))
  self._logSign1_img:SetActive(false)
  self._showLog_btn = self:AddComponent(UIButton, btn_showlog_path)
  self._showLog_btn:SetOnClick(function()
    self:OnClickLogBtn(1)
  end)
  self._hideLog_btn = self:AddComponent(UIButton, btn_hidelog_path)
  self._hideLog_btn:SetOnClick(function()
    self:OnClickLogBtn(2)
  end)
  self._scrollView = self:AddComponent(UILoopListView2, _cp_scrollView)
  self._scrollView_ScrollRect = self:AddComponent(UIScrollRect, _cp_scrollView)
  self._scrollViewContent = self:AddComponent(UIBaseContainer, _cp_scrollViewContent)
  self._scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  
  function self._scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnEndDrag()
  end
end

local function DataDefine(self)
  self._timer_loop = nil
  
  function self._timer_loop_action(temp)
    self:RefreshLog()
  end
  
  self.allLog = {}
  self.listLog = {}
  self.allLogCurNum = 0
  self.isCreat = false
  self.isShowLog = false
  self.lastLogCount = 0
  self.cells = {}
  self._isFetchingMore = false
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > self.count then
    return nil
  end
  self.prefabIndex = self.prefabIndex or 0
  local dt = self.listLog[self.count + 1 - index]
  if type(dt) == "number" then
    local item = loopScroll:NewListViewItem("AllianceLogGrid")
    if item == nil then
      return nil
    end
    if self.cells[item] ~= nil then
      self.cells[item]:SetActive(true)
      self.cells[item]:ReInit(dt)
    else
      local script = self._scrollViewContent:GetComponent(item.gameObject.name, AllianceLogGrid)
      if script == nil then
        local objectName = "AllianceLogGrid_" .. self.prefabIndex
        self.prefabIndex = self.prefabIndex + 1
        item.gameObject.name = objectName
        if not item.IsInitHandlerCalled then
          item.IsInitHandlerCalled = true
        end
        script = self._scrollViewContent:AddComponent(AllianceLogGrid, objectName)
      end
      script:SetActive(true)
      script:ReInit(dt)
      self.cells[item] = script
    end
    return item
  end
  local item = loopScroll:NewListViewItem("AllianceLogCell")
  if item == nil then
    return nil
  end
  if self.cells[item] ~= nil then
    self.cells[item]:SetActive(true)
    self.cells[item]:ReInit(dt)
  else
    local script = self._scrollViewContent:GetComponent(item.gameObject.name, AllianceLogCell)
    if script == nil then
      local objectName = "AllianceLogCell_" .. self.prefabIndex
      self.prefabIndex = self.prefabIndex + 1
      item.gameObject.name = objectName
      if not item.IsInitHandlerCalled then
        item.IsInitHandlerCalled = true
      end
      script = self._scrollViewContent:AddComponent(AllianceLogCell, objectName)
    end
    script:SetActive(true)
    script:ReInit(dt)
    self.cells[item] = script
  end
  return item
end

local function OnEndDrag(self)
  if not self._isFetchingMore and self._scrollView.unity_looplistview2.ContainerTrans.rect.height - self._scrollView.unity_looplistview2.ContainerTrans.localPosition.y < 400 then
    self:GetHistoricalChat()
  end
end

function AllianceMain:GetHistoricalChat()
  self._isFetchingMore = true
  SFSNetwork.SendMessage(MsgDefines.ViewAllianceLog, self.allLog[table.count(self.allLog)].time, false)
end

local function ShowButtons(self)
  self:ClearButtons()
  local list = self.view.ctrl:GetAllianceButtonShow()
  self.buttonListInType = {}
  self.model = {}
  if list ~= nil then
    local count = table.count(list)
    for i = 1, count do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceFunItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(AllianceFunItem, nameStr, list[i])
        cell:OnRefreshRedPot(list[i].type)
        self.buttonListInType[list[i].type] = cell
        if i == count then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
          self.view:RefreshSpecialGuide()
        end
      end)
    end
  end
end

local function ClearButtons(self)
  self.content:RemoveComponents(AllianceFunItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function OnDestroy(self)
  DOTween.Kill(self._allianceLog_rect.transform)
  DOTween.Kill(self._logLoop1_txt.transform)
  DOTween.Kill(self._logLoop2_txt.transform)
  self:DeleteTimer()
  self:ClearButtons()
  self.buttonListInType = nil
  self.name = nil
  self.power = nil
  self.power_txt = nil
  self.leader = nil
  self.leader_txt = nil
  self.land = nil
  self.land_txt = nil
  self.gift = nil
  self.gift_txt = nil
  self.people = nil
  self.people_txt = nil
  self.des_txt = nil
  self.des_default_txt = nil
  self.set_announce_btn = nil
  self.announce = nil
  self.content = nil
  self.item_prefab = nil
  self.lastLogCount = nil
  self._scrollViewContent:RemoveComponents(AllianceLogGrid)
  self._scrollViewContent:RemoveComponents(AllianceLogCell)
  self._scrollView:ClearAllItems()
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.isShowLog = false
  self._isFetchingMore = false
end

local function OnRefresh(self)
  self:ShowButtons()
  local data = self.view.ctrl:GetAllianceBaseData()
  if data == nil then
    return
  end
  self:SetFlag()
  self.name:SetText("<" .. data.abbr .. "> " .. data.allianceName)
  self.power_txt:SetText(string.GetFormattedSeperatorNum(data.fightPower))
  local leaderName = data.leaderUid == "" and Localization:GetString("100206") or data.leaderName
  self.leader_txt:SetText(leaderName)
  local languageId = data.language == "" and 115600 or data.language
  self.land_txt:SetLocalText(languageId)
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(data.country)
  if nationTemplate and not LuaEntry.GlobalData:IsChina() then
    self.countryFlagN:SetActive(true)
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlagN:SetActive(false)
  end
  self.gift_txt:SetLocalText(300665, DataCenter.AllianceGiftDataManager:GetCurLevel())
  self.people_txt:SetText(data.curMember .. "/" .. data.maxMember)
  self:SetAllianceAnnounce(data.announce)
  local hideChat = DataCenter.AllianceBaseDataManager:IsSelfLeader() or string.IsNullOrEmpty(data.leaderUid)
  self.leaderChatBtn:SetActive(not hideChat)
  table.walk(self.buttonListInType, function(k, v)
    v:OnRefreshRedPot(k)
  end)
  self._allianceLog_rect:SetSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 30))
  self._logLoop_rect:SetActive(true)
  self._showLog_btn:SetActive(true)
  self._hideLog_btn:SetActive(false)
  self:AllianceLogUpdateSignal()
end

local function SetFlag(self)
  local data = self.view.ctrl:GetAllianceBaseData()
  if data == nil then
    return
  end
  self.allianceFlag:SetData(data.icon)
end

local function AllianceLogUpdateSignal(self)
  if self.isCreat then
    self.allLog = DataCenter.AllianceLogManager:GetAllLog()
    self._isFetchingMore = false
    self.listLog, self.count = DataCenter.AllianceLogManager:GetAnalyseData()
    self._scrollView:SetListItemCount(self.count, false, false)
    self._scrollView:RefreshAllShownItem()
    local oldChatCount = self.lastLogCount
    self._scrollView.unity_looplistview2:ForceUpdate()
    self.lastLogCount = self.count
    return
  end
  self.isCreat = true
  self.allLog = DataCenter.AllianceLogManager:GetAllLog()
  if not self.allLog then
    return
  end
  self.listLog, self.count = DataCenter.AllianceLogManager:GetAnalyseData()
  self.lastLogCount = #self.listLog
  if next(self.allLog) then
    self._logLoop1_txt:SetText(self.allLog[1]:GetStrLog(true))
    self._logSign1_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
    self._logSign1_img:SetActive(true)
    if table.count(self.allLog) ~= 1 then
      self._logLoop2_txt:SetText(self.allLog[2]:GetStrLog(true))
      self._logSign2_img:LoadSprite(self.allLog[2]:GetLogSignIconPath())
      self._logSign2_img:SetActive(true)
      self.allLogCurNum = 2
      self:AddTimer()
    else
      self.allLogCurNum = 1
      self._logLoop2_txt:SetText("")
    end
    self._scrollView:SetListItemCount(self.count, false, false)
  end
end

local function DeleteTimer(self)
  if self._timer_loop ~= nil then
    self._timer_loop:Stop()
    self._timer_loop = nil
  end
end

local function AddTimer(self)
  if self._timer_loop == nil then
    self.loopYPos1 = 29
    self.loopYPos2 = 0
    self.loopYPosSign1 = 30
    self.loopYPosSign2 = 0
    self._logLoop1_txt:SetAnchoredPositionXY(30, 0)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop1_txt.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop2_txt.rectTransform)
    local height1 = self._logLoop1_txt:GetSizeDelta().y
    self.loopInitNum1 = math.ceil(height1) / 29
    self.loopNum1 = Mathf.Ceil(self.loopInitNum1)
    self._logLoop2_txt:SetAnchoredPositionXY(30, -29)
    local height2 = self._logLoop2_txt:GetSizeDelta().y
    self.loopInitNum2 = math.ceil(height2) / 29
    self.loopNum2 = Mathf.Ceil(self.loopInitNum2)
    self._timer_loop = TimerManager:GetInstance():GetTimer(3, self._timer_loop_action, self, false, false, false)
    self._timer_loop:Start()
  end
end

local function RefreshLog(self)
  if self.loopNum2 == 1 or self.loopYPos2 == 0 then
    self._logLoop1_txt.rectTransform:DOAnchorPosY(self.loopYPos1, 0.5):OnComplete(function()
      if self.loopYPos1 ~= 0 or self.loopYPos1 == 29 then
        self.loopNum1 = self.loopNum1 - 1
      end
      if self.loopNum1 == 0 then
        self._logLoop1_txt:SetAnchoredPositionXY(30, -29)
        local data = DataCenter.AllianceLogManager:GetAllianceLogById(self.allLogCurNum + 1)
        if data then
          self.allLogCurNum = self.allLogCurNum + 1
          self._logLoop1_txt:SetText(data:GetStrLog(true))
          self._logSign1_img:LoadSprite(data:GetLogSignIconPath())
        else
          self.allLogCurNum = 1
          self._logLoop1_txt:SetText(self.allLog[1]:GetStrLog(true))
          self._logSign1_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop1_txt.rectTransform)
        local height = self._logLoop1_txt:GetSizeDelta().y
        self.loopInitNum1 = math.ceil(height) / 29
        self.loopNum1 = Mathf.Ceil(self.loopInitNum1)
        self.loopYPos1 = 0
      else
        self.loopYPos1 = 29 + 29 * (self.loopInitNum1 - self.loopNum1)
      end
    end)
  end
  if self.loopNum1 == 1 or self.loopYPos1 == 0 then
    self._logLoop2_txt.rectTransform:DOAnchorPosY(self.loopYPos2, 0.5):OnComplete(function()
      if self.loopYPos2 ~= 0 or self.loopYPos2 == 29 then
        self.loopNum2 = self.loopNum2 - 1
      end
      if self.loopNum2 == 0 then
        self._logLoop2_txt:SetAnchoredPositionXY(30, -29)
        local data = DataCenter.AllianceLogManager:GetAllianceLogById(self.allLogCurNum + 1)
        if data then
          self.allLogCurNum = self.allLogCurNum + 1
          self._logLoop2_txt:SetText(data:GetStrLog(true))
          self._logSign2_img:LoadSprite(data:GetLogSignIconPath())
        else
          self.allLogCurNum = 1
          self._logLoop2_txt:SetText(self.allLog[1]:GetStrLog(true))
          self._logSign2_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop2_txt.rectTransform)
        local height = self._logLoop2_txt:GetSizeDelta().y
        self.loopInitNum2 = math.ceil(height) / 29
        self.loopNum2 = Mathf.Ceil(self.loopInitNum2)
        self.loopYPos2 = 0
      else
        self.loopYPos2 = 29 + 29 * (self.loopInitNum2 - self.loopNum2)
      end
    end)
  end
end

local function SetAllianceAnnounce(self, announce)
  self.announce = announce
  if announce ~= nil and announce ~= "" then
    self.des_default_txt:SetActive(false)
    self.des_txt:SetActive(true)
    self.des_txt:SetText(announce)
  else
    self.des_txt:SetActive(false)
    self.des_default_txt:SetActive(true)
    self.des_default_txt:SetLocalText(128024)
  end
end

local function OnRefreshAllianceWar(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceBattle] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceBattle]:OnRefreshRedPot(AllianceButtonType.AllianceBattle)
  end
end

local function OnRefreshAllianceGift(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceGift] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceGift]:OnRefreshRedPot(AllianceButtonType.AllianceGift)
  end
end

local function OnRefreshAllianceHelp(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceHelp] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceHelp]:OnRefreshRedPot(AllianceButtonType.AllianceHelp)
  end
end

local function OnRefreshAllianceMember(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceMember] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceMember]:OnRefreshRedPot(AllianceButtonType.AllianceMember)
  end
end

local function OnRefreshAlLeaderElect(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AlLeaderElect] ~= nil then
    self.buttonListInType[AllianceButtonType.AlLeaderElect]:OnRefreshRedPot(AllianceButtonType.AlLeaderElect)
  end
end

local function OnRefreshAllianceTask(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceTask] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceTask]:OnRefreshRedPot(AllianceButtonType.AllianceTask)
  end
end

local function OnRefreshAllianceAnnounce(self, announce)
  DataCenter.AllianceBaseDataManager:SetAnnounce(announce)
  self:SetAllianceAnnounce(announce)
end

local function OnRefreshAllianceDailyTask(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.EverydayTask] ~= nil then
    self.buttonListInType[AllianceButtonType.EverydayTask]:OnRefreshRedPot(AllianceButtonType.EverydayTask)
  end
end

local function OnRefreshAllianceCity(self)
  if self.buttonListInType and self.buttonListInType[AllianceButtonType.AllianceCity] ~= nil then
    self.buttonListInType[AllianceButtonType.AllianceCity]:OnRefreshRedPot(AllianceButtonType.AllianceCity)
  end
end

local function OnClickMailBtn(self)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailSend)
  else
    UIUtil.ShowTipsId(141063)
  end
end

local function OnClickLogBtn(self, type)
  if not self.allLog then
    return
  end
  if next(self.allLog) then
    if type == 1 then
      self.isShowLog = true
      self._showLog_btn:SetActive(false)
      self._logLoop_rect:SetActive(false)
      self._allianceLog_rect.rectTransform:DOSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 367), 0.1):OnComplete(function()
        self._hideLog_btn:SetActive(true)
      end)
    else
      self._logLoop_rect:SetActive(true)
      self._allianceLog_rect.rectTransform:DOSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 30), 0.3)
      self._showLog_btn:SetActive(true)
      self._hideLog_btn:SetActive(false)
      self.isShowLog = false
    end
  end
end

local function OnClickLeaderChatBtn(self)
  local data = self.view.ctrl:GetAllianceBaseData()
  local userId = data.leaderUid
  local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
  local param = {}
  param.roomId = roomId
  param.userId = userId
  param.username = data.leaderName
  GoToUtil.OpenChatView(true, {
    anim = false,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, param)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.UpdateAlertData, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.RefreshAlertUI, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.CrossServerWar, self.OnRefreshAllianceWar)
  self:AddUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshAllianceHelp)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshAllianceGift)
  self:AddUIListener(EventId.AllianceMemberRedPoint, self.OnRefreshAllianceMember)
  self:AddUIListener(EventId.AllianceAnnounce, self.OnRefreshAllianceAnnounce)
  self:AddUIListener(EventId.DailyQuestSuccess, self.OnRefreshAllianceDailyTask)
  self:AddUIListener(EventId.DailyQuestReward, self.OnRefreshAllianceDailyTask)
  self:AddUIListener(EventId.AlWaitMergeStatusChange, self.OnRefresh)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnRefresh)
  self:AddUIListener(EventId.AllianceLogUpdate, self.AllianceLogUpdateSignal)
  self:AddUIListener(EventId.UpdateAlElectRed, self.OnRefreshAlLeaderElect)
  self:AddUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshAllianceTask)
  self:AddUIListener(EventId.AllianceFlagChanged, self.SetFlag)
  self:AddUIListener(EventId.DeclareWar, self.OnRefreshAllianceCity)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.UpdateAlertData, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.RefreshAlertUI, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.CrossServerWar, self.OnRefreshAllianceWar)
  self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshAllianceHelp)
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshAllianceGift)
  self:RemoveUIListener(EventId.AllianceMemberRedPoint, self.OnRefreshAllianceMember)
  self:RemoveUIListener(EventId.AllianceAnnounce, self.OnRefreshAllianceAnnounce)
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.OnRefreshAllianceDailyTask)
  self:RemoveUIListener(EventId.DailyQuestReward, self.OnRefreshAllianceDailyTask)
  self:RemoveUIListener(EventId.DeclareWar, self.OnRefreshAllianceCity)
  self:RemoveUIListener(EventId.AlWaitMergeStatusChange, self.OnRefresh)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnRefresh)
  self:RemoveUIListener(EventId.AllianceLogUpdate, self.AllianceLogUpdateSignal)
  self:RemoveUIListener(EventId.UpdateAlElectRed, self.OnRefreshAlLeaderElect)
  self:RemoveUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshAllianceTask)
  self:RemoveUIListener(EventId.AllianceFlagChanged, self.SetFlag)
end

local function GetBtnCellByBtnType(self, btnType)
  if self.buttonListInType ~= nil then
    return self.buttonListInType[btnType]
  end
end

AllianceMain.OnCreate = OnCreate
AllianceMain.ComponentDefine = ComponentDefine
AllianceMain.DataDefine = DataDefine
AllianceMain.OnDestroy = OnDestroy
AllianceMain.OnRefresh = OnRefresh
AllianceMain.OnEnable = OnEnable
AllianceMain.OnDisable = OnDisable
AllianceMain.OnRefreshAllianceWar = OnRefreshAllianceWar
AllianceMain.OnAddListener = OnAddListener
AllianceMain.OnRemoveListener = OnRemoveListener
AllianceMain.OnRefreshAllianceGift = OnRefreshAllianceGift
AllianceMain.OnRefreshAllianceHelp = OnRefreshAllianceHelp
AllianceMain.OnRefreshAllianceMember = OnRefreshAllianceMember
AllianceMain.OnRefreshAllianceAnnounce = OnRefreshAllianceAnnounce
AllianceMain.OnRefreshAlLeaderElect = OnRefreshAlLeaderElect
AllianceMain.OnRefreshAllianceTask = OnRefreshAllianceTask
AllianceMain.SetAllianceAnnounce = SetAllianceAnnounce
AllianceMain.OnRefreshAllianceDailyTask = OnRefreshAllianceDailyTask
AllianceMain.OnRefreshAllianceCity = OnRefreshAllianceCity
AllianceMain.OnClickMailBtn = OnClickMailBtn
AllianceMain.ShowButtons = ShowButtons
AllianceMain.ClearButtons = ClearButtons
AllianceMain.DeleteTimer = DeleteTimer
AllianceMain.AddTimer = AddTimer
AllianceMain.RefreshLog = RefreshLog
AllianceMain.OnClickLogBtn = OnClickLogBtn
AllianceMain.AllianceLogUpdateSignal = AllianceLogUpdateSignal
AllianceMain.OnGetItemByIndex = OnGetItemByIndex
AllianceMain.OnEndDrag = OnEndDrag
AllianceMain.OnClickLeaderChatBtn = OnClickLeaderChatBtn
AllianceMain.SetFlag = SetFlag
AllianceMain.GetBtnCellByBtnType = GetBtnCellByBtnType
return AllianceMain
