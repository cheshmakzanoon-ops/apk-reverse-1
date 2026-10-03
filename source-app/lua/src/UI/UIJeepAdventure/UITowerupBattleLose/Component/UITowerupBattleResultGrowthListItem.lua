local UIZombieBattleResultGrowthListItem = BaseClass("UIZombieBattleResultGrowthListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "Title"
local goto_btn_path = "GotoBtn"
local btn_text_path = "GotoBtn/BtnText"

function UIZombieBattleResultGrowthListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIZombieBattleResultGrowthListItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIZombieBattleResultGrowthListItem:OnEnable()
  base.OnEnable(self)
end

function UIZombieBattleResultGrowthListItem:OnDisable()
  base.OnDisable(self)
end

function UIZombieBattleResultGrowthListItem:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
end

function UIZombieBattleResultGrowthListItem:ComponentDestroy()
  self.title = nil
  self.goto_btn = nil
  self.btn_text = nil
end

function UIZombieBattleResultGrowthListItem:RefreshView(title, btnText, obj, action)
  self.title:SetText(title)
  self.btn_text:SetLocalText(btnText)
  self.goto_btn:SetOnClick(BindCallback(obj, action))
end

return UIZombieBattleResultGrowthListItem
