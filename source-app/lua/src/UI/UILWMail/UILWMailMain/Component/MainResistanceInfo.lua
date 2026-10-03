local MainResistanceInfo = BaseClass("MainResistanceInfo", UIBaseContainer)
local base = UIBaseContainer
local kx_current_title_path = "KangXing/KangXingCurrent/Content/KXCurrentTitle"
local kx_current_num_path = "KangXing/KangXingCurrent/Content/KXCurrentNum"
local kx_require_title_path = "KangXing/KangXingRequire/Content/KXRequireTitle"
local kx_require_num_path = "KangXing/KangXingRequire/Content/KXRequireNum"
local kx_detail_path = "KangXingMsg/KXDetail"
local btn_path = "KangXingMsg/KangXingMsgBtn"
local viral_img_path = "KangXingMsg/battle_state_btn/viral_img"
local viral_img_ok_path = "KangXingMsg/battle_state_btn/viral_img_ok"
local info_btn_path = "InfoBtn"
local kang_xing_msg_path = "KangXingMsg"

function MainResistanceInfo:OnCreate()
  base.OnCreate(self)
  self.kang_xing_msg = self:AddComponent(UIBaseContainer, kang_xing_msg_path)
  self.info_btn = self:AddComponent(UIImage, info_btn_path)
  self.btn = self:AddComponent(UIButton, "")
  self.kx_bg = self:AddComponent(UIImage, "bg")
  self.kx_current_title = self:AddComponent(UIText, kx_current_title_path)
  self.kx_current_num = self:AddComponent(UIText, kx_current_num_path)
  self.kx_require_title = self:AddComponent(UIText, kx_require_title_path)
  self.kx_require_num = self:AddComponent(UIText, kx_require_num_path)
  self.kx_detail = self:AddComponent(UIText, kx_detail_path)
  self.viral_img = self:AddComponent(UIImage, viral_img_path)
  self.viral_img_ok = self:AddComponent(UIImage, viral_img_ok_path)
  self.msg_btn = self:AddComponent(UIButton, btn_path)
  self.msg_btn:SetOnClick(function()
    self:ShowMsgDetailInfo()
  end)
  self.btn:SetOnClick(function()
    if self.data ~= nil then
      local protoData = self.data:GetProtoData()
      if protoData and SeasonUtil.IsResistanceType1Monster(protoData) then
        return
      end
    end
    self:ShowDetailInfo()
  end)
end

function MainResistanceInfo:OnDestroy()
  self.info_btn = nil
  self.kang_xing_msg = nil
  base.OnDestroy(self)
end

function MainResistanceInfo:ShowMsgDetailInfo()
  if self.msg_btn and self.msg_btn:GetActive() then
    if self.data.subIsMuster then
      if UIUtil.ShowS1HowToPlay(101002) then
        return
      end
    elseif not self.data.isMuster and UIUtil.ShowS1HowToPlay(101001) then
      return
    end
    if self.has_resistance and self.need_resistance > 0 and 0 > self.percent_resistance then
      local selfPercent = SeasonUtil.GetSeasonResistanceSelf(self.has_resistance, self.need_resistance, self.resistance_type) - 1
      local otherPercent = SeasonUtil.GetSeasonResistanceOther(self.has_resistance, self.need_resistance, self.resistance_type)
      UIUtil.ShowResistanceDetail(selfPercent, otherPercent)
    end
  end
end

function MainResistanceInfo:ShowDetailInfo()
  if self.msg_btn and self.msg_btn:GetActive() and self.has_resistance and self.need_resistance > 0 and 0 > self.percent_resistance then
    local selfPercent = SeasonUtil.GetSeasonResistanceSelf(self.has_resistance, self.need_resistance, self.resistance_type) - 1
    local otherPercent = SeasonUtil.GetSeasonResistanceOther(self.has_resistance, self.need_resistance, self.resistance_type)
    UIUtil.ShowResistanceDetail(selfPercent, otherPercent)
  end
end

function MainResistanceInfo:parseEffect(player)
  if player and player.effects and player.effectList == nil then
    player.effectList = {}
    for _, v in ipairs(player.effects) do
      if v and v.effectId and v.value then
        player.effectList[v.effectId] = tonumber(v.value) or 0
      end
    end
  end
end

