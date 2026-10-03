local base = UIBaseView
local UIFishBuffView = BaseClass("UIFishBuffView", UIBaseView)

function UIFishBuffView:ComponentDefine()
  local panel_path = "Panel"
  local desc_path = "Content/Info/Desc"
  local title_txt_path = "Content/bgContent1/titleBg/mask_titlebg/titlebg/titleTxt"
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
end

function UIFishBuffView:ComponentDestroy()
  self.panel = nil
  self.desc = nil
  self.title_txt = nil
end

function UIFishBuffView:DataDestroy()
  self.Data = nil
end

function UIFishBuffView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit(self:GetUserData())
end

function UIFishBuffView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishBuffView:ReInit(statusCell)
  if self:InitData(statusCell) then
    self:InitUi()
  end
end

function UIFishBuffView:InitData(statusCell)
  if statusCell ~= nil then
    self.StatusCell = statusCell
    return true
  end
  return false
end

function UIFishBuffView:InitUi()
  self.title_txt:SetLocalText(self.StatusCell.name)
  self.desc:SetText(self:GetDesc(self.StatusCell.id))
end

function UIFishBuffView:GetDesc(statusId)
  local template = LocalController:instance():getLine(TableName.StatusTab, statusId)
  if not template then
    return ""
  end
  local effectIds = string.split(template.effect, "|")
  local effectValues = string.split(template.effect_num, "|")
  if effectIds and effectValues and 0 < #effectIds and #effectIds == #effectValues then
    local sb = StringBuilder.New()
    sb:Clear()
    for i, effectId in ipairs(effectIds) do
      local valueStr, name = UIUtil.GetEffectStr(nil, effectValues[i], tonumber(effectId))
      sb:AppendFormatLine("%s <color=#5FEF87>%s</color>", CS.GameEntry.Localization:GetString(name), valueStr)
    end
    return sb:ToString()
  end
  return ""
end

function UIFishBuffView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return UIFishBuffView
