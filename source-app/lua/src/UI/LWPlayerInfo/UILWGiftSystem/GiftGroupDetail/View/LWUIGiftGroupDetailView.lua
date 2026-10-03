local base = UIBaseView
local LWUIGiftGroupDetailView = BaseClass("LWUIGiftGroupDetailView", base)
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local text_path = "panel/toggleAnonymous/layout/anonymousTipText"
local Localization = CS.GameEntry.Localization
local utf8Tools = require("Common/Tools/utf8")
local closeBtn_path = "curtain"
local giftIconImg_path = "panel/bg/giftIconContent/giftIcon"
local giftNameTxt_path = "panel/bg/giftName"
local addCharmTxt_path = "panel/addCharmBg/addCharm"
local input_path = "panel/InputField"
local sliderGroup_path = "panel/GroupSelector/UISliderGroup"
local sendBtn_path = "panel/btnNormal"
local anonymousToggle_path = "panel/toggleAnonymous"
local qualityRawImg_path = "panel/bg/corner_rawImg"
local limitTxt_path = "panel/InputField/Limit"
local giftStar_path = "panel/bg/giftStar"
local itemBar_path = "ItemBar"
local resourceIcon_path = "panel/btnNormal/Container/resource/resourceIcon"
local resourceNum_path = "panel/btnNormal/Container/resource/resourceIcon/resourceNum"
local priceIcon_path = "panel/PriceArea/PriceIcon"
local priceNum_path = "panel/PriceArea/PriceIcon/PriceNum"
local resourceGo_path = "panel/btnNormal/Container/resource"
local giftNumTxt_path = "panel/bg/GiftNumDetail/giftNum"
local priceArea_path = "panel/PriceArea"
local btnText_path = "panel/btnNormal/Container/txtBtnNormal"
local giftSmallIcon_path = "panel/bg/GiftNumDetail/SmallIcon"
local previewBtn_path = "panel/PreviewBtn"
local hasAnimTip_path = "panel/bg/giftName/hasAnimTip"
local tip_btn_path = "panel/toggleAnonymous/layout/tipBtn"
local addCharmBtn_path = "panel/addCharmBg"
local groupIcons_path = {
  "panel/GroupSelector/GroupIcons/iconcontent1/Icon1",
  "panel/GroupSelector/GroupIcons/iconcontent2/Icon2",
  "panel/GroupSelector/GroupIcons/iconcontent3/Icon3",
  "panel/GroupSelector/GroupIcons/iconcontent4/Icon4",
  "panel/GroupSelector/GroupIcons/iconcontent5/Icon5"
}
local groupTexts_path = {
  "panel/GroupSelector/GroupNums/Num1",
  "panel/GroupSelector/GroupNums/Num2",
  "panel/GroupSelector/GroupNums/Num3",
  "panel/GroupSelector/GroupNums/Num4",
  "panel/GroupSelector/GroupNums/Num5"
}
local groupLines_path = {
  "panel/GroupSelector/UISliderGroup/Slider/Background/GroupLines/Line1",
  "panel/GroupSelector/UISliderGroup/Slider/Background/GroupLines/Line2",
  "panel/GroupSelector/UISliderGroup/Slider/Background/GroupLines/Line3",
  "panel/GroupSelector/UISliderGroup/Slider/Background/GroupLines/Line4"
}
local input_tip_txt_path = "panel/inputTipTxt"
local input_block_path = "panel/InputField/inputBlock"
local gift_icon_show_content_path = "panel/bg/giftIconContent/GiftIconShowContent"
local Min_Select_Count = 1
local Max_Select_Count = 99
local Max_Input_Count = 60

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
  self.input = self:AddComponent(UIInput, input_path)
  self.sliderGroup = self:AddComponent(UIBaseContainer, sliderGroup_path)
  self.anonymousToggle = self:AddComponent(UIToggle, anonymousToggle_path)
  self.qualityRawImg = self:AddComponent(UIRawImage, qualityRawImg_path)
  self.limitTxt = self:AddComponent(UIText, limitTxt_path)
  self.giftStar = self:AddComponent(UIBaseContainer, giftStar_path)
  self.itemBar = self:AddComponent(UIBaseContainer, itemBar_path)
  self.resourceIcon = self:AddComponent(UIImage, resourceIcon_path)
  self.resourceNum = self:AddComponent(UIText, resourceNum_path)
  self.priceIcon = self:AddComponent(UIImage, priceIcon_path)
  self.priceNum = self:AddComponent(UIText, priceNum_path)
  self.resourceGo = self:AddComponent(UIBaseContainer, resourceGo_path)
  self.giftNumTxt = self:AddComponent(UIText, giftNumTxt_path)
  self.priceArea = self:AddComponent(UIBaseContainer, priceArea_path)
  self.btnText = self:AddComponent(UIText, btnText_path)
  self.giftSmallIcon = self:AddComponent(UIImage, giftSmallIcon_path)
  self.previewBtn = self:AddComponent(UIButton, previewBtn_path)
  self.hasAnimTip = self:AddComponent(UITextMeshProUGUIEx, hasAnimTip_path)
  self.addCharmBtn = self:AddComponent(UIButton, addCharmBtn_path)
  self.groupIcons = {
    self:AddComponent(UIImage, groupIcons_path[1]),
    self:AddComponent(UIImage, groupIcons_path[2]),
    self:AddComponent(UIImage, groupIcons_path[3]),
    self:AddComponent(UIImage, groupIcons_path[4]),
    self:AddComponent(UIImage, groupIcons_path[5])
  }
  self.groupTexts = {
    self:AddComponent(UIText, groupTexts_path[1]),
    self:AddComponent(UIText, groupTexts_path[2]),
    self:AddComponent(UIText, groupTexts_path[3]),
    self:AddComponent(UIText, groupTexts_path[4]),
    self:AddComponent(UIText, groupTexts_path[5])
  }
  self.groupLines = {
    self:AddComponent(UIBaseContainer, groupLines_path[1]),
    self:AddComponent(UIBaseContainer, groupLines_path[2]),
    self:AddComponent(UIBaseContainer, groupLines_path[3]),
    self:AddComponent(UIBaseContainer, groupLines_path[4])
  }
  self.item_bar = self:AddComponent(UITopItem, itemBar_path)
  self.itemBarList = {
    self.item_bar
  }
  self.itemBar:SetActive(CommonUtil.IsGrayServer(3, 36))
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.addCharmBtn:SetOnClick(function()
    UIUtil.ShowTipsId("gift_score_tips_1")
  end)
  self.sendBtn = self:AddComponent(UIButton, sendBtn_path)
  self.sendBtn:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  self.anonymousTipText = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.sliderGroupComponent = self:AddComponent(UISliderGroup, sliderGroup_path)
  self.sliderGroupComponent:SetOnNumChangedHandler(function(num)
    self.num = num
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
    self.willSendNum = toInt(goods.group_id[self.num + 1])
    self:OnNumChange()
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
  ChatInterface.SetEmojiTextProperty(self.inputText, true)
  self.tipBtn = self:AddComponent(UIButton, tip_btn_path)
  self.tipBtn:SetOnClick(function()
    local tipStr = Localization:GetString("gift_sent_wc_tips")
    UIUtil.ShowBubbleTips(tipStr, self.tipBtn.transform.position, 0, 20, 0, nil, nil, {reversal = true})
  end)
  self.inputPlaceHolder = self.input.unity_tmpinput.placeholder
  self.previewBtn:SetOnClick(function()
    self:OnPreviewBtnClick()
  end)
  self.input_tip_txt = self:AddComponent(UITextMeshProUGUIEx, input_tip_txt_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.anonymousTipText:SetLocalText("gift_sent_anon_title")
  local size = self.anonymousTipText.unity_tmpro:GetPreferredValues()
  self.anonymousTipText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, size.x)
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
  self.giftSmallIcon = nil
  self.previewBtn = nil
  self.hasAnimTip = nil
  self.groupIcons = nil
  self.groupTexts = nil
  self.groupLines = nil
  self.sliderGroupComponent = nil
  self.input_tip_txt = nil
  self.input_block = nil
  self.gift_icon_show_content = nil
end

local function DataDefine(self)
  local data = self:GetUserData()
  self.template = data.template
  self.targetUid = data.targetUid
  self.targetServerId = data.targetServerId
  self.viewType = data.viewType
  self.willSendNum = 0
  self.fromType = data.fromType
  self.playerWriteTxt = nil
end

local function DataDestroy(self)
  self.willSendNum = 0
  self.playerWriteTxt = nil
end

function LWUIGiftGroupDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:AddUIListener(EventId.BuyCommonShopGoods_Gift, self.DirectBuy)
end

function LWUIGiftGroupDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:RemoveUIListener(EventId.BuyCommonShopGoods_Gift, self.DirectBuy)
  base.OnRemoveListener(self)
end

function LWUIGiftGroupDetailView:RefreshView()
  self.num = 0
  self.willSendNum = 0
  self:InitBaseUI()
  self:InitGroupInfo()
  self:InitShopInfo()
  self:RefreshCostItem()
  self:OnNumChange()
end

function LWUIGiftGroupDetailView:InitBaseUI()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  self.giftNum = DataCenter.GiftSystemManager:GetGiftNum(self.template.id)
  self.giftNumTxt:SetText(self.giftNum)
  self.limitTxt:SetText(string.format("%d/%d", 0, Max_Input_Count))
  self.qualityRawImg:LoadSpriteAsync(GiftSystemConst.GetSendGiftQualityIcon(self.template.color))
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  self.giftSmallIcon:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
    if self.giftSmallIcon then
      self.giftSmallIcon:SetNativeSize()
    end
  end)
  self.giftSmallIcon:SetLocalScaleXYZ(minScale, minScale, minScale)
  if self.viewType == "moment" then
    self.btnText:SetLocalText("moment_follow_special_btn")
  else
    self.btnText:SetLocalText("gift_send_btn")
  end
  self.anonymousToggle:SetIsOn(false)
  self.input:SetText("")
  self.input:SetCharacterLimit(0)
  self.item_bar:SetData(GiftSystemConst.ShopItemId, nil, function()
  end)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(GiftSystemConst.ShopItemId)
  self.resourceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
  self.priceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
