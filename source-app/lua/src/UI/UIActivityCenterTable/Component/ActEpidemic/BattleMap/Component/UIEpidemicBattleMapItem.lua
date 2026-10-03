local UIEpidemicBattleMapItem = BaseClass("UIEpidemicBattleMapItem", UIBaseContainer)
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

function UIEpidemicBattleMapItem:OnCreate()
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

function UIEpidemicBattleMapItem:OnDestroy()
  self.build = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleMapItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
end

function UIEpidemicBattleMapItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.UpdateMarch)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.UpdateMarch)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleMapItem:ReInit(config, mapPointInfo)
  self.config = config
  self.mapPointInfo = mapPointInfo
  self.mainIndex = nil
  self.detailInfo = nil
  self.buildId = nil
  self.theRole = nil
  if mapPointInfo ~= nil then
    self.mainIndex = mapPointInfo.mainIndex
    self.detailInfo = mapPointInfo.detail
    self.buildId = self.detailInfo ~= nil and self.detailInfo.BuildId or nil
    self.theRole = self.detailInfo ~= nil and self.detailInfo.Role or EpidemicZoneRole.Default
  end
  self:UpdateStatus()
  self:UpdateMarch()
end

function UIEpidemicBattleMapItem:UpdateStatus()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local detailInfo = self.detailInfo
  self.txt_root:SetActive(false)
  local map_icon = self.config.map_icon
  if detailInfo == nil then
    self.time_root:SetActive(false)
    self.user_root:SetActive(false)
  else
    local curRole = DataCenter.ActEpidemicZoneManager:GetCurRole()
    if detailInfo.State == EpidemicBuildState.Normal then
      if curTime < detailInfo.OpenTime then
        self.time_root:SetActive(true)
        self.user_root:SetActive(false)
        self.protectTime = detailInfo.OpenTime
      else
        self.time_root:SetActive(false)
        self.user_root:SetActive(true)
      end
      self.user_name:SetLocalText("458224")
    elseif detailInfo.State == EpidemicBuildState.Occupied then
      self.time_root:SetActive(false)
      self.user_root:SetActive(true)
      local name = Localization:GetString("YiBianJinQu_role_name_" .. self.theRole + 1)
      if self.theRole == curRole then
        map_icon = string.gsub(map_icon, "_huang", "_lan")
        self.user_name:SetText("<color=#15AADF>" .. name .. "</color>")
      else
        map_icon = string.gsub(map_icon, "_huang", "_hong")
        self.user_name:SetText("<color=#EB393A>" .. name .. "</color>")
      end
    end
    self.build:SetLocalScaleXYZ(1, 1, 1)
  end
  self:UpdateTime()
  local build = self.build
  local rt = self.rectTransform
  local flag = build:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldEpidemicDetailPath, map_icon, nil), function()
    if IsNotNull(rt) and IsNotNull(build.unity_image) then
      build:SetNativeSize()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rt)
    end
  end)
  if not flag then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rt)
  end
end

function UIEpidemicBattleMapItem:UpdateMarch()
  local atkCntRed, atkCntBlue, defCntRed, defCntBlue = DataCenter.ActEpidemicZoneManager:GetAttackInfo(self.mainIndex, self.theRole)
  if 0 < atkCntBlue and 0 < atkCntRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(true)
    self.txt_attack1:SetText(atkCntBlue)
    self.txt_attack2:SetText(atkCntRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
    self.attack2:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  elseif 0 < atkCntBlue then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(atkCntBlue)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
  elseif 0 < atkCntRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(atkCntRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  else
    self.attack1:SetActive(false)
    self.attack2:SetActive(false)
  end
  self.defence:SetActive(0 < defCntRed or 0 < defCntBlue)
  self.txt_defence:SetText(defCntRed + defCntBlue)
  if 0 < defCntRed then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangzhushou"))
  elseif 0 < defCntBlue then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangzhushou"))
  end
end

function UIEpidemicBattleMapItem:UpdateTime()
  if self.protectTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.protectTime - curTime
  if 0 < remainTime then
    local txtTime = UITimeManager:GetInstance():SecondToFmtString(remainTime)
    self.time_txt:SetText(Localization:GetString("458192") .. " " .. txtTime)
  else
    self.time_root:SetActive(false)
    self.user_root:SetActive(true)
    self.protectTime = nil
  end
end

return UIEpidemicBattleMapItem
