local base = UIBaseView
local UIOfficialApplyView = BaseClass("UIOfficialApplyView", base)
local UIOfficialApplyPlayerPanel = require("UI.UIGovernment.OfficialApply.Component.UIOfficialApplyPlayerPanel")
local UIOfficialApplyEffectPanel = require("UI.UIGovernment.OfficialApply.Component.UIOfficialApplyEffectPanel")
local UIOfficialAppointmentCell = require("UI.UIGovernment.OfficialApply.Component.UIOfficialAppointmentCell")
local string_format = string.format
local pairs = _ENV.pairs
local BindCallback = _ENV.BindCallback
local DataCenter = _ENV.DataCenter
local OfficialApplyManager = DataCenter.OfficialApplyManager
local UIManager = _ENV.UIManager
local UIWindowNames = _ENV.UIWindowNames
local UIUtil = _ENV.UIUtil
local LuaEntry = _ENV.LuaEntry
local EventId = _ENV.EventId
local titleTxt_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local rightBtn_path = "Root/Content/ContentHolder/InfoPanel/RightBtn"
local leftBtn_path = "Root/Content/ContentHolder/InfoPanel/LeftBtn"
local officialPanel_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel"
local officialIcon_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel/Officialcon"
local noPlayerText_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel/NoPlayerText"
local playerPanel_path = "Root/Content/ContentHolder/InfoPanel/PlayerPanel"
local nonePanel_path = "Root/Content/ContentHolder/AutoPanel/ScrollView/NonePanel"
local noneTipText_path = "Root/Content/ContentHolder/AutoPanel/ScrollView/NonePanel/NoneTipText"
local logBtn_path = "Root/Content/ContentHolder/DownPanel/LogBtn"
local logBtnText_path = "Root/Content/ContentHolder/DownPanel/LogBtn/LogBtnText"
local list_btn_path = "Root/Content/ContentHolder/DownPanel/ListBtn"
local list_btn_text_path = "Root/Content/ContentHolder/DownPanel/ListBtn/ListBtnText"
local tipText_path = "Root/Content/ContentHolder/DownPanel/TipText"
local applyBtn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/ApplyBtn"
local applyBtnText_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/ApplyBtn/ApplyBtnText"
local closePanel_path = "Panel"
local setBtn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/SetBtn"
local removeBtn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/RemoveBtn"
local setBtnText_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/SetBtn/SetBtnText"
local resign_btn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/ResignBtn"
local effectPanel_path = "Root/Content/ContentHolder/AutoPanel/EffectPanel"
local downPanel_path = "Root/Content/ContentHolder/DownPanel"
local red_dot_without_num_path = "Root/Content/ContentHolder/DownPanel/ListBtn/RedDotWithoutNum"
local list_num_text_path = "Root/Content/ContentHolder/AutoPanel/ListTextPanel/ListNumText"
local scrollView_height = 609
local maxApplyNum

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.officialPanel = self:AddComponent(UIBaseContainer, officialPanel_path)
  self.officialIcon = self:AddComponent(UIImage, officialIcon_path)
  self.noPlayerText = self:AddComponent(UIText, noPlayerText_path)
  self.playerPanel = self:AddComponent(UIOfficialApplyPlayerPanel, playerPanel_path)
  self.nonePanel = self:AddComponent(UIBaseContainer, nonePanel_path)
  self.noneTipText = self:AddComponent(UIText, noneTipText_path)
  self.logBtn = self:AddComponent(UIButton, logBtn_path)
  self.logBtnText = self:AddComponent(UIText, logBtnText_path)
  self.list_btn = self:AddComponent(UIButton, list_btn_path)
  self.list_btn_text = self:AddComponent(UITextMeshProUGUIEx, list_btn_text_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.applyBtn = self:AddComponent(UIButton, applyBtn_path)
  self.applyBtnText = self:AddComponent(UIText, applyBtnText_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.setBtn = self:AddComponent(UIButton, setBtn_path)
  self.removeBtn = self:AddComponent(UIButton, removeBtn_path)
  self.setBtnText = self:AddComponent(UIText, setBtnText_path)
  self.resignBtn = self:AddComponent(UIButton, resign_btn_path)
  self.resignBtn:SetActive(false)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rightBtn:SetOnClick(BindCallback(self, self.OnChangePosition, true))
  self.leftBtn:SetOnClick(BindCallback(self, self.OnChangePosition, false))
  self.applyBtn:SetOnClick(function()
    self.ctrl:SendKingdomPositionApply(self.positionId)
  end)
  self.logBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialAppointLog, {anim = true}, self.positionId)
  end)
  self.list_btn:SetOnClick(BindCallback(self, self.OnApplyListBtnClick))
  self.effectPanel = self:AddComponent(UIOfficialApplyEffectPanel, effectPanel_path)
  self.setBtn:SetOnClick(function()
    if self:IsInAppointTimeCD() then
      UIUtil.ShowTipsId(457059)
      return
    end
    if not OfficialApplyManager:IsManager(self.serverId) then
      UIUtil.ShowTipsId(393018)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficialSelectMember, self.positionId)
  end)
  self.removeBtn:SetOnClick(function()
    if not OfficialApplyManager:IsManager(self.serverId) then
      UIUtil.ShowTipsId(393018)
      return
    end
    local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.positionId)
    local configData = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
    DataCenter.GovernmentManager:TryKingdomPositionAppoint(self.positionId, positionInfo, configData)
  end)
  self.resignBtn:SetOnClick(function()
    local msg = CS.GameEntry.Localization:GetString("officer_apply_062", DataCenter.GovernmentTemplateManager:GetTemplateName(self.positionId))
    UIUtil.ShowMessage(msg, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local officialId = DataCenter.OfficialApplyManager:GetOwnAppointIdName()
      if officialId and officialId == self.positionId then
        SFSNetwork.SendMessage(MsgDefines.KingdomPositionResign)
      end
    end, nil)
  end)
  local scroll_view_path = "Root/Content/ContentHolder/AutoPanel/ScrollView"
  self.scrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  local content_path = "Root/Content/ContentHolder/AutoPanel/ScrollView/Content"
  self.scrollContent = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.appointmentCellList = {}
  self.scrollContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.playerPanel:SetActive(false)
  self.downPanel = self:AddComponent(UIBaseContainer, downPanel_path)
  self.downPanel:SetActive(false)
  self.red_dot_without_num = self:AddComponent(UIBaseContainer, red_dot_without_num_path)
  self.list_num_text = self:AddComponent(UITextMeshProUGUIEx, list_num_text_path)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.appointmentCellList = nil
  self.titleTxt = nil
  self.closeBtn = nil
  self.rightBtn = nil
  self.leftBtn = nil
  self.officialPanel = nil
  self.officialIcon = nil
  self.noPlayerText = nil
  self.playerPanel = nil
  self.nonePanel = nil
  self.noneTipText = nil
  self.logBtn = nil
  self.logBtnText = nil
  self.tipText = nil
  self.applyBtn = nil
  self.applyBtnText = nil
  self.closePanel = nil
  self.setBtn = nil
  self.removeBtn = nil
  self.setBtnText = nil
  self.resignBtn = nil
  self.scrollView = nil
  self.scrollContent = nil
  self.effectPanel = nil
  self.red_dot_without_num = nil
