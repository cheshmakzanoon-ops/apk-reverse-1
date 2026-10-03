local p_img_rank_bg_path = "p_img_rank_bg"
local p_text_rank_name_path = "mid/p_text_rank_name"
local p_text_rank_desc_path = "mid/p_text_rank_desc"
local p_text_rank_server_path = "mid/p_text_rank_server"
local p_text_rank_score_path = "right/p_text_rank_score"
local p_go_img_rank_1_path = "rank/p_go_img_rank_1"
local p_go_img_rank_2_path = "rank/p_go_img_rank_2"
local p_go_img_rank_3_path = "rank/p_go_img_rank_3"
local p_text_img_rank_no_path = "rank/p_text_img_rank_no"
local p_text_rank_no_path = "rank/p_text_rank_no"
local p_btn_server_icon_path = "p_btn_server_icon"
local p_img_server_icon_path = "p_btn_server_icon/p_img_server_icon"
local p_img_alliance_flag_path = "p_img_alliance_flag"
local p_comp_player_head_path = "p_comp_player_head"
local p_go_no_alliance_path = "p_go_no_alliance"
local p_text_no_alliance_path = "p_go_no_alliance/p_text_no_alliance"
local p_btn_rank_item_path = "p_btn_rank_item"
local p_btn_thumb_path = "p_btn_thumb"
local p_text_rank_military_time_path = "mid/p_text_rank_military_time"
local p_content_military_auto_path = "mid/p_content_military_auto"
local p_text_rank_military_score_path = "mid/p_content_military_auto/p_text_rank_military_score"
local p_text_rank_military_date_path = "mid/p_content_military_auto/p_text_rank_military_date"
local base = UIBaseContainer
local UILWSeasonMilitaryRankCell = BaseClass("UILWSeasonMilitaryRankCell", UIBaseContainer)

function UILWSeasonMilitaryRankCell:ComponentDefine()
  self.p_img_rank_bg = self:AddComponent(UIImage, p_img_rank_bg_path)
  self.p_text_rank_name = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_name_path)
  self.p_text_rank_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_desc_path)
  self.p_text_rank_server = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_server_path)
  self.p_text_rank_score = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_score_path)
  self.p_go_img_rank_1 = self:AddComponent(UIImage, p_go_img_rank_1_path)
  self.p_go_img_rank_2 = self:AddComponent(UIImage, p_go_img_rank_2_path)
  self.p_go_img_rank_3 = self:AddComponent(UIImage, p_go_img_rank_3_path)
  self.p_text_img_rank_no = self:AddComponent(UITextMeshProUGUIEx, p_text_img_rank_no_path)
  self.p_text_rank_no = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_no_path)
  self.p_btn_server_icon = self:AddComponent(UIButton, p_btn_server_icon_path)
  self.p_img_server_icon = self:AddComponent(UIImage, p_img_server_icon_path)
  self.p_img_alliance_flag = self:AddComponent(UIImage, p_img_alliance_flag_path)
  self.p_comp_player_head = self:AddComponent(UICommonHead, p_comp_player_head_path)
  self.p_go_no_alliance = self:AddComponent(UIImage, p_go_no_alliance_path)
  self.p_text_no_alliance = self:AddComponent(UITextMeshProUGUIEx, p_text_no_alliance_path)
  self.p_btn_rank_item = self:AddComponent(UIButton, p_btn_rank_item_path)
  self.p_btn_rank_item:SetOnClick(BindCallback(self, self.OnItemClicked))
  self.p_btn_thumb = self:AddComponent(UIButton, p_btn_thumb_path)
  self.p_text_rank_military_time = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_military_time_path)
  self.p_content_military_auto = self:AddComponent(UIBaseContainer, p_content_military_auto_path)
  self.p_text_rank_military_score = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_military_score_path)
  self.p_text_rank_military_date = self:AddComponent(UITextMeshProUGUIEx, p_text_rank_military_date_path)
end

function UILWSeasonMilitaryRankCell:ComponentDestroy()
  self.p_img_rank_bg = nil
  self.p_text_rank_name = nil
  self.p_text_rank_desc = nil
  self.p_text_rank_server = nil
  self.p_text_rank_score = nil
  self.p_go_img_rank_1 = nil
  self.p_go_img_rank_2 = nil
  self.p_go_img_rank_3 = nil
  self.p_text_img_rank_no = nil
  self.p_text_rank_no = nil
  self.p_btn_server_icon = nil
  self.p_img_server_icon = nil
  self.p_img_alliance_flag = nil
  self.p_comp_player_head = nil
  self.p_go_no_alliance = nil
  self.p_text_no_alliance = nil
  self.p_btn_rank_item = nil
  self.p_btn_thumb = nil
  self.p_text_rank_military_time = nil
  self.p_content_military_auto = nil
  self.p_text_rank_military_score = nil
  self.p_text_rank_military_date = nil
end

function UILWSeasonMilitaryRankCell:DataDefine()
  self.Data = nil
  self.SkinData = nil
end

function UILWSeasonMilitaryRankCell:DataDestroy()
  self.Data = nil
  self.SkinData = nil
end

function UILWSeasonMilitaryRankCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryRankCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryRankCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  else
    self:InitNotRank()
  end
end

function UILWSeasonMilitaryRankCell:InitData(data)
  if data ~= nil then
    self.Data = data
    self.SkinData = self:GetSkinData()
    return true
  end
  return false
