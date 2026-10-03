local UILWSeasonOutpostAttackTab1S6Item = BaseClass("UILWSeasonOutpostAttackTab1S6Item", UIBaseContainer)
local baseContainer = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonOutpostAttackTab1S6Item:OnCreate()
  baseContainer.OnCreate(self)
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.icon = self:AddComponent(UIButton, "icon")
  self.bg = self:AddComponent(UIImage, "")
  self.icon:SetOnClick(function()
    if self.serverId then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGovernmentOfficial) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficial)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverId)
    end
  end)
end

function UILWSeasonOutpostAttackTab1S6Item:OnDestroy()
  self.name = nil
  self.icon = nil
  self.bg = nil
  baseContainer.OnDestroy(self)
end

function UILWSeasonOutpostAttackTab1S6Item:ReInit(campId, serverId)
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
  local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
  if itemCfg ~= nil then
    self.icon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemCfg.icon))
  end
  if campId == 1 then
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_fuwuqibg01.png")
  elseif campId == 2 then
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_fuwuqibg02.png")
  end
  self.name:SetText("#" .. serverId)
  self.serverId = serverId
end

local UILWSeasonOutpostAttackTab1S6 = BaseClass("UILWSeasonOutpostAttackTab1S6", UIAsyncContainer)
local base = UIAsyncContainer
local LWSeasonMainBanner = require("UI.LWSeasonShared.Component.LWSeasonMainBanner")

function UILWSeasonOutpostAttackTab1S6:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self:ComponentDefine()
  self.btn_detail:SetOnClick(function()
    local msg = Localization:GetString("war_zone_outpost_90")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
end

function UILWSeasonOutpostAttackTab1S6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackTab1S6:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.toggleGroup = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.banner = self:AddComponent(LWSeasonMainBanner, "banner")
  self.banner:SetActive(true)
  self.banner:SetParams({
    showJustIconName = true,
    showBg = false,
    ignoreClick = true
  })
  self.btn_detail = self:AddComponent(UIButton, "BtnDetail")
  self.banner:RefreshData()
  self.server1 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server1")
  self.server5 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server5")
  self.server2 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server2")
  self.server6 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server6")
  self.server3 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server3")
  self.server7 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server7")
  self.server4 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server4")
  self.server8 = self:AddComponent(UILWSeasonOutpostAttackTab1S6Item, "ScrollView/Viewport/Content/server8")
end

function UILWSeasonOutpostAttackTab1S6:ComponentDestroy()
  self.banner = nil
  self.btn_detail = nil
  self.content = nil
  self.server1 = nil
  self.server5 = nil
  self.server2 = nil
  self.server6 = nil
  self.server3 = nil
  self.server7 = nil
  self.server4 = nil
  self.server8 = nil
end

function UILWSeasonOutpostAttackTab1S6:ReInit(debugMode, attackActData, battleInfo, battleStartTime, battleEndTime)
  self.debugMode = debugMode
  self.attackActData = attackActData
  self.battleInfo = battleInfo
  self.battleStartTime = battleStartTime
  self.battleEndTime = battleEndTime
end

function UILWSeasonOutpostAttackTab1S6:UpdateData()
  if not self:AsyncLoadDone() then
    return
  end
  local camp1List = {}
  local camp2List = {}
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if seasonInfo and seasonInfo.campInfo and #seasonInfo.campInfo > 0 then
    for _, v in ipairs(seasonInfo.campInfo) do
      if v.campId == SeasonFactionType.Rebels then
        table.insert(camp1List, v.serverId)
      elseif v.campId == SeasonFactionType.Gendarmerie then
        table.insert(camp2List, v.serverId)
      end
    end
  else
    local seasonFactionInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    if seasonFactionInfo then
      for _, v in pairs(seasonFactionInfo) do
        if v.campId == SeasonFactionType.Rebels then
          table.insert(camp1List, v.serverId)
        elseif v.campId == SeasonFactionType.Gendarmerie then
          table.insert(camp2List, v.serverId)
        end
      end
    end
  end
  if 0 < #camp1List and 0 < #camp2List then
    table.sort(camp1List, function(a, b)
      return a < b
    end)
    table.sort(camp2List, function(a, b)
      return a < b
    end)
    local node
    local index = 1
    for _, serverId in ipairs(camp1List) do
      node = self["server" .. index]
      if node then
        node:ReInit(1, serverId)
      end
      index = index + 1
    end
    for _, serverId in ipairs(camp2List) do
      node = self["server" .. index]
      if node then
        node:ReInit(2, serverId)
      end
      index = index + 1
    end
  end
end

return UILWSeasonOutpostAttackTab1S6
