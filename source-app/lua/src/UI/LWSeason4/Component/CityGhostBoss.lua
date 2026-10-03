local CityGhostBoss = BaseClass("CityGhostBoss", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local info_btn_path = "top/info/infoBtn"
local desc_path = "top/info/desc"
local attack_tip_y_e_s_path = "AttackTipYES"
local attack_tip_n_o_path = "AttackTipNO"
local h_p_bar_path = "buildHp/HPBar"
local h_p_label_path = "buildHp/HPLabel"
local h_p_title_path = "buildHp/HPTitle"
local name_text_path = "buildDes/soldierlayout/NameText"
local city_add_num_des_path = "buildDes/layout1/cityAddNumDes"
local city_add_num_path = "buildDes/layout1/cityAddNum"
local city_add_num_des_btn1_path = "buildDes/layout1/cityAddNumDesBtn1"
local city_add_num3_path = "buildDes/layout3/cityAddNum3"
local city_add_num_des_btn3_path = "buildDes/layout3/cityAddNumDesBtn3"
local common_btn_detail_1_path = "buildDes/layout1/cityAddNumDesBtn1/Common_btn_detail_1"
local res_item_path = "RewardListSeason/ScrollView/ResItem"
local reward_content_path = "RewardListSeason/ScrollView/Viewport/rewardContent"
local reward_list_season_path = "RewardListSeason"
local tips_label_path = "tipsLabel"
local down_path = "down"
local simple_tip_path = "down/simple_tip"
local viral_path = "viral"
local viral_btn_path = "viral/viral_btn"
local viral_txt_path = "viral/viral_txt"
local viral_img_path = "viral/viral_btn/viral_img"
local viral_img_ok_path = "viral/viral_btn/viral_img_ok"
local viral_bg_path = "viral/viral_bg"

function CityGhostBoss:OnCreate()
  base.OnCreate(self)
  self.viral = self:AddComponent(UIBaseContainer, viral_path)
  self.viral_btn = self:AddComponent(UIButton, viral_btn_path)
  self.viral_txt = self:AddComponent(UIText, viral_txt_path)
  self.viral_img = self:AddComponent(UIImage, viral_img_path)
  self.viral_img_ok = self:AddComponent(UIImage, viral_img_ok_path)
  self.viral_bg = self:AddComponent(UIImage, viral_bg_path)
  self.viral_btn:SetOnClick(function()
    if self.pointData.selfPercent >= 0 then
      UIUtil.ShowTipsId("season_tiles_popui_info007")
      return
    end
    UIUtil.ShowResistanceDetail(self.pointData.selfPercent, self.pointData.otherPercent)
  end)
  self.viral:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.attack_tip_yes = self:AddComponent(UIImage, attack_tip_y_e_s_path)
  self.attack_tip_no = self:AddComponent(UIImage, attack_tip_n_o_path)
  self.h_p_bar = self:AddComponent(UISlider, h_p_bar_path)
  self.h_p_label = self:AddComponent(UITextMeshProUGUIEx, h_p_label_path)
  self.h_p_title = self:AddComponent(UITextMeshProUGUIEx, h_p_title_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.city_add_num_des = self:AddComponent(UITextMeshProUGUIEx, city_add_num_des_path)
  self.city_add_num = self:AddComponent(UITextMeshProUGUIEx, city_add_num_path)
  self.city_add_num_des_btn1 = self:AddComponent(UIButton, city_add_num_des_btn1_path)
  self.city_add_num3 = self:AddComponent(UITextMeshProUGUIEx, city_add_num3_path)
  self.city_add_num_des_btn3 = self:AddComponent(UIButton, city_add_num_des_btn3_path)
  self.common_btn_detail_1 = self:AddComponent(UIButton, common_btn_detail_1_path)
  self.theItem = self.transform:Find(res_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.reward_list_season = self:AddComponent(UIBaseContainer, reward_list_season_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.tips_label = self:AddComponent(UITextMeshProUGUIEx, tips_label_path)
  self.down = self:AddComponent(UIBaseContainer, down_path)
  self.simple_tip = self:AddComponent(UITextMeshProUGUIEx, simple_tip_path)
  self.info_btn:SetOnClick(function()
    local pointData = self.pointData
    local meta = pointData.monsterTemplate
    local title = meta.name
    local desc = Localization:GetString("season_s4_monster_tips16")
    UIUtil.ShowDetail(desc, title)
  end)
  self.city_add_num_des_btn1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.city_add_num_des_btn1, nil, "season_s4_monster_tips26", false)
  end)
  self.common_btn_detail_1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.city_add_num_des_btn1, nil, "season_s4_monster_tips26", false)
  end)
  self.city_add_num_des_btn3:SetOnClick(function()
    UIUtil.ShowButtonTips(self.city_add_num_des_btn3, nil, "302015", false)
  end)
