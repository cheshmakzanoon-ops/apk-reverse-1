local GoodsNumEffectItem = BaseClass("GoodsNumEffectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local eff_ui_up_txt_path = ""
local txt_path = "txt"
local image_path = "txt/Image"
local ActMonopolySkipBtnKeyStr = "ActMonopolySkipBtnKey"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.eff_ui_up_txt = self:AddComponent(UIBaseContainer, eff_ui_up_txt_path)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.image = self:AddComponent(UIImage, image_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.soundHandleList = {}
end

local function DataDestroy(self)
  if self.soundHandleList then
    for i = 1, #self.soundHandleList do
      DataCenter.LWSoundManager:StopSound(self.soundHandleList[i])
    end
    self.soundHandleList = nil
  end
end

local function SetData(self, data)
  self.data = data
  self.txt:SetText("+" .. data.addNum)
  local rewardType = RewardType.GOODS
  local pic = DataCenter.RewardManager:GetPicByType(rewardType, data.itemId)
  self.image:LoadSprite(pic)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.flyAniTime = curTime + 600
  self.flyAniIsPlay = false
end

local function Update100MS(self)
  if self.flyAniIsPlay == nil or self.flyAniIsPlay == true then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.flyAniTime then
    self.flyAniIsPlay = true
    self.eff_ui_up_txt:SetActive(false)
    local data = self.data
    local rewardType = RewardType.GOODS
    local pic = DataCenter.RewardManager:GetPicByType(rewardType, data.itemId)
    local flyNum = data.addNum
    flyNum = math.max(flyNum, 1)
    flyNum = math.min(flyNum, 10)
    local startPos = self.image:GetPosition()
    local endPos = data.endPos
    local flyTime = data.flyTime
    local model = "Assets/_Art/Effect/prefab/ui/Common/FlyGoods.prefab"
    
    local function callback()
      local isSkip = Setting:GetInt(ActMonopolySkipBtnKeyStr, 0)
      if 0 < isSkip then
        return
      end
      local handle = DataCenter.LWSoundManager:PlaySound(91108, false)
      if not table.IsNullOrEmpty(self.soundHandleList) then
        table.insert(self.soundHandleList, handle)
      end
    end
    
    local function initCallback()
      local isSkip = Setting:GetInt(ActMonopolySkipBtnKeyStr, 0)
      if 0 < isSkip then
        return
      end
      local handle = DataCenter.LWSoundManager:PlaySound(91107, false)
      if not table.IsNullOrEmpty(self.soundHandleList) then
        table.insert(self.soundHandleList, handle)
      end
    end
    
    UIUtil.DoFlyWithoutLogic(pic, flyNum, startPos, endPos, 100, 100, callback, model, -20, 20, 0.1, flyTime, initCallback)
  end
end

GoodsNumEffectItem.OnCreate = OnCreate
GoodsNumEffectItem.OnDestroy = OnDestroy
GoodsNumEffectItem.ComponentDefine = ComponentDefine
GoodsNumEffectItem.ComponentDestroy = ComponentDestroy
GoodsNumEffectItem.DataDefine = DataDefine
GoodsNumEffectItem.DataDestroy = DataDestroy
GoodsNumEffectItem.Update100MS = Update100MS
GoodsNumEffectItem.SetData = SetData
return GoodsNumEffectItem
