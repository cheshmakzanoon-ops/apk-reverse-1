local base = UIBaseContainer
local UIFireworkQueueItem = BaseClass("UIFireworkQueueItem", base)
local remainTimeTxt_path = "RemainTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.remainTimeTxt = self:AddComponent(UIText, remainTimeTxt_path)
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

local function ComponentDestroy(self)
  self.remainTimeTxt = nil
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIFireworkQueueItem:SetData(data)
  self.endTime = data.endTime
  self.playerHead:SetEnableClickShowInfo(true, true)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  self.playerHead:SetData(data.sendUid, data.pic, data.picVer, nil, headBgImg)
  self:UpdateRemainTimeTxt()
end

function UIFireworkQueueItem:UpdateRemainTimeTxt()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.remainTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
end

UIFireworkQueueItem.OnCreate = OnCreate
UIFireworkQueueItem.OnDestroy = OnDestroy
UIFireworkQueueItem.OnEnable = OnEnable
UIFireworkQueueItem.OnDisable = OnDisable
UIFireworkQueueItem.ComponentDefine = ComponentDefine
UIFireworkQueueItem.ComponentDestroy = ComponentDestroy
UIFireworkQueueItem.DataDefine = DataDefine
UIFireworkQueueItem.DataDestroy = DataDestroy
return UIFireworkQueueItem
