local GoldBrickTemplateManager = BaseClass("GoldBrickTemplateManager")
local GoldBrickProductTemplate = require("DataCenter.GoldBrick.GoldBrickProductTemplate")
local CommonUtils = CS.CommonUtils
local SDKManager = CS.SDKManager

function GoldBrickTemplateManager:__init()
  self.goldBrickInfos = {}
  self.freeGoldBrickInfos = {}
  self.storeProducts = {}
  self.hasInitGoldBricks = false
  self.hasInitProducts = false
end

function GoldBrickTemplateManager:__delete()
  self.goldBrickInfos = nil
  self.freeGoldBrickInfos = nil
  self.storeProducts = nil
  self.hasInitGoldBricks = nil
  self.hasInitProducts = nil
end

function GoldBrickTemplateManager:InitGoldBrickInfos()
  if not self.hasInitGoldBricks then
    LocalController:instance():visitTable(TableName.GoldBrick_Amount, function(id, lineData)
      local productId = lineData.product_id
      if not string.IsNullOrEmpty(productId) then
        local goldbrick = tonumber(lineData.goldbrick) or 0
        if 0 < goldbrick then
          self.goldBrickInfos[productId] = goldbrick
        end
        self.freeGoldBrickInfos[productId] = tonumber(lineData.goldbrick_free) or 0
      end
    end)
    self.hasInitGoldBricks = true
  end
end

function GoldBrickTemplateManager:GetCostGoldBrick(productId)
  self:InitGoldBrickInfos()
  if self.goldBrickInfos[productId] then
    return self.goldBrickInfos[productId]
  end
  return IntMaxValue
end

function GoldBrickTemplateManager:GetFreeGoldBrick(productId)
  self:InitGoldBrickInfos()
  if self.freeGoldBrickInfos[productId] then
    return self.freeGoldBrickInfos[productId]
  end
  return 0
end

function GoldBrickTemplateManager:GetAllProductId()
  if not self.hasInitProducts then
    LocalController:instance():visitTable(TableName.Product_Init, function(id, lineData)
      local productId = lineData.product_id
      if not string.IsNullOrEmpty(productId) then
        local productStore = tonumber(lineData.store_type) or 0
        if 0 < productStore then
          if not self.storeProducts[productStore] then
            self.storeProducts[productStore] = {}
          end
          local storeP = self.storeProducts[productStore]
          storeP[#storeP + 1] = productId
        end
      end
    end)
    self.hasInitProducts = true
  end
  local allProductId = {}
  local storeType = 0
  if SDKManager.IS_UNITY_ANDROID() then
    storeType = 1
  elseif SDKManager.IS_UNITY_IPHONE() then
    storeType = 2
  end
  if self.storeProducts[storeType] then
    allProductId = self.storeProducts[storeType]
  end
  return allProductId
end

return GoldBrickTemplateManager
