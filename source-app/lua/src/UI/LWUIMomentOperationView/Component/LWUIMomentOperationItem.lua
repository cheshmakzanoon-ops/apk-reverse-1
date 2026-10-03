local LWUIMomentOperationItem = BaseClass("LWUIMomentOperationItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Linetype = {
  {lineHight = 5, differenceValue = -100},
  {lineHight = 12, differenceValue = 0}
}
local DarkConfig = {
  {lineColor = "#C8C8C9", lineAlpha = 1},
  {lineColor = "#1e1e1e", lineAlpha = 0.6}
}

function LWUIMomentOperationItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIMomentOperationItem:ComponentDefine()
  self.text = self:AddComponent(UITextMeshProUGUIEx, "btnCom/text")
  self.btn = self:AddComponent(UIButton, "btnCom/btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.line = self:AddComponent(UIImage, "line")
end

function LWUIMomentOperationItem:OnBtnClick()
  self.view:OnItemClick(self.data)
end

function LWUIMomentOperationItem:UpdateItem(data, index)
  if not data then
    return
  end
  self.data = data
  self.index = index
  self.text:SetLocalText(self.data.key)
  local size = self:GetSizeDelta()
  if data.line then
    self.line:SetActive(true)
    local config = Linetype[data.line]
    if config then
      self.line:SetSizeDeltaXY(size.x + config.differenceValue, config.lineHight)
    end
  else
    self.line:SetActive(false)
  end
  self:DarkMode()
end

function LWUIMomentOperationItem:DarkMode()
  local config = DarkConfig[ChatInterface.GetChatTheme()]
  self.line:SetColorHex(config.lineColor)
  self.line:SetAlpha(config.lineAlpha)
end

function LWUIMomentOperationItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMomentOperationItem:DataDestroy()
end

function LWUIMomentOperationItem:ComponentDestroy()
end

return LWUIMomentOperationItem
