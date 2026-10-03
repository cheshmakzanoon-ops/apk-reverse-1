local AllianceMemberRankItem = BaseClass("AllianceMemberRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberItem")
local icon_path = "mainContent/leader"
local name_path = "mainContent/nameTxt"
local rank_name_path = "mainContent/ListNameText"
local num_path = "mainContent/people"
local show_btn_path = "mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local content_path = "armyContent"
local inactive_path = "mainContent/inactive"
local inactiveTip_path = "mainContent/inactive/inactiveTip"

local function OnCreate(self)
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.rankNameText = self:AddComponent(UIText, rank_name_path)
  self.num = self:AddComponent(UIText, num_path)
  self.close_img = self:AddComponent(UIImage, close_img_path)
  self.open_img = self:AddComponent(UIImage, open_img_path)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.inactiveN = self:AddComponent(UIBaseContainer, inactive_path)
  self.inactiveAnimN = self:AddComponent(UIAnimator, inactive_path)
  self.inactiveTipN = self:AddComponent(UIText, inactiveTip_path)
  self.inactiveTipN:SetLocalText(141141)
  local needCollapse = self.view.ctrl:NeedShowInactive()
  self:ShowMember(not needCollapse)
end

local function OnDestroy(self)
  self.icon = nil
  self.name = nil
  self.rankNameText = nil
  self.num = nil
  self.close_img = nil
  self.open_img = nil
  self.show_btn = nil
  self.content = nil
  self.showMember = nil
  base.OnDestroy(self)
end

local function RefreshData(self, rank)
  self.rank = rank
  self.data = self.view.ctrl:GetRankData(rank)
  local isSelfAlliance = self.view.ctrl:GetIsSelfAlliance()
  local viewOpenType = DataCenter.AllianceMemberDataManager:GetAllianceRankVisible()
  local isSwitchOn = DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch()
  if isSwitchOn and (isSelfAlliance or viewOpenType == 1) then
    local rank_name = DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(rank)
    self.rankNameText:SetText(rank_name or "")
    self.rankNameText:SetActive(not string.IsNullOrEmpty(rank_name))
  else
    self.rankNameText:SetText("")
    self.rankNameText:SetActive(false)
  end
  self.num:SetText(self.data.rankNum)
  if not self.showMember then
    local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
    if selfRank == rank then
      local showSelfRank = self.view:CheckIfNeedShowSelfRank()
      self.showMember = showSelfRank
    else
      self.showMember = false
    end
  end
  if self.showMember then
    self:RefreshMemberList()
  elseif self.data then
    local param = {}
    param.rank = self.data.rank
    param.isShow = self.showMember
    EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
  end
  local showInactiveTip = self.view.showInactiveTip
  local inactivePlayerCount = DataCenter.AllianceMemberDataManager:GetInactivePlayerCount(rank)
  if showInactiveTip and 0 < inactivePlayerCount then
    self.inactiveN:SetActive(true)
    self.inactiveAnimN:Play("InactivePlayer", 0, 0)
  else
    self.inactiveN:SetActive(false)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnShowClick(self)
  if self.showMember then
    self:SetAllCellDestroy()
    self:ShowMember(false)
    if self.data then
      local param = {}
      param.rank = self.data.rank
      param.isShow = self.showMember
      EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
    end
  else
    self:ShowMember(true)
    self:RefreshMemberList()
  end
end

local function ShowMember(self, isShow)
  self.showMember = isShow
  self.open_img:SetActive(isShow)
  self.close_img:SetActive(not isShow)
end

local function RefreshMemberList(self)
  self:SetAllCellDestroy()
  local list = self.view.ctrl:GetMemberListByRank(self.data.rank)
  self.modelCount = 0
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/Alliance/UILWAlMemberItem.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(MemberItem, nameStr)
        cell:SetData(list[i])
        cell.clickBtn:SetActive(false)
        table.insert(self.cellList, cell)
        if #self.cellList == #list and self.data then
          local param = {}
          param.rank = self.data.rank
          param.isShow = self.showMember
          EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
        end
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(MemberItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.cellList = {}
end

AllianceMemberRankItem.OnCreate = OnCreate
AllianceMemberRankItem.OnDestroy = OnDestroy
AllianceMemberRankItem.OnEnable = OnEnable
AllianceMemberRankItem.OnDisable = OnDisable
AllianceMemberRankItem.RefreshData = RefreshData
AllianceMemberRankItem.OnShowClick = OnShowClick
AllianceMemberRankItem.RefreshMemberList = RefreshMemberList
AllianceMemberRankItem.SetAllCellDestroy = SetAllCellDestroy
AllianceMemberRankItem.ShowMember = ShowMember
return AllianceMemberRankItem
