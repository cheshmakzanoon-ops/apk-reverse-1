local ScratchOffRecordItem = BaseClass("ScratchOffRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local playerNameTxt_path = "HorizionalLayout/playerNameTxt"
local timeTxt_path = "timeTxt"
local lotteryTxt_path = "HorizionalLayout/lotteryTxt"

function ScratchOffRecordItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffRecordItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffRecordItem:DataDefine()
end

function ScratchOffRecordItem:DataDestroy()
end

function ScratchOffRecordItem:ComponentDefine()
  self.playerNameTxt = self:AddComponent(UIText, playerNameTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.lotteryTxt = self:AddComponent(UIText, lotteryTxt_path)
end

function ScratchOffRecordItem:ComponentDestroy()
end

function ScratchOffRecordItem:SetData(itemInfo)
  if itemInfo == nil then
    return
  end
  self.uid = tostring(itemInfo.uid)
  local name = itemInfo.playerName
  if self.uid ~= LuaEntry.Player.uid and itemInfo.serverId and itemInfo.serverId ~= 0 then
    name = string.format("[%s]%s", itemInfo.serverId, itemInfo.playerName)
  end
  self.playerNameTxt:SetText(name)
  local time = UITimeManager:GetInstance():TimeStampToTimeForServer(itemInfo.time)
  self.timeTxt:SetText(time)
  self.lotteryTxt:SetLocalText(2000704, itemInfo.lotteryRank, itemInfo.lottery)
end

return ScratchOffRecordItem