end

function UILWSeasonMilitaryRankCell:InitUi()
  self.p_img_rank_bg:SetActive(true)
  self.p_img_rank_bg:LoadSpriteAsync(self.SkinData.ImgBgPath)
  self:InitRank()
  self:InitMid()
  self:InitRight()
end

function UILWSeasonMilitaryRankCell:InitNotRank()
  self.p_img_rank_bg:SetActive(false)
  self.p_go_no_alliance:SetActive(true)
  self.p_text_no_alliance:SetLocalText("season_military_honor_wall_no_record")
end

function UILWSeasonMilitaryRankCell:InitRank()
  local rank = checknumber(self.Data.Rank)
  self.p_go_img_rank_1:SetActive(rank == 1)
  self.p_go_img_rank_2:SetActive(rank == 2)
  self.p_go_img_rank_3:SetActive(rank == 3)
  self.p_text_img_rank_no:SetText(checkstring(rank))
  self.p_text_img_rank_no:SetActive(rank <= 3)
  self.p_text_rank_no:SetText(checkstring(rank))
  self.p_text_rank_no:SetActive(3 < rank)
end

function UILWSeasonMilitaryRankCell:InitMid()
  if self.Data.IsAlliance then
    self.p_comp_player_head:SetActive(false)
    if not string.IsNullOrEmpty(self.Data.AllianceId) then
      self.p_go_no_alliance:SetActive(false)
      self.p_img_alliance_flag:SetActive(true)
      self.p_img_alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.Data.Icon)))
    else
      self.p_go_no_alliance:SetActive(true)
      self.p_text_no_alliance:SetLocalText(451033)
      self.p_img_alliance_flag:SetActive(false)
    end
  else
    self.p_go_no_alliance:SetActive(false)
    self.p_img_alliance_flag:SetActive(false)
    self.p_comp_player_head:SetActive(true)
    self.p_comp_player_head:SetHead(self.Data.Uid, self.Data.Pic, self.Data.PicVer, nil, self.Data.HeadFrame)
  end
  if not string.IsNullOrEmpty(self.Data.Name) then
    self.p_text_rank_name:SetText(self:GetColoredText(self.SkinData.NameColor, self.Data.Name))
  end
  if not string.IsNullOrEmpty(self.Data.Desc) then
    self.p_text_rank_desc:SetText(self:GetColoredText(self.SkinData.DescColor, self.Data.Desc))
  end
  if not string.IsNullOrEmpty(self.Data.ServerId) then
    local serverStr = CS.GameEntry.Localization:GetString("800941") .. " #" .. self.Data.ServerId
    self.p_text_rank_server:SetText(self:GetColoredText(self.SkinData.ServerColor, serverStr))
  end
  if not table.IsNullOrEmpty(self.Data.ExtraData) then
    if self.Data.ExtraData.Auto then
      self.p_text_rank_military_time:SetActive(false)
      self.p_content_military_auto:SetActive(true)
      self.p_text_rank_military_score:SetText(self.Data.ExtraData.Score)
      self.p_text_rank_military_date:SetText(self.Data.ExtraData.Date)
    else
      self.p_text_rank_military_time:SetActive(true)
      self.p_text_rank_military_time:SetText(self:GetColoredText(self.SkinData.NameColor, self.Data.ExtraData.Time))
      self.p_content_military_auto:SetActive(false)
    end
  end
end

function UILWSeasonMilitaryRankCell:InitRight()
  self.p_text_rank_score:SetActive(not string.IsNullOrEmpty(self.Data.Score))
  if not string.IsNullOrEmpty(self.Data.Score) then
    self.p_text_rank_score:SetText(self:GetColoredText(self.SkinData.ScoreColor, self.Data.Score))
  end
  self.p_btn_thumb:SetActive(false)
end

function UILWSeasonMilitaryRankCell:GetColoredText(color, text)
  return string.format("<color=%s>%s</color>", color, text)
end

function UILWSeasonMilitaryRankCell:GetSkinData()
  local rank = checknumber(self.Data.Rank)
  local skinData = {}
  skinData.NameColor = "#2A2830"
  skinData.DescColor = "#2A2830"
  skinData.ServerColor = "#2A2830"
  skinData.ScoreColor = "#2A2830"
  skinData.ImgBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4"
  if self.Data.IsSelf then
    skinData.NameColor = "#2A2830"
    skinData.ImgBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5"
  elseif rank == 1 then
    skinData.NameColor = "#AB6100"
    skinData.ImgBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1"
  elseif rank == 2 then
    skinData.NameColor = "#3D4D9B"
    skinData.ImgBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2"
  elseif rank == 3 then
    skinData.NameColor = "#90624D"
    skinData.ImgBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3"
  end
  return skinData
end

function UILWSeasonMilitaryRankCell:OnItemClicked()
  if self.Data ~= nil then
    if self.Data.IsAlliance then
      if not string.IsNullOrEmpty(self.Data.AllianceId) then
        UIUtil.TryShowAllianceInfo(self.Data.ServerId, self.Data.AllianceId, self.Data.AllianceName)
      end
    elseif self.Data.Uid ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
        serverId = self.Data.ServerId,
        uid = self.Data.Uid
      })
    end
  end
end

return UILWSeasonMilitaryRankCell
