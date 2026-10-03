local LWSeasonBuildView = BaseClass("LWSeasonBuildView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonBuildTabItem1 = require("UI.LWSeason.LWSeasonBuild.Component.LWSeasonBuildTabItem1")
local LWSeasonBuildTabItem2 = require("UI.LWSeason.LWSeasonBuild.Component.LWSeasonBuildTabItem2")
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local lastActiveTab = 1
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local btn_effect1_path = "Root/BottomBar/BtnEffect1"
local btn_effect2_path = "Root/BottomBar/BtnEffect2"
local content1_path = "Root/Container/Content1"
local content2_path = "Root/Container/Content2"
local res_list_path = "Root/BottomBar/ResList"
local res1_path = "Root/BottomBar/ResList/res1"
local res2_path = "Root/BottomBar/ResList/res2"
local res3_path = "Root/BottomBar/ResList/res3"
local res4_path = "Root/BottomBar/ResList/res4"
local anim1_path = "Root/BottomBar/ResList/res1/anim1"
local anim2_path = "Root/BottomBar/ResList/res2/anim2"
local anim3_path = "Root/BottomBar/ResList/res3/anim3"
local anim4_path = "Root/BottomBar/ResList/res4/anim4"
local top_res1_path = "Root/TopBar/TopRes1"
local top_res2_path = "Root/TopBar/TopRes2"
local red_point_path = "Root/TopBar/Tab/TabItem2/RedPoint"
local red_num_path = "Root/TopBar/Tab/TabItem2/RedPoint/RedNum"

function LWSeasonBuildView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  if param and type(param) == "number" then
    lastActiveTab = toInt(param)
    if lastActiveTab ~= 1 and lastActiveTab ~= 2 then
      lastActiveTab = 1
    end
  end
  self:ComponentDefine()
  DataCenter.AllianceStorageManager:CheckAllianceStorage()
  DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
  if DataCenter.SeasonDataManager.PlayerBuildList == nil and not LuaEntry.Player:IsInSourceServer() then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonBuildInfo)
  end
end

function LWSeasonBuildView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBuildView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCenterUpdate, self.UpdateData2)
  self:AddUIListener(EventId.GatherSeasonResTimeChange, self.UpdateData1)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  self:AddUIListener(EventId.LWSeasonPlayerBuildListUpdate, self.UpdateData2)
end

function LWSeasonBuildView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCenterUpdate, self.UpdateData2)
  self:RemoveUIListener(EventId.GatherSeasonResTimeChange, self.UpdateData1)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.LWSeasonPlayerBuildListUpdate, self.UpdateData2)
  base.OnRemoveListener(self)
end

