local base = UIBaseView
local UIDecorationChoiceBoxView = BaseClass("UIDecorationChoiceBoxView", base)
local Localization = CS.GameEntry.Localization
local UIDecorationChoiceBoxChooseCell = require("UI.UIDecorationChoiceBox.Component.UIDecorationChoiceBoxChooseCell")
local DecorationModelShow = require("UI.UIDecorationChoiceBox.Component.DecorationModelShow")
local UIDecorationChatBubble = require("UI.UIDecorationChoiceBox.Component.UIDecorationChatBubble")
local DecorationBoxCellPath = "Assets/Main/Prefabs/UI/DecorationChoiceBox/UIDecorationChoiceBoxCell.prefab"
local panel_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "Common_bg_orange/infoContentBg/closeBtn"
local common_bg_orange_path = "Common_bg_orange"
local common_bg_orange1_path = "Common_bg_orange/Common_bg_orange1"
local info_content_bg_path = "Common_bg_orange/infoContentBg"
local info_content_bg2_path = "Common_bg_orange/infoContentBg/infoContentBg2"
local item_img_path = "Common_bg_orange/infoContentBg/itemImg"
local name_text_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/NameText"
local point_bg_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/PointBg"
local use_title_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/useTitleContent"
local use_title_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/useTitleContent/UseTitle"
local use_effect1_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/UseEffect1Content"
local use_effect2_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/UseEffect2Content"
local own_title_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/ownTitleContent"
local own_title_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/ownTitleContent/ownTitle"
local own_effect1_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/ownEffect1Content"
local own_effect2_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/EffectList/ownEffect2Content"
local btn_go_path = "Common_bg_orange/BtnGo"
local choose_btn_path = "Common_bg_orange/BtnGo/ChooseBtn"
local empty_content_path = "Common_bg_orange/emptyContent"
local data_content_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent"
local main_city_path = "Common_bg_orange/infoContentBg/MainCity"
local cell_content_path = "Common_bg_orange/CellScrollView/Viewport/CellContent"
local u_i_decoration_choice_box_cell_path = "Common_bg_orange/UIDecorationChoiceBoxCell"
local chat_bubble_path = "Common_bg_orange/infoContentBg/ChatBubble"
local point_text_path = "Common_bg_orange/infoContentBg/dataScroll/viewPort/dataContent/PointBg/PointText"
local MainCityRTSize = 600

function UIDecorationChoiceBoxView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:OnOpen()
end

