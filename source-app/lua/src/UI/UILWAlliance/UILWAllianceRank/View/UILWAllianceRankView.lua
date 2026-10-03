local UILWAllianceRankView = BaseClass("UILWAllianceRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankContent = require("UI.UILWAlliance.UILWAllianceRank.Component.LWAlRankContent")
local DonateRankContent = require("UI.UILWAlliance.UILWAllianceRank.Component.LWAlDonateRankContent")
local tab_path = "Root/MiddleContentContainer/ConditionBtnScroll/ConditionBtns/Tab%d"

function UILWAllianceRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:SendAlMemberDataMsg()
end

function UILWAllianceRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceRankView:ComponentDefine()
  self.title = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.title:SetText(Localization:GetString("455113"))
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabs = {}
  for i = 1, 3 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
    tab.tab_name = tab.tab:AddComponent(UIText, "activityName")
    tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
end

function UILWAllianceRankView:ComponentDestroy()
  if self.rankContent then
    self.rankContent:SetActive(false)
  end
  if self.donateRankContent then
    self.donateRankContent:SetActive(false)
  end
  self.title = nil
  self.closeBtn = nil
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
  self.rankContent = nil
  self.donateRankContent = nil
  self.rankContentGo = nil
  self.donateRankContentGo = nil
end

function UILWAllianceRankView:DataDefine()
  self.selectIndex = 1
  self.showTabData = {
    AlRankType.Power,
    AlRankType.Kill,
    AlRankType.Donate
  }
end

function UILWAllianceRankView:DataDestroy()
end

function UILWAllianceRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.GetMemberData)
end

function UILWAllianceRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.GetMemberData)
  base.OnRemoveListener(self)
end

function UILWAllianceRankView:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
  local jumpType = self:GetUserData()
  if jumpType ~= nil then
    for k, v in pairs(self.showTabData) do
      if v == jumpType then
        self.selectIndex = k
        break
      end
    end
  end
  self:RefreshBar()
  self:RefreshContent()
end

function UILWAllianceRankView:GetTabNameByType(type)
  local name = ""
  if type == AlRankType.Power then
    name = Localization:GetString("100644")
  elseif type == AlRankType.Kill then
    name = Localization:GetString("310139")
  elseif type == AlRankType.Donate then
    name = Localization:GetString("alliance_rank_title_donation")
  end
  return name
end

function UILWAllianceRankView:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshBar()
  self:RefreshContent()
end

function UILWAllianceRankView:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function UILWAllianceRankView:RefreshContent()
  local curType = self.showTabData[self.selectIndex]
  if curType == nil then
    return
  end
  if curType == AlRankType.Power or curType == AlRankType.Kill then
    if self.rankContent == nil then
      self.rankContent = self:AddComponent(RankContent, "Root/MiddleContentContainer/ContentContainer/rankContent")
    end
    if self.donateRankContent then
      self.donateRankContent:SetActive(false)
    else
      if not self.donateRankContentGo then
        self.donateRankContentGo = self.transform:Find("Root/MiddleContentContainer/ContentContainer/donateRankContent").gameObject
      end
      self.donateRankContentGo:SetActive(false)
    end
    if self.rankContent then
      self.rankContent:SetActive(true)
      self.rankContent:SetData(curType)
    end
  elseif curType == AlRankType.Donate then
    if self.rankContent then
      self.rankContent:SetActive(false)
    else
      if not self.rankContentGo then
        self.rankContentGo = self.transform:Find("Root/MiddleContentContainer/ContentContainer/rankContent").gameObject
      end
      self.rankContentGo:SetActive(false)
    end
    if self.donateRankContent == nil then
      self.donateRankContent = self:AddComponent(DonateRankContent, "Root/MiddleContentContainer/ContentContainer/donateRankContent")
    end
    if self.donateRankContent then
      self.donateRankContent:SetActive(true)
      self.donateRankContent:SetData()
    end
  end
end

function UILWAllianceRankView:GetMemberData()
  self:RefreshBar()
  self:RefreshContent()
end

function UILWAllianceRankView:SendAlMemberDataMsg()
  if self.sendTime == nil then
    self.sendTime = 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.sendTime + 2000 then
    self.sendTime = curTime
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data then
      local tempAlId = data.uid
      SFSNetwork.SendMessage(MsgDefines.AlRank, tempAlId)
    end
  end
end

return UILWAllianceRankView
