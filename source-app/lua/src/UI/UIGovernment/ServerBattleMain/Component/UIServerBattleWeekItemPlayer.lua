local UIServerBattleWeekItemPlayer = BaseClass("UIServerBattleWeekItemPlayer", UIBaseContainer)
local base = UIBaseContainer
local player_path = "Player"
local name_path = "name"
local text_path = "Icon/Text"
local rank_name_path = "rank/rankName"
local info_img_path = "InfoImg"
local title_path = "title"
local score_path = "score"

function UIServerBattleWeekItemPlayer:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.name = self:AddComponent(UIText, name_path)
  self.powerText = self:AddComponent(UIText, text_path)
  self.rank_name = self:AddComponent(UIText, rank_name_path)
  self.infoImg = self:AddComponent(UIImage, info_img_path)
  self.title = self:AddComponent(UIText, title_path)
  self.score = self:AddComponent(UIText, score_path)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.playerUI:SetEnableClickShowInfo(true, true)
end

function UIServerBattleWeekItemPlayer:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleWeekItemPlayer:ReInit(configScore, config, serverBattleType, isWinner, scoreData)
  local player = scoreData.extra
  self.configScore = configScore
  self.config = config
  self.serverBattleType = serverBattleType
  if isWinner then
    self.title:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.score:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_wofangjilubg.png")
  else
    self.title:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.score:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difangjilubg.png")
  end
  self.title:SetLocalText(configScore.name)
  self.score:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
  if string.IsNullOrEmpty(player.abbr) then
    self.name:SetText("#" .. scoreData.serverId .. " " .. player.name)
  else
    self.name:SetText("#" .. scoreData.serverId .. " [" .. player.abbr .. "]" .. player.name)
  end
  self.powerText:SetText(string.GetFormattedSeparatorNum(player.power or 0))
  self.rank_name:SetText("NO.1")
  self.playerUI:ParseHeadInfo(player)
  self.playerUI:SetFlag(player.country)
  self.infoImg:LoadSprite(configScore.icon)
  self.infoImg:SetNativeSize()
end

return UIServerBattleWeekItemPlayer
