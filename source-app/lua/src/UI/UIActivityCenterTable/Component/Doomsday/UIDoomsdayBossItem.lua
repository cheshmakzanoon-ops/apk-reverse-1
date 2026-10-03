local base = UIBaseContainer
local UIDoomsdayBossItem = BaseClass("UIDoomsdayBossItem", base)
local MonsterIDistanceItem = require("UI.UIActivityCenterTable.Component.ActMonsterInvasion.MonsterIDistanceItem")
local Localization = CS.GameEntry.Localization
local fullPath = "Assets/Main/Sprites/HeroIconsBig/%s.png"
local fullBgPath = "Assets/Main/Sprites/UI/UISearch/%s.png"
local defaultBgIcon = "zyf_shijiesouguai_guaiwudikuang"
local superBgIcon = "zxl_sangshiruqin_pinzhi_cheng"

local function __OnClick(self)
  if self.vo and self.vo.targetPos then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldMarchAndOpen(self.vo.targetPos, self.vo.uid)
  end
end

local compBook = {
  {
    path = "imgIcon",
    name = "imgIcon",
    type = UIImage
  },
  {
    path = "imgBg",
    name = "imgBg",
    type = UIImage
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText,
    text = ""
  },
  {
    path = "txtCoords",
    name = "txtCoords",
    type = UIText,
    text = ""
  },
  {
    path = "nodeTime",
    name = "nodeTime",
    type = UIBaseContainer,
    text = ""
  },
  {
    path = "nodeTime/txtTime",
    name = "txtTime",
    type = UIText,
    text = ""
  },
  {
    path = "btn",
    name = "btn",
    type = UIButton,
    onClick = function(self)
      __OnClick(self)
    end
  },
  {
    path = "attacking",
    name = "attacking",
    type = UIBaseContainer
  },
  {
    path = "DistanceGroup",
    name = "distance_group",
    type = MonsterIDistanceItem
  }
}

function UIDoomsdayBossItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayBossItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayBossItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDoomsdayBossItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDoomsdayBossItem:Refresh(vo)
  self.vo = vo
  local levelStr = Localization:GetString("300665", GetTableData(TableName.Monster, vo.monsterId, "level"))
  local nameStr = Localization:GetString(GetTableData(TableName.Monster, vo.monsterId, "name"))
  self.txtName:SetText(levelStr .. " " .. nameStr)
  local coords = SceneUtils.IndexToTilePos(self.vo.targetPos, ForceChangeScene.World)
  local coordsStr = string.format("(%s,%s)", toInt(coords.x), toInt(coords.y))
  self.txtCoords:SetText(coordsStr)
  local monsterIcon = GetTableData(TableName.Monster, vo.monsterId, "pic_name")
  self.imgIcon:LoadSpriteAuto(string.format(fullPath, monsterIcon))
  local special = GetTableData(TableName.Monster, vo.monsterId, "special")
  if tonumber(special) == WorldMonsterSpecialType.SuperRunningBoss then
    self.imgBg:LoadSprite(string.format(fullBgPath, superBgIcon))
  else
    self.imgBg:LoadSprite(string.format(fullBgPath, defaultBgIcon))
  end
  if not self.vo.isRally then
    self.distance_group:ReInit(self.vo.targetPos)
  end
  self.distance_group:SetActive(not self.vo.isRally)
  self.attacking:SetActive(self.vo.isRally)
  self:OnTick()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.nodeTime.transform)
end

function UIDoomsdayBossItem:OnTick()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.vo and self.vo.refreshTime and self.vo.refreshTime - serverTime or 0
  if 0 < remainTime then
    self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    return false
  else
    self.txtTime:SetText("00:00:00")
    return true
  end
end

return UIDoomsdayBossItem
