local base = UIBaseContainer
local UIPositionShare_RedPacketComponent = BaseClass("UIPositionShare_RedPacketComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPositionShare_RedPacketChannelComponent = require("UI/UIPositionShare/Component/RedPacket/UIPositionShare_RedPacketChannelComponent")
local toggleKey = "UIPositionShare_RedPacketComponent_toggleKey"
local channelKey = "UIPositionShare_RedPacketComponent_channelKey"

function UIPositionShare_RedPacketComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPositionShare_RedPacketComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPositionShare_RedPacketComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textSwitch = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 2)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.compChannel = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compWorldChannel = self.viewSkin:AddComponent(self, UIPositionShare_RedPacketChannelComponent, 5)
  self.compSeasonChannel = self.viewSkin:AddComponent(self, UIPositionShare_RedPacketChannelComponent, 6)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compAliFriendChannel = self.viewSkin:AddComponent(self, UIPositionShare_RedPacketChannelComponent, 8)
end

function UIPositionShare_RedPacketComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textSwitch = nil
  self.slider = nil
  self.btnSwitch = nil
  self.compChannel = nil
  self.compWorldChannel = nil
  self.compSeasonChannel = nil
  self.btnLWInfo = nil
  self.compAliFriendChannel = nil
end

function UIPositionShare_RedPacketComponent:DataDefine()
end

function UIPositionShare_RedPacketComponent:DataDestroy()
end

function UIPositionShare_RedPacketComponent:ReInit(packetId)
  self.packetTemplate = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(packetId)
  if self.packetTemplate == nil then
    return
  end
  self.isToggleOn = CommonUtil.PlayerPrefsGetBool(toggleKey, false)
  self.selectChannel = DataCenter.RedPacketManager.ChannelType.World
  local canSelectChannel = self.packetTemplate:GetCanCopyChannelCount() > 1
  if canSelectChannel then
    local defaultChannel = DataCenter.RedPacketManager.ChannelType.World
    self.selectChannel = CommonUtil.PlayerPrefsGetInt(channelKey, defaultChannel)
    self.textSwitch:SetLocalText("egg_sharepos_switch")
  else
    self.textSwitch:SetLocalText("red_pocket_desc2")
  end
  self:RefreshAll()
end

function UIPositionShare_RedPacketComponent:RefreshAll()
  local isShowWorld = self.packetTemplate:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.World)
  local isShowSeason = self.packetTemplate:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.Season)
  local isShowAliFriend = false
  local can_copy_count = 0
  if DataCenter.SeasonAllyFriendManager:HasFriend() then
    isShowAliFriend = self.packetTemplate:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.AliFriend)
    if isShowAliFriend then
      can_copy_count = can_copy_count + 1
    end
  end
  if isShowWorld then
    can_copy_count = can_copy_count + 1
  end
  if isShowSeason then
    can_copy_count = can_copy_count + 1
  end
  local isShowChannel = 1 < can_copy_count and self.isToggleOn == true
  self.compChannel:SetActive(isShowChannel)
  if isShowChannel then
    self.compWorldChannel:SetActive(isShowWorld)
    self.compSeasonChannel:SetActive(isShowSeason)
    self.compAliFriendChannel:SetActive(isShowAliFriend)
    self.compWorldChannel:ReInit(Localization:GetString("egg_sharepos_option1"), self.selectChannel == DataCenter.RedPacketManager.ChannelType.World, function(tf)
      if tf == true then
        CommonUtil.PlayerPrefsSetInt(channelKey, DataCenter.RedPacketManager.ChannelType.World)
        self.selectChannel = DataCenter.RedPacketManager.ChannelType.World
        self:RefreshAll()
        PostEventLog.Track(PostEventLog.Defines.RedPacketShareChannelSwitch, {
          share_type = DataCenter.RedPacketManager.ChannelType.World
        })
      end
    end)
    self.compSeasonChannel:ReInit(Localization:GetString("egg_sharepos_option2"), self.selectChannel == DataCenter.RedPacketManager.ChannelType.Season, function(tf)
      if tf == true then
        CommonUtil.PlayerPrefsSetInt(channelKey, DataCenter.RedPacketManager.ChannelType.Season)
        self.selectChannel = DataCenter.RedPacketManager.ChannelType.Season
        self:RefreshAll()
        PostEventLog.Track(PostEventLog.Defines.RedPacketShareChannelSwitch, {
          share_type = DataCenter.RedPacketManager.ChannelType.Season
        })
      end
    end)
    self.compAliFriendChannel:ReInit(Localization:GetString("egg_sharepos_option3"), self.selectChannel == DataCenter.RedPacketManager.ChannelType.AliFriend, function(tf)
      if tf == true then
        CommonUtil.PlayerPrefsSetInt(channelKey, DataCenter.RedPacketManager.ChannelType.AliFriend)
        self.selectChannel = DataCenter.RedPacketManager.ChannelType.AliFriend
        self:RefreshAll()
        PostEventLog.Track(PostEventLog.Defines.RedPacketShareChannelSwitch, {
          share_type = DataCenter.RedPacketManager.ChannelType.AliFriend
        })
      end
    end)
  end
  if self.isToggleOn then
    self.slider:SetValue(1)
  else
    self.slider:SetValue(0)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compChannel.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIPositionShare_RedPacketComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIPositionShare_RedPacketComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPositionShare_RedPacketComponent:OnBtnSwitchClick()
  if self.packetTemplate == nil then
    return
  end
  self.isToggleOn = not self.isToggleOn
  CommonUtil.PlayerPrefsSetBool(toggleKey, self.isToggleOn)
  local canSelectChannel = self.packetTemplate:GetCanCopyChannelCount() > 1
  self.selectChannel = DataCenter.RedPacketManager.ChannelType.World
  if canSelectChannel and self.isToggleOn == true then
    local defaultChannel = DataCenter.RedPacketManager.ChannelType.World
    self.selectChannel = CommonUtil.PlayerPrefsGetInt(channelKey, defaultChannel)
  end
  self:RefreshAll()
end

function UIPositionShare_RedPacketComponent:OnBtnLWInfoClick()
  if self.packetTemplate == nil then
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(self.packetTemplate.share_info_text, self.packetTemplate.copy_rate / 100)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIPositionShare_RedPacketComponent:GetIsCopyToChat()
  if self.packetTemplate == nil then
    return false
  end
  local canSelectChannel = self.packetTemplate:GetCanCopyChannelCount() > 1
  if canSelectChannel then
    return self.isToggleOn
  else
    return not self.isToggleOn
  end
end

function UIPositionShare_RedPacketComponent:GetCopyChatChannelType()
  return self.selectChannel
end

return UIPositionShare_RedPacketComponent
