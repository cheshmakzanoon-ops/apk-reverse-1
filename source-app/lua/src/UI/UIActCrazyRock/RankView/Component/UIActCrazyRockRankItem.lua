local base = UIBaseContainer
local UIActCrazyRockRankItem = BaseClass("UIActCrazyRockRankItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockRankItem
local rank_image_path = "RankImage"
local rank_text_path = "RankText"
local player_head_path = "UIPlayerHead"
local player_name_path = "PlayerInfo/PlayerName"
local score_text_path = "ScoreText"
local bg_path = "Bg"
local rank_text_black_path = "RankTextBlack"
local accuracyRateText_text_path = "accuracyRateText"
local allianceName_path = "AllianceName"
local RANK_PATH = "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png"
local bgDict = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.rankImage = self:AddComponent(UIImage, rank_image_path)
  self.rankText = self:AddComponent(UIText, rank_text_path)
  self.playerHead = self:AddComponent(UICommonHead, player_head_path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.playerName = self:AddComponent(UIText, player_name_path)
  self.scoreText = self:AddComponent(UIText, score_text_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rankTextBlack = self:AddComponent(UIText, rank_text_black_path)
  self.accuracyRateText = self:AddComponent(UIText, accuracyRateText_text_path)
  self.allianceName = self:AddComponent(UIText, allianceName_path)
end

function M:ComponentDestroy()
  self.rankImage = nil
  self.rankText = nil
  self.playerHead = nil
  self.playerName = nil
  self.scoreText = nil
  self.bg = nil
  self.rankTextBlack = nil
  self.accuracyRateText = nil
  self.allianceName = nil
end

function M:DataDefine()
  self.rankData = {}
  self.activityId = 0
end

function M:DataDestroy()
  self.rankData = nil
  self.activityId = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(data, actId)
  self.rankData = data
  self.activityId = actId
  if not self.rankData then
    Logger.LogError("rank data is nil")
    return
  end
  self:RefreshAll()
end

function M:RefreshAll()
  local rank = -1
  if not self.rankData.rank or not tonumber(self.rankData.rank) then
    self.rankImage:SetActive(false)
    self.rankText:SetActive(false)
  else
    rank = tonumber(self.rankData.rank)
    if rank == 0 then
      self.rankImage:SetActive(false)
      self.rankTextBlack:SetLocalText("activity_breakthrough_tips_16")
      self.rankTextBlack:SetActive(true)
      self.rankText:SetActive(false)
    elseif rank <= 3 and 0 < rank then
      local imagePath = string.format(RANK_PATH, rank)
      self.rankImage:LoadSprite(imagePath)
      self.rankImage:SetActive(true)
      self.rankTextBlack:SetActive(false)
      self.rankText:SetActive(true)
      self.rankText:SetText(rank)
    else
      self.rankImage:SetActive(false)
      self.rankTextBlack:SetActive(true)
      self.rankText:SetActive(false)
      self.rankTextBlack:SetText(rank)
    end
  end
  local bgPath = ""
  if not self.rankData.isSelf then
    if rank <= 3 then
      bgPath = bgDict[rank]
    else
      bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
    end
  else
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
  end
  if not string.IsNullOrEmpty(bgPath) then
    self.bg:LoadSpriteAsync(bgPath)
  end
  local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(self.rankData.headSkinId, self.rankData.headSkinET)
  if self.rankData.isSelf then
    local userPic = LuaEntry.Player:GetPic() or ""
    local userPicVer = LuaEntry.Player.picVer or 0
    self.playerHead:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
  else
    self.playerHead:SetData(self.rankData.uid, self.rankData.pic, self.rankData.picVer, nil, headFrame)
  end
  local name = self.rankData.name
  local allianceName = self.rankData.abbr or ""
  if not string.IsNullOrEmpty(allianceName) and not self.rankData.isSelf then
    allianceName = "[" .. allianceName .. "]"
  end
  local server = self.rankData.serverId or ""
  if not string.IsNullOrEmpty(server) then
    allianceName = "#" .. server .. allianceName
  end
  self.playerName:SetText(name)
  self.allianceName:SetText(allianceName)
  local rate = "-"
  if self.rankData.accuracyRate and tonumber(self.rankData.accuracyRate) and 0 < tonumber(self.rankData.accuracyRate) then
    rate = tostring(self.rankData.accuracyRate) .. "%"
  end
  self.accuracyRateText:SetText(rate)
  if self.rankData.score then
    if tonumber(self.rankData.score) == 0 then
      self.scoreText:SetText("-")
    else
      self.scoreText:SetText(self.rankData.score)
    end
  end
  local color = {
    0,
    0,
    0,
    255
  }
  if rank then
    if rank == 1 then
      color = {
        171,
        97,
        0,
        255
      }
    elseif rank == 2 then
      color = {
        61,
        77,
        155,
        255
      }
    elseif rank == 3 then
      color = {
        144,
        98,
        77,
        255
      }
    else
      color = {
        0,
        0,
        0,
        255
      }
    end
  end
  self.playerName:SetColorRGBA255(color[1], color[2], color[3], color[4])
  self.allianceName:SetColorRGBA255(color[1], color[2], color[3], color[4])
  self.accuracyRateText:SetColorRGBA255(color[1], color[2], color[3], color[4])
  self.scoreText:SetColorRGBA255(color[1], color[2], color[3], color[4])
end

return UIActCrazyRockRankItem
