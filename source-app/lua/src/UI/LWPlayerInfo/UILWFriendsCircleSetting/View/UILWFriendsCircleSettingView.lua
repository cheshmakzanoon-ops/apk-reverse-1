local UILWFriendsCircleSettingView = BaseClass("UILWFriendsCircleSettingView", UIBaseView)
local base = UIBaseView
local UILWSettingItem = require("UI.LWPlayerInfo.UILWPlayerRemarkName.UILWChangeRemarkName.Component.UILWSettingItem")

function UILWFriendsCircleSettingView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWFriendsCircleSettingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
end

function UILWFriendsCircleSettingView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  base.OnRemoveListener(self)
end

function UILWFriendsCircleSettingView:OnPlayerDataCallBack(uid)
  if self.playerUid == uid then
    self.config = self.ctrl:GetFriendsCircleSetting(self.playerUid)
    if not self.itemDic then
      return
    end
    for i = 1, #self.config do
      if self.config[i].type and self.itemDic[self.config[i].type] then
        self.itemDic[self.config[i].type]:ReInit(self.config[i])
      end
    end
  end
end

function UILWFriendsCircleSettingView:ReInit()
  self.config = self.ctrl:GetFriendsCircleSetting(self.playerUid)
  if not self.config then
    self.ctrl:CloseSelf()
  end
  self.layout:RemoveComponents(UILWSettingItem)
  self.item:GameObjectRecycleAll()
  local item
  for i = 1, #self.config do
    item = self.item:GameObjectSpawn(self.layout.transform)
    item.name = self.config[i].name .. i
    item:SetActive(true)
    item = self.layout:AddComponent(UILWSettingItem, item.name)
    item:ReInit(self.config[i])
    self.itemDic[self.config[i].type] = item
  end
end

function UILWFriendsCircleSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFriendsCircleSettingView:ComponentDefine()
  self.layout = self:AddComponent(UIBaseContainer, "panel/layout")
  self.item = self.transform:Find("panel/layout/settingItem").gameObject
  self.panelBtn = self:AddComponent(UIButton, "curtain")
  self.closeBtn = self:AddComponent(UIButton, "panel/btnClose")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.item:GameObjectCreatePool()
end

function UILWFriendsCircleSettingView:DataDefine()
  self.playerUid = self:GetUserData()
  self.itemDic = {}
end

function UILWFriendsCircleSettingView:DataDestroy()
  local isSend
  local list = {}
  local number
  for i = 1, #self.config do
    if self.config[i].isOn ~= self.config[i].newIsOn then
      isSend = true
    end
    number = self.config[i].newIsOn and 1 or 0
    table.insert(list, number)
  end
  table.insert(list, 2, 0)
  if isSend then
    SFSNetwork.SendMessage(MsgDefines.SetFriendsCircleSetting, list)
  end
  self.itemDic = nil
  self.playerUid = nil
end

function UILWFriendsCircleSettingView:ComponentDestroy()
  self.layout:RemoveComponents(UILWSettingItem)
  self.item:GameObjectRecycleAll()
  self.layout = nil
  self.item = nil
end

return UILWFriendsCircleSettingView
