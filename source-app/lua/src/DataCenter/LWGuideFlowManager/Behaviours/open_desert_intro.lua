local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "guideType"},
  {
    "string",
    "textureFormatPath"
  }
}

function behaviour:Begin()
  if string.IsNullOrEmpty(self.guideType) or string.IsNullOrEmpty(self.textureFormatPath) then
    self:LogError("guideType or textureFormatPath is empty")
    return
  end
  if not self.guideList then
    self.guideList = {}
    LocalController:instance():visitTable(TableName.Desert_Battle_Guide, function(id, lineData)
      local battle_type = lineData:getIntValue("battle_type")
      if battle_type == self.guideType then
        local big_pic = lineData:getValue("big_pic")
        local small_pic = lineData:getValue("small_pic_list")
        if not string.IsNullOrEmpty(big_pic) then
          big_pic = string.format(self.textureFormatPath, big_pic)
        end
        if not string.IsNullOrEmpty(small_pic) then
          small_pic = string.format(self.textureFormatPath, small_pic)
        end
        table.insert(self.guideList, {
          num = lineData:getIntValue("id"),
          tittle = lineData:getValue("tittle"),
          battle_type = lineData:getValue("battle_type"),
          big_pic = big_pic,
          small_pic = small_pic,
          desc = lineData:getValue("small_pic_desc_list")
        })
      end
    end)
    table.sort(self.guideList, function(a, b)
      return a.num < b.num
    end)
  end
  if #self.guideList > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, {anim = true}, self.guideList)
  end
  self.done = true
end

function behaviour:Clear()
  if self.closeWhenClear and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIDesertBattleDetail) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleDetail)
  end
end

return behaviour
