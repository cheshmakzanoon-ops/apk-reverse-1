local base = UIBaseView
local LWUIGiftDetailView = BaseClass("LWUIGiftDetailView", base)
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local Localization = CS.GameEntry.Localization
local utf8Tools = require("Common/Tools/utf8")
local closeBtn_path = "curtain"
local giftIconImg_path = "panel/bg/giftIconContent/giftIcon"
local giftNameTxt_path = "panel/bg/giftName"
local addCharmTxt_path = "panel/addCharmBg/addCharm"
local addCharmBtn_path = "panel/addCharmBg"
local input_path = "panel/InputField"
local sliderGroup_path = "panel/UISliderGroup"
local sendBtn_path = "panel/btnNormal"
local anonymousToggle_path = "panel/toggleAnonymous"
local maxBtn_path = "panel/UISliderGroup/maxBtn"
local qualityRawImg_path = "panel/bg/corner_rawImg"
local limitTxt_path = "panel/InputField/Limit"
local giftStar_path = "panel/bg/giftStar"
local itemBar_path = "ItemBar"
local resourceIcon_path = "panel/btnNormal/Container/resource/resourceIcon"
local resourceNum_path = "panel/btnNormal/Container/resource/resourceIcon/resourceNum"
local priceIcon_path = "panel/PriceArea/PriceIcon"
local priceNum_path = "panel/PriceArea/PriceNum"
local resourceGo_path = "panel/btnNormal/Container/resource"
local giftNumTxt_path = "panel/bg/giftIconContent/giftNum"
local priceArea_path = "panel/PriceArea"
local btnText_path = "panel/btnNormal/Container/txtBtnNormal"
local previewBtn_path = "panel/PreviewBtn"
local sendGiftTips_path = "panel/toggleAnonymous/tips"
local hasAnimTip_path = "panel/bg/giftName/hasAnimTip"
local input_tip_txt_path = "panel/inputTipTxt"
local input_block_path = "panel/InputField/inputBlock"
local gift_icon_show_content_path = "panel/bg/giftIconContent/GiftIconShowContent"
local message_layout_path = "panel/messageLayout"
local message_text_path = "panel/messageLayout/messageText"
local image_content_path = "panel/messageLayout/messageText/ImageContent"
local extra_image_path = "panel/messageLayout/messageText/ImageContent/extraImage"
local panel_path = "panel"
local price_path = "panel/PriceArea/Price"
local bg_path = "panel/bg"
local small_icon_path = "panel/GiftNumDetail/SmallIcon"
local gift_num_path = "panel/GiftNumDetail/giftNum"
local text_path = "panel/toggleAnonymous/layout/anonymousTipText"
local tip_btn_path = "panel/toggleAnonymous/layout/tipBtn"
local Min_Select_Count = 1
local Max_Select_Count = 99
local Max_Input_Count = 60
local bgHight = 788
local messageDiffH = 20

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.giftIconImg = self:AddComponent(UIImage, giftIconImg_path)
  self.giftNameTxt = self:AddComponent(UIText, giftNameTxt_path)
  self.addCharmTxt = self:AddComponent(UIText, addCharmTxt_path)
  self.addCharmBtn = self:AddComponent(UIButton, addCharmBtn_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.sliderGroup = self:AddComponent(UIBaseContainer, sliderGroup_path)
  self.anonymousToggle = self:AddComponent(UIToggle, anonymousToggle_path)
  self.maxBtn = self:AddComponent(UIButton, maxBtn_path)
  self.qualityRawImg = self:AddComponent(UIRawImage, qualityRawImg_path)
  self.limitTxt = self:AddComponent(UIText, limitTxt_path)
  self.giftStar = self:AddComponent(UIBaseContainer, giftStar_path)
  self.itemBar = self:AddComponent(UIBaseContainer, itemBar_path)
  self.resourceIcon = self:AddComponent(UIImage, resourceIcon_path)
  self.resourceNum = self:AddComponent(UIText, resourceNum_path)
  self.priceIcon = self:AddComponent(UIImage, priceIcon_path)
  self.priceNum = self:AddComponent(UIText, priceNum_path)
  self.price = self:AddComponent(UIText, price_path)
  self.resourceGo = self:AddComponent(UIBaseContainer, resourceGo_path)
  self.giftNumTxt = self:AddComponent(UIText, giftNumTxt_path)
  self.priceArea = self:AddComponent(UIBaseContainer, priceArea_path)
  self.btnText = self:AddComponent(UIText, btnText_path)
  self.previewBtn = self:AddComponent(UIButton, previewBtn_path)
  self.sendGiftTips = self:AddComponent(UIText, sendGiftTips_path)
  self.hasAnimTip = self:AddComponent(UITextMeshProUGUIEx, hasAnimTip_path)
  self.item_bar = self:AddComponent(UITopItem, itemBar_path)
  self.smallGiftIcon = self:AddComponent(UIImage, small_icon_path)
  self.smallGiftNumber = self:AddComponent(UITextMeshProUGUIEx, gift_num_path)
  self.bgIcon = self:AddComponent(UIImage, bg_path)
  self.tipBtn = self:AddComponent(UIButton, tip_btn_path)
  self.anonymousTipText = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.itemBarList = {
    self.item_bar
  }
  self.maxBtn:SetOnClick(function()
    self:SetMaxNum()
  end)
  self.tipBtn:SetOnClick(function()
    local tipStr = Localization:GetString("gift_sent_wc_tips")
    UIUtil.ShowBubbleTips(tipStr, self.tipBtn.transform.position, 0, 20, 0, nil, nil, {reversal = true})
  end)
  self.addCharmBtn:SetOnClick(function()
    UIUtil.ShowTipsId("gift_score_tips_1")
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.sendBtn = self:AddComponent(UIButton, sendBtn_path)
  self.sendBtn:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  self.sliderGroupComponent = self:AddComponent(UISliderGroup, sliderGroup_path)
  self.sliderGroupComponent:SetOnNumChangedHandler(function(num)
    self.num = num
    self.sliderGroupComponent:SetTipText(self.num)
    self:RefreshCostItem()
  end)
  self.input:SetOnValueChange(function(val)
    self:TextValueChange(val)
  end)
  self.input:SetOnEndEdit(function(val)
    self:OnEndEdit(val)
  end)
  self.input_block = self:AddComponent(UIButton, input_block_path)
  self.input_block:SetOnClick(function()
    self:OnInputClick()
  end)
  self.inputText = self:AddComponent(UITextMeshProUGUIEx, "panel/InputField/Text Area/Text")
  ChatInterface.SetEmojiTextProperty(self.inputText)
  self.inputPlaceHolder = self.input.unity_tmpinput.placeholder
  self.previewBtn:SetOnClick(function()
    self:OnPreviewBtnClick()
  end)
  self.input_tip_txt = self:AddComponent(UITextMeshProUGUIEx, input_tip_txt_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.message_layout = self:AddComponent(UIBaseContainer, message_layout_path)
  self.message_text = self:AddComponent(UITextMeshProUGUIEx, message_text_path)
  self.image_content = self:AddComponent(UIBaseContainer, image_content_path)
  self.extra_image = self:AddComponent(UIImage, extra_image_path)
  self.panel = self:AddComponent(UIBaseContainer, panel_path)
  self.message_text:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.giftIconImg = nil
  self.giftNameTxt = nil
  self.addCharmTxt = nil
  self.input = nil
  self.sliderGroup = nil
  self.sendBtn = nil
  self.anonymousToggle = nil
  self.maxBtn = nil
  self.qualityRawImg = nil
  self.limitTxt = nil
  self.giftStar = nil
  self.itemBar = nil
  self.resourceIcon = nil
  self.resourceNum = nil
  self.priceIcon = nil
  self.priceNum = nil
  self.resourceGo = nil
  self.giftNumTxt = nil
  self.priceArea = nil
  self.btnText = nil
  self.previewBtn = nil
  self.sendGiftTips = nil
  self.hasAnimTip = nil
  self.sliderGroupComponent = nil
  self.input_tip_txt = nil
  self.input_block = nil
  self.gift_icon_show_content = nil
  self.message_layout = nil
  self.message_text = nil
  self.image_content = nil
  self.extra_image = nil
  self.panel = nil
  self.price = nil
end

local function DataDefine(self)
  local data = self:GetUserData()
  self.template = data.template
  self.targetUid = data.targetUid
  self.targetServerId = data.targetServerId
  self.viewType = data.viewType
  self.fromType = data.fromType
  self.playerWriteTxt = nil
end

local function DataDestroy(self)
  self.playerWriteTxt = nil
end

function LWUIGiftDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshGoods)
  self:AddUIListener(EventId.BuyCommonShopGoods_Gift, self.DirectBuy)
end

function LWUIGiftDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshGoods)
  self:RemoveUIListener(EventId.BuyCommonShopGoods_Gift, self.DirectBuy)
  base.OnRemoveListener(self)
end

function LWUIGiftDetailView:RefreshView(isStayTxtInput)
  if self.num == nil then
    self.num = Min_Select_Count
  end
  if not isStayTxtInput then
    self.num = Min_Select_Count
  end
  self.price:SetLocalText("129009")
  local preferredValues = self.price.unity_tmpro:GetPreferredValues()
  self.price.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
  self.giftNumTxt:SetText(self.giftNum)
  self.giftNum = DataCenter.GiftSystemManager:GetGiftNum(self.template.id)
  self.giftNumTxt:SetText(self.giftNum > 0 and "\195\151" .. self.giftNum or "")
  if not isStayTxtInput then
    self.input:SetText("")
    self.limitTxt:SetText(string.format("%d/%d", 0, Max_Input_Count))
  end
  local quality = self.template.color
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  self.qualityRawImg:LoadSpriteAsync(GiftSystemConst.GetSendGiftQualityIcon(quality))
  self.smallGiftIcon:LoadSpriteAsync(GiftSystemConst.GetIconPathNew(goods.icon_big))
  self.smallGiftNumber:SetText(self.giftNum)
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  if 0 < #goods.show_fx then
    self.giftIconImg:SetActive(false)
    self.gift_icon_show_content:SetActive(true)
    self.gift_icon_show_content:SetShowData(goods.id, 1)
    self.gift_icon_show_content:SetLocalScaleXYZ(maxScale, maxScale, maxScale)
  else
    self.giftIconImg:SetActive(true)
    self.gift_icon_show_content:SetActive(false)
    self.giftIconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
      if self.giftIconImg then
        self.giftIconImg:SetNativeSize()
      end
    end)
    self.giftIconImg:SetLocalScaleXYZ(maxScale, maxScale, maxScale)
  end
  local name = Localization:GetString(self.template.name)
  if goods.ep_gift == 1 then
    self.sendGiftTips:SetLocalText("gift_sent_wc_tips")
    self.giftNameTxt:SetText(name)
  else
    self.sendGiftTips:SetLocalText("gift_sent_anon_des")
    self.giftNameTxt:SetText(name)
  end
  self.hasAnimTip:SetActive(true)
  local tipStr = ""
  local willSendNum = self.willSendNum
  local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, willSendNum)
  if curCanEditor == 1 and goods.ep_gift == 1 then
    tipStr = Localization:GetString("gift_sent_leave_message_and_animation_tips")
  elseif curCanEditor == 1 then
    tipStr = Localization:GetString("gift_sent_leave_message_tips")
  elseif goods.ep_gift == 1 then
    tipStr = Localization:GetString("gift_sent_animation_tips")
  end
  self.hasAnimTip:SetText(tipStr)
  self.addCharmTxt:SetText("+" .. goods.add_exp)
  if not isStayTxtInput then
    self.anonymousToggle:SetIsOn(false)
  end
  self.anonymousToggle:SetActive(goods.ep_gift == 1)
  self.input:SetCharacterLimit(0)
  self.item_bar:SetData(GiftSystemConst.ShopItemId, nil, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, nil, GiftSystemConst.ShopGroupId, GiftSystemConst.ShopItemId)
  end)
  if self.viewType == "moment" then
    self.btnText:SetLocalText("moment_follow_special_btn")
  else
    self.btnText:SetLocalText("gift_send_btn")
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(GiftSystemConst.ShopItemId)
  self.resourceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
  local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
  for _, v in ipairs(showDataList) do
    if v.itemId == self.template.id then
      self.shopItem = v
      break
    end
  end
  self.priceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
  if self.shopItem then
    self.sliderGroupComponent:SetMaxNum(Max_Select_Count)
    self.priceArea:SetActive(true)
    self.priceNum:SetText("\195\151" .. tostring(self.shopItem.configData.currency_num))
  else
    self.sliderGroupComponent:SetMaxNum(math.max(self.giftNum, Min_Select_Count))
    self.priceArea:SetActive(false)
  end
  self.sliderGroupComponent:SetMinNum(Min_Select_Count)
  self.sliderGroupComponent:SetCurNum(self.num)
  self.previewBtn:SetActive(false)
  self:RefreshCostItem()
  self:OnInputCompStateChange()
  local messageContentH = 0
  local isSettingOpen = LuaEntry.DataConfig:CheckSwitch("gift_coupon")
  if goods and #goods.gift_coupon == 2 and isSettingOpen then
    self.message_layout:SetActive(true)
    local goodsId = goods.gift_coupon[1]
    local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
    local iconPath = string.format(LoadPath.ItemPath, goodsTemp.icon)
    self.extra_image:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.extra_image then
        self.extra_image:SetNativeSize()
        local contentX = 40
        local iconX, iconY = self.extra_image:GetSizeDeltaXY()
        local iconScale = contentX / iconX
        self.extra_image:SetLocalScaleXYZ(iconScale, iconScale, iconScale)
      end
    end)
    local msg1 = Localization:GetString("gift_coupon_limit1")
    local msg2 = "\195\151" .. goods.gift_coupon[2]
    local txt2WordCount = string.word_count(msg2)
    local lineContentW, lineContentH = self.image_content:GetSizeDeltaXY()
    local spaceNum = 0
    local oneSpaceW = 5.8335
    local oneSpaceW2 = 5
    if 0 < lineContentW then
      if lineContentW > oneSpaceW * 2 then
        spaceNum = 2 + math.ceil((lineContentW - oneSpaceW * 2) / oneSpaceW2)
      else
        spaceNum = math.ceil(lineContentW / oneSpaceW)
      end
    end
    local spaceStr = ""
    if 2 < spaceNum then
      spaceStr = string.rep("\194\160", spaceNum - 2)
      spaceStr = " " .. spaceStr .. " "
    else
      spaceStr = " " .. "\194\160"
    end
    self.message_text:SetText(msg1 .. "<link=" .. goodsId .. ">" .. "<u>" .. spaceStr .. msg2 .. "</u></link>")
    self.message_text.unity_tmpro:ForceMeshUpdate()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.message_layout.transform)
    local txtSizeX = self.message_text:GetSizeDelta().x
    local txtPrefabSize = self.message_text.unity_tmpro:GetPreferredValues(txtSizeX, 0)
    local txtPrefabH = txtPrefabSize.y
    messageContentH = txtPrefabH + messageDiffH
    self.message_text:SetSizeDeltaXY(txtSizeX, txtPrefabH)
    self.message_text.unity_tmpro:ForceMeshUpdate()
    local textInfo = self.message_text.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    if textInfo.characterCount >= spaceNum + txt2WordCount then
      local charInfo1 = textInfo.characterInfo[textInfo.characterCount - spaceNum - txt2WordCount]
      local charInfo2 = textInfo.characterInfo[textInfo.characterCount - 1 - txt2WordCount]
      local position1 = charInfo1.bottomLeft
      local position2 = charInfo2.bottomRight
      self.image_content:SetLocalPosition((position1 + position2) / 2, true)
      local lineH = textInfo.lineInfo[lineCount - 1].lineHeight
      local aPosX = self.image_content:GetAnchoredPositionX()
      local aPosY = self.image_content:GetAnchoredPositionY()
      aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
      self.image_content:SetAnchoredPositionXY(aPosX, aPosY + lineH / 4, true)
    end
    self.anonymousTipText:SetLocalText("gift_sent_anon_title")
    local size = self.anonymousTipText.unity_tmpro:GetPreferredValues()
    self.anonymousTipText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, size.x)
  else
    self.message_layout:SetActive(false)
  end
  self.bgIcon:SetSizeDeltaY(bgHight + messageContentH)
