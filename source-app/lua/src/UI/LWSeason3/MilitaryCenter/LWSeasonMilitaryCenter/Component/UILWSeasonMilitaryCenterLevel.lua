local UILWSeasonMilitaryCenterLevel = BaseClass("UILWSeasonMilitaryCenterLevel", UIAsyncContainer)
local base = UIAsyncContainer
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local Localization = CS.GameEntry.Localization
local content_path = "ScrollView/Viewport/Content"
local target_item_path = "ScrollView/Viewport/Content/TargetItem"
local task_title_txt_path = "taskTitleTxt"
local from_path = "taskTitleTxt/from"
local arr_path = "taskTitleTxt/arr"
local to_path = "taskTitleTxt/to"
local level_up_root_path = "LevelUpRoot"
local from_level_path = "LevelUpRoot/TitleTxt/fromLevel"
local arr_level_path = "LevelUpRoot/TitleTxt/arrLevel"
local to_level_path = "LevelUpRoot/TitleTxt/toLevel"
local res_info_path = "LevelUpRoot/ResInfo"
local from_res_path = "LevelUpRoot/ResIcon1/bg/fromRes"
local to_res_path = "LevelUpRoot/ResIcon2/bg/toRes"
local res_info_num_path = "LevelUpRoot/ResInfoNum"
local desc_path = "LevelUpRoot/desc"
local res_icon1_path = "LevelUpRoot/ResIcon1"
local res_icon2_path = "LevelUpRoot/ResIcon2"
local btn_info_path = "LevelUpRoot/btnInfo"

function UILWSeasonMilitaryCenterLevel:OnCreate()
  base.OnCreate(self)
  self.build_root = self:AddComponent(UIBaseContainer, task_title_txt_path)
  self.from = self:AddComponent(UITextMeshProUGUIEx, from_path)
  self.arr = self:AddComponent(UIImage, arr_path)
  self.to = self:AddComponent(UITextMeshProUGUIEx, to_path)
  self.level_up_root = self:AddComponent(UIBaseContainer, level_up_root_path)
  self.from_level = self:AddComponent(UITextMeshProUGUIEx, from_level_path)
  self.arr_level = self:AddComponent(UIImage, arr_level_path)
  self.to_level = self:AddComponent(UITextMeshProUGUIEx, to_level_path)
  self.res_info = self:AddComponent(UISlider, res_info_path)
  self.from_res = self:AddComponent(UITextMeshProUGUIEx, from_res_path)
  self.to_res = self:AddComponent(UITextMeshProUGUIEx, to_res_path)
  self.res_info_num = self:AddComponent(UITextMeshProUGUIEx, res_info_num_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.res_icon1 = self:AddComponent(UIImage, res_icon1_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.theItem = self.transform:Find(target_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonMilitaryCenterCarrierRule)
  end)
end

function UILWSeasonMilitaryCenterLevel:OnDestroy()
  self.theItem:GameObjectRecycleAll()
  self.from = nil
  self.arr = nil
  self.to = nil
  self.content = nil
  self.target_item = nil
  self.level_up_root = nil
  self.from_level = nil
  self.arr_level = nil
  self.to_level = nil
  self.res_info = nil
  self.from_res = nil
  self.to_res = nil
  self.res_info_num = nil
  self.desc = nil
  self.res_icon1 = nil
  self.res_icon2 = nil
  self.task_title_txt = nil
  self.btn_info = nil
  base.OnDestroy(self)
end

function UILWSeasonMilitaryCenterLevel:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  self.theStoveCenter = theStoveCenter
  if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.Build then
    self.to:SetText("Lv.1")
    self.from:SetActive(false)
    self.arr:SetActive(false)
    self.to:SetActive(true)
    self.build_root:SetActive(true)
    self.level_up_root:SetActive(false)
    self:UpdateLevelInfo(0, 1, maxLevel)
  else
    local level = theStoveCenter.level
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_MUMMY_CENTER)
    local maxLevel = meta.max_level
    if level == maxLevel then
      self.build_root:SetActive(false)
      self.level_up_root:SetActive(true)
      self.to_level:SetText("Lv." .. maxLevel .. " (" .. Localization:GetString("454114") .. ")")
      self.from:SetActive(false)
      self.arr:SetActive(false)
      self.to:SetActive(true)
      self.from_level:SetActive(false)
      self.arr_level:SetActive(false)
    else
      self.build_root:SetActive(false)
      self.level_up_root:SetActive(true)
      self.from_level:SetText("Lv." .. level)
      self.to_level:SetText("Lv." .. level + 1)
      self.from_level:SetActive(true)
      self.arr_level:SetActive(true)
      self.to_level:SetActive(true)
    end
    self:UpdateLevelInfo(level, math.min(level + 1, maxLevel), maxLevel)
  end
