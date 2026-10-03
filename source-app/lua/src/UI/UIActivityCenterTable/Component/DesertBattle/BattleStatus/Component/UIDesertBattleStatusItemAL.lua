local UIDesertBattleStatusItemAL = BaseClass("UIDesertBattleStatusItemAL", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local flag_icon1_path = "flagIcon1"
local server1_path = "flagIcon1/bg/server1"
local name1_path = "name1"
local count11_path = "count11"
local count12_path = "count12"
local count13_path = "count13"

function UIDesertBattleStatusItemAL:OnCreate()
  base.OnCreate(self)
  self.flag_icon1 = self:AddComponent(UIImage, flag_icon1_path)
  self.server1 = self:AddComponent(UIText, server1_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.count11 = self:AddComponent(UIText, count11_path)
  self.count12 = self:AddComponent(UIText, count12_path)
  self.count13 = self:AddComponent(UIText, count13_path)
end

function UIDesertBattleStatusItemAL:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleStatusItemAL:OnEnable()
  base.OnEnable(self)
end

function UIDesertBattleStatusItemAL:OnDisable()
  base.OnDisable(self)
end

function UIDesertBattleStatusItemAL:ReInit(allianceId, data)
  local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
  local vsInfoArr = dragonInfo ~= nil and dragonInfo.vsInfoArr or nil
  if vsInfoArr ~= nil then
    for i, v in ipairs(vsInfoArr) do
      if v.allianceId == allianceId then
        local pointAdd = data.pointAdd or 0
        self.flag_icon1:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
        self.server1:SetText("#" .. v.serverId)
        self.name1:SetText(v:GetFullName())
        self.count11:SetText(string.GetFormattedGoldNum(math.floor(data.score)))
        self.count12:SetText("+" .. pointAdd .. "/s")
        self.count13:SetText(data.currPlayerNum)
        break
      end
    end
  end
end

function UIDesertBattleStatusItemAL:Update1000MS()
end

return UIDesertBattleStatusItemAL
