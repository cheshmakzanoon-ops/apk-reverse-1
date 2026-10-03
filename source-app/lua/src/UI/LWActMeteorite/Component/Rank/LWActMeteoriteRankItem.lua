local base = UIBaseContainer
local LWActMeteoriteRankItem = BaseClass("LWActMeteoriteRankItem", base)
local bg_path = "Bg"
local rank_img_path = "RankImg"
local rank_text1_path = "RankImg/RankText1"
local rank_text2_path = "RankText2"
local flag_img_path = "FlagImg"
local head_path = "Head"
local player_head_path = "Head/UIPlayerHead"
local p_info_path = "PInfo"
local p_name_text_path = "PInfo/PNameText"
local power_text_path = "PInfo/Power/PowerText"
local a_info_path = "AInfo"
local a_name_text_path = "AInfo/ANameText"
local slider_path = "AInfo/Slider"
local res_text_path = "AInfo/Slider/ResText"
local coin_text_path = "CoinText"
local RANK_BG_PATH = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_%d.png"
local RANK_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%d.png"

function LWActMeteoriteRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rank_img = self:AddComponent(UIImage, rank_img_path)
  self.rank_text1 = self:AddComponent(UITextMeshProUGUIEx, rank_text1_path)
  self.rank_text2 = self:AddComponent(UITextMeshProUGUIEx, rank_text2_path)
  self.flag_img = self:AddComponent(UIImage, flag_img_path)
  self.flag_btn = self:AddComponent(UIButton, flag_img_path)
  self.flag_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.alInfo ~= nil then
      UIUtil.TryShowAllianceInfo(self.alInfo.serverId, self.alInfo.allianceId, self.alInfo.name)
    end
  end)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.p_info = self:AddComponent(UIBaseContainer, p_info_path)
  self.p_name_text = self:AddComponent(UITextMeshProUGUIEx, p_name_text_path)
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
  self.a_info = self:AddComponent(UIBaseContainer, a_info_path)
  self.a_name_text = self:AddComponent(UITextMeshProUGUIEx, a_name_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.res_text = self:AddComponent(UITextMeshProUGUIEx, res_text_path)
  self.coin_text = self:AddComponent(UITextMeshProUGUIEx, coin_text_path)
end

function LWActMeteoriteRankItem:OnDestroy()
  self.alInfo = nil
  self.bg = nil
  self.rank_img = nil
  self.rank_text1 = nil
  self.rank_text2 = nil
  self.flag_img = nil
  self.head = nil
  self.u_i_player_head = nil
  self.p_info = nil
  self.p_name_text = nil
  self.power_text = nil
  self.a_info = nil
  self.a_name_text = nil
  self.slider = nil
  self.res_text = nil
  self.coin_text = nil
  base.OnDestroy(self)
end

function LWActMeteoriteRankItem:BaseShow(idx, bPerson, bSelf)
  self.head:SetActive(bPerson)
  self.p_info:SetActive(bPerson)
  self.coin_text:SetActive(bPerson)
  self.flag_img:SetActive(not bPerson)
  self.a_info:SetActive(not bPerson)
  self.rank_img:SetActive(0 < idx and idx <= 3)
  self.rank_text2:SetActive(idx <= 0 or 3 < idx)
  if 0 < idx and idx <= 3 then
    self.rank_text1:SetText(idx)
    if bSelf then
      self.bg:LoadSpriteAuto(string.format(LoadPath.LWActMeteoriteBattlePath, "ljq_tongyong_paihangbang_5.png"))
    else
      self.bg:LoadSpriteAuto(string.format(RANK_BG_PATH, idx))
    end
    self.rank_img:LoadSpriteAuto(string.format(RANK_PATH, idx))
  else
    if idx <= 0 then
      self.rank_text2:SetLocalText("100206")
    else
      self.rank_text2:SetText(idx)
    end
    local sPath = bSelf and "ljq_tongyong_paihangbang_5.png" or "zxl_common_diban_lan.png"
    self.bg:LoadSpriteAuto(string.format(LoadPath.LWActMeteoriteBattlePath, sPath))
  end
end

function LWActMeteoriteRankItem:SetData(idx, info, bPerson, maxScore)
  local bSelf = false
  if info then
    if bPerson then
      bSelf = info.uid == LuaEntry.Player.uid
    else
      bSelf = info.allianceId == LuaEntry.Player.allianceId
    end
  end
  self:BaseShow(idx, bPerson, bSelf)
  local curScore = info.score or 0
  if bPerson then
    self.alInfo = nil
    self.player_head:SetHeadAndFrame(info.uid, info.pic, info.picVer, false, info.headSkinId, info.headSkinET)
    self.p_name_text:SetText(UIUtil.FormatServerAllianceName(info.serverId, info.abbr, info.name, info.uid))
    self.power_text:SetText(string.GetFormattedStr0(info.power or 0))
    self.coin_text:SetText(string.GetFormattedStr(curScore))
  else
    self.alInfo = info
    self.flag_img:LoadSpriteAsyncWithCallback(string.format(AL_FLAG_SPRITE_PATH, tostring(info.icon)), function()
      if self.flag_img then
        self.flag_img:SetNativeSize()
      end
    end)
    self.a_name_text:SetText(string.format("[%s] %s", info.abbr, info.name))
    local percent = 0 < maxScore and curScore / maxScore or 0
    self.slider:SetValue(percent)
    self.res_text:SetText(string.GetFormattedSeparatorNum(curScore))
  end
end

function LWActMeteoriteRankItem:SetSelfInfo(rank, score, bPerson, maxScore)
  self:BaseShow(rank or 0, bPerson, true)
  local info = LuaEntry.Player
  local curScore = score or 0
  if bPerson then
    self.alInfo = nil
    local uid = info:GetUid()
    local pic = info:GetPic()
    local picVer = info.picVer
    local headSkinPath = info:GetHeadBgImg()
    self.player_head:SetData(uid, pic, picVer, nil, headSkinPath)
    self.p_name_text:SetText(info:GetFullName())
    self.power_text:SetText(string.GetFormattedStr0(info.power))
    self.coin_text:SetText(string.GetFormattedStr(curScore))
  else
    if string.IsNullOrEmpty(info.allianceId) then
      self.flag_img:SetActive(false)
      self.a_info:SetActive(false)
      return
    end
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self.alInfo = {
      serverId = info:GetSourceServerId(),
      allianceId = info.allianceId,
      name = baseData.allianceName
    }
    self.flag_img:LoadSpriteAsyncWithCallback(string.format(AL_FLAG_SPRITE_PATH, tostring(baseData.icon)), function()
      if self.flag_img then
        self.flag_img:SetNativeSize()
      end
    end)
    self.a_name_text:SetText(string.format("[%s] %s", baseData.abbr, baseData.allianceName))
    local percent = 0 < maxScore and curScore / maxScore or 0
    self.slider:SetValue(percent)
    self.res_text:SetText(string.GetFormattedSeparatorNum(curScore))
  end
end

return LWActMeteoriteRankItem
