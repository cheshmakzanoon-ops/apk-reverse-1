local LWUIMigration_Matter = BaseClass("LWUIMigration_Matter", UIBaseContainer)
local base = UIBaseContainer
local basePath = "Assets/Main/Sprites/UI/LWUIMigration/"

function LWUIMigration_Matter:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "Icon")
  self.text = self:AddComponent(UIText, "Text")
end

function LWUIMigration_Matter:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_Matter:SetData(idx)
  local key = "migration_activity_interface_1008" .. 4 + idx
  local flag = false
  if idx == 1 then
    flag = LuaEntry.Player:IsInAlliance() == false
  elseif idx == 2 then
    flag = true
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident and curPresident.uid == LuaEntry.Player:GetUid() then
      flag = false
    end
  elseif idx == 3 then
    flag = LuaEntry.Player:AtHomeNow()
  elseif idx == 4 then
    local curMarchNum = DataCenter.ArmyFormationDataManager:GetAlreadySetCountInArmyFormation()
    flag = curMarchNum == 0
  elseif idx == 5 then
  end
  self.icon:LoadSpriteAuto(flag and basePath .. "mjc_guanzhijineng_text_bg01.png" or basePath .. "Mjc_vip_text_bg_00.png")
  self.text:SetLocalText(key)
  return flag
end

return LWUIMigration_Matter