end

function LWUIGiftDetailView:OnPointerClick(clickPos)
  local linkId = self.message_text:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local goodsId = tonumber(linkId) or 0
  if 0 < goodsId then
    local des_txt = DataCenter.ItemTemplateManager:GetDes(goodsId)
    UIUtil.ShowBubbleTips(des_txt, self.extra_image.transform.position, 0, -20, 0)
  end
end

function LWUIGiftDetailView:OnInputClick()
  if self.template then
    local willSendNum = self.willSendNum
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
    local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, willSendNum)
    if curCanEditor == 0 then
      UIUtil.ShowTipsId("gift_detail_tips_2")
    end
  end
end

function LWUIGiftDetailView:OnInputCompStateChange()
  local willSendNum = self.willSendNum
  local groupIndex = 1
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, willSendNum)
  if curCanEditor == 1 then
    self.input_tip_txt:SetLocalText("gift_sent_textbox_default")
    self.input:SetInteractable(true)
    self.input_block:SetActive(false)
    if not string.IsNullOrEmpty(self.playerWriteTxt) then
      self.input:SetText(self.playerWriteTxt)
    else
      self.input:SetLocalText(defaultKey)
      self.playerWriteTxt = nil
      self.input:ForceAdjustRectTransformRelativeToViewport()
    end
  else
    self.input_tip_txt:SetLocalText("gift_sent_textbox_default_2")
    self.input:SetInteractable(false)
    self.input_block:SetActive(true)
    self.input:SetLocalText(defaultKey)
    self.playerWriteTxt = nil
  end
  self.limitTxt:SetActive(curCanEditor == 1)
