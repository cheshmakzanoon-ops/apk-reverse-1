local UILWPlayerDeatilBattleInfoItem = BaseClass("UILWPlayerDeatilBattleInfoItem", UIBaseContainer)
local base = UIBaseContainer
local careerIconPatch = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/"
local Localization = CS.GameEntry.Localization
local red_dot_path = "redDot"

function UILWPlayerDeatilBattleInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWPlayerDeatilBattleInfoItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.GiftSystemReceivingPrivilege, self.OnReceivingPrivilegeMsg)
end

function UILWPlayerDeatilBattleInfoItem:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.GiftSystemReceivingPrivilege, self.OnReceivingPrivilegeMsg)
  base.OnRemoveListener(self)
end

function UILWPlayerDeatilBattleInfoItem:ComponentDefine()
  self.notCom = self:AddComponent(UIBaseContainer, "not")
  self.icon = self:AddComponent(UIImage, "icon")
  self.text = self:AddComponent(UIText, "text")
  self.bg = self:AddComponent(UIImage, "bg")
  self.btn = self:AddComponent(UIButton, "")
  self.infoIcon = self:AddComponent(UIImage, "icon/info")
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UILWPlayerDeatilBattleInfoItem:OnBtnClick()
  if not self.config then
    return
  end
  if self.config.type == PlayerBattleInfoType.Power then
    if self.data.isSelf then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      UIUtil.OpenPowerOverviewPanel()
    else
      local param = {}
      param.type = "desc"
      param.title = ""
      param.desc = "avatar_mainui_info001"
      param.alignObject = self.icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.config.type == PlayerBattleInfoType.Kill then
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "avatar_mainui_info002"
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.config.type == PlayerBattleInfoType.Career then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCareerClick()
  elseif self.config.type == PlayerBattleInfoType.Gift and self.data.isSelf then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftPrivilege, {anim = true})
  end
end

function UILWPlayerDeatilBattleInfoItem:OnCareerClick()
  if self.notCom:GetActive() then
    return
  end
  if self.data.isSelf then
    local isOpen = DataCenter.MasteryManager:Enabled()
    if isOpen then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      UIUtil.ShowTipsId("season_mastery_error_code_01")
    end
  elseif self.data and self.data.careerType then
    local seasonClassTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.data.careerType)
    if seasonClassTemp then
      local param = {}
      param.itemName = seasonClassTemp.name
      param.itemDesc = seasonClassTemp.description
      param.alignObject = self.icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end
end

function UILWPlayerDeatilBattleInfoItem:ReInit(data, config)
  self.data = data
  self.config = config
  if not self.config or not self.data then
    self:ShowNotIcon(true)
    return
  end
  self:ShowNotIcon(false)
  self.infoIcon:SetActive(false)
  self.red_dot:SetActive(false)
  self.icon:LoadSprite(self.config.icon)
  if self.config.type == PlayerBattleInfoType.Power then
    self.text:SetText(string.GetFormattedStr(data.power or 0))
  elseif self.config.type == PlayerBattleInfoType.Kill then
    self.text:SetText(string.GetFormattedStr(data.kill or 0))
  elseif self.config.type == PlayerBattleInfoType.Career then
    self:InitCareer()
  elseif self.config.type == PlayerBattleInfoType.Gift then
    if IsGiftSystemOpen then
      local giftLevel = 0
      if data.isSelf then
        giftLevel = DataCenter.GiftSystemManager:GetGiftLevel()
        if DataCenter.GiftSystemManager:CheckPrivilegeHaveRedDot() then
          self.red_dot:SetActive(true)
        end
      else
        giftLevel = data.giftLevel or 0
      end
      self.text:SetLocalText("140002", giftLevel)
    else
      self:ShowNotIcon(true)
    end
  end
  self.icon:SetNativeSize()
end

function UILWPlayerDeatilBattleInfoItem:OnReceivingPrivilegeMsg(data)
  if self.data and self.data.isSelf and self.config.type == PlayerBattleInfoType.Gift then
    self.red_dot:SetActive(false)
    if DataCenter.GiftSystemManager:CheckPrivilegeHaveRedDot() then
      self.red_dot:SetActive(true)
    end
  end
end

function UILWPlayerDeatilBattleInfoItem:InitCareer()
  local isMasteryOpen = DataCenter.MasteryManager:Enabled()
  if isMasteryOpen and self.data.careerType ~= MasteryHome.None and toInt(self.data.careerLv) > 0 then
    local seasonClassTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.data.careerType)
    if seasonClassTemp ~= nil then
      self.text:SetText(Localization:GetString("300665", self.data.careerLv))
      self.icon:LoadSprite(careerIconPatch .. seasonClassTemp.icon)
      return
    end
  end
  self:ShowNotIcon(true)
end

function UILWPlayerDeatilBattleInfoItem:ShowNotIcon(isOn)
  self.notCom:SetActive(isOn)
  self.icon:SetActive(not isOn)
  self.text:SetActive(not isOn)
  self.bg:SetActive(not isOn)
end

function UILWPlayerDeatilBattleInfoItem:ComponentDestroy()
  self.notCom = nil
  self.icon = nil
  self.text = nil
  self.btn = nil
  self.red_dot = nil
end

function UILWPlayerDeatilBattleInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDeatilBattleInfoItem:DataDestroy()
  self.data = nil
  self.config = nil
end

return UILWPlayerDeatilBattleInfoItem