end

function CityGhostBoss:OnDestroy()
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.reward_list_season = nil
  self.common_btn_detail_1 = nil
  self.info_btn = nil
  self.desc = nil
  self.attack_tip_yes = nil
  self.attack_tip_no = nil
  self.h_p_bar = nil
  self.h_p_label = nil
  self.h_p_title = nil
  self.name_text = nil
  self.city_add_num_des = nil
  self.city_add_num = nil
  self.city_add_num_des_btn1 = nil
  self.city_add_num3 = nil
  self.city_add_num_des_btn3 = nil
  self.res_item = nil
  self.reward_content = nil
  self.viral = nil
  self.tips_label = nil
  self.down = nil
  self.simple_tip = nil
  self.time_label = nil
  base.OnDestroy(self)
end

function CityGhostBoss:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityStrongholdMonsterDetailRefresh, self.OnDetailRefresh)
end

function CityGhostBoss:OnRemoveListener()
  self:RemoveUIListener(EventId.CityStrongholdMonsterDetailRefresh, self.OnDetailRefresh)
  base.OnRemoveListener(self)
end

function CityGhostBoss:OnDetailRefresh()
  local pointData = self.pointData
  if IsNull(self.gameObject) or pointData == nil then
    return
  end
  local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(self.uuid)
  if theDetail and toInt(theDetail.curNum) > 0 then
    self.cityBossNum = toInt(theDetail.curNum)
    self.cityBossMax = toInt(theDetail.maxNum)
    if 0 >= self.cityBossMax then
      self.cityBossMax = 1
    end
    self.h_p_title:SetText(Localization:GetString("311058") .. string.percentage(self.cityBossNum, self.cityBossMax, 2))
    self.h_p_label:SetText("")
    self.h_p_bar:SetValue(self.cityBossNum / self.cityBossMax)
  end
end

