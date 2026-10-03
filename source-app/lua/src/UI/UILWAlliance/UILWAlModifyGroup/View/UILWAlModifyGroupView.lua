local UILWAlModifyGroupView = BaseClass("UILWAlModifyGroupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWAlModifyGroupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPopup()
end

function UILWAlModifyGroupView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlModifyGroupView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compInputFieldR5 = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compInputFieldR4 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compInputFieldR3 = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compInputFieldR2 = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compInputFieldR1 = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.toggleVisible = self.viewSkin:AddComponent(self, UIToggle, 9)
  self.textVisibleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirmBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textWaitCheckTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compVisiblePanel = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.toggleVisible:SetOnValueChanged(function(state)
    self:OnToggleVisibleChange(state)
  end)
  self.inputFieldList = {}
  self.inputHolderList = {}
  self.inputTextList = {}
  self.inputCharNumList = {}
  self.inputTipList = {}
  self.inputFieldCompList = {
    self.compInputFieldR1,
    self.compInputFieldR2,
    self.compInputFieldR3,
    self.compInputFieldR4,
    self.compInputFieldR5
  }
  for index = 1, 5 do
    local input_field_comp = self.inputFieldCompList[index]
    self.inputFieldList[index] = input_field_comp:AddComponent(UIInput, "")
    self.inputHolderList[index] = input_field_comp:AddComponent(UIText, "Viewport/HolderText")
    self.inputCharNumList[index] = input_field_comp:AddComponent(UIText, "CharNumText")
    self.inputTipList[index] = input_field_comp:AddComponent(UIText, "InputTipText")
    self.inputFieldList[index]:SetOnValueChange(function(value)
      self:IptOnValueChange(value, index)
    end)
    self.inputFieldList[index]:SetOnEndEdit(function(value)
      self:IptOnValueChange(value, index)
    end)
  end
end

function UILWAlModifyGroupView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compInputFieldR5 = nil
  self.compInputFieldR4 = nil
  self.compInputFieldR3 = nil
  self.compInputFieldR2 = nil
  self.compInputFieldR1 = nil
  self.toggleVisible = nil
  self.textVisibleTip = nil
  self.btnConfirm = nil
  self.textConfirmBtn = nil
  self.textWaitCheckTip = nil
  self.compVisiblePanel = nil
  self.inputFieldCompList = nil
  self.inputFieldList = nil
  self.inputHolderList = nil
  self.inputTextList = nil
  self.inputCharNumList = nil
  self.inputTipList = nil
end

function UILWAlModifyGroupView:DataDefine()
  self.curRankNameList = {}
  self.oriRankNameList = {}
  self.curInputCharNumList = {}
  self.curVisibleState = 0
  self.maxInputCharNum = 0
  self.minGiftLevel = 0
  self.isIllegalInput = {}
end

function UILWAlModifyGroupView:DataDestroy()
  self.curRankNameList = nil
  self.oriRankNameList = nil
  self.curInputCharNumList = nil
  self.curVisibleState = nil
  self.maxInputCharNum = nil
  self.isIllegalInput = nil
end

function UILWAlModifyGroupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Al_RankNameModify, self.OnRankNameModify)
  self:AddUIListener(EventId.Al_RankVisibleModify, self.OnRankVisibleModify)
end

function UILWAlModifyGroupView:OnRemoveListener()
  self:RemoveUIListener(EventId.Al_RankNameModify, self.OnRankNameModify)
  self:RemoveUIListener(EventId.Al_RankVisibleModify, self.OnRankVisibleModify)
  base.OnRemoveListener(self)
end

function UILWAlModifyGroupView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWAlModifyGroupView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWAlModifyGroupView:OnBtnConfirmClick()
  for index = 1, 5 do
    if self.curInputCharNumList[index] > self.maxInputCharNum then
      UIUtil.ShowTipsId("alliance_rankEdit_limit_tooLong")
      return
    end
    if self.isIllegalInput[index] then
      UIUtil.ShowTipsId("alliance_rankEdit_limit_sensitive")
      return
    end
  end
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(393093)
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR5() then
    UIUtil.ShowTipsId(393094)
    return
  end
  if DataCenter.AllianceGiftDataManager:GetCurLevel() < self.minGiftLevel then
    return
  end
  local isVisibleChangeOnly = true
  for index = 1, 5 do
    if self.curRankNameList[index] ~= self.oriRankNameList[index] then
      isVisibleChangeOnly = false
      break
    end
  end
  if isVisibleChangeOnly then
    local visibleParam = {
      viewOpen = self.curVisibleState
    }
    SFSNetwork.SendMessage(MsgDefines.AllianceGroupDescriptionViewOpen, visibleParam)
  else
    for index = 1, 5 do
      if string.IsNullOrEmpty(self.curRankNameList[index]) then
        self.curRankNameList[index] = ""
      end
    end
    local rankNameParam = {
      groupDescription = self.curRankNameList,
      viewOpen = self.curVisibleState
    }
    SFSNetwork.SendMessage(MsgDefines.AllianceGroupDescriptionModify, rankNameParam)
  end
  self:SetWaitCheckState(true)
