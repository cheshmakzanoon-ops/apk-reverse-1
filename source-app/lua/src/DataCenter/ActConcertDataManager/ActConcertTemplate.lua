local ActConcertTemplate = BaseClass("ActConcertTemplate")

function ActConcertTemplate:__init()
  self.id = 0
  self.goods_id = ""
  self.status = ""
  self.bannerPicPath = ""
  self.bgPicPath = ""
  self.scrollPicPath = ""
  self.bubble_reward = ""
  self.title = ""
  self.emptyText = ""
  self.bubbleLimit = 0
  self.getText = ""
  self.detectEventId = ""
  self.share_cd = ""
end

function ActConcertTemplate:__delete()
  self.id = nil
  self.goods_id = nil
  self.status = nil
  self.bannerPicPath = nil
  self.bgPicPath = nil
  self.scrollPicPath = nil
  self.bubble_reward = nil
  self.title = nil
  self.emptyText = nil
  self.bubbleLimit = nil
  self.getText = nil
  self.detectEventId = nil
  self.share_cd = nil
end

function ActConcertTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.goods_id = row:getValue("goods_id") or ""
  self.status = row:getValue("status") or ""
  local list_bg = row:getValue("list_bg1") or ""
  local bgList = string.split(list_bg, ";")
  if table.length(bgList) == 3 then
    self.bannerPicPath = bgList[1] or ""
    self.bgPicPath = bgList[2] or ""
    self.scrollPicPath = bgList[3] or ""
  end
  self.bubble_reward = row:getValue("bubble_reward") or ""
  local textConfig = row:getValue("list_text1") or ""
  local textList = string.split(textConfig, ";")
  self.title = textList[1] or ""
  self.emptyText = textList[2] or ""
  self.getText = textList[3] or ""
  self.bubbleLimit = tonumber(row:getValue("bubble_limit")) or 0
  self.detectEventId = row:getValue("detect_event_id") or ""
  self.share_cd = tonumber(row:getValue("share_cd")) or 0
end

return ActConcertTemplate