function CityGhostBoss:UpdateData()
  local pointData = self.pointData
  if IsNull(self.gameObject) or pointData == nil then
    return
  end
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  local myAlId = LuaEntry.Player.allianceId
  local ownerAllianceId = pointData.ownerAllianceId
  local meta = pointData.monsterTemplate
  self.attack_tip_yes:SetActive(pointData.canAttack)
  self.attack_tip_no:SetActive(not pointData.canAttack)
  self.down:SetActive(false)
  if pointData.canAttack then
    local recommend_power = string.format("</color><color=#099B4A>%s</color>", string.GetFormattedSeparatorNum(toInt(meta.recommend_power)))
    local msg = Localization:GetString("300644", recommend_power)
    self.tips_label:SetText("<color=#736863>" .. msg)
    self.simple_tip:SetText("0")
  else
    self.tips_label:SetLocalText("season_s4_monster_tips15")
  end
  if self.cityBossNum and self.cityBossMax then
    self.h_p_title:SetText(Localization:GetString("311058") .. string.percentage(self.cityBossNum, self.cityBossMax, 2))
    self.h_p_label:SetText("")
    self.h_p_bar:SetValue(self.cityBossNum / self.cityBossMax)
  else
    self.h_p_title:SetText(Localization:GetString("311058") .. "???")
    self.h_p_label:SetText("")
    self.h_p_bar:SetValue(0)
  end
  self.desc:SetText(Localization:GetString("2010379", self.cityLevel) .. " " .. Localization:GetString(meta.name))
  self:OnDetailRefresh()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, LuaEntry.Player:GetCurServerId())
  if cityTemplate ~= nil then
    local buff = cityTemplate.buff
    if buff ~= nil then
      local buffArr = string.split(buff, "|")
      if 0 < #buffArr then
        local buffStr = string.split(buffArr[1], ";")
        if 1 < #buffStr then
          local effectId = tonumber(buffStr[1])
          if effectId ~= 30145 then
            local value = tonumber(buffStr[2])
            local buffAddNum, nameStr = UIUtil.GetEffectStr(nil, value, effectId)
            if buffAddNum and nameStr then
              self.city_add_num_des:SetLocalText(nameStr)
              self.city_add_num_des:SetColorHex("#fd7156")
              self.city_add_num:SetText(" " .. buffAddNum)
              self.city_add_num:SetColorHex("#fd7156")
            end
          end
        end
      end
    end
    local dead_rate = ""
    local wounded_rate = cityTemplate.wounded_rate
    local injury_rate = cityTemplate.injury_rate
    if wounded_rate and injury_rate then
      local rate = 100 - wounded_rate - injury_rate
      dead_rate = rate .. "%"
    end
    self.city_add_num3:SetText(dead_rate)
  end
  local nameStr = Localization:GetString("season_city_mori")
  if pointData.cityExtraInfo then
    local alAbbr = pointData.cityExtraInfo.alAbbr
    local alName = pointData.cityExtraInfo.alName
    local allianceId = pointData.cityExtraInfo.allianceId
    local ownerServerId = pointData.cityExtraInfo.serverId
    if not string.IsNullOrEmpty(allianceId) and not string.IsNullOrEmpty(alAbbr) then
      nameStr = UIUtil.FormatServerAllianceName(ownerServerId, alAbbr, alName)
    end
  end
  if isInAlliance and ownerAllianceId == myAlId then
    self.name_text:SetText("<color=#0091e8>" .. nameStr .. "</color>")
  else
    self.name_text:SetText("<color=#2A2830>" .. nameStr .. "</color>")
  end
  if pointData.resistance and 0 < pointData.resistance then
    self.viral:SetActive(true)
    local str1 = string.format("%s/%s", string.GetFormattedSeparatorNum(toInt(pointData.selfValue)), string.GetFormattedSeparatorNum(toInt(pointData.resistance)))
    local str2 = Localization:GetString("season_tiles_popui_info004", str1)
    local str3 = ""
    if 0 > pointData.selfPercent then
      self.viral_img:SetActive(true)
      self.viral_img_ok:SetActive(false)
      str3 = Localization:GetString("season_tiles_popui_info005", string.GetFormattedPercentStr(pointData.selfPercent))
      self.viral_txt:SetText(str2 .. " " .. str3)
      self.viral_bg:SetColorRGBA(1, 0.8901960784313725, 0.8745098039215686, 1)
    else
      self.viral_img:SetActive(false)
      self.viral_img_ok:SetActive(true)
      self.viral_txt:SetText("<color=#0e9500>" .. str2 .. "</color>")
      self.viral_bg:SetColorRGBA(0.8745098039215686, 1, 0.9647058823529412, 1)
    end
  else
    self.viral:SetActive(false)
  end
  local rewardShowDataList = DataCenter.RewardManager:ParseRewardsStr(table.concat(meta.show_reward, "|"))
  local count = table.count(rewardShowDataList)
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.reward_list_season:SetActive(0 < count)
  if 0 < count then
    local goItem, theItem
    for i = 1, count do
      goItem = self.theItem:GameObjectSpawn(self.reward_content.transform)
      goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.reward_content:AddComponent(UICommonResItem, goItem.name)
      theItem:ReInit(rewardShowDataList[i])
    end
  end
end

function CityGhostBoss:RefreshData(pointData)
  self.pointData = pointData
  self.uuid = pointData.uuid
  self.cityId = pointData.cityPointInfo.CityId
  self.cityLevel = pointData.cityPointInfo.CityLevel
  self.cityBossNum = toInt(pointData.cityBossNum)
  self.cityBossMax = toInt(pointData.cityBossMax)
  if self.cityBossMax <= 0 then
    self.cityBossMax = 1
  end
end

return CityGhostBoss
