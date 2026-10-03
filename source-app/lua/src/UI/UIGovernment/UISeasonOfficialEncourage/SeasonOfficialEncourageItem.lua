local SeasonOfficialEncourageItem = BaseClass("SeasonOfficialEncourageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local reward_content_path = "ScrollView/Viewport/RewardContent"

function SeasonOfficialEncourageItem:OnCreate()
  base.OnCreate(self)
  self.num = self:AddComponent(UIText, "num")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.btn:SetOnClick(function()
    if self.index == 1 then
      self:OnGetBtnClick()
    else
      self:OnGiveBtnClick()
    end
  end)
end

function SeasonOfficialEncourageItem:OnDestroy()
  self:RemoveItems()
  base.OnDestroy(self)
end

function SeasonOfficialEncourageItem:RemoveItems()
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

function SeasonOfficialEncourageItem:ReInit(cell_index, govType, serverId, buildingId)
  self:RemoveItems()
  self.index = cell_index
  self.throneType = GovOfficialType2ThroneType[govType]
  self.govOfficialType = govType
  self.serverId = serverId
  self.buildingId = buildingId
  local goItem, theItem
  local configData = DataCenter.WonderGiftTemplateManager:GetTemplateByType(cell_index, self.throneType)
  if configData then
    self.title:SetLocalText(configData.name)
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
  end
  self.configData = configData
  self:UpdateData()
end

function SeasonOfficialEncourageItem:UpdateData()
  if self.configData == nil then
    CS.UIGray.SetGray(self.btn.transform, true, false)
    self.num:SetText("0/" .. 0)
    self.thePresent = nil
    return
  end
  local present = DataCenter.BuildingOfficialManager:GetPresentByRewardType(self.index, self.serverId, self.buildingId)
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

function SeasonOfficialEncourageItem:OnGiveBtnClick()
  if self.thePresent ~= nil and LuaEntry.Player:IsSurfaceLeader(self.serverId, self.buildingId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialEncourageSelect, self.index, self.govOfficialType, self.serverId, self.buildingId)
  else
    UIUtil.ShowTipsId(393018)
  end
end

function SeasonOfficialEncourageItem:OnGetBtnClick()
  if self.thePresent ~= nil and LuaEntry.Player:IsSurfaceLeader(self.serverId, self.buildingId) then
    DataCenter.BuildingOfficialManager:FetchKingdomBuildingSendPresent(GovOfficialType2Group[self.govOfficialType], self.serverId, self.buildingId, self.thePresent.presentId, {
      LuaEntry.Player.uid
    })
    CS.UIGray.SetGray(self.btn.transform, true, false)
  else
    UIUtil.ShowTipsId(393018)
  end
end

return SeasonOfficialEncourageItem
