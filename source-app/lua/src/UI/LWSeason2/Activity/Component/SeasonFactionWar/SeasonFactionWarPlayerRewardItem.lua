local SeasonFactionWarPlayerRewardItem = BaseClass("SeasonFactionWarPlayerRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function SeasonFactionWarPlayerRewardItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self._require_txt = self:AddComponent(UIText, "Txt_Require")
  self._reward_txt = self:AddComponent(UIText, "Txt_Reward")
end

function SeasonFactionWarPlayerRewardItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonFactionWarPlayerRewardItem:RefreshData(param)
  local scoreId = param
  local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
  if string.IsNullOrEmpty(cfg.tips) then
    self._require_txt:SetLocalText(cfg.name)
  else
    self._require_txt:SetLocalText(cfg.tips)
  end
  self._reward_txt:SetText("+ " .. cfg.points)
end

function SeasonFactionWarPlayerRewardItem:SetBg(i)
  if i % 2 == 0 then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(true)
  end
end

return SeasonFactionWarPlayerRewardItem
