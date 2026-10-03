local UIBFDsbDuelBattleMapItem = BaseClass("UIBFDsbDuelBattleMapItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local attack1_path = "icon/attack1"
local txt_attack1_path = "icon/attack1/txt_attack1"
local defence_path = "icon/defence"
local txt_defence_path = "icon/defence/txt_defence"
local attack2_path = "icon/attack2"
local txt_attack2_path = "icon/attack2/txt_attack2"
local txt_path = "txt"
local txt_state_path = "txt/txt_state"
local time_path = "time"
local time_txt_path = "time/time_txt"
local user_path = "user"
local user_name_path = "user/user_name"

function UIBFDsbDuelBattleMapItem:OnCreate()
  base.OnCreate(self)
  self.build = self:AddComponent(UIImage, icon_path)
  self.defence = self:AddComponent(UIImage, defence_path)
  self.txt_defence = self:AddComponent(UIText, txt_defence_path)
  self.attack1 = self:AddComponent(UIImage, attack1_path)
  self.txt_attack1 = self:AddComponent(UIText, txt_attack1_path)
  self.attack2 = self:AddComponent(UIImage, attack2_path)
  self.txt_attack2 = self:AddComponent(UIText, txt_attack2_path)
  self.txt_root = self:AddComponent(UIImage, txt_path)
  self.txt_state = self:AddComponent(UIText, txt_state_path)
  self.time_root = self:AddComponent(UIImage, time_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.user_root = self:AddComponent(UIImage, user_path)
  self.user_name = self:AddComponent(UIText, user_name_path)
end

function UIBFDsbDuelBattleMapItem:OnDestroy()
  self.jumpPos = nil
  base.OnDestroy(self)
end

function UIBFDsbDuelBattleMapItem:OnEnable()
  base.OnEnable(self)
end

function UIBFDsbDuelBattleMapItem:OnDisable()
  base.OnDisable(self)
end

function UIBFDsbDuelBattleMapItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
end

function UIBFDsbDuelBattleMapItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelBattleMapItem:ReInit(config, mapPointInfo)
  self.config = config
  self.mapPointInfo = mapPointInfo
  if mapPointInfo ~= nil then
    self.detailInfo = mapPointInfo.detail
    if self.detailInfo ~= nil and self.detailInfo.Role ~= nil then
      self.role = self.detailInfo.Role
    end
  else
    self.detailInfo = nil
  end
  self:UpdateStatus()
  self:UpdateMarch()
end

function UIBFDsbDuelBattleMapItem:UpdateStatus()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local detailInfo = self.detailInfo
  if self.detailInfo ~= nil then
    self.buildId = self.detailInfo.BuildId or self.detailInfo.ItemId
  end
  if self.config == nil or self.config:IsScoreBox() then
    self.time_root:SetActive(false)
    self.txt_root:SetActive(false)
    self.user_root:SetActive(false)
  end
  if self.config then
    if self.config:IsBuild() then
      self.build:LoadSpriteAsyncWithCallback(self.config:GetIconPath(self.role), function()
        if self.build then
          self.build:SetNativeSize()
        end
      end)
      self.txt_root:SetActive(true)
      self.user_root:SetActive(true)
      self.build:SetLocalScaleXYZ(0.3, 0.3, 0.3)
      local state = detailInfo.State
      if state == BattlefieldBuildState.Normal then
        if curTime < detailInfo.OpenTime then
          self.time_root:SetActive(true)
          self.user_root:SetActive(false)
          self.protectTime = detailInfo.OpenTime
        else
          self.time_root:SetActive(false)
          self.user_root:SetActive(true)
        end
        self.txt_state:SetText(Localization:GetString("Desert_strom_tips1058") .. " +" .. self.config.point_produce_per_second .. "/s")
        self.user_name:SetLocalText("458224")
        self.user_name:SetColor(CityLabelWhiteColor)
      else
        self.time_root:SetActive(false)
        self.user_root:SetActive(true)
        local speed = self.config.point_produce_per_second
        self.txt_state:SetText(Localization:GetString("Desert_strom_tips1058") .. "+" .. speed .. "/s")
        local _team = BattlefieldDsbDuelUtils.GetRole(self.role)
        if _team then
          self.user_name:SetText(_team.allianceAbbr)
        end
        local color = BattlefieldDsbDuelUtils.GetColorByRoleType(self.role, true)
        if color then
          self.user_name:SetColor(color.colorLabel)
        end
      end
      self:UpdateTime()
    elseif self.config:IsRes() then
      self.build:LoadSpriteAsyncWithCallback(self.config:GetIconPath(), function()
        if self.build then
          self.build:SetNativeSize()
        end
      end)
      self.txt_root:SetActive(false)
      self.user_root:SetActive(false)
      self.time_root:SetActive(false)
      self.build:SetLocalScaleXYZ(0.2, 0.2, 0.2)
    elseif self.config:IsScoreBox() then
      self.build:LoadSpriteAsyncWithCallback(self.config:GetIconPath(self.role), function()
        if self.build then
          self.build:SetNativeSize()
        end
      end)
      self.txt_root:SetActive(false)
      self.user_root:SetActive(false)
      self.time_root:SetActive(false)
      self.build:SetLocalScaleXYZ(0.15, 0.15, 0.15)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIBFDsbDuelBattleMapItem:UpdateMarch()
  local allianceId = BattlefieldDsbDuelUtils.GetAllianceIdByRoleId(self.role)
  local attackCountRed, attackCountBlue, defenceCountRed, defenceCountBlue = DataCenter.BattlefieldDsbDuelManager:GetAttackInfo(self.config.mainIndex, allianceId)
  if 0 < attackCountBlue and 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(true)
    self.txt_attack1:SetText(attackCountBlue)
    self.txt_attack2:SetText(attackCountRed)
    self.attack1:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
    self.attack2:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  elseif 0 < attackCountBlue then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountBlue)
    self.attack1:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
  elseif 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountRed)
    self.attack1:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  else
    self.attack1:SetActive(false)
    self.attack2:SetActive(false)
  end
  self.defence:SetActive(0 < defenceCountRed or 0 < defenceCountBlue)
  self.txt_defence:SetText(defenceCountRed + defenceCountBlue)
  if 0 < defenceCountRed then
    self.defence:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangzhushou"))
  elseif 0 < defenceCountBlue then
    self.defence:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangzhushou"))
  end
end

function UIBFDsbDuelBattleMapItem:UpdateTime()
  if self.occupyTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.occupyTime - curTime
    if 0 < remainTime then
      local txtTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000)
      self.time_txt:SetText(Localization:GetString("458195") .. " " .. txtTime)
    else
      self.time_root:SetActive(false)
      self.occupyTime = nil
    end
  elseif self.protectTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      local txtTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000)
      self.time_txt:SetText(Localization:GetString("458192") .. " " .. txtTime)
    else
      self.time_root:SetActive(false)
      self.user_root:SetActive(true)
      self.protectTime = nil
    end
  end
end

return UIBFDsbDuelBattleMapItem
