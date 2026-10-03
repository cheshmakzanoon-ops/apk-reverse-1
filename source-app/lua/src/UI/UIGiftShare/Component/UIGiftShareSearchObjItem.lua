local base = UIBaseContainer
local UIGiftShareSearchObjItem = BaseClass("UIGiftShareSearchObjItem", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local search_input_field_ex_path = "SearchInputFieldEx"
local bg_show_obj_path = "SearchInputFieldEx/Text Area/BgShowObj"
local search_input_tip_path = "SearchInputFieldEx/Text Area/BgShowObj/searchInputTip"
local num_text_path = "SearchInputFieldEx/Text Area/numText"
local warn_text_path = "SearchInputFieldEx/Text Area/warnText"
local btn_send_path = "btnSend"
local btn_send_txt_path = "btnSend/btnSendTxt"
local btn_cancel_path = "btnCancel"
local btn_cancel_txt_path = "btnCancel/btnCancelTxt"
local searchBoxOffset1 = 16
local searchBoxOffset2 = 318

function UIGiftShareSearchObjItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIGiftShareSearchObjItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGiftShareSearchObjItem:ComponentDefine()
  self.search_input_field_ex = self:AddComponent(UIInput, search_input_field_ex_path)
  self.bg_show_obj = self:AddComponent(UIBaseContainer, bg_show_obj_path)
  self.search_input_tip = self:AddComponent(UIBaseContainer, search_input_tip_path)
  self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
  self.warn_text = self:AddComponent(UITextMeshProUGUIEx, warn_text_path)
  self.btn_send = self:AddComponent(UIButton, btn_send_path)
  self.btn_send_txt = self:AddComponent(UITextMeshProUGUIEx, btn_send_txt_path)
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_cancel_txt = self:AddComponent(UITextMeshProUGUIEx, btn_cancel_txt_path)
  self.bg_show_obj_layout = self.bg_show_obj.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  
  function self.inputOnSelectFunc()
    self:TryToSearchShowType()
  end
  
  self.search_input_field_ex.unity_tmpinput.onSelect:AddListener(self.inputOnSelectFunc)
  self.btn_cancel:SetOnClick(function()
    self:TryToNoramlShowType()
  end)
  self.btn_send:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  self.search_input_field_ex:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
end

function UIGiftShareSearchObjItem:ComponentDestroy()
  self.search_input_field_ex.unity_tmpinput.onSelect:RemoveListener(self.inputOnSelectFunc)
  pcall(function()
    self.search_input_field_ex.unity_tmpinput.onSelect:Clear()
  end)
  self.search_input_field_ex = nil
  self.bg_show_obj = nil
  self.search_input_tip = nil
  self.num_text = nil
  self.warn_text = nil
  self.btn_send = nil
  self.btn_send_txt = nil
  self.btn_cancel = nil
  self.btn_cancel_txt = nil
  self.bg_show_obj_layout = nil
end

function UIGiftShareSearchObjItem:TryToNoramlShowType()
  if self.normalTypeShowFunc then
    self.normalTypeShowFunc()
  end
end

function UIGiftShareSearchObjItem:TryToSearchShowType()
  if self.searchTypeShowFunc then
    self.searchTypeShowFunc()
  end
end

function UIGiftShareSearchObjItem:UpdateItem(data, normalTypeShowFunc, searchTypeShowFunc, needFindNum)
  self:SetSizeDeltaXY(self.view.img_bg and self.view.img_bg:GetSizeDelta().x or DefaultScreenWidth, self:GetSizeDelta().y)
  self.data = data
  if normalTypeShowFunc then
    self.normalTypeShowFunc = normalTypeShowFunc
  end
  if searchTypeShowFunc then
    self.searchTypeShowFunc = searchTypeShowFunc
  end
  self.needFindNum = needFindNum
  self.inputValue = ""
  self.canUseSearch = false
  self.isInCD = false
  self.onInputValChangeBlock = false
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    self.inputValue = DataCenter.ChatPrivateSearchDataManager:GetCurSearchTxt()
  end
  self.onInputValChangeBlock = true
  self.search_input_field_ex:SetText(self.inputValue)
  self.onInputValChangeBlock = false
  self:Update1000MS()
  self:OnInputChangeViewRefresh()
  if viewShowType == ChatPrivateListShowType.Normal then
    self:RefreshNormalTypeShow()
  elseif viewShowType == ChatPrivateListShowType.Search then
    self:RefreshSearchTypeShow()
  end
end

function UIGiftShareSearchObjItem:UpdateViewByType()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    self.inputValue = DataCenter.ChatPrivateSearchDataManager:GetCurSearchTxt()
  end
  if viewShowType == ChatPrivateListShowType.Normal then
    self:RefreshNormalTypeShow()
  elseif viewShowType == ChatPrivateListShowType.Search then
    self:RefreshSearchTypeShow()
  end
end

function UIGiftShareSearchObjItem:RefreshNormalTypeShow()
  local offsetMaxX, offsetMaxY = self.search_input_field_ex:GetOffsetMaxXY()
  local offsetMaxX2, offsetMaxY2 = self.search_input_field_ex:GetOffsetMinXY()
  self.search_input_field_ex:SetOffsetMaxXY(-1 * searchBoxOffset1, offsetMaxY)
  self.search_input_field_ex:SetOffsetMinXY(1 * searchBoxOffset1, offsetMaxY2)
  self.bg_show_obj_layout.childAlignment = CS.UnityEngine.TextAnchor.MiddleCenter
  self.num_text:SetText("")
  self.warn_text:SetActive(false)
  self.btn_send:SetActive(false)
  self.btn_cancel:SetActive(false)
end

function UIGiftShareSearchObjItem:RefreshSearchTypeShow()
  local offsetMaxX, offsetMaxY = self.search_input_field_ex:GetOffsetMaxXY()
  local offsetMaxX2, offsetMaxY2 = self.search_input_field_ex:GetOffsetMinXY()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  if not isMirror then
    self.search_input_field_ex:SetOffsetMaxXY(-1 * searchBoxOffset2, offsetMaxY)
    self.search_input_field_ex:SetOffsetMinXY(1 * searchBoxOffset1, offsetMaxY2)
  else
    self.search_input_field_ex:SetOffsetMaxXY(-1 * searchBoxOffset1, offsetMaxY)
    self.search_input_field_ex:SetOffsetMinXY(1 * searchBoxOffset2, offsetMaxY2)
  end
  self.bg_show_obj_layout.childAlignment = CS.UnityEngine.TextAnchor.MiddleLeft
  self.num_text:SetText("")
  self.warn_text:SetActive(false)
  self.btn_send:SetActive(true)
  self.btn_cancel:SetActive(true)
end

function UIGiftShareSearchObjItem:IptOnValueChange(value)
  if self.onInputValChangeBlock then
    return
  end
  self.inputValue = value
  DataCenter.ChatPrivateSearchDataManager:SetCurSearchTxt(self.inputValue)
  self:OnInputChangeViewRefresh()
end

function UIGiftShareSearchObjItem:OnInputChangeViewRefresh()
  local state = self:CheckName(self.inputValue)
  self:CheckNameChangeState(state)
end

function UIGiftShareSearchObjItem:CheckName(value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  return type
end

function UIGiftShareSearchObjItem:CheckNameChangeState(type)
  if string.IsNullOrEmpty(self.inputValue) then
    self.num_text:SetText("")
  else
    local len = #self.inputValue
    self.num_text:SetText(len .. "/" .. MAX_AL_NAME_CHAR)
  end
  self.canUseSearch = false
  if string.IsNullOrEmpty(self.inputValue) then
    self.warn_text:SetActive(false)
  else
    self.checkState = type
    if type == CheckNameType.None then
      self.warn_text:SetActive(false)
      self.canUseSearch = true
    elseif type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.warn_text:SetActive(true)
      local strKey = "user_search_tips"
      if type == CheckNameType.MinNameChar then
        strKey = "user_search_tips"
      elseif type == CheckNameType.MaxNameChar then
        strKey = "120193"
      end
      self.warn_text:SetLocalText(strKey)
    else
      self.warn_text:SetActive(false)
      self.canUseSearch = true
    end
  end
  if not self.isInCD then
    self.btn_send_txt:SetLocalText("user_search_btn")
    UIGray.SetGray(self.btn_send.transform, not self.canUseSearch, self.canUseSearch)
  end
end

function UIGiftShareSearchObjItem:Update1000MS()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local canSearchTime = DataCenter.ChatPrivateSearchDataManager:GetCanSearchTime()
    local isInCDOld = self.isInCD
    if curTime > canSearchTime then
      self.isInCD = false
    else
      self.isInCD = true
      self.btn_send_txt:SetLocalText("time_count_s", math.ceil((canSearchTime - curTime) / 1000))
      UIGray.SetGray(self.btn_send.transform, true, false)
    end
    if isInCDOld ~= self.isInCD then
      self:OnInputChangeViewRefresh()
    end
  end
end

function UIGiftShareSearchObjItem:OnSendBtnClick()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType ~= ChatPrivateListShowType.Search then
    return
  end
  if self.isInCD then
    return
  end
  if not self.canUseSearch then
    return
  end
  if self.needFindNum and self.needFindNum > 0 then
    DataCenter.ChatPrivateSearchDataManager:OnSearchStart(self.inputValue)
    SFSNetwork.SendMessage(MsgDefines.SearchChatRoomV3, self.inputValue, 0)
    self:Update1000MS()
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchViewRefresh)
  else
    DataCenter.ChatPrivateSearchDataManager:OnSearchStart(self.inputValue)
    self:Update1000MS()
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchViewRefresh)
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchResultMsgBack)
  end
end

function UIGiftShareSearchObjItem:SetContentViewScript()
end

return UIGiftShareSearchObjItem
