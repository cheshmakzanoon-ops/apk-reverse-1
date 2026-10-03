local UIWorldServerChangeTipView = BaseClass("UIWorldServerChangeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIWorldServerChangeTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIWorldServerChangeTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldServerChangeTipView:WorldZoneTipChanged(serverId)
  self:SetDataAndPlay(serverId)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIWorldServerChangeTip)
  if window ~= nil then
    UIManager:GetInstance():PlayMoveInAnim(window)
  end
end

function UIWorldServerChangeTipView:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "safeArea/root")
  self.bg = self:AddComponent(UIBaseComponent, "safeArea/root/bg")
  self.serverIcon = self:AddComponent(UIImage, "safeArea/root/icon")
  self.player = self:AddComponent(UICommonHead, "safeArea/root/player")
  self.serverName = self:AddComponent(UITextMeshProUGUIEx, "safeArea/root/name")
  self.serverDesc = self:AddComponent(UITextMeshProUGUIEx, "safeArea/root/desc")
end

function UIWorldServerChangeTipView:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.desc = nil
end

function UIWorldServerChangeTipView:ReInit()
  local data = self:GetUserData()
  self:SetDataAndPlay(data)
end

function UIWorldServerChangeTipView:SetDataAndPlay(serverId)
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
      self.serverIcon:SetActive(true)
      self.serverIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png")
      self.player:SetActive(false)
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
          self.serverIcon:LoadSprite(center_land_icon)
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

return UIWorldServerChangeTipView