end

function UILWAlModifyGroupView:OnRankNameModify(message)
  self:SetWaitCheckState(false)
  if not message or next(message) == nil then
    return
  end
  local message_code = message.result
  if not message_code then
    return
  end
  if message_code == 0 then
    self.ctrl:CloseSelf()
  elseif message_code == 1 then
    UIUtil.ShowTipsId("alliance_rankEdit_limit_tooLong")
    for index = 1, 5 do
      self:RefreshInputCharNum(index)
    end
  elseif message_code == 2 then
    UIUtil.ShowTipsId("alliance_rankEdit_limit_sensitive")
    local modify_rank_name_list = message.groupDescription
    for index = 1, 5 do
      if string.trim(self.curRankNameList[index]) ~= modify_rank_name_list[index] then
        self.curRankNameList[index] = modify_rank_name_list[index]
        self.curInputCharNumList[index] = #modify_rank_name_list[index]
        self.inputFieldList[index]:SetText(modify_rank_name_list[index])
        self:RefreshInputCharNum(index)
        self.inputTipList[index]:SetLocalText("alliance_rankEdit_limit_sensitive")
        self.inputTipList[index]:SetActive(true)
        self.isIllegalInput[index] = true
      else
        self.inputTipList[index]:SetActive(false)
        self.isIllegalInput[index] = false
      end
    end
  elseif message_code == 3 then
    UIUtil.ShowTipsId(393093)
  end
end

function UILWAlModifyGroupView:OnRankVisibleModify(message)
  self:SetWaitCheckState(false)
  if not message or next(message) == nil then
    return
  end
  local message_code = message.result
  if not message_code then
    return
  end
  if message_code == 0 then
    self.ctrl:CloseSelf()
  elseif message_code == 3 then
    UIUtil.ShowTipsId(393093)
  end
end

function UILWAlModifyGroupView:InitPopup()
  self:SetWaitCheckState(false)
  self.textTitle:SetLocalText("alliance_rankEdit_title")
  self.textVisibleTip:SetLocalText("alliance_rankEdit_limit_allVisible")
  self.textConfirmBtn:SetLocalText(GameDialogDefine.CONFIRM)
  self.textWaitCheckTip:SetLocalText("alliance_rankEdit_limit_checking")
  local rank_edit_limit_config = LuaEntry.DataConfig:TryGetStr("alliance_rankEdit", "k1", "")
  local edit_limit_config = string.split(rank_edit_limit_config, ";")
  self.minGiftLevel = tonumber(edit_limit_config[1]) or 5
  self.maxInputCharNum = tonumber(edit_limit_config[2]) or 30
  self.curRankNameList = DeepCopy(DataCenter.AllianceMemberDataManager:GetAllianceRankName())
  self.curVisibleState = DataCenter.AllianceMemberDataManager:GetAllianceRankVisible()
  if next(self.curRankNameList) ~= nil then
    self.oriRankNameList = DeepCopy(self.curRankNameList)
  end
  for index = 1, 5 do
    self.inputFieldList[index]:SetText(self.curRankNameList[index])
    self:IptOnValueChange(self.curRankNameList[index], index)
    self.inputHolderList[index]:SetLocalText("alliance_rankEdit_limit_input")
  end
  self.toggleVisible:SetIsOn(self.curVisibleState == 1)
end

function UILWAlModifyGroupView:IptOnValueChange(value, index)
  value = value or ""
  self.curRankNameList[index] = value
  self.curInputCharNumList[index] = #value
  if self.curInputCharNumList[index] > self.maxInputCharNum then
    self.inputTipList[index]:SetLocalText("alliance_rankEdit_limit_tooLong")
    self.inputTipList[index]:SetActive(true)
  else
    self.inputTipList[index]:SetActive(false)
    self.isIllegalInput[index] = false
  end
  self:RefreshInputCharNum(index)
end

function UILWAlModifyGroupView:RefreshInputCharNum(index)
  local inputCharNum = self.curInputCharNumList[index]
  self.inputCharNumList[index]:SetText(string.format("%d/%d", inputCharNum, self.maxInputCharNum))
  self.inputHolderList[index]:SetActive(inputCharNum == 0)
end

function UILWAlModifyGroupView:OnToggleVisibleChange(state)
  self.toggleVisible:SetIsOn(state)
  self.curVisibleState = state and 1 or 0
end

function UILWAlModifyGroupView:SetWaitCheckState(state)
  self.compVisiblePanel:SetActive(not state)
  self.btnConfirm:SetActive(not state)
  self.textWaitCheckTip:SetActive(state)
  for index = 1, 5 do
    self.inputFieldList[index]:SetEnable(not state)
  end
end

return UILWAlModifyGroupView
