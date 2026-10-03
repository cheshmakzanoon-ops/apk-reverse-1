local LWSeasonFactionGroupMember = BaseClass("LWSeasonFactionGroupMember", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function LWSeasonFactionGroupMember:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.player_btn = self:AddComponent(UIButton, "PlayerBtn")
  self.icon = self:AddComponent(UIImage, "PlayerBtn/icon")
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.power_icon = self:AddComponent(UIImage, "InfoRoot/PowerText/PowerIcon")
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, "InfoRoot/PowerText")
  self.xitu_icon = self:AddComponent(UIImage, "InfoRoot/XituText/XituIcon")
  self.xitu_text = self:AddComponent(UITextMeshProUGUIEx, "InfoRoot/XituText")
  self.xitu_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.pop = self:AddComponent(UIImage, "DoBtn/pop")
  self.num = self:AddComponent(UITextMeshProUGUIEx, "DoBtn/pop/num")
  self.tips_icon = self:AddComponent(UIImage, "TipsIcon")
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "Tips")
  self.pop:SetActive(false)
  self.tips:SetActive(false)
  self.tips_icon:SetActive(false)
  self.res_bg = self:AddComponent(UIImage, "InfoRoot/ResBg")
  self.res_text = self:AddComponent(UITextMeshProUGUIEx, "InfoRoot/ResBg/ResRoot/ResText")
  self.res_tip = self:AddComponent(UITextMeshProUGUIEx, "InfoRoot/ResBg/ResRoot/resTip")
  self.res_icon = self:AddComponent(UIImage, "InfoRoot/ResBg/ResRoot/ResIcon")
  self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.do_btn = self:AddComponent(UIButton, "DoBtn")
  self.do_btn_text = self:AddComponent(UITextMeshProUGUIEx, "DoBtn/DoBtnText")
  self.player_btn:SetOnClick(function()
    UIUtil.TryShowAllianceInfo(self.rankData.serverId, self.rankData.allianceId, self.rankData.name)
  end)
  self.do_btn:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      local myAllianceId = LuaEntry.Player:GetAllianceUid()
      local actObj = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
      if actObj and actObj.currStep == SeasonFactionDeclareWarStep.declare_before then
        UIUtil.ShowTipsId("372114")
      elseif actObj and actObj.currStep == SeasonFactionDeclareWarStep.declare then
        if DataCenter.SeasonFactionWarDataManager:CanJoinAttack(myAllianceId) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarDeclareDlg, {anim = true}, self.rankData)
        else
          UIUtil.ShowTipsId("season_s2_faction_war_tips_01")
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarDeclareDlg, {anim = true}, self.rankData)
      end
    else
      UIUtil.ShowTipsId("2010218")
    end
  end)
  local seasonType = SeasonUtil.GetSeasonType()
  if SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) then
    self.res_tip:SetLocalText("season_s3_activity_1000064_desc01")
  else
    self.res_tip:SetLocalText("season_s2_faction_war_53")
  end
end

function LWSeasonFactionGroupMember:OnDestroy()
  self.player_btn = nil
  self.icon = nil
  self.tips = nil
  self.name_text = nil
  self.power_text = nil
  self.res_text = nil
  self.do_btn = nil
  base.OnDestroy(self)
end

function LWSeasonFactionGroupMember:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDeclareFinish)
end

function LWSeasonFactionGroupMember:OnDisable()
  self:RemoveUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDeclareFinish)
  base.OnDisable(self)
end

function LWSeasonFactionGroupMember:OnDeclareFinish(data)
  if data and data.targetAllianceId and self.rankData and self.rankData.allianceId == data.targetAllianceId then
    self.rankData.enemy = data.enemy
    local enemyCount = toInt(self.rankData.enemyCount)
    if self.rankData.enemy then
      enemyCount = table.count(self.rankData.enemy)
    end
    self.num:SetText(enemyCount)
  end
end

function LWSeasonFactionGroupMember:ReInit(campId, data, view)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  local attackCampId = actInfo.attackCampId
  local currStep = actInfo.currStep
  local hasDeclareWar = false
  self.campId = campId
  self.attackCampId = attackCampId
  self.data = data
  self.rank = data.rank
  self.rankData = data.data
  self.parentView = view
  if attackCampId == campId then
    self.res_bg:SetActive(false)
    self.res_text:SetActive(true)
    self.do_btn:SetActive(false)
    self.tips:SetActive(true)
    self.tips_icon:SetActive(true)
    self.tips:SetLocalText("300717")
    self.tips:SetColorRGBA255(255, 255, 255)
  else
    self.res_bg:SetActive(true)
    self.res_text:SetActive(true)
    self.do_btn:SetActive(true)
    self.tips:SetActive(false)
    self.tips_icon:SetActive(false)
    if currStep == SeasonFactionDeclareWarStep.declare_before then
      self.pop:SetActive(false)
      self.do_btn_text:SetLocalText("season_s2_faction_war_07")
      UIGray.SetGray(self.do_btn.transform, true, true)
    elseif currStep == SeasonFactionDeclareWarStep.declare then
      if campId == myCampId and campId ~= attackCampId then
        self.do_btn_text:SetLocalText("458544")
      elseif DataCenter.SeasonFactionWarDataManager.targetAllianceId == self.rankData.allianceId then
        hasDeclareWar = true
        self.do_btn_text:SetLocalText("season_s2_faction_war_22")
      else
        self.do_btn_text:SetLocalText("season_s2_faction_war_02")
      end
      UIGray.SetGray(self.do_btn.transform, false, true)
    else
      self.do_btn_text:SetLocalText("458544")
      self.pop:SetActive(false)
      UIGray.SetGray(self.do_btn.transform, false, true)
    end
    local enemyCount = toInt(self.rankData.enemyCount)
    if self.rankData.enemy then
      enemyCount = table.count(self.rankData.enemy)
    end
    if enemyCount ~= 0 and (currStep == SeasonFactionDeclareWarStep.declare or currStep == SeasonFactionDeclareWarStep.invite) then
      self.num:SetText(enemyCount)
      self.pop:SetActive(true)
    else
      self.pop:SetActive(false)
    end
  end
  if myAllianceId == self.rankData.allianceId then
    self.bg:SetColorRGBA255(230, 255, 190)
  elseif myCampId == attackCampId then
    if DataCenter.SeasonFactionWarDataManager.targetAllianceId == self.rankData.allianceId then
      self.bg:SetColorRGBA255(251, 217, 215)
    else
      self.bg:SetColorRGBA(1, 1, 1, 1)
    end
  else
    self.bg:SetColorRGBA(1, 1, 1, 1)
  end
  self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.rankData.icon)))
  self.name_text:SetText(Localization:GetString("801140", self.rankData.rank) .. " " .. UIUtil.FormatServerAllianceName(self.rankData.serverId, self.rankData.abbr, self.rankData.name))
  self.power_text:SetLocalText("100392", string.GetFormattedStr(self.rankData.power))
  self.xitu_text:SetText(string.GetFormattedStr(self.rankData.resourceNum))
  local canRobNum = toInt(self.rankData.canRobNum)
  if canRobNum <= 0 then
    local ratio = DataCenter.SeasonFactionWarDataManager:GetPlunderRatio()
    self.res_text:SetText(string.GetFormattedStr(self.rankData.resourceNum * ratio))
  else
    self.res_text:SetText(string.GetFormattedStr(canRobNum))
  end
end

return LWSeasonFactionGroupMember
