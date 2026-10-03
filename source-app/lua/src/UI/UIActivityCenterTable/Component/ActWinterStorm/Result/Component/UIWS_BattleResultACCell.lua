local base = UIBaseContainer
local UIWS_BattleResultACCell = BaseClass("UIWS_BattleResultACCell", UIBaseContainer)
local ActMgr = DataCenter.ActWinterStormManager

function UIWS_BattleResultACCell:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "Icon")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "Desc")
  self.score = self:AddComponent(UITextMeshProUGUIEx, "ScoreIcon/Score")
end

function UIWS_BattleResultACCell:OnDestroy()
  base.OnDestroy(self)
end

function UIWS_BattleResultACCell:ReInit(data)
  self.score:SetText("+" .. (data.number or 0))
  local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, data.id)
  if lineData ~= nil then
    local icon = lineData:getValue("icon")
    if not string.IsNullOrEmpty(icon) then
      self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, icon))
    end
    self.desc:SetLocalText(lineData:getValue("name"))
  end
end

return UIWS_BattleResultACCell
