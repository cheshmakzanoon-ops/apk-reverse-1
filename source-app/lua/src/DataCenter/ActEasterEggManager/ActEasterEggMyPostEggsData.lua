local ActEasterEggMyPostEggsData = BaseClass("ActEasterEggMyPostEggsData")
local ActEasterEggData = require("DataCenter.ActEasterEggManager.ActEasterEggData")

function ActEasterEggMyPostEggsData:__init()
  self:AddListener()
  self.activityId = 0
  self.todayPraiseNum = 0
  self.todayCommentNum = 0
  self.eggArr = {}
  self.curAnonymousName = ""
end

function ActEasterEggMyPostEggsData:__delete()
  self:RemoveListener()
  self.activityId = nil
  self.todayPraiseNum = nil
  self.todayCommentNum = nil
  self.eggArr = nil
  self.curAnonymousName = nil
end

function ActEasterEggMyPostEggsData:AddListener()
end

function ActEasterEggMyPostEggsData:RemoveListener()
end

function ActEasterEggMyPostEggsData:ParseMyPostEggInfo(eggInfo)
  self.activityId = eggInfo.activityId
  self.eggArr = {}
  local eggArr = eggInfo.eggArr
  for k, v in pairs(eggArr) do
    local eggData = ActEasterEggData.New()
    eggData:ParseEggInfo(v)
    table.insert(self.eggArr, eggData)
  end
  local curAnonymousStr = eggInfo.curAnonymousHead
  if not string.IsNullOrEmpty(curAnonymousStr) then
    local curAnonymousInfo = string.split(curAnonymousStr, ";")
    self.curAnonymousName = curAnonymousInfo[1]
  end
  self.todayPraiseNum = eggInfo.todayPraiseNum
  self.todayCommentNum = eggInfo.todayCommentNum
end

function ActEasterEggMyPostEggsData:DeletePostEggs(delArr)
  local deleteIndexList = {}
  for k, v in pairs(delArr) do
    for m, n in pairs(self.eggArr) do
      if v == n:GetId() then
        table.insert(deleteIndexList, m)
      end
    end
  end
  for i = #deleteIndexList, 1, -1 do
    table.remove(self.eggArr, deleteIndexList[i])
  end
end

function ActEasterEggMyPostEggsData:GetEggDataById(eggId)
  for k, v in pairs(self.eggArr) do
    if v:GetId() == eggId then
      return v
    end
  end
  return nil
end

return ActEasterEggMyPostEggsData
