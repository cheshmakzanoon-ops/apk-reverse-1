local base = UIBaseContainer
local LWUIGiftSetMsgItem = BaseClass("LWUIGiftSetMsgItem", base)
local Localization = CS.GameEntry.Localization
local ItemMinH = 263
local ContentWithItemDiff = 127
local playerHead_path = "UIPlayerHead"
local descTxt_path = "TxtContent/Txt_Des"
local timeTxt_path = "Txt_Time"
local titleTxt_path = "TxtContent/Txt_Title"
local giftIconImg_path = "Layout/GiftBg/GiftIcon"
local giftNumTxt_path = "Layout/GiftBg/Txt_GiftNum"
local sendGiftBtn_path = "SendGiftBtn"
local translateTrans_path = "TxtContent/translateContent"
local translateBtn_path = "TxtContent/translateContent/TranslateBtn"
local translateRefreshBtn_path = "TxtContent/translateContent/TranslateRefreshBtn"
local translateFinishImg_path = "TxtContent/translateContent/TranslateFinishImg"
local translating_path = "TxtContent/translateContent/Translating"
local translatingText_path = "TxtContent/translateContent/Translating/TranslatingText"
local txtContent_path = "TxtContent"
local rootLayoutE_path = ""
local have_set_txt_path = "HaveSetTxt"

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

local function ComponentDefine(self)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.descTxt = self:AddComponent(UITextMeshProUGUI, descTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.giftIconImg = self:AddComponent(UIImage, giftIconImg_path)
  self.giftNumTxt = self:AddComponent(UIText, giftNumTxt_path)
  self.sendGiftBtn = self:AddComponent(UIButton, sendGiftBtn_path)
  self.translateTrans = self:AddComponent(UIBaseContainer, translateTrans_path)
  self.translateBtn = self:AddComponent(UIButton, translateBtn_path)
  self.translateRefreshBtn = self:AddComponent(UIButton, translateRefreshBtn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translateFinishImg_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_path)
  self.txtContent = self:AddComponent(UIBaseContainer, txtContent_path)
  self.rootLayoutE = self:AddComponent(UILayoutElement, rootLayoutE_path)
  self.translatingText = self:AddComponent(UIText, translatingText_path)
  self.translatingText:SetLocalText("120039")
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHeadComponent:SetEnableClickShowInfo(true, true)
  self.sendGiftBtn:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  ChatInterface.SetEmojiTextProperty(self.descTxt)
  self.translateBtn:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
  self.have_set_txt = self:AddComponent(UITextMeshProUGUIEx, have_set_txt_path)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.descTxt = nil
  self.timeTxt = nil
  self.titleTxt = nil
  self.giftIconImg = nil
  self.giftNumTxt = nil
  self.sendGiftBtn = nil
  self.translateTrans = nil
  self.translateBtn = nil
  self.translateRefreshBtn = nil
  self.translateFinishImg = nil
  self.translating = nil
  self.translatingText = nil
  self.txtContent = nil
  self.rootLayoutE = nil
  self.playerHeadComponent = nil
  self.have_set_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftSetMsgItem:OnSendBtnClick()
  if self.data == nil then
    return
  end
  if self.showData == nil then
    return
  end
  if self.showData.giftDetailSet.contentId ~= self.data.uuid then
    self.showData:SendSetDataMsg(false, false, false, self.data.uuid, self.data.num)
    self.view.ctrl:CloseSelf()
  else
  end
end

function LWUIGiftSetMsgItem:RefreshView(index, data, showData)
  if data == nil then
    return
  end
  if showData == nil then
    return
  end
  self.data = data
  self.showData = showData
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  self.giftIconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
    if self.giftIconImg then
      self.giftIconImg:SetNativeSize()
    end
  end)
  self.giftIconImg:SetLocalScaleXYZ(minScale, minScale, minScale)
  self.giftNumTxt:SetText(data.num)
  local userInfo = data.userInfo
  self.playerHeadComponent:SetEnableClickShowInfo(data.anonymous ~= 1)
  self.playerHeadComponent:ParseHeadInfo(userInfo)
  self.timeTxt:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.sendTime * 1000, false))
  local uid = tostring(LuaEntry.Player.uid)
  if self.showData.giftDetailSet.contentId == self.data.uuid then
    self.sendGiftBtn:SetActive(false)
    self.have_set_txt:SetActive(true)
  else
    self.sendGiftBtn:SetActive(true)
    self.have_set_txt:SetActive(false)
  end
  self:RefreshTxtContent()
