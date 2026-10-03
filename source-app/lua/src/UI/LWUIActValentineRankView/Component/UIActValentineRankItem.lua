local base = UIBaseContainer
local UIActValentineRankItem = BaseClass("UIActValentineRankItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActValentineRankItem
local rank_image_path = "RankImage"
local rank_text_path = "RankText"
local player_head_path = "UIPlayerHead"
local gender_path = "PlayerInfo/Gender"
local player_name_path = "PlayerInfo/PlayerName"
local score_text_path = "Node/Score/ScoreText"
local star_text_path = "Node/Star/StarText"
local level_type_text = "Node/Star/LevelTypeText"
local score_node_path = "Node/Score"
local star_node_path = "Node/Star"
local tip_btn_path = "TipBtn"
local bg_path = "Bg"
local player_info = "PlayerInfo"
local rank_text_black_path = "RankTextBlack"
local womenIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie00.png"
local manIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie01.png"

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
  self.genderImage = self:AddComponent(UIImage, gender_path)
  self.playerName = self:AddComponent(UIText, player_name_path)
  self.scoreText = self:AddComponent(UIText, score_text_path)
  self.starText = self:AddComponent(UIText, star_text_path)
  self.levelTypeText = self:AddComponent(UIText, level_type_text)
  self.tipBtn = self:AddComponent(UIButton, tip_btn_path)
  self.tipBtn:SetOnClick(function()
    self:OnClickTipBtn()
  end)
  self.scoreNode = self:AddComponent(UIBaseContainer, score_node_path)
  self.starNode = self:AddComponent(UIBaseContainer, star_node_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.playerInfoNode = self:AddComponent(UIBaseContainer, player_info)
  self.rankTextBlack = self:AddComponent(UIText, rank_text_black_path)
end

function M:ComponentDestroy()
  self.rankImage = nil
  self.rankText = nil
  self.playerHead = nil
  self.genderImage = nil
  self.playerName = nil
  self.scoreText = nil
  self.starText = nil
  self.levelTypeText = nil
  self.tipBtn = nil
  self.scoreNode = nil
  self.starNode = nil
  self.bg = nil
  self.rankTextBlack = nil
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

function M:SetData(data, actId, curChannel)
  self.rankData = data
  self.activityId = actId
  self.curChannel = curChannel
  if not self.rankData then
    Logger.LogError("rank data is nil")
    return
  end
  self:RefreshAll()
end

function M:RefreshAll()
  local rank = self.rankData.rank
  if not rank then
    self.rankImage:SetActive(false)
    self.rankText:SetActive(false)
  elseif rank == 0 then
    self.rankImage:SetActive(false)
    self.rankTextBlack:SetLocalText("activity_breakthrough_tips_16")
    self.rankTextBlack:SetActive(true)
    self.rankText:SetActive(false)
  elseif tonumber(rank) <= 3 and 0 < tonumber(rank) then
    local imagePath = "Assets/Main/Sprites/UI/UIActValentineMain/zxl_qingrenjie_paiming" .. rank .. ".png"
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
    self.playerName:SetColor(Color32.black)
  end
  local bgPath = ""
  if self.rankData.isSelf then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
  elseif tonumber(rank) <= 3 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_" .. rank .. ".png"
  else
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
  end
  if not string.IsNullOrEmpty(bgPath) then
    self.bg:LoadSprite(bgPath)
  end
  local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(self.rankData.headSkinId, self.rankData.headSkinET)
  if self.rankData.isSelf then
    local userPic = LuaEntry.Player:GetPic() or ""
    local userPicVer = LuaEntry.Player.picVer or 0
    self.playerHead:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
  else
    self.playerHead:SetData(self.rankData.uid, self.rankData.pic, self.rankData.picVer, nil, headFrame)
  end
  if self.rankData.gender == 1 then
    self.genderImage:SetActive(true)
    self.genderImage:LoadSprite(manIconPath)
  elseif self.rankData.gender == 2 then
    self.genderImage:SetActive(true)
    self.genderImage:LoadSprite(womenIconPath)
  else
    self.genderImage:SetActive(false)
  end
  self.genderImage:SetNativeSize()
  local name = self.rankData.name
  if not string.IsNullOrEmpty(self.rankData.abbr) then
    if self.rankData.isSelf then
      name = self.rankData.abbr .. name
    else
      name = "[" .. self.rankData.abbr .. "]" .. name
    end
  end
  self.playerName:SetText(name)
  if rank then
    if rank == 1 then
      self.playerName:SetColorRGBA255(171, 97, 0, 255)
    elseif rank == 2 then
      self.playerName:SetColorRGBA255(36, 79, 154, 255)
    elseif rank == 3 then
      self.playerName:SetColorRGBA255(145, 99, 78, 255)
    else
      self.playerName:SetColorRGBA255(0, 0, 0, 255)
    end
  end
  if self.rankData.score then
    self.scoreText:SetText(self.rankData.score)
    local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
    if not rData then
      return
    end
    local rankData = rData:GetRankDataByExp(tonumber(self.rankData.score))
    if not rankData then
      return
    end
    self.levelTypeText:SetLocalText(rankData.key_big)
    self.starText:SetText(rankData.star)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scoreNode.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.starNode.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.playerInfoNode.rectTransform)
  self.tipBtn:SetActive(self.rankData.historyFirst == 1 and self.curChannel == ValentineRankType.SelfServer)
end

function M:RefreshScroll()
  if self.rewardRate == nil or #self.rewardRate == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.rewardRate, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:OnClickTipBtn()
  local param = {}
  param.content = Localization:GetString("chocolateStar_rankshow1_desc")
  param.position = self.tipBtn:GetPosition()
  param.deltaX = 0
  param.deltaY = -20
  param.contentX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

return UIActValentineRankItem
