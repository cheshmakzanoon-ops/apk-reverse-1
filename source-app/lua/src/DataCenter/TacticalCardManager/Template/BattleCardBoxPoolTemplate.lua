local BattleCardBoxPoolTemplate = BaseClass("BattleCardBoxPoolTemplate")

function BattleCardBoxPoolTemplate:__init()
  self.id = 0
  self.card_pool = ""
  self.card_pool_next = ""
  self.card_pool_server = ""
end

function BattleCardBoxPoolTemplate:__delete()
  self.id = nil
  self.card_pool = nil
  self.card_pool_next = nil
  self.card_pool_server = nil
end

function BattleCardBoxPoolTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.card_pool = rowData:getValue("card_pool") or ""
  self.card_pool_next = rowData:getValue("card_pool_next") or ""
  self.card_pool_server = rowData:getValue("card_pool_server") or ""
end

function BattleCardBoxPoolTemplate:GetCardPool()
  if self.cardPool ~= nil then
    return self.cardPool
  end
  self.cardPool = self.card_pool
  local serverId = LuaEntry.Player:GetSourceServerId()
  if not string.IsNullOrEmpty(self.card_pool_server) then
    local split1 = string.split(self.card_pool_server, "|")
    if split1 and #split1 == 2 and not string.IsNullOrEmpty(split1[2]) then
      local split2 = string.split(split1[2], "-")
      if split2 and #split2 == 2 then
        local serverIdMin = tonumber(split2[1])
        local serverIdMax = tonumber(split2[2])
        if serverId >= serverIdMin and serverId <= serverIdMax then
          self.cardPool = self.card_pool_next
          return self.cardPool
        end
      end
    end
  end
  return self.cardPool
end

return BattleCardBoxPoolTemplate
