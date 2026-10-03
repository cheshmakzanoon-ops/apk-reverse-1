local UIDesertBattleSoldierTipView = BaseClass("UIDesertBattleSoldierTipView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local item_bg_path = "PopUpTitle/bg/bg2/di0/item_bg"
local item_lv_path = "PopUpTitle/bg/bg2/di0/lv"
local desc_base_path = "PopUpTitle/bg/bg2/di%d/desc%d"
local num_base_path = "PopUpTitle/bg/bg2/di%d/num%d"

function UIDesertBattleSoldierTipView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  if param == nil or param.id == nil then
    return
  end
  self.close_btn = self:AddComponent(UIButton, panel_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.time_bg = self:AddComponent(UIImage, item_bg_path)
  self.time_bg:LoadSpriteAuto(UIUtil.GetItemQualityBg(param.quality))
  self.item_lv = self:AddComponent(UIText, item_lv_path)
  self.item_lv:SetLocalText(140002, param.lv)
  local langKeys = {
    "winter_battlefield_tips1017",
    "Desert_strom_tips1011",
    "130236",
    "Desert_strom_limit_soilders_tips_1"
  }
  local nums = {
    param.count,
    param.dead,
    param.heal,
    param.finishSoldierNum
  }
  for i = 1, 4 do
    local desc = self:AddComponent(UIText, string.format(desc_base_path, i, i))
    desc:SetLocalText(langKeys[i])
    local num = self:AddComponent(UIText, string.format(num_base_path, i, i))
    num:SetText(string.GetFormattedStr(nums[i] or 0))
  end
end

function UIDesertBattleSoldierTipView:OnDestroy()
  self.close_btn = nil
  self.time_bg = nil
  self.item_lv = nil
  base.OnDestroy(self)
end

return UIDesertBattleSoldierTipView