end

function LWUIGiftDetailView:RefreshCostItem()
  if self.shopItem == nil then
    self.resourceGo:SetActive(false)
    return
  end
  local currencyNum = self.shopItem.configData.currency_num
  self.costNum = 0
  local color = Color.white
  local resource = DataCenter.ItemData:GetItemById(GiftSystemConst.ShopItemId)
  self.hasResourceNum = resource and resource.count or 0
  if self.giftNum < self.num then
    local diff = self.num - self.giftNum
    self.costNum = diff * currencyNum
    if self.costNum > self.hasResourceNum then
      color = Color.red
    end
  end
  self.resourceGo:SetActive(self.costNum > 0)
  self.resourceNum:SetText("\195\151" .. self.costNum)
  self.resourceNum:SetColor(color)
end

function LWUIGiftDetailView:RefreshGoods()
  self:RefreshView(true)
end

function LWUIGiftDetailView:OnSendBtnClick()
  if self.shopItem and self.costNum and self.hasResourceNum and self.costNum > self.hasResourceNum then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, nil, GiftSystemConst.ShopGroupId, GiftSystemConst.ShopItemId)
    return
  end
  self.giftNum = DataCenter.GiftSystemManager:GetGiftNum(self.template.id)
  if self.num > self.giftNum then
    if self.shopItem == nil then
      self:DirectBuy()
      return
    end
    SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, self.shopItem.id, nil, self.num - self.giftNum)
    return
  end
  self:DirectBuy()
