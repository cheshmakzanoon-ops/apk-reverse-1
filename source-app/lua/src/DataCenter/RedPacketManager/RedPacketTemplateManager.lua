local RedPacketTemplateManager = BaseClass("RedPacketTemplateManager")
local RedPacketTemplate = require("DataCenter.RedPacketManager.RedPacketTemplate")

local function __init(self)
  self.templateDic = {}
  self.redPacketTypeDic = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDic = nil
  self.redPacketTypeDic = nil
end

function RedPacketTemplateManager:InitAllTemplate()
  local redPacketAppearance, item, tempItem
  LocalController:instance():visitTable(TableName.LW_Chat_Packet, function(id, lineData)
    if lineData ~= nil then
      item = RedPacketTemplate:New()
      item:InitData(lineData, redPacketAppearance)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
      tempItem = self.redPacketTypeDic[item.special_type]
      if (not tempItem or item.id < tempItem.id) and item.special_type then
        self.redPacketTypeDic[item.special_type] = item
      end
    end
  end)
end

function RedPacketTemplateManager:GetAllRedPackTemplate()
  return self.templateDic
end

function RedPacketTemplateManager:GetAllRedPackTypeTemp()
  return self.redPacketTypeDic
end

function RedPacketTemplateManager:GetTemplateByGoodsId(goodsId, isNotAstrict)
  if not goodsId then
    return
  end
  goodsId = tonumber(goodsId)
  for i, template in pairs(self.templateDic) do
    if template.goodsId == goodsId and (isNotAstrict or template:IsOpenRedPacket()) then
      return template
    end
  end
end

local function GetTemplate(self, id)
  local numId = tonumber(id)
  return self.templateDic[numId]
end

RedPacketTemplateManager.__init = __init
RedPacketTemplateManager.__delete = __delete
RedPacketTemplateManager.GetTemplate = GetTemplate
return RedPacketTemplateManager
