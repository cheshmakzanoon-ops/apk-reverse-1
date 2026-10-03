local UILWSeasonCityAttachmentTabLevel = BaseClass("UILWSeasonCityAttachmentTabLevel", UIAsyncContainer)
local base = UIAsyncContainer
local LevelItem = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentLevelItem")
local exp_root_path = "ExpRoot"
local exp_pro_path = "ExpRoot/ExpPro"
local exp_num_path = "ExpRoot/ExpNum"
local exp_add_path = "ExpRoot/ExpAdd"
local level_txt_path = "ExpRoot/LineIcon/levelTxt"
local content_level_path = "Viewport/ContentLevel"
local viewport_path = "Viewport"

function UILWSeasonCityAttachmentTabLevel:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.firstEnter = true
  self.items = {}
  self.viewport = self:AddComponent(UIBaseContainer, viewport_path)
  self.scroll_view = self:AddComponent(UIScrollRect, "")
  self.exp_root = self:AddComponent(UIBaseContainer, exp_root_path)
  self.exp_pro = self:AddComponent(UISlider, exp_pro_path)
  self.exp_num = self:AddComponent(UITextMeshProUGUIEx, exp_num_path)
  self.exp_add = self:AddComponent(UIButton, exp_add_path)
  self.level_txt = self:AddComponent(UITextMeshProUGUIEx, level_txt_path)
  self.exp_add:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.AllianceFarmerExp)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_level_path)
  self.ScrollView = self:AddComponent(UILoopListView2, "")
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UILWSeasonCityAttachmentTabLevel:OnDestroy()
  self.items = {}
  self.content:RemoveComponents(LevelItem)
  self.ScrollView:ClearAllItems()
  self.dataList = nil
  self.exp_root = nil
  self.exp_pro = nil
  self.exp_num = nil
  self.exp_add = nil
  self.line_icon = nil
  self.level_txt = nil
  self.level = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentTabLevel:ReInit(isFarmer, allianceBuildInfo)
  self.isFarmer = isFarmer
  self.allianceBuildInfo = allianceBuildInfo
  self:UpdateData()
end

function UILWSeasonCityAttachmentTabLevel:UpdateData()
  local allianceBuildInfo = self.allianceBuildInfo
  local isFarmer = self.isFarmer
  if IsNull(self.gameObject) or allianceBuildInfo == nil then
    return
  end
  local myLevel = 0
  local builderExpInfo = allianceBuildInfo.builderExpInfo
  if isFarmer and builderExpInfo then
    myLevel = toInt(builderExpInfo.level)
  end
  self.myLevel = myLevel
  if isFarmer and builderExpInfo then
    self.exp_root:SetActive(true)
    local curExp = toInt(builderExpInfo.curExp)
    local levelCfg = DataCenter.SeasonFarmerTemplateManager:GetExpTemplateByLevel(myLevel)
    if builderExpInfo and levelCfg and levelCfg.exp then
      self.exp_pro:SetValue(math.min(1, curExp / levelCfg.exp))
      self.exp_num:SetText(string.GetFormattedSeparatorNum(curExp) .. "/" .. string.GetFormattedSeparatorNum(levelCfg.exp))
    else
      self.exp_pro:SetValue(0)
      self.exp_num:SetText("")
    end
    self.level_txt:SetText(myLevel)
    self.viewport.transform.offsetMax = Vector2.New(-28, -150)
  else
    self.exp_root:SetActive(false)
    self.viewport.transform.offsetMax = Vector2.New(-28, -22)
  end
  local unlockIndex = 0
  if self.dataList == nil then
    local dataList = {}
    local expList = DataCenter.SeasonFarmerTemplateManager:GetALLExpTemplate()
    if expList then
      for k, v in pairs(expList) do
        if v.unlockBuildId ~= 0 and v.unlockCount ~= 0 then
          table.insert(dataList, v)
          if myLevel >= v.level then
            unlockIndex = unlockIndex + 1
          end
        end
      end
      table.sort(dataList, function(a, b)
        return a.level < b.level
      end)
    end
    self.dataList = dataList
    self.ScrollView:SetListItemCount(#dataList, false, false)
  end
  self.ScrollView:RefreshAllShownItem()
  if self.firstEnter then
    self.firstEnter = false
    self.ScrollView:MovePanelToItemIndex(unlockIndex - 1, 0)
  end
end

function UILWSeasonCityAttachmentTabLevel:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  local dataCount = #dataList
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("BuildCell")
  local data = dataList[index]
  local dataPre
  if 1 < index then
    dataPre = dataList[index - 1]
  end
  if self.items[csItem] == nil then
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    NameCount = NameCount + 1
    self.items[csItem] = self.content:AddComponent(LevelItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data, data.level > self.myLevel, dataCount, self.myLevel, dataPre)
  end
  return csItem
end

return UILWSeasonCityAttachmentTabLevel
