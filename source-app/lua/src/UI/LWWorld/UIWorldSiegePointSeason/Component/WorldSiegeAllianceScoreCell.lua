local WorldSiegeAllianceScoreSeasonCell = BaseClass("WorldSiegeAllianceScoreSeasonCell", UIBaseContainer)
local base = UIBaseContainer
local rankBg_path = ""
local rankTxt_path = "rank"
local rankImg_path = "rank/rankImg"
local name_path = "name"
local score_path = "score"

local function OnCreate(self)
  base.OnCreate(self)
  self.rankTxtN = self:AddComponent(UIText, rankTxt_path)
  self.rankImgN = self:AddComponent(UIImage, rankImg_path)
  self.rankBgN = self:AddComponent(UIImage, rankBg_path)
  self.name = self:AddComponent(UIText, name_path)
  self.score = self:AddComponent(UIText, score_path)
end

local function OnDestroy(self)
  self.name = nil
  self.score = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, rank)
  if data ~= nil and not string.IsNullOrEmpty(data.alAbbr) then
    local nameStr = "[" .. data.alAbbr .. "]"
    self.name:SetText(nameStr)
    self.score:SetText(string.GetFormattedSeperatorNum(math.floor(data.point)))
  elseif data ~= nil and not string.IsNullOrEmpty(data.abbr) then
    local nameStr = "[" .. data.abbr .. "]"
    self.name:SetText(nameStr)
    self.score:SetText(string.GetFormattedSeperatorNum(math.floor(data.point)))
  end
  if rank then
    self.rankTxtN:SetText(rank)
    if rank <= 3 then
      self.rankImgN:SetActive(true)
      local path = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_gongcheng_jin.png"
      if rank == 2 then
        path = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_gongcheng_yin.png"
      elseif rank == 3 then
        path = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_gongcheng_tong.png"
      end
      self.rankImgN:LoadSprite(path)
    else
      self.rankImgN:SetActive(false)
    end
  end
end

WorldSiegeAllianceScoreSeasonCell.OnCreate = OnCreate
WorldSiegeAllianceScoreSeasonCell.OnDestroy = OnDestroy
WorldSiegeAllianceScoreSeasonCell.OnEnable = OnEnable
WorldSiegeAllianceScoreSeasonCell.OnDisable = OnDisable
WorldSiegeAllianceScoreSeasonCell.RefreshData = RefreshData
return WorldSiegeAllianceScoreSeasonCell