end

function LWUIGiftDetailView:DirectBuy()
  local sendMsg = ""
  if self.playerWriteTxt then
    sendMsg = self.playerWriteTxt
  end
  if self.viewType == "moment" then
    DataCenter.GiftSystemManager:SendGiftByFollow(self.template.id, self.targetUid, self.anonymousToggle:GetIsOn(), sendMsg, self.num)
    self.ctrl:CloseSelf()
    return
  elseif self.fromType == GiftSystemConst.fromType.LLGroupInvitation then
    local info = {
      template = self.template,
      context = sendMsg,
      num = self.num
    }
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftOperation_v2)
    EventManager:GetInstance():Broadcast(EventId.LandlordServerInviteGiftInfo, info)
    return
  end
  DataCenter.GiftSystemManager:SendGift(self.template.id, self.targetUid, self.anonymousToggle:GetIsOn(), sendMsg, self.num)
  self.ctrl:CloseSelf()
end

function LWUIGiftDetailView:TextValueChange(value)
  local count = utf8Tools.len(value)
  if count > Max_Input_Count then
    count = Max_Input_Count
    value = utf8Tools.sub(value, 1, Max_Input_Count + 1)
    self.input.unity_tmpinput:SetTextWithoutNotify(value)
  end
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, count), Max_Input_Count))
  self.playerWriteTxt = value
