local UILWMummyMainItemConvertS6 = BaseClass("UILWMummyMainItemConvertS6", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local LWUIEffectNumAdd = require("UI.LWSeason.LWUIEffectNumAdd")
local ArmyCell = require("UI.LWSeason6.UILWMummyS6.UILWMummyMainS6.Component.UILWMummyMainItemArmyCellS6")
local mummy_path = "Top/Mummy"
local mummy_empty_path = "Top/Mummy/mummyEmpty"
local mummy_icon_path = "Top/Mummy/mummyIcon"
local mummy_txt_path = "Top/Mummy/mummyTxt"
local army_path = "Top/Army"
local icon_path = "Top/Army/armyIcon/icon"
local army_exist_path = "Top/Army/armyIcon"
local army_empty_path = "Top/Army/armyEmpty"
local army_txt_path = "Top/Army/armyTxt"
local arrow_path = "Top/Arrow"
local title_path = "Tips/Title"
local tips_btn_path = "Tips/TipsBtn"
local scroll_view_path = "ScrollView"
local viewport_path = "ScrollView/Viewport"
local content_path = "ScrollView/Viewport/Content"
local no_data_path = "ScrollView/Viewport/Content/NoData"
local army_item_path = "ScrollView/Viewport/Content/ArmyItem"
local popup_path = "Top/Mummy/popup"
local res_icon_shake_path = "Top/Mummy/popup/res_icon_shake"
local res_count_path = "Top/Mummy/popup/res_count"
local eff_awake_explode_path = "Top/Mummy/VFX_mask/Eff_ui_S3_Mummy_main_awake_explode"
local eff_ui_s3_mummy_main_add_ring_path = "Top/Army/armyEmpty/Eff_ui_S3_Mummy_main_add_ring"
local add_path = "Top/Army/armyEmpty/add"

function UILWMummyMainItemConvertS6:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.theDeathSoldierInfo = nil
end

function UILWMummyMainItemConvertS6:ComponentDefine()
  self.popup = self:AddComponent(UIButton, popup_path)
  self.res_icon_shake = self:AddComponent(UIImage, res_icon_shake_path)
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, res_count_path)
  self.mummy = self:AddComponent(UIButton, mummy_path)
  self.mummy_empty = self:AddComponent(UIImage, mummy_empty_path)
  self.mummy_icon = self:AddComponent(UIImage, mummy_icon_path)
  self.mummy_txt = self:AddComponent(UITextMeshProUGUIEx, mummy_txt_path)
  self.army_root = self:AddComponent(UIButton, army_path)
  self.army_exist = self:AddComponent(UIBaseContainer, army_exist_path)
  self.army_icon = self:AddComponent(UIImage, icon_path)
  self.army_empty = self:AddComponent(UIButton, army_empty_path)
  self.army_txt = self:AddComponent(UITextMeshProUGUIEx, army_txt_path)
  self.arrow = self:AddComponent(UISimpleAnimation, arrow_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.viewport = self:AddComponent(UIImage, viewport_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tips_title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.tips_btn = self:AddComponent(UIButton, tips_btn_path)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, no_data_path)
  self.theItem = self.transform:Find(army_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.tips_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLackSourceS6)
  end)
  self.mummy:SetOnClick(function()
    UIUtil.ShowTipsId("season_s4_Mummy_ui_info_05")
  end)
  self.army_empty:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLackSourceS6)
  end)
  self.army_root:SetOnClick(function()
    UIUtil.ShowTipsId("season_s4_Mummy_ui_info_04")
  end)
  self.eff_ui_s3_mummy_main_add_ring = self:AddComponent(UIBaseContainer, eff_ui_s3_mummy_main_add_ring_path)
  self.add = self:AddComponent(UIImage, add_path)
  self.awake_explode = self:AddComponent(UIBaseContainer, eff_awake_explode_path)
  self.awake_explode:SetActive(false)
end

function UILWMummyMainItemConvertS6:TryFetchMummy()
  local soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK)
  local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
  if soldierLimit <= mummyCount then
    UIUtil.ShowTipsId("season_s3_Mummy_tips016")
  else
    DataCenter.BuildBubbleManager.lastClickBuildBubbleTipPos = self.mummy.transform.position
    DataCenter.BuildBubbleManager.lastClickBuildBubbleTipType = BuildBubbleType.BuildMummyYard
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummySoldier)
    self.awake_explode_tick = 3
    self.awake_explode:SetActive(true)
  end
end

