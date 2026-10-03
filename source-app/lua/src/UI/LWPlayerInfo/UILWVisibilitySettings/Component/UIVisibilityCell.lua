local UIVisibilityCell = BaseClass("UIVisibilityCell", UIBaseContainer)
local base = UIBaseContainer
local common_duihao_path = "Common_duihao_kuang/Common_duihao"
local DarkConfig = {
  {textColor = "#736863", textSelectColor = "#736863"},
  {textColor = "#828282", textSelectColor = "#AAAAAA"}
}

function UIVisibilityCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIVisibilityCell:ComponentDefine()
  self.selectImg = self:AddComponent(UIImage, common_duihao_path)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIVisibilityCell:OnBtnClick()
  if self.callBack then
    self.callBack(self.index)
  end
end

function UIVisibilityCell:ReInit(data, index, callBack)
  self.data = data
  self.index = index
  self.callBack = callBack
  self.selectImg:SetActive(false)
  if self.data then
    self.nameText:SetLocalText(self.data.lanKay)
  end
  self:DarkMode()
end

function UIVisibilityCell:DarkMode()
  self.nameText:SetColorHex(DarkConfig[ChatInterface.GetChatTheme()].textColor)
end

function UIVisibilityCell:SelectItem(isOn)
  local config = DarkConfig[ChatInterface.GetChatTheme()]
  self.selectImg:SetActive(isOn)
  local color = isOn and config.textSelectColor or config.textColor
  self.nameText:SetColorHex(color)
end

function UIVisibilityCell:ComponentDestroy()
  self.selectImg = nil
  self.nameText = nil
  self.btn = nil
end

function UIVisibilityCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVisibilityCell:DataDestroy()
  self.data = nil
  self.index = nil
  self.callBack = nil
end

return UIVisibilityCell