end

local function DataDefine(self)
  self:OnOpenFunc()
end

local function DataDestroy(self)
  self.positionId = nil
  self.theCD = nil
  self.applyCDStrId = nil
  self.applyCD = nil
  self.serverId = nil
  self.resignAppointTime = nil
  OfficialApplyManager:SetViewPositionId(nil)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshPlayerPanel)
  self:AddUIListener(EventId.OfficialApplyDownRefresh, self.RefreshDownPanel)
  self:AddUIListener(EventId.OfficialAppointmentListRefresh, self.RefreshAppointmentList)
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshRedDotState)
  self:AddUIListener(EventId.OfficialApplyListInit, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshPlayerPanel)
  self:RemoveUIListener(EventId.OfficialApplyDownRefresh, self.RefreshDownPanel)
  self:RemoveUIListener(EventId.OfficialAppointmentListRefresh, self.RefreshAppointmentList)
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshRedDotState)
  self:RemoveUIListener(EventId.OfficialApplyListInit, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ReopenWithoutCreate(self)
  base.ReopenWithoutCreate(self)
  self:OnOpenFunc()
end

local function OnOpenFunc(self)
  self.scrollContent:SetActive(false)
  self.positionId = tostring(self:GetUserData())
  OfficialApplyManager:SetViewPositionId(self.positionId)
  maxApplyNum = OfficialApplyManager.GetMaxAppointmentNum(self)
  self:RefreshPlayerPanel()
  self.serverId = LuaEntry.Player:GetSourceServerId()
  OfficialApplyManager:SendKingdomPositionApplyList(self.positionId)
  OfficialApplyManager:SendKingdomPositionAppointmentList(self.positionId, true)
end

local function RefreshAll(self)
  self.downPanel:SetActive(true)
  self:RefreshPlayerPanel()
end

local function RefreshAppointmentList(self, positionId)
  if positionId ~= self.positionId then
    return
  end
  self.scrollView:SetSizeDeltaY(scrollView_height - self.effectPanel:GetSizeDelta().y)
  local num = 0
  self.appointmentDataList = OfficialApplyManager:GetAppointmentList(positionId)
  if self.appointmentDataList and 0 < #self.appointmentDataList then
    self.scrollContent:SetActive(true)
    self.nonePanel:SetActive(false)
    self.scrollContent:RefreshMaskSize()
    self.scrollContent:SetItemCount(#self.appointmentDataList)
    local moveIndex = OfficialApplyManager:GetMoveIndexInAppointmentList(positionId)
    if moveIndex and -1 < moveIndex then
      self.scrollContent:MoveItemByIndex(moveIndex)
    end
    num = #self.appointmentDataList
  else
    self.scrollContent:SetActive(false)
    self.nonePanel:SetActive(true)
  end
  self.list_num_text:SetText(string_format("[%s/%s]", num, maxApplyNum))
  self:RefreshDownPanel()
end

local function RefreshPlayerPanel(self)
  local template = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
  self.titleTxt:SetLocalText(template.name)
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.positionId)
  if positionInfo and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    self.playerPanel:SetActive(true)
    self.officialPanel:SetActive(false)
    self.playerPanel:SetData(positionInfo)
  else
    self.playerPanel:SetActive(false)
    self.officialPanel:SetActive(true)
    local configData = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
    self.officialIcon:LoadSprite(configData.icon)
    self.officialIcon:SetNativeSize()
  end
  self.effectPanel:SetData(self.positionId)
  self:RefreshDownPanel()
  self:RefreshRedDotState()
end

local function RefreshDownPanel(self)
  self.tipText:SetActive(false)
  self.applyBtn:SetActive(false)
  self.setBtn:SetActive(false)
  self.removeBtn:SetActive(false)
  self.resignBtn:SetActive(false)
  self.resignAppointTime = nil
  local isCtrl = OfficialApplyManager:IsManager(self.serverId)
  if isCtrl then
    self.tipText:SetActive(false)
    self.applyBtn:SetActive(false)
    self.setBtn:SetActive(true)
    local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.positionId)
    if positionInfo then
      if positionInfo.uid ~= nil and positionInfo.uid ~= "" then
        if LuaEntry.Player:IsFirstLady(self.serverId) and self.positionId == "10002" then
          self.removeBtn:SetActive(false)
        else
          self.removeBtn:SetActive(true)
        end
      else
        self.removeBtn:SetActive(false)
      end
      self.theCD = positionInfo:GetAppointTimeCD()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.theCD = self.theCD - curTime
    else
      self.theCD = 0
    end
    if not self:IsInAppointTimeCD() then
      CS.UIGray.SetGray(self.setBtn.transform, false, true)
      self.setBtnText:SetLocalText(457093)
    else
      CS.UIGray.SetGray(self.setBtn.transform, true, true)
      self.setBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.theCD))
    end
    if self.appointmentCellList then
      for key, value in pairs(self.appointmentCellList) do
        value:SetLock(self:IsInAppointTimeCD())
      end
    end
    if LuaEntry.Player:IsFirstLady(self.serverId) and self.positionId == "10002" and LuaEntry.DataConfig:CheckSwitch("officials_resign") and positionInfo and positionInfo.uid ~= nil and positionInfo.uid == LuaEntry.Player.uid then
      self.resignAppointTime = positionInfo.appointTime + DataCenter.OfficialApplyManager:GetResignOfficeTime() * 1000
      self:RefreshResignBtn()
    end
  else
    local str, cd, myCurOffice = OfficialApplyManager:GetOwnApplicantData(self.positionId, CS.GameEntry.Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true))
    if str == nil then
      self.tipText:SetActive(false)
      self.applyBtn:SetActive(true)
    else
      self.tipText:SetActive(true)
      self.applyBtn:SetActive(false)
      if cd == nil then
        self.tipText:SetText(str)
        self.applyCD = nil
      else
        self.applyCDStrId = str
        self.applyCD = cd
        if 0 < self.applyCD then
          self.tipText:SetLocalText(self.applyCDStrId, UITimeManager:GetInstance():MilliSecondToFmtString(self.applyCD))
        end
      end
      if myCurOffice and LuaEntry.DataConfig:CheckSwitch("officials_resign") then
        local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.positionId)
        if positionInfo and positionInfo.uid ~= nil and positionInfo.uid == LuaEntry.Player.uid then
          self.resignAppointTime = positionInfo.appointTime + DataCenter.OfficialApplyManager:GetResignOfficeTime() * 1000
          self:RefreshResignBtn()
        end
      end
    end
  end