function UILWMummyMainItemConvertS6:OnDestroy()
  self.content:RemoveComponents(ArmyCell)
  self.theItem:GameObjectRecycleAll()
  self.mummy = nil
  self.eff_ui_s3_mummy_main_add_ring = nil
  self.mummy_empty = nil
  self.mummy_icon = nil
  self.mummy_txt = nil
  self.army_root = nil
  self.army_icon = nil
  self.army_empty = nil
  self.add = nil
  self.army_txt = nil
  self.arrow = nil
  self.scroll_view = nil
  self.viewport = nil
  self.content = nil
  self.tips_title = nil
  self.tips_btn = nil
  self.no_data = nil
  self.army_item = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemConvertS6:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FetchSeasonMummySoldierResult, self.OnFetchSeasonMummy)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
end

function UILWMummyMainItemConvertS6:OnRemoveListener()
  self:RemoveUIListener(EventId.FetchSeasonMummySoldierResult, self.OnFetchSeasonMummy)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
  base.OnRemoveListener(self)
end

function UILWMummyMainItemConvertS6:OnResourceItemRefresh()
  self:UpdateData()
end

function UILWMummyMainItemConvertS6:OnFetchSeasonMummy(soldier)
end

function UILWMummyMainItemConvertS6:UpdateDeathSoldierInfo()
  local now = UITimeManager:GetInstance():GetServerTime()
  local list = DataCenter.SeasonMummyDataManager.waitConvertArmyList
  local time = DataCenter.SeasonMummyDataManager.waitConvertArmyTime
  if list and (now ~= time or self.theDeathSoldierInfo == nil) then
    self.theDeathSoldierInfo = list
    self:UpdateData()
  else
    local countArmy, maxArmy = DataCenter.SeasonMummyDataManager:GetArmyCount()
    if self.canFetchMummyCount ~= countArmy then
      self.theDeathSoldierInfo = list
      self:UpdateData()
    end
  end
end

function UILWMummyMainItemConvertS6:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local dataLevelMax
  local armyCount = 0
  local dataList = {}
  if self.theDeathSoldierInfo == nil then
    self.theDeathSoldierInfo = DataCenter.SeasonMummyDataManager.waitConvertArmyList
  end
  if self.theDeathSoldierInfo then
    for k, v in pairs(self.theDeathSoldierInfo) do
      local data = {
        soldierId = v.armyId,
        soldierCount = v.armyNum
      }
      if dataLevelMax == nil or dataLevelMax.soldierId < data.soldierId then
        dataLevelMax = data
      end
      armyCount = armyCount + data.soldierCount
      table.insert(dataList, data)
    end
    table.sort(dataList, function(a, b)
      return a.soldierId > b.soldierId
    end)
  end
  local isEmpty = true
  local countArmy = 0
  self.canFetchMummyCount = countArmy
  self.mummy_empty:SetActive(isEmpty)
  self.mummy:SetEnable(not isEmpty)
  self.army_icon:SetActive(not isEmpty)
  self.army_exist:SetActive(not isEmpty)
  self.army_empty:SetActive(isEmpty)
  self.no_data:SetActive(isEmpty)
  self.content:RemoveComponents(ArmyCell)
  self.theItem:GameObjectRecycleAll()
  self.arrow:Stop()
  self.convertData = dataLevelMax
  local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
  self.army_txt:SetText("")
  self.mummy_txt:SetText("")
  self.tips_title:SetLocalText("season_s4_Mummy_ui_info_06", toInt(mummyCount))
  self.no_data:SetLocalText("season_s4_Mummy_ui_info_07")
  self.mummy_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_munaiyi.png")
  self.arrow:Rewind("Default")
  self.arrow:Play("Default")
  self.popup:SetActive(false)
  self.res_icon_shake:SetActive(false)
  self.res_count:SetActive(false)
  self.eff_ui_s3_mummy_main_add_ring:SetActive(false)
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704201)
  if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) then
    self.add:LoadSprite(stateMeta.icon)
    self.add:SetSizeDeltaXY(99, 99)
  end
end

function UILWMummyMainItemConvertS6:TryShowSoldierInfoTip(theIndex, gameObject, soldierId)
  if self.view then
    self.view:TryShowSoldierInfoTip(theIndex, gameObject, soldierId)
  end
end

function UILWMummyMainItemConvertS6:Update1000MS()
  if self.animName and self.arrow and not self.arrow:IsPlaying(self.animName) then
    self.arrow:Stop()
    self.arrow:Rewind(self.animName)
    self.arrow:Play(self.animName)
  end
  if self.awake_explode_tick then
    self.awake_explode_tick = self.awake_explode_tick - 1
    if self.awake_explode_tick < 0 then
      self.awake_explode:SetActive(false)
      self.awake_explode_tick = nil
    else
      self.awake_explode:SetActive(true)
    end
  end
end

return UILWMummyMainItemConvertS6