function UIDecorationChoiceBoxView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationChoiceBoxView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.point_bg = self:AddComponent(UIImage, point_bg_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.common_bg_orange = self:AddComponent(UIImage, common_bg_orange_path)
  self.common_bg_orange1 = self:AddComponent(UIImage, common_bg_orange1_path)
  self.info_content_bg = self:AddComponent(UIRawImage, info_content_bg_path)
  self.info_content_bg_container = self:AddComponent(UIBaseContainer, info_content_bg_path)
  self.info_content_bg2 = self:AddComponent(UIImage, info_content_bg2_path)
  self.item_img = self:AddComponent(UIImage, item_img_path)
  self.use_title_content = self:AddComponent(UIBaseContainer, use_title_content_path)
  self.use_title = self:AddComponent(UIText, use_title_path)
  self.use_effect1_content = self:AddComponent(UIBaseContainer, use_effect1_content_path)
  self.use_effect2_content = self:AddComponent(UIBaseContainer, use_effect2_content_path)
  self.own_title_content = self:AddComponent(UIBaseContainer, own_title_content_path)
  self.own_title = self:AddComponent(UIText, own_title_path)
  self.own_effect1_content = self:AddComponent(UIBaseContainer, own_effect1_content_path)
  self.own_effect2_content = self:AddComponent(UIBaseContainer, own_effect2_content_path)
  self.use_title:SetLocalText(2000471)
  self.own_title:SetLocalText(2000472)
  self.use_effect_list = {}
  self.use_effect_list[1] = {
    root = self.use_effect1_content
  }
  self.use_effect_list[2] = {
    root = self.use_effect2_content
  }
  local effectList = self.use_effect_list
  for i = 1, #effectList do
    effectList[i].effect = effectList[i].root:AddComponent(UIText, "effect")
    effectList[i].effectVal = effectList[i].root:AddComponent(UIText, "effectVal")
  end
  self.own_effect_list = {}
  self.own_effect_list[1] = {
    root = self.own_effect1_content
  }
  self.own_effect_list[2] = {
    root = self.own_effect2_content
  }
  effectList = self.own_effect_list
  for i = 1, #effectList do
    effectList[i].effect = effectList[i].root:AddComponent(UIText, "effect")
    effectList[i].effectVal = effectList[i].root:AddComponent(UIText, "effectVal")
  end
  self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
  self.choose_btn = self:AddComponent(UIButton, choose_btn_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.choose_btn:SetOnClick(function()
    self:UseItem()
  end)
  self.data_content = self:AddComponent(UIBaseContainer, data_content_path)
  self.main_city = self:AddComponent(DecorationModelShow, main_city_path)
  self.cellList = {}
  self.cell_content = self:AddComponent(UIBaseContainer, cell_content_path)
  self.chat_bubble = self:AddComponent(UIDecorationChatBubble, chat_bubble_path)
  self.uiCommonResItem = nil
end

function UIDecorationChoiceBoxView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self:SetAllCellDestroy()
  self.uiCommonResItem = nil
  self.info_content_bg_container:RemoveComponents(UICommonResItem)
  if self.uiCommonResItemReq then
    self:GameObjectDestroy(self.uiCommonResItemReq)
    self.uiCommonResItemReq = nil
  end
  self.cellList = nil
  self.cell_content = nil
  self.name_text = nil
  self.point_bg = nil
  self.point_text = nil
  self.common_bg_orange = nil
  self.common_bg_orange1 = nil
  self.info_content_bg = nil
  self.info_content_bg_container = nil
  self.info_content_bg2 = nil
  self.item_img = nil
  self.use_title_content = nil
  self.use_title = nil
  self.use_effect1_content = nil
  self.use_effect2_content = nil
  self.own_title_content = nil
  self.own_title = nil
  self.own_effect1_content = nil
  self.own_effect2_content = nil
  self.use_effect_list = nil
  self.own_effect_list = nil
  self.btn_go = nil
  self.choose_btn = nil
  self.empty_content = nil
  self.data_content = nil
  self.chat_bubble = nil
  self.main_city:EndShow()
  self.main_city = nil
end

function UIDecorationChoiceBoxView:DataDefine()
  self.itemId = nil
  self.isDisplay = false
  self.itemUuid = nil
  self.currentSelect = 1
  self.showDataList = {}
end

function UIDecorationChoiceBoxView:DataDestroy()
  self.itemId = nil
  self.isDisplay = nil
  self.itemUuid = nil
  self.currentSelect = nil
  self.showDataList = nil
end

function UIDecorationChoiceBoxView:OnOpen()
  self.itemId, self.isDisplay, self.itemUuid = self:GetUserData()
  self.itemId = tonumber(self.itemId)
  self.showDataList = self.ctrl:GetShowData(self.itemId)
  self:SetShowType()
  self:RefreshTopContent()
  self:RefreshScrollViewNew()
  self:RefreshBottomContent()
end

function UIDecorationChoiceBoxView:SetShowType()
  if self.isDisplay then
    self.btn_go:SetActive(false)
    self.empty_content:SetActive(true)
    self.common_bg_orange1:SetOffsetMinXY(32, 50)
  else
    self.btn_go:SetActive(true)
    self.empty_content:SetActive(false)
    self.common_bg_orange1:SetOffsetMinXY(32, 150)
  end
end

function UIDecorationChoiceBoxView:RefreshScrollViewNew()
  self:SetAllCellDestroy()
  self.model = {}
  for showIndex, v in ipairs(self.showDataList) do
    local index = showIndex
    self.model[showIndex] = self:GameObjectInstantiateAsync(DecorationBoxCellPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.cell_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = showIndex
      local cell = self.cell_content:AddComponent(UIDecorationChoiceBoxChooseCell, go.name)
      self.cellList[index] = cell
      cell:ReInit(self.showDataList[index], index, self.OnItemClick)
    end)
  end
  self.cell_content:SetAnchoredPositionXY(0, 0)
end

function UIDecorationChoiceBoxView:SetAllCellDestroy()
  self.cell_content:RemoveComponents(UIDecorationChoiceBoxChooseCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIDecorationChoiceBoxView:RefreshTopContent()
  self.data_content:SetAnchoredPositionXY(0, 0)
  local curData = self.showDataList[self.currentSelect]
  if curData.itemTemp.type == GOODS_TYPE.GOODS_TYPE_113 then
    self:RefreshUICommonRes(false)
    local bgPath1 = self:GetViewBg1(curData.decoTemp.quality)
    self.info_content_bg:LoadSprite(bgPath1)
    local bgPath2 = self:GetViewBg2(curData.decoTemp.quality)
    self.info_content_bg2:LoadSprite(bgPath2)
    self.item_img:LoadSprite(curData.decoTemp.icon)
    if curData.decoTemp.type == DecorationType.DecorationType_TittleName or curData.decoTemp.type == DecorationType.DecorationType_Head_Frame then
      self.main_city:SetActive(false)
      self.main_city:EndShow()
      self.item_img:SetActive(true)
      self.chat_bubble:SetActive(false)
      self.item_img:SetLocalScaleXYZ(1.3, 1.3, 1.3)
      self.item_img:SetNativeSize()
    elseif curData.decoTemp.type == DecorationType.DecorationType_Chat_Bubble then
      self.main_city:SetActive(false)
      self.main_city:EndShow()
      self.item_img:SetActive(false)
      self.chat_bubble:SetActive(true)
      self.chat_bubble:ReInit(self:GetChatBubbleData(curData.decoTemp.id))
    elseif curData.decoTemp.type == DecorationType.DecorationType_Main_Effect then
      local mainCitySkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
      self.item_img:SetActive(false)
      self.chat_bubble:SetActive(false)
      self.main_city:StartShow(MainCityRTSize)
      self.main_city:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
      self.main_city:SetData({
        decorationId = curData.decoTemp.id,
        mainCitySkinId = mainCitySkinId
      })
    else
      self.item_img:SetActive(false)
      self.chat_bubble:SetActive(false)
      self.main_city:StartShow(MainCityRTSize)
      self.main_city:SetData({
        decorationId = curData.decoTemp.id
      })
    end
    self.name_text:SetText(curData.itemTemp:GetName())
    local qualityColor = UIUtil.GetColorByQuality(curData.decoTemp.quality)
    self.name_text:SetColor(qualityColor)
    self.point_bg:SetActive(not curData.isCanUse)
    local txtStrKey = "optional_chest_desc01"
    if curData.eternalType == GoodsType113DecorationEternalType.HaveGoods then
      txtStrKey = "building_center_desc23"
    end
    self.point_text:SetLocalText(txtStrKey)
    local template = curData.decoTemp
    local useNum = table.count(template.wearEffect)
    if 0 < useNum then
      self.use_title_content:SetActive(true)
      local index = 1
      local showEffectTxt = {}
      for _, v in pairs(template.wearEffect) do
        local effectId = v.key
        local value = v.value
        local nameStr = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
        local name = Localization:GetString(nameStr)
        local addValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
        local addValueTxt = ""
        if value < 0 then
          addValueTxt = "<color=#f26a67>" .. addValue .. "</color>"
        else
          addValueTxt = "<color=#5FEF87>" .. addValue .. "</color>"
        end
        showEffectTxt[index] = {name = name, addValueTxt = addValueTxt}
        index = index + 1
      end
      for i = 1, #self.use_effect_list do
        if showEffectTxt[i] then
          self.use_effect_list[i].root:SetActive(true)
          self.use_effect_list[i].effect:SetText(showEffectTxt[i].name)
          self.use_effect_list[i].effectVal:SetText(showEffectTxt[i].addValueTxt)
        else
          self.use_effect_list[i].root:SetActive(false)
        end
      end
    else
      self.use_title_content:SetActive(false)
      for i = 1, #self.use_effect_list do
        self.use_effect_list[i].root:SetActive(false)
      end
    end
    local ownNum = table.count(template.ownEffect)
    if 0 < ownNum then
      self.own_title_content:SetActive(true)
      local index = 1
      local showEffectTxt = {}
      for _, v in pairs(template.ownEffect) do
        local effectId = v.key
        local value = v.value
        local nameStr = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
        local name = Localization:GetString(nameStr)
        local addValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
        local addValueTxt = ""
        if value < 0 then
          addValueTxt = "<color=#f26a67>" .. addValue .. "</color>"
        else
          addValueTxt = "<color=#5FEF87>" .. addValue .. "</color>"
        end
        showEffectTxt[index] = {name = name, addValueTxt = addValueTxt}
        index = index + 1
      end
      for i = 1, #self.own_effect_list do
        if showEffectTxt[i] then
          self.own_effect_list[i].root:SetActive(true)
          self.own_effect_list[i].effect:SetText(showEffectTxt[i].name)
          self.own_effect_list[i].effectVal:SetText(showEffectTxt[i].addValueTxt)
        else
          self.own_effect_list[i].root:SetActive(false)
        end
      end
    else
      self.own_title_content:SetActive(false)
      for i = 1, #self.own_effect_list do
        self.own_effect_list[i].root:SetActive(false)
      end
    end
  else
    self.item_img:SetActive(false)
    self.chat_bubble:SetActive(false)
    self.main_city:SetActive(false)
    self.main_city:EndShow()
    local bgPath1 = self:GetViewBg1(curData.itemTemp.quality)
    self.info_content_bg:LoadSprite(bgPath1)
    local bgPath2 = self:GetViewBg2(curData.itemTemp.quality)
    self.info_content_bg2:LoadSprite(bgPath2)
    local param1 = {
      rewardType = RewardType.GOODS,
      itemId = curData.itemId,
      count = curData.itemNum
    }
    self:RefreshUICommonRes(true, param1)
    self.name_text:SetText(curData.itemTemp:GetName())
    local qualityColor = UIUtil.GetColorByQuality(curData.itemTemp.quality)
    self.name_text:SetColor(qualityColor)
    self.point_bg:SetActive(false)
    self.use_title_content:SetActive(false)
    for i = 1, #self.use_effect_list do
      self.use_effect_list[i].root:SetActive(false)
    end
    self.own_title_content:SetActive(false)
    for i = 1, #self.own_effect_list do
      self.own_effect_list[i].root:SetActive(false)
    end
  end
end

function UIDecorationChoiceBoxView:RefreshUICommonRes(state, param)
  self.showUICommonRes = state
  if self.uiCommonResItem then
    if param then
      self.uiCommonResItem:ReInit(param)
    end
    self.uiCommonResItem:SetActive(state)
    return
  end
  if self.uiCommonResItemReq then
    self:GameObjectDestroy(self.uiCommonResItemReq)
    self.uiCommonResItemReq = nil
  end
  self.uiCommonResItemReq = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.info_content_bg_container.transform)
    go.transform:Set_localScale(1.3, 1.3, 1.3)
    go.transform:Set_sizeDelta(150, 150)
    go.name = "uiCommonResItem"
    local cell = self.info_content_bg_container:AddComponent(UICommonResItem, go.name)
    self.uiCommonResItem = cell
    if param then
      self.uiCommonResItem:ReInit(param)
    end
    self.uiCommonResItem:SetAnchoredPositionXY(90, -70)
    self.uiCommonResItem:SetActive(self.showUICommonRes)
  end)
end

function UIDecorationChoiceBoxView:RefreshBottomContent()
end

function UIDecorationChoiceBoxView:GetViewBg1(quality)
  local imgPath = "Assets/Main/TextureEx/DecorationChoiceBox/lrb_zixuanbaoxiang_banzi_lan.png"
  if quality == 5 then
    imgPath = "Assets/Main/TextureEx/DecorationChoiceBox/lrb_zixuanbaoxiang_banzi_cheng.png"
  elseif quality == 4 then
    imgPath = "Assets/Main/TextureEx/DecorationChoiceBox/lrb_zixuanbaoxiang_banzi_zi.png"
  elseif quality == 3 then
    imgPath = "Assets/Main/TextureEx/DecorationChoiceBox/lrb_zixuanbaoxiang_banzi_lan.png"
  end
  return imgPath
end

function UIDecorationChoiceBoxView:GetViewBg2(quality)
  local imgPath = "Assets/Main/Sprites/UI/DecorationChoiceBox/lrb_zixuanbaoxiang_tiao_lan.png"
  if quality == 5 then
    imgPath = "Assets/Main/Sprites/UI/DecorationChoiceBox/lrb_zixuanbaoxiang_tiao_cheng.png"
  elseif quality == 4 then
    imgPath = "Assets/Main/Sprites/UI/DecorationChoiceBox/lrb_zixuanbaoxiang_tiao_zi.png"
  elseif quality == 3 then
    imgPath = "Assets/Main/Sprites/UI/DecorationChoiceBox/lrb_zixuanbaoxiang_tiao_lan.png"
  end
  return imgPath
end

function UIDecorationChoiceBoxView:GetChatBubbleData(decorationId)
  local result = {}
  result.decorationId = decorationId
  result.frame = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  result.bubbleRes, result.msgColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(decorationId, LongMaxValue)
  return result
end

function UIDecorationChoiceBoxView:OnItemClick(index)
  if self.currentSelect == index then
    return
  end
  self.currentSelect = index
  for k, v in pairs(self.cellList) do
    v:RefreshView()
  end
  self:RefreshTopContent()
  self:RefreshBottomContent()
end

function UIDecorationChoiceBoxView:UseItem()
  local curData = self.showDataList[self.currentSelect]
  if curData.isCanUse then
    local itemTemp = curData.itemTemp
    local message = Localization:GetString("optional_box_use_alert9", itemTemp:GetName())
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.UIDecorationChoiceBoxTip .. self.itemId, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = self.itemUuid,
        num = 1,
        para1 = tostring(curData.index)
      })
      self.ctrl:CloseSelf()
    end, function()
    end, nil, nil, false, nil, nil)
  elseif curData.eternalType == GoodsType113DecorationEternalType.HaveGoods then
    UIUtil.ShowTipsId("item_use_alerttips_002")
  else
    UIUtil.ShowTipsId("optional_chest_desc01")
  end
end

return UIDecorationChoiceBoxView
