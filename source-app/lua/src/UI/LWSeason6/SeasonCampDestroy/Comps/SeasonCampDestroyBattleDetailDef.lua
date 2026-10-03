local base = UIBaseContainer
local SeasonCampDestroyBattleDetailDef = BaseClass("SeasonCampDestroyBattleDetailDef", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyBattleDetailDef:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBattleDetailDef:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleDetailDef:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgPIconAllianceFlag = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnPMeInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPMeInfo:SetOnClick(function()
    self:OnBtnPMeInfoClick()
  end)
  self.textPMeAllianceAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPMeAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgPMeCityIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 7)
  self.textPMeCityName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textPMeLocation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnPMeGoto = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnPMeGoto:SetOnClick(function()
    self:OnBtnPMeGotoClick()
  end)
  self.textPDeclareGoto = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.imgIconFriend = self.viewSkin:AddComponent(self, UIImage, 12)
end

function SeasonCampDestroyBattleDetailDef:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgPIconAllianceFlag = nil
  self.btnPMeInfo = nil
  self.textPMeAllianceAbbr = nil
  self.textPMeAllianceName = nil
  self.imgPMeCityIcon = nil
  self.slider = nil
  self.textPMeCityName = nil
  self.textPMeLocation = nil
  self.btnPMeGoto = nil
  self.textPDeclareGoto = nil
  self.imgIconFriend = nil
end

function SeasonCampDestroyBattleDetailDef:DataDefine()
end

function SeasonCampDestroyBattleDetailDef:DataDestroy()
end

function SeasonCampDestroyBattleDetailDef:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyBattleDetailDef:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleDetailDef:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonCampDestroyBattleDetailDef:InitData(data)
  if data ~= nil and not table.IsNullOrEmpty(data.DeclareInfo) then
    self.DeclareInfo = data.DeclareInfo
    self.CityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.DeclareInfo.cityId)
    self.CityId = self.DeclareInfo.cityId
    self.ServerId = self.DeclareInfo.serverId
    self.EndTime = self.DeclareInfo.endTime
    if self.CityInfo ~= nil then
      self.PointId = self.CityInfo:GetPointId()
    end
    return true
  end
  return false
end

function SeasonCampDestroyBattleDetailDef:InitUi()
  local atk = self.DeclareInfo.atk
  if atk == nil then
    self.textPMeAllianceAbbr:SetText("")
    self.textPMeAllianceName:SetText("")
  else
    local allianceAbbr = string.format("#%s [%s]", atk.serverId, atk.abbr)
    self.textPMeAllianceAbbr:SetText(allianceAbbr)
    self.textPMeAllianceName:SetText(atk.name)
  end
  self.imgPMeCityIcon:LoadSpriteAsync(self.CityInfo:GetIconPath(false))
  self.textPMeLocation:SetText(string.format("#%s (X:%s Y:%s)", self.DeclareInfo.serverId, self.CityInfo.pos.x, self.CityInfo.pos.y))
  self.textPDeclareGoto:SetLocalText("season_s5_activity_1200059_desc25")
  local def = self.DeclareInfo.def
  if def ~= nil and not string.IsNullOrEmpty(def.allianceId) then
    local isAlly = DataCenter.SeasonAllyFriendManager:IsMyAllianceFriend(def.allianceId)
    self.imgIconFriend:SetActive(isAlly)
  else
    self.imgIconFriend:SetActive(false)
  end
end

function SeasonCampDestroyBattleDetailDef:UpdateData()
  if self.CityInfo ~= nil then
    self.MaxDurability = checknumber(self.CityInfo.wall)
    self.RecoverSpeed = checknumber(self.CityInfo.wall_recover)
    return true
  end
  return false
end

function SeasonCampDestroyBattleDetailDef:UpdateUi()
  self:Update1000MS()
end

function SeasonCampDestroyBattleDetailDef:UpdateDurability()
  if self.DeclareInfo ~= nil then
    if self.DeclareInfo.durability ~= nil then
      local maxDurability = self.MaxDurability
      local durability = checknumber(self.DeclareInfo.durability)
      local lastDurabilityTime = checknumber(self.DeclareInfo.lastDurabilityTime)
      local cityRecoverSpeed = self.RecoverSpeed
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local addNum = (curTime - lastDurabilityTime) * cityRecoverSpeed
      local realDurabilityNum = durability + math.max(addNum, 0)
      local curDurability = math.min(realDurabilityNum, maxDurability)
      local percent = Mathf.Clamp(curDurability / maxDurability, 0, 1)
      self.slider:SetActive(true)
      self.slider:SetValue(percent)
    else
      self.slider:SetActive(false)
    end
  end
end

function SeasonCampDestroyBattleDetailDef:Update1000MS()
  self:UpdateDurability()
end

function SeasonCampDestroyBattleDetailDef:OnBtnPMeInfoClick()
end

function SeasonCampDestroyBattleDetailDef:OnBtnPMeGotoClick()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

return SeasonCampDestroyBattleDetailDef
