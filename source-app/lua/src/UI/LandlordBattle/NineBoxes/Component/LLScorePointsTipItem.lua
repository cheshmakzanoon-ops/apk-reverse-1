local base = UIBaseContainer
local LLScorePointsTipItem = BaseClass("LLScorePointsTipItem", base)
local l_text_path = "LText"
local r_text_path = "RText"

function LLScorePointsTipItem:OnCreate()
  base.OnCreate(self)
  self.l_text = self:AddComponent(UITextMeshProUGUIEx, l_text_path)
  self.r_text = self:AddComponent(UITextMeshProUGUIEx, r_text_path)
end

function LLScorePointsTipItem:OnDestroy()
  self.l_text = nil
  self.r_text = nil
  base.OnDestroy(self)
end

function LLScorePointsTipItem:ReInit(xmlId)
  local info = LocalController:instance():getLine(TableName.Score, xmlId)
  if info ~= nil then
    local value = info:getValue("value")
    local type = info:getValue("type")
    if type == 700 or type == 701 then
      local line = LocalController:instance():getLine(TableName.LW_Soldier, value)
      if line ~= nil then
        value = line:getValue("soldier_lv")
      end
    end
    self.l_text:SetLocalText(info:getValue("name"), value)
    self.r_text:SetText("+" .. info:getValue("points"))
  end
end

return LLScorePointsTipItem
