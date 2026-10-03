local UICommonScore = BaseClass("UICommonScore", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICommonScore:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg/bg")
  self._require_txt = self:AddComponent(UIText, "bg/Txt_Require")
  self._reward_txt = self:AddComponent(UIText, "bg/Txt_Reward")
end

function UICommonScore:OnDestroy()
  base.OnDestroy(self)
end

function UICommonScore:RefreshData(cfg)
  if string.IsNullOrEmpty(cfg.tips) then
    self._require_txt:SetLocalText(cfg.name)
  else
    self._require_txt:SetLocalText(cfg.tips)
  end
  self._reward_txt:SetText("+ " .. cfg.points)
  self._require_txt:SetSizeDeltaXY(590, 50)
end

function UICommonScore:SetBg(i)
  if i % 2 == 0 then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(true)
  end
end

return UICommonScore
