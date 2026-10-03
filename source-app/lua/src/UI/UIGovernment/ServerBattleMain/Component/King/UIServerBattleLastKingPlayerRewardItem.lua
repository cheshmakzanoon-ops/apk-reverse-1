local UIServerBattleLastKingPlayerRewardItem = BaseClass("UIServerBattleLastKingPlayerRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIServerBattleLastKingPlayerRewardItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self._require_txt = self:AddComponent(UIText, "Txt_Require")
  self._reward_txt = self:AddComponent(UIText, "Txt_Reward")
end

function UIServerBattleLastKingPlayerRewardItem:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleLastKingPlayerRewardItem:RefreshData(param)
  local scoreId = param
  local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
  if string.IsNullOrEmpty(cfg.tips) then
    self._require_txt:SetLocalText(cfg.name)
  else
    self._require_txt:SetLocalText(cfg.tips)
  end
  self._reward_txt:SetText("+ " .. cfg.points)
end

function UIServerBattleLastKingPlayerRewardItem:SetBg(i)
  if i % 2 == 0 then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(true)
  end
end

return UIServerBattleLastKingPlayerRewardItem
