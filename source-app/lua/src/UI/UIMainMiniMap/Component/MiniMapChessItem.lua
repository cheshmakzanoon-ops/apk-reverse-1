local base = UIBaseContainer
local MiniMapChessItem = BaseClass("MiniMapChessItem", base)
local Localization = CS.GameEntry.Localization

function MiniMapChessItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "icon")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
end

function MiniMapChessItem:OnDestroy()
  self.icon = nil
  self.txt = nil
  base.OnDestroy(self)
end

function MiniMapChessItem:ReInit(index, data)
  local color_help_list = string.split_ss_array(tostring(data.color_help), "|")
  local color_help
  for _, key in ipairs(color_help_list) do
    if color_help == nil then
      color_help = Localization:GetString(key)
    else
      color_help = color_help .. "\n" .. Localization:GetString(key)
    end
  end
  self.txt:SetText(color_help)
  self.icon:LoadSprite(data.color_help_icon)
end

return MiniMapChessItem
