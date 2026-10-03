local base = UIBaseContainer
local UILWGGGoRankItem = BaseClass("UILWGGGoRankItem.lua", base)
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

function UILWGGGoRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWGGGoRankItem:OnDestroy()
  self.data = nil
  self.isSelf = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoRankItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.name = self:AddComponent(UIBaseContainer, name_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.power_txt = self:AddComponent(UIText, power_path)
  self.server_txt = self:AddComponent(UIText, server_name_path)
  self.num_txt = self:AddComponent(UIText, num_path)
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

function UILWGGGoRankItem:ComponentDestroy()
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

function UILWGGGoRankItem:SetData(data, isSelf)
  self.data = data
  self.isSelf = isSelf
  self:Refresh()
end

function UILWGGGoRankItem:Refresh()
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if self.isSelf then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif self.data.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif self.data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif self.data.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.bg:LoadSprite(bgPath)
  if self.btn_on_thumb then
    self.btn_on_thumb:SetActive(not self.isSelf and self.data.rank <= 3 and self.data.type == LittleGameRankType.Owner)
  end
  self.no_al_root:SetActive(false)
  self.alliance_flag:SetActive(false)
  if self.data.type == LittleGameRankType.Language then
    self.player_flag:SetActive(false)
    self.name:SetAnchoredPositionXY(-200, 0)
  else
    self.player_flag:SetActive(true)
    self.player_flag:SetHead(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headFrame)
    self.name:SetAnchoredPositionXY(-140, 0)
  end
  if type(self.data.rank) == "number" and self.data.rank > 0 then
    self.num_txt:SetText(self.data.rank)
  else
    self.num_txt:SetLocalText("361054")
  end
  self.first_flag:SetActive(self.data.rank == 1)
  self.second_flag:SetActive(self.data.rank == 2)
  self.third_flag:SetActive(self.data.rank == 3)
  local time = self.data.costTimeInMills or 0
  if self.data.trytimes ~= nil then
    self.power_txt:SetText("<color=" .. power_color .. ">" .. time .. "(" .. self.data.trytimes .. ")" .. "</color>")
  else
    self.power_txt:SetText("<color=" .. power_color .. ">" .. time .. "</color>")
  end
  self.first_txt:SetText("<color=" .. first_color .. ">" .. self.data.firstName .. "</color>")
  if self.data.heroId ~= nil and self.data.type == RankingTypeServer.ONE_HERO_POWER then
    local heroName = HeroUtils.GetHeroNameByConfigId(data.heroId)
    if heroName ~= nil and heroName ~= "" then
      heroName = Localization:GetString(heroName)
      self.second_txt:SetActive(true)
      self.second_txt:SetText("<color=" .. second_color .. ">" .. Localization:GetString("200003") .. " : " .. heroName .. "</color>")
    else
      self.second_txt:SetActive(false)
    end
  else
    self.second_txt:SetActive(false)
  end
  if self.data.serverId ~= nil and LuaEntry.Player.serverId ~= self.data.serverId then
    self.server_txt:SetActive(true)
    self.server_txt:SetText(Localization:GetString("800941") .. " #" .. self.data.serverId)
  else
    self.server_txt:SetActive(false)
  end
end

function UILWGGGoRankItem:OnClick()
  if self.data == nil then
    return
  end
  if self.data.type == LittleGameRankType.Language then
    return
  end
  if self.data.serverId and self.data.uid then
    if self.data.isAlliance then
      if not string.IsNullOrEmpty(self.data.uid) then
        if self.view and self.view.OnAllianceDetailClick then
          self.view:OnAllianceDetailClick(self.data.serverId, self.data.uid, self.data.allianceName)
        else
          UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.uid, self.data.allianceName)
        end
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
        serverId = self.data.serverId,
        uid = self.data.uid
      })
    end
  end
end

function UILWGGGoRankItem:OnClickThumb()
  if self.data.uid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  InteractiveUtil.TryThumbsUp(self.data.uid, InteractiveUtil.ThumbsUpType.GGGoRank, "GGGoRank", function(msg)
    self.heart_effect:SetActive(true)
    self.eff_heart:Play()
    local effectItem = self.theHeartPopAnim:GameObjectSpawn(self.btn_on_thumb.transform)
    local textTrans = effectItem.transform:Find("PopAnimText")
    local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    local unity_text = textTrans.gameObject:GetComponent(typeof(CS.TextMeshProUGUIEx))
    if unity_text and unity_canvas_group then
      unity_text.text = "+1"
      effectItem.name = "Count1"
      effectItem:SetActive(true)
      unity_canvas_group.alpha = 1
      unity_canvas_group:DOFade(0, 0.75)
      self.sequence = CS.DG.Tweening.DOTween.Sequence()
      self.sequence:Join(effectItem.transform:DOLocalMove(Vector3.New(0, 50, 0), 0.75):SetEase(CS.DG.Tweening.Ease.OutCirc))
      self.sequence:AppendCallback(function()
        effectItem:GameObjectRecycle()
        self.eff_heart:Stop()
        self.heart_effect:SetActive(false)
      end)
    else
      effectItem:GameObjectRecycle()
    end
  end)
end

return UILWGGGoRankItem
