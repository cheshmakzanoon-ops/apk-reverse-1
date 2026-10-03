local base = UIBaseContainer
local GiftShowSendMaxContent = BaseClass("GiftShowSendMaxContent", base)
local Localization = CS.GameEntry.Localization
local empty_content_path = "emptyContent"
local show_content_path = "showContent"
local u_i_player_head_path = "showContent/UIPlayerHead"
local player_name_text_path = "showContent/GenderNameGroup/PlayerNameText"
local exhibit_content_path = "showContent/exhibitContent"
local exhibit_txt_path = "showContent/exhibitContent/exhibitTxt"
local editor_content_path = "showContent/editorContent"
local editor_txt_path = "showContent/editorContent/editorTxt"
local select_content_path = "showContent/editorContent/selectContent"
local select_btn_path = "showContent/editorContent/selectContent/selectBtn"
local selected_img_path = "showContent/editorContent/selectContent/selectBtn/selectedBg/selectedImg"
local gender_name_group_path = "showContent/GenderNameGroup"
local no_data_txt_path = "showContent/noDataTxt"
local v_f_x_charge_path = "VFX_charge"

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
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.exhibit_content = self:AddComponent(UIBaseContainer, exhibit_content_path)
  self.exhibit_txt = self:AddComponent(UITextMeshProUGUIEx, exhibit_txt_path)
  self.editor_content = self:AddComponent(UIBaseContainer, editor_content_path)
  self.editor_txt = self:AddComponent(UITextMeshProUGUIEx, editor_txt_path)
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.selected_img = self:AddComponent(UIImage, selected_img_path)
  self.gender_name_group = self:AddComponent(UIBaseContainer, gender_name_group_path)
  self.no_data_txt = self:AddComponent(UITextMeshProUGUIEx, no_data_txt_path)
  self.v_f_x_charge = self:AddComponent(UIVfx, v_f_x_charge_path)
  self.select_btn:SetOnClick(function()
    if self.dataChangeFunc then
      self.dataChangeFunc(false, true, false)
    end
  end)
end

local function ComponentDestroy(self)
  self.empty_content = nil
  self.show_content = nil
  self.u_i_player_head = nil
  self.player_name_text = nil
  self.exhibit_content = nil
  self.exhibit_txt = nil
  self.editor_content = nil
  self.editor_txt = nil
  self.select_content = nil
  self.select_btn = nil
  self.selected_img = nil
  self.gender_name_group = nil
  self.no_data_txt = nil
  self.v_f_x_charge:Remove()
  self.v_f_x_charge = nil
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

function GiftShowSendMaxContent:SetData(targetUid, originIdList, curOriginId, showData, giftGoodsTemp, goodsTemp)
  self.targetUid = targetUid
  self.originIdList = originIdList
  self.curOriginId = curOriginId
  self.showData = showData
  self.giftGoodsTemp = giftGoodsTemp
  self.goodsTemp = goodsTemp
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  self:RefreshView()
end

function GiftShowSendMaxContent:RefreshView()
  if self.showData == nil then
    self.empty_content:SetActive(true)
    self.show_content:SetActive(false)
    self.v_f_x_charge:SetActive(false)
    self.v_f_x_charge:Remove()
    return
  end
  if self.isEditorType then
    self:RefreshEditorTypeView()
  else
    self:RefreshNormalTypeView()
  end
  self:RefreshBgEffect()
end

function GiftShowSendMaxContent:RefreshBgEffect()
  local maxNum = 0
  local effectPath
  if self.targetUid == LuaEntry.Player.uid then
    if not string.IsNullOrEmpty(self.showData.maxObj.senderUid) then
      maxNum = self.showData.maxObj.num
    end
  elseif 0 < self.showData.giftDetailSet.maxState and not string.IsNullOrEmpty(self.showData.maxObj.senderUid) then
    maxNum = self.showData.maxObj.num
  end
  if maxNum <= 0 then
    maxNum = 1
  end
  if 0 < maxNum then
    local val = LuaEntry.DataConfig:TryGetStr("gift_show_control", "k3")
    if not string.IsNullOrEmpty(val) then
      local valList = string.string2array_s(val, ";", "|")
      for i = 1, #valList do
        local data = valList[i]
        if #data == 2 then
          local num = tonumber(data[1])
          if maxNum >= num then
            effectPath = data[2]
          else
            break
          end
        end
      end
    end
  end
  if not string.IsNullOrEmpty(effectPath) then
    local fPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/IconEffect/UIEffect/%s.prefab"
    self.v_f_x_charge:SetActive(true)
    self.v_f_x_charge:PlayByStay(string.format(fPath, effectPath), {isBreak = true})
  else
    self.v_f_x_charge:SetActive(false)
    self.v_f_x_charge:Remove()
  end
end

function GiftShowSendMaxContent:RefreshEditorTypeView()
  self.empty_content:SetActive(false)
  self.show_content:SetActive(true)
  if not string.IsNullOrEmpty(self.showData.maxObj.senderUid) then
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
  self.selected_img:SetActive(self.showData.giftDetailSet.maxState <= 0)
end

function GiftShowSendMaxContent:RefreshNormalTypeView()
  local isShowEmpty = true
  if self.showData.giftDetailSet.maxState > 0 and not string.IsNullOrEmpty(self.showData.maxObj.senderUid) then
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

function GiftShowSendMaxContent:RefreshPlayerContent()
  local userInfo = self.showData.maxObj.userInfo
  if userInfo == nil then
    return
  end
  local name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
  self.u_i_player_head:ParseHeadInfo(userInfo)
  self.player_name_text:SetText(name)
  local goodsName = Localization:GetString(self.goodsTemp.name)
  local strKey = "gifts_show_tips_8"
  local maxNum = self.showData.maxObj.num
  if maxNum and 0 < maxNum then
    local val = LuaEntry.DataConfig:TryGetStr("gift_show_control", "k2")
    if not string.IsNullOrEmpty(val) then
      local valList = string.string2array_s(val, ";", "|")
      for i = 1, #valList do
        local data = valList[i]
        if #data == 2 then
          local num = tonumber(data[1])
          if maxNum >= num then
            strKey = data[2]
          else
            break
          end
        end
      end
    end
  end
  self.editor_txt:SetLocalText(strKey, goodsName, self.showData.maxObj.num)
  self.exhibit_txt:SetLocalText(strKey, goodsName, self.showData.maxObj.num)
end

function GiftShowSendMaxContent:SetInfoDataSetFunc(dataChangeFunc)
  self.dataChangeFunc = dataChangeFunc
end

GiftShowSendMaxContent.OnCreate = OnCreate
GiftShowSendMaxContent.OnDestroy = OnDestroy
GiftShowSendMaxContent.OnEnable = OnEnable
GiftShowSendMaxContent.OnDisable = OnDisable
GiftShowSendMaxContent.ComponentDefine = ComponentDefine
GiftShowSendMaxContent.ComponentDestroy = ComponentDestroy
GiftShowSendMaxContent.DataDefine = DataDefine
GiftShowSendMaxContent.DataDestroy = DataDestroy
return GiftShowSendMaxContent
