local LWUISeasonTowerRankArmyInfoView = BaseClass("LWUISeasonTowerRankArmyInfoView", UIBaseView)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local UIPlayerHead_path = "bossRankObj/UIPlayerHead/HeadIcon"
local content_path = "bossRankObj/ScrollView/Viewport/Content"
local player_name_text_path = "bossRankObj/PlayerNameText"
local power_text_path = "bossRankObj/PowerText"
local tip_text_path = "bossRankObj/tipText"

function LWUISeasonTowerRankArmyInfoView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.uid = param.uid
  self.stageId = param.stageId
  self.playerInfo = param.info
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerStageRecord, {
    uid = param.uid,
    stageId = param.stageId
  })
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerHeadIcon = self:AddComponent(UIPlayerHead, UIPlayerHead_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.player_name_text = self:AddComponent(UIText, player_name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.model = {}
end

function LWUISeasonTowerRankArmyInfoView:OnDestroy()
  self.close_btn = nil
  self.return_btn = nil
  self.playerHeadIcon = nil
  self.content = nil
  self.player_name_text = nil
  self.power_text = nil
  self.tip_text = nil
  base.OnDestroy(self)
end

function LWUISeasonTowerRankArmyInfoView:OnEnable()
  base.OnEnable(self)
end

function LWUISeasonTowerRankArmyInfoView:OnDisable()
  base.OnDisable(self)
end

function LWUISeasonTowerRankArmyInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerStageRecord, self.RefreshView)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.ShowPlayerInfo)
end

function LWUISeasonTowerRankArmyInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTowerStageRecord, self.RefreshView)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.ShowPlayerInfo)
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRankArmyInfoView:RefreshView(t)
  if self.stageId ~= t.stageId or self.uid ~= t.uid then
    return
  end
  self.record = t.records[1] or {}
  self:ShowPlayerInfo(self.uid)
  self:ShowHeroList(t.records[1])
  self.playerHeadIcon:ParseHeadInfo(self.playerInfo)
  local data = t.records[1]
  if data and data.floor then
    self.tip_text:SetText(Localization:GetString("season_tower_show_progress", data.floor))
  end
end

function LWUISeasonTowerRankArmyInfoView:ClearHero()
  self.content:RemoveComponents(UIHeroCellSmall)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function LWUISeasonTowerRankArmyInfoView:ShowPlayerInfo(uid)
  if uid ~= self.uid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  self.player_name_text:SetText(UIUtil.FormatAllianceAndName(user.alAbbr, showName))
  local power = user.power
  if self.record and self.record.power then
    power = self.record.power
  end
  self.power_text:SetText(power)
end

function LWUISeasonTowerRankArmyInfoView:ShowHeroList(unit)
  self:ClearHero()
  if unit == nil then
    return
  end
  local heroes = unit.heroes
  local heroList = table.values(heroes)
  if 0 < #heroList then
    table.sort(heroList, function(heroA, heroB)
      local indexA = heroA.index % 6
      local indexB = heroB.index % 6
      return indexA < indexB
    end)
    for _, heroInfo in pairs(heroList) do
      if self.model[_] == nil then
        self.model[_] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(0.9, 0.9, 1)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.content:AddComponent(UIHeroCellSmall, nameStr)
          cell:InitWithConfigId(heroInfo.heroId, nil, heroInfo.level, heroInfo.rankLv, heroInfo.weaponLevel, heroInfo.awakenLv, heroInfo.skinId)
        end)
      end
    end
  end
end

return LWUISeasonTowerRankArmyInfoView
