local WorldSiegeAllianceScoreCell = BaseClass("WorldSiegeAllianceScoreCell", UIBaseContainer)
local base = UIBaseContainer
local rankBg_path = ""
local rankTxt_path = "rank"
local rankImg_path = "rank/rankImg"
local name_path = "name"
local score_path = "score"

local function OnCreate(self)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.score = self:AddComponent(UIText, score_path)
  self.slider = self:AddComponent(UISlider, "slider")
  self.fill = self:AddComponent(UIImage, "slider/Fill Area/Fill")
end

local function OnDestroy(self)
  self.name = nil
  self.score = nil
  self.slider = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, rank, max)
  if not data then
    return
  end
  local abbr
  if not string.IsNullOrEmpty(data.alAbbr) then
    abbr = data.alAbbr
  elseif not string.IsNullOrEmpty(data.abbr) then
    abbr = data.abbr
  end
  local myAbbr
  if LuaEntry.Player:IsInAlliance() then
    local allianceBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseInfo then
      myAbbr = allianceBaseInfo.abbr
    end
  end
  self.name:SetText("[" .. abbr .. "]")
  self.score:SetText(string.GetFormattedSeperatorNum(math.floor(data.point)))
  if myAbbr == abbr then
    self.name:SetColorRGBA(0, 0.57, 0.92, 1)
    self.fill:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_2.png")
  else
    self.name:SetColorRGBA(0.9, 0.25, 0.25, 1)
    self.fill:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_3.png")
  end
  self.slider:SetValue(data.point / max)
end

WorldSiegeAllianceScoreCell.OnCreate = OnCreate
WorldSiegeAllianceScoreCell.OnDestroy = OnDestroy
WorldSiegeAllianceScoreCell.OnEnable = OnEnable
WorldSiegeAllianceScoreCell.OnDisable = OnDisable
WorldSiegeAllianceScoreCell.RefreshData = RefreshData
return WorldSiegeAllianceScoreCell
