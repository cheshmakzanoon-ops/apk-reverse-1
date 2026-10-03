local DailyPackageTemplate = BaseClass("DailyPackageTemplate")

local function __init(self)
  self.id = 0
  self.packageItems = {}
  self.content_type = 0
  self.select_condition = ""
  self.pic_para1 = ""
  self.selectConditionHeroId = 0
  self.selectConditionStarId = 0
end

local function __delete(self)
  self.id = nil
  self.packageItems = nil
  self.content_type = nil
  self.select_condition = nil
  self.select_condition2 = nil
  self.pic_para1 = nil
  self.pic_para3 = nil
  self.pic_para2 = nil
  self.pic_para4 = nil
  self.selectConditionHeroId = nil
  self.selectConditionStarId = nil
  self.awakenConditionHeroId = nil
  self.awakenConditionStarId = nil
  self.posterPageRect = nil
  self.posterWindowRect = nil
  self.spinePageMaskRect = nil
  self.spineWindowMaskRect = nil
  self.spinePagePos = nil
  self.spineWindowPos = nil
  self.awaken_appearance = nil
end

local function InitLine(self, lineData)
  if not lineData then
    return
  end
  self.id = lineData.id
  local itemsStr = lineData.item or ""
  local packages = string.split(itemsStr, "|")
  for i, v in pairs(packages) do
    local arr2 = string.split(v, ";")
    if 3 <= #arr2 then
      local packageId = tonumber(arr2[#arr2])
      if packageId then
        self.packageItems[packageId] = {}
        for j = 1, #arr2 - 1, 2 do
          local itemId = tonumber(arr2[j])
          local itemNum = tonumber(arr2[j + 1])
          if itemId and itemNum then
            local data = {}
            data.itemId = itemId
            data.count = itemNum
            data.rewardType = RewardType.GOODS
            table.insert(self.packageItems[packageId], data)
          else
            break
          end
          if j + 2 <= #arr2 then
            break
          end
        end
      end
    end
  end
  self.content_type = lineData:getValue("content_type")
  self.select_condition = lineData:getValue("select_condition")
  self.select_condition2 = lineData:getValue("select_condition2")
  self.pic_para1 = lineData:getValue("pic_para1")
  self.pic_para2 = lineData:getValue("pic_para2")
  self.pic_para3 = lineData:getValue("pic_para3")
  self.pic_para4 = lineData:getValue("pic_para4")
  self.awaken_appearance = lineData:getValue("awaken_appearance")
  if self.pic_para3 then
    self.posterPageRect = self:GetRectParam(self.pic_para3[1])
    self.posterWindowRect = self:GetRectParam(self.pic_para3[2])
  end
  if self.content_type == DailyPackageType.HeroUniqueWeapon or self.content_type == DailyPackageType.HeroAwaken then
    if self.select_condition then
      self.selectConditionHeroId = self.select_condition[1]
      self.selectConditionStarId = self.select_condition[2]
    end
    if self.content_type == DailyPackageType.HeroAwaken and self.select_condition2 then
      self.awakenConditionHeroId = self.select_condition2[1]
      self.awakenConditionStarId = self.select_condition2[2]
    end
  end
  if self.pic_para4 then
    self.spinePageMaskRect = self:GetRectParam(self.pic_para4[1])
    self.spineWindowMaskRect = self:GetRectParam(self.pic_para4[2])
  end
  if self.pic_para2 then
    self.spinePagePos = self:GetRectParam(self.pic_para2[1])
    self.spineWindowPos = self:GetRectParam(self.pic_para2[2])
  end
end

local function GetRectParam(self, str)
  local param = {}
  
  local function toNumber(strParam)
    if not string.IsNullOrEmpty(strParam) then
      return tonumber(strParam)
    else
      return 0
    end
  end
  
  if not string.IsNullOrEmpty(str) then
    local splitStr = string.split(str, ";")
    param.x = toNumber(splitStr[1])
    param.y = toNumber(splitStr[2])
    param.width = toNumber(splitStr[3])
    param.height = toNumber(splitStr[4])
    param.scale = toNumber(splitStr[5])
  end
  return param
end

local function GetItemByPackageId(self, packageId)
  if self.packageItems[tonumber(packageId)] then
    return self.packageItems[tonumber(packageId)]
  end
  return nil
end

local function GetHeroId(self)
  if self.packageItems then
    for packageId, items in pairs(self.packageItems) do
      if not table.IsNullOrEmpty(items) then
        for i, v in pairs(items) do
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
          if itemTemplate and (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191) then
            return itemTemplate.para2
          end
        end
      end
    end
  end
  return nil
end

DailyPackageTemplate.__init = __init
DailyPackageTemplate.__delete = __delete
DailyPackageTemplate.InitLine = InitLine
DailyPackageTemplate.GetItemByPackageId = GetItemByPackageId
DailyPackageTemplate.GetHeroId = GetHeroId
DailyPackageTemplate.GetRectParam = GetRectParam
return DailyPackageTemplate
