local base = UIBaseContainer
local BattlePointTipItem = BaseClass("BattlePointTipItem", base)
local l_text_path = "LText"
local r_text_path = "RText"

function BattlePointTipItem:OnCreate()
  base.OnCreate(self)
  self.l_text = self:AddComponent(UITextMeshProUGUIEx, l_text_path)
  self.r_text = self:AddComponent(UITextMeshProUGUIEx, r_text_path)
end

function BattlePointTipItem:OnDestroy()
  self.l_text = nil
  self.r_text = nil
  base.OnDestroy(self)
end

function BattlePointTipItem:ReInit(info)
  self.l_text:SetLocalText(info.name)
  self.r_text:SetText("+" .. info.points)
end

return BattlePointTipItem
