local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ResourceManager = CS.GameEntry.Resource
local UIActHeroLevelReplace = BaseClass("UIActHeroLevelReplace", base)
local heroItem = require("UI.UIActivityCenterTable.Component.UIHeroLevelReplace.UIActHeroLevelAddHeroItem")
local Localization = CS.GameEntry.Localization
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_times_path = "rect/ActivityTopGo/TimeContent/Txt_Times"
local intro_btn_path = "rect/IntroBtn"
local left_hero_path = "rect/heroArea/leftHero"
local right_hero_path = "rect/heroArea/rightHero"
local do_btn_path = "rect/bottomContent/DoBtn"
local img_cost_item1_path = "rect/bottomContent/DoBtn/ImgCostItem1"
local text_cost1_path = "rect/bottomContent/DoBtn/ImgCostItem1/TextCost1"
local left_hero_spine_container_path = "rect/leftHeroSpineViewport/leftHeroSpineContainer"
local right_hero_spine_container_path = "rect/rightleftHeroSpineViewport/rightHeroSpineContainer"
local eff_ui_saiji_zhihuan_jiantou_faguang_path = "rect/heroArea/Eff_ui_saiji_zhihuan_jiantou_faguang"
local eff_ui_saiji_zhihuan_touxiang_faguang_1_path = "rect/heroArea/leftHero/Eff_ui_saiji_zhihuan_touxiang_faguang_1"
local eff_ui_saiji_zhihuan_touxiang_faguang_2_path = "rect/heroArea/rightHero/Eff_ui_saiji_zhihuan_touxiang_faguang_2"

function UIActHeroLevelReplace:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActHeroLevelReplace:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActHeroLevelReplace:OnEnable()
  base.OnEnable(self)
end

function UIActHeroLevelReplace:OnDisable()
  self:ClearSpine()
  self.eff_ui_saiji_zhihuan_jiantou_faguang:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2:SetActive(false)
  base.OnDisable(self)
end

function UIActHeroLevelReplace:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWHeroLevelChangeSelectHero, self.SelectHero)
  self:AddUIListener(EventId.LWSeasonHeroLevelChange, self.ChangeLevelSuccess)
end

function UIActHeroLevelReplace:OnRemoveListener()
  self:RemoveUIListener(EventId.LWHeroLevelChangeSelectHero, self.SelectHero)
  self:RemoveUIListener(EventId.LWSeasonHeroLevelChange, self.ChangeLevelSuccess)
  base.OnRemoveListener(self)
end

function UIActHeroLevelReplace:ComponentDefine()
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:ClickTip()
  end)
  self.left_hero = self:AddComponent(heroItem, left_hero_path)
  self.right_hero = self:AddComponent(heroItem, right_hero_path)
  self.do_btn = self:AddComponent(UIButton, do_btn_path)
  self.do_btn:SetOnClick(function()
    self:DoReplace()
  end)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.text_cost1 = self:AddComponent(UIText, text_cost1_path)
  self.left_hero_spine_container = self:AddComponent(UIBaseContainer, left_hero_spine_container_path)
  self.right_hero_spine_container = self:AddComponent(UIBaseContainer, right_hero_spine_container_path)
  self.eff_ui_saiji_zhihuan_jiantou_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_zhihuan_jiantou_faguang_path)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1 = self:AddComponent(UIBaseContainer, eff_ui_saiji_zhihuan_touxiang_faguang_1_path)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2 = self:AddComponent(UIBaseContainer, eff_ui_saiji_zhihuan_touxiang_faguang_2_path)
  self.eff_ui_saiji_zhihuan_jiantou_faguang:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2:SetActive(false)
end

function UIActHeroLevelReplace:ComponentDestroy()
  self.txt_act_name = nil
  self.txt_times = nil
  self.intro_btn = nil
  self.left_hero = nil
  self.right_hero = nil
  self.do_btn = nil
  self.img_cost_item1 = nil
  self.text_cost1 = nil
  self.left_hero_spine_container = nil
  self.right_hero_spine_container = nil
  if self.delayInvoke then
    self.delayInvoke:Stop()
    self.delayInvoke = nil
  end
  self.eff_ui_saiji_zhihuan_jiantou_faguang = nil
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1 = nil
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2 = nil
end

function UIActHeroLevelReplace:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self.leftHeroUuid = nil
  self.rightHeroUuid = nil
  self:ClearSpine()
  self.left_hero:HeroLevelEmptyItemSetData(self.leftHeroUuid, 1, self)
  self.right_hero:HeroLevelEmptyItemSetData(self.leftHeroUuid, 2, self)
  self.canExchange = false
  self.costItemId = 0
  self.costCount = 0
  local flag = false
  local tabData = LocalController:instance():getLine(TableName.Activity, self.activityId)
  if tabData ~= nil and not string.IsNullOrEmpty(tabData.para) then
    local items = string.split(tabData.para, "|")
    if items then
      local itemId = items[1]
      local count = items[2]
      if itemId and count then
        flag = true
        self.costItemId = itemId
        self.costCount = count
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        local item = DataCenter.ItemData:GetItemById(itemId)
        Logger.Log("itemId : " .. tostring(itemId))
        self.img_cost_item1:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
        if item then
          self.text_cost1:SetText(tostring(item.count) .. "/" .. tostring(count))
          if item.count >= tonumber(count) then
            self.canExchange = true
          else
            self.canExchange = false
          end
        else
          self.text_cost1:SetText(tostring(0) .. "/" .. tostring(count))
          self.canExchange = false
        end
      end
    end
  end
  if flag then
    self.do_btn:SetActive(true)
  else
    self.do_btn:SetActive(false)
    Logger.LogError(string.format("error config, self.activityId: %s", tostring(self.activityId)))
  end
  self:Update1000MS()
