local UIActSlotMachineTipRateComp = BaseClass("UIActSlotMachineTipRateComp", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIActSlotMachineTipBoxRateItem = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipBoxRateItem")
local UIActSlotMachineTipRollRateItem = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipRollRateItem")
local contentBodyDefaultColor = Color.New(0.2549019607843137, 0.27450980392156865, 0.37254901960784315, 1.0)
local content_path = "ScrollView/Viewport/Content"
local box_rate_item_path = "ScrollView/Viewport/Content/boxRateContent/boxRateItem"
local box_rate_content_path = "ScrollView/Viewport/Content/boxRateContent/boxRateContent"
local type1_rate_content_path = "ScrollView/Viewport/Content/drawRateContent/type1RateContent"
local type2_rate_content_path = "ScrollView/Viewport/Content/drawRateContent/type2RateContent"
local type3_rate_content_path = "ScrollView/Viewport/Content/drawRateContent/type3RateContent"
local draw_rate_item_path = "ScrollView/Viewport/Content/drawRateContent/drawRateItem"
local type1_txt_path = "ScrollView/Viewport/Content/drawRateContent/type1Txt"
local type2_txt_path = "ScrollView/Viewport/Content/drawRateContent/type2Txt"
local type3_txt_path = "ScrollView/Viewport/Content/drawRateContent/type3Txt"
local tip_txt_path = "ScrollView/Viewport/Content/tipTxt"

function UIActSlotMachineTipRateComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineTipRateComp:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineTipRateComp:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.box_rate_item = self:AddComponent(UIBaseContainer, box_rate_item_path)
  self.box_rate_content = self:AddComponent(UIBaseContainer, box_rate_content_path)
  self.type1_rate_content = self:AddComponent(UIBaseContainer, type1_rate_content_path)
  self.type2_rate_content = self:AddComponent(UIBaseContainer, type2_rate_content_path)
  self.type3_rate_content = self:AddComponent(UIBaseContainer, type3_rate_content_path)
  self.draw_rate_item = self:AddComponent(UIImage, draw_rate_item_path)
  self.type1_txt = self:AddComponent(UITextMeshProUGUIEx, type1_txt_path)
  self.type2_txt = self:AddComponent(UITextMeshProUGUIEx, type2_txt_path)
  self.type3_txt = self:AddComponent(UITextMeshProUGUIEx, type3_txt_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.boxRateItemList = {}
  self.box_rate_item:SetActive(false)
  self.box_rate_item.gameObject:GameObjectCreatePool()
  self.drawRateItemList = {}
  self.draw_rate_item:SetActive(false)
  self.draw_rate_item.gameObject:GameObjectCreatePool()
end

function UIActSlotMachineTipRateComp:ComponentDestroy()
  self.content = nil
  self.box_rate_item = nil
  self.box_rate_content = nil
  self.type1_rate_content = nil
  self.type2_rate_content = nil
  self.type3_rate_content = nil
  self.draw_rate_item = nil
  self.type1_txt = nil
  self.type2_txt = nil
  self.type3_txt = nil
  self.tip_txt = nil
end

function UIActSlotMachineTipRateComp:DataDefine()
  self.param = nil
  self.boxRateData = nil
  self.rollRateData = nil
end

function UIActSlotMachineTipRateComp:DataDestroy()
  self.param = nil
  self.boxRateData = nil
  self.rollRateData = nil
end

function UIActSlotMachineTipRateComp:ClearContent()
  self.box_rate_content:RemoveComponents(UIActSlotMachineTipBoxRateItem)
  for _, v in ipairs(self.box_rate_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.box_rate_item.gameObject:GameObjectRecycleAll()
  self.boxRateItemList = {}
  self.type1_rate_content:RemoveComponents(UIActSlotMachineTipRollRateItem)
  for _, v in ipairs(self.type1_rate_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.type2_rate_content:RemoveComponents(UIActSlotMachineTipRollRateItem)
  for _, v in ipairs(self.type2_rate_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.type3_rate_content:RemoveComponents(UIActSlotMachineTipRollRateItem)
  for _, v in ipairs(self.type3_rate_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.draw_rate_item.gameObject:GameObjectRecycleAll()
  self.drawRateItemList = {}
end

function UIActSlotMachineTipRateComp:SetData(param)
  self:ClearContent()
  self.param = param
  local infoTemp = self.param.activityDetailData.infoTemp
  local groupid = infoTemp.groupid
  local eventid = infoTemp.eventid
  local pic_group = infoTemp.pic_group
  local dropshow = infoTemp.dropshow
  local boxTempDict = DataCenter.ActSlotMachineDataManager.boxTempDict[eventid]
  self.boxRateData = {}
  for k, v in pairs(boxTempDict) do
    table.insert(self.boxRateData, v)
  end
  table.sort(self.boxRateData, function(a, b)
    return a.id < b.id
  end)
  local boxTempDict = DataCenter.ActSlotMachineDataManager.boxTempDict[eventid]
  self.boxRateData = {}
  for k, v in pairs(boxTempDict) do
    table.insert(self.boxRateData, v)
  end
  table.sort(self.boxRateData, function(a, b)
    return a.id < b.id
  end)
  self.rollRateData = DataCenter.ActSlotMachineDataManager:GetGroupResultDataDict(groupid)
  self.content:SetAnchoredPositionXY(0, 0)
  local showNum = #self.boxRateData
  local boxTotalWeight = 0
  for i = 1, showNum do
    boxTotalWeight = boxTotalWeight + self.boxRateData[i].rate_show
  end
  if 0 < showNum then
    for i = 1, showNum do
      local showData = self.boxRateData[i]
      local item = self.box_rate_item.gameObject:GameObjectSpawn(self.box_rate_content.transform)
      item.name = i
      local obj = self.box_rate_content:AddComponent(UIActSlotMachineTipBoxRateItem, item.name)
      obj:SetActive(true)
      self.boxRateItemList[i] = obj
      obj:SetData(showData, boxTotalWeight)
    end
  end
  local type1ShowData = {}
  for _, type in ipairs(ActSlotResultGroupContain[ActSlotResultGroupoType.AllSame]) do
    if self.rollRateData[type] then
      table.insert(type1ShowData, self.rollRateData[type])
    end
  end
  showNum = #type1ShowData
  if 0 < showNum then
    for i = 1, showNum do
      local showData = type1ShowData[i]
      local item = self.draw_rate_item.gameObject:GameObjectSpawn(self.type1_rate_content.transform)
      item.name = i
      local obj = self.type1_rate_content:AddComponent(UIActSlotMachineTipRollRateItem, item.name)
      obj:SetActive(true)
      self.drawRateItemList[showData.type] = obj
      obj:SetData(showData, groupid, dropshow)
    end
  end
  local type2ShowData = {}
  for _, type in ipairs(ActSlotResultGroupContain[ActSlotResultGroupoType.DoubleSame]) do
    if self.rollRateData[type] then
      table.insert(type2ShowData, self.rollRateData[type])
    end
  end
  showNum = #type2ShowData
  if 0 < showNum then
    for i = 1, showNum do
      local showData = type2ShowData[i]
      local item = self.draw_rate_item.gameObject:GameObjectSpawn(self.type2_rate_content.transform)
      item.name = i
      local obj = self.type2_rate_content:AddComponent(UIActSlotMachineTipRollRateItem, item.name)
      obj:SetActive(true)
      self.drawRateItemList[showData.type] = obj
      obj:SetData(showData, groupid, dropshow)
    end
  end
  local type3ShowData = {}
  for _, type in ipairs(ActSlotResultGroupContain[ActSlotResultGroupoType.Diff]) do
    if self.rollRateData[type] then
      table.insert(type3ShowData, self.rollRateData[type])
    end
  end
  showNum = #type3ShowData
  if 0 < showNum then
    for i = 1, showNum do
      local showData = type3ShowData[i]
      local item = self.draw_rate_item.gameObject:GameObjectSpawn(self.type3_rate_content.transform)
      item.name = i
      local obj = self.type3_rate_content:AddComponent(UIActSlotMachineTipRollRateItem, item.name)
      obj:SetActive(true)
      self.drawRateItemList[showData.type] = obj
      obj:SetData(showData, groupid, dropshow)
    end
  end
end

function UIActSlotMachineTipRateComp:SetDefaultPacking()
  self.type1_txt:SetColor(contentBodyDefaultColor)
  self.type2_txt:SetColor(contentBodyDefaultColor)
  self.type3_txt:SetColor(contentBodyDefaultColor)
  self.tip_txt:SetColor(contentBodyDefaultColor)
end

function UIActSlotMachineTipRateComp:ModifyPanelPacking(targetColor)
  self.type1_txt:SetColor(targetColor)
  self.type2_txt:SetColor(targetColor)
  self.type3_txt:SetColor(targetColor)
  self.tip_txt:SetColor(targetColor)
end

return UIActSlotMachineTipRateComp
