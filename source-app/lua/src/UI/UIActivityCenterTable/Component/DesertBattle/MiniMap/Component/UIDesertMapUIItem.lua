local UIDesertMapUIItem = BaseClass("UIDesertMapUIItem", UIBaseContainer)
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

function UIDesertMapUIItem:OnCreate()
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

function UIDesertMapUIItem:OnDestroy()
  self.build = nil
  base.OnDestroy(self)
end

function UIDesertMapUIItem:OnEnable()
  base.OnEnable(self)
end

function UIDesertMapUIItem:OnDisable()
  base.OnDisable(self)
end

function UIDesertMapUIItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
end

function UIDesertMapUIItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
  base.OnRemoveListener(self)
end

function UIDesertMapUIItem:ReInit(config, mapPointInfo)
  self.config = config
  self.mapPointInfo = mapPointInfo
  self.theAllianceId = nil
  if mapPointInfo ~= nil then
    self.detailInfo = mapPointInfo.detail
    if self.detailInfo ~= nil and self.detailInfo.AllianceId ~= nil then
      self.theAllianceId = self.detailInfo.AllianceId
    end
  else
    self.detailInfo = nil
  end
  self:UpdateStatus()
  self:UpdateMarch()
end

function UIDesertMapUIItem:UpdateStatus()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local detailInfo = self.detailInfo
  local dragonInfo = DataCenter.ActDragonManager:GetActInfo()
  local map_icon = self.config.map_icon
  if self.detailInfo ~= nil then
    self.buildId = self.detailInfo.BuildId or self.detailInfo.ItemId
  end
  if self.detailInfo == nil or self.buildId == 10110 then
    self.time_root:SetActive(false)
    self.txt_root:SetActive(false)
    self.user_root:SetActive(false)
  end
  if detailInfo ~= nil and self.buildId ~= 10110 then
    self.txt_root:SetActive(true)
    local myAllianceId = LuaEntry.Player.allianceId
    if detailInfo.State == 0 then
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
    elseif detailInfo.State == 3 and curTime < detailInfo.OccupyTime then
      self.time_root:SetActive(true)
      self.user_root:SetActive(true)
      self.occupyTime = detailInfo.OccupyTime
      self.txt_state:SetText(Localization:GetString("Desert_strom_tips1058") .. " +" .. self.config.point_produce_per_second .. "/s")
      local aName = dragonInfo:GetAllianceName(detailInfo.AllianceId)
      if detailInfo.AllianceId == myAllianceId then
        map_icon = string.gsub(map_icon, "_huang", "_lan")
        self.user_name:SetText("<color=#15AADF>" .. aName .. "</color>")
      else
        map_icon = string.gsub(map_icon, "_huang", "_hong")
        self.user_name:SetText("<color=#EB393A>" .. aName .. "</color>")
      end
    else
      self.time_root:SetActive(false)
      self.user_root:SetActive(true)
      local speed = self.config.point_produce_per_second
      local bUp, effNum = DataCenter.ActDragonManager:GetBuildUpEffInfo(detailInfo.AllianceId)
      if bUp then
        speed = math.floor(speed * (1 + effNum / 10000))
      end
      self.txt_state:SetText(Localization:GetString("Desert_strom_tips1058") .. "+" .. speed .. "/s")
      local aName = dragonInfo:GetAllianceName(detailInfo.AllianceId)
      if detailInfo.AllianceId == myAllianceId then
        map_icon = string.gsub(map_icon, "_huang", "_lan")
        self.user_name:SetText("<color=#15AADF>" .. aName .. "</color>")
      else
        map_icon = string.gsub(map_icon, "_huang", "_hong")
        self.user_name:SetText("<color=#EB393A>" .. aName .. "</color>")
      end
    end
    self.build:SetLocalScaleXYZ(1, 1, 1)
  else
    self.build:SetLocalScaleXYZ(1, 1, 1)
  end
  local flag = self.build:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDesertDetailPath, map_icon), function()
    if self.build then
      self.build:SetNativeSize()
      self:UpdateTime()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
    end
  end)
  if not flag then
    self:UpdateTime()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  end
end

function UIDesertMapUIItem:UpdateMarch()
  local attackCountRed, attackCountBlue, defenceCountRed, defenceCountBlue = DataCenter.ActDragonManager:GetAttackInfo(self.config.mainIndex, self.theAllianceId)
  if 0 < attackCountBlue and 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(true)
    self.txt_attack1:SetText(attackCountBlue)
    self.txt_attack2:SetText(attackCountRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
    self.attack2:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  elseif 0 < attackCountBlue then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountBlue)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
  elseif 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  else
    self.attack1:SetActive(false)
    self.attack2:SetActive(false)
  end
  self.defence:SetActive(0 < defenceCountRed or 0 < defenceCountBlue)
  self.txt_defence:SetText(defenceCountRed + defenceCountBlue)
  if 0 < defenceCountRed then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangzhushou"))
  elseif 0 < defenceCountBlue then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangzhushou"))
  end
end

function UIDesertMapUIItem:UpdateTime()
  if self.occupyTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.occupyTime - curTime
    if 0 < remainTime then
      local txtTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.time_txt:SetText(Localization:GetString("458195") .. " " .. txtTime)
      print(Localization:GetString("458195") .. " " .. txtTime)
    else
      self.time_root:SetActive(false)
      self.occupyTime = nil
    end
  elseif self.protectTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      local txtTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.time_txt:SetText(Localization:GetString("458192") .. " " .. txtTime)
    else
      self.time_root:SetActive(false)
      self.user_root:SetActive(true)
      self.protectTime = nil
    end
  end
end

return UIDesertMapUIItem
