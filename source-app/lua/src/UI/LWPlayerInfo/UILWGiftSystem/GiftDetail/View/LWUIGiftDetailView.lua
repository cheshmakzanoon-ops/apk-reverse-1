local base = UIBaseView
local LWUIGiftDetailView = BaseClass("LWUIGiftDetailView", base)
local closeBtn_path = "curtain"
local giftIconImg_path = "panel/bg/giftIcon"
local giftNameTxt_path = "panel/bg/giftName"
local addCharmTxt_path = "panel/addCharmBg/addCharm"
local input_path = "panel/InputField"
local sliderGroup_path = "panel/UISliderGroup"
local sendBtn_path = "panel/btnNormal"
local anonymousToggle_path = "panel/toggleAnonymous"
local maxBtn_path = "panel/UISliderGroup/maxBtn"
local qualityRawImg_path = "panel/bg/corner_rawImg"
local limitTxt_path = "panel/InputField/Limit"
local giftStar_path = "panel/bg/giftStar"
local previewBtn_path = "panel/PreviewBtn"
local btnText_path = "panel/btnNormal/txtBtnNormal"
local Min_Select_Count = 1
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
  self.maxBtn = self:AddComponent(UIButton, maxBtn_path)
  self.qualityRawImg = self:AddComponent(UIRawImage, qualityRawImg_path)
  self.limitTxt = self:AddComponent(UIText, limitTxt_path)
  self.giftStar = self:AddComponent(UIBaseContainer, giftStar_path)
  self.previewBtn = self:AddComponent(UIButton, previewBtn_path)
  self.btnText = self:AddComponent(UIText, btnText_path)
  self.maxBtn:SetOnClick(function()
    self.sliderGroupComponent:SetInputText(math.max(Min_Select_Count, self.giftNum))
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
  end)
  self.input:SetOnValueChange(function(val)
    self:TextValueChange(val)
  end)
  self.input:SetOnEndEdit(function(val)
    self:OnEndEdit(val)
  end)
  self.inputText = self.input.unity_tmpinput.textComponent
  self.inputPlaceHolder = self.input.unity_tmpinput.placeholder
  self.previewBtn:SetOnClick(function()
    self:OnPreviewBtnClick()
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
  self.previewBtn = nil
  self.btnText = nil
  self.sliderGroupComponent = nil
end

local function DataDefine(self)
  local data = self:GetUserData()
  self.template = data.template
  self.targetUid = data.targetUid
  self.targetServerId = data.targetServerId
  self.viewType = data.viewType
end

local function DataDestroy(self)
end

function LWUIGiftDetailView:RefreshView()
  self.num = Min_Select_Count
  self.giftNum = DataCenter.GiftSystemManager:GetGiftNum(self.template.id)
  self.sliderGroupComponent:SetMinNum(Min_Select_Count)
  self.sliderGroupComponent:SetMaxNum(math.max(Min_Select_Count, self.giftNum))
  self.sliderGroupComponent:SetCurNum(self.num)
  self.input:SetText("")
  self.limitTxt:SetText(string.format("%d/%d", 0, Max_Input_Count))
  local quality = self.template.color
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
  self.qualityRawImg:LoadSpriteAsync(GiftSystemConst.GetSendGiftQualityIcon(quality))
  self.giftIconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
    if self.giftIconImg then
      self.giftIconImg:SetNativeSize()
    end
  end)
  self.giftNameTxt:SetLocalText(self.template.name)
  self.addCharmTxt:SetText("+" .. goods.add_exp)
  self.anonymousToggle:SetIsOn(false)
  self.anonymousToggle:SetActive(goods.ep_gift == 1)
  self.input:SetCharacterLimit(Max_Input_Count)
  if self.viewType == "moment" then
    self.btnText:SetLocalText("moment_follow_special_btn")
  else
    self.btnText:SetLocalText("gift_send_btn")
  end
  self.previewBtn:SetActive(false)
end

function LWUIGiftDetailView:OnSendBtnClick()
  if self.targetUid == nil then
    return
  end
  if self.viewType == "moment" then
    DataCenter.GiftSystemManager:SendGiftByFollow(self.template.id, self.targetUid, self.anonymousToggle:GetIsOn(), self.input:GetText(), self.num)
    self.ctrl:CloseSelf()
    return
  end
  DataCenter.GiftSystemManager:SendGift(self.template.id, self.targetUid, self.anonymousToggle:GetIsOn(), self.input:GetText(), self.num)
  self.ctrl:CloseSelf()
end

function LWUIGiftDetailView:TextValueChange(value)
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, #value), Max_Input_Count))
end

function LWUIGiftDetailView:OnEndEdit(value)
  self.inputText.gameObject:SetActive(not string.IsNullOrEmpty(value))
  self.inputPlaceHolder.gameObject:SetActive(string.IsNullOrEmpty(value))
  self.limitTxt:SetText(string.format("%d/%d", math.min(Max_Input_Count, #value), Max_Input_Count))
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
