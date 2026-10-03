local Item = BaseClass("Item", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local desc_txt_path = "Desc"
local finish_go_path = "FinishIcon"
local btn_path = "Btn"
local btn_text_path = "Btn/BtnTitle"
local RESEARCH_TXT = 100094
local BUILD_TXT = 110015
local OBTAIN_TXT = 100547

function Item:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Item:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Item:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.finishGo = self:AddComponent(UIBaseContainer, finish_go_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

function Item:ComponentDestroy()
  self.icon = nil
  self.descText = nil
  self.finishGo = nil
  self.btnText = nil
  self.btn = nil
end

function Item:DataDefine()
  self.params = {}
end

function Item:DataDestroy()
  self.params = nil
end

function Item:OnEnable()
  base.OnEnable(self)
end

function Item:OnDisable()
  base.OnDisable(self)
end

function Item:OnAddListener()
  base.OnAddListener(self)
end

function Item:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Item:SetData(params)
  self.params = params
  local colorFormatRed = "<color=#F53C3D>"
  local colorFormatNormal1 = "<color=#2A2830>"
  local colorFormatNormal2 = "<color=#706A67>"
  local colorFormatEnd = "</color>"
  self.btnText:SetLocalText(OBTAIN_TXT)
  if params.condType == 1 then
    local itemId = params.itemId
    self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(itemId, params.level))
    local buildName = ""
    if DataCenter.ScienceManager:IsScienceBuild(itemId) then
      buildName = Localization:GetString("tech_research005")
    elseif itemId == BuildingTypes.LW_BUILD_TANKCENTER or itemId == BuildingTypes.LW_BUILD_ARTILLERYCENTER or itemId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
      buildName = Localization:GetString("building_center_tips5")
    else
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
      if template ~= nil then
        buildName = Localization:GetString(template.name)
      end
    end
    local strDesc = Localization:GetString("science_condition", params.level, buildName)
    local strPre = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    self.descText:SetText(strPre .. strDesc .. strEnd)
    self.btnText:SetLocalText(BUILD_TXT)
  elseif params.condType == 2 then
    local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(params.itemId, params.level)
    local icon = string.format(LoadPath.UILWScience, tempTemplate.icon)
    self.icon:LoadSprite(icon)
    if tempTemplate ~= nil then
      local strDesc = Localization:GetString("science_condition", params.level, Localization:GetString(tempTemplate.name))
      local strPre = params.isRed and colorFormatRed or colorFormatNormal1
      local strEnd = colorFormatEnd
      self.descText:SetText(strPre .. strDesc .. strEnd)
    end
    self.btnText:SetLocalText(RESEARCH_TXT)
  elseif params.condType == 3 then
    self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(params.resourceType))
    local strDesc1 = string.GetFormattedSpecial(params.own)
    local strPre1 = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    local str1 = strPre1 .. strDesc1 .. strEnd
    local strDesc2 = string.GetFormattedSpecial(params.count)
    local strPre2 = colorFormatNormal2
    local str2 = strPre2 .. strDesc2 .. strEnd
    self.descText:SetText(str1 .. "/" .. str2)
  elseif params.condType == 4 then
    local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(params.resourceItemId)
    if resourceItemData ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, resourceItemData.pic))
    end
    local strDesc1 = string.GetFormattedSpecial(params.own)
    local strPre1 = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    local str1 = strPre1 .. strDesc1 .. strEnd
    local strDesc2 = string.GetFormattedSpecial(params.count)
    local strPre2 = colorFormatNormal2
    local str2 = strPre2 .. strDesc2 .. strEnd
    self.descText:SetText(str1 .. "/" .. str2)
  elseif params.condType == 5 then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(params.itemId)
    if goods ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
    local strDesc1 = string.GetFormattedSpecial(params.own)
    local strPre1 = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    local str1 = strPre1 .. strDesc1 .. strEnd
    local strDesc2 = string.GetFormattedSpecial(params.count)
    local strPre2 = colorFormatNormal2
    local str2 = strPre2 .. strDesc2 .. strEnd
    self.descText:SetText(str1 .. "/" .. str2)
  elseif params.condType == 6 then
    local scienceId = params.itemId
    local level = params.level
    local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, level)
    local icon = string.format(LoadPath.UILWScience, tempTemplate.icon)
    self.icon:LoadSprite(icon)
    local strDesc = Localization:GetString("building_update_science_condition1", params.level, Localization:GetString(tempTemplate.name))
    local strPre = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    self.descText:SetText(strPre .. strDesc .. strEnd)
    self.btnText:SetLocalText("building_update_science_condition2")
  elseif params.condType == ScienceUnlockConditionType.ScienceGroupPercent then
    local needPercent = params.needPercent
    local descKey = params.descKey
    local tabIdList = params.tabIdList
    local isRed = params.isRed
    local strPre1
    if not isRed then
      strPre1 = colorFormatNormal1
    else
      strPre1 = colorFormatRed
    end
    local strEnd = colorFormatEnd
    local desc = Localization:GetString(descKey, needPercent)
    local str1 = strPre1 .. desc .. strEnd
    self.descText:SetText(str1)
    local tabConfig = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(params.minPercentId)
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, tabConfig.icon))
  elseif params.condType == ScienceUnlockConditionType.MonoPolyFinish then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UITask/UITask_zombielord.png")
    local num = DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(params.itemId))
    local strDesc1 = Localization:GetString(800704, num)
    local strPre1 = params.isRed and colorFormatRed or colorFormatNormal1
    local strEnd = colorFormatEnd
    local str1 = strPre1 .. strDesc1 .. strEnd
    self.descText:SetText(str1)
    self.btnText:SetLocalText("110003")
  end
  if params.isRed then
    self.finishGo:SetActive(false)
    self.btn:SetActive(true)
  else
    self.finishGo:SetActive(true)
    self.btn:SetActive(false)
  end