end

function LWUIGiftGroupDetailView:InitGroupInfo()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  for i, v in ipairs(goods.group_id) do
    local num = v
    local icon = goods.group_icon[i]
    self.groupIcons[i]:LoadSprite(GiftSystemConst.GetIconPath(icon))
    self.groupIcons[i]:SetLocalScaleXYZ(1, 1, 1)
    self.groupIcons[i]:SetNativeSize()
    self.groupTexts[i]:SetText(num)
    if self.giftNum < tonumber(num) then
      self.groupTexts[i]:SetColorHex("#F97077")
    else
      self.groupTexts[i]:SetColorHex("#FFFFFF")
    end
  end
end

function LWUIGiftGroupDetailView:InitShopInfo()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
  for _, v in ipairs(showDataList) do
    if v.itemId == self.template.id then
      self.shopItem = v
      break
    end
  end
  if self.shopItem then
    self.sliderGroupComponent:SetMaxNum(Max_Select_Count)
    self.priceArea:SetActive(true)
    self.priceNum:SetText("\195\151" .. tostring(self.shopItem.configData.currency_num))
  else
    self.sliderGroupComponent:SetMaxNum(math.max(#goods.group_id - 1, Min_Select_Count))
    self.priceArea:SetActive(false)
  end
  self.sliderGroupComponent:SetMinNum(0)
  self.sliderGroupComponent:SetCurNum(self.num)
end

function LWUIGiftGroupDetailView:RefreshCostItem()
  if self.shopItem == nil then
    self.resourceGo:SetActive(false)
    return
  end
  local currencyNum = self.shopItem.configData.currency_num
  self.costNum = 0
  local color = Color.white
  local resource = DataCenter.ItemData:GetItemById(GiftSystemConst.ShopItemId)
  self.hasResourceNum = resource and resource.count or 0
  if self.giftNum < self.willSendNum then
    local diff = self.willSendNum - self.giftNum
    self.costNum = diff * currencyNum
    if self.costNum > self.hasResourceNum then
      color = Color.red
    end
  end
  self.resourceGo:SetActive(self.costNum > 0)
  self.resourceNum:SetText("\195\151" .. self.costNum)
  self.resourceNum:SetColor(color)
end

function LWUIGiftGroupDetailView:RefreshGoods()
  for i = 1, #self.itemBarList do
    self.itemBarList[i]:RefreshData()
  end
  self:RefreshCostItem()
end

function LWUIGiftGroupDetailView:OnSendBtnClick()
  if self.shopItem and self.costNum and self.hasResourceNum and self.costNum > self.hasResourceNum then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, nil, GiftSystemConst.ShopGroupId, GiftSystemConst.ShopItemId)
    return
  end
  self.giftNum = DataCenter.GiftSystemManager:GetGiftNum(self.template.id)
  if self.willSendNum > self.giftNum then
    if self.shopItem == nil then
      self:DirectBuy()
      return
    end
    SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, self.shopItem.id, nil, self.willSendNum - self.giftNum)
    return
  end
  self:DirectBuy()