end

local function RefreshResignBtn(self)
  if self.resignAppointTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.resignAppointTime then
    self.resignBtn:SetActive(true)
    self.tipText:SetActive(false)
    self.resignAppointTime = nil
  end
end

local function Update1000MS(self)
  local deltaTime = 1000
  if self.theCD ~= nil and self.theCD > 0 then
    self.theCD = self.theCD - deltaTime
    if self.theCD > 0 then
      self.setBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.theCD))
    else
      self.theCD = 0
      self:RefreshDownPanel()
    end
  end
  if self.applyCD ~= nil and 0 < self.applyCD then
    self.applyCD = self.applyCD - deltaTime
    if 0 < self.applyCD then
      self.tipText:SetLocalText(self.applyCDStrId, UITimeManager:GetInstance():MilliSecondToFmtString(self.applyCD))
    else
      self.applyCD = 0
      self:RefreshDownPanel()
    end
  end
  self:RefreshResignBtn()
end

local function OnChangePosition(self, isAdd)
  local governmentList = OfficialApplyManager:GetCanApplyGovernmentList()
  local order = 1
  for index, value in ipairs(governmentList) do
    if value == self.positionId then
      order = index
      break
    end
  end
  order = self:ChangePositionIndex(isAdd, order, governmentList, not DataCenter.GovernmentManager:IsConqueror(self.serverId))
  self.positionId = governmentList[order]
  OfficialApplyManager:SetViewPositionId(self.positionId)
  OfficialApplyManager:SendKingdomPositionApplyList(self.positionId)
  OfficialApplyManager:SendKingdomPositionAppointmentList(self.positionId, true)
