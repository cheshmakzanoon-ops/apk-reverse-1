local SeasonDeclareCityHistoryItem = BaseClass("SeasonDeclareCityHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_blue_path = "bgBlue"
local bg_red_path = "bgRed"
local title_path = "title"
local score_path = "score"
local flag_icon1_path = "flagIcon1"
local name1_path = "flagIcon1/Name1"
local win1_path = "flagIcon1/Win1"
local lose1_path = "flagIcon1/Lose1"
local flag_icon2_path = "flagIcon2"
local name2_path = "flagIcon2/Name2"
local win2_path = "flagIcon2/Win2"
local lose2_path = "flagIcon2/Lose2"
local empty_path = "empty"
local pos_path = "pos"
local btn_path = "btn"

function SeasonDeclareCityHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg_blue = self:AddComponent(UIImage, bg_blue_path)
  self.bg_red = self:AddComponent(UIImage, bg_red_path)
  self.title = self:AddComponent(UIText, title_path)
  self.score = self:AddComponent(UIText, score_path)
  self.flag_icon1 = self:AddComponent(UIImage, flag_icon1_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.win1 = self:AddComponent(UIImage, win1_path)
  self.lose1 = self:AddComponent(UIImage, lose1_path)
  self.flag_icon2 = self:AddComponent(UIImage, flag_icon2_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.win2 = self:AddComponent(UIImage, win2_path)
  self.lose2 = self:AddComponent(UIImage, lose2_path)
  self.empty = self:AddComponent(UIText, empty_path)
  self.battleTime = self:AddComponent(UIText, "time")
  self.pos = self:AddComponent(UITextMeshProUGUIEx, pos_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.JumpTo))
end

function SeasonDeclareCityHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareCityHistoryItem:ReInit(data)
  self.data = data
  local fightStartTime = DataCenter.SeasonDataManager.CrossDeclareWarStartTime
  local startTime = data.startTime
  local weekTime = 7 * OneDayTime * 1000
  self.weekIndex = math.min(4, math.max(1, math.ceil((startTime - fightStartTime) / weekTime)))
  self.win1:SetActive(false)
  self.lose1:SetActive(false)
  self.win2:SetActive(false)
  self.lose2:SetActive(false)
  self.score:SetText("")
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(data.cityId)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myData, enemyData
  if data.atk and data.atk.serverId == mySourceServerId then
    self.bg_blue:SetActive(true)
    self.bg_red:SetActive(false)
  else
    self.bg_blue:SetActive(false)
    self.bg_red:SetActive(true)
  end
  if data.atk and data.def then
    if data.atk.serverId == mySourceServerId then
      myData = data.atk
      enemyData = data.def
      if data.result == 1 then
        self.title:SetText("#" .. myData.serverId .. " " .. Localization:GetString("390186"))
        self.score:SetText("+" .. cityInfo.force)
        self.win1:SetActive(true)
        self.lose2:SetActive(true)
      elseif data.result == 2 then
        self.title:SetText("#" .. myData.serverId .. " " .. Localization:GetString("390187"))
        self.lose1:SetActive(true)
        self.win2:SetActive(true)
      end
    else
      myData = data.def
      enemyData = data.atk
      if data.result == 1 then
        self.title:SetText("#" .. enemyData.serverId .. " " .. Localization:GetString("390186"))
        self.score:SetText("+" .. cityInfo.force)
        self.lose1:SetActive(true)
        self.win2:SetActive(true)
      elseif data.result == 2 then
        self.title:SetText("#" .. enemyData.serverId .. " " .. Localization:GetString("390187"))
        self.win1:SetActive(true)
        self.lose2:SetActive(true)
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
      self.title:SetText("#" .. myData.serverId .. " " .. Localization:GetString("390186"))
      self.score:SetText("+" .. cityInfo.force)
      self.win1:SetActive(true)
    elseif data.result == 2 then
      self.title:SetText("#" .. myData.serverId .. " " .. Localization:GetString("390187"))
      self.lose1:SetActive(true)
    end
  end
  self.flag_icon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(myData.icon)))
  self.name1:SetText(string.format("#%s [%s]%s", myData.serverId, myData.abbr, myData.name))
  self.battleTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.startTime))
  self.pos:SetText(string.format("#%s (%s,%s)", data.serverId, cityInfo.pos.x, cityInfo.pos.y))
  if enemyData == nil or string.IsNullOrEmpty(enemyData.abbr) then
    self.flag_icon2:SetActive(false)
    self.empty:SetActive(true)
  else
    self.flag_icon2:SetActive(true)
    self.empty:SetActive(false)
    self.flag_icon2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(enemyData.icon)))
    self.name2:SetText(string.format("#%s [%s]%s", enemyData.serverId, enemyData.abbr, enemyData.name))
  end
end

function SeasonDeclareCityHistoryItem:JumpTo()
  if self.data then
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId)
    local serverId = self.data.serverId
    local pointId = cityInfo:GetPointId()
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPos, nil, nil, nil, serverId)
  end
end

return SeasonDeclareCityHistoryItem