end

function Item:OnClick()
  if self.params.condType == 1 then
    GoToUtil.GotoCityByCondBuildId(self.params.itemId, WorldTileBtnType.City_Upgrade)
  elseif self.params.condType == 2 then
    EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, self.params.itemId)
    self.view.ctrl:CloseSelf()
  elseif self.params.condType == 3 then
    local data = {}
    table.insert(data, {
      resType = self.params.resourceType,
      need = self.params.count
    })
    LWResourceLackUtil:GotoResLack(data)
  elseif self.params.condType == 4 then
    LWResourceLackUtil:GotoResourceItemLack(self.params.resourceItemId, self.params.count)
  elseif self.params.condType == 5 then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.params.itemId)
    if itemTemplate then
      LWResourceLackUtil:GotoGoodsItemLack(self.params.itemId, self.params.count)
    end
  elseif self.params.condType == 6 then
    local scienceId = self.params.itemId
    local level = self.params.level
    local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId, level)
    local scienceTab = template.tab
    local allScienceQueues = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    for i, v in ipairs(allScienceQueues) do
      local buildUuid = v.funcUuid
      if buildUuid then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
        if buildData and 1 <= buildData.level then
          local state = v:GetQueueState()
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWScienceMain, scienceTab, buildUuid)
          GoToUtil.GotoScience(scienceId, scienceTab, buildUuid, true)
          return
        end
      end
    end
  elseif self.params.condType == ScienceUnlockConditionType.ScienceGroupPercent then
    local allScienceQueues = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    for i, v in ipairs(allScienceQueues) do
      local buildUuid = v.funcUuid
      if buildUuid then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
        if buildData and 1 <= buildData.level then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWScienceMain, self.params.minPercentId, buildUuid)
          GoToUtil.OpenScienceTree(nil, self.params.minPercentId, buildUuid, false)
          return
        end
      end
    end
  elseif self.params.condType == ScienceUnlockConditionType.MonoPolyFinish then
    GoToUtil.CloseAllWindows()
    SceneUtils.ChangeToCity(function()
      GoToUtil.GoToCurObstacle()
    end)
  end
end

return Item
