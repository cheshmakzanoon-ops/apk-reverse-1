local base = UIBaseContainer
local GiftShowMessageContent = BaseClass("GiftShowMessageContent", base)
local Localization = CS.GameEntry.Localization
local TranslateContentComp = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Component.TranslateContentComp")
local empty_content_path = "contentRoot/emptyContent"
local show_content_path = "contentRoot/showContent"
local u_i_player_head_path = "contentRoot/showContent/UIPlayerHead"
local gender_name_group_path = "contentRoot/showContent/GenderNameGroup"
local player_name_text_path = "contentRoot/showContent/GenderNameGroup/PlayerNameText"
local info_name_content_path = "contentRoot/showContent/infoNameContent"
local exhibit_content_path = "contentRoot/showContent/exhibitContent"
local exhibit_txt_path = "contentRoot/showContent/exhibitContent/exhibitTxt"
local editor_content_path = "contentRoot/showContent/editorContent"
local editor_txt_path = "contentRoot/showContent/editorContent/editorTxt"
local set_msg_btn_path = "contentRoot/showContent/editorContent/btnContent/SetMsgBtn"
local select_content_path = "contentRoot/showContent/editorContent/selectContent"
local no_data_txt_path = "contentRoot/showContent/noDataTxt"
local select_btn_path = "contentRoot/showContent/editorContent/selectContent/selectBtn"
local selected_img_path = "contentRoot/showContent/editorContent/selectContent/selectBtn/selectedBg/selectedImg"
local translateTrans_path = "contentRoot/showContent/exhibitContent/translateContent"
local translate_content_editor_path = "contentRoot/showContent/editorContent/btnContent/translateContentEditor"
local bg_path = "contentRoot/bg"
local arrow_path = "contentRoot/bg/arrow"
local minTxtH = 50
local maxTxtH = 150
local bgBaseSpaceH = 50
local funcBtnH = 50
local isShowEditorH = 68

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
  self.rootBg = self:AddComponent(UIBaseContainer, "")
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.show_content = self:AddComponent(UIBaseContainer, show_content_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  self.gender_name_group = self:AddComponent(UIBaseContainer, gender_name_group_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.info_name_content = self:AddComponent(UIBaseContainer, info_name_content_path)
  self.exhibit_content = self:AddComponent(UIBaseContainer, exhibit_content_path)
  self.exhibit_txt = self:AddComponent(UITextMeshProUGUIEx, exhibit_txt_path)
  self.editor_content = self:AddComponent(UIBaseContainer, editor_content_path)
  self.editor_txt = self:AddComponent(UITextMeshProUGUIEx, editor_txt_path)
  self.set_msg_btn = self:AddComponent(UIButton, set_msg_btn_path)
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
  self.no_data_txt = self:AddComponent(UITextMeshProUGUIEx, no_data_txt_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.selected_img = self:AddComponent(UIImage, selected_img_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  ChatInterface.SetEmojiTextProperty(self.exhibit_txt)
  ChatInterface.SetEmojiTextProperty(self.editor_txt)
  self.select_btn:SetOnClick(function()
    if self.dataChangeFunc then
      self.dataChangeFunc(true, false, false)
    end
  end)
  self.set_msg_btn:SetOnClick(function()
    self:OnSetMsgBtnClick()
  end)
  self.translateTrans = self:AddComponent(TranslateContentComp, translateTrans_path)
  self.translateTrans:SetData(TranslateStateType.NotTranslated, function()
    self:OnTranslateBtnClick()
  end)
  self.translate_content_editor = self:AddComponent(TranslateContentComp, translate_content_editor_path)
  self.translate_content_editor:SetData(TranslateStateType.NotTranslated, function()
    self:OnEditorTranslateBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.empty_content = nil
  self.show_content = nil
  self.u_i_player_head = nil
  self.gender_name_group = nil
  self.player_name_text = nil
  self.info_name_content = nil
  self.exhibit_content = nil
  self.exhibit_txt = nil
  self.editor_content = nil
  self.editor_txt = nil
  self.set_msg_btn = nil
  self.select_content = nil
  self.no_data_txt = nil
  self.select_btn = nil
  self.selected_img = nil
  self.translateTrans = nil
  self.bg = nil
  self.arrow = nil
  self.translate_content_editor = nil
end

local function DataDefine(self)
  self.targetUid = nil
  self.originIdList = {}
  self.curOriginId = nil
  self.showData = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.dataChangeFunc = nil
end

local function DataDestroy(self)
  self.targetUid = nil
  self.originIdList = nil
  self.curOriginId = nil
  self.showData = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.dataChangeFunc = nil
end

function GiftShowMessageContent:SetData(targetUid, originIdList, curOriginId, showData, giftGoodsTemp, goodsTemp)
  self.targetUid = targetUid
  self.originIdList = originIdList
  self.curOriginId = curOriginId
  self.showData = showData
  self.giftGoodsTemp = giftGoodsTemp
  self.goodsTemp = goodsTemp
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  if self.showData == nil or self.giftGoodsTemp == nil or self.goodsTemp == nil then
    return
  end
  self:RefreshView()
end

function GiftShowMessageContent:RefreshView()
  if self.showData == nil then
    self.empty_content:SetActive(true)
    self.show_content:SetActive(false)
    self.rootBg:SetSizeDeltaY(minTxtH + bgBaseSpaceH + funcBtnH)
    return
  end
  local canEditor = false
  if #self.giftGoodsTemp.group_id > 0 then
    for i, v in ipairs(self.giftGoodsTemp.group_id) do
      local curNum = tonumber(v)
      local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(self.giftGoodsTemp.id, curNum)
      if curCanEditor == 1 then
        canEditor = true
        break
      end
    end
  else
    local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(self.giftGoodsTemp.id, 1)
    if curCanEditor == 1 then
      canEditor = true
    end
  end
  if not canEditor then
    self.rootBg:SetActive(false)
    return
  end
  self.rootBg:SetActive(true)
  local bg, arrow, nameColor = GiftSystemConst.GetGiftShowMsgBoardPic(self.goodsTemp.color)
  self.bg:LoadSprite(bg)
  self.arrow:LoadSprite(arrow)
  self.player_name_text:SetColorHex(nameColor)
  if self.isEditorType then
    self:RefreshEditorTypeView()
  else
    self:RefreshNormalTypeView()
  end
end

function GiftShowMessageContent:RefreshEditorTypeView()
  local txtUseH = minTxtH
  self.empty_content:SetActive(false)
  self.show_content:SetActive(true)
  if self.showData.giftDetailSet.contentId > 0 and not string.IsNullOrEmpty(self.showData.contentObj.senderUid) then
    self.u_i_player_head:SetActive(true)
    self.gender_name_group:SetActive(true)
    self.exhibit_content:SetActive(false)
    self.editor_content:SetActive(true)
    self.no_data_txt:SetActive(false)
    self.editor_txt:SetActive(true)
    self:RefreshPlayerContent()
    self:RefreshTxtContent()
    local sizeX = self.editor_txt:GetSizeDelta().x
    self.editor_txt:SetSizeDeltaXY(sizeX, 1000)
    local txtContentVal = self.editor_txt.unity_tmpro:GetPreferredValues(sizeX, 0)
    if txtUseH < txtContentVal.y then
      txtUseH = txtContentVal.y
      if txtUseH > maxTxtH then
        txtUseH = maxTxtH
      end
    end
    self.editor_txt:SetSizeDeltaXY(sizeX, txtUseH)
  else
    self.u_i_player_head:SetActive(false)
    self.gender_name_group:SetActive(false)
    self.exhibit_content:SetActive(false)
    self.editor_content:SetActive(true)
    self.no_data_txt:SetActive(true)
    self.editor_txt:SetActive(false)
    self.translate_content_editor:SetStateData(TranslateStateType.TranslationCompleted)
  end
  self.selected_img:SetActive(0 >= self.showData.giftDetailSet.contentState)
  self.rootBg:SetSizeDeltaY(txtUseH + bgBaseSpaceH + isShowEditorH + funcBtnH)
end

function GiftShowMessageContent:RefreshNormalTypeView()
  local isShowEmpty = true
  local txtUseH = minTxtH
  if self.showData.giftDetailSet.contentState > 0 and 0 < self.showData.giftDetailSet.contentId and not string.IsNullOrEmpty(self.showData.contentObj.senderUid) and not string.IsNullOrEmpty(self.showData.contentObj.content) then
    isShowEmpty = false
  end
  if isShowEmpty then
    self.empty_content:SetActive(true)
    self.show_content:SetActive(false)
  else
    self.empty_content:SetActive(false)
    self.show_content:SetActive(true)
    self.u_i_player_head:SetActive(true)
    self.gender_name_group:SetActive(true)
    self.exhibit_content:SetActive(true)
    self.editor_content:SetActive(false)
    self.no_data_txt:SetActive(false)
    self.editor_txt:SetActive(true)
    self:RefreshPlayerContent()
    self:RefreshTxtContent()
    local sizeX = self.exhibit_txt:GetSizeDelta().x
    self.exhibit_txt:SetSizeDeltaXY(sizeX, 1000)
    local txtContentVal = self.exhibit_txt.unity_tmpro:GetPreferredValues(sizeX, 0)
    if txtUseH < txtContentVal.y then
      txtUseH = txtContentVal.y
      if txtUseH > maxTxtH then
        txtUseH = maxTxtH
      end
    end
    self.exhibit_txt:SetSizeDeltaXY(sizeX, txtUseH)
  end
  self.rootBg:SetSizeDeltaY(txtUseH + bgBaseSpaceH + funcBtnH)
end

function GiftShowMessageContent:RefreshPlayerContent()
  local userInfo = self.showData.contentObj.userInfo
  if userInfo == nil then
    return
  end
  local name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
  self.u_i_player_head:ParseHeadInfo(userInfo)
  self.player_name_text:SetText(name)
end

function GiftShowMessageContent:RefreshTxtContent()
  local content = self.showData.contentObj.content
  local translateState, translateText = DataCenter.TranslateResultSaveDataManager:GetTranslateResult(TranslateSaveDataFuncType.GiftHistory, self.showData.contentObj.uuid)
  local desShowTxt = ""
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
  self.exhibit_txt:SetText(desShowTxt)
  self.editor_txt:SetText(desShowTxt)
  self.translateTrans:SetStateData(translateState)
  self.translate_content_editor:SetStateData(translateState)
end

function GiftShowMessageContent:SetInfoDataSetFunc(dataChangeFunc)
  self.dataChangeFunc = dataChangeFunc
end

function GiftShowMessageContent:OnSetMsgBtnClick()
  if self.showData == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftSetMsgShowPanel, {anim = true}, {
    targetUid = self.targetUid,
    itemId = self.curOriginId,
    showData = self.showData
  })
end

function GiftShowMessageContent:OnTranslateBtnClick()
  if self.showData == nil then
    return
  end
  if self.showData.contentObj == nil then
    return
  end
  DataCenter.TranslateResultSaveDataManager:SetTranslateStateDoing(TranslateSaveDataFuncType.GiftHistory, self.showData.contentObj.uuid)
  self:RefreshTxtContent()
  local content = self.showData.contentObj.content
  ChatManager2:GetInstance().Translate:Translate(content, nil, nil, function(ok, data)
    if not data or data.code ~= 0 then
      DataCenter.TranslateResultSaveDataManager:ClearTranslateResult(TranslateSaveDataFuncType.GiftHistory, self.showData.contentObj.uuid)
    else
      DataCenter.TranslateResultSaveDataManager:SaveTranslateResult(TranslateSaveDataFuncType.GiftHistory, self.showData.contentObj.uuid, data.translateMsg)
    end
    if self.view and self.view.ctrl then
      self:RefreshTxtContent()
    end
  end)
end

function GiftShowMessageContent:OnEditorTranslateBtnClick()
  self:OnTranslateBtnClick()
end

GiftShowMessageContent.OnCreate = OnCreate
GiftShowMessageContent.OnDestroy = OnDestroy
GiftShowMessageContent.OnEnable = OnEnable
GiftShowMessageContent.OnDisable = OnDisable
GiftShowMessageContent.ComponentDefine = ComponentDefine
GiftShowMessageContent.ComponentDestroy = ComponentDestroy
GiftShowMessageContent.DataDefine = DataDefine
GiftShowMessageContent.DataDestroy = DataDestroy
return GiftShowMessageContent
