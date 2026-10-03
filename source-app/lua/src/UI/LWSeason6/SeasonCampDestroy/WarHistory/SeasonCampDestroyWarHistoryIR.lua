local base = UIBaseContainer
local SeasonCampDestroyWarHistoryIR = BaseClass("SeasonCampDestroyWarHistoryIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyWarHistoryIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyWarHistoryIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarHistoryIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBgBlue = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgBgRed = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnInfoImg = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfoImg:SetOnClick(function()
    self:OnBtnInfoImgClick()
  end)
  self.imgCamp = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgFlagIcon2 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textServer1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textAbbr1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textName1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compLose1 = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compWin1 = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textServer2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textName2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textAbbr2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compWin2 = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compLose2 = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.imgFlagIcon1 = self.viewSkin:AddComponent(self, UIImage, 22)
  self.btnJumpToWorld = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnJumpToWorld:SetOnClick(function()
    self:OnBtnJumpToWorldClick()
  end)
end

function SeasonCampDestroyWarHistoryIR:ComponentDestroy()
  self.viewSkin = nil
  self.imgBgBlue = nil
  self.imgBgRed = nil
  self.btnInfoImg = nil
  self.imgCamp = nil
  self.textScore = nil
  self.imgFlagIcon2 = nil
  self.textServer1 = nil
  self.textAbbr1 = nil
  self.textName1 = nil
  self.compLose1 = nil
  self.compWin1 = nil
  self.textServer2 = nil
  self.textName2 = nil
  self.textAbbr2 = nil
  self.compWin2 = nil
  self.compLose2 = nil
  self.textEmpty = nil
  self.imgIcon = nil
  self.textPos = nil
  self.btn = nil
  self.textTime = nil
  self.imgFlagIcon1 = nil
  self.btnJumpToWorld = nil
end

function SeasonCampDestroyWarHistoryIR:DataDefine()
  self.data = nil
end

function SeasonCampDestroyWarHistoryIR:DataDestroy()
  self.data = nil
end

function SeasonCampDestroyWarHistoryIR:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyWarHistoryIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarHistoryIR:OnBtnInfoImgClick()
  self:JumpTo()
end

function SeasonCampDestroyWarHistoryIR:OnBtnClick()
  self:JumpTo()
end

function SeasonCampDestroyWarHistoryIR:OnBtnJumpToWorldClick()
  self:JumpTo()
end

function SeasonCampDestroyWarHistoryIR:ReInit(data)
  self.data = data
  local fightStartTime = DataCenter.SeasonDataManager.CrossDeclareWarStartTime
  if fightStartTime == nil or fightStartTime == 0 then
    fightStartTime = UITimeManager:GetInstance():GetServerTime() - 15 * OneDayTime * 1000
  end
  local startTime = data.startTime
  local weekTime = 7 * OneDayTime * 1000
  self.compWin1:SetActive(false)
  self.compLose1:SetActive(false)
  self.compWin2:SetActive(false)
  self.compLose2:SetActive(false)
  self.textScore:SetText(string.format("+%s", string.GetFormattedSeparatorNum(data.score or 0)))
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(data.cityId)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myData, enemyData, myColor, enemyColor
  local winnerCamp = 0
  if data.atk then
    data.atk.camp = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.atk.serverId)
  end
  if data.def then
    data.def.camp = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.def.serverId)
  end
  local showIcon = false
  if data.atk and data.def then
    if data.result == 1 then
      winnerCamp = data.atk.camp
      showIcon = true
    elseif data.result == 2 then
      winnerCamp = data.def.camp
    end
  elseif data.atk and data.result == 1 then
    winnerCamp = data.atk.camp
  end
  self.imgBgRed:SetActive(data.atk.camp == 1)
  self.imgBgBlue:SetActive(data.atk.camp == 2)
  if showIcon then
    self.imgCamp:LoadSpriteAuto(SeasonUtil.GetSeason6CampIconPath(winnerCamp))
    self.textScore:SetColor(SeasonUtil.GetSeason6CampFontColor(winnerCamp))
  end
  self.imgCamp:SetActive(showIcon)
  self.textScore:SetActive(showIcon)
  if data.atk and data.def then
    if data.atk.serverId == mySourceServerId then
      myData = data.atk
      enemyData = data.def
      if data.result == 1 then
        self.textScore:SetText("+" .. string.GetFormattedSeparatorNum(data.score or 0))
        self.compWin1:SetActive(true)
        self.compLose2:SetActive(true)
      elseif data.result == 2 then
        self.compLose1:SetActive(true)
        self.compWin2:SetActive(true)
      end
    else
      myData = data.def
      enemyData = data.atk
      if data.result == 1 then
        self.textScore:SetText("+" .. string.GetFormattedSeparatorNum(data.score or 0))
        self.compLose1:SetActive(true)
        self.compWin2:SetActive(true)
      elseif data.result == 2 then
        self.compWin1:SetActive(true)
        self.compLose2:SetActive(true)
      end
    end
  else
    if data.atk then
      myData = data.atk
      enemyData = {
        serverId = "",
        icon = "1",
        abbr = "",
        name = ""
      }
    elseif data.def then
      myData = data.def
      enemyData = {
        serverId = "",
        icon = "1",
        abbr = "",
        name = ""
      }
    end
    if data.result == 1 then
      self.textScore:SetText("+" .. string.GetFormattedSeparatorNum(data.score or 0))
      self.compWin1:SetActive(true)
    elseif data.result == 2 then
      self.compLose1:SetActive(true)
    end
  end
  myColor = SeasonUtil.GetSeason6CampFontColor(myData.camp)
  enemyColor = SeasonUtil.GetSeason6CampFontColor(enemyData.camp)
  self.imgFlagIcon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(myData.icon)))
  self.textServer1:SetText(string.format("#%s", myData.serverId))
  self.textAbbr1:SetText(string.format("[%s]", myData.abbr))
  self.textName1:SetText(myData.name)
  self.textServer1:SetColor(myColor)
  self.textAbbr1:SetColor(myColor)
  self.textName1:SetColor(myColor)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.startTime))
  if cityInfo then
    self.textPos:SetText(string.format("#%s X:%s Y:%s", data.serverId, cityInfo.pos.x, cityInfo.pos.y))
  else
    self.textPos:SetText(string.format("#%s", data.serverId))
  end
  if enemyData == nil or string.IsNullOrEmpty(enemyData.abbr) then
    self.imgFlagIcon2:SetActive(false)
    self.textEmpty:SetActive(true)
  else
    self.imgFlagIcon2:SetActive(true)
    self.textEmpty:SetActive(false)
    self.imgFlagIcon2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(enemyData.icon)))
    self.textServer2:SetText(string.format("#%s", enemyData.serverId))
    self.textAbbr2:SetText(string.format("[%s]", enemyData.abbr))
    self.textName2:SetText(enemyData.name)
    self.textServer2:SetColor(enemyColor)
    self.textAbbr2:SetColor(enemyColor)
    self.textName2:SetColor(enemyColor)
  end
end

function SeasonCampDestroyWarHistoryIR:JumpTo()
  if self.data then
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId)
    if cityInfo == nil then
      return
    end
    local serverId = self.data.serverId
    local pointId = cityInfo:GetPointId()
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPos, nil, nil, nil, serverId)
  end
end

return SeasonCampDestroyWarHistoryIR
