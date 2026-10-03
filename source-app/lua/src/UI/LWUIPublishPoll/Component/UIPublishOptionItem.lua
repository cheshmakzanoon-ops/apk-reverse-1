local UIPublishOptionItem = BaseClass("UIPublishOptionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local characterLimit = 50
local BtnType = {Cell = 1, Add = 2}
local BtnState = {
  NotDelete = 1,
  Delete = 2,
  NotAdd = 3,
  Add = 4
}
local iconPath = {
  "ChatNotice/zyf_tongmenggonggao_jianshao_hui_icon.png",
  "ChatNotice/zyf_tongmenggonggao_zengjia_hong_icon.png",
  "ChatNotice/zyf_tongmenggonggao_zengjia_hui_icon.png",
  "ChatNotice/zyf_tongmenggonggao_zengjia_lan_icon.png"
}
local input_field_cover_path = "panel/InputFieldCover"
local placeholder2_path = "panel/InputFieldCover/Placeholder2"
local text2_path = "panel/InputFieldCover/Text2"

function UIPublishOptionItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIPublishOptionItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPublishOptionItem:ComponentDefine()
  self.opImg = self:AddComponent(UIImage, "panel/opImg")
  self.optionInput = self:AddComponent(UIInput, "panel/InputField")
  self.img = self:AddComponent(UIImage, "panel/Image")
  self.addOpBtn = self:AddComponent(UIButton, "panel/Btn")
  self.addOpText = self:AddComponent(UIText, "panel/addOpBtn")
  self.addOpBtn:SetOnClick(function()
    if self.state == BtnState.Add then
      self.view:AddOption()
    end
  end)
  self.optionInput:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.optionInput:SetOnEndEdit(function(value)
    self:IptEndEdit(value)
  end)
  self.opBtn = self:AddComponent(UIButton, "panel/opImg")
  self.opBtn:SetOnClick(function()
    self:OnOpBtnClick()
  end)
  self.input_field_cover = self:AddComponent(UIButton, input_field_cover_path)
  self.placeholder2 = self:AddComponent(UITextMeshProUGUIEx, placeholder2_path)
  self.text2 = self:AddComponent(UITextMeshProUGUIEx, text2_path)
  self.input_field_cover:SetOnClick(function()
    self:SetInputTxtShow(true)
  end)
end

function UIPublishOptionItem:OnOpBtnClick()
  if self.state == BtnState.NotDelete then
    return
  elseif self.state == BtnState.Delete then
    self.view:DeleteOption(self.index)
  elseif self.state == BtnState.NotAdd then
    return
  elseif self.state == BtnState.Add then
    self.view:AddOption()
  end
end

function UIPublishOptionItem:IptOnValueChange(text)
  if string.len(text) > characterLimit then
    self.optionInput:SetText(string.SubStr(text, 0, characterLimit))
  end
  if self.callBack then
    self.callBack(self.index, text)
  end
end

function UIPublishOptionItem:IptEndEdit(text)
  self:SetInputTxtShow(false)
end

function UIPublishOptionItem:SetInputTxtShow(show)
  if self.param.btnType == BtnType.Add then
    self.optionInput:SetActive(false)
    self.input_field_cover:SetActive(false)
    return
  end
  if show then
    self.optionInput:SetActive(true)
    self.input_field_cover:SetActive(false)
    self.optionInput:Select()
  else
    self.optionInput:SetActive(false)
    self.input_field_cover:SetActive(true)
    local text = self.optionInput:GetText()
    if string.IsNullOrEmpty(text) then
      self.placeholder2:SetActive(true)
      self.text2:SetActive(false)
    else
      self.placeholder2:SetActive(false)
      self.text2:SetActive(true)
      self.text2:SetText(text)
    end
  end
end

function UIPublishOptionItem:UpdateIconBg(pathIndex)
  self.state = pathIndex
  if self.state == BtnState.Add then
    self.addOpBtn:SetActive(self.param.btnType == BtnType.Add)
  end
  self.opImg:LoadSprite(ChatInterface.GetChatUIPath(iconPath[pathIndex]))
end

function UIPublishOptionItem:ComponentDestroy()
  self.opImg = nil
  self.optionInput = nil
  self.img = nil
  self.btn = nil
  self.addOpBtn = nil
  self.input_field_cover = nil
  self.placeholder2 = nil
  self.text2 = nil
end

function UIPublishOptionItem:DataDefine()
end

function UIPublishOptionItem:DataDestroy()
  self.param = nil
end

function UIPublishOptionItem:ReInit(param, index, callBack)
  self.param = param
  self.index = index
  self.callBack = callBack
  self:UpdateIconBg(self.param.bgIndex)
  if self.param.info then
    self.optionInput:SetText(self.param.info)
  end
  self.addOpText:SetActive(self.param.btnType == BtnType.Add)
  self.addOpBtn:SetActive(self.param.btnType == BtnType.Add)
  self.img:SetActive(self.param.btnType ~= BtnType.Add)
  self.optionInput:SetActive(self.param.btnType == BtnType.Cell)
  self:SetInputTxtShow(false)
  if param.setFocus then
    self:SetInputTxtShow(true)
  end
end

return UIPublishOptionItem
