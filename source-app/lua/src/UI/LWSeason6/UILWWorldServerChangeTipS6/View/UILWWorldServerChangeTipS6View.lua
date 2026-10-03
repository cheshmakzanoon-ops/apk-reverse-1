local UILWWorldServerChangeTipS6View = BaseClass("UILWWorldServerChangeTipS6View", UIBaseView)
local base = UIBaseView

function UILWWorldServerChangeTipS6View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWWorldServerChangeTipS6View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWWorldServerChangeTipS6View:WorldZoneTipChanged(serverId)
  self:SetDataAndPlay(serverId)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWWorldServerChangeTipS6)
  if window ~= nil then
    UIManager:GetInstance():PlayMoveInAnim(window)
  end
end

function UILWWorldServerChangeTipS6View:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "safeArea/root")
  self.bg = self:AddComponent(UIImage, "safeArea/root/bg")
  self.serverIcon = self:AddComponent(UIImage, "safeArea/root/icon")
  self.player = self:AddComponent(UICommonHead, "safeArea/root/player")
  self.serverName = self:AddComponent(UITextMeshProUGUIEx, "safeArea/root/name")
  self.serverDesc = self:AddComponent(UITextMeshProUGUIEx, "safeArea/root/desc")
  self.boss = self:AddComponent(UIImage, "safeArea/root/Boss")
  self.boss_icon = self:AddComponent(UIImage, "safeArea/root/Boss/bossIcon")
end

function UILWWorldServerChangeTipS6View:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.desc = nil
  self.boss = nil
  self.boss_icon = nil
end

function UILWWorldServerChangeTipS6View:ReInit()
  local data = self:GetUserData()
  self:SetDataAndPlay(data)
end

function UILWWorldServerChangeTipS6View:SetDataAndPlay(serverId)
  self.serverId = toInt(serverId)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if IsNull(self.transform) then
    return
  end
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(self.serverId)
  local king = kingInfo and kingInfo.king or nil
  local cfgId = 511001
  if kingInfo and kingInfo.badges then
    cfgId = kingInfo.badges.cfgId or 511001
  end
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
  if itemCfg then
    self.serverIcon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    self.serverName:SetText("#" .. serverId)
    self.serverDesc:SetText(itemCfg:GetName())
  else
    self.serverIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi00.png")
    self.serverName:SetText("#" .. serverId)
    self.serverDesc:SetText("")
  end
  self.boss:SetActive(false)
  if king ~= nil then
    self.serverIcon:SetActive(false)
    self.player:SetActive(true)
    self.player:ParseHeadInfo(king)
  else
    self.serverIcon:SetActive(true)
    self.player:SetActive(false)
  end
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info ~= nil then
    local center_land_name_list
    local mapIndex = info:GetNinePalacesIndex(serverId)
    if mapIndex == 5 and king == nil then
      self.serverIcon:SetActive(false)
      self.boss:SetActive(true)
      self.boss_icon:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/CityChangeTip/ljq_s6_boss_datouxiang.png")
      self.player:SetActive(false)
    end
    local campId = info:GetCampIdByServerId(serverId)
    if campId == 1 then
      self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/CityChangeTip/ljq_s6_kuafu_bg_03_banner.png")
    elseif campId == 2 then
      self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/CityChangeTip/ljq_s6_kuafu_bg_02_banner.png")
    else
      self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/CityChangeTip/ljq_s6_kuafu_bg_01_banner.png")
    end
    local config = info.currentSeasonConfig or info.seasonConfig
    if config then
      local center_land_name = config.center_land_name
      if not string.IsNullOrEmpty(center_land_name) then
        center_land_name_list = string.split_ss_array(center_land_name, "|")
        self.serverName:SetText("#" .. serverId)
        if #center_land_name_list == 9 then
          self.serverDesc:SetLocalText(center_land_name_list[mapIndex])
        elseif mapIndex == 5 then
          self.serverDesc:SetLocalText(center_land_name)
        end
      end
      if king == nil and mapIndex == 5 then
        local center_land_icon = config.center_land_icon
        if not string.IsNullOrEmpty(center_land_icon) then
          self.boss_icon:LoadSprite(center_land_icon)
          self.serverIcon:SetActive(false)
          self.boss:SetActive(true)
          self.player:SetActive(false)
        end
      end
    end
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.canvasGroup:SetAlpha(1)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
  end, 3)
end

return UILWWorldServerChangeTipS6View
