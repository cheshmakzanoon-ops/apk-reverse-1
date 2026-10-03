local base = UIBaseContainer
local BattlePopBase = BaseClass("BattlePopBase", base)
local close_btn_path = "CloseBtn"
local title_text_path = "Common_img_title/titleText"

function BattlePopBase:OnCreate()
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
end

function BattlePopBase:OnDestroy()
  self.close_btn = nil
  self.title_text = nil
  base.OnDestroy(self)
end

function BattlePopBase:ReInit(key, cb)
  self.close_btn:SetOnClick(cb)
  self.title_text:SetLocalText(key)
end

return BattlePopBase
