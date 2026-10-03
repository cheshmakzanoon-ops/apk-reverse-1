local base = UIBaseContainer
local GiftShowFirstSendContent = BaseClass("GiftShowFirstSendContent", base)
local Localization = CS.GameEntry.Localization
local empty_content_path = "emptyContent"
local show_content_path = "showContent"
local u_i_player_head_path = "showContent/UIPlayerHead"
local gender_name_group_path = "showContent/GenderNameGroup"
local player_name_text_path = "showContent/GenderNameGroup/PlayerNameText"
local exhibit_content_path = "showContent/exhibitContent"
local exhibit_txt_path = "showContent/exhibitContent/exhibitTxt"
local editor_content_path = "showContent/editorContent"
local editor_txt_path = "showContent/editorContent/editorTxt"
local select_btn_path = "showContent/editorContent/selectContent/selectBtn"
local selected_img_path = "showContent/editorContent/selectContent/selectBtn/selectedBg/selectedImg"
local no_data_txt_path = "showContent/noDataTxt"

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
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.show_content = self:AddComponent(UIBaseContainer, show_content_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  self.gender_name_group = self:AddComponent(UIBaseContainer, gender_name_group_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.exhibit_content = self:AddComponent(UIBaseContainer, exhibit_content_path)
  self.exhibit_txt = self:AddComponent(UITextMeshProUGUIEx, exhibit_txt_path)
  self.editor_content = self:AddComponent(UIBaseContainer, editor_content_path)
  self.editor_txt = self:AddComponent(UITextMeshProUGUIEx, editor_txt_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.selected_img = self:AddComponent(UIImage, selected_img_path)
  self.no_data_txt = self:AddComponent(UITextMeshProUGUIEx, no_data_txt_path)
  self.select_btn:SetOnClick(function()
    if self.dataChangeFunc then
      self.dataChangeFunc(false, false, true)
    end
  end)
  self.bg = self:AddComponent(UIImage, "")
end

local function ComponentDestroy(self)
  self.empty_content = nil
  self.show_content = nil
  self.u_i_player_head = nil
  self.gender_name_group = nil
  self.player_name_text = nil
  self.exhibit_content = nil
  self.exhibit_txt = nil
  self.editor_content = nil
  self.editor_txt = nil
  self.select_btn = nil
  self.selected_img = nil
  self.no_data_txt = nil
end

local function DataDefine(self)
  self.targetUid = nil
  self.originIdList = {}
  self.curOriginId = nil
  self.showData = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.isEditorType = false
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

function GiftShowFirstSendContent:SetData(targetUid, originIdList, curOriginId, showData, giftGoodsTemp, goodsTemp)
  self.targetUid = targetUid
  self.originIdList = originIdList
  self.curOriginId = curOriginId
  self.showData = showData
  self.giftGoodsTemp = giftGoodsTemp
  self.goodsTemp = goodsTemp
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  self:RefreshView()
end

function GiftShowFirstSendContent:RefreshView()
  if self.goodsTemp == nil then
    return
  end
  local bg, modelBg, txtColor, infoBg = GiftSystemConst.GetGiftDetailShowQualityPic(self.goodsTemp.color)
  self.bg:LoadSprite(infoBg)
  if self.showData == nil then
    self.empty_content:SetActive(true)
    self.show_content:SetActive(false)
    return
  end
  if self.isEditorType then
    self:RefreshEditorTypeView()
  else
    self:RefreshNormalTypeView()
  end
end

function GiftShowFirstSendContent:RefreshEditorTypeView()
  self.empty_content:SetActive(false)
  self.show_content:SetActive(true)
  if not string.IsNullOrEmpty(self.showData.firstObj.senderUid) then
    self.u_i_player_head:SetActive(true)
    self.gender_name_group:SetActive(true)
    self.exhibit_content:SetActive(false)
    self.editor_content:SetActive(true)
    self.no_data_txt:SetActive(false)
    self.editor_txt:SetActive(true)
    self:RefreshPlayerContent()
  else
    self.u_i_player_head:SetActive(false)
    self.gender_name_group:SetActive(false)
    self.exhibit_content:SetActive(false)
    self.editor_content:SetActive(true)
    self.no_data_txt:SetActive(true)
    self.editor_txt:SetActive(false)
  end
  self.selected_img:SetActive(self.showData.giftDetailSet.firstState <= 0)
end

function GiftShowFirstSendContent:RefreshNormalTypeView()
  local isShowEmpty = true
  if self.showData.giftDetailSet.firstState > 0 and not string.IsNullOrEmpty(self.showData.firstObj.senderUid) then
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
  end
end

function GiftShowFirstSendContent:RefreshPlayerContent()
  local userInfo = self.showData.firstObj.userInfo
  if userInfo == nil then
    return
  end
  local name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
  self.u_i_player_head:ParseHeadInfo(userInfo)
  self.player_name_text:SetText(name)
  local goodsName = Localization:GetString(self.goodsTemp.name)
  self.editor_txt:SetLocalText("gifts_show_tips_9", goodsName)
  self.exhibit_txt:SetLocalText("gifts_show_tips_9", goodsName)
end

function GiftShowFirstSendContent:SetInfoDataSetFunc(dataChangeFunc)
  self.dataChangeFunc = dataChangeFunc
end

GiftShowFirstSendContent.OnCreate = OnCreate
GiftShowFirstSendContent.OnDestroy = OnDestroy
GiftShowFirstSendContent.OnEnable = OnEnable
GiftShowFirstSendContent.OnDisable = OnDisable
GiftShowFirstSendContent.ComponentDefine = ComponentDefine
GiftShowFirstSendContent.ComponentDestroy = ComponentDestroy
GiftShowFirstSendContent.DataDefine = DataDefine
GiftShowFirstSendContent.DataDestroy = DataDestroy
return GiftShowFirstSendContent
