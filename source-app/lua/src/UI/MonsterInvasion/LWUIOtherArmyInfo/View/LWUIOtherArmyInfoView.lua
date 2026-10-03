local LWUIOtherArmyInfoView = BaseClass("LWUIOtherArmyInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local UIPlayerHead_path = "bossRankObj/UIPlayerHead/HeadIcon"
local content_path = "bossRankObj/ScrollView/Viewport/Content"
local player_name_text_path = "bossRankObj/PlayerNameText"
local power_text_path = "bossRankObj/PowerText"

function LWUIOtherArmyInfoView:OnCreate()
  base.OnCreate(self)
  self.uid, self.sendMsg = self:GetUserData()
  SFSNetwork.SendMessage(self.sendMsg, self.uid)
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
  self.model = {}
end

function LWUIOtherArmyInfoView:OnDestroy()
  self.close_btn = nil
  self.return_btn = nil
  self.playerHeadIcon = nil
  self.content = nil
  self.player_name_text = nil
  self.power_text = nil
  base.OnDestroy(self)
end

function LWUIOtherArmyInfoView:OnEnable()
  base.OnEnable(self)
end

function LWUIOtherArmyInfoView:OnDisable()
  base.OnDisable(self)
end

function LWUIOtherArmyInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnOtherArmyInfoRefresh, self.RefreshView)
end

function LWUIOtherArmyInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnOtherArmyInfoRefresh, self.RefreshView)
end

function LWUIOtherArmyInfoView:RefreshView(t)
  if not t.ownerUid or self.uid ~= t.ownerUid then
    return
  end
  self:ClearHero()
  self.playerHeadIcon:SetData(self.uid, t.ownerIcon, t.ownerIconVer)
  self.power_text:SetText(t.power)
  if not string.IsNullOrEmpty(t.alAbbr) then
    self.player_name_text:SetText(string.format("[%s]%s", t.alAbbr, t.ownerName))
  else
    self.player_name_text:SetText(t.ownerName)
  end
  if t.armyInfo ~= nil then
    local unit = PBController.ParsePb1(t.armyInfo, "protobuf.ArmyCombatUnit")
    self:ShowHeroList(unit.armyInfo)
  end
end

function LWUIOtherArmyInfoView:ClearHero()
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

function LWUIOtherArmyInfoView:ShowHeroList(unit)
  self:ClearHero()
  if unit == nil then
    return
  end
  local heroes = unit.heroes
  local heroList = table.values(heroes)
  if 0 < #heroList then
    table.sort(heroList, function(heroA, heroB)
      return heroA.index < heroB.index
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
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.content:AddComponent(UIHeroCellSmall, nameStr)
          cell:InitWithConfigId(heroInfo.heroId, heroInfo.heroQuality, heroInfo.heroLevel, heroInfo.rankLv, heroInfo.weaponLevel, heroInfo.awakenLv, heroInfo.heroSkinId)
        end)
      end
    end
  end
end

return LWUIOtherArmyInfoView
