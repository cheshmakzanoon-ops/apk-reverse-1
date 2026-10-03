local UILWMummyMainItemEffect = BaseClass("UILWMummyMainItemEffect", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local LWUIEffectNumAdd = require("UI.LWSeason.LWUIEffectNumAdd")
local ArmyCell = require("UI.LWSeasonShared.UILWMummyMain.Component.UILWMummyMainItemArmyCell")
local EffectItem = require("UI.LWSeasonShared.UILWMummyMain.Component.UILWMummyMainItemEffectItem")
local EffectTip = require("UI.LWSeasonShared.UILWMummyMain.Component.UILWMummyMainItemEffectTip")
local pro_path = "Top/Pro"
local skill_1_path = "Top/Skill_1"
local skill_2_path = "Top/Skill_2"
local skill_3_path = "Top/Skill_3"
local skill_4_path = "Top/Skill_4"
local skill_5_path = "Top/Skill_5"
local title_path = "Tips/Title"
local tips_btn_path = "Tips/TipsBtn"
local pro_bar_path = "Tips/GameObject/ProBar"
local pro_bar_text_path = "Tips/GameObject/ProBar/ProBarText"
local plus_path = "Tips/GameObject/plus"
local head_btn_path = "Tips/GameObject/headBtn"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local no_data_path = "ScrollView/Viewport/Content/NoData"
local empty_btn_path = "ScrollView/Viewport/Content/NoData/EmptyBtn"
local army_item_path = "ScrollView/Viewport/Content/ArmyItem"
local mummy_effect_info_tip1_path = "Top/MummyEffectInfoTip1"
local mummy_effect_info_tip2_path = "Top/MummyEffectInfoTip2"
local mummy_effect_info_tip3_path = "Top/MummyEffectInfoTip3"
local mummy_effect_info_tip4_path = "Top/MummyEffectInfoTip4"

function UILWMummyMainItemEffect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMummyMainItemEffect:ComponentDefine()
  self.skill_full_explode = self:AddComponent(UIBaseContainer, "Top/Eff_ui_S3_Mummy_skillfull_explode")
  self.head_btn = self:AddComponent(UIButton, head_btn_path)
  self.plus = self:AddComponent(UIButton, plus_path)
  self.pro_bar = self:AddComponent(UISlider, pro_bar_path)
  self.pro_bar_text = self:AddComponent(UITextMeshProUGUIEx, pro_bar_text_path)
  self.pro = self:AddComponent(UIImage, pro_path)
  self.skill_1 = self:AddComponent(EffectItem, skill_1_path)
  self.skill_2 = self:AddComponent(EffectItem, skill_2_path)
  self.skill_3 = self:AddComponent(EffectItem, skill_3_path)
  self.skill_4 = self:AddComponent(EffectItem, skill_4_path)
  self.skill_5 = self:AddComponent(EffectItem, skill_5_path)
  self.effect_info_tip1 = self:AddComponent(EffectTip, mummy_effect_info_tip1_path)
  self.effect_info_tip2 = self:AddComponent(EffectTip, mummy_effect_info_tip2_path)
  self.effect_info_tip3 = self:AddComponent(EffectTip, mummy_effect_info_tip3_path)
  self.effect_info_tip4 = self:AddComponent(EffectTip, mummy_effect_info_tip4_path)
  self.tips_title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.tips_btn = self:AddComponent(UIButton, tips_btn_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, no_data_path)
  self.empty_btn = self:AddComponent(UIButton, empty_btn_path)
  self.theItem = self.transform:Find(army_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.tips_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s3_Mummy_ui_info05"))
  end)
  self.tips_btn:SetActive(false)
  self.empty_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLack, {anim = true})
  end)
  self.plus:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMummyLack, {anim = true})
  end)
  self.head_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s3_Mummy_ui_info05"))
  end)
end

function UILWMummyMainItemEffect:OnDestroy()
  self.content:RemoveComponents(ArmyCell)
  self.theItem:GameObjectRecycleAll()
  self.plus = nil
  self.head_btn = nil
  self.pro_bar = nil
  self.pro_bar_text = nil
  self.tips_title = nil
  self.tips_btn = nil
  self.scroll_view = nil
  self.content = nil
  self.no_data = nil
  self.empty_btn = nil
  self.army_item = nil
  self.pro = nil
  self.skill_1 = nil
  self.skill_2 = nil
  self.skill_3 = nil
  self.skill_4 = nil
  self.skill_5 = nil
  self.mummy_effect_info_tip1 = nil
  self.mummy_effect_info_tip2 = nil
  self.mummy_effect_info_tip3 = nil
  self.mummy_effect_info_tip4 = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemEffect:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
end

