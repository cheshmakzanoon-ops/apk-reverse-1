local UILWMummyMainViewS5 = BaseClass("UILWMummyMainViewS5", UIBaseView)
local base = UIBaseView
local lastActiveTab = 1
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWMummyInfoTipS5 = require("UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyInfoTipS5")
local panel_path = "panel"
local tab_bottom_path = "PopUpTitle/TabBottom"
local tab_top_path = "PopUpTitle/TabTop"
local tab_item1_path = "PopUpTitle/TabBottom/TabItem1"
local tab_item2_path = "PopUpTitle/TabBottom/TabItem2"
local tab_item3_path = "PopUpTitle/TabBottom/TabItem3"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_path = "PopUpTitle/ContentTop/title"
local icon_path = "PopUpTitle/ContentTop/title/icon"
local content_path = "PopUpTitle/Content"
local mummy_buff_path = "PopUpTitle/ContentTop/MummyBuff"
local mummy_record_path = "PopUpTitle/ContentTop/MummyRecord"
local mummy_count_path = "PopUpTitle/ContentTop/MummyCount"
local mummy_count_txt_path = "PopUpTitle/ContentTop/MummyCount/MummyCountTxt"

function UILWMummyMainViewS5:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local isExistBuilding = DataCenter.BuildManager:HasSeasonMummyYardBuilding()
  if isExistBuilding then
    local isFirstOpen = Setting:GetPrivateBool("TabShowMummyMainS5", true)
    Setting:SetPrivateBool("TabShowMummyMainS5", false)
    if isFirstOpen then
      lastActiveTab = 1
    else
      lastActiveTab = 2
    end
    self.defaultTab = self:GetUserData()
    if self.defaultTab then
      local index = toInt(self.defaultTab)
      if index == 1 or index == 2 or index == 3 then
        lastActiveTab = index
      end
    end
    self.tab_bottom:SetActive(true)
    self.tab_top:SetActive(true)
    if lastActiveTab == 1 then
      self.tab_item1:SetIsOn(true)
    elseif lastActiveTab == 2 then
      self.tab_item2:SetIsOn(true)
    elseif lastActiveTab == 3 then
      self.tab_item3:SetIsOn(true)
    end
    if self.activeTab == nil then
      self:OnTabChanged(lastActiveTab)
    end
  else
    lastActiveTab = 1
    self.tab_item1:SetIsOn(true)
    self.tab_bottom:SetActive(false)
    self.tab_top:SetActive(false)
    if self.activeTab == nil then
      self:OnTabChanged(1)
    end
  end
end

function UILWMummyMainViewS5:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMummyMainViewS5:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateSeasonDeathSoldierInfo, self.UpdateDeathSoldierInfo)
end

function UILWMummyMainViewS5:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateSeasonDeathSoldierInfo, self.UpdateDeathSoldierInfo)
  base.OnRemoveListener(self)
end

function UILWMummyMainViewS5:ComponentDefine()
  self.tab_bottom = self:AddComponent(UIBaseContainer, tab_bottom_path)
  self.tab_top = self:AddComponent(UIBaseContainer, tab_top_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.infoBtn = self:AddComponent(UIButton, icon_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
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
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(3)
    end
  end)
  self.infoBtn:SetOnClick(function()
    local msg
    if self.activeTab == 1 then
      msg = Localization:GetString("season_s3_Mummy_ui_info02")
    elseif self.activeTab == 2 then
      msg = Localization:GetString("season_s3_Mummy_ui_info05")
    elseif self.activeTab == 3 then
      msg = Localization:GetString("season_s3_Mummy_ui_info05")
    end
    if msg then
      UIUtil.ShowDetail(msg, nil, nil, true, true)
    end
  end)
  self.mummy_buff = self:AddComponent(UIButton, mummy_buff_path)
  self.mummy_record = self:AddComponent(UIButton, mummy_record_path)
  self.mummy_buff:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.mummy_record:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyHistory)
  end)
  self.mummy_count = self:AddComponent(UIImage, mummy_count_path)
  self.mummy_count_txt = self:AddComponent(UITextMeshProUGUIEx, mummy_count_txt_path)
  self.mummy_buff:SetActive(false)
  self.mummy_record:SetActive(false)
end

function UILWMummyMainViewS5:ComponentDestroy()
  self.content = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.close_btn = nil
  self.title = nil
  self.infoBtn = nil
  self.content_convert = nil
  self.content_effect = nil
  self.content_book = nil
  self.mummy_count = nil
  self.mummy_count_txt = nil
end

