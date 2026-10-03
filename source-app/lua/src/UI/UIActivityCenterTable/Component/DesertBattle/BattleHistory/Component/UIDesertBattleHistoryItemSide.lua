local UIDesertBattleHistoryItemSide = BaseClass("UIDesertBattleHistoryItemSide", UIBaseContainer)
local base = UIBaseContainer

function UIDesertBattleHistoryItemSide:OnCreate()
  base.OnCreate(self)
  self.win = self:AddComponent(UIImage, "win")
  self.flag_icon = self:AddComponent(UIImage, "flagIcon1")
  self.team_icon = self:AddComponent(UIImage, "flagIcon1/TeamIcon")
  self.server = self:AddComponent(UIText, "flagIcon1/bg/server1")
  self.userName = self:AddComponent(UIText, "name1")
  self.countScore = self:AddComponent(UIText, "count11")
  self.countUser = self:AddComponent(UIText, "count13")
end

function UIDesertBattleHistoryItemSide:OnDestroy()
  self.win = nil
  self.flag_icon = nil
  self.team_icon = nil
  self.server = nil
  self.userName = nil
  self.countScore = nil
  self.countUser = nil
  base.OnDestroy(self)
end

function UIDesertBattleHistoryItemSide:ReInit(data, mine)
  if mine then
    self.win:SetActive(data.state == 2)
    if string.IsNullOrEmpty(data.icon) then
    else
      self.flag_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
    end
    self.team_icon:SetActive(data.groupM > 0)
    if data.groupM > 0 then
      DataCenter.ActDragonManager:LoadTeamSprite(self.team_icon, data.groupM)
    end
    self.server:SetText("#" .. data.server)
    self.userName:SetText(data:GetMineName())
    self.countScore:SetText(data.score)
    self.countUser:SetText(string.GetFormattedSeperatorNum(data.userNum))
  else
    self.win:SetActive(data.state == 3)
    if data.state == 1 then
      self.server:SetText("???")
      self.userName:SetText("???")
      self.countScore:SetText("???")
      self.countUser:SetText("???")
      self.team_icon:SetActive(false)
    else
      if string.IsNullOrEmpty(data.enemyIcon) then
      else
        self.flag_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.enemyIcon))
      end
      self.team_icon:SetActive(0 < data.groupE)
      if 0 < data.groupE then
        DataCenter.ActDragonManager:LoadTeamSprite(self.team_icon, data.groupE)
      end
      self.server:SetText("#" .. data.enemyServer)
      self.userName:SetText(data:GetEnemyName())
      self.countScore:SetText(data.enemyScore)
      self.countUser:SetText(string.GetFormattedSeperatorNum(data.enemyUserNum))
    end
  end
end

return UIDesertBattleHistoryItemSide
