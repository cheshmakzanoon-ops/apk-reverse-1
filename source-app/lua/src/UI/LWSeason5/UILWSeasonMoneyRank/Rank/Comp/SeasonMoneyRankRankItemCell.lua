local base = UIBaseContainer
local SeasonMoneyRankRankItemCell = BaseClass("SeasonMoneyRankRankItemCell", base)
local Localization = CS.GameEntry.Localization
local btn_on_thumb_path = "Btn_OnThumb"
local pop_anim_path = "Btn_OnThumb/PopAnim"
local active_anim_path = "Btn_OnThumb/ActiveAnim"
local name_path = "Name"
local first_name_path = "Name/firstNameTxt"
local second_name_path = "Name/secondNameTxt"
local server_name_path = "Name/serverTxt"
local power_path = "powerTxt"
local num_path = "numTxt"
local num_on_img_path = "numTxtOnImg"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "player"
local alliance_flag_path = "allianceFlag"
local btn_path = "Button"
local bg_path = "bg"
local no_al_path = "NoAL"
local text_no_al_path = "NoAL/TextNoAL"
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function SeasonMoneyRankRankItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonMoneyRankRankItemCell:OnDestroy()
  self.data = nil
  self.isSelf = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMoneyRankRankItemCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.name = self:AddComponent(UIBaseContainer, name_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.power_txt = self:AddComponent(UIText, power_path)
  self.server_txt = self:AddComponent(UIText, server_name_path)
  self.num_txt = self:AddComponent(UIText, num_path)
  self.num_on_img = self:AddComponent(UIText, num_on_img_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_flag_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_flag_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_flag_path)
  self.player_flag = self:AddComponent(UICommonHead, player_flag_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.no_al_root = self:AddComponent(UIImage, no_al_path)
  self.text_no_al = self:AddComponent(UIText, text_no_al_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  if not IsNull(self.transform:Find(btn_on_thumb_path)) then
    self.btn_on_thumb = self:AddComponent(UIButton, btn_on_thumb_path)
    self.btn_on_thumb:SetOnClick(BindCallback(self, self.OnClickThumb))
    self.pop_anim_root = self:AddComponent(UICanvasGroup, pop_anim_path)
    self.theHeartPopAnim = self.pop_anim_root.gameObject
    self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
    self.eff_heart = self.heart_effect.transform:GetComponent(TypeParticleSystem)
    self.theHeartPopAnim:GameObjectCreatePool()
  end
end

function SeasonMoneyRankRankItemCell:ComponentDestroy()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.theHeartPopAnim then
    self.theHeartPopAnim:GameObjectRecycleAll()
  end
  self.name = nil
  self.text_first = nil
  self.text_second = nil
  self.text_power = nil
  self.text_server = nil
  self.text_num = nil
  self.img_first = nil
  self.img_second = nil
  self.img_third = nil
  self.player_flag = nil
  self.alliance_flag = nil
  self.img_no_all = nil
  self.text_no_all = nil
  self.btn = nil
  self.btn_on_thumb = nil
  self.pop_anim_root = nil
  self.theHeartPopAnim = nil
  self.heart_effect = nil
  self.eff_heart = nil
end

function SeasonMoneyRankRankItemCell:SetData(data, isSelf)
  self.data = data
  self.isSelf = isSelf
  self:Refresh()
end

function SeasonMoneyRankRankItemCell:Refresh()
  local textColor = "#2A2830"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4"
  if self.isSelf then
    textColor = "#2A2830"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5"
  elseif self.data.rank == 1 then
    textColor = "#AB6100"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1"
  elseif self.data.rank == 2 then
    textColor = "#3D4D9B"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2"
  elseif self.data.rank == 3 then
    textColor = "#90624D"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3"
  end
  self.bg:LoadSprite(bgPath)
  local isAlliance = self.data.isAlliance
  if isAlliance then
    self.player_flag:SetActive(false)
    if not string.IsNullOrEmpty(self.data.allianceId) then
      self.no_al_root:SetActive(false)
      self.alliance_flag:SetActive(true)
      self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.icon)))
    else
      self.no_al_root:SetActive(true)
      self.text_no_al:SetLocalText(451033)
      self.alliance_flag:SetActive(false)
    end
  else
    self.no_al_root:SetActive(false)
    self.alliance_flag:SetActive(false)
    self.player_flag:SetActive(true)
    self.player_flag:SetHead(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headFrame)
  end
  local rank = checknumber(self.data.rank)
  if 0 < rank then
    if rank <= 3 then
      self.num_on_img:SetActive(true)
      self.num_txt:SetActive(false)
      self.num_on_img:SetText(rank)
    else
      self.num_on_img:SetActive(false)
      self.num_txt:SetActive(true)
      self.num_txt:SetText(self.data.rank)
    end
  else
    self.num_on_img:SetActive(false)
    self.num_txt:SetActive(true)
    self.num_txt:SetLocalText("361054")
  end
  self.first_flag:SetActive(self.data.rank == 1)
  self.second_flag:SetActive(self.data.rank == 2)
  self.third_flag:SetActive(self.data.rank == 3)
  self.power_txt:SetText("<color=" .. textColor .. ">" .. string.GetFormattedSeparatorNum(self.data.score) .. "</color>")
  self.first_txt:SetText("<color=" .. textColor .. ">" .. self.data.firstName .. "</color>")
  self.second_txt:SetActive(false)
  if self.data.serverId ~= nil then
    self.server_txt:SetActive(true)
    local serverStr = Localization:GetString("800941") .. " #" .. self.data.serverId
    self.server_txt:SetText("<color=" .. textColor .. ">" .. serverStr .. "</color>")
  else
    self.server_txt:SetActive(false)
  end
end

function SeasonMoneyRankRankItemCell:OnClick()
  if self.data.serverId and self.data.uid then
    if self.data.isAlliance then
      if not string.IsNullOrEmpty(self.data.allianceId) then
        UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.allianceId, self.data.allianceName)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
        serverId = self.data.serverId,
        uid = self.data.uid
      })
    end
  end
end

function SeasonMoneyRankRankItemCell:OnClickThumb()
  if self.data.uid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
end

return SeasonMoneyRankRankItemCell