function UILWMummyMainViewS5:OnTabChanged(tabIndex)
  local prefabPath
  local isExistBuilding = false
  lastActiveTab = tabIndex
  self.activeTab = tabIndex
  if tabIndex == 1 then
    if self.content_convert == nil then
      local UILWMummyMainItemConvertS5 = "UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyMainItemConvertS5"
      prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/UIMummyMainS5/ComponentS5/UIMummyTab1S5.prefab"
      self.content_convert = UIBaseComponent.LoadComponentAsync(self, UILWMummyMainItemConvertS5, prefabPath, self.content)
      self.content_convert:UpdateDeathSoldierInfo()
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummyMainInfo)
    else
      self.content_convert:UpdateData()
    end
    UIUtil.CheckEventTrigger(OpMode.ClickBtnMummyMainTab1)
    self.title:SetActive(true)
    self.title:SetLocalText("season_s3_Mummy_ui_tittle01")
  elseif tabIndex == 2 then
    if self.content_effect == nil then
      local UILWMummyMainItemEffectS5 = "UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyMainItemEffectS5"
      prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/UIMummyMainS5/ComponentS5/UIMummyTab2S5.prefab"
      self.content_effect = UIBaseComponent.LoadComponentAsync(self, UILWMummyMainItemEffectS5, prefabPath, self.content)
    else
      self.content_effect:UpdateData()
    end
    self.title:SetActive(true)
    self.title:SetLocalText("season_s3_Mummy_ui_tittle02")
    UIUtil.CheckEventTrigger(OpMode.ClickBtnMummyMainTab2)
  elseif tabIndex == 3 then
    if self.content_book == nil then
      local UILWMummyMainBooksS5 = "UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyMainBooksS5"
      prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/UIMummyMainS5/ComponentS5/UIMummyTab3S5.prefab"
      self.content_book = UIBaseComponent.LoadComponentAsync(self, UILWMummyMainBooksS5, prefabPath, self.content)
    else
      self.content_book:UpdateData()
    end
    local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
    self.mummy_count_txt:SetText(string.GetFormattedSeparatorNum(mummyCount))
    self.title:SetLocalText("season_s3_Mummy_ui_tittle03")
    self.title:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mummy_count_txt.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mummy_count.transform)
  end
  self.mummy_buff:SetActive(tabIndex == 1)
  self.mummy_record:SetActive(tabIndex == 1)
  if self.content_convert ~= nil then
    self.content_convert:SetActive(tabIndex == 1)
  end
  if self.content_effect ~= nil then
    self.content_effect:SetActive(tabIndex == 2)
  end
  if self.content_book ~= nil then
    self.content_book:SetActive(tabIndex == 3)
  end
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704201)
  if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) then
    self.mummy_buff:LoadSprite(stateMeta.icon)
  end
end

function UILWMummyMainViewS5:UpdateDeathSoldierInfo()
  if self.content_convert ~= nil then
    self.content_convert:UpdateDeathSoldierInfo()
  end
end

function UILWMummyMainViewS5:TryShowSoldierInfoTip(theIndex, gameObject, soldierId)
  self.theSoldierInfoTipTargetIndex = theIndex
  self.theSoldierInfoTipTarget = gameObject
  self.theSoldierInfoTipTargetId = soldierId
  if self.theSoldierInfoTip == nil then
    self.theSoldierInfoTip = 0
    self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/UI/UIMummyMainS5/ComponentS5/SoldierInfoTipS5.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = "theSoldierInfoTip"
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_localRotation(0, 0, 0, 1)
      go.gameObject:SetActive(true)
      self.theSoldierInfoTip = self:AddComponent(UILWMummyInfoTipS5, "theSoldierInfoTip")
      self.theSoldierInfoTipArrow = self:AddComponent(UIBaseComponent, "theSoldierInfoTip/bg")
      self:ShowSoldierInfoTip2(self.theSoldierInfoTipTargetIndex, self.theSoldierInfoTipTarget, self.theSoldierInfoTipTargetId)
    end)
  elseif self.theSoldierInfoTip ~= nil and self.theSoldierInfoTip ~= 0 then
    self:ShowSoldierInfoTip2(self.theSoldierInfoTipTargetIndex, self.theSoldierInfoTipTarget, self.theSoldierInfoTipTargetId)
  end
end

function UILWMummyMainViewS5:ShowSoldierInfoTip2(theIndex, gameObject, soldierId)
  if self.theSoldierInfoTip == nil or self.theSoldierInfoTip == 0 or IsNull(gameObject) or self.theSoldierInfoTipArrow == nil then
    return
  end
  local x, y, z = self.theSoldierInfoTipArrow:GetLocalPositionXYZ()
  if theIndex == 0 then
    self.theSoldierInfoTipArrow:SetLocalPositionXYZ(240, y, z)
  elseif theIndex == 1 then
    self.theSoldierInfoTipArrow:SetLocalPositionXYZ(-233, y, z)
  elseif theIndex == 2 then
    self.theSoldierInfoTipArrow:SetLocalPositionXYZ(0, y, z)
  end
  self.theSoldierInfoTip.transform.position = gameObject.transform.position
  x, y, z = self.theSoldierInfoTip:GetLocalPositionXYZ()
  self.theSoldierInfoTip:SetLocalPositionXYZ(0, y + 170, 0)
  self.theSoldierInfoTip:SetActive(true)
  self.theSoldierInfoTip:SetAlpha(1)
  self.theSoldierInfoTip:Refresh(DataCenter.SoldierDataManager:GetTemplate(soldierId))
end

return UILWMummyMainViewS5
