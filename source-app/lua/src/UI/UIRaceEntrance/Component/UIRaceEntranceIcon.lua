local base = UIBaseContainer
local UIRaceEntranceIcon = BaseClass("UIRaceEntranceIcon", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local icon_path = "Icon"
local front_path = "Front"

function UIRaceEntranceIcon:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.front = self:AddComponent(UIImage, front_path)
end

function UIRaceEntranceIcon:OnDestroy()
  self.btn = nil
  self.bg = nil
  self.icon = nil
  self.front = nil
  base.OnDestroy(self)
end

function UIRaceEntranceIcon:OnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.tipKey == nil then
    if self.actType == EnumActivity.ActDragon.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.Desert, BF_GuideTag.Reward)
    elseif self.actType == EnumActivity.ActWinterStorm.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormTaskS0)
    elseif self.actType == EnumActivity.ActMeteorite.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteAward)
    elseif self.actType == EnumActivity.ActDsbDuel.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true}, BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward)
    elseif self.actType == EnumActivity.ActEpidemic.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicRewardView, {anim = true}, 3)
    end
    return
  end
  local strTip = Localization:GetString(self.tipKey)
  local pos = self.btn.transform.position
  local reversal = pos.y < Screen.height / 4
  local num = reversal and 30 or -30
  UIUtil.ShowBubbleTips(strTip, self.btn.transform.position, 0, num, 0, nil, nil, {reversal = reversal})
end

function UIRaceEntranceIcon:RefreshData(icon, tipKey, actType)
  if type(tipKey) == "number" then
    self.bg:SetActive(true)
    self.front:SetActive(false)
    self.bg:LoadSpriteAsync(UIUtil.GetItemQualityBg(tipKey))
  else
    self.bg:SetActive(false)
    self.front:SetActive(true)
    self.tipKey = tipKey
  end
  self.icon:LoadSpriteAsync(icon)
  self.actType = actType
end

return UIRaceEntranceIcon
