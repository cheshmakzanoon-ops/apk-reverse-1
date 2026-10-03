local base = UIAsyncContainer
local LWUINewBeeMigrateMailBg = BaseClass("LWUINewBeeMigrateMailBg", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LWUINewBeeMigrateMailBg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUINewBeeMigrateMailBg:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUINewBeeMigrateMailBg:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnP1 = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnP1:SetOnClick(function()
    self:OnBtnP1Click()
  end)
  self.btnP2 = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnP2:SetOnClick(function()
    self:OnBtnP2Click()
  end)
  self.btnP3 = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnP3:SetOnClick(function()
    self:OnBtnP3Click()
  end)
  self.btnP4 = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnP4:SetOnClick(function()
    self:OnBtnP4Click()
  end)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.btnPList = {
    self.btnP1,
    self.btnP2,
    self.btnP3,
    self.btnP4
  }
end

function LWUINewBeeMigrateMailBg:ComponentDestroy()
  self.viewSkin = nil
  self.textContent = nil
  self.textReward = nil
  self.compContent = nil
  self.btnP1 = nil
  self.btnP2 = nil
  self.btnP3 = nil
  self.btnP4 = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.btnPList = nil
end

function LWUINewBeeMigrateMailBg:DataDefine()
  self.textContent:SetLocalText("newbee_migration_tips1003", LuaEntry.Player.newBeeMigrateServer)
  if LuaEntry.Player.immigrateSoldierCount == 0 then
    self.btnP3:SetActive(false)
  end
  self.rewardList = DataCenter.ActMigrationManager:GetRewards(1)
  self.asyncs = {}
  local cnt = #self.rewardList
  local scale = 0.62
  for i = 1, cnt do
    local info = self.rewardList[i]
    self.asyncs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = UIUtil.GetLoopListItemIndex("Item_")
      go.gameObject:SetActive(true)
      local tf = go.transform
      tf:SetParent(self.compContent.transform)
      tf:Reset()
      local cell = self.compContent:AddComponent(UICommonResItem, go.name)
      cell:SetLocalScaleXYZ(scale, scale, scale)
      cell:ReInit(info)
    end)
  end
end

function LWUINewBeeMigrateMailBg:DataDestroy()
  self.compContent:RemoveAllComponentes()
  self.asyncs = nil
  self.rewardList = nil
end

function LWUINewBeeMigrateMailBg:OnAddListener()
  base.OnAddListener(self)
end

function LWUINewBeeMigrateMailBg:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUINewBeeMigrateMailBg:OnBtnP1Click()
  self:OnClickPrivileges(1)
end

function LWUINewBeeMigrateMailBg:OnBtnP2Click()
  self:OnClickPrivileges(2)
end

function LWUINewBeeMigrateMailBg:OnBtnP3Click()
  self:OnClickPrivileges(3)
end

function LWUINewBeeMigrateMailBg:OnBtnP4Click()
  self:OnClickPrivileges(4)
end

function LWUINewBeeMigrateMailBg:OnBtnLeftClick()
  if self.view.newBeeMigrateAccept ~= nil then
    return
  end
  self.view.newBeeMigrateAccept = false
  self.view.ctrl:SendNewBeeMigrateMsg(false)
end

function LWUINewBeeMigrateMailBg:OnBtnRightClick()
  if self.view.newBeeMigrateAccept ~= nil then
    return
  end
  self.view.newBeeMigrateAccept = true
  local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
  if 2 < newBeeMigrateWay then
    EventManager:GetInstance():Broadcast(EventId.NewBeeMigratePushMsg)
  else
    self.view.ctrl:SendNewBeeMigrateMsg(true)
  end
end

function LWUINewBeeMigrateMailBg:OnClickPrivileges(idx)
  local btn = self.btnPList[idx]
  local strTip
  if idx == 3 then
    strTip = Localization:GetString("newbee_migration_tips101" .. idx, LuaEntry.Player.immigrateSoldierCount, LuaEntry.Player.immigrateSoldierLv)
  else
    strTip = Localization:GetString("newbee_migration_tips101" .. idx)
  end
  UIUtil.ShowBubbleTips(strTip, btn.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

return LWUINewBeeMigrateMailBg