end

function LWUIGiftGroupDetailView:DirectBuy()
  local isOn = self.anonymousToggle:GetIsOn()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  if isOn and goods.ep_gift ~= 1 and self.willSendNum < goods.num_send_country then
    isOn = false
  end
  local sendMsg = ""
  if self.playerWriteTxt then
    sendMsg = self.playerWriteTxt
  end
  if self.viewType == "moment" then
    DataCenter.GiftSystemManager:SendGiftByFollow(self.template.id, self.targetUid, isOn, sendMsg, self.willSendNum)
    self.ctrl:CloseSelf()
    return
  elseif self.fromType == GiftSystemConst.fromType.LLGroupInvitation then
    local info = {
      template = self.template,
      context = sendMsg,
      num = self.willSendNum
    }
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftOperation_v2)
    EventManager:GetInstance():Broadcast(EventId.LandlordServerInviteGiftInfo, info)
    return
  end
  DataCenter.GiftSystemManager:SendGift(self.template.id, self.targetUid, isOn, sendMsg, self.willSendNum, self.fromType)
  self.ctrl:CloseSelf()
end

function LWUIGiftGroupDetailView:TextValueChange(value)
  local count = utf8Tools.len(value)
  if count > Max_Input_Count then
    count = Max_Input_Count
    value = utf8Tools.sub(value, 1, Max_Input_Count + 1)
    self.input.unity_tmpinput:SetTextWithoutNotify(value)
  end
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, count), Max_Input_Count))
  self.playerWriteTxt = value
