local UILWMummyMainItemEffectItemS6 = BaseClass("UILWMummyMainItemEffectItemS6", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UILWMummyMainItemEffectItemS6:OnCreate()
  base.OnCreate(self)
  self.active = self:AddComponent(UIImage, "active")
  self.open = self:AddComponent(UIButton, "open")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
  self.active:SetActive(false)
  self.open:SetActive(false)
  self.open:SetOnClick(function()
    if self.effect_info_tip ~= nil then
      self.effect_info_tip:ShowTips(self.statusId, self.needArmyCount, self.totalArmyCountNow)
    else
      self:ShowTips()
    end
  end)
  self:SetOnClick(function()
    self:ShowTips()
  end)
end

function UILWMummyMainItemEffectItemS6:ShowTips()
  local param = {}
  if self.index ~= nil and self.index ~= 0 then
    param.title = Localization:GetString("season_s3_Mummy_ui_info01" .. self.index)
    param.desc = Localization:GetString("season_s3_Mummy_tips005", self.needArmyCount)
  else
    param.title = Localization:GetString("season_s3_soilder_Mummy")
    param.desc = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(self.totalArmyCountNow or 0)
  end
  param.type = "nameDesc"
  param.isLocal = true
  param.alignObject = self
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UILWMummyMainItemEffectItemS6:OnDestroy()
  if self.theEffect then
    pcall(self.theEffect.Delete, self.theEffect)
    self.theEffect = nil
  end
  if self.effect_info_tip ~= nil then
    self.effect_info_tip:SetActive(false)
  end
  self.active = nil
  self.open = nil
  self.txt = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemEffectItemS6:ReInit(index, armyCount, statusId, totalArmyCountNow, effect_info_tip)
  local armyCountNeed = toInt(armyCount)
  local reachItNow = totalArmyCountNow >= armyCountNeed
  self.txt:SetText(armyCount)
  if armyCountNeed == 0 then
    reachItNow = 0 < totalArmyCountNow
    self.txt:SetText(totalArmyCountNow)
  end
  self.index = index
  self.needArmyCount = armyCountNeed
  self.totalArmyCountNow = totalArmyCountNow
  self.effect_info_tip = effect_info_tip
  self.statusId = statusId
  self.active:SetActive(reachItNow)
  self.open:SetActive(true)
  return armyCountNeed
end

return UILWMummyMainItemEffectItemS6
