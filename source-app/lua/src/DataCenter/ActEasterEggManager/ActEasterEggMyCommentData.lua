local ActEasterEggMyCommentData = BaseClass("ActEasterEggMyCommentData")
local ActEasterEggCommentData = require("DataCenter.ActEasterEggManager.ActEasterEggCommentData")

function ActEasterEggMyCommentData:__init()
  self:AddListener()
  self.activityId = 0
  self.startIndex = 0
  self.endIndex = 0
  self.commentArr = {}
end

function ActEasterEggMyCommentData:__delete()
  self:RemoveListener()
  self.activityId = nil
  self.startIndex = nil
  self.endIndex = nil
  self.commentArr = nil
end

function ActEasterEggMyCommentData:AddListener()
end

function ActEasterEggMyCommentData:RemoveListener()
end

function ActEasterEggMyCommentData:ParseMyCommentInfo(eggInfo)
  if self.endIndex > eggInfo.startIndex then
    return
  end
  self.activityId = eggInfo.activityId
  self.startIndex = eggInfo.startIndex
  self.endIndex = eggInfo.endIndex
  local commentArr = eggInfo.commentArr
  for k, v in pairs(commentArr) do
    local eggCommentData = ActEasterEggCommentData.New()
    eggCommentData:ParseCommentData(v)
    table.insert(self.commentArr, eggCommentData)
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityGetMyCommentInfo)
end

function ActEasterEggMyCommentData:ClearData()
  self:AddListener()
  self.activityId = 0
  self.startIndex = 0
  self.endIndex = 0
  self.commentArr = {}
end

function ActEasterEggMyCommentData:DeleteMyCommentEggs(delArr)
  local deleteIndexList = {}
  for k, v in pairs(delArr) do
    for m, n in pairs(self.commentArr) do
      if tonumber(v) == n:GetId() then
        table.insert(deleteIndexList, m)
      end
    end
  end
  for i = #deleteIndexList, 1, -1 do
    table.remove(self.commentArr, deleteIndexList[i])
  end
end

return ActEasterEggMyCommentData