end

function LWUIGiftSetMsgItem:RefreshTxtContent()
  if self.data == nil then
    return
  end
  local data = self.data
  local userInfo = data.userInfo
  local name = ""
  local content = ""
  local isShowContent = true
  local isAnonymous = data.anonymous == 1
  local isBlock = ChatManager2:GetInstance().Restrict:isInRestrictList(userInfo.uid, RestrictType.BLOCK)
  if not isAnonymous then
    name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
    content = data.content or ""
  else
    name = Localization:GetString("390810")
    isShowContent = false
  end
  if isBlock then
    name = Localization:GetString("390810")
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.data.itemId)
    local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, self.data.num)
    content = Localization:GetString(defaultKey)
    isShowContent = false
  end
  if string.IsNullOrEmpty(content) then
    isShowContent = false
  end
  local translateState, translateText = DataCenter.TranslateResultSaveDataManager:GetTranslateResult(TranslateSaveDataFuncType.GiftHistory, data.uuid)
  local desShowTxt = ""
  if isShowContent then
    if translateState == TranslateStateType.NotTranslated or translateState == TranslateStateType.TranslationError then
      desShowTxt = content
    elseif translateState == TranslateStateType.TranslationCompleted then
      desShowTxt = translateText
    elseif translateState == TranslateStateType.Translating then
      if string.IsNullOrEmpty(translateText) then
        desShowTxt = content
      else
        desShowTxt = translateText
      end
    end
  end
  self.titleTxt:SetText(string.gsub(name, " ", "<space=10>"))
  self.descTxt:SetText(desShowTxt)
  local isTranslateBtnShow = false
  if isShowContent and translateState ~= TranslateStateType.TranslationCompleted then
    isTranslateBtnShow = true
    self.translateTrans:SetActive(true)
    local isTranslating = translateState == TranslateStateType.Translating
    local hasTranslated = translateState == TranslateStateType.TranslationCompleted
    self.translating:SetActive(isTranslating and not hasTranslated)
    self.translateBtn:SetActive(not isTranslating and not hasTranslated)
    self.translateFinishImg:SetActive(false)
    self.translateRefreshBtn:SetActive(false)
  else
    self.translateTrans:SetActive(false)
  end
  local txtContentH = 0
  local titleTxtContentVal = self.titleTxt.unity_tmpro:GetPreferredValues(self.titleTxt:GetSizeDelta().x, 0)
  local descTxtContentVal = self.descTxt.unity_tmpro:GetPreferredValues(self.descTxt:GetSizeDelta().x, 0)
  txtContentH = titleTxtContentVal.y + descTxtContentVal.y
  local itemH = txtContentH + ContentWithItemDiff
  itemH = math.max(itemH, ItemMinH)
  self.rootLayoutE:SetPreferredHeight(itemH)
  self.rootLayoutE:SetMinHeight(itemH)
end

function LWUIGiftSetMsgItem:OnTranslateBtnClick()
  if self.data == nil then
    return
  end
  DataCenter.TranslateResultSaveDataManager:SetTranslateStateDoing(TranslateSaveDataFuncType.GiftHistory, self.data.uuid)
  self:RefreshTxtContent()
  local content = self.data.content
  ChatManager2:GetInstance().Translate:Translate(content, nil, nil, function(ok, data)
    if not data or data.code ~= 0 then
      DataCenter.TranslateResultSaveDataManager:ClearTranslateResult(TranslateSaveDataFuncType.GiftHistory, self.data.uuid)
    else
      DataCenter.TranslateResultSaveDataManager:SaveTranslateResult(TranslateSaveDataFuncType.GiftHistory, self.data.uuid, data.translateMsg)
    end
    if self.view and self.view.ctrl then
      self:RefreshTxtContent()
    end
  end)
end

LWUIGiftSetMsgItem.OnCreate = OnCreate
LWUIGiftSetMsgItem.OnDestroy = OnDestroy
LWUIGiftSetMsgItem.OnEnable = OnEnable
LWUIGiftSetMsgItem.OnDisable = OnDisable
LWUIGiftSetMsgItem.ComponentDefine = ComponentDefine
LWUIGiftSetMsgItem.ComponentDestroy = ComponentDestroy
LWUIGiftSetMsgItem.DataDefine = DataDefine
LWUIGiftSetMsgItem.DataDestroy = DataDestroy
return LWUIGiftSetMsgItem
