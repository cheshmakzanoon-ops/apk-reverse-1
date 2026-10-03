local base = UIBaseContainer
local LWActMeteoriteZoneInfo = BaseClass("LWActMeteoriteZoneInfo", base)
local Localization = CS.GameEntry.Localization
local death_text_path = "Root/DeathIcon/DeathText"
local build_text_path = "Root/BuildIcon/BuildText"
local circle1_path = "Root/Circle1"
local circle2_path = "Root/Circle2"

function LWActMeteoriteZoneInfo:OnCreate()
  base.OnCreate(self)
  self.death_text = self:AddComponent(UITextMeshProUGUIEx, death_text_path)
  self.build_text = self:AddComponent(UITextMeshProUGUIEx, build_text_path)
  self.circle1 = self:AddComponent(UIBaseComponent, circle1_path)
  self.circle2 = self:AddComponent(UIBaseComponent, circle2_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("yuntieBattle_interface_1043", self.build_text:GetText(), self.death_text:GetText())
    UIUtil.ShowBubbleTips(strTip, self.btn.transform.position, 0, -30, 0)
  end)
end

function LWActMeteoriteZoneInfo:OnDestroy()
  self.death_text = nil
  self.build_text = nil
  self.circle = nil
  base.OnDestroy(self)
end

function LWActMeteoriteZoneInfo:SetData(meteorite, index)
  if meteorite == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.death_text:SetText(string.GetFormattedStr0(meteorite.soldierNum or 0))
  self.build_text:SetText(string.GetFormattedStr0(meteorite.buildNum or 0))
  local temp = index % 2
  self.circle1:SetActive(temp == 0)
  self.circle2:SetActive(temp == 1)
end

return LWActMeteoriteZoneInfo