end

function UILWSeasonMilitaryCenterLevel:UpdateLevelInfo(level, nextLevel, maxLevel)
  local mineInfoFrom = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_MUMMY_CENTER)
  local mineInfoTo = DataCenter.AllianceMineManager:GetAllianceMineTemplate(nextLevel + BuildingTypes.SEASON_MUMMY_CENTER)
  local dict = {}
  self.theItem:GameObjectRecycleAll()
  if mineInfoFrom and mineInfoTo then
    if self.theStoveCenter ~= nil and self.theStoveCenter.status ~= AllianceMineStatus.Build then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if level ~= maxLevel then
        self.res_icon1:SetActive(true)
        self.res_icon2:SetActive(true)
        self.from_res:SetText(string.GetFormattedStr(mineInfoFrom.total_stone_exp_value or 0))
        self.to_res:SetText(string.GetFormattedStr(mineInfoTo.total_stone_exp_value or 0))
        self.res_info:SetValue(math.min(1, allianceData.resStone / (mineInfoTo.total_stone_exp_value or 1)))
        self.res_info_num:SetText(string.GetFormattedSeparatorNum(allianceData.resStone) .. "/" .. string.GetFormattedSeparatorNum(mineInfoTo.total_stone_exp_value))
        self.desc:SetText("")
      else
        self.res_icon1:SetActive(true)
        self.res_icon2:SetActive(false)
        self.from_res:SetText(string.GetFormattedStr(mineInfoFrom.total_stone_exp_value or 0))
        self.res_info:SetValue(1)
        self.res_info_num:SetText(string.GetFormattedSeparatorNum(allianceData.resStone))
        self.desc:SetText("")
      end
    end
    if mineInfoFrom.coal_value_show and level ~= 0 and level ~= maxLevel then
      for item in string.gmatch(mineInfoFrom.coal_value_show, "([^|]+)|?") do
        local dialog, value, style = string.match(item, "([^;]+);([^;]+);([^;]+)")
        if dialog and value and style then
          local suffix
          if style == "1" then
            suffix = ""
            value = string.GetFormattedSeparatorNum(toInt(value))
          elseif style == "2" then
            suffix = "\194\176C"
          elseif style == "3" then
            suffix = "/min"
          elseif style == "4" then
            suffix = "%"
          elseif style == "5" then
            suffix = "/h"
          end
          if suffix ~= nil then
            dict[dialog] = {
              from = value .. suffix,
              to = nil
            }
          end
        end
      end
    end
    if mineInfoTo.coal_value_show then
      for item in string.gmatch(mineInfoTo.coal_value_show, "([^|]+)|?") do
        local dialog, value, style = string.match(item, "([^;]+);([^;]+);([^;]+)")
        if dialog and value and style then
          local suffix
          if style == "1" then
            suffix = ""
            value = string.GetFormattedSeparatorNum(toInt(value))
          elseif style == "2" then
            suffix = "\194\176C"
          elseif style == "3" then
            suffix = "/min"
          elseif style == "4" then
            suffix = "%"
          elseif style == "5" then
            suffix = "/h"
          end
          if suffix then
            if dict[dialog] then
              dict[dialog].to = value .. suffix
            else
              dict[dialog] = {
                to = value .. suffix
              }
            end
          end
        end
      end
    end
  end
  if dict then
    local goItem
    for k, v in pairs(dict) do
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      goItem.transform:Find("title"):GetComponent(UnityTextMeshProEx).text = Localization:GetString(k)
      local txtFrom = goItem.transform:Find("from"):GetComponent(UnityTextMeshProEx)
      local txtTo = goItem.transform:Find("to"):GetComponent(UnityTextMeshProEx)
      if level == 0 or level == maxLevel then
        goItem.transform:Find("arr").gameObject:SetActive(false)
        txtFrom.gameObject:SetActive(false)
        txtTo.text = v.from or v.to or ""
      else
        goItem.transform:Find("arr").gameObject:SetActive(true)
        txtFrom.gameObject:SetActive(true)
        txtFrom.text = v.from or ""
        txtTo.text = v.to or ""
      end
    end
  end
end

function UILWSeasonMilitaryCenterLevel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnAllianceResourceUpdate)
  self:AddUIListener(EventId.AllianceCenterUpdate, self.UpdateData)
end

function UILWSeasonMilitaryCenterLevel:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnAllianceResourceUpdate)
  self:RemoveUIListener(EventId.AllianceCenterUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryCenterLevel:OnAllianceResourceUpdate()
end

return UILWSeasonMilitaryCenterLevel