end

function LWUIGiftDetailView:OnEndEdit(value)
  local count = utf8Tools.len(value)
  if count > Max_Input_Count then
    count = Max_Input_Count
    value = utf8Tools.sub(value, 1, Max_Input_Count + 1)
  end
  self.input.unity_tmpinput:SetTextWithoutNotify(value)
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, count), Max_Input_Count))
  self.playerWriteTxt = value
end

function LWUIGiftDetailView:SetMaxNum()
  if self.shopItem == nil or self.giftNum > 0 then
    self.sliderGroupComponent:SetInputText(math.min(Max_Select_Count, math.max(Min_Select_Count, self.giftNum)))
    return
  end
  local resource = DataCenter.ItemData:GetItemById(GiftSystemConst.ShopItemId)
  local resourceNum = resource and resource.count or 0
  if 0 < resourceNum then
    local currencyNum = self.shopItem.configData.currency_num
    local num = math.floor(resourceNum / currencyNum)
    self.sliderGroupComponent:SetInputText(math.max(Min_Select_Count, num))
    return
  end
  self.sliderGroupComponent:SetInputText(Max_Select_Count)
end

function LWUIGiftDetailView:OnPreviewBtnClick()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  local param = {}
  if goods.ep_gift == 1 then
    param.configEffectId = goods.effect_id
    param.configSoundId = goods.sound_id
    UIManager:GetInstance():OpenWindow(UIWindowNames.GiftEffectPreview, {anim = true}, param)
  end
end

LWUIGiftDetailView.OnCreate = OnCreate
LWUIGiftDetailView.OnDestroy = OnDestroy
LWUIGiftDetailView.OnEnable = OnEnable
LWUIGiftDetailView.OnDisable = OnDisable
LWUIGiftDetailView.ComponentDefine = ComponentDefine
LWUIGiftDetailView.ComponentDestroy = ComponentDestroy
LWUIGiftDetailView.DataDefine = DataDefine
LWUIGiftDetailView.DataDestroy = DataDestroy
return LWUIGiftDetailView