function UILWMummyMainItemEffect:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
  base.OnRemoveListener(self)
end

function UILWMummyMainItemEffect:OnResourceItemRefresh()
  self:UpdateData()
end

function UILWMummyMainItemEffect:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local armyCount = 0
  local dataList = {}
  local theDeathSoldierList = DataCenter.SoldierDataManager:GetInsideSoldiers(SoldierType.Mummy)
  if theDeathSoldierList then
    for k, v in pairs(theDeathSoldierList) do
      local data = {
        soldierId = v.id,
        soldierCount = v.count,
        soldierLevel = v.lv
      }
      armyCount = armyCount + data.soldierCount
      table.insert(dataList, data)
    end
    table.sort(dataList, function(a, b)
      return a.soldierId > b.soldierId
    end)
  end
  local isEmpty = armyCount == 0
  self.no_data:SetActive(isEmpty)
  self.content:RemoveComponents(ArmyCell)
  self.theItem:GameObjectRecycleAll()
  if isEmpty then
    self.no_data:SetLocalText("season_s3_Mummy_ui_info06")
  else
    local goItem, theItem
    for k, v in pairs(dataList) do
      local name = "army_" .. UIUtil.GetLoopListItemIndex()
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = name
      goItem:SetActive(true)
      theItem = self.content:AddComponent(ArmyCell, name)
      theItem:ReInit(k, v.soldierId, v.soldierCount, v.soldierLevel, self, SoldierType.Mummy)
    end
  end
  self.armyCount = armyCount
  local K2 = SeasonUtil.GetMummyConfigStr("k2", "5000|10000|15000|20000")
  local K3 = SeasonUtil.GetMummyConfigStr("k3", "")
  self.config_k2 = string.split_ii_array(K2, "|")
  self.config_k3 = string.split_ss_array(K3, "|")
  self.armyCount1 = self.skill_1:ReInit(0, 0, 0, armyCount, nil)
  self.armyCount2 = self.skill_2:ReInit(1, self.config_k2[1] or 5000, self.config_k3[1], armyCount, self.effect_info_tip1)
  self.armyCount3 = self.skill_3:ReInit(2, self.config_k2[2] or 10000, self.config_k3[2], armyCount, self.effect_info_tip2)
  self.armyCount4 = self.skill_4:ReInit(3, self.config_k2[3] or 15000, self.config_k3[3], armyCount, self.effect_info_tip3)
  self.armyCount5 = self.skill_5:ReInit(4, self.config_k2[4] or 20000, self.config_k3[4], armyCount, self.effect_info_tip4)
  self:UpdateFillAmount()
end

function UILWMummyMainItemEffect:UpdateFillAmount()
  local armyMax = toInt(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK))
  local totalArmyCount = toInt(self.armyCount)
  if totalArmyCount >= self.armyCount5 then
    local rate = 0.825 + 0.17500000000000004 * (totalArmyCount - self.armyCount5) / self.armyCount5
    self.pro:SetFillAmount(math.min(rate, 1))
  elseif totalArmyCount >= self.armyCount4 then
    self.pro:SetFillAmount(0.65 + 0.05499999999999994 * (totalArmyCount - self.armyCount4) / (self.armyCount5 - self.armyCount4))
  elseif totalArmyCount >= self.armyCount3 then
    self.pro:SetFillAmount(0.463 + 0.067 * (totalArmyCount - self.armyCount3) / (self.armyCount4 - self.armyCount3))
  elseif totalArmyCount >= self.armyCount2 then
    self.pro:SetFillAmount(0.29 + 0.05499999999999999 * (totalArmyCount - self.armyCount2) / (self.armyCount3 - self.armyCount2))
  else
    self.pro:SetFillAmount(0.178 * totalArmyCount / self.armyCount2)
  end
  self.skill_full_explode:SetActive(totalArmyCount >= self.armyCount5)
  self.tips_title:SetText(Localization:GetString("season_s3_Mummy_ui_tittle02"))
  self.pro_bar_text:SetText(string.GetFormattedSeparatorNum(totalArmyCount) .. "/" .. string.GetFormattedSeparatorNum(armyMax))
  if armyMax <= totalArmyCount then
    self.pro_bar:SetValue(1)
  elseif armyMax == 0 or totalArmyCount == 0 then
    self.pro_bar:SetValue(0)
  else
    self.pro_bar:SetValue(math.max(math.min(1, totalArmyCount / armyMax), 0.03))
  end
end

function UILWMummyMainItemEffect:TryShowSoldierInfoTip(theIndex, gameObject, soldierId)
  if self.view then
    self.view:TryShowSoldierInfoTip(theIndex, gameObject, soldierId)
  end
end

return UILWMummyMainItemEffect
