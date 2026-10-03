local base = UIAsyncContainer
local BattleSignAchievementCell = BaseClass("BattleSignAchievementCell", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local BG_PATH = "mjc_dongri_huoquchengjiu%s_bg"

function BattleSignAchievementCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BattleSignAchievementCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BattleSignAchievementCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHeadIcon = self.viewSkin:AddComponent(self, UIPlayerHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgRoot = self.viewSkin:AddComponent(self, UIImage, 5)
end

function BattleSignAchievementCell:ComponentDestroy()
  self.viewSkin = nil
  self.compHeadIcon = nil
  self.textName = nil
  self.textDesc = nil
  self.imgIcon = nil
  self.imgRoot = nil
end

function BattleSignAchievementCell:DataDefine()
  self.startTime = 0
  self.minTime = 0
end

function BattleSignAchievementCell:DataDestroy()
  if self.txtTweenSeq then
    self.txtTweenSeq:Kill()
    self.txtTweenSeq = nil
  end
  self:CleanDelay()
  self.minTime = 0
end

function BattleSignAchievementCell:OnAddListener()
  base.OnAddListener(self)
end

function BattleSignAchievementCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BattleSignAchievementCell:UpdateData()
  self:CleanDelay()
  local teamArr = self.info
  self:SetActive(teamArr ~= nil)
  if teamArr == nil then
    return
  end
  self.compHeadIcon:SetData(teamArr.uid, teamArr.head, teamArr.frame or 0)
  local showName = UIUtil.FormatServerAllianceName(teamArr.server, teamArr.abbr, teamArr.name, teamArr.uid)
  self.textName:SetText(showName)
  local colorType
  if teamArr.uid == LuaEntry.Player:GetUid() then
    colorType = CityLabelColorType.Green
  else
    local bEnemy = BattleFieldUtil.IsBattleFieldEnemy(teamArr.uid, BattleFieldType.WinterStorm)
    colorType = bEnemy and CityLabelColorType.Red or CityLabelColorType.Blue
  end
  self.textName:SetColor(CityLabelColors[colorType] or CityLabelWhiteColor)
  local rawWidth = self.textName:GetWidth()
  if self.txtTweenSeq then
    self.txtTweenSeq:Kill()
  end
  local QUEST_ENTRY_WIDTH_LIMIT = 210
  if rawWidth > QUEST_ENTRY_WIDTH_LIMIT then
    self.txtTweenSeq = UIUtil.SetTMPHorseRaceLamp(self.textName, QUEST_ENTRY_WIDTH_LIMIT, 2, 60, 2, self.textName.transform)
  else
    self.textName:SetAnchoredPositionXY(0, 0)
  end
  local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, teamArr.id)
  local playTime = 5
  self.minTime = 2
  if lineData ~= nil then
    local quality = lineData:getIntValue("quality")
    local qStr = ""
    if quality == 1 then
      qStr = "3"
    elseif quality == 2 then
      qStr = "2"
    end
    local path = string.format(BG_PATH, qStr)
    self.imgRoot:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterPath, path))
    local icon = lineData:getValue("icon")
    if not string.IsNullOrEmpty(icon) then
      self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, icon))
    end
    self.textDesc:SetLocalText(lineData:getValue("short_name"))
    self.minTime = lineData:getIntValue("min_display_interval", 2)
    playTime = lineData:getIntValue("display_interval", 5)
  end
  self.startTime = UITimeManager:GetInstance():GetServerSeconds()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.WinterStormBattleAchievementNew)
  end, playTime)
end

function BattleSignAchievementCell:CleanDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.startTime = 0
end

function BattleSignAchievementCell:CheckLeftMin()
  if self.startTime == nil or self.startTime == 0 then
    return 0
  end
  local passTime = UITimeManager:GetInstance():GetServerSeconds() - self.startTime
  return passTime - self.minTime
end

function BattleSignAchievementCell:SetData(info)
  self.info = info
  self:RefreshView()
end

return BattleSignAchievementCell
