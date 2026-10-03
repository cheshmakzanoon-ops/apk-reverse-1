local TrainDriverInviteItem = BaseClass("TrainDriverInviteItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TrainDriverInviteItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainDriverInviteItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function TrainDriverInviteItem:ComponentDefine()
  self.head = self:AddComponent(UICommonHead, "head")
  self.name = self:AddComponent(UIText, "Name")
  self.level = self:AddComponent(UIText, "Level")
  self.power = self:AddComponent(UIText, "Power")
  self.toggle = self:AddComponent(UIToggle, "Toggle")
  self.toggle:SetIsOn(false)
  self.toggle:SetOnValueChanged(function(bool)
    if bool then
      if self.nameStr then
        self.view:OnSelect(self.uid, self.nameStr)
      else
        self.view:OnSelect(self.uid)
      end
    end
  end)
  self.online = self:AddComponent(UITextMeshProUGUIEx, "Online")
  self.offline = self:AddComponent(UITextMeshProUGUIEx, "Offline")
  self.cantSelect = self:AddComponent(UITextMeshProUGUIEx, "CantSelect")
end

function TrainDriverInviteItem:ComponentDestroy()
end

function TrainDriverInviteItem:DataDefine()
end

function TrainDriverInviteItem:DataDestroy()
  self.nameStr = nil
end

function TrainDriverInviteItem:Refresh(data, toggleGroup)
  self.uid = data.uid
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.head:SetEnableClickShowInfo(true, true)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, showName))
  self.level:SetLocalText(2010379, data.level)
  self.power:SetText(string.GetFormattedSeparatorNum(data.power))
  self.toggle:SetGroup(toggleGroup)
  self.online:SetActive(data.online)
  self.offline:SetActive(not data.online)
end

function TrainDriverInviteItem:RefreshVip(data, toggleGroup)
  self.online:SetLocalText("alliance_train_vip011")
  self.offline:SetLocalText("alliance_train_vip012")
  self.cantSelect:SetLocalText("alliance_train_vip018")
  self.uid = data.uid
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.head:SetEnableClickShowInfo(true, true)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.nameStr = UIUtil.FormatAllianceAndName(data.abbr, showName)
  self.name:SetText(self.nameStr)
  self.level:SetLocalText(2010379, data.level)
  self.power:SetText(string.GetFormattedSeparatorNum(data.power))
  self.toggle:SetGroup(toggleGroup)
  self.online:SetActive(data.online == 1)
  self.offline:SetActive(data.online == 0)
  self.cantSelect:SetActive(data.online == 2)
  self.toggle:SetActive(data.online ~= 2)
end

return TrainDriverInviteItem