function LWSeasonBuildView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("803067")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.btn_effect1 = self:AddComponent(UIButton, btn_effect1_path)
  self.btn_effect2 = self:AddComponent(UIButton, btn_effect2_path)
  self.btn_effect1:SetOnClick(function()
    self:OnResourceCollect()
  end)
  self.btn_effect2:SetOnClick(function()
  end)
  self.res_list = self:AddComponent(UIButton, res_list_path)
  self.res1 = self:AddComponent(UIText, res1_path)
  self.res2 = self:AddComponent(UIText, res2_path)
  self.res3 = self:AddComponent(UIText, res3_path)
  self.res4 = self:AddComponent(UIText, res4_path)
  self.anim1 = self:AddComponent(UICanvasGroup, anim1_path)
  self.anim2 = self:AddComponent(UICanvasGroup, anim2_path)
  self.anim3 = self:AddComponent(UICanvasGroup, anim3_path)
  self.anim4 = self:AddComponent(UICanvasGroup, anim4_path)
  self.animTxt1 = self:AddComponent(UIText, anim1_path)
  self.animTxt2 = self:AddComponent(UIText, anim2_path)
  self.animTxt3 = self:AddComponent(UIText, anim3_path)
  self.animTxt4 = self:AddComponent(UIText, anim4_path)
  self.content1 = self:AddComponent(LWSeasonBuildTabItem1, content1_path)
  self.content2 = self:AddComponent(LWSeasonBuildTabItem2, content2_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_num = self:AddComponent(UIText, red_num_path)
  local count = SeasonUtil.CanBuildPlayerBuildingCount()
  if 0 < count then
    self.red_point:SetActive(true)
    self.red_num:SetText(count)
  else
    self.red_point:SetActive(false)
  end
  self.res_list:SetOnClick(function()
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  else
    self.tab_item2:SetIsOn(true)
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab)
  end
  self.top_res1 = self:AddComponent(UIMainResourceProgress, top_res1_path)
  self.top_res2 = self:AddComponent(UIMainResourceProgress, top_res2_path)
  self.top_res1:ReInit(self:GetResourceParam(ResourceType.OBSIDIAN))
  self.top_res2:ReInit(self:GetResourceParam(ResourceType.FLINT))
end

function LWSeasonBuildView:GetResourceParam(resourceType)
  local param = {}
  param.resourceType = resourceType
  param.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
  param.showExpandAnimation = false
  param.showExpandParam = false
  return param
end

function LWSeasonBuildView:ComponentDestroy()
  self.btn_back = nil
  self.tabActive = nil
end

function LWSeasonBuildView:OnResourceUpdated()
  self.top_res1:Refresh()
  self.top_res2:Refresh()
end

function LWSeasonBuildView:OnDesClick()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.res_list.gameObject.transform.position + Vector3.New(20, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("110483")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 300
  param.pivot = 0.3
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function LWSeasonBuildView:OnResourceCollect()
  if self.content1.gasNum >= 1 or 1 <= self.content1.flintNum or 1 <= self.content1.metalNum or 1 <= self.content1.foodNum then
    SFSNetwork.SendMessage(MsgDefines.UserCollectDesertRes)
    self:DoFlyRes(self.content1.gasNum, self.content1.flintNum, self.content1.metalNum, self.content1.foodNum)
  else
    UIUtil.ShowTipsId("season_tips145")
  end
end

function LWSeasonBuildView:DoFlyRes(gasNum, flintNum, metalNum, foodNum)
  if gasNum ~= nil or flintNum ~= nil or metalNum ~= nil or foodNum ~= nil then
    local num = 4
    if gasNum and 1 <= gasNum then
      local posTo = self.top_res1.gameObject.transform.position
      local posFrom = self.res1.gameObject.transform.position
      local icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.OBSIDIAN)
      UIUtil.DoFlyCustom(icon, nil, num, posFrom, posTo)
    end
    if flintNum and 1 <= flintNum then
      local posTo = self.top_res2.gameObject.transform.position
      local posFrom = self.res2.gameObject.transform.position
      local icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT)
      UIUtil.DoFlyCustom(icon, nil, num, posFrom, posTo)
    end
    if metalNum and 1 <= metalNum then
      local posTo = self.text_title.gameObject.transform.position
      local posFrom = self.res3.gameObject.transform.position
      local icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Metal)
      UIUtil.DoFlyCustom(icon, nil, num, posFrom, posTo)
    end
    if foodNum and 1 <= foodNum then
      local posTo = self.text_title.gameObject.transform.position
      local posFrom = self.res4.gameObject.transform.position
      local icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Food)
      UIUtil.DoFlyCustom(icon, nil, num, posFrom, posTo)
    end
  end
end

function LWSeasonBuildView:OnTabChanged(index)
  lastActiveTab = index
  self.tabActive = index
  self.btn_effect1:SetActive(index == 1)
  self.btn_effect2:SetActive(index == 2)
  self.content1:SetActive(index == 1)
  self.content2:SetActive(index == 2)
  self.res_list:SetActive(index == 1)
  if index == 1 and self.tabDataInit ~= true then
    SFSNetwork.SendMessage(MsgDefines.UserGetAllDesert)
    SFSNetwork.SendMessage(MsgDefines.SeasonForceReward)
    self.tabDataInit = true
  end
  if self.tabActive == 1 then
    self.content1:UpdateData()
    self.content1:RefreshNum()
  elseif self.tabActive == 2 then
    self.content2:UpdateData()
  end
end

function LWSeasonBuildView:UpdateData1()
  if self.tabActive == 1 then
    self.content1:RefreshNum()
  end
end

function LWSeasonBuildView:UpdateData2()
  if self.tabActive == 2 then
    self.content2:UpdateData()
  end
end

return LWSeasonBuildView