end

local function ChangePositionIndex(self, isAdd, index, list, check)
  if isAdd then
    index = index + 1
    if index > #list then
      index = 1
    end
  else
    index = index - 1
    if index <= 0 then
      index = #list
    end
  end
  if check and DataCenter.GovernmentTemplateManager:IsConqueror(list[index]) then
    return self:ChangePositionIndex(isAdd, index, list, check)
  end
  return index
end

local function OnInitScroll(self, go, index)
  local item = self.scrollView:AddComponent(UIOfficialAppointmentCell, go)
  item.name = tostring("UIOfficialAppointmentCell" .. index)
  self.appointmentCellList[go] = item
end

local function OnUpdateScroll(self, go, index)
  if self.appointmentDataList == nil or self.appointmentDataList[index + 1] == nil then
    go:SetActive(false)
    return
  end
  local sub = self.appointmentDataList[index + 1]
  local cellItem = self.appointmentCellList[go]
  go:SetActive(true)
  cellItem:SetData(self.positionId, sub, self:IsInAppointTimeCD(), self.serverId)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(UIOfficialAppointmentCell)
  self.scrollContent:DestroyChildNode()
end

local function IsInAppointTimeCD(self)
  return self.theCD ~= nil and self.theCD > 0
end

local function OnApplyListBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialAppointApplyList, {anim = true}, self.positionId, self.serverId)
end

local function RefreshRedDotState(self)
  self.red_dot_without_num:SetActive(OfficialApplyManager:HaveApplyRed(self.positionId))
end

UIOfficialApplyView.OnCreate = OnCreate
UIOfficialApplyView.OnDestroy = OnDestroy
UIOfficialApplyView.OnEnable = OnEnable
UIOfficialApplyView.OnDisable = OnDisable
UIOfficialApplyView.ComponentDefine = ComponentDefine
UIOfficialApplyView.ComponentDestroy = ComponentDestroy
UIOfficialApplyView.DataDefine = DataDefine
UIOfficialApplyView.DataDestroy = DataDestroy
UIOfficialApplyView.OnAddListener = OnAddListener
UIOfficialApplyView.OnRemoveListener = OnRemoveListener
UIOfficialApplyView.ReopenWithoutCreate = ReopenWithoutCreate
UIOfficialApplyView.OnOpenFunc = OnOpenFunc
UIOfficialApplyView.RefreshAll = RefreshAll
UIOfficialApplyView.RefreshAppointmentList = RefreshAppointmentList
UIOfficialApplyView.RefreshPlayerPanel = RefreshPlayerPanel
UIOfficialApplyView.RefreshDownPanel = RefreshDownPanel
UIOfficialApplyView.Update1000MS = Update1000MS
UIOfficialApplyView.OnChangePosition = OnChangePosition
UIOfficialApplyView.OnInitScroll = OnInitScroll
UIOfficialApplyView.OnUpdateScroll = OnUpdateScroll
UIOfficialApplyView.OnDestroyScrollItem = OnDestroyScrollItem
UIOfficialApplyView.ClearScroll = ClearScroll
UIOfficialApplyView.IsInAppointTimeCD = IsInAppointTimeCD
UIOfficialApplyView.OnApplyListBtnClick = OnApplyListBtnClick
UIOfficialApplyView.RefreshRedDotState = RefreshRedDotState
UIOfficialApplyView.ChangePositionIndex = ChangePositionIndex
UIOfficialApplyView.RefreshResignBtn = RefreshResignBtn
return UIOfficialApplyView
