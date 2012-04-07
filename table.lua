require "lang"
require "func"

--Table and 'array' utils
local M = {}
local A = {}

-- Safely modify a metatable
function M.hook(tbl, key, hook)
  -- Index is a special case, as it can be either
  -- a table or a function.
  if key == 'index' or
     key == '__index' or
     key == 'proto' then
    M.index(tbl,hook)
  else
    local old = tbl[key]
    tbl[key] = function(...)
      local rt = hook(unpack(arg))
      if not rt then
        rt = old(unpack(arg))
      end
      return rt
    end
  end
end

function M.index(tbl, hook)
  
end
M.proto=M.index

function M.each(tbl, func)
  for k, v in pairs(tbl) do
    func(k, v)
  end
  return tbl
end

M.hook(_G,"index",function(a,b)
  error("Global '"..tostring(b).."' is undefined")
end)

M.hook(_G,"newindex",function(a,b)
  print("Global '"..tostring(b).."' created")
end)

M.shift = function(tbl)
  return table.remove(tbl,1)
end

expose(M,"table")
expose(M,"array")

