local base = UIBaseContainer
local UIAttackCityS0BattleResultCell = BaseClass("UIAttackCityS0BattleResultCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local PlayerItem = require("UI.LWCityAttackS0.HistoryList.Component.UIAttackCityS0BattleResultPlayerItem")
local MAX_PLAYERS = 3

function UIAttackCityS0BattleResultCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0BattleResultCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattleResultCell:ComponentDefine()
  self.btnPop = self:AddComponent(UIButton, "")
  self.btnPop:SetOnClick(function()
    self:OnBtnPopClick()
  end)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgVictoryBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgDefeatBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgCityIcon = self:AddComponent(UIImage, "cityBg/Build/building/cityIcon")
  self.btnPos = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.content = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.playerItems = {}
  table.insert(self.playerItems, self:AddComponent(PlayerItem, "playerContent/PlayerItem1"))
  table.insert(self.playerItems, self:AddComponent(PlayerItem, "playerContent/PlayerItem2"))
  table.insert(self.playerItems, self:AddComponent(PlayerItem, "playerContent/PlayerItem3"))
end

function UIAttackCityS0BattleResultCell:ComponentDestroy()
  self.btnPop = nil
  self.viewSkin = nil
  self.imgVictoryBg = nil
  self.imgDefeatBg = nil
  self.textTime = nil
  self.imgCityIcon = nil
  self.btnPos = nil
  self.textPos = nil
  self.textLevel = nil
  self.content = nil
end

function UIAttackCityS0BattleResultCell:DataDefine()
end

function UIAttackCityS0BattleResultCell:DataDestroy()
end

function UIAttackCityS0BattleResultCell:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0BattleResultCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattleResultCell:OnBtnPosClick()
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
  end
end

function UIAttackCityS0BattleResultCell:ReInit(data)
  self.cityId = data.cityId
  self.battleResult = data.battleResult
  self.battleEndTime = data.battleEndTime
  self.playerList = data.ranks
  self:UpdateBaseInfo()
  self:UpdatePlayerList()
end

function UIAttackCityS0BattleResultCell:UpdateBaseInfo()
  local time = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.battleEndTime)
  self.textTime:SetText(time)
  self.imgVictoryBg.gameObject:SetActive(self.battleResult)
  self.imgDefeatBg.gameObject:SetActive(not self.battleResult)
  local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId)
  if dataConfig ~= nil and dataConfig.pos ~= nil then
    self.textPos:SetText("<u>(" .. dataConfig.pos.x .. "," .. dataConfig.pos.y .. ")</u>")
  else
    self.textPos:SetText("")
  end
  self.dataConfig = dataConfig
  self.textLevel:SetLocalText("city_war_battle_record_04", dataConfig.level)
  self.cityPos = dataConfig.pos
  local iconStr = string.format("Assets/Main/Sprites/UI/LWAllianceZone/Textures/%s.png", dataConfig.city_rally_icon_npc)
  self.imgCityIcon:LoadSprite(iconStr)
end

function UIAttackCityS0BattleResultCell:UpdatePlayerList()
  for i = 1, MAX_PLAYERS do
    local item = self.playerItems[i]
    if item then
      local data = self.playerList[i]
      item:ReInit(data, i, self.cityId)
    end
  end
end

function UIAttackCityS0BattleResultCell:OnBtnPopClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAttackCityS0RecordDetailPop, {anim = true}, self.cityId)
end

return UIAttackCityS0BattleResultCell
