local KingPowerItem = BaseClass("KingPowerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_path = "item"
local desc_path = "Desc"
local go_btn_path = "GoBtn"
local num_path = "Num"
local effect_desc_path = "EffectDesc"

function KingPowerItem:OnCreate()
  base.OnCreate(self)
  self.item = self:AddComponent(UICommonResItem, item_path)
  self.text_title = self:AddComponent(UIText, desc_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.text_num = self:AddComponent(UIText, num_path)
  self.effect_desc = self:AddComponent(UIText, effect_desc_path)
  self.go_btn:SetOnClick(function()
    if LuaEntry.Player:IsPresident() then
      UIUtil.ShowTipsId(120018)
    else
      UIUtil.ShowTipsId(120173)
    end
  end)
end

function KingPowerItem:OnDestroy()
  base.OnDestroy(self)
end

function KingPowerItem:OnEnable()
  base.OnEnable(self)
end

function KingPowerItem:OnDisable()
  base.OnDisable(self)
end

function KingPowerItem:ReInit(index)
  self.text_title:SetLocalText("2500930")
  self.text_num:SetLocalText("457014", 0, 5)
  self.effect_desc:SetLocalText("457004")
  local itemData = DataCenter.RewardManager:ParseOneRewardStr("200362;7;1")
  self.item:ReInit(itemData)
end

function KingPowerItem:Update1000MS()
end

return KingPowerItem