end

function UIActHeroLevelReplace:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

function UIActHeroLevelReplace:ClickTip()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActHeroLevelReplace:DoReplace()
  if self.leftHeroUuid == nil or self.rightHeroUuid == nil then
    UIUtil.ShowTipsId("season_tips171")
    return
  end
  if not self.canExchange then
    LWResourceLackUtil:GotoGoodsItemLack(self.costItemId, self.costCount)
    return
  end
  if self.leftHeroUuid ~= self.rightHeroUuid then
    local heroDataL = DataCenter.HeroDataManager:GetHeroByUuid(self.leftHeroUuid)
    local heroDataR = DataCenter.HeroDataManager:GetHeroByUuid(self.rightHeroUuid)
    if heroDataL.level == heroDataR.level then
      local strTips = Localization:GetString("season_level_replacement_010")
      UIUtil.ShowTips(strTips)
      return
    end
    self.msgLeftHeroCache = {}
    self.msgRightHeroCache = {}
    self.msgLeftHeroCache.heroUuid = self.leftHeroUuid
    self.msgLeftHeroCache.heroData = self:GetTmpHeroData(self.leftHeroUuid)
    self.msgRightHeroCache.heroUuid = self.rightHeroUuid
    self.msgRightHeroCache.heroData = self:GetTmpHeroData(self.rightHeroUuid)
    SFSNetwork.SendMessage(MsgDefines.LWSeasonHeroLVInterchange, self.leftHeroUuid, self.rightHeroUuid)
  else
    Logger.LogError("DoReplace: leftHeroUuid is equal to  rightHeroUuid")
  end
end

function UIActHeroLevelReplace:GetTmpHeroData(uuid)
  local result = {}
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
  if heroData then
    result.level = heroData.level
    result.def = heroData:GetDef()
    result.atk = heroData:GetAtk()
    result.hp = heroData:GetMaxHp()
    result.soldiersCapacity = heroData:GetSoldierCapacity()
  else
    result.level = 0
    result.def = 0
    result.atk = 0
    result.hp = 0
    result.soldiersCapacity = 0
  end
  return result
end

function UIActHeroLevelReplace:SelectHero(param)
  if param.side == 1 then
    self.leftHeroUuid = param.heroUuid
    self.left_hero:HeroLevelEmptyItemSetData(self.leftHeroUuid, 1, self)
    local heroDataL = DataCenter.HeroDataManager:GetHeroByUuid(self.leftHeroUuid)
    self.leftHeroLoader = self:LoadHeroSpine(heroDataL, self.left_hero_spine_container, self.leftHeroLoader)
  elseif param.side == 2 then
    self.rightHeroUuid = param.heroUuid
    self.right_hero:HeroLevelEmptyItemSetData(self.rightHeroUuid, 2, self)
    local heroDataR = DataCenter.HeroDataManager:GetHeroByUuid(self.rightHeroUuid)
    self.rightHeroLoader = self:LoadHeroSpine(heroDataR, self.right_hero_spine_container, self.rightHeroLoader)
  end
end

function UIActHeroLevelReplace:GetSelectHero()
  local result = {}
  if self.leftHeroUuid then
    table.insert(result, self.leftHeroUuid)
  end
  if self.rightHeroUuid then
    table.insert(result, self.rightHeroUuid)
  end
  return result
end

function UIActHeroLevelReplace:ChangeLevelSuccess()
  self.eff_ui_saiji_zhihuan_jiantou_faguang:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1:SetActive(false)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2:SetActive(false)
  self.eff_ui_saiji_zhihuan_jiantou_faguang:SetActive(true)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_1:SetActive(true)
  self.eff_ui_saiji_zhihuan_touxiang_faguang_2:SetActive(true)
  self:UIBroadcast(EventId.SeasonMainViewMaskShow)
  self.delayInvoke = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayInvoke and self.msgLeftHeroCache and self.msgRightHeroCache then
      self:UIBroadcast(EventId.SeasonMainViewMaskHide)
      self.delayInvoke = nil
      local param = {
        leftHero = self.msgLeftHeroCache,
        rigthHero = self.msgRightHeroCache
      }
      self.msgLeftHeroCache = nil
      self.msgRightHeroCache = nil
      self:SetData(self.activityId, true)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonHeroLevelChangeReport, {anim = false}, param)
    end
  end, 0.3)
end

function UIActHeroLevelReplace:LoadHeroSpine(heroData, parent, loader)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if loader ~= nil then
    loader:Destroy()
    loader = nil
  end
  local request = ResourceManager:InstantiateAsync(spinePath)
  loader = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.heroSpineLoadRequest[heroData.uuid] = nil
      return
    end
    self:ResetSpineTransform(request.gameObject, parent, heroData.modelId)
  end)
  return loader
end

function UIActHeroLevelReplace:ResetSpineTransform(obj, parent, modelId)
  if not obj then
    return
  end
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    local spineScale = Vector3.one
    local spinePos = Vector3.zero
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
    spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_scale")
    spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_pos")
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(spineScale, spineScale, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

function UIActHeroLevelReplace:ClearSpine()
  if self.leftHeroLoader then
    self.leftHeroLoader:Destroy()
    self.leftHeroLoader = nil
  end
  if self.rightHeroLoader then
    self.rightHeroLoader:Destroy()
    self.rightHeroLoader = nil
  end
end

return UIActHeroLevelReplace