end

function LWUIGiftGroupDetailView:OnEndEdit(value)
  local count = utf8Tools.len(value)
  if count > Max_Input_Count then
    count = Max_Input_Count
    value = utf8Tools.sub(value, 1, Max_Input_Count + 1)
  end
  self.input.unity_tmpinput:SetTextWithoutNotify(value)
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, count), Max_Input_Count))
  self.playerWriteTxt = value
end

function LWUIGiftGroupDetailView:SetMaxNum()
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

function LWUIGiftGroupDetailView:OnNumChange()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  self.sliderGroupComponent:SetTipText(self.willSendNum)
  self.previewBtn:SetActive(false)
  self.addCharmTxt:SetText("+" .. tonumber(goods.add_exp) * self.willSendNum)
  self.anonymousToggle:SetActive(goods.ep_gift == 1 or self.willSendNum >= goods.num_send_country)
  local pic = goods.group_pic[self.num + 1]
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  if #goods.show_fx > 0 then
    self.giftIconImg:SetActive(false)
    self.gift_icon_show_content:SetActive(true)
    self.gift_icon_show_content:SetShowData(goods.id, tonumber(goods.group_id[self.num + 1]))
    self.gift_icon_show_content:SetLocalScaleXYZ(maxScale, maxScale, maxScale)
  else
    self.giftIconImg:SetActive(true)
    self.gift_icon_show_content:SetActive(false)
    self.giftIconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(pic), function()
      if self.giftIconImg then
        self.giftIconImg:SetNativeSize()
      end
    end)
    self.giftIconImg:SetLocalScaleXYZ(maxScale, maxScale, maxScale)
  end
  local name = Localization:GetString(self.template.name)
  self.anonymousTipText:SetLocalText("gift_sent_anon_title")
  local size = self.anonymousTipText.unity_tmpro:GetPreferredValues()
  self.anonymousTipText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, size.x)
  self.giftNameTxt:SetText(name)
  self.hasAnimTip:SetActive(true)
  local tipStr = ""
  local willSendNum = self.willSendNum
  local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, willSendNum)
  if curCanEditor == 1 and not string.IsNullOrEmpty(goods.group_effect[self.num + 1]) then
    tipStr = Localization:GetString("gift_sent_leave_message_and_animation_tips")
  elseif curCanEditor == 1 then
    tipStr = Localization:GetString("gift_sent_leave_message_tips")
  elseif not string.IsNullOrEmpty(goods.group_effect[self.num + 1]) then
    tipStr = Localization:GetString("gift_sent_animation_tips")
  end
  self.hasAnimTip:SetText(tipStr)
  for i = 1, #self.groupLines do
    self.groupLines[i]:SetActive(i <= self.num)
  end
  self:RefreshCostItem()
  self:OnInputCompStateChange()
end

function LWUIGiftGroupDetailView:OnInputClick()
  if self.willSendNum and self.template then
    local willSendNum = self.willSendNum
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
    local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, willSendNum)
    if curCanEditor == 0 then
      UIUtil.ShowTipsId("gift_detail_tips_2")
    end
  end
end

function LWUIGiftGroupDetailView:OnInputCompStateChange()
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

function LWUIGiftGroupDetailView:OnPreviewBtnClick()
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  local param = {}
  if next(goods.group_id) then
    param.configEffectId = goods.group_effect[self.num + 1]
    param.configSoundId = goods.group_sound[self.num + 1]
  elseif goods.ep_gift == 1 then
    param.configEffectId = goods.effect_id
    param.configSoundId = goods.sound_id
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.GiftEffectPreview, {anim = true}, param)
end

LWUIGiftGroupDetailView.OnCreate = OnCreate
LWUIGiftGroupDetailView.OnDestroy = OnDestroy
LWUIGiftGroupDetailView.OnEnable = OnEnable
LWUIGiftGroupDetailView.OnDisable = OnDisable
LWUIGiftGroupDetailView.ComponentDefine = ComponentDefine
LWUIGiftGroupDetailView.ComponentDestroy = ComponentDestroy
LWUIGiftGroupDetailView.DataDefine = DataDefine
LWUIGiftGroupDetailView.DataDestroy = DataDestroy
return LWUIGiftGroupDetailView
