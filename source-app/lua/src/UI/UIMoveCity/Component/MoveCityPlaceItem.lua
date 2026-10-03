local MoveCityPlaceItem = BaseClass("MoveCityPlaceItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local server_input_field_path = "serverInputField"
local x_input_path = "xInputField/PosX_Value"
local y_input_path = "yInputField/PosY_Value"
local pos_s_value_path = "serverInputField/PosS_Value"
local pos_s_text_path = "PosS_Text"
local posX_text_path = "PosX_Text"
local posY_text_path = "PosY_Text"

function MoveCityPlaceItem:OnCreate()
  base.OnCreate(self)
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "")
  self.x_input = self:AddComponent(UITextMeshProUGUIEx, x_input_path)
  self.y_input = self:AddComponent(UITextMeshProUGUIEx, y_input_path)
  self.posX_text = self:AddComponent(UITextMeshProUGUIEx, posX_text_path)
  self.posY_text = self:AddComponent(UITextMeshProUGUIEx, posY_text_path)
  self.posX_text:SetText("X:")
  self.posY_text:SetText("Y:")
  self.bg = self:AddComponent(UIImage, bg_path)
  self.pos_s_text = self:AddComponent(UITextMeshProUGUIEx, pos_s_text_path)
  self.server_input_field = self:AddComponent(UIImage, server_input_field_path)
  self.pos_s_value = self:AddComponent(UITextMeshProUGUIEx, pos_s_value_path)
end

function MoveCityPlaceItem:OnDestroy()
  self.x_input = nil
  self.y_input = nil
  self.posX_text = nil
  self.posY_text = nil
  self.bg = nil
  self.pos_s_text = nil
  self.server_input_field = nil
  self.pos_s_value = nil
  base.OnDestroy(self)
end

function MoveCityPlaceItem:ShowServerInfo(showIt)
  self.showServerInfo = showIt
  self.pos_s_text:SetActive(showIt)
  self.server_input_field:SetActive(showIt)
  if showIt then
    self.layout:SetSizeDeltaXY(520, 66)
    self.layout:SetPaddingLeft(8)
    self.layout:SetPaddingRight(8)
    self.bg:SetSizeDeltaXY(520, 62)
    self.bg:SetLocalPositionXYZ(0, 0, 0)
  else
    self.layout:SetSizeDeltaXY(440, 66)
    self.layout:SetPaddingLeft(33)
    self.layout:SetPaddingRight(33)
    self.bg:SetSizeDeltaXY(410, 62)
    self.bg:SetLocalPositionXYZ(15, 0, 0)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function MoveCityPlaceItem:InitState(x, y, serverId)
  self.server = serverId or LuaEntry.Player:GetCurServerId()
  self.x = x
  self.y = y
  self.x_input:SetText(tostring(self.x))
  self.y_input:SetText(tostring(self.y))
  if self.showServerInfo then
    self.pos_s_value:SetText("#" .. tostring(self.server))
  end
end

return MoveCityPlaceItem
