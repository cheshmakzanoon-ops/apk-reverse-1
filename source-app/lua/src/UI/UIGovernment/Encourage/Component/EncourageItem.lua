local EncourageItem = BaseClass("EncourageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local reward_content_path = "ScrollView/Viewport/RewardContent"

function EncourageItem:OnCreate()
  base.OnCreate(self)
  self.num = self:AddComponent(UIText, "num")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.btn:SetOnClick(function()
    if self.index == 1 then
      self:OnGetBtnClick()
    else
      self:OnGiveBtnClick()
    end
  end)
end

function EncourageItem:OnDestroy()
  self:RemoveItems()
  base.OnDestroy(self)
end

function EncourageItem:RemoveItems()
  self.content:RemoveComponents(UICommonResItem)
  if self.gos then
    for _, v in pairs(self.gos) do
      if not IsNull(v) then
        v:GameObjectRecycle()
      end
    end
  end
  self.gos = {}
end

function EncourageItem:ReInit(cell_index, throneType, serverId)
  self:RemoveItems()
  self.index = cell_index
  self.throneType = throneType
  self.serverId = serverId
  local goItem, theItem
  local configData = DataCenter.WonderGiftTemplateManager:GetTemplateByType(cell_index, self.throneType)
  local extraRewards = configData and DataCenter.RewardManager:ParseRewardsStr(configData.reward_show)
  if extraRewards then
    for i, item in ipairs(extraRewards) do
      local levelName = "item_" .. i
      goItem = self.view.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(item)
      self.gos[i] = goItem
    end
  end
  self.configData = configData
  self:UpdateData()
end

function EncourageItem:UpdateData()
  if self.configData == nil then
    CS.UIGray.SetGray(self.btn.transform, true, false)
    self.num:SetText("0/" .. 0)
    self.thePresent = nil
    return
  end
  local present = DataCenter.GovernmentManager:GetPresentByRewardType(self.index, self.throneType)
  if present ~= nil then
    self.num:SetText(present.useCount .. "/" .. self.configData.num)
    self.isActive = tonumber(present.useCount) < tonumber(self.configData.num)
  else
    self.isActive = false
    self.num:SetText("0/" .. self.configData.num)
  end
  if self.isActive then
    CS.UIGray.SetGray(self.btn.transform, false, true)
  else
    CS.UIGray.SetGray(self.btn.transform, true, false)
  end
  self.thePresent = present
end

function EncourageItem:OnGiveBtnClick()
  if self.thePresent ~= nil and LuaEntry.Player:IsPresident(self.serverId) then
    if ThroneType.Cross == self.throneType then
      local isConqueror = LuaEntry.Player:IsInSourceServer() and DataCenter.GovernmentManager:IsConqueror(LuaEntry.Player:GetSourceServerId())
      if isConqueror then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourageSelectMember, self.index, self.throneType)
      else
        UIUtil.ShowTipsId("conqueror_error_tips01")
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourageSelectMember, self.index, self.throneType)
    end
  else
    UIUtil.ShowTipsId(393018)
  end
end

function EncourageItem:OnGetBtnClick()
  if self.thePresent ~= nil and LuaEntry.Player:IsPresident(self.serverId) then
    if ThroneType.Cross == self.throneType then
      local isConqueror = LuaEntry.Player:IsInSourceServer() and DataCenter.GovernmentManager:IsConqueror(LuaEntry.Player:GetSourceServerId())
      if isConqueror then
        DataCenter.GovernmentManager:KingSendPresent({
          LuaEntry.Player.uid
        }, self.thePresent.presentId)
        CS.UIGray.SetGray(self.btn.transform, true, false)
      else
        UIUtil.ShowTipsId("conqueror_error_tips01")
      end
    else
      DataCenter.GovernmentManager:KingSendPresent({
        LuaEntry.Player.uid
      }, self.thePresent.presentId)
      CS.UIGray.SetGray(self.btn.transform, true, false)
    end
  else
    UIUtil.ShowTipsId(393018)
  end
end

return EncourageItem