function MainResistanceInfo:fetchEffect(playerList)
  if playerList then
    local player1 = playerList[1]
    local player2 = playerList[2]
    if player1 and player2 then
      self:parseEffect(player1)
      self:parseEffect(player2)
      local effect1 = player1.effectList and player1.effectList[EffectDefine.APS_SEASON_DESERT_RESISTANCE] or 0
      local effect2 = player2.effectList and player2.effectList[EffectDefine.APS_SEASON_DESERT_RESISTANCE] or 0
      return effect1, effect2
    end
  end
  return 0, 0
end

function MainResistanceInfo:SetData(data)
  self.data = data
  if data == nil or data.targetType == MailTargetType.Player or data.targetType == MailTargetType.DragonBuild or data.targetType == MailTargetType.CityStronghold or data.targetType == MailTargetType.WinterStormBuilding or data.targetType == MailTargetType.EpidemicBuild or data.targetType == MailTargetType.SeasonCenter or data.targetType == MailTargetType.SeasonBuilding or data.type == MailType.LW_ZOMBIE_RUSH_PERSONAL_MAIL or data.type == MailType.LW_ZOMBIE_RUSH_ALLIANCE_MAIL or data.type == MailType.LW_SEASON_AL_CENTER_BATTLE_MAIL or data.player and data.player[1] and data.player[1].armyType == MailTargetType.Monster or data.player and data.player[1] and data.player[1].armyType == MailTargetType.Player and data.player[2] and data.player[2].armyType == MailTargetType.Player then
    return false
  end
  local playerList = data.player
  if playerList then
    local effect1, effect2 = self:fetchEffect(playerList)
    if effect1 == 0 and effect2 == 0 and data.round and data.targetType ~= MailTargetType.SeasonOutpost then
      for k1, v1 in ipairs(data.round) do
        if v1 and v1.battle then
          for k2, v2 in ipairs(v1.battle) do
            if v2 and v2.player then
              effect1, effect2 = self:fetchEffect(v2.player)
              if effect1 ~= 0 or effect2 ~= 0 then
                break
              end
            end
          end
          if effect1 ~= 0 or effect2 ~= 0 then
            break
          end
        end
      end
    end
    if effect2 ~= 0 then
      local protoData = data:GetProtoData()
      local isResistanceType1, resistance_type = SeasonUtil.IsResistanceType1Monster(protoData)
      local percent = 0
      if isResistanceType1 then
        percent = SeasonUtil.GetSeasonResistance1Self(effect1, effect2) - 1
        self.msg_btn:SetInteractable(false)
      else
        percent = SeasonUtil.GetSeasonResistanceSelf(effect1, effect2, resistance_type) - 1
        self.msg_btn:SetInteractable(true)
      end
      self.kx_current_title:SetLocalText("season_tiles_popui_info010")
      self.kx_require_title:SetLocalText("season_tiles_popui_info011")
      self.kx_current_num:SetText(string.GetFormattedSeparatorNum(toInt(effect1)))
      self.kx_require_num:SetText(string.GetFormattedSeparatorNum(toInt(effect2)))
      self.has_resistance = toInt(effect1)
      self.need_resistance = toInt(effect2)
      self.resistance_type = toInt(resistance_type)
      self.percent_resistance = percent
      if percent < 0 then
        self.viral_img:SetActive(false)
        self.viral_img_ok:SetActive(false)
        self.msg_btn:SetActive(true)
        self.info_btn:SetActive(not isResistanceType1)
        self.kx_detail:SetLocalText("season_tiles_popui_info005", string.GetFormattedPercentStr(percent))
        self.kx_detail:SetColorRGBA255(245, 60, 61, 255)
        self.kx_bg:SetColorRGBA255(253, 219, 213, 255)
        self.msg_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UITroops_btn_combat03.png")
      else
        self.viral_img:SetActive(false)
        self.viral_img_ok:SetActive(false)
        self.msg_btn:SetActive(true)
        self.info_btn:SetActive(false)
        self.kx_detail:SetLocalText("season_tiles_popui_info007")
        self.kx_detail:SetColorRGBA255(37, 128, 62, 255)
        self.kx_bg:SetColorRGBA255(222, 234, 225, 255)
        self.msg_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UITroops_btn_combat01.png")
      end
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.kang_xing_msg.rectTransform)
      return true
    end
  end
  return false
end

function MainResistanceInfo:Update1000MS()
  if ComponentIsValid(self.kang_xing_msg) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.kang_xing_msg.rectTransform)
  end
end

return MainResistanceInfo
