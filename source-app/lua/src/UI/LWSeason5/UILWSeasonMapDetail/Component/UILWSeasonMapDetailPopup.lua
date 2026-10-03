local UILWSeasonMapDetailPopup = BaseClass("UILWSeasonMapDetailPopup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local arrow_down_path = "arrowDown"
local arrow_top_path = "arrowTop"
local icon_path = "icon"
local txt_path = "txt"
local pos_path = "pos"
local buff_path = "buff"
local buff_txt_path = "buffTxt"
local detail_path = "detail"
local close_btn_path = "closeBtn"

function UILWSeasonMapDetailPopup:OnCreate()
  base.OnCreate(self)
  self.arrow_down = self:AddComponent(UIImage, arrow_down_path)
  self.arrow_top = self:AddComponent(UIImage, arrow_top_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.pos = self:AddComponent(UITextMeshProUGUIEx, pos_path)
  self.buff = self:AddComponent(UIImage, buff_path)
  self.buff_txt = self:AddComponent(UITextMeshProUGUIEx, buff_txt_path)
  self.detail = self:AddComponent(UITextMeshProUGUIEx, detail_path)
  self.close_btn = self:AddComponent(UIButton, "")
  self.close_btn:SetOnClick(function()
    self:SetActive(false)
  end)
end

function UILWSeasonMapDetailPopup:OnDestroy()
  self.arrow_down = nil
  self.arrow_top = nil
  self.icon = nil
  self.txt = nil
  self.pos = nil
  self.buff = nil
  self.buff_txt = nil
  self.detail = nil
  self.close_btn = nil
  base.OnDestroy(self)
end

function UILWSeasonMapDetailPopup:ShowAt(item)
  local mapIndex = item.mapIndex or 1
  local skin = item.skinMeta
  local serverId = item.serverId
  self.arrow_down:SetActive(mapIndex < 4)
  self.arrow_top:SetActive(3 < mapIndex)
  if mapIndex < 4 then
    self:SetLocalPositionXYZ(0, 233, 0)
    self.arrow_down:SetLocalPositionXYZ(-466 + 233 * mapIndex, -181.5, 0)
  elseif mapIndex < 7 then
    self:SetLocalPositionXYZ(0, -61, 0)
    self.arrow_top:SetLocalPositionXYZ(-466 + 233 * (mapIndex - 3), 185, 0)
  else
    self:SetLocalPositionXYZ(0, 163, 0)
    self.arrow_top:SetLocalPositionXYZ(-466 + 233 * (mapIndex - 6), 185.5, 0)
  end
  self.icon:LoadSprite(skin.location_icon)
  self.txt:SetLocalText(skin.aliases)
  self.detail:SetLocalText(skin.location_info)
  local msg = Localization:GetString("s5_map_ui_5", Localization:GetString(skin.position))
  if mapIndex ~= 5 then
    msg = Localization:GetString("s5_map_ui_4", "#" .. serverId) .. "\n" .. msg
  end
  self.pos:SetText(msg)
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, toInt(skin.location_buff))
  if stateMeta then
    self.buff_txt:SetLocalText(stateMeta.description)
  else
    self.buff_txt:SetText("")
  end
  self:SetActive(true)
end

return UILWSeasonMapDetailPopup
